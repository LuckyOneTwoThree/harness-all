# Engineering LOOP

Engineering uses 4 sequential substages, each running its own PLAN → ACT → VERIFY loop with a checkpoint at the end. Routing is defined in `.harness/rules/engineering-pipeline.md`; shared counting and breaker semantics are defined in `STATE_PROTOCOL.md`; `state.schema.json` is the machine-readable state shape.

## Substage Enum

`substage` for engineering is one of:

| substage | Meaning | Written by |
|---|---|---|
| `design-intake` | phase 0 active (non-LOOP; see Phase 0 Exception in `engineering-pipeline.md`) | design-intake skill (checkpoint still applies) |
| `frontend` | phase 1 LOOP active | phase 1 ACT/verify |
| `backend` | phase 2 LOOP active | phase 2 ACT/verify |
| `integration` | phase 3 LOOP active | phase 3 ACT/verify |

Phase-internal verify progress is encoded in `substage_progress[<phase>]` (`completed` / `user_confirmed`, `verify_state`), not in the `substage` enum. The enum only identifies the active phase. Phase 0 sets `substage: design-intake` to identify itself as active, but does not run the PLAN→ACT→VERIFY loop (see Phase 0 Exception).

## Core Loop (per phase)

```text
PLAN (phase spec) → ACT (one attempt + inline verify-fast)
        ↑                    │
        └── replan ──────────┴── fail by cause
                                  │ pass all phase outcomes
                                  ▼
                          VERIFY-FULL → CHECKPOINT → (user confirms) → next phase
```

Within one phase, the LOOP is the classic PLAN → ACT → VERIFY with failure routing by cause. The checkpoint after VERIFY-FULL is the only addition.

## Loop Types (per phase)

Phase 0 (design-intake) does not run LOOP — see Phase 0 Exception in `engineering-pipeline.md`. The table below covers phases 1-3 only.

| Phase | Default ACT owner sequence | Recommended failed-attempt limit | Success condition |
|---|---|---|---|
| frontend | frontend-implementation → test-driven-development | 5 | affected tests pass + AC evidence |
| backend | data-layer → api-implementation → test-driven-development | 5 | API contract implemented + BAC evidence + tests pass |
| integration | mock-to-real-switch → contract-verify → e2e-verification → verify | 3 | mock→real migration + IAC evidence + e2e suite passes |

**Specialist ACT replacement** (per `engineering-pipeline.md` Workflow × Phase × ACT Matrix):
- `optimize` workflow (E): the default ACT sequence is replaced by `performance-optimization` (specialist ACT) in the single active phase.
- `migration` workflow (F): the default ACT sequence is replaced by `migration` (specialist ACT) in Phase 2.
- `bugfix` workflow (C): the default ACT sequence is replaced by `test-driven-development` (regression test + fix) in the single active phase.

The recommended limit is an escalation point. The hard cap (attempt 10) and attempt-10/11 behavior come only from `STATE_PROTOCOL.md`.

## Attempt Lifecycle

1. Read raw `state.yaml`; reject terminal state or active breaker.
2. If `iteration >= 10`, do not start another ACT.
3. Increment iteration exactly once and persist `stage: act`, `status: running`, `substage: <active-phase>` before mutation.
4. Execute one independently verifiable outcome scoped to the current phase.
5. Run inline verify-fast within the ACT skill. It writes the attempt's single terminal outcome to `iterations.log` (exactly one PASSED/FAILED line; no second attempt record).
6. Failure routes to ACT, PLAN, or systematic-debugging without another increment. The next ACT increments when it actually begins.
7. After all phase outcomes pass, run verify-full once for the phase, then write the checkpoint.

## Checkpoint Mechanism

After verify-full passes for phase N:

1. Write `loops/specs/<task>/phase-N-<phase-name>-report.md` with cited evidence.
2. Set in `state.yaml`:
   ```yaml
   substage_progress:
     <phase-name>:
       completed: true
       user_confirmed: false
       report: loops/specs/<task>/phase-N-<phase-name>-report.md
   ```
3. Set `status: needs-human` (awaiting user confirmation). Do not enter the next phase.
4. On explicit user confirmation, set `substage_progress[<phase-name>].user_confirmed = true`, set `status: running`, then enter the next phase's entry check.
5. If the user rejects, set `completed: false`, append the rejection reason to `iterations.log`, and route back to that phase's PLAN.

A checkpoint is the only valid transition between phases. Auto-advance is forbidden.

## Persistent Artifacts

```text
loops/specs/<task>/
├── spec.md                              # current approved plan; overwrite on explicit replan
├── state.yaml                           # current state; overwrite
├── evidence.md                          # final verification evidence; verify owns it
├── review.md                            # final review; code-review owns it (after verify-full; phase 3 for multi-phase workflows, single active phase for single-phase workflows)
├── iterations.log                       # append-only attempt/review/reset events
├── phase-0-design-intake-report.md
├── phase-1-frontend-report.md
├── phase-2-backend-report.md
└── phase-3-integration-report.md
```

## State Responsibilities

| Field | Plan | ACT skill | Verify | Code review (after verify-full) |
|---|---:|---:|---:|---:|
| task/start/mode | initialize | — | — | — |
| iteration | `0` | increment before ACT | never | never |
| stage | `plan` | `act` | `verify` | `review` |
| substage | `<active-phase>` | `<active-phase>` | `<active-phase>` | `<active-phase>` (stays in the active phase; multi-phase = `integration`, single-phase = the single active phase) |
| status | running | running/retrying | running/needs-human (checkpoint) | done/retrying/needs-human |
| substage_progress[<phase>].verify_state | — | `inline-passed` / `inline-failed` / `awaiting-full` | `full-running` / `full-passed` / `full-failed` | — |
| substage_progress[<phase>].completed / .report | — | — | verify sets on phase pass | — |
| substage_progress[<phase>].user_confirmed | — | — | orchestrator on user message | — |
| last error | clear | observed ACT failure | observed gate failure | blocking finding |

> **substage vs verify_state**: `substage` (top-level field) only identifies the active phase (`design-intake` / `frontend` / `backend` / `integration`); it does NOT change during PLAN/ACT/VERIFY/review within the same phase. Phase-internal verify progress (inline-passed, full-passed, etc.) is written to `substage_progress[<active-phase>].verify_state`. ACT skills must NOT overwrite `substage` with verify state values.

**Valid stage values**: `plan`, `act`, `verify`, `review`, `debug`. The `debug` stage is entered when failure routing sends control to `systematic-debugging` (a diagnostic skill, NOT an ACT skill — it does not increment iteration or own per-attempt terminal outcomes). It exits when systematic-debugging returns to LOOP for verify-full.

`done` belongs exclusively to code-review after verify-full passes. For multi-phase workflows, this is at the end of Phase 3; for single-phase workflows (bugfix/optimize/migration), this is within the single active phase. A phase-level `done` (checkpoint confirmed) is encoded in `substage_progress`, not in `status`.

## Exploration Mode

`exploration_mode` selects the phase set:

| mode | Phase 0 | Phase 1 | Phase 2 | Phase 3 |
|---|---|---|---|---|
| none | — | — | — | — |
| skip | — | — | — | ✓ |
| standard | ✓ | ✓ | ✓ | ✓ |
| deep | ✓ | ✓ | ✓ | ✓ + OpenAPI contract generation in phase 0 |

- **none**: non-LOOP path. No phase routing, no task_type, no state.yaml. Used by setup, quick-fix, and release workflows.
- **skip**: jump directly to phase 3 integration; assumes frontend + backend already exist. Used for smoke/regression runs.
- **standard**: full 4-phase path. Default.
- **deep**: standard + machine-readable contract artifacts (OpenAPI/async-api) emitted from phase 0; phase 2 consumes the contract; phase 3 validates against it.

`exploration_mode` is set at workflow initialization and is not changed mid-task. It composes with `task_type` routing: a skipped phase per `task_type` remains skipped regardless of `exploration_mode`.

## Hard Circuit Breaker

The hard cap is global across phases, not per-phase. `iteration` counts attempts across the entire task lifetime:

- Recommended phase limits trigger early escalation; the user may authorize further attempts up to 10.
- Attempt 10 may execute and may complete successfully. If its verification fails, write `status: failed`, `hard_limit_reached: true`, and a concrete `last_error`.
- Before ACT, if `iteration >= 10`, do not start attempt 11; trigger the same breaker immediately.
- Verification must read raw `state.yaml`. A successful attempt 10 may transition to the phase's normal success state.
- Reset (per `STATE_PROTOCOL.md`) writes `iteration: 0`, `hard_limit_reached: false`, `status: running`, and records the reset in `iterations.log`. Reset does not unset `substage_progress` — confirmed phases remain confirmed; the active phase resumes its LOOP.

## Failure Routing

Failure routes by cause are defined in `engineering-pipeline.md` (Routing Rules). Summary:

- requirement/spec → phase PLAN
- implementation/test → phase ACT
- unknown cause → systematic-debugging
- upstream contract defect → block and feedback
- recommended phase limit → `needs-human`
- attempt 10 / attempt 11 → hard breaker per `STATE_PROTOCOL.md`
- code-review finding → code-review response then ACT if code changes (code-review runs at Phase 3 for multi-phase workflows, or within the single active phase for single-phase workflows)

## Completion Gate

A task is complete only when:

- every planned stable AC/BAC/IAC has cited evidence;
- every active phase's checkpoint is `completed: true, user_confirmed: true`;
- verify-full passes with actual command output in the terminal phase (Phase 3 for multi-phase workflows; the single active phase for single-phase workflows);
- code-review has no unresolved blocking findings;
- `review.md` exists and code-review writes `status: done`;
- session-end synchronizes the task board.

Phase 0-2 verify-full passes alone are not task completion; they are phase checkpoints pending confirmation.
