---
name: design-recommendation
description: Generates data-driven design recommendations based on product type. Use when a new design system needs to be created. Use when product type is identified in DESIGN_BRIEF.md.
triggers:
  - 需要设计推荐
  - 创建设计系统前
  - DESIGN_BRIEF.md 已存在
reads:
  - docs/visual/DESIGN_BRIEF.md
  - .harness/data/design/reasoning.csv
  - .harness/data/design/products.csv
  - .harness/data/design/styles.csv
  - .harness/data/design/colors.csv
  - .harness/data/design/typography.csv
  - .harness/data/design/landing.csv
writes:
  - docs/design-system/RECOMMENDATION.md
---

# Design Recommendation

## Overview

根据产品类型推荐风格/配色/字体/落地页模式。数据驱动决策，不靠 LLM "发明"设计决策。

## When to Use

- ✅ 需要设计推荐
- ✅ 创建设计系统前（design-system skill 的前置）
- ✅ DESIGN_BRIEF.md 已存在且产品类型已识别
- ❌ NOT for 已有 RECOMMENDATION.md 且产品类型未变

## Process

### 1. 读取产品类型

从 `docs/visual/DESIGN_BRIEF.md` 读取 Product Type。

### 2. Grep 精确匹配 reasoning.csv

```
Grep pattern="<Product Type>" path=".harness/data/design/reasoning.csv"
```

解析命中行的字段：
- recommended_pattern
- style_priority（用 `+` 分割成关键词列表）
- color_mood
- typography_mood
- key_effects
- anti_patterns
- decision_rules（JSON，如 `{"if_luxury": "switch-to-minimal"}`）
- severity

**Fallback**：若 reasoning.csv 未命中或文件为空，调用先验知识推理，但必须加警告：
```
[WARNING: Using LLM Prior Knowledge due to empty/unmatched CSV]
```

### 3. Grep 匹配 products.csv

```
Grep pattern="<Product Type>" path=".harness/data/design/products.csv"
```

解析：primary_style / secondary_styles / landing_pattern / color_palette_focus / key_considerations

### 4. 多域检索

对 styles/colors/typography/landing 各跑一次 Grep：

- **styles.csv**：用 style_priority 关键词加权 Grep
- **colors.csv**：用产品类型 Grep
- **typography.csv**：用 typography_mood Grep
- **landing.csv**：用 recommended_pattern Grep

### 5. Agent 推理

把 5 域结果 + reasoning 规则 + decision_rules 喂给 LLM，承担"三级匹配"职责：
1. 精确风格名匹配
2. 关键词字段打分
3. 默认首位

应用 decision_rules（如 `if_luxury: switch-to-minimal`）。

### 6. 输出

写入 `docs/design-system/RECOMMENDATION.md`。

## RECOMMENDATION.md 输出格式

```markdown
# Design Recommendation

## Product Type
<识别结果>

## Recommended Pattern
<落地页结构 + Section Order + CTA Placement>

## Recommended Style
- 风格名：<从 styles.csv 匹配>
- AI Prompt Keywords：<...>
- CSS Keywords：<...>
- Design System Variables：<...>

## Recommended Color Palette
<17 列语义化 token：primary/on-primary/secondary/accent/...>

## Recommended Typography
- 字体对：<从 typography.csv 匹配>
- Google Fonts URL：<...>
- CSS Import：<...>
- Tailwind Config：<...>

## Key Effects
<动效/阴影/圆角建议>

## Anti-patterns
<该产品类型应避免的设计>

## Decision Rules
<JSON 条件规则，供后续 skill 解析>

## Severity
<CRITICAL/HIGH/MEDIUM>
```

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "我凭经验推荐就行" | 数据驱动比经验更稳定，6 个产品类型有明确推荐 |
| "推荐会限制创意" | 推荐是起点不是终点，用户可覆盖 |
| "数据文件不全没法推荐" | 有 Fallback 机制，先验知识 + WARNING 标签 |

## Red Flags

- 跳过数据检索直接用先验知识
- 未应用 decision_rules
- 推荐结果未标注数据来源（CSV vs 先验知识）

## Verification

- [ ] reasoning.csv 已检索（证据：Grep 命令执行记录）
- [ ] 5 域检索完成（证据：每个域有 Grep 记录）
- [ ] decision_rules 已应用（证据：RECOMMENDATION.md 体现条件逻辑）
- [ ] 若用先验知识有 WARNING 标签（证据：文件内容）
- [ ] RECOMMENDATION.md 字段齐全（证据：文件内容）

## 与 LOOP 的关系

- 不在 LOOP 内运行（在 LOOP 前的推荐阶段运行）
- 产出的 RECOMMENDATION.md 供 design-system skill 读取作为基础
- 产出的 Anti-patterns 供 design-lint skill 检查
- 产出的 Decision Rules 供后续 skill 解析
