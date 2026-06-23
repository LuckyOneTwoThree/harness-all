# FEATURES.md — Feature status board

> Dynamic status tracking (updated during development).
> Division of labor with PROJECT.md: PROJECT.md is a static definition (written at project initiation), while this file is dynamic status (updated during development).
> Update trigger: after the verify skill passes, change the corresponding feature status to done.

## Feature status

| ID | Feature | Priority | Status | Last updated | Note |
|------|------|--------|------|---------|------|
| F-001 | [feature name] | P1 | pending | | |

## Status definitions

- `pending` — not started
- `in_progress` — in development (corresponding loops/specs/ has state.yaml)
- `review` — verify passed, awaiting code-review
- `done` — fully complete (code-review passed)
- `blocked` — blocked (explain the reason)

## Update rules

1. **Start development**: change status to `in_progress`, create `loops/specs/<feature>/`
2. **verify passed**: change status to `review`
3. **code-review passed**: change status to `done`
4. **session-end batch update**: scan features with status:done in `loops/specs/*/state.yaml`, batch sync to this file
