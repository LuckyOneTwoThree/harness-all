# FEATURES.md — Design task status board

> Dynamic status tracking (updated during design).
> Division of labor with DESIGN_BRIEF.md: DESIGN_BRIEF.md is a static definition (written at project initiation), while this file is dynamic status (updated during design).
> Update trigger: after the verify skill passes, change the corresponding design task status to done.

## Design task status

| ID | Design task/component | Priority | Status | Last updated | Note |
|------|--------------|--------|------|---------|------|
| D-001 | [design task name] | P1 | pending | | |

## Status definitions

- `pending` — not started
- `in_progress` — designing (corresponding loops/specs/ has state.yaml)
- `review` — verify passed, awaiting design-review
- `done` — fully complete (design-review passed)
- `blocked` — blocked (explain the reason)

## Update rules

1. **Start design**: change status to `in_progress`, create `loops/specs/<task>/`
2. **verify passed**: change status to `review`
3. **design-review passed**: change status to `done`
4. **session-end batch update**: scan tasks with status:done in `loops/specs/*/state.yaml`, batch sync to this file
