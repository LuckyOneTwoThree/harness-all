# 交接：harness-design → harness-solo

> 生成时间：YYYY-MM-DD HH:MM
> 源框架：harness-design
> 目标框架：harness-solo

## 阶段总结

<本阶段做了什么，一句话概括。如：完成 V1 视觉设计 + 交互设计 + 组件映射，含 3 个核心页面>

## 设计系统资产

| 资产 | 路径 | 说明 |
|------|------|------|
| 设计系统 | docs/design-system/DESIGN.md | 色彩/字体/间距/阴影/圆角/断点（10 段标准格式） |
| 设计令牌（JSON） | docs/design-system/tokens.json | 机器可读的 token 定义 |
| 设计令牌（CSS） | docs/design-system/tokens.css | 工程直接消费的 CSS 变量 |
| 组件规格 | docs/interaction/component-spec.md | 组件 Props/States 表 |
| 组件映射 | docs/handoff/component-map.json | 设计组件 → 工程组件的显式映射 |

## 页面清单

| 页面 | 视觉稿 | 交互稿 | 线框图 |
|------|--------|--------|--------|
| <Home> | docs/visual/home.md | docs/interaction/home.md | - |
| <Login> | docs/visual/login.md | docs/interaction/login.md | - |

## 组件清单

<组件列表 + 状态 + 变体，详见 component-spec.md 和 component-map.json>

## 验收标准（AC-xxx）

> 以下 AC 直接沿用 harness-pm PRD 的 acceptance_criteria 编号，不重新编号。
> harness-solo 的 writing-plans skill 应将此处 AC-xxx 标记为"设计相关 AC"，在 spec.md 中保留原编号。
> 若设计阶段新增了设计专属验收点，使用 DAC-xxx 前缀（D = Design-derived），与工程 AC 区分。

- [ ] AC-001: <沿用 PRD 的可测试描述>
- [ ] AC-002: <沿用 PRD 的可测试描述>
- [ ] AC-003: <沿用 PRD 的可测试描述>
- [ ] DAC-001: <设计阶段新增的可测试描述，如"按钮 hover 态有 200ms 过渡动画">
- [ ] DAC-002: <设计阶段新增的可测试描述，如"首屏 LCP ≥ 2.5s">

## 交互流程

<关键流程描述，详见 docs/prototype/flow.md>

## 关键决策

| 决策 | 理由 | 影响范围 |
|------|------|---------|
| 选用组件库 X | 技术栈匹配 + 设计系统对齐 | 全项目 |
| 不做响应式 Y | 不在 MVP 范围 | 范围边界 |

## 注意事项

<工程实现需注意的点，如：>
- component-map.json 的 props Type 已按 TECH_STACK 匹配，工程直接消费即可
- 暗色模式 token 已在 tokens.json 定义，需在工程中实现切换逻辑
- 所有触控目标 ≥ 44px（可访问性硬约束）

## 未决事项

需 harness-solo 处理或与 harness-design 确认的问题：

- 待定 1: <问题描述>
- 待定 2: <问题描述>

## 建议下一步

harness-solo 应优先处理：

1. 运行 brainstorming skill，消费本文件 + component-map.json
2. 运行 writing-plans skill，将 AC-xxx + DAC-xxx 写入 spec.md
3. 运行 frontend-implementation skill，按 component-map.json 实现组件

## 风险提示

| 风险 | 等级 | 缓解措施 |
|------|------|---------|
| 技术栈与 component-map.json 不匹配 | 高/中/低 | <措施> |
| 设计稿与 PRD 验收标准偏差 | 高/中/低 | <措施> |

---

## 下游框架使用说明

harness-solo 的 brainstorming / writing-plans / frontend-implementation / verify skill 会自动检测本文件并读取 AC-xxx + DAC-xxx 清单和 component-map.json。
如未自动识别，可手动指向本文件路径让 Agent 读取。
