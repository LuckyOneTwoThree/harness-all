# FEATURES.md — 增长任务/实验状态看板

> 动态状态跟踪（运营中更新）。
> 与 GROWTH_STRATEGY.md 的分工：GROWTH_STRATEGY.md 是静态定义（立项时写），本文件是动态状态（运营中更新）。
> 更新触发点：measure skill 通过后，将对应实验状态改为 done。

## Skill 建设进度

| 模块 | 总数 | 已建 | 状态 |
|------|------|------|------|
| 元（meta） | 4 | 4 | ✅ 完成 |
| 模块1 增长策略 | 5 | 5 | ✅ 完成 |
| 模块2 增长实验 | 6 | 6 | ✅ 完成 |
| 模块3 内容营销 | 5 | 5 | ✅ 完成 |
| 模块4 SEO优化 | 5 | 5 | ✅ 完成 |
| 模块5 用户运营 | 5 | 5 | ✅ 完成 |
| 模块6 获客投放 | 3 | 3 | ✅ 完成 |
| 模块7 变现 | 3 | 3 | ✅ 完成 |
| 模块8 数据分析 | 3 | 3 | ✅ 完成 |
| 模块9 增长审查 | 1 | 1 | ✅ 完成 |
| **合计** | **40** | **40** | ✅ 全部完成 |

## Workflow 建设进度

| Workflow | 状态 |
|----------|------|
| growth-experiment-workflow | ✅ 已建设 |
| growth-review-workflow | ✅ 已建设 |
| content-marketing-workflow | ✅ 已建设 |
| seo-optimization-workflow | ✅ 已建设 |
| lifecycle-operations-workflow | ✅ 已建设 |
| growth-strategy-workflow | ✅ 已建设 |

## 实验/任务状态

| 编号 | 实验/任务 | 优先级 | 状态 | 最后更新 | 说明 |
|------|----------|--------|------|---------|------|
| G-001 | [实验/任务名] | P1 | pending | | |

## 状态定义

- `pending` — 未开始
- `in_progress` — 进行中（对应 loops/specs/ 有 state.yaml）
- `review` — measure 通过，待增长审查
- `done` — 完全完成（增长审查通过，结论已归档）
- `blocked` — 被阻塞（说明原因）

## 更新规则

1. **开始实验**：状态改 `in_progress`，创建 `loops/specs/<experiment>/`
2. **measure 通过**：状态改 `review`
3. **增长审查通过**：状态改 `done`，结论写入 knowledge-base.md
4. **session-end 批量更新**：扫描 `loops/specs/*/state.yaml` 中 status:done 的实验，批量同步到本文件
