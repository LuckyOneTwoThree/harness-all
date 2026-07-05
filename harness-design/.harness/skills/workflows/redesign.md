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
  → LOOP(ui-design → verify)                [ui-design, max 5] (A1: combined visual + interaction)
  → design-review (gate outside LOOP, includes accessibility audit)
  → session-end
```

**ui-design interaction sub-stage trigger conditions** (run if any is met):
- AC-xxx contains interaction-related acceptance criteria (states/motion/keyboard navigation/touch targets)
- The redesign involves interactive components (Button/Input/Modal/Dropdown/Toast, etc.)
- The redesign involves motion parameters (duration/easing/state transitions)

If the redesign only involves visuals (color/spacing/typography/layout), the interaction sub-stage is skipped within the ui-design LOOP (visual sub-stage only). A1: no separate interaction-design LOOP — both sub-stages are in the single ui-design LOOP.

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

### 6. LOOP: ui-design (max 5, type ui-design, A1: combined visual + interaction)

```
ui-design → verify
  ↑                          |
  └──── on failure, back to ui-design ┘
```

- **A1**: combined visual + interaction sub-stages in one LOOP (replaces former visual-design + interaction-design two-LOOP sequence)
- Interaction sub-stage conditional: see "ui-design interaction sub-stage trigger conditions" in the Orchestration section
- Based on the diff analysis, produce the new combined visual + interaction design
- verify failure → back to ui-design, iteration +1
- More than 5 iterations → request human intervention

### 7. design-review (gate outside LOOP, includes accessibility audit)

- Five-Axis Review (5 axes, Axis 5 performs WCAG 2.1 AA static-checkable subset audit; DOM-level checks deferred to harness-solo verify)
- Doubt-Driven (only Critical triggers adversarial debate)
- Focus of review: whether the redesign breaks the existing user experience
- Appends `## Five-Axis Review` + `## WCAG Audit` + `## Doubt-Driven Review` sections to `loops/specs/<task>/review-evidence.md` (A2: no separate evidence.md / accessibility-report.md)
- Not passed → back to LOOP (fixable) or PLAN (needs re-planning)

### 8. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Redesign requirements (with AC-xxx) |
| docs/design-system/IMPORT_REPORT.md | Import report |
| docs/design-system/DESIGN.md | Updated design system |
| docs/design-system/tokens.json | Updated tokens |
| loops/specs/<task>/spec.md | Redesign spec (with AC list) |
| loops/specs/<task>/state.yaml | Loop state (carries spec_ref pointer) |
| loops/specs/<task>/review-evidence.md | Consolidated evidence (verify + lint + five-axis + WCAG + doubt-driven, sectioned) |
| loops/specs/<task>/iterations.log | Iteration history |
| docs/ui/<page>.md | Redesigned combined visual + interaction (A1: replaces former docs/visual/<page>.md + docs/interaction/<page>.md) |

## Exit Criteria

- design-system-import complete
- Diff analysis complete
- LOOP passed (verify incl. lint)
- design-review passed (includes accessibility audit)
- state.yaml status=done
