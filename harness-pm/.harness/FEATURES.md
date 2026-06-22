# FEATURES.md — 产品功能状态看板

> 动态状态跟踪（产品工作中更新）。
> 与 PRD.md 的分工：PRD.md 是静态定义（设计阶段写），本文件是动态状态（开发/上线中更新）。
> 更新触发点：verify skill 通过后，将对应功能状态改为 done。

## 功能状态

| 编号 | 功能 | 优先级 | 状态 | 最后更新 | 说明 |
|------|------|--------|------|---------|------|
| F-001 | [功能名] | P1 | pending | | |

## 状态定义

- `pending` — 未开始
- `in_progress` — 产品设计中（对应 loops/specs/ 有 state.yaml）
- `review` — 设计完成，待人类审批
- `approved` — 审批通过，可交接工程
- `developing` — 工程开发中（由 harness-solo 接管）
- `launched` — 已上线
- `blocked` — 被阻塞（说明原因）

## 更新规则

1. **开始产品设计**：状态改 `in_progress`，创建 `loops/specs/<task>/`
2. **设计完成**：状态改 `review`，等待人类审批
3. **审批通过**：状态改 `approved`，产出交接文档 `docs/handoff/pm-to-solo.md`
4. **工程开发中**：状态改 `developing`（由 harness-solo 反馈）
5. **上线**：状态改 `launched`
6. **session-end 批量更新**：扫描 `loops/specs/*/state.yaml` 中 status:done 的任务，批量同步到本文件
