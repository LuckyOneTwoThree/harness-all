---
name: design-system-import
description: Imports design system from existing code configuration. Use when redesigning an existing project. Use when CSS/Tailwind/MUI config exists.
triggers:
  - 重设计已有项目
  - 存在 CSS/Tailwind/MUI 配置
  - 需要从代码抽取设计系统
reads:
  - tailwind.config.js
  - src/theme.ts
  - src/globals.css
writes:
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/design-system/tokens.css
---

# Design System Import

## Overview

从现有项目配置抽取设计系统。Chesterton's Fence：先理解原设计再决定是否重写。

## When to Use

- ✅ 重设计已有项目
- ✅ 存在 CSS/Tailwind/MUI 配置
- ✅ 需要从代码抽取设计系统
- ❌ NOT for 全新项目（用 design-system skill）

## Process

### 1. 检测项目技术栈

检查以下文件判断技术栈：
- `tailwind.config.js` / `tailwind.config.ts` → Tailwind
- `src/theme.ts` / `src/theme/theme.ts` → MUI
- `components.json` → shadcn/ui
- `src/globals.css` / `src/index.css` → 纯 CSS

### 2. 读取配置文件

根据技术栈读取对应配置：
- **Tailwind**：读取 theme.extend（colors/spacing/fontFamily/borderRadius/boxShadow）
- **MUI**：读取 createTheme 的 palette/typography/spacing
- **shadcn**：读取 CSS variables（--primary/--secondary/...）
- **纯 CSS**：读取 :root 的 CSS custom properties

### 3. 抽取 Token

抽取以下维度：
- 色彩（primary/secondary/accent/background/foreground/muted/border/destructive）
- 字体（heading/body/mono + Google Fonts 链接）
- 间距（spacing scale）
- 阴影（box-shadow）
- 圆角（border-radius）
- 断点（breakpoints）

### 4. 生成 DESIGN.md 10 段

基于抽取的 token 填充 DESIGN.md：
- 第 1-9 段：从 token 推导
- 第 10 段 Semantic Vocabulary：扫描现有组件代码，识别常见块（Header/Footer/Hero/Form/Empty State/Dialog/Error State/Loading State）

### 5. 生成 tokens.json + tokens.css

将抽取的 token 转换为 W3C 标准格式和 CSS custom properties。

### 6. 差异报告

生成 `docs/design-system/IMPORT_REPORT.md`，记录：
- 成功抽取的 token
- 无法识别的配置（需人工确认）
- 建议补充的 token（设计系统缺失项）

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "现有项目没有设计系统" | 代码里一定有隐式 token，抽取出来就是设计系统 |
| "直接重写更干净" | Chesterton's Fence：先理解原设计再决定是否重写 |
| "配置文件太乱没法抽取" | 分维度逐步抽取，先色彩后字体后间距 |

## Red Flags

- 未读取配置文件就凭空生成设计系统
- 抽取的 token 与原配置不一致
- 未生成差异报告

## Verification

- [ ] 技术栈已识别（证据：检测到配置文件）
- [ ] 配置文件已读取（证据：Read 命令执行记录）
- [ ] DESIGN.md 10 段已填充（证据：文件内容）
- [ ] tokens.json 与原配置一致（证据：对比配置文件值）
- [ ] IMPORT_REPORT.md 已生成（证据：文件存在）

## 与 LOOP 的关系

- 不在 LOOP 内运行（在 LOOP 前的设计系统导入阶段运行，用于 redesign workflow）
- 产出的 DESIGN.md + tokens.json + tokens.css 与 design-system skill 产出等价，供后续 LOOP 内 skill 读取
- 产出的 IMPORT_REPORT.md 供用户确认差异，决定是否进入 LOOP 重设计
