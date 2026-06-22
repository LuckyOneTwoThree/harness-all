---
name: design-system-refactor
description: Scans design system and suggests merges/abstractions/tokenization. Use when design system has accumulated redundancy. Use for design system evolution.
triggers:
  - 设计系统有冗余
  - 组件数量膨胀
  - 需要设计系统重构
reads:
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/visual/
  - docs/interaction/
writes:
  - docs/design-system/REFACTOR_REPORT.md
---

# Design System Refactor

## Overview

扫描现有设计系统，建议合并/抽象/token 化。设计系统是活文档，需要持续演进。不重构的技术债更 risky，累积后无法挽回。

## When to Use

- ✅ 设计系统有冗余（相似组件 ≥3 个）
- ✅ 组件数量膨胀（>20 个组件）
- ✅ 需要设计系统重构
- ❌ NOT for 初次创建设计系统（用 design-system skill）

## Process

### 1. 扫描所有组件

读取以下目录的所有组件定义：
- `docs/design-system/DESIGN.md`（第 4 段 Component Stylings + 第 10 段 Semantic Vocabulary）
- `docs/visual/*.md`（视觉设计中的组件使用）
- `docs/interaction/*.md`（交互设计中的组件状态）

### 2. 识别重复/相似组件

#### 名称相似

Grep 组件名，识别名称相似的组件：
- PrimaryButton / MainButton / ActionButton
- ProductCard / ItemCard / ListCard

#### 结构相似

对比组件的 props 和 states，识别仅 props 差异的组件：
- 3 个按钮仅在 padding 上不同
- 5 个卡片共享相同结构，仅 token 差异

#### 视觉相似

对比组件的 token 使用，识别仅 token 差异的组件：
- 12 处硬编码 #3B82F6 应该用 token color.primary

### 3. 生成重构建议

#### 合并建议

```
发现：PrimaryButton / MainButton / ActionButton 三个组件
分析：仅在 padding 上不同（8px / 12px / 16px）
建议：合并为 Button + size prop（sm/md/lg）
影响：组件数 3 → 1，维护成本降低
```

#### 抽象建议

```
发现：ProductCard / ItemCard / ListCard 共享相同结构
分析：仅 token 差异（variant: product/item/list）
建议：抽象为 Card + variant prop
影响：组件数 3 → 1，扩展性提升
```

#### Token 化建议

```
发现：12 处硬编码 #3B82F6
分析：应统一用 token color.primary
建议：替换所有硬编码为 token 引用
影响：可维护性提升，主题切换可用
```

### 4. 输出重构报告

写入 `docs/design-system/REFACTOR_REPORT.md`：

```markdown
# Design System Refactor Report

## 扫描范围
- 组件总数：<N>
- token 总数：<N>
- 扫描日期：<ISO 8601>

## 合并建议

### R001: 合并 3 个按钮组件
- 涉及组件：PrimaryButton / MainButton / ActionButton
- 差异：仅 padding（8px / 12px / 16px）
- 建议：合并为 Button + size prop
- Before: 3 个独立组件
- After: 1 个组件 + size prop
- 影响范围：<列出引用文件>

## 抽象建议

### R002: 抽象 Card 组件
- 涉及组件：ProductCard / ItemCard / ListCard
- 差异：仅 variant token
- 建议：抽象为 Card + variant prop
- Before: 3 个独立组件
- After: 1 个组件 + variant prop

## Token 化建议

### R003: 替换硬编码颜色
- 涉及位置：12 处
- 当前值：#3B82F6（硬编码）
- 建议值：var(--color-primary)
- 影响范围：<列出文件>

## 执行优先级
- P0: R003（token 化，零风险）
- P1: R001（合并按钮，低风险）
- P2: R002（抽象 Card，中风险）
```

### 5. 用户确认后执行重构

用户确认后，更新：
- `docs/design-system/DESIGN.md`（第 4 段 Component Stylings）
- `docs/design-system/tokens.json`（新增/合并 token）
- `docs/handoff/component-map.json`（更新映射）

### 6. 重构后验证

运行 design-lint 确认重构未引入错误。

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "设计系统建好就不用动" | 设计系统是活文档，需要持续演进 |
| "重构太 risky" | 不重构的技术债更 risky，累积后无法挽回 |
| "组件多了再抽象" | 过早抽象是债，过晚抽象也是债，3 个相似就该抽象 |
| "硬编码颜色也能用" | 硬编码破坏主题切换和可维护性 |

## Red Flags

- 未扫描所有组件目录
- 重构建议无 Before/After 对比
- 未标注执行优先级
- 重构后未运行 design-lint 验证

## Verification

- [ ] 扫描覆盖所有组件目录（证据：扫描范围记录）
- [ ] 每条建议有 Before/After 对比（证据：报告内容）
- [ ] 执行优先级已标注（证据：P0/P1/P2 标记）
- [ ] 重构后 design-lint 通过（证据：lint-report.md 无 error）
- [ ] DESIGN.md + tokens.json + component-map.json 已更新（证据：文件 diff）

## 与 LOOP 的关系

- 不在 LOOP 内运行（在 LOOP 后的设计系统维护阶段运行）
- 读取 LOOP 产出的 docs/visual/ + docs/interaction/ 作为扫描输入
- 重构后调用 design-lint skill 验证未引入错误（复用 LOOP 内的 lint skill，但不进入循环）
- 产出的 REFACTOR_REPORT.md 供用户确认后执行合并/抽象/token 化
