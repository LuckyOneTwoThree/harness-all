---
name: design-handoff-spec
description: Produces engineering-consumable handoff with component-map.json. Use after design-review passes. Use for design-to-engineering delivery.
triggers:
  - 设计交付
  - design-review 通过后
  - 需要交接给工程
reads:
  - .harness/data/design/ux-guidelines.csv
  - .harness/craft/common-rules.md
  - docs/visual/
  - docs/interaction/
  - docs/prototype/
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/design-system/tokens.css
  - docs/design-system/components/
  - docs/handoff/pm-to-design.md
  - loops/specs/<task>/evidence.md
writes:
  - docs/handoff/design-to-solo.md
  - docs/handoff/component-map.json
  - docs/interaction/component-spec.md
  - docs/prototype/flow.md
---

# Design Handoff Spec

## Overview

工程可消费的结构化交付。把"设计到代码"从"魔法导出"变成"显式映射"，可审查、可版本控制、可测试。

## When to Use

- ✅ 设计交付
- ✅ design-review 通过后
- ✅ 需要交接给工程（harness-solo）
- ❌ NOT for 设计阶段（用 visual-design 等skill）

## Process

### 1. 汇总产出

读取已批准的设计产出：
- `docs/visual/<page>.md`：视觉设计
- `docs/interaction/<page>.md`：交互设计
- `docs/prototype/wireframe.md`：线框图
- `docs/design-system/DESIGN.md`：设计系统
- `docs/design-system/tokens.json`：token 定义
- `docs/handoff/pm-to-design.md`：PM 交接文档（沿用 AC-xxx 编号，不重新编号）

### 2. 生成 design-to-solo.md（人类可读完整说明）

> 完整模板见 `docs/handoff/design-to-solo-template.md`，以下为核心结构。

```markdown
# Design Handoff: <Project Name>

## 概述
<设计目标 + 范围>

## 设计系统
- DESIGN.md 路径：docs/design-system/DESIGN.md
- tokens.json 路径：docs/design-system/tokens.json
- tokens.css 路径：docs/design-system/tokens.css

## 页面清单
| 页面 | 视觉稿 | 交互稿 | 线框图 |
|------|--------|--------|--------|
| Home | docs/visual/home.md | docs/interaction/home.md | - |
| Login | docs/visual/login.md | docs/interaction/login.md | - |

## 组件清单
<组件列表 + 状态 + 变体>

## 验收标准（AC-xxx）
> 沿用 harness-pm PRD 的 acceptance_criteria 编号，不重新编号。
> 设计阶段新增的验收点使用 DAC-xxx 前缀（D = Design-derived）。

- [ ] AC-001: <沿用 PRD 的可测试描述>
- [ ] AC-002: <沿用 PRD 的可测试描述>
- [ ] DAC-001: <设计阶段新增的可测试描述>

## 交互流程
<关键流程描述>

## 注意事项
<工程实现需注意的点>
```

### 3. 生成 component-spec.md（组件规格）

写入 `docs/interaction/component-spec.md`：

```markdown
# Component Specification

## Button
### Props
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| variant | primary/secondary/ghost | primary | 视觉变体 |
| size | sm/md/lg | md | 尺寸 |
| disabled | boolean | false | 禁用态 |
| loading | boolean | false | 加载态 |

### States
| State | Style |
|-------|-------|
| default | bg: --color-primary |
| hover | bg: --color-primary-hover |
| active | transform: scale(0.98) |
| disabled | opacity: 0.5 |
| loading | spinner + disabled |
```

### 4. 生成 component-map.json（显式映射层）

**核心创新**（来自 Stitch）：设计组件 → 工程组件的显式映射，可版本控制。

**框架无关约束**：props 的 Type 声明必须与 `docs/visual/DESIGN_BRIEF.md` 中定义的 Tech Stack 匹配。
- React 项目 → `ReactNode` / `JSX.Element`
- Vue 项目 → `VNode` / `Slot`
- Svelte 项目 → `Snippet` / `Component`
- 原生/Web Components → `HTMLElement` / `Slot`
- 未明确技术栈 → 用中性抽象类型（`Slot` / `Component`），并在 notes 标注"待工程确认"

写入 `docs/handoff/component-map.json`：

```json
{
  "PrimaryButton": {
    "designToken": "button.primary",
    "engineeringComponent": "Button",
    "props": { "variant": "primary", "size": "md" },
    "states": ["default", "hover", "active", "disabled", "loading"],
    "notes": "主操作按钮，每屏最多 1 个"
  },
  "ProductCard": {
    "designToken": "card.product",
    "engineeringComponent": "Card",
    "props": { "variant": "product", "elevation": "sm" },
    "states": ["default", "hover", "selected"],
    "notes": "产品列表卡片，支持选中态"
  },
  "EmptyState": {
    "designToken": "empty-state",
    "engineeringComponent": "EmptyState",
    "props": {
      "illustration": "string",
      "title": "string",
      "description": "string",
      "action": "Slot"
    },
    "states": ["default"],
    "notes": "空状态组件，DESIGN.md 第 10 段定义。action 类型取决于 Tech Stack，见框架无关约束"
  }
}
```

### 5. 生成 flow.md（交互流程图）

写入 `docs/prototype/flow.md`，描述关键用户流程。

### 6. Pre-Delivery Checklist（交付前检查）

来自 UI UX Pro Max：

- [ ] 运行 UX 验证扫描（Grep ux-guidelines.csv 的 animation/accessibility/z-index/loading）
- [ ] 过一遍 Common Rules §1-§3（CRITICAL + HIGH 级别）
- [ ] 在 375px（小手机）和横屏下测试
- [ ] 开启 reduced-motion 验证
- [ ] 独立验证暗色模式对比度
- [ ] 确认所有触控目标 ≥44pt

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "markdown 交付够了" | 工程需要 component-map.json 做映射，不只是 markdown |
| "工程自己看设计稿就行" | 显式映射比魔法导出更可靠，可审查可测试 |
| "Pre-Delivery Checklist 太繁琐" | 6 项检查是交付质量的最低保障 |

## Red Flags

- 未生成 component-map.json
- component-map.json 缺少 states 字段
- component-map.json 的 props Type 与 DESIGN_BRIEF.md 的 Tech Stack 不匹配（如 Vue 项目用了 ReactNode）
- 未执行 Pre-Delivery Checklist
- 交付物路径与 AGENTS.md 约定不一致

## Verification

- [ ] design-to-solo.md 已生成（证据：文件存在）
- [ ] component-map.json 已生成（证据：JSON 合法 + 含 states 字段）
- [ ] component-spec.md 已生成（证据：文件含 Props/States 表）
- [ ] flow.md 已生成（证据：文件含关键流程）
- [ ] Pre-Delivery Checklist 全部 ✓（证据：6 项检查记录）

## 与 LOOP 的关系

- 不在 LOOP 内运行（在 LOOP 外门禁通过后的交付阶段运行）
- 读取 LOOP 产出的所有设计稿（docs/visual/ + docs/interaction/ + docs/prototype/）作为汇总输入
- 读取 LOOP 外门禁的通过证据（design-review + accessibility-audit 的 evidence.md）
- 产出的 component-map.json 是 Stitch 核心创新，供 harness-solo 工程实现阶段消费
