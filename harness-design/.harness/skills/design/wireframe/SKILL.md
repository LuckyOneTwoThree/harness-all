---
name: wireframe
description: Produces low-fidelity wireframes for structure validation. Use before visual design. Use for prototype tasks in LOOP.
triggers:
  - 线框图任务
  - LOOP 内 wireframe 阶段
  - 视觉设计前需要验证结构
reads:
  - docs/visual/DESIGN_BRIEF.md
  - .harness/data/design/landing.csv
  - docs/design-system/DESIGN.md
writes:
  - docs/prototype/wireframe.md
---

# Wireframe

## Overview

低保真线框图，快速验证结构。黑白灰，不涉及视觉。先结构后视觉，避免在错误结构上做视觉设计。

## When to Use

- ✅ 线框图任务
- ✅ LOOP 内 wireframe 阶段
- ✅ 视觉设计前需要验证结构
- ❌ NOT for 高保真视觉设计（用 visual-design skill）

## Process

### 1. 读取上下文

- `docs/visual/DESIGN_BRIEF.md`：需求
- `.harness/data/design/landing.csv`：落地页结构模式（若适用）

### 2. 信息架构（IA）梳理

- 列出页面所有信息单元
- 按优先级排序（P0/P1/P2）
- 分组归类

### 3. 用户流程（user-flow）绘制

- 入口 → 关键步骤 → 出口
- 标注分支和异常路径

### 4. 低保真线框图

用 ASCII art 或 markdown 描述布局：

```
+----------------------------------+
| Logo          Nav     UserMenu   |
+----------------------------------+
|                                  |
|        Hero Title                |
|        Hero Subtitle             |
|        [Primary CTA]             |
|                                  |
+----------------------------------+
| Feature 1  | Feature 2 | Feature 3|
| [icon]     | [icon]    | [icon]   |
+----------------------------------+
| Footer Links    Copyright        |
+----------------------------------+
```

**约束**：
- 只用黑白灰（不涉及颜色）
- 不涉及字体选择
- 不涉及具体图片
- 标注信息优先级（P0/P1/P2）

### 5. 响应式结构

标注移动端/平板/桌面的结构差异：

```
移动端（375px）：单列堆叠
平板（768px）：双列
桌面（1280px）：三列
```

### 6. 输出

写入 `docs/prototype/wireframe.md`。

## 输出格式

```markdown
# Wireframe: <Page Name>

## Information Architecture

### P0（必须）
- Hero 标题
- 主 CTA

### P1（重要）
- 特性列表
- 社会证明

### P2（可选）
- 页脚链接

## User Flow

入口 → Hero → CTA → 注册页 → ...

## Wireframe

### 桌面（1280px）
<ASCII art>

### 平板（768px）
<ASCII art>

### 移动端（375px）
<ASCII art>
```

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "直接做高保真更快" | 在错误结构上做视觉设计是浪费时间 |
| "线框图太粗糙" | 线框图的目的就是快速验证结构，粗糙是优点 |
| "IA 不用梳理" | 没有 IA 的线框图是乱涂鸦 |

## Red Flags

- 线框图包含颜色/字体/图片
- 未标注信息优先级
- 未画响应式结构
- 跳过 IA 直接画线框

## Verification

- [ ] IA 已梳理（证据：P0/P1/P2 分组）
- [ ] user-flow 已绘制（证据：流程图）
- [ ] 线框图只有黑白灰（证据：无颜色/字体/图片）
- [ ] 响应式结构已标注（证据：375px/768px/1280px）
- [ ] 信息优先级已标注（证据：P0/P1/P2 标记）

## 与 LOOP 的关系

- 所属阶段：DESIGN
- 循环类型：wireframe
- 最大迭代：5
- 每次迭代后由 verify 检查，verify 通过后由 design-lint 检查
- LOOP 退出后由 design-review 做 Five-Axis 审查
