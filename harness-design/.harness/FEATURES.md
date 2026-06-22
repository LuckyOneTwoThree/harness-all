# FEATURES.md — 设计任务状态看板

> 动态状态跟踪（设计中更新）。
> 与 DESIGN_BRIEF.md 的分工：DESIGN_BRIEF.md 是静态定义（立项时写），本文件是动态状态（设计中更新）。
> 更新触发点：verify skill 通过后，将对应设计任务状态改为 done。

## 设计任务状态

| 编号 | 设计任务/组件 | 优先级 | 状态 | 最后更新 | 说明 |
|------|--------------|--------|------|---------|------|
| D-001 | [设计任务名] | P1 | pending | | |

## 状态定义

- `pending` — 未开始
- `in_progress` — 设计中（对应 loops/specs/ 有 state.yaml）
- `review` — verify 通过，待 design-review
- `done` — 完全完成（design-review 通过）
- `blocked` — 被阻塞（说明原因）

## 更新规则

1. **开始设计**：状态改 `in_progress`，创建 `loops/specs/<task>/`
2. **verify 通过**：状态改 `review`
3. **design-review 通过**：状态改 `done`
4. **session-end 批量更新**：扫描 `loops/specs/*/state.yaml` 中 status:done 的任务，批量同步到本文件
