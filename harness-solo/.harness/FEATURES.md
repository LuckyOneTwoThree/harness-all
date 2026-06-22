# FEATURES.md — 功能状态看板

> 动态状态跟踪（开发中更新）。
> 与 PROJECT.md 的分工：PROJECT.md 是静态定义（立项时写），本文件是动态状态（开发中更新）。
> 更新触发点：verify skill 通过后，将对应功能状态改为 done。

## 功能状态

| 编号 | 功能 | 优先级 | 状态 | 最后更新 | 说明 |
|------|------|--------|------|---------|------|
| F-001 | [功能名] | P1 | pending | | |

## 状态定义

- `pending` — 未开始
- `in_progress` — 开发中（对应 loops/specs/ 有 state.yaml）
- `review` — verify 通过，待 code-review
- `done` — 完全完成（code-review 通过）
- `blocked` — 被阻塞（说明原因）

## 更新规则

1. **开始开发**：状态改 `in_progress`，创建 `loops/specs/<feature>/`
2. **verify 通过**：状态改 `review`
3. **code-review 通过**：状态改 `done`
4. **session-end 批量更新**：扫描 `loops/specs/*/state.yaml` 中 status:done 的功能，批量同步到本文件
