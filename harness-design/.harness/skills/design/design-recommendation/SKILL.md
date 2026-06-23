---
name: design-recommendation
description: Generates data-driven design recommendations based on product type. Use when a new design system needs to be created. Use when product type is identified in DESIGN_BRIEF.md.
triggers:
  - Design recommendation needed
  - Before creating a design system
  - DESIGN_BRIEF.md already exists
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

Recommends style / color palette / font / landing page patterns based on product type. Data-driven decisions; do not rely on LLM to "invent" design decisions.

## When to Use

- ✅ Design recommendation needed
- ✅ Before creating a design system (prerequisite for the design-system skill)
- ✅ DESIGN_BRIEF.md exists and product type identified
- ❌ NOT for cases where RECOMMENDATION.md already exists and product type is unchanged

## Process

### 1. Read Product Type

Read Product Type from `docs/visual/DESIGN_BRIEF.md`.

### 2. Grep Exact Match in reasoning.csv

```
Grep pattern="<Product Type>" path=".harness/data/design/reasoning.csv"
```

Parse fields of the matched line:
- recommended_pattern
- style_priority (split on `+` into a keyword list)
- color_mood
- typography_mood
- key_effects
- anti_patterns
- decision_rules (JSON, e.g., `{"if_luxury": "switch-to-minimal"}`)
- severity

**Fallback**: If reasoning.csv has no match or is empty, invoke prior knowledge reasoning, but must add a warning:
```
[WARNING: Using LLM Prior Knowledge due to empty/unmatched CSV]
```

### 3. Grep Match in products.csv

```
Grep pattern="<Product Type>" path=".harness/data/design/products.csv"
```

Parse: primary_style / secondary_styles / landing_pattern / color_palette_focus / key_considerations

### 4. Multi-domain Retrieval

Run a Grep for each of styles/colors/typography/landing:

- **styles.csv**: Weighted Grep using style_priority keywords
- **colors.csv**: Grep using product type
- **typography.csv**: Grep using typography_mood
- **landing.csv**: Grep using recommended_pattern

### 5. Agent Reasoning

Feed the 5-domain results + reasoning rules + decision_rules to the LLM, which performs the "three-level matching" duty:
1. Exact style name match
2. Keyword field scoring
3. Default to first entry

Apply decision_rules (e.g., `if_luxury: switch-to-minimal`).

### 6. Output

Write to `docs/design-system/RECOMMENDATION.md`.

## RECOMMENDATION.md Output Format

```markdown
# Design Recommendation

## Product Type
<Identification result>

## Recommended Pattern
<Landing page structure + Section Order + CTA Placement>

## Recommended Style
- Style name: <Matched from styles.csv>
- AI Prompt Keywords: <...>
- CSS Keywords: <...>
- Design System Variables: <...>

## Recommended Color Palette
<17-column semantic tokens: primary/on-primary/secondary/accent/...>

## Recommended Typography
- Font pair: <Matched from typography.csv>
- Google Fonts URL: <...>
- CSS Import: <...>
- Tailwind Config: <...>

## Key Effects
<Motion / shadow / border radius recommendations>

## Anti-patterns
<Designs to avoid for this product type>

## Decision Rules
<JSON conditional rules, parsed by downstream skills>

## Severity
<CRITICAL/HIGH/MEDIUM>
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "I'll just recommend based on experience" | Data-driven is more stable than experience; 6 product types have clear recommendations |
| "Recommendations limit creativity" | Recommendations are a starting point, not an endpoint; users can override |
| "Data files are incomplete, can't recommend" | There's a Fallback mechanism: prior knowledge + WARNING label |

## Red Flags

- Skipping data retrieval and going straight to prior knowledge
- decision_rules not applied
- Recommendation results not annotated with data source (CSV vs prior knowledge)

## Verification

- [ ] reasoning.csv retrieved (evidence: Grep command execution record)
- [ ] 5-domain retrieval completed (evidence: each domain has a Grep record)
- [ ] decision_rules applied (evidence: RECOMMENDATION.md reflects conditional logic)
- [ ] If prior knowledge used, WARNING label present (evidence: file content)
- [ ] RECOMMENDATION.md fields complete (evidence: file content)

## Relationship with LOOP

- Not run inside LOOP (runs in the pre-LOOP recommendation stage)
- The RECOMMENDATION.md produced is consumed by the design-system skill as a baseline
- The Anti-patterns produced are checked by the design-lint skill
- The Decision Rules produced are parsed by downstream skills
