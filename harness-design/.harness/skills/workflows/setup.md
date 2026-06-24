---
workflow_id: A
name: setup
description: "Initialize a harness-design project by creating the design brief, recommendation, and design system"
default_mode: skip
---

# Workflow: setup

> Project initialization workflow · Run when using harness-design for the first time

## Applicable Scenarios

- Using harness-design in a project for the first time
- Need to initialize the design system
- Project has no DESIGN.md

## Orchestration

```
session-start
  → design-brief (hard gate)
  → design-recommendation (data-driven recommendation)
  → design-system (create DESIGN.md 10 sections + tokens)
  → session-end
```

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. design-brief (hard gate)

- Surface Assumptions
- Product type identification
- Extract the 4 elements of requirements
- Vibe Translation
- Aesthetic direction selection
- Reframe (produce AC-xxx list)
- Anti AI-Slop fields
- Output `docs/visual/DESIGN_BRIEF.md` (with AC-xxx)

**Hard gate**: If DESIGN_BRIEF.md is not generated or is incomplete, do not proceed to the next step.

### 3. design-recommendation

- Read the product type from DESIGN_BRIEF.md
- Grep reasoning.csv + products.csv + styles.csv + colors.csv + typography.csv + landing.csv
- Apply decision_rules
- Output `docs/design-system/RECOMMENDATION.md`

### 4. design-system

- Read RECOMMENDATION.md as the basis
- Fill in the 10 sections of DESIGN.md (including the fixed template for section 10 Semantic Vocabulary)
- Export tokens.json + tokens.css
- Create the pages/ directory

### 5. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Requirements document (with AC-xxx) |
| docs/design-system/RECOMMENDATION.md | Design recommendation |
| docs/design-system/DESIGN.md | Design system (10 sections) |
| docs/design-system/tokens.json | Tokens (W3C format) |
| docs/design-system/tokens.css | Tokens (CSS) |
| docs/design-system/pages/ | Page-level override directory |

## Exit Criteria

- All deliverables generated
- DESIGN_BRIEF.md passes the hard gate
- DESIGN.md contains 10 sections
- tokens.json conforms to W3C format
