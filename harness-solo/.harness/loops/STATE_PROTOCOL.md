# State Protocol — Family-Wide LOOP Contract

> This file defines the shared state semantics for every harness. Domain LOOP.md files define their own stages and recommended iteration limits; this protocol owns counting, status transitions, and the hard circuit breaker.

## Single Source of Truth

`loops/specs/<task>/state.yaml` is the persisted source of truth for an active task. Context memory never overrides the raw file. At every verification stage, read the full file before deciding whether to continue.

## Attempt and Iteration Semantics

An **attempt** is one domain execution followed by verification:

- PM: RESEARCH → VALIDATE
- Design: DESIGN → VERIFY/LINT
- Solo: ACT → VERIFY
- Growth: EXPERIMENT → MEASURE
- Ops: PROVISION → VERIFY

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
| hard_limit_reached | Verification or explicit user-authorized reset |
| current_nested_task | Product-level orchestration only; aggregate progress remains in the canonical task board |

The accompanying `state.schema.json` validates the common shape. Domain LOOP.md files constrain the allowed `stage` values.
