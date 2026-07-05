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
  → LOOP(ui-design → verify)                [ui-design, max 5] (A1: combined visual + interaction)
  → design-review (gate outside LOOP, includes accessibility audit)
  → session-end
```

**ui-design interaction sub-stage trigger conditions** (run if any is met):
- AC-xxx contains interaction-related acceptance criteria (states/motion/keyboard navigation/touch targets)
- The change involves interactive components (Button/Input/Modal/Dropdown/Toast, etc.)
- The change involves motion parameters (duration/easing/state transitions)

If the AC only involves visuals (color/spacing/typography/layout), the interaction sub-stage is skipped within the ui-design LOOP (visual sub-stage only). A1: no separate interaction-design LOOP — both sub-stages are in the single ui-design LOOP.

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. Design System Gate (lightweight existence check)

The `ui-design` SKILL (A1: replaces former visual-design + interaction-design) requires `docs/design-system/DESIGN.md` as input, and `verify`'s lint step validates against `docs/design-system/tokens.json`. Before iterating, confirm the design system exists so the iterated output can be token-validated:

- [ ] Read `docs/design-system/DESIGN.md` — exists?
- [ ] Read `docs/design-system/tokens.json` — exists?

**On pass** (both exist): proceed to Chesterton's Fence analysis. The design system is the source of truth for the tokens/components being iterated.

**On fail** (either missing): pause and prompt the user. The design being iterated cannot be consistently tokenized without a design system. Options:
- Run the `design-onboarding` workflow first (fast skeleton)
- Run the `design-system-setup` workflow first (full system with components)
- User confirms they will provide the design system externally, then proceed

This is a lighter check than `new-product-design`'s Design System Gate (which verifies 10-section completeness): iteration only requires existence, because the iteration target already references the design system. Do not proceed without resolving — `ui-design` would otherwise produce outputs that `verify`'s lint step cannot token-validate.

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

### 5. LOOP: ui-design (max 5, A1: combined visual + interaction)

```
ui-design → verify
  ↑                          |
  └──── on failure, back to ui-design ┘
```

- **A1**: combined visual + interaction sub-stages in one LOOP (replaces former visual-design + interaction-design two-LOOP sequence)
- Interaction sub-stage conditional: see "ui-design interaction sub-stage trigger conditions" in the Orchestration section
- **Scope Discipline**: Only touch what the task requires; record unrelated issues in the "NOTICED BUT NOT TOUCHING" list
- verify failure → back to ui-design, iteration +1
- More than 5 iterations → request human intervention

### 6. design-review (gate outside LOOP, includes accessibility audit)

- Five-Axis Review (5 axes, Axis 5 performs WCAG 2.1 AA static-checkable subset audit; DOM-level checks deferred to harness-solo verify)
- Doubt-Driven (only Critical triggers adversarial debate)
- Compare before/after
- Appends `## Five-Axis Review` + `## WCAG Audit` + `## Doubt-Driven Review` sections to `loops/specs/<task>/review-evidence.md` (A2: no separate evidence.md / accessibility-report.md)
- Not passed → back to LOOP (fixable) or PLAN (needs re-planning)

### 7. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| loops/specs/<task>/context-analysis.md | Chesterton's Fence analysis |
| loops/specs/<task>/spec.md | Iteration spec (with AC-xxx) |
| docs/ui/<page>.md | Updated combined visual + interaction design (A1: replaces former docs/visual/<page>.md + docs/interaction/<page>.md) |
| loops/specs/<task>/state.yaml | Loop state (carries spec_ref pointer) |
| loops/specs/<task>/review-evidence.md | Consolidated evidence (verify + lint + five-axis + WCAG + doubt-driven, sectioned) |
| loops/specs/<task>/iterations.log | Iteration history |

## Exit Criteria

- Chesterton's Fence analysis complete
- LOOP passed (verify incl. lint)
- design-review passed (includes accessibility audit)
- before/after comparison recorded
- state.yaml status=done

## Handoff batch rules (design iteration scenario)

When design-iteration produces a new design-to-solo.md (via the design-handoff workflow), the handoff MUST follow the batch delivery protocol:

| Field | Value for design iteration handoff |
|-------|-----------------------------------|
| `batch.type` | `incremental` (NOT `full` — `full` is only for first-time design delivery) |
| `batch.id` | Previous batch id + 1 |
| `batch.added_acs` | New DAC-xxx IDs allocated for newly designed pages/criteria in this iteration |
| `batch.modified_acs` | DAC-xxx IDs with changed semantics (per acceptance-id-protocol, these get NEW IDs; old IDs go to `superseded_acs`) |
| `batch.superseded_acs` | Old DAC-xxx IDs replaced or withdrawn (e.g., hover animation parameter changed → old DAC ID superseded by new) |
| `batch.unchanged_acs` | All valid AC-xxx + DAC-xxx IDs from the previous design-to-solo that are NOT in added/modified/superseded |
| `ac_ids` (envelope) | MUST be FULL SET of valid AC/DAC IDs = `added_acs` + `modified_acs` (new IDs) + `unchanged_acs`. Never just the changed subset. |

**Critical**: even though design-iteration only updates the changed pages/modules, the handoff's `ac_ids` envelope and `unchanged_acs` MUST include ALL valid ACs/DACs from the previous delivery. This ensures:
- Solo's session-start 1a can correctly identify unchanged vs added vs superseded ACs/DACs
- If a previous design-to-solo was never consumed, no ACs/DACs are lost (first-consumption guard treats all as added)

**Body format**: unchanged ACs/DACs use one-line summary + reference to prior handoff; added/modified ACs/DACs use full description; superseded ACs/DACs appear in body with `[superseded]` tag + pointer to replacement (but NOT in `ac_ids`).
