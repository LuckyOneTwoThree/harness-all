---
workflow_id: D
name: redesign
description: "Redesign an existing project by importing the current design system, diffing, and iterating on visuals"
default_mode: deep
---

# Workflow: redesign

> Redesign workflow · Redesign of an existing project

## Applicable Scenarios

- Existing project needs a redesign
- Current design system needs an upgrade
- Design refactoring after a tech stack migration

## Orchestration

```
session-start
  → design-brief (hard gate)
  → design-system-import (import from existing code)
  → diff analysis
  → PLAN (inline, initialize LOOP state)
  → LOOP(visual-design → verify → design-lint)        [visual-design, max 5] (always runs)
  → LOOP(interaction-design → verify → design-lint)   [interaction-design, max 5] (conditional)
  → design-review (gate outside LOOP)
  → accessibility-audit (gate outside LOOP)
  → session-end
```

**interaction-design LOOP trigger conditions** (run if any is met):
- AC-xxx contains interaction-related acceptance criteria (states/motion/keyboard navigation/touch targets)
- The redesign involves interactive components (Button/Input/Modal/Dropdown/Toast, etc.)
- The redesign involves motion parameters (duration/easing/state transitions)

If the redesign only involves visuals (color/spacing/typography/layout), skip the interaction-design LOOP.

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. design-brief (hard gate)

- Redesign goals
- Problems with the current design
- Desired improvement directions
- Produce `docs/visual/DESIGN_BRIEF.md` (with AC-xxx)

### 3. design-system-import

- Detect the project's tech stack
- Read config files (tailwind.config.js / theme.ts / globals.css)
- Extract tokens
- Generate DESIGN.md 10 sections
- Generate tokens.json + tokens.css
- Output IMPORT_REPORT.md

### 4. Diff Analysis

Compare the current design system with the redesign goals:

```markdown
# Redesign Diff Analysis

## Current Design System
- Color palette: <...>
- Typography: <...>
- Components: <...>

## Redesign Goals
- Color palette: <...>
- Typography: <...>
- Components: <...>

## Differences
| Dimension | Current | Target | Change Scope |
|------|------|------|---------|
| Color palette | <...> | <...> | Global replacement |
| Typography | <...> | <...> | Global replacement |
| Components | <...> | <...> | Partial refactoring |

## Impact Scope
- Affected pages: <...>
- Affected components: <...>
```

### 5. PLAN (inline, no standalone skill)

- Define redesign AC-xxx based on the diff analysis
- Constitution check
- Initialize `loops/specs/<task>/state.yaml` (stage=plan, iteration=0, status=running)
- Write `loops/specs/<task>/spec.md` (with AC list)

### 6. LOOP: visual-design (max 5, type visual-design)

```
visual-design → verify → design-lint
  ↑                          |
  └──── on failure, back to visual-design ┘
```

- Based on the diff analysis, produce the new visual design
- verify/design-lint failure → back to visual-design, iteration +1
- More than 5 iterations → request human intervention

### 7. LOOP: interaction-design (max 5, conditional)

**Trigger conditions**: See "interaction-design LOOP trigger conditions" in the Orchestration section. If not triggered, skip this step.

```
interaction-design → verify → design-lint
  ↑                          |
  └──── on failure, back to interaction-design ┘
```

- Based on the new visual design, update component states/motion parameters
- verify/design-lint failure → back to interaction-design, iteration +1

### 8. design-review (gate outside LOOP)

- Five-Axis Review
- Doubt-Driven (only Critical triggers adversarial debate)
- Focus of review: whether the redesign breaks the existing user experience
- Output `loops/specs/<task>/evidence.md`
- Not passed → back to LOOP (fixable) or PLAN (needs re-planning)

### 9. accessibility-audit (gate outside LOOP)

- WCAG 2.1 AA full check
- Not passed → back to LOOP

### 10. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Redesign requirements (with AC-xxx) |
| docs/design-system/IMPORT_REPORT.md | Import report |
| docs/design-system/DESIGN.md | Updated design system |
| docs/design-system/tokens.json | Updated tokens |
| loops/specs/<task>/spec.md | Redesign spec (with AC list) |
| loops/specs/<task>/state.yaml | Loop state |
| loops/specs/<task>/evidence.md | Validation evidence |
| loops/specs/<task>/iterations.log | Iteration history |
| loops/specs/<task>/lint-report.md | Lint report |
| docs/visual/<page>.md | Redesigned visual mockup |
| docs/interaction/<page>.md | Updated interaction design (if interaction LOOP triggered) |

## Exit Criteria

- design-system-import complete
- Diff analysis complete
- LOOP passed (verify + lint)
- design-review passed
- accessibility-audit passed
- state.yaml status=done
