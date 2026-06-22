---
name: design-system
description: Creates a design system with DESIGN.md 10-section standard and token exports. Use when no design system exists. Use after design-recommendation.
triggers:
  - 创建设计系统
  - 无 DESIGN.md
  - design-recommendation 完成后
reads:
  - .harness/craft/anti-ai-slop.md
  - .harness/craft/typography.md
  - .harness/craft/color.md
writes:
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/design-system/tokens.css
  - docs/design-system/pages/
---

# Design System

## Overview

创建 DESIGN.md 10 段标准 + token 导出（md + json + css）。设计系统是单一事实源，所有设计稿必须遵循。

## When to Use

- ✅ 创建设计系统
- ✅ 无 DESIGN.md
- ✅ design-recommendation 完成后
- ❌ NOT for 已有 DESIGN.md 且无需变更

## Process

### 1. 检查 RECOMMENDATION.md

若 `docs/design-system/RECOMMENDATION.md` 存在，作为基础。

### 2. 确认设计系统范围

- 色彩系统（primary/secondary/accent/background/foreground/muted/border/destructive）
- 字体系统（heading/body/mono，含 Google Fonts 链接）
- 间距系统（4px base，常用阶梯）
- 阴影系统
- 圆角系统
- 断点系统

### 3. 填充 DESIGN.md 10 段

参考 craft/typography.md 和 craft/color.md。

#### 第 1-9 段（标准）

1. Visual Theme & Atmosphere
2. Color Palette & Roles
3. Typography Rules
4. Component Stylings
5. Layout Principles
6. Depth & Elevation
7. Do's and Don'ts
8. Responsive Behavior
9. Agent Prompt Guide

#### 第 10 段：Semantic Vocabulary（固定模板）

必须包含以下常见块（若项目无对应场景，标注"不适用"）：

```markdown
## 10. Semantic Vocabulary

### Header
- 组件组合：Logo + Navigation + UserMenu
- 用途：全局导航

### Footer
- 组件组合：FooterLink + FooterSection + Copyright
- 用途：页脚信息

### Hero
- 组件组合：HeroTitle + HeroSubtitle + HeroCTA + HeroImage
- 用途：首屏主视觉

### Form
- 组件组合：FormField + Label + Input + ErrorMessage + SubmitButton
- 用途：表单输入

### Empty State
- 组件组合：EmptyIllustration + EmptyTitle + EmptyDescription + PrimaryAction
- 用途：无数据时展示

### Dialog
- 组件组合：Modal + DialogTitle + DialogBody + ButtonGroup(primary+secondary)
- 用途：确认/弹窗

### Error State
- 组件组合：ErrorIcon + ErrorTitle + ErrorDescription + RetryAction
- 用途：错误提示

### Loading State
- 组件组合：Skeleton | Spinner + LoadingText
- 用途：加载中
```

### 4. Token 导出

#### tokens.json（W3C 标准格式）

```json
{
  "color": {
    "primary": { "$value": "#3b82f6", "$description": "主色" },
    "on-primary": { "$value": "#ffffff" }
  },
  "spacing": {
    "sm": { "$value": "0.5rem" },
    "md": { "$value": "1rem" }
  }
}
```

#### tokens.css（CSS custom properties）

```css
:root {
  --color-primary: #3b82f6;
  --color-on-primary: #ffffff;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
}
```

### 5. Master + Overrides 初始化

创建 `docs/design-system/pages/` 目录，用于页面级覆盖。

检索规则（供后续 skill 使用）：
1. 先检查 `docs/design-system/pages/<page>.md` 是否存在
2. 若存在 → 其规则覆盖 MASTER.md（DESIGN.md）
3. 若不存在 → 仅使用 MASTER.md

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "设计系统太重，先画页面吧" | 没有设计系统的页面是一盘散沙 |
| "token 表格够了" | 工程需要 json/css，不只是 markdown |
| "Semantic Vocabulary 太细" | 固定模板有 7 个常见块，颗粒度刚好 |
| "Semantic Vocabulary 让我自由发挥" | 固定模板保证下游可消费，自由发挥会导致映射断裂 |

## Red Flags

- 跳过第 10 段 Semantic Vocabulary
- Semantic Vocabulary 未用固定模板
- token 只输出 markdown，无 json/css
- 未创建 pages/ 目录

## Verification

- [ ] DESIGN.md 包含 10 段（证据：文件内容）
- [ ] 第 10 段 Semantic Vocabulary 包含 7 个常见块（证据：文件内容）
- [ ] tokens.json 符合 W3C 格式（证据：JSON 结构含 $value 字段）
- [ ] tokens.css 包含 CSS custom properties（证据：文件含 --color-* 变量）
- [ ] pages/ 目录已创建（证据：Glob 确认目录存在）

## 与 LOOP 的关系

- 不在 LOOP 内运行（在 LOOP 前的设计系统建设阶段运行）
- 产出的 DESIGN.md + tokens.json + tokens.css 供所有 LOOP 内 skill 读取（visual-design / interaction-design / wireframe / component-design / verify / design-lint）
- 产出的第 10 段 Semantic Vocabulary 供 component-design skill 识别组件清单
- 产出的 token 供 design-lint 的 L001-L005 规则检查一致性
- 产出的 pages/ 目录供 visual-design skill 检索页面级覆盖
