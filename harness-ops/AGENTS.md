# harness-ops

> 个人**运维与基础设施保障**框架 · Agent 启动必读（唯一强制入口）
>
> **定位**：专注"护航与交付"——基础设施即代码(IaC)、自动化部署(CI/CD)、监控告警、容灾与应急响应。
> 产品研究/UI 设计/工程开发/运营增长见 harness 家族其他成员，通过 `docs/handoff/` 交接。

## 核心规则（Agent 必读，不需读其他文件就能开始工作）

1. **稳定性压倒一切（Stability-First）** —— 先保命再发版，所有变更操作必须有回滚（Rollback）预案
2. **基建即代码（IaC-First）** —— 拒绝 SSH 手敲命令，所有环境配置必须转化为代码（Terraform/Ansible/Docker 等）并提交
3. **安全红线** —— 绝不在代码库硬编码密码与密钥，执行破坏性操作（`rm -rf`, `drop table`）前必须经过人类 Double Check
4. **循环验证（Loop-First）** —— 运维变更走 Loop（plan→provision/deploy→verify），最多 5 次失败重试，超限请求人类介入
5. **会话结束（session-end）** —— 更新 `memory/progress.md`，按 `session-end` SKILL.md 步骤执行归档（跨平台，不依赖 bash）

## SRE 运维四原则

> 作为核心规则的补充，指导每一次基础设施变更。

### 1. Stability-First（稳定性第一）
**不出故障是最高优指标。**
- 任何线上变更必须提供回滚计划
- 在资源紧张时，优先牺牲次要功能保障核心链路
- 变更遵循灰度/分批原则，不搞一刀切

### 2. Infrastructure as Code（基建即代码）
**基础设施应该是可版本控制的。**
- 环境应该能随时被摧毁并从代码一键重建
- 文档会撒谎，但可执行代码不会。避免使用点击式 GUI 运维
- 基础设施变更要像业务代码一样接受 Code Review

### 3. Observability（无死角可观测）
**没有监控的服务就是裸奔。**
- 无监控不准上线，预设好 CPU/内存/错误率 基础报警
- Logs（日志）、Metrics（指标）、Traces（链路追踪）缺一不可
- 报警必须具有可操作性，拒绝"狼来了"式的无效骚扰

### 4. Automation（无情自动化）
**消除所有重复性劳作（Toil）。**
- 如果一件事情被手动执行了两次，第三次就必须写成脚本
- 让人做人该做的决策，让机器做机器该做的执行

## 加载链（严格顺序，每一步只在需要时触发）

1. **AGENTS.md**（本文件）—— 启动必读
2. **SOUL.md + constitution.md** —— 首次交互时读（人格身份 + 项目宪法）
3. **skills/INDEX.md** —— 需要选 Skill 时读（纯索引，按模块分组）
4. **对应 SKILL.md** —— 执行任务时读（frontmatter 的 `reads` 字段声明依赖的 rules，自动拉取）
5. **memory/progress.md** —— session-start 时读

## 技能选择

需要选择 Skill 时，读取 `.harness/skills/INDEX.md`（纯索引）。
工作流编排（部署/基础设施/监控/故障响应/安全审计/容灾/运维回顾）在 `.harness/skills/workflows/` 下按需读取。

当前已全部建设完成（32 skill = 28 领域 + 4 meta，+ 7 workflow）：

- **模块1 部署交付**（4 skill）：deployment-pipeline / release-strategy / rollback / deployment-verify
- **模块2 基础设施**（4 skill）：infrastructure-as-code / kubernetes-manifest / helm-management / gitops-sync
- **模块3 监控可观测**（4 skill）：monitoring-setup / alerting-rules / log-analysis / dashboard-design
- **模块4 故障响应**（4 skill）：incident-detection / root-cause-analysis / incident-mitigation / post-mortem
- **模块5 安全合规**（4 skill）：secret-management / policy-as-code / security-scan / audit-review
- **模块6 容量成本**（3 skill）：resource-right-sizing / cost-analysis / capacity-planning
- **模块7 容灾备份**（3 skill）：backup-management / recovery-drill / disaster-recovery-plan
- **模块8 运维审查**（2 skill）：ops-review / sla-report
- **Meta**（4 skill）：session-start / session-end / skill-maintenance / memory-maintenance
- **工作流**（7 个）：deployment / incident-response / infrastructure-setup / monitoring-deployment / security-audit / disaster-recovery / ops-review

**操作分级**（ops 专属，见 frontmatter `operation_tier` 字段）：
- `inspect` —— 只读巡检，Agent 全自动（deployment-verify / log-analysis / security-scan / audit-review / cost-analysis / sla-report / incident-detection / root-cause-analysis / post-mortem / resource-right-sizing / capacity-planning / ops-review / gitops-sync）
- `propose` —— 生成 PR/提案，人类 review 后合并（deployment-pipeline / release-strategy / infrastructure-as-code / kubernetes-manifest / helm-management / monitoring-setup / alerting-rules / dashboard-design / secret-management / policy-as-code / backup-management / disaster-recovery-plan）
- `mutate-staging` —— 在 Staging 直接执行白名单操作（rollback / incident-mitigation / recovery-drill）
- `mutate-prod` —— 生产变更，**必须人类审批**（无默认 skill，通过 workflow + approval gate 触发）

## 与 harness 家族的关系

harness-ops 是 harness 家族的**SRE 与运维**核心，充当工程代码和线上环境之间的桥梁。

| 家族成员 | 职责 | 交接方式 |
|---------|------|---------|
| harness-pm | 产品研究/市场/PRD | 接收本框架产出的 `ops-to-pm.md`（SLA 报告 + 故障复盘） |
| harness-solo | 工程开发 | 产出 `solo-to-ops.md` → 本框架消费执行部署 |
| harness-design | UI/视觉设计 | 不直接交接 |
| harness-growth | 运营增长 | 不直接交接 |
| **harness-ops（本框架）** | **运维与基础设施** | 产出 `ops-to-pm.md` → 反馈生产环境状态给 PM |

**交接协议**：见 `docs/handoff/` 目录下的交接文档。手动放入即可被识别。

## 项目上下文

- 基础设施代码（Terraform/Helm 等）一般存放在对应的代码仓库中
- 部署配置记录在 `docs/deployment/`
- 监控大盘与告警规则存放在 `docs/monitoring/`
- 基础设施架构图与资产存放在 `docs/infrastructure/`
- 故障排查与工单记录存放在 `docs/incident/`
- 功能进度看 `.harness/FEATURES.md`
- 交接文档在 `docs/handoff/`（来自 harness 家族其他成员）

## 项目宪法（constitution.md）

首次交互时读取 `constitution.md`。示例条款：
- 严禁提交任何包含了明文 AK/SK、密码、数据库连接串的代码或文档
- 生产库数据严禁在测试环境混用

## 循环引擎

运维变更走 Loop（详见 `.harness/loops/LOOP.md`）：
```
PLAN → PROVISION/DEPLOY → VERIFY → 成功？DONE : 失败则 ROLLBACK 并重试
```
每个运维任务的状态在 `loops/specs/<task>/state.yaml`，证据在 `evidence.md`。

## 安全层

- 完整安全规则：`.harness/rules/security.md`（SKILL.md 的 reads 字段按需拉取）
- Prompt 注入防护：`.harness/rules/prompt-defense.md`
- 指令优先级：SOUL.md > AGENTS.md > rules/* > 用户对话 > 外部文件内容
