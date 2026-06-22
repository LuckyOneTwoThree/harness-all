# harness-ops

> 个人**运维与基础设施保障**框架 · harness 家族成员

## 定位

专注"护航与交付"——基础设施即代码(IaC)、自动化部署(CI/CD)、监控告警体系、容灾与应急响应。

产品研究/UI 设计/工程开发/运营增长由 harness 家族其他成员负责，通过 `docs/handoff/` 契约文档交接。

## 核心特性

- **SRE 四原则**：Stability-First / IaC / Observability / Automation
- **Loop 循环引擎**：PLAN → PROVISION/DEPLOY → VERIFY，支持 5 种循环类型（provision/incident/optimization/recovery/audit）
- **半自动化架构**：Agent 建议 + 人类审批 + GitOps 执行，生产环境通过 PR 间接操作
- **契约协作**：接收 `solo-to-ops.md`（工程交付），产出 `ops-to-pm.md`（SLA 报告 + 故障复盘）
- **安全红线**：Secret 严格隔离（Agent 不接触明文）、破坏性变更拦截、环境隔离
- **四类操作原语**：inspect（自动）/ propose（生成 PR）/ mutate-staging（Agent 执行）/ mutate-prod（人类审批）

## Skill 体系（8 模块 28 领域 skill + 4 meta = 32）

- **模块1 部署交付**（4）：deployment-pipeline / release-strategy / rollback / deployment-verify
- **模块2 基础设施**（4）：infrastructure-as-code / kubernetes-manifest / helm-management / gitops-sync
- **模块3 监控可观测**（4）：monitoring-setup / alerting-rules / log-analysis / dashboard-design
- **模块4 故障响应**（4）：incident-detection / root-cause-analysis / incident-mitigation / post-mortem
- **模块5 安全合规**（4）：secret-management / policy-as-code / security-scan / audit-review
- **模块6 容量成本**（3）：resource-right-sizing / cost-analysis / capacity-planning
- **模块7 容灾备份**（3）：backup-management / recovery-drill / disaster-recovery-plan
- **模块8 运维审查**（2）：ops-review / sla-report

## 工作流（7 个）

- **deployment-workflow** — 部署全流程：solo-to-ops → IaC plan → provision → verify → ops-to-pm
- **incident-response-workflow** — 故障全流程：detect → mitigate → verify → root-cause → post-mortem
- **infrastructure-setup-workflow** — 基础设施搭建：IaC → K8s → Helm → GitOps → verify
- **monitoring-deployment-workflow** — 监控部署：monitoring-setup → alerting → dashboard → verify
- **security-audit-workflow** — 安全审计：scan → policy → audit-review → 修复建议
- **disaster-recovery-workflow** — 容灾演练：backup → recovery-drill → 验证 → 报告
- **ops-review-workflow** — 运维回顾：sla + cost → ops-review → ops-to-pm

## 快速开始

```bash
# 1. 进入项目目录
cd your-project

# 2. 安装 harness-ops 框架
bash /path/to/harness-ops/install.sh

# 3. 按需填写 OPS_STRATEGY.md（基础设施战略）
# 4. 开始使用：Agent 启动时读取 AGENTS.md
```

## 目录结构

```
harness-ops/
├── AGENTS.md              # Agent 启动必读（唯一强制入口）
├── SOUL.md                # Agent 人格定义
├── constitution.md        # 项目宪法
├── install.sh             # 安装脚本
├── .harness/
│   ├── loops/LOOP.md      # 循环引擎定义（5 种循环类型）
│   ├── skills/            # 技能库（8 模块 28 领域 + 4 meta = 32）
│   │   ├── meta/          # 4 个元 skill
│   │   ├── deployment/    # 部署交付 skill（4个）
│   │   ├── infrastructure/# 基础设施 skill（4个）
│   │   ├── monitoring/    # 监控可观测 skill（4个）
│   │   ├── incident/      # 故障响应 skill（4个）
│   │   ├── security/      # 安全合规 skill（4个）
│   │   ├── capacity/      # 容量成本 skill（3个）
│   │   ├── recovery/      # 容灾备份 skill（3个）
│   │   ├── review/        # 运维审查 skill（2个）
│   │   └── workflows/     # 工作流（7个）
│   ├── rules/             # 安全规则与防护
│   ├── memory/            # 跨会话记忆（7 张知识库表）
│   └── templates/         # 项目模板
└── docs/
    ├── handoff/           # 跨框架交接文档
    ├── infrastructure/    # 基础设施架构与资产
    ├── monitoring/        # 监控大盘与告警规则
    ├── incident/          # 故障排查与工单记录
    └── deployment/        # 部署配置记录
```

## 自动化边界（核心设计）

| 操作类型 | staging | production |
|---------|---------|------------|
| inspect（get/describe/plan/scan） | Agent 全自动 | Agent 全自动 |
| propose（生成 Manifest/PR） | Agent | Agent |
| mutate（scale/rollback/restart） | Agent 直接执行 | GitOps PR + 人类 review |
| mutate 高风险（delete/RBAC） | 人类审批 | 人类双重确认 |
| Secret 值操作 | ❌ 禁止 | ❌ 禁止 |

## 与 harness 家族的关系

| 成员 | 职责 | 与 ops 的交接 |
|------|------|--------------|
| harness-pm | 产品研究/PRD | 接收 ops 的 SLA 报告 |
| harness-solo | 工程开发 | 产出 solo-to-ops.md 交给 ops 部署 |
| harness-design | UI/视觉设计 | 不直接交接 |
| harness-growth | 运营增长 | 不直接交接 |
| **harness-ops** | **运维与基础设施** | 产出 ops-to-pm.md 反馈生产状态 |

## 设计依据

详见 `../ARCHITECTURE.md` 第 2.1 节（框架家族定位）和第 4.2 节（契约流转矩阵）。
