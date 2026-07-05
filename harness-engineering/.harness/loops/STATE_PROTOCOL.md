# State Protocol — Family-Wide LOOP Contract

> This file defines the shared state semantics for every harness. Domain LOOP.md files define their own stages and recommended iteration limits; this protocol owns counting, status transitions, and the hard circuit breaker.

## Single Source of Truth

`loops/specs/<task>/state.yaml` is the persisted source of truth for an active task. Context memory never overrides the raw file. At every verification stage, read the full file before deciding whether to continue.

## Attempt and Iteration Semantics

An **attempt** is one domain execution followed by verification:

- PM: RESEARCH → VALIDATE
- Engineering: ACT → VERIFY (across the 4 phases — design-intake / frontend / backend / integration — each phase runs its own LOOP)

Rules:

1. Initialize `iteration: 0`.
2. Immediately before starting a domain execution stage, increment iteration exactly once and persist it.
3. Verification, failure recording, rollback, review, and replanning never increment iteration.
4. A retry increments iteration only when the next execution attempt actually begins.
5. Outside-LOOP gates do not consume an iteration unless they re-enter a domain execution stage.
6. Every attempt appends exactly one terminal outcome to `iterations.log`.

This rule overrides any ambiguous wording elsewhere. One attempt can never increment iteration twice.

## Status Transitions

| From | Allowed To | Meaning |
|---|---|---|
| new | running | Task initialized |
| running | retrying / needs-human / blocked / done / failed | Execution or verification result |
| retrying | running / needs-human / blocked / failed | Next attempt, pause, or exhausted limit |
| needs-human | running / blocked / failed | Human decision received or task cannot continue |
| blocked | running / failed | Dependency resolved or task abandoned |
| done | — | Terminal; further work creates a new task |
| failed | running only after explicit reset | Terminal unless the user resets the circuit breaker |

Forbidden examples: `done → running`, `failed → retrying`, or any execution while `hard_limit_reached: true`.

**Task completion archival**: when a task transitions to `done` or `failed` (terminal states), `memory-maintenance` archives `loops/specs/<task>/iterations.log` to `loops/archives/iterations-<task>-<YYYYMMDD>.log` and removes the original from `loops/specs/<task>/`. This keeps the task directory clean (only active-task files remain: state.yaml, spec.md, evidence.md, review.md). The archived log is retained for audit but no longer loaded by session-start. If the same task scope is later re-opened as a fix task (`<original-task-id>-fix-<N>`), it creates a new `iterations.log` under the new task directory; the original archived log is NOT merged back.

**Fix task exception (product-level only)**: when product-engineering-review finds a Critical issue in an already-`done` nested task, the done task is NOT re-opened (that would violate the terminal rule). Instead, a new `<original-task-id>-fix-<N>` task is created with its own spec/state, referencing the original task's evidence as input. The original task's `status: done` and evidence remain authoritative for the pre-fix revision; the original spec.md retains `AC [status: done]` for audit integrity. The fix task's spec.md marks the inherited ACs as `[status: pending]` for re-verification. This preserves the audit trail while allowing downstream-impacting issues to be addressed.

## Hard Circuit Breaker

- Recommended domain limits trigger early escalation; the user may explicitly authorize further attempts up to 10.
- Attempt 10 may execute and may complete successfully. If its verification fails, write `status: failed`, `hard_limit_reached: true`, and a concrete `last_error`.
- Before ACT, if `iteration >= 10`, do not start attempt 11; trigger the same breaker immediately.
- Verification must read raw `state.yaml`. A successful attempt 10 may transition to the domain's normal success state.
- Do not execute another LOOP stage after the breaker until the user explicitly requests a reset.
- Reset writes `iteration: 0`, `hard_limit_reached: false`, `status: running`, and records the reset in `iterations.log`.

## Field Ownership

| Field | Writer |
|---|---|
| current_task / started_at / exploration_mode | Workflow initialization |
| iteration | Domain execution stage, once per attempt |
| stage | The stage currently entered |
| status / last_error / last_error_at | Current stage based on observed outcome |
| substage | Family-wide field with framework-local semantics. Engineering uses enum `{design-intake, frontend, backend, integration}` (see `state.schema.json`); PM uses its own sub-stage values documented in PM's LOOP.md |
| hard_limit_reached | Verification or explicit user-authorized reset |
| current_nested_task | Product-level orchestration only; aggregate progress remains in the canonical task board |

The accompanying `state.schema.json` validates the common shape. Domain LOOP.md files constrain the allowed `stage` values.
