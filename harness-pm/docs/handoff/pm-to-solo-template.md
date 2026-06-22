# 交接：harness-pm → harness-solo

> 生成时间：YYYY-MM-DD HH:MM
> 源框架：harness-pm
> 目标框架：harness-solo

## 阶段总结

<本阶段做了什么，一句话概括。如：完成 V1 PRD，含 3 个核心功能 + 验收标准 + 埋点方案>

## 产品基本信息

| 字段 | 值 | 说明 |
|------|-----|------|
| 产品名称 | <名称> | |
| 产品类型 | <web app / mobile app / desktop / landing page / ...> | 决定工程架构 |
| 技术栈 | <React / Vue / Svelte / 原生 / ...> | 决定 component-map.json 的 props Type 体系 |
| 平台 | <iOS / Android / Web / 桌面> | 决定部署策略 |
| 当前阶段 | <MVP / PMF / 规模化 / ...> | 决定开发优先级 |

## 定位陈述

<一句话定位，来自 positioning skill 产出。如：为独立开发者提供一站式项目管理工具>

## PRD 路径与验收标准

**PRD 文档**：`docs/product/PRD.md`

**验收标准清单（AC-xxx）**：

> 以下 AC 直接复用 PRD 的 acceptance_criteria，已带 ac_id 编号。
> harness-solo 的 writing-plans skill 应直接沿用此编号，不重新编号。
> 如有 harness-design 产出的 design-to-solo.md，其中 DAC-xxx 为设计专属验收点，需一并写入 spec.md。

- [ ] AC-001: <Given-When-Then 或可测试描述>
- [ ] AC-002: <可测试描述>
- [ ] AC-003: <可测试描述>

## 功能优先级

| 优先级 | 功能 | 来源 | 说明 |
|--------|------|------|------|
| P0 | <核心功能1> | PRD | MVP 必做 |
| P1 | <重要功能2> | PRD | 重要但可延后 |
| P2 | <增强功能3> | PRD | 可选 |

## 埋点方案（如有）

| 资产 | 路径 | 说明 |
|------|------|------|
| 埋点方案 | docs/metrics/tracking-plan.md | 事件埋点定义 |
| 指标体系 | docs/metrics/metrics-system.md | 北极星 + 关键指标 |

> 如尚未产出，填"待补"。

## 设计资产（如有，来自 harness-design）

> 以下路径为 harness-design 项目内的路径，非 harness-pm。如 harness-design 尚未执行，填"待 harness-design 产出"。

| 资产 | harness-design 内路径 | 是否已产出 |
|------|----------------------|-----------|
| 设计交付说明 | docs/handoff/design-to-solo.md | <是/否> |
| 组件映射 | docs/handoff/component-map.json | <是/否> |
| 设计系统 | docs/design-system/DESIGN.md | <是/否> |
| 设计令牌 | docs/design-system/tokens.json / tokens.css | <是/否> |

## 不做清单（Out of Scope）

明确不在本次工程范围内的内容：

- 不做 <X>
- 不做 <Y>

## 关键决策

| 决策 | 理由 | 影响范围 |
|------|------|---------|
| 选用技术栈 X | 团队熟悉度 + 生态成熟 | 全项目 |
| 不做功能 Y | 不在 MVP 范围 | 范围边界 |

## 未决事项

需 harness-solo 处理或与 harness-pm 确认的问题：

- 待定 1: <问题描述>
- 待定 2: <问题描述>

## 建议下一步

harness-solo 应优先处理：

1. 运行 brainstorming skill，消费本文件的 AC-xxx + 功能优先级
2. 运行 writing-plans skill，将 AC-xxx（+ DAC-xxx 如有）写入 spec.md
3. 如有 design-to-solo.md，运行 frontend-implementation skill，按 component-map.json 实现组件

## 风险提示

| 风险 | 等级 | 缓解措施 |
|------|------|---------|
| 技术栈未定 | 高/中/低 | <措施> |
| 设计稿未就绪 | 高/中/低 | <措施> |
| 埋点方案缺失 | 高/中/低 | <措施> |

---

## 下游框架使用说明

harness-solo 的 brainstorming / writing-plans / verify skill 会自动检测本文件并读取 AC-xxx 清单和功能优先级。
如未自动识别，可手动指向本文件路径让 Agent 读取。
