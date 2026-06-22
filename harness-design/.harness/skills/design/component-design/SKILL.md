---
name: component-design
description: Designs atomic components (Button/Input/Card/Modal) with state machines, variants, and composition rules. Use when DESIGN.md exists and component design is needed. Use for component design tasks in LOOP.
triggers:
  - 组件设计任务（Button/Input/Card/Modal 等）
  - LOOP 内 component 阶段
  - design-system-setup workflow
reads:
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - .harness/craft/anti-ai-slop.md
  - .harness/craft/common-rules.md
writes:
  - docs/design-system/components/
---

# Component Design

## Overview

原子组件设计，产出状态机 + 变体表 + 组合规则。聚焦"原子组件"本身，不涉及页面级布局（那是 visual-design 的职责）。

## When to Use

- ✅ 设计核心组件（Button/Input/Card/Modal/Toast/Dialog 等）
- ✅ LOOP 内 component 阶段
- ✅ DESIGN.md 和 tokens.json 已存在
- ❌ NOT for 页面级视觉设计（用 visual-design skill）
- ❌ NOT for 低保真线框图（用 wireframe skill）

## Process

### 1. 读取上下文

- `docs/design-system/DESIGN.md`：设计系统（10 段，特别是第 4 段 Component Stylings 和第 10 段 Semantic Vocabulary）
- `docs/design-system/tokens.json`：可用 token（color/spacing/radius/shadow/typography）
- `docs/visual/DESIGN_BRIEF.md`：需求上下文（若有）

### 2. 识别组件需求

从 DESIGN.md 第 10 段 Semantic Vocabulary 提取需要的组件清单：
- 基础组件：Button / Input / Select / Checkbox / Radio / Switch
- 容器组件：Card / Modal / Dialog / Drawer / Popover
- 反馈组件：Toast / Alert / Progress / Skeleton
- 导航组件：Tabs / Breadcrumb / Pagination

### 3. 设计单个组件

对每个组件，按以下结构产出：

```markdown
## Component: <Name>

### 描述
<1-2 句组件用途>

### Props
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| variant | 'primary' \| 'secondary' \| 'ghost' | 'primary' | 视觉变体 |
| size | 'sm' \| 'md' \| 'lg' | 'md' | 尺寸 |
| disabled | boolean | false | 是否禁用 |
| loading | boolean | false | 是否加载中 |

### States（状态机）
| State | 触发条件 | 视觉变化 | 动效 |
|-------|---------|---------|------|
| default | 初始 | token: button.primary | - |
| hover | 鼠标进入 | token: button.primary.hover | 80-150ms ease-out |
| active | 鼠标按下 | token: button.primary.active | 80ms ease-out |
| focus | 键盘聚焦 | outline: 2px token: focus.ring | 立即 |
| disabled | disabled=true | opacity: 0.5, cursor: not-allowed | - |
| loading | loading=true | 显示 Spinner, 文字隐藏 | 200ms ease-in-out |

### Variants（变体表）
| Variant | Color Token | Use Case |
|---------|------------|----------|
| primary | color.primary | 主操作（每屏最多 1 个） |
| secondary | color.secondary | 次要操作 |
| ghost | transparent | 第三级操作 / 工具栏 |

### Sizes（尺寸表）
| Size | Padding | Font Size | Min Height |
|------|---------|-----------|------------|
| sm | spacing.xs spacing.sm | text.sm | 32px |
| md | spacing.sm spacing.md | text.base | 40px |
| lg | spacing.md spacing.lg | text.lg | 48px |

### Composition Rules（组合规则）
- 与 Icon 组合：Icon 在左，间距 spacing.sm
- 与 Badge 组合：Badge 在右上角
- 与 Loading 组合：文字隐藏，Spinner 居中
- 禁止组合：Button 内嵌 Button

### Accessibility
- role: button
- keyboard: Enter/Space 触发
- focus visible: outline 2px
- aria-disabled: 当 disabled
```

### 4. Token 一致性检查

- 所有颜色必须来自 token（禁止硬编码 hex）
- 所有间距必须来自 spacing scale
- 所有圆角必须来自 radius scale
- 所有字号必须来自 type scale
- 所有阴影必须来自 elevation scale

### 5. 反 AI-slop 检查

逐条对照 `.harness/craft/anti-ai-slop.md`：
- [ ] 未使用统一圆角（rounded-2xl 全场）
- [ ] 未使用重阴影
- [ ] 未使用 Inter/Roboto/Arial 作为主字体
- [ ] 未使用 #6366f1 紫色

### 6. 触控目标检查

- 所有可点击元素 ≥44×44pt（iOS）/ 48×48dp（Android）
- 间距足够防止误触

### 7. 输出

写入 `docs/design-system/components/<ComponentName>.md`，每个组件一个文件。

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "组件状态后面再加" | 状态是组件的核心，不是装饰；缺状态的组件无法交付 |
| "变体太多用户会困惑" | 变体是设计系统的价值；用语义命名（primary/secondary/ghost）不会困惑 |
| "硬编码颜色更快" | 硬编码摧毁设计系统的一致性，lint 会拦截 |
| "组件可以自由组合" | 没有组合规则的组件会被滥用（如 Button 内嵌 Button） |
| "触控目标小一点没关系" | 44pt 是 WCAG 强制要求，小于此值无法通过 accessibility-audit |

## Red Flags

- 硬编码 hex 颜色（非 token）
- 缺少状态定义（少于 4 个状态）
- 缺少变体定义
- 缺少组合规则
- 触控目标 <44pt
- 使用统一圆角

## Verification

- [ ] 每个组件有 Props 表（证据：文件含 ### Props 章节）
- [ ] 每个组件有 States 表（≥4 个状态）（证据：文件含 ### States 章节）
- [ ] 每个组件有 Variants 表（证据：文件含 ### Variants 章节）
- [ ] 每个组件有 Sizes 表（证据：文件含 ### Sizes 章节）
- [ ] 每个组件有 Composition Rules（证据：文件含 ### Composition Rules 章节）
- [ ] 每个组件有 Accessibility 章节（证据：文件含 ### Accessibility 章节）
- [ ] 所有颜色来自 token（证据：Grep 组件文件无硬编码 hex）
- [ ] 触控目标 ≥44pt（证据：Sizes 表 Min Height ≥32px sm / ≥40px md）
- [ ] 反 AI-slop 检查全通过（证据：逐条对照清单 ✓）

## 与 LOOP 的关系

- 所属阶段：DESIGN
- 循环类型：component
- 最大迭代：5
- 每次迭代后由 verify 检查，verify 通过后由 design-lint 检查
- LOOP 退出后由 design-review 做 Five-Axis 审查
