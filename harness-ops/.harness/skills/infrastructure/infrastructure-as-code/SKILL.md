---
name: infrastructure-as-code
description: Terraform/Ansible IaC 管理，生成/plan/apply 基础设施代码，plan 可自动 apply 需人类确认
triggers:
  - 需要创建/修改云资源时
  - 需要执行 terraform plan/apply 时
  - 基础设施漂移检测时
  - 用户要求"配置新环境"时
  - infrastructure-setup-workflow 触发时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - docs/infrastructure/
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/infrastructure/
  - loops/specs/<task-name>/spec.md
  - loops/specs/<task-name>/state.yaml
  - loops/specs/<task-name>/evidence.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 3
operation_tier: propose
requires_approval: true
---

# Infrastructure as Code — Terraform/Ansible IaC 管理

## 铁律

1. **IaC 必须先行** —— 拒绝 ClickOps，所有资源必须通过代码声明
2. **plan 可自动，apply 需确认** —— 生产环境 apply 必须人类审批
3. **state 文件是核心资产** —— 远程 backend + 加密 + 版本控制
4. **不硬编码凭据** —— 变量通过 tfvars/env 注入，不写明文
5. **destroy 是高危操作** —— 必须人类双重确认 + 资源白名单

## 流程

### 1. 评估 IaC 需求

读取 `OPS_STRATEGY.md` 了解架构拓扑和选型：
- 云厂商：AWS / GCP / Azure / 阿里云 / 腾讯云
- IaC 工具：Terraform / Pulumi / Crossplane
- 配置管理：Ansible / SaltStack

确定本次任务范围：
- 新建资源 / 修改现有资源 / 销毁资源
- 影响环境：dev / staging / production

### 2. 生成/修改 IaC 代码

#### Terraform 结构
```
infrastructure/
├── modules/                    # 可复用模块
│   ├── vpc/
│   ├── eks/
│   ├── rds/
│   └── alb/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars    # 不含敏感信息
│   ├── staging/
│   └── production/
└── shared/
    └── remote_state.tf         # S3 backend 配置
```

#### 生成原则
- 模块化：资源按职责分模块，不写大单体
- 版本固定：provider 显式指定版本（`version = "~> 4.0"`）
- 标签规范：所有资源打 `Environment` / `Project` / `ManagedBy` 标签
- 最小权限：IAM 策略遵循最小权限原则
- 加密默认：存储/传输默认加密

### 3. 执行 terraform plan（Agent 可自动）

```bash
# 初始化
terraform init -backend-config=backend.hcl

# 格式化与校验
terraform fmt -check -diff
terraform validate

# 计划（dry-run）
terraform plan -out=tfplan -input=false
```

**Agent 解析 plan 输出**：
- 识别创建/修改/销毁的资源
- 评估影响面
- 生成 plan 摘要供人类 review

```
## Terraform Plan 摘要
- 创建: 3 个资源（VPC, Subnet, IGW）
- 修改: 1 个资源（EKS 集群添加节点组）
- 销毁: 0 个资源
- 影响面: 中（新增资源，不影响现有）
- 预计耗时: 8 分钟
- 风险评估: 低
```

### 4. 执行 terraform apply（生产需人类确认）

**Staging 环境**：
- Agent 可直接执行 `terraform apply -auto-approve`
- 执行后验证资源创建成功

**Production 环境**：
- Agent 展示 plan 摘要
- 通过 AskUserQuestion 请求人类确认
- 人类确认后执行 `terraform apply`
- 执行后验证

**禁止操作**：
- `terraform destroy`（任何环境都需人类双重确认）
- `terraform force-unlock`（需人类确认）
- 修改 state 文件（需人类确认）

### 5. Ansible 配置管理（如需）

```yaml
# inventory.yml
all:
  hosts:
    prod-web-01:
      ansible_host: 10.0.1.10
  children:
    webservers:
      hosts:
        prod-web-01:
        prod-web-02:
    dbservers:
      hosts:
        prod-db-01:
```

```yaml
# playbook.yml
- name: Configure web servers
  hosts: webservers
  become: yes
  roles:
    - nginx
    - app-config
  vars:
    env: production
```

**执行**：
- `ansible-playbook -i inventory.yml playbook.yml --check`（dry-run）
- `ansible-playbook -i inventory.yml playbook.yml`（实际执行）

### 6. 漂移检测

定期执行：
```bash
terraform plan -detailed-exitcode
# exit code 0: 无漂移
# exit code 2: 有漂移（需处理）
```

发现漂移：
- 分析漂移原因（手动修改 / 外部系统变更）
- 决策：拉回 IaC / 更新 IaC 匹配实际
- 记录到知识库

### 7. 更新 IaC 资产库

`memory/knowledge-base.md` 的 IaC 资产库追加：
```
| 资源ID | 类型 | 环境 | 模块路径 | 创建日期 | 最后修改 |
|--------|------|------|---------|---------|---------|
| vpc-xxx | AWS VPC | production | environments/prod/main.tf | 2026-06-22 | 2026-06-22 |
```

## 禁止事项

- 不硬编码 AK/SK/密码到 .tf 文件
- 不在生产环境执行 terraform destroy（除非人类双重确认）
- 不使用 local state（必须远程 backend）
- 不跳过 terraform plan 直接 apply
- 不修改 .terraform/ 目录下的文件
- 不在不了解影响面的情况下 apply

## 与 LOOP 的关系

**所属 LOOP 类型**：provision

```
LOOP(provision):
  PLAN:       评估需求 → 生成/修改 IaC 代码
  PROVISION:  terraform plan → [人类确认] → terraform apply
  VERIFY:     验证资源创建成功 + 标签正确 + 加密生效
  通过? DONE : 分析原因 → 修复 IaC → 回到 PROVISION
```

## 操作分级

| 操作 | staging | production |
|------|---------|------------|
| terraform fmt/validate | Agent | Agent |
| terraform plan | Agent | Agent |
| terraform apply | Agent | 人类确认后 |
| terraform destroy | 人类确认 | 人类双重确认 |
| ansible --check | Agent | Agent |
| ansible-playbook | Agent | 人类确认后 |
