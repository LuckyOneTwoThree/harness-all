---
name: audit-review
description: 审计日志分析，K8s audit log/Git history/操作记录审查，识别异常行为
triggers:
  - 定期安全审计时
  - 疑似安全事件时
  - 合规检查时
  - 用户要求"审查操作记录"时
  - security-audit-workflow 触发时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<task-name>/evidence.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
operation_tier: inspect
requires_approval: false
---

# Audit Review — 审计日志分析

## 铁律

1. **审计是只读操作** —— 不修改任何日志，只分析
2. **异常必须有结论** —— 每个异常要么确认正常，要么标记风险
3. **审计覆盖全链路** —— K8s audit + Git history + Agent 操作记录
4. **不泄露审计内容** —— 审计报告可能含敏感信息，脱敏后归档

## 流程

### 1. K8s Audit Log 分析

#### 启用 K8s Audit（如未启用）
```yaml
# kube-apiserver 配置
--audit-policy-file=/etc/kubernetes/audit-policy.yaml
--audit-log-path=/var/log/kubernetes/audit.log
--audit-log-maxage=30
--audit-log-maxbackup=10
--audit-log-maxsize=100
```

#### Audit Policy
```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
# 记录所有 Secret 操作
- level: RequestResponse
  resources:
  - group: ""
    resources: ["secrets"]

# 记录所有写操作
- level: Request
  verbs: ["create", "update", "patch", "delete"]

# 记录认证失败
- level: Metadata
  verbs: ["get", "list", "watch"]
  omitStages: ["RequestReceived"]
```

#### 分析 Audit Log
```bash
# 查看最近的写操作
kubectl get events -n production --sort-by='.lastTimestamp'

# 查看 Secret 访问记录
grep "secrets" /var/log/kubernetes/audit.log | jq '. | select(.verb=="get")'

# 查看删除操作
grep '"delete"' /var/log/kubernetes/audit.log | jq '. | {user, resource, namespace, name}'

# 查看认证失败
grep '"401"' /var/log/kubernetes/audit.log | jq '. | {user, ip, time}'
```

#### 识别异常模式
```
## K8s Audit 异常检测

### 1. 异常 Secret 访问
- 用户: john.doe
- 操作: get secret db-credentials
- 频率: 1 小时内 50 次
- 风险: 可能的凭据窃取
- 建议: 调查用户行为

### 2. 非工作时间删除
- 时间: 2026-06-22 03:00 AM
- 操作: delete deployment payment-service
- 用户: unknown-service-account
- 风险: 可能的误操作或攻击
- 建议: 立即调查

### 3. 权限提升
- 用户: dev-user
- 操作: create clusterrolebinding
- 风险: 权限提升
- 建议: 审查是否授权
```

### 2. Git History 分析

```bash
# 查看最近的提交
git log --oneline --since="7 days ago"

# 查看敏感文件修改
git log --all --pretty=format:"%h %an %ad %s" -- docs/infrastructure/

# 查看 Secret 相关提交
git log -p --all -S "password" -- '*.yaml'
git log -p --all -S "api_key" -- '*.yaml'

# 查看强制推送
git reflog --all | grep "forced update"
```

#### 识别异常
```
## Git History 异常检测

### 1. 敏感文件修改
- 文件: infrastructure/terraform.tfvars
- 修改者: dev-user
- 时间: 2026-06-22
- 风险: 可能包含凭据变更
- 建议: review 变更内容

### 2. 非常规提交时间
- 提交者: contractor
- 时间: 周末凌晨
- 风险: 可能的未授权操作
- 建议: 确认是否授权

### 3. 历史中发现 Secret
- 文件: config.yaml
- 提交: abc123
- 内容: 包含明文 password
- 风险: Secret 泄露到 Git 历史
- 建议: 立即轮转 Secret + 清理历史
```

### 3. Agent 操作记录分析

读取 `loops/specs/*/iterations.log`：
- Agent 执行了哪些操作
- 是否有失败的操作
- 是否有 needs-human 状态的操作
- 是否有异常的迭代次数

```
## Agent 操作审计

### 统计
- 本周 Agent 操作: 45 次
- 成功: 40 次
- 失败: 3 次
- 需人类介入: 2 次

### 异常操作
1. INC-2026-06-20: 迭代 5 次未解决（超限）
   - 原因: 根因分析不充分
   - 建议: 升级到人类 SRE

2. DEP-2026-06-21: production 部署被人类拒绝
   - 原因: plan 摘要显示销毁资源
   - 建议: review IaC 代码
```

### 4. 生成审计报告

```
## 安全审计报告

### 审计范围
- 时间: 2026-06-15 ~ 2026-06-22
- K8s Audit Log: production 集群
- Git History: gitops-repo + infrastructure-repo
- Agent 操作: 所有 loops/specs/

### 发现汇总
| 类别 | 高风险 | 中风险 | 低风险 | 已处理 |
|------|--------|--------|--------|--------|
| K8s Audit | 2 | 5 | 8 | 3 |
| Git History | 1 | 3 | 5 | 2 |
| Agent 操作 | 0 | 2 | 4 | 1 |

### 高风险项（必须处理）
1. [K8s] 异常 Secret 访问（john.doe 50次/小时）
2. [K8s] 非工作时间删除（unknown SA）
3. [Git] 历史中发现明文 password

### 建议改进
1. 收紧 RBAC 策略
2. 启用 Secret 访问告警
3. 配置 Git push 签名验证
4. Agent 操作增加 rate limit
```

### 5. 更新知识库

`memory/knowledge-base.md` 追加：
```
| 审计日期 | 范围 | 高风险 | 中风险 | 处理状态 | 报告路径 |
|---------|------|--------|--------|---------|---------|
| 2026-06-22 | 全链路 | 3 | 10 | 处理中 | docs/security/audit-2026-06-22.md |
```

## 禁止事项

- 不修改任何审计日志（只读分析）
- 不在报告中暴露用户 PII（脱敏）
- 不跳过高风险项不报告
- 不独自处理高风险项（需人类确认）

## 与 LOOP 的关系

**所属 LOOP 类型**：audit

```
LOOP(audit):
  PLAN:       确定审计范围
  PROVISION:  收集日志（K8s/Git/Agent）
  VERIFY:     分析异常 + 生成报告
  通过? DONE : 处理风险项 → 重新验证
```
