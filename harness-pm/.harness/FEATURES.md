# FEATURES.md — Product feature status board

> Dynamic status tracking (updated during product work).
> Division of labor with PRD.md: PRD.md is a static definition (written during the design phase), while this file is dynamic status (updated during development/launch).
> Update trigger: after the verify skill passes, change the corresponding feature status to done.

## Feature status

| ID | Feature | Priority | Status | Last updated | Note |
|------|------|--------|------|---------|------|
| F-001 | [feature name] | P1 | pending | | |

## Status definitions

- `pending` — not started
- `in_progress` — in product design (corresponding loops/specs/ has state.yaml)
- `review` — design complete, awaiting human approval
- `approved` — approval passed, ready for engineering handoff
- `developing` — in engineering development (taken over by harness-engineering)
- `launched` — launched
- `blocked` — blocked (explain the reason)

## Update rules

1. **Start product design**: change status to `in_progress`, create `loops/specs/<task>/`
2. **Design complete**: change status to `review`, awaiting human approval
3. **Approval passed**: change status to `approved`, produce handoff document `docs/handoff/pm-to-engineering.md`
4. **In engineering development**: change status to `developing` (fed back by harness-engineering)
5. **Launch**: change status to `launched`
6. **session-end batch update**: scan tasks with status:done in `loops/specs/*/state.yaml`, batch sync to this file
