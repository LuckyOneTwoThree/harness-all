---
name: deployment-pipeline
description: CI/CD 流水线编排与执行，消费 solo-to-ops 交接文档，编排构建-测试-部署全流程
triggers:
  - 收到 solo-to-ops.md 交接文档时
  - 用户要求"部署新版本"或"发布到 staging/production"
  - CI/CD 流水线失败需要排查时
  - 需要设计或修改部署流水线时
reads:
  - docs/handoff/solo-to-ops.md
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/deployment/
  - loops/specs/<task-name>/spec.md
  - loops/specs/<task-name>/state.yaml
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 3
operation_tier: propose
requires_approval: true
---

# Deployment Pipeline — CI/CD 流水线编排与执行

## 铁律

1. **不直接操作生产集群** —— 生产部署必须通过 GitOps PR + 人类 review，Agent 只生成 PR
2. **不跳过 solo-to-ops 契约** —— 没有交接文档不开始部署，字段缺失必须先补全
3. **不跳过回滚预案** —— 任何部署必须先定义回滚方案，否则 PLAN 阶段不通过
4. **不跳过环境隔离** —— 测试环境不准直连生产 DB，凭据必须物理隔离
5. **不在周五晚/节假日前发版** —— 除非用户显式确认"明知风险仍要发布"

## 流程

### 1. 消费交接文档

读取 `docs/handoff/solo-to-ops.md`，逐字段核对：
- 交付物版本（镜像 Tag / Commit Hash）✓
- 变更内容与影响面（高/中/低）✓
- 环境变量增删改清单 ✓
- 数据库迁移脚本及执行顺序 ✓
- 冒烟测试检查点 ✓
- 失败回滚方案 ✓

**字段缺失处理**：通过 AskUserQuestion 要求 solo 补全，不自行假设。

### 2. 部署前评估

```
## 部署前评估
- 目标环境: [staging/production]
- 影响面等级: [高/中/低]
- 包含 DB Migration: [是/否]
- 包含 Breaking Change: [是/否]
- 回滚方案: [镜像回退/SQL回滚/配置回滚]
- 部署窗口: [是否符合 OPS_STRATEGY.md 定义的窗口期]
- 前置依赖: [是否有未完成的依赖项]
```

### 3. 编排部署流水线

根据影响面选择流水线模板：

**低影响面**（配置变更/小功能）：
```
构建镜像 → 扫描漏洞(Trivy) → 推送仓库 → staging 部署 → 冒烟测试 → [人类审批] → production 滚动更新
```

**中影响面**（新功能/接口变更）：
```
构建镜像 → 扫描漏洞 → 推送仓库 → staging 部署 → 冒烟测试 → 集成测试
→ [人类审批] → production 灰度(5%→25%→100%) → 每阶段健康检查
```

**高影响面**（DB Migration/Breaking Change）：
```
备份 DB → 构建镜像 → 扫描漏洞 → 推送仓库 → staging 全量演练
→ [人类审批 + DBA 确认] → production 维护窗口部署 → Migration → 验证 → 灰度推进
```

### 4. 生成部署配置

- 生成/修改 K8s Manifest（Deployment/Service/ConfigMap）
- 生成 Helm values 或 Kustomize overlay
- 生成 GitOps PR 内容（ArgoCD Application / Flux Kustomization）
- 生成数据库 Migration 执行脚本

### 5. 执行部署（按环境分层）

**Staging 环境**：
- Agent 可直接执行白名单操作（apply/scale/restart）
- 执行后自动触发冒烟测试
- 失败自动回滚并通知

**Production 环境**：
- Agent 生成 GitOps PR，不直接 apply
- 通过 AskUserQuestion 请求人类 review
- 人类 merge 后由 ArgoCD/Flux 自动同步
- Agent 监控同步状态并执行验证

### 6. 部署后验证

调用 `deployment-verify` skill 执行：
- 健康检查（HTTP 200, readiness probe）
- 监控指标平稳（错误率/延迟/吞吐）
- 冒烟测试通过
- 日志无异常报错

### 7. 记录与归档

- 写入 `docs/deployment/<date>-<version>.md` 部署记录
- 更新 `loops/specs/<task>/state.yaml`
- 关键发现追加到 `memory/knowledge-base.md` 的部署记录库

## 禁止事项

- 不在没有 solo-to-ops.md 的情况下开始部署
- 不跳过 Trivy 漏洞扫描
- 不在生产环境直接 kubectl apply（必须走 GitOps PR）
- 不在部署过程中修改 RBAC / NetworkPolicy（需单独审批）
- 不隐瞒部署失败（失败必须记录并通知）
- 不删除旧版本镜像（保留至少 2 个历史版本用于回滚）

## 与 LOOP 的关系

**所属 LOOP 类型**：provision（最大迭代 3 次）

```
LOOP(provision):
  PLAN:        消费 solo-to-ops → 部署前评估 → 编排流水线 → 生成配置
  PROVISION:   staging 部署 / 生成 production GitOps PR
  VERIFY:      deployment-verify 执行健康检查+冒烟测试+监控验证
  通过? DONE : 回滚 → 分析原因 → 可修复回 PROVISION / 需重新规划回 PLAN
```

**stage 字段写入**：plan → provision → verify → rollback（如需）

## 操作分级

| 操作 | staging | production |
|------|---------|------------|
| 生成 Manifest/Helm values | ✅ Agent | ✅ Agent |
| 生成 GitOps PR | ✅ Agent | ✅ Agent |
| kubectl apply | ✅ Agent | ❌ 人类 merge PR |
| 数据库 Migration | ✅ Agent | ❌ 人类执行 |
| 镜像扫描 | ✅ Agent | ✅ Agent |
| 健康检查 | ✅ Agent | ✅ Agent |
| 回滚 | ✅ Agent 自动 | ⚠️ Agent 建议，人类确认 |
