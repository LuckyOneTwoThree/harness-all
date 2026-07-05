# Domain Boundaries and Routing

> Purpose: Prevent capability overlap from turning into duplicate execution. Independence remains available, but family collaboration uses one clear owner per outcome.

## Operating Modes

- **Standalone mode**: One harness may use its local fallback skills to complete domain-adjacent work.
- **Family mode**: When multiple harnesses are intentionally combined, the owner below executes the work; upstream frameworks define constraints and consume results.

The user chooses the operating mode. Do not infer that installed templates alone mean family mode.

## Ownership Matrix

| Outcome | Owner in family mode | Upstream contribution |
|---|---|---|
| Product strategy, PRD, product ACs | PM | Research and human decisions |
| Product analytics definitions, North Star, tracking requirements | PM | Research and human decisions |
| Visual/interaction system, tokens, component map, DACs | Design | PM provides PRD and Persona |
| Code, tests, architecture, engineering evidence | Solo | PM ACs + Design DACs/contracts |
| Product-health interpretation and roadmap decision | PM | Solo provides engineering evidence |

## Naming Rules

- **product analytics**: User/product behavior metrics owned by PM.

Avoid the unqualified word “monitoring” in new contracts when one of these precise terms applies.

## Handoff Rules

In family mode:

1. Standalone fallback output must be marked `mode: standalone-fallback` so it is not mistaken for an owner-produced family contract.

## FEATURES.md Cross-Framework Reconciliation

PM and Solo each maintain their own `FEATURES.md` with different status vocabularies reflecting their lifecycle perspectives:

| PM status (product lifecycle) | Solo status (engineering lifecycle) | Meaning |
|-------------------------------|-------------------------------------|---------|
| `pending` | `pending` | Not started |
| `in_progress` | — | PM in product design (Solo not involved yet) |
| `review` | — | Design complete, awaiting PM-internal approval |
| `approved` | `pending` | PM handoff ready; Solo has not started |
| `developing` | `in_progress` / `review` | Solo actively developing or in verify |
| `launched` | `done` | Solo code-review passed AND PM launched |
| `blocked` | `blocked` | Blocked (reason may differ by framework) |

**Reconciliation rules**:

1. **PM session-start reconciliation step** (added to step 4 "Read the feature board"): when PM session-start reads `FEATURES.md`, if a `solo-to-pm.md` handoff has been consumed (receipt exists), PM should cross-check: for each feature marked `done` in Solo's `FEATURES.md` (reported via solo-to-pm.md's "Implemented Features" section), PM's `FEATURES.md` should reflect at least `developing`. If PM still shows `approved` while Solo reports `done`, flag the drift to the user.

2. **PM session-end reconciliation**: when PM session-end updates `FEATURES.md` (step 4 of update rules), if a Solo `done` feature has been reported via consumed solo-to-pm.md, PM may advance status to `launched` (after PM-internal launch decision) or leave at `developing` (if launch pending). PM never marks `launched` without its own launch decision.

3. **Solo session-end reconciliation**: Solo's `FEATURES.md` reflects only engineering lifecycle (`pending` → `in_progress` → `review` → `done`). Solo does NOT consume PM's `FEATURES.md` directly; status synchronization flows through solo-to-pm.md's "Implemented Features" section → PM session-start reconciliation.

4. **No direct write across frameworks**: PM never writes to Solo's `FEATURES.md`; Solo never writes to PM's `FEATURES.md`. Synchronization is handoff-driven, not direct-write.

### PM-Design Reconciliation

Design maintains its own `FEATURES.md` with design-lifecycle status (`pending` → `in_progress` → `review` → `done` → `blocked`). PM-Design synchronization flows through handoff documents, not direct write:

| PM status (product lifecycle) | Design status (design lifecycle) | Meaning |
|-------------------------------|----------------------------------|---------|
| `pending` / `in_progress` | `pending` | PM still in product design; Design not involved yet |
| `approved` | `pending` | PM handoff ready; Design has not started |
| `approved` | `in_progress` | Design actively designing (consumed pm-to-design.md) |
| `approved` | `review` / `done` | Design verify/review passed; design-to-solo ready or published |
| `developing` | `done` | Design complete; Solo consuming design-to-solo.md |
| `launched` | `done` | Fully launched; Design work complete |
| `blocked` | `blocked` | Blocked (reason may differ by framework) |

5. **PM session-start Design reconciliation**: when PM session-start reads `FEATURES.md`, if a `design-to-pm.md` handoff has been consumed (receipt exists), PM cross-checks: for each design task reported as `done` in design-to-pm.md, PM's corresponding feature should be at least `approved`. If PM shows `in_progress` while Design reports `done`, flag the drift (Design completed work PM hasn't approved for handoff).

6. **Design session-start reconciliation**: when Design session-start reads its `FEATURES.md`, if a `pm-to-design.md` handoff has been consumed (receipt exists), Design cross-checks: for each feature PM marks as `approved` in pm-to-design.md, Design's corresponding task should be at least `in_progress`. If Design shows `pending` while PM reports `approved`, flag the drift (PM handoff ready but Design hasn't started).

7. **Design session-end reconciliation**: when Design session-end updates `FEATURES.md`, if design-to-solo.md has been published (design complete), Design marks the corresponding task as `done`. This signals Solo (via design-to-solo.md consumption) that design work is complete and engineering can proceed.

8. **No direct write PM↔Design**: PM never writes to Design's `FEATURES.md`; Design never writes to PM's `FEATURES.md`. Synchronization is handoff-driven (`pm-to-design.md` / `design-to-pm.md`).
