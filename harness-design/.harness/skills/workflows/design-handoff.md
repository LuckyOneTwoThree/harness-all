---
workflow_id: F
name: design-handoff
description: "Hand off completed design deliverables to engineering with specs, component contract, and pre-delivery checks"
default_mode: skip
---

# Workflow: design-handoff

> Design handoff workflow · Handover from design to engineering
>
> **Responsibility boundary**: This workflow is only responsible for deliverable generation + Pre-Delivery Checklist.
> It trusts the gate-outside-LOOP results of the preceding workflow (new-design / design-iteration / redesign)
> (design-review, which includes accessibility audit, has already passed) and does not re-run reviews.

## Applicable Scenarios

- Design phase complete, needs handoff to engineering
- The preceding workflow's gate outside LOOP has passed (design-review includes accessibility audit)
- Produce engineering-consumable deliverables

## Prerequisites (hard gate)

Before entering this workflow, confirm the following prerequisites are met:

- [ ] The preceding workflow (new-design / design-iteration / redesign) is complete
- [ ] verify inside the LOOP passed (evidence: `loops/specs/<task>/lint-report.md` has no errors)
- [ ] design-review outside the LOOP passed (evidence: `loops/specs/<task>/evidence.md` contains a "passed" conclusion)
- [ ] design-review's Axis 5 accessibility audit passed (evidence: `docs/visual/accessibility-report.md` has no Critical failures)

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

**Product-level mode branch** (when the preceding workflow is `new-product-design`):

Product-level handoff does not have a single `<task>` — it spans multiple per-page tasks plus one product-task. The single-task checks above must be aggregated as follows:

- **Per-page tasks**: for each per-page task `<product-task>-<page-name>` listed in `docs/visual/DESIGN_PLAN.md` Section 2 (Status = done), verify:
  - `loops/specs/<product-task>-<page-name>/lint-report.md` has no error-level violations
  - `loops/specs/<product-task>-<page-name>/evidence.md` contains a "passed" design-review conclusion
  - `loops/specs/<product-task>-<page-name>/state.yaml` status is not failed
  - (Skipped pages — Status = skipped — are exempt; they must already be acknowledged in the handoff's Open Items section.)
- **Product-task**: verify the product-level consistency gate passed:
  - `loops/specs/<product-task>/product-review-evidence.md` contains a "passed" conclusion with no open Critical findings
  - `loops/specs/<product-task>/state.yaml` status is not failed
- **Accessibility**: `docs/visual/accessibility-report.md` has no Critical failures (this report is product-level in product-level mode, covering all pages)

If any per-page task or the product-task check is not satisfied → stop, return to `new-product-design` to complete the missing reviews. Do not generate a partial handoff that silently omits un-reviewed pages.

### 3. design-handoff-spec

Generate deliverables:

- Aggregate visual/interaction/prototype outputs
- Generate `docs/handoff/design-to-solo.md` (human-readable complete description)
- Generate `docs/interaction/component-spec.md` (component props/states/variants table)
- Generate `docs/handoff/component-contract.json` (framework-neutral semantic component contract)
- Generate `docs/prototype/flow.md` (interaction flow diagram)

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
| docs/handoff/component-contract.json | Semantic component contract (design → engineering) |
| docs/interaction/component-spec.md | Component spec |
| docs/prototype/flow.md | Interaction flow diagram |
| docs/handoff/packages/<handoff_id>/ | Portable package (manifest.json + artifacts/ + hash validation) |

## Exit Criteria

- All prerequisite hard gates passed
- All deliverables generated
- Pre-Delivery Checklist all ✓
- component-contract.json validates against its schema and contains stable IDs/states/token provenance
- Portable package is self-contained; manifest hash validates and every artifact path resolves
