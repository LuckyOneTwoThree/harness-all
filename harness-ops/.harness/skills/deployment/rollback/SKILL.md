---
name: rollback
description: 回滚操作与验证，支持镜像回退/配置回退/数据库回滚，确保业务快速恢复
triggers:
  - 部署后健康检查失败时
  - 监控告警显示新版本异常时
  - 用户要求"回滚到上一版本"时
  - 灰度发布阶段健康门未通过时
  - incident-response 触发紧急回滚时
reads:
  - loops/specs/<task-name>/spec.md
  - loops/specs/<task-name>/state.yaml
  - docs/handoff/solo-to-ops.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<task-name>/state.yaml
  - loops/specs/<task-name>/evidence.md
  - loops/specs/<task-name>/iterations.log
  - docs/incident/
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: mutate-staging
requires_approval: true
---

# Rollback — 回滚操作与验证

## 铁律

1. **回滚优先于根因** —— 业务异常时先回滚恢复，再分析根因
2. **回滚必须可验证** —— 回滚后必须确认业务恢复，不是"回滚了就行"
3. **数据库回滚需谨慎** —— 含 Schema 变更的回滚必须 DBA 确认，可能不可逆
4. **回滚不等于失败** —— 回滚是正常的安全机制，必须记录但不应追责

## 流程

### 1. 确认回滚决策

回滚触发场景：
- **自动触发**：deployment-verify 健康检查失败、灰度健康门未通过
- **人工触发**：用户要求回滚、incident-response 决定回滚
- **监控触发**：错误率飙升、延迟恶化、业务指标下降

确认回滚范围：
```
## 回滚决策
- 触发原因: [健康检查失败/告警/人工]
- 回滚范围: [单个服务/多个服务/全量]
- 当前版本: [镜像 Tag / Commit]
- 目标版本: [上一稳定版本]
- 数据库状态: [是否需要 SQL 回滚]
- 影响评估: [回滚过程中业务影响]
```

### 2. 选择回滚策略

#### 镜像回退（最常见）
- 适用：代码变更导致的异常
- 方式：修改 Deployment image tag 为上一版本
- 时效：K8s 滚动更新，约 1-5 分钟
- 生产环境：生成 GitOps PR，人类 merge 后同步

#### 配置回退
- 适用：ConfigMap/Secret 变更导致的异常
- 方式：revert ConfigMap 到上一版本
- 时效：秒级（Pod 重启后生效）

#### 数据库回滚（高风险）
- 适用：Migration 导致的数据问题
- 前置条件：solo-to-ops.md 提供了 `db_revert_v*.sql`
- 流程：
  ```
  [人类 DBA 确认] → 执行回滚 SQL → 验证数据一致性 → 回滚镜像
  ```
- **警告**：不可逆的 Migration（如 DROP COLUMN）无法回滚，只能前进修复

#### 流量切回（蓝绿部署）
- 适用：蓝绿部署模式
- 方式：流量切回 Blue 环境
- 时效：秒级

#### GitOps Revert
- 适用：通过 GitOps 部署的所有变更
- 方式：`git revert <commit>` + merge
- 优势：可追溯，自动触发 ArgoCD/Flux 同步

### 3. 执行回滚

**Staging 环境**：
- Agent 直接执行回滚（kubectl set image / helm rollback）
- 记录回滚操作到 iterations.log

**Production 环境**：
- Agent 生成 GitOps revert PR
- 通过 AskUserQuestion 请求人类确认
- 紧急情况：Agent 建议，人类口头确认后 Agent 执行 kubectl rollout undo
- 记录回滚操作到 iterations.log

### 4. 验证回滚效果

调用 `deployment-verify` skill：
- 健康检查恢复 ✓
- 错误率下降到正常水平 ✓
- 业务指标恢复 ✓
- 监控告警消除 ✓

### 5. 记录与归档

```
## 回滚记录
- 时间: [ISO 8601]
- 任务: [task-name]
- 触发原因: [详细描述]
- 回滚策略: [镜像/配置/DB/流量]
- 回滚前版本: [v1.2.3]
- 回滚后版本: [v1.2.2]
- 验证结果: [健康检查通过/业务指标恢复]
- 耗时: [从决策到恢复的总时长]
- 根因初判: [待分析 / 已定位]
```

写入：
- `loops/specs/<task>/evidence.md` — 回滚证据
- `loops/specs/<task>/iterations.log` — 追加回滚记录
- `docs/incident/<date>-rollback.md` — 如涉及生产故障
- `memory/knowledge-base.md` — 故障库追加一行

## 禁止事项

- 不在未确认影响范围的情况下盲目回滚
- 不跳过数据库回滚的 DBA 确认
- 不回滚后不验证（必须确认业务恢复）
- 不隐瞒回滚事件（必须记录并通知）
- 不在回滚过程中同时修复 bug（先恢复，再修复）

## 与 LOOP 的关系

**所属 LOOP 类型**：provision（作为 VERIFY 失败后的 rollback 阶段）

```
LOOP(provision):
  PLAN → PROVISION → VERIFY
    ↓ 失败
  ROLLBACK → 验证回滚
    ↓ 恢复
  分析根因 → 可修复回 PROVISION / 需重新规划回 PLAN
```

**stage 字段写入**：rollback

**状态写入**：
- 回滚中：status=retrying, stage=rollback
- 回滚成功：status=running（回到 PLAN 重新规划）或 status=done（如放弃本次发布）
- 回滚失败：status=needs-human（请求人类介入）
