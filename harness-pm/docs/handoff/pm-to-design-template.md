# 交接：harness-pm → harness-design

> 生成时间：YYYY-MM-DD HH:MM
> 源框架：harness-pm
> 目标框架：harness-design

## 阶段总结

<本阶段做了什么，一句话概括。如：完成 V1 PRD，含 3 个核心功能>

## 产品基本信息

| 字段 | 值 | 说明 |
|------|-----|------|
| 产品名称 | <名称> | |
| 产品类型 | <web app / mobile app / desktop / landing page / ...> | 决定设计范式 |
| 目标受众 | <受众描述> | 影响风格定位 |
| 技术栈 | <React / Vue / Svelte / 原生 / ...> | 决定 component-map.json 的 props Type 体系 |
| 平台 | <iOS / Android / Web / 桌面> | 决定响应式策略 |

## 定位陈述

<一句话定位，来自 positioning skill 产出。如：为独立开发者提供一站式项目管理工具>

## Persona

| Persona | 路径 | 关键特征 |
|---------|------|---------|
| 主用户 | docs/discovery/user-research.md（"用户画像"章节） | <一句话特征> |
| 次用户 | docs/discovery/user-research.md（"用户画像"章节） | <一句话特征> |

> Persona 数据存储在 user-research.md 的"用户画像"章节，如尚未产出，填"待补"并标注影响范围。

## PRD 路径与验收标准

**PRD 文档**：`docs/product/PRD.md`

**验收标准清单（AC-xxx）**：

> 以下 AC 直接复用 PRD 的 acceptance_criteria，已带 ac_id 编号。
> harness-design 的 design-brief skill 应直接沿用此编号，不重新编号。
> ⚠️ **警告**：PM 在此列出的 AC 仅限于描述【业务规则、数据流转、前置后置条件】。严禁包含具体的 UI 布局、颜色或排版指示。必须将视觉与交互的探索空间 100% 留给 harness-design。

- [ ] AC-001: <Given-When-Then 或可测试描述>
- [ ] AC-002: <可测试描述>
- [ ] AC-003: <可测试描述>

## 风格关键词

<3-5 个风格关键词，来自 positioning 或用户明确要求。如：极简 / 专业 / 可信赖 / 科技感>

> 如未明确，填"待 harness-design 的 design-brief skill 探索"。

## 不做清单（Out of Scope）

明确不在本次设计范围内的内容：

- 不做 <X>
- 不做 <Y>

## 已有设计系统资产（如有）

> 以下路径为 harness-design 项目内的路径（非 harness-pm），PM 仅标注是否已存在，由 harness-design 确认。

| 资产 | harness-design 内路径 | 是否已存在 |
|------|----------------------|-----------|
| 设计系统 | docs/design-system/DESIGN.md | <是/否/未知> |
| 设计令牌 | docs/design-system/tokens.json | <是/否/未知> |
| 组件库 | docs/design-system/components/ | <是/否/未知> |

> 如为全新项目，填"无"。如 PM 不确定，填"未知，由 harness-design 确认"。

## 关键决策

| 决策 | 理由 | 影响范围 |
|------|------|---------|
| 选用方案 X | 用户调研支撑 | 全项目 |
| 不做功能 Y | 不在 MVP 范围 | 范围边界 |

## 未决事项

需 harness-design 处理或与 harness-pm 确认的问题：

- 待定 1: <问题描述>
- 待定 2: <问题描述>

## 建议下一步

harness-design 应优先处理：

1. 运行 design-brief skill，消费本文件的 AC-xxx 和风格关键词
2. 运行 design-system-setup workflow，建立设计系统骨架
3. 运行 new-design workflow，进入 LOOP 产出设计稿

## 风险提示

| 风险 | 等级 | 缓解措施 |
|------|------|---------|
| 技术栈未定 | 高/中/低 | <措施> |
| Persona 缺失 | 高/中/低 | <措施> |

---

## 下游框架使用说明

harness-design 的 design-brief skill 会自动检测本文件并读取 AC-xxx 清单。
如未自动识别，可手动指向本文件路径让 Agent 读取。
