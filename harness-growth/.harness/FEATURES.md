# FEATURES.md — Growth task/experiment status board

> Dynamic status tracking (updated during operations).
> Division of labor with GROWTH_STRATEGY.md: GROWTH_STRATEGY.md is a static definition (written at project initiation), while this file is dynamic status (updated during operations).
> Update trigger: after the measure skill passes, change the corresponding experiment status to done.

## Experiment/task status

| ID | Experiment/task | Priority | Status | Last updated | Note |
|------|----------|--------|------|---------|------|
| G-001 | [experiment/task name] | P1 | pending | | |

## Status definitions

- `pending` — not started
- `in_progress` — in progress (corresponding loops/specs/ has state.yaml)
- `review` — measure passed, awaiting growth review
- `done` — fully complete (growth review passed, conclusions archived)
- `blocked` — blocked (explain the reason)

## Update rules

1. **Start experiment**: change status to `in_progress`, create `loops/specs/<experiment>/`
2. **measure passed**: change status to `review`
3. **Growth review passed**: change status to `done`, write conclusions to knowledge-base.md
4. **session-end batch update**: scan experiments with status:done in `loops/specs/*/state.yaml`, batch sync to this file
