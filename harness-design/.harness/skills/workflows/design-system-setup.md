---
workflow_id: E
name: design-system-setup
description: "Build a complete design system from scratch with tokens, components, and design recommendations"
default_mode: standard
---

# Workflow: design-system-setup

> Design system setup workflow · Build a design system from scratch

## Applicable Scenarios

- Project has no design system
- Need to build a complete design system
- After setup, the design system is referenced by all pages

## Orchestration

```
session-start
  → design-brief (hard gate, identify product type)
  → design-recommendation (data-driven recommendation)
  → design-system (create DESIGN.md 10 sections + tokens)
  → PLAN (inline, initialize LOOP state)
  → LOOP(component-design → verify)  [component, max 5]
  → design-review (gate outside LOOP)
  → session-end
```

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. design-brief (hard gate)

- Identify product type (used by design-recommendation)
- Define AC-xxx for the design system setup
- Produce `docs/visual/DESIGN_BRIEF.md`

### 3. design-recommendation

- Read the product type from DESIGN_BRIEF.md
- Grep reasoning.csv + products.csv + styles.csv + colors.csv + typography.csv + landing.csv
- Output `docs/design-system/RECOMMENDATION.md`

### 4. design-system

- Read RECOMMENDATION.md as the basis
- Fill in the 10 sections of DESIGN.md (including the fixed template for section 10 Semantic Vocabulary)
- Export tokens.json + tokens.css
- Create the pages/ directory

### 5. PLAN (inline, no standalone skill)

- Extract the component list from section 10 Semantic Vocabulary of DESIGN.md
- Define AC-xxx for each component
- Constitution check
- Initialize `loops/specs/<task>/state.yaml` (stage=plan, iteration=0, status=running)
- Write `loops/specs/<task>/spec.md` (with AC list)

### 6. LOOP: component-design (max 5, type component)

For each core component (Button/Input/Card/Modal, etc.):

```
component-design → verify
  ↑                          |
  └──── on failure, back to component-design ┘
```

- **component-design**: Design components based on the design system (states/variants/sizes/composition rules)
- **verify**: Component integrity check (Props/States/Variants/Sizes/Composition/Accessibility)
- **verify**: Token consistency check (L001-L015, unified gate including lint)
- Failure → back to component-design, iteration +1
- More than 5 iterations → request human intervention

### 7. design-review (gate outside LOOP, includes accessibility audit)

- Five-Axis Review (5 axes, Axis 5 performs WCAG 2.1 AA static-checkable subset audit; focus on component consistency axis)
- Doubt-Driven (only Critical triggers adversarial debate)
- Output `loops/specs/<task>/review-evidence.md` (A2: includes `## Verify Evidence`, `## Lint Report`, `## WCAG Audit` sections)
- Not passed → back to LOOP (fixable) or PLAN (needs re-planning)

### 8. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Requirements document (with product type + AC-xxx) |
| docs/design-system/RECOMMENDATION.md | Design recommendation |
| docs/design-system/DESIGN.md | Design system (10 sections) |
| docs/design-system/tokens.json | Tokens (W3C format) |
| docs/design-system/tokens.css | Tokens (CSS) |
| docs/design-system/pages/ | Page-level override directory |
| docs/design-system/components/<Component>.md | Component design mockup |
| loops/specs/<task>/spec.md | Design spec (with AC list) |
| loops/specs/<task>/state.yaml | Loop state |
| loops/specs/<task>/review-evidence.md | Validation evidence + lint report + WCAG audit (A2: merged from evidence.md + lint-report.md + accessibility-report.md) |
| loops/specs/<task>/iterations.log | Iteration history |

## Exit Criteria

- DESIGN.md contains 10 sections
- tokens.json conforms to W3C format
- Core components (Button/Input/Card/Modal) all designed
- LOOP passed (verify incl. lint)
- design-review passed
- state.yaml status=done
