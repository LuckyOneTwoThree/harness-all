---
name: visual-design
description: Produces visual design with anti-AI-slop checks and multiple variants. Use when DESIGN_BRIEF.md and DESIGN.md exist. Use for visual design tasks in LOOP.
triggers:
  - 视觉设计任务
  - LOOP 内 visual-design 阶段
reads:
  - .harness/craft/anti-ai-slop.md
  - .harness/craft/common-rules.md
  - .harness/craft/typography.md
  - .harness/craft/color.md
writes:
  - docs/visual/
---

# Visual Design

## Overview

视觉设计产出，含响应式 + 反 AI-slop + 多方案变体。每个间距值都在 spacing scale 上，每个颜色都来自 token。

## When to Use

- ✅ 视觉设计任务
- ✅ LOOP 内 visual-design 阶段
- ✅ DESIGN_BRIEF.md 和 DESIGN.md 已存在
- ❌ NOT for 低保真线框图（用 wireframe skill）

## Process

### 1. 读取上下文

- `docs/visual/DESIGN_BRIEF.md`：需求 + 审美方向 + Vibe Translation
- `docs/design-system/DESIGN.md`：设计系统（10 段）
- `docs/design-system/pages/<page>.md`：页面级覆盖（若存在）

### 2. 确认审美方向

从 DESIGN_BRIEF.md 的 Aesthetic Direction 读取用户选择的方向。

### 3. 配色方案

- 从设计系统选取颜色（禁止硬编码 hex）
- 检查对比度（正文 ≥4.5:1）
- accent 每屏最多 2 次

### 4. 字体选择

- 从设计系统选取字体（禁止 Inter/Roboto/Arial 作为主字体）
- 检查字号在 type scale 上

### 5. 布局设计

- 移动优先（375px 起步）
- 12 栅格
- 4/8dp 间距节奏

### 6. 视觉层次

- 每屏 1 个焦点
- 用字重/字号/颜色建立层级（不用标题下强调线）

### 7. 反 AI-slop 检查

逐条对照 `.harness/craft/anti-ai-slop.md`：
- [ ] 未使用 Inter/Roboto/Arial 作为主字体
- [ ] 未使用 #6366f1 紫色
- [ ] 未使用紫蓝渐变
- [ ] 未使用统一圆角（rounded-2xl 全场）
- [ ] 未使用 Lorem ipsum 占位文本
- [ ] 未使用过度居中
- [ ] 未使用标准卡片网格（忽略信息优先级）
- [ ] 未使用过度 padding
- [ ] 未使用重阴影
- [ ] 未使用标题下强调线

### 8. 多方案变体

产出 2-3 个视觉方案，同文件分隔：

```markdown
## 方案 A：<方向名>
<设计描述 + 标注>

## 方案 B：<方向名>
<设计描述 + 标注>

## 方案 C：<方向名>
<设计描述 + 标注>
```

### 9. 用户选择

呈现 2-3 个方案，让用户选择。用户选择后写入 `docs/visual/<page>.md`。

### 10. 响应式标注

每个方案标注：
- 移动端（375px）布局
- 平板（768px）布局
- 桌面（1280px）布局

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "Inter 是最安全的字体" | Inter 是 AI slop 的标志，用项目设计系统的字体 |
| "紫色渐变很好看" | #6366f1 是 AI 默认味，所有 app 长一样 |
| "统一圆角更简洁" | 最大圆角忽略真实设计的圆角层级 |
| "用户不会注意到 1px 偏差" | 累积偏差摧毁视觉层级 |
| "只出 1 个方案就行" | 多方案变体是设计探索的核心，至少 2 个 |

## Red Flags

- 硬编码 hex 颜色（非 token）
- 使用 Inter/Roboto/Arial 作为主字体
- 使用 #6366f1 或紫蓝渐变
- 只出 1 个方案
- 未标注响应式

## Verification

- [ ] 每个间距值都在 spacing scale 上（证据：对比 DESIGN.md）
- [ ] 每个颜色都来自设计系统 token（证据：Grep 设计稿无硬编码 hex）
- [ ] 对比度 ≥4.5:1（证据：手动计算或工具检查）
- [ ] 反 AI-slop 检查全通过（证据：逐条对照清单 ✓）
- [ ] 产出 2-3 个方案（证据：文件含 ## 方案 A/B/C）
- [ ] 响应式标注齐全（证据：375px/768px/1280px 都有）

## 与 LOOP 的关系

- 所属阶段：DESIGN
- 循环类型：visual-design
- 最大迭代：5
- 每次迭代后由 verify 检查，verify 通过后由 design-lint 检查
