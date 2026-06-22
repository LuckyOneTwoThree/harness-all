# 交接：<源框架> → <目标框架>

> 生成时间：YYYY-MM-DD HH:MM
> 源框架：<harness-pm / harness-design / harness-solo / ...>
> 目标框架：<harness-design / harness-solo / ...>

## 阶段总结

<本阶段做了什么，一句话概括>

## 产出物清单

| 产出物 | 路径 | 类型 | 说明 |
|--------|------|------|------|
| 设计需求 | docs/handoff/pm-to-design.md（本文件） | Markdown | 设计需求文档，含功能列表和验收标准 |
| Persona | docs/visual/persona.md | Markdown | 目标用户画像 |
| 设计系统 | docs/design-system/DESIGN.md | Markdown | 色彩/字体/间距/阴影/圆角/断点 |

> 注：harness-pm 产出的是本交接文档（含设计需求内容），不是 docs/visual/DESIGN_BRIEF.md。
> DESIGN_BRIEF.md 始终由 harness-design 的 design-brief skill 维护（从交接文档提取需求后写入）。

## 关键决策

| 决策 | 理由 | 影响范围 |
|------|------|---------|
| 选用设计风格 X | 品牌定位 + 用户偏好 | 全项目 |
| 不做功能 Y | 不在 MVP 范围 | 范围边界 |

## 验收标准（AC）

下游框架实现时必须满足的可验证条件：

- [ ] AC-001: <可验证的描述>
- [ ] AC-002: <可验证的描述>
- [ ] AC-003: <可验证的描述>

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
| 设计风险 X | 高/中/低 | <措施> |
| 依赖风险 Y | 高/中/低 | <措施> |

---

## 下游框架使用说明

下游框架的 design-brief skill 会自动检测本文件并读取。
如未自动识别，可手动指向本文件路径让 Agent 读取。
