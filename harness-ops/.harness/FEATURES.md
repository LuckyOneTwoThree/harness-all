# FEATURES.md — Ops task status board

> Dynamic status tracking (updated during operations).
> Division of labor with OPS_STRATEGY.md: OPS_STRATEGY.md is a static definition (written at project initiation), while this file is dynamic status (updated during operations).
> Update trigger: after the verify skill passes, change the corresponding task status to done.

## Task status

| ID | Task | Priority | Status | Last updated | Note |
|------|------|--------|------|---------|------|
| O-001 | Fill in infrastructure strategy document (OPS_STRATEGY.md) | P1 | pending | | |
| O-002 | Set up CI/CD pipeline | P1 | pending | | |
| O-003 | Deploy monitoring & alerting system | P1 | pending | | |
| O-004 | Design disaster recovery drill plan | P2 | pending | | |

## Status definitions

- `pending` — not started
- `in_progress` — in progress (corresponding loops/specs/ has state.yaml)
- `review` — verify passed, awaiting ops review
- `done` — fully complete (ops review passed)
- `blocked` — blocked (explain the reason)

## Update rules

1. **Start task**: change status to `in_progress`, create `loops/specs/<task>/`
2. **verify passed**: change status to `review`
3. **Ops review passed**: change status to `done`
4. **session-end batch update**: scan tasks with status:done in `loops/specs/*/state.yaml`, batch sync to this file
