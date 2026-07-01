---
workflow_id: C
name: design-iteration
description: "Iterate on existing designs through Chesterton's Fence analysis, visual and interaction LOOPs"
default_mode: standard
---

# Workflow: design-iteration

> Design iteration workflow · Modifications to existing designs

## Applicable Scenarios

- Modifying an existing design
- Iterating after user feedback
- Design optimization

## Orchestration

```
session-start
  → Design System Gate (lightweight existence check)
  → Chesterton's Fence analysis (understand the original design)
  → PLAN (inline, initialize LOOP state)
  → LOOP(visual-design → verify)        [visual-design, max 5] (always runs)
  → LOOP(interaction-design → verify)   [interaction-design, max 5] (conditional)
  → design-review (gate outside LOOP, includes accessibility audit)
  → session-end
```

**interaction-design LOOP trigger conditions** (run if any is met):
- AC-xxx contains interaction-related acceptance criteria (states/motion/keyboard navigation/touch targets)
- The change involves interactive components (Button/Input/Modal/Dropdown/Toast, etc.)
- The change involves motion parameters (duration/easing/state transitions)

If the AC only involves visuals (color/spacing/typography/layout), skip the interaction-design LOOP.

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. Design System Gate (lightweight existence check)

The `visual-design` SKILL requires `docs/design-system/DESIGN.md` as input, and `verify`'s lint step validates against `docs/design-system/tokens.json`. Before iterating, confirm the design system exists so the iterated output can be token-validated:

- [ ] Read `docs/design-system/DESIGN.md` — exists?
- [ ] Read `docs/design-system/tokens.json` — exists?

**On pass** (both exist): proceed to Chesterton's Fence analysis. The design system is the source of truth for the tokens/components being iterated.

**On fail** (either missing): pause and prompt the user. The design being iterated cannot be consistently tokenized without a design system. Options:
- Run the `design-onboarding` workflow first (fast skeleton)
- Run the `design-system-setup` workflow first (full system with components)
- User confirms they will provide the design system externally, then proceed

This is a lighter check than `new-product-design`'s Design System Gate (which verifies 10-section completeness): iteration only requires existence, because the iteration target already references the design system. Do not proceed without resolving — `visual-design` would otherwise produce outputs that `verify`'s lint step cannot token-validate.

### 3. Chesterton's Fence analysis

**Understand the original design before changing it** (from addyosmani code-simplification):

Answer the following questions; if you can't answer them, you're not ready to change:
- Why is the original design this way? (design intent)
- Call relationships? (referenced by which pages)
- Boundaries? (interacts with which components)
- Why was it designed this way? (performance? platform constraints? historical reasons?)

Output `loops/specs/<task>/context-analysis.md`:

```markdown
# Context Analysis (Chesterton's Fence)

## Original Design Intent
<...>

## Call Relationships
- Referenced by: <page list>
- Depends on: <component list>

## Boundaries
- Interacts with <component>
- Constrained by <constraint>

## Why Designed This Way
- <reason 1>
- <reason 2>

## Modification Scope
- Only touch: <...>
- Do not touch: <...>

## NOTICED BUT NOT TOUCHING
- <unrelated issues found but outside this task's scope>
- <Should we create a task?>
```

### 4. PLAN (inline, no standalone skill)

- Define iteration goals + AC-xxx based on the Chesterton's Fence analysis
- Constitution check
- Initialize `loops/specs/<task>/state.yaml` (stage=plan, iteration=0, status=running)
- Write `loops/specs/<task>/spec.md` (with AC list)

### 5. LOOP: visual-design (max 5)

```
visual-design → verify
  ↑                          |
  └──── on failure, back to visual-design ┘
```

- **Scope Discipline**: Only touch what the task requires; record unrelated issues in the "NOTICED BUT NOT TOUCHING" list
- verify failure → back to visual-design, iteration +1
- More than 5 iterations → request human intervention

### 6. LOOP: interaction-design (max 5, conditional)

**Trigger conditions**: See "interaction-design LOOP trigger conditions" in the Orchestration section. If not triggered, skip this step.

```
interaction-design → verify
  ↑                          |
  └──── on failure, back to interaction-design ┘
```

- Based on the iterated visual design, update component states/motion parameters
- verify failure → back to interaction-design, iteration +1
- More than 5 iterations → request human intervention

### 7. design-review (gate outside LOOP, includes accessibility audit)

- Five-Axis Review (5 axes, Axis 5 performs WCAG 2.1 AA static-checkable subset audit; DOM-level checks deferred to harness-solo verify)
- Doubt-Driven (only Critical triggers adversarial debate)
- Compare before/after
- Output `loops/specs/<task>/evidence.md` + `docs/visual/accessibility-report.md`
- Not passed → back to LOOP (fixable) or PLAN (needs re-planning)

### 8. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| loops/specs/<task>/context-analysis.md | Chesterton's Fence analysis |
| loops/specs/<task>/spec.md | Iteration spec (with AC-xxx) |
| docs/visual/<page>.md | Updated visual design |
| docs/interaction/<page>.md | Updated interaction design (if interaction LOOP triggered) |
| loops/specs/<task>/state.yaml | Loop state |
| loops/specs/<task>/evidence.md | Validation evidence |
| loops/specs/<task>/iterations.log | Iteration history |
| loops/specs/<task>/lint-report.md | Lint report |

## Exit Criteria

- Chesterton's Fence analysis complete
- LOOP passed (verify incl. lint)
- design-review passed (includes accessibility audit)
- before/after comparison recorded
- state.yaml status=done
