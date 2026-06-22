---
name: interaction-design
description: Produces interaction design with state machine and motion parameters. Use when visual design is approved. Use for interaction design tasks in LOOP.
triggers:
  - 交互设计任务
  - LOOP 内 interaction-design 阶段
  - 视觉设计已批准
reads:
  - .harness/craft/common-rules.md
  - docs/visual/DESIGN_BRIEF.md
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/visual/
writes:
  - docs/interaction/
---

# Interaction Design

## Overview

交互设计产出，含状态机 + 动效参数。缺状态比多状态更让用户困惑。

## When to Use

- ✅ 交互设计任务
- ✅ LOOP 内 interaction-design 阶段
- ✅ 视觉设计已批准
- ❌ NOT for 视觉设计（用 visual-design skill）

## Process

### 1. 读取上下文

- `docs/visual/DESIGN_BRIEF.md`：需求
- `docs/design-system/DESIGN.md`：设计系统（第 4 段 Component Stylings）
- `docs/visual/<page>.md`：已批准的视觉设计

### 2. 定义组件状态

每个交互组件必须标注所有状态：

| 组件 | 必备状态 |
|------|---------|
| Button | default / hover / active / disabled / loading |
| Input | default / focus / filled / error / disabled |
| Card | default / hover / selected / pressed |
| Modal | closed / opening / open / closing |
| Dropdown | closed / opening / open / closing |
| Toast | entering / visible / exiting |

### 3. 定义状态转换

每个状态转换标注：
- 触发条件（用户动作/系统事件）
- 动效（时长 + 缓动 + 属性变化）
- 中断处理（能否被新触发打断）

示例：
```
Button: default → hover
  触发：mouseenter
  动效：150ms ease-out, background-color change
  中断：可被 mouseleave 打断

Button: hover → active
  触发：mousedown
  动效：80ms ease-out, transform: scale(0.98)
  中断：可被 mouseup 打断
```

### 4. 动效参数

| 交互类型 | 时长 | 缓动 |
|---------|------|------|
| 点击反馈 | 80-150ms | ease-out |
| 微交互 | 150-300ms | 原生缓动 |
| 页面过渡 | 200-400ms | ease-in-out |
| 加载动画 | 持续 | linear |

### 5. 键盘导航流程

- Tab 顺序 = 视觉顺序
- 焦点可见（ring token）
- 无键盘陷阱
- Esc 关闭 Modal/Dropdown

### 6. 手势支持（移动端）

- 触控目标 ≥44×44pt
- 单区域单手势
- 优先原生交互原语

### 7. 输出

写入 `docs/interaction/<page>.md`。

## 输出格式

```markdown
# Interaction Design: <Page Name>

## Component States

### Button
| State | Style | Trigger |
|-------|-------|---------|
| default | bg: primary, color: on-primary | - |
| hover | bg: primary-hover | mouseenter |
| active | transform: scale(0.98) | mousedown |
| disabled | opacity: 0.5, cursor: not-allowed | disabled prop |
| loading | spinner + disabled | loading prop |

## State Transitions

### Button: default → hover
- 触发：mouseenter
- 动效：150ms ease-out, background-color
- 中断：可被 mouseleave 打断

## Keyboard Navigation
1. Logo → Tab → Nav Item 1 → ... → UserMenu
2. Esc 关闭 Modal

## Motion Parameters
- 点击反馈：100ms ease-out
- 微交互：200ms ease-out
- 页面过渡：300ms ease-in-out
```

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "动效后面再加" | 动效是交互的一部分，不是装饰 |
| "状态太多用户会困惑" | 缺状态比多状态更让用户困惑 |
| "loading 态不重要" | 200ms 内无反馈用户会以为卡死 |
| "键盘导航没人用" | 可访问性是硬约束，不是可选 |

## Red Flags

- 组件缺少必备状态
- 动效时长超出 80-400ms 范围
- 未定义键盘导航
- 触控目标 <44pt

## Verification

- [ ] 每个交互组件标注所有必备状态（证据：状态表完整）
- [ ] 每个状态转换有动效参数（证据：时长+缓动+属性）
- [ ] 键盘导航流程已定义（证据：Tab 顺序 + Esc 行为）
- [ ] 触控目标 ≥44pt（证据：尺寸标注）
- [ ] 动效时长在 80-400ms 范围（证据：参数表）

## 与 LOOP 的关系

- 所属阶段：DESIGN
- 循环类型：interaction-design
- 最大迭代：5
- 每次迭代后由 verify 检查，verify 通过后由 design-lint 检查
- LOOP 退出后由 design-review 做 Five-Axis 审查
