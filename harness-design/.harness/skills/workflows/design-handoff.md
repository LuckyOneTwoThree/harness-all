---
workflow_id: F
name: design-handoff
default_mode: skip
---

# Workflow: design-handoff

> Design handoff workflow · Handover from design to engineering
>
> **Responsibility boundary**: This workflow is only responsible for deliverable generation + Pre-Delivery Checklist.
> It trusts the gate-outside-LOOP results of the preceding workflow (new-design / design-iteration / redesign)
> (design-review + accessibility-audit have already passed) and does not re-run reviews.

## Applicable Scenarios

- Design phase complete, needs handoff to engineering
- The preceding workflow's gates outside LOOP have passed (design-review + accessibility-audit)
- Produce engineering-consumable deliverables

## Prerequisites (hard gate)

Before entering this workflow, confirm the following prerequisites are met:

- [ ] The preceding workflow (new-design / design-iteration / redesign) is complete
- [ ] verify + design-lint inside the LOOP all passed (evidence: `loops/specs/<task>/lint-report.md` has no errors)
- [ ] design-review outside the LOOP passed (evidence: `loops/specs/<task>/evidence.md` contains a "passed" conclusion)
- [ ] accessibility-audit outside the LOOP passed (evidence: `docs/visual/accessibility-report.md` has no Critical failures)

**Hard gate not passed**: Do not enter handoff; return to the preceding workflow to complete the reviews.

## Orchestration

```
session-start
  → prerequisite check (hard gate)
  → design-handoff-spec (generate handoff spec + Pre-Delivery Checklist)
  → session-end
```

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. Prerequisite check (hard gate)

Verify the 4 prerequisite checks item by item:

- Read `loops/specs/<task>/lint-report.md` to confirm no error-level violations
- Read `loops/specs/<task>/evidence.md` to confirm the design-review conclusion is "passed"
- Read `docs/visual/accessibility-report.md` to confirm no Critical failures
- Read `loops/specs/<task>/state.yaml` to confirm status is not failed

If any is not satisfied → stop, return to the preceding workflow to complete the reviews.

### 3. design-handoff-spec

Generate deliverables:

- Aggregate visual/interaction/prototype outputs
- Generate `docs/handoff/design-to-solo.md` (human-readable complete description)
- Generate `docs/interaction/component-spec.md` (component props/states/variants table)
- Generate `docs/handoff/component-map.json` (explicit mapping layer, Stitch's core innovation)
- Generate `docs/prototype/flow.md` (interaction flow diagram)
- Copy `docs/design-system/tokens.json` + `tokens.css` to the handoff directory

Run the Pre-Delivery Checklist (6 items):

- [ ] Run UX validation scan (Grep ux-guidelines.csv for animation/accessibility/z-index/loading)
- [ ] Walk through Common Rules §1-§3 (CRITICAL + HIGH levels)
- [ ] Test at 375px (small phone) and in landscape mode
- [ ] Verify with reduced-motion enabled
- [ ] Independently verify dark mode contrast
- [ ] Confirm all touch targets ≥44pt

### 4. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/handoff/design-to-solo.md | Human-readable complete description |
| docs/handoff/component-map.json | Explicit mapping layer (design → engineering) |
| docs/interaction/component-spec.md | Component spec |
| docs/prototype/flow.md | Interaction flow diagram |

## Exit Criteria

- All prerequisite hard gates passed
- All deliverables generated
- Pre-Delivery Checklist all ✓
- component-map.json is valid and contains a states field
