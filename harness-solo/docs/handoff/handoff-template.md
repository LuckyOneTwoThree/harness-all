# 交接：<源框架> → <目标框架>

> 生成时间：YYYY-MM-DD HH:MM
> 源框架：<harness-pm / harness-design / harness-solo / ...>
> 目标框架：<harness-solo / harness-growth / ...>

## 阶段总结

<本阶段做了什么，一句话概括>

## 产出物清单

| 产出物 | 路径 | 类型 | 说明 |
|--------|------|------|------|
| PRD | docs/handoff/pm-to-solo.md（本文件） | Markdown | 产品需求文档，含功能列表和验收标准 |
| Persona | docs/product/persona.md | Markdown | 目标用户画像 |
| 路线图 | docs/product/roadmap.md | Markdown | 功能优先级和迭代计划 |

> 注：harness-pm 产出的是本交接文档（含 PRD 内容），不是 docs/product/PROJECT.md。
> PROJECT.md 始终由 harness-solo 的 brainstorming skill 维护（从交接文档提取需求后写入）。

## 关键决策

| 决策 | 理由 | 影响范围 |
|------|------|---------|
| 选用技术栈 X | 团队熟悉度 + 生态成熟度 | 全项目 |
| 不做功能 Y | 不在 MVP 范围 | 范围边界 |

## 验收标准（AC）

下游框架实现时必须满足的可测试条件：

- [ ] AC-001: <可测试的描述>
- [ ] AC-002: <可测试的描述>
- [ ] AC-003: <可测试的描述>

## 未决事项

需下游框架处理或与上游确认的问题：

- 待定 1: <问题描述>
- 待定 2: <问题描述>

## 建议下一步

下游框架应优先处理：

1. <任务 1>
2. <任务 2>
3. <任务 3>

## 风险提示

| 风险 | 等级 | 缓解措施 |
|------|------|---------|
| 技术风险 X | 高/中/低 | <措施> |
| 依赖风险 Y | 高/中/低 | <措施> |

---

## 下游框架使用说明

下游框架的 brainstorming skill 会自动检测本文件并读取。
如未自动识别，可手动指向本文件路径让 Agent 读取。
