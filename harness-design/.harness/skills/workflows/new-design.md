---
workflow_id: B
name: new-design
default_mode: deep
---

# Workflow: new-design

> New design task workflow · Core workflow

## Applicable Scenarios

- New page/component design tasks
- Clear requirements, designing from scratch
- Project already has a design system

## Orchestration

```
session-start
  → design-brief (hard gate)
  → PLAN (inline, initialize LOOP state)
  → LOOP(wireframe → verify → design-lint)            [wireframe, max 5]
  → LOOP(visual-design → verify → design-lint)        [visual-design, max 5]
  → LOOP(interaction-design → verify → design-lint)   [interaction-design, max 5]
  → design-review (gate outside LOOP)
  → accessibility-audit (gate outside LOOP)
  → session-end
```

**Sequencing principle**: Structure first (wireframe) → then visual → then interaction.
Doing visual design on top of a flawed structure is a waste of time; the same applies to interaction design on top of flawed visuals.

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. design-brief (hard gate)

- Produce `docs/visual/DESIGN_BRIEF.md` (with AC-xxx list)
- Hard gate: do not proceed to the next step if not passed

### 3. PLAN (inline, no standalone skill)

- Read the AC-xxx list from DESIGN_BRIEF.md
- Constitution check
- Initialize `loops/specs/<task>/state.yaml` (stage=plan, iteration=0, status=running)
- Write `loops/specs/<task>/spec.md` (with AC list)

### 4. LOOP 1: wireframe (max 5)

```
wireframe → verify → design-lint
  ↑                       |
  └── on failure, back to wireframe ──┘
```

- **wireframe**: Low-fidelity wireframe (black/white/gray, validate structure)
- **verify**: Structural integrity check + AC check
- **design-lint**: Mechanical rule check
- Failure → back to wireframe, iteration +1
- More than 5 iterations → request human intervention

### 5. LOOP 2: visual-design (max 5)

```
visual-design → verify → design-lint
  ↑                          |
  └──── on failure, back to visual-design ┘
```

- **visual-design**: Based on the approved wireframe, produce 2-3 visual proposals; after the user selects one, write it to docs/visual/
- **verify**: AC item-by-item check + constitution + quick accessibility check
- **design-lint**: Write and run a Node.js script for mechanical rule checks
- verify or design-lint failure → back to visual-design, iteration +1
- More than 5 iterations → request human intervention

### 6. LOOP 3: interaction-design (max 5)

```
interaction-design → verify → design-lint
  ↑                          |
  └──── on failure, back to interaction-design ┘
```

- **interaction-design**: Based on the approved visual design, produce component states + state transitions + motion parameters
- **verify**: AC check + keyboard navigation check
- **design-lint**: Mechanical rule check
- Failure → back to interaction-design, iteration +1

### 7. design-review (gate outside LOOP)

- Five-Axis Review (5 axes)
- Doubt-Driven (only Critical triggers adversarial debate; Nit/FYI are recorded directly)
- Severity Labeling
- Output `loops/specs/<task>/evidence.md`
- Not passed → back to LOOP (fixable) or PLAN (needs re-planning)

### 8. accessibility-audit (gate outside LOOP)

- WCAG 2.1 AA full check
- Not passed → back to LOOP

### 9. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Requirements document (with AC-xxx) |
| docs/prototype/wireframe.md | Wireframe (structural validation) |
| docs/visual/<page>.md | Visual design |
| docs/interaction/<page>.md | Interaction design |
| loops/specs/<task>/spec.md | Design spec (with AC list) |
| loops/specs/<task>/state.yaml | Loop state |
| loops/specs/<task>/evidence.md | Validation evidence |
| loops/specs/<task>/iterations.log | Iteration history |
| loops/specs/<task>/lint-report.md | Lint report |

## Exit Criteria

- All 3 LOOPs passed (verify + lint)
- design-review passed
- accessibility-audit passed
- evidence.md contains a review conclusion of "passed"
- state.yaml status=done
