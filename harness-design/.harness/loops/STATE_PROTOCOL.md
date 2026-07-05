# State Protocol — Family-Wide LOOP Contract

> This file defines the shared state semantics for every harness. Domain LOOP.md files define their own stages and recommended iteration limits; this protocol owns counting, status transitions, and the hard circuit breaker.

## Single Source of Truth

`loops/specs/<task>/state.yaml` is the persisted source of truth for an active task. Context memory never overrides the raw file. At every verification stage, read the full file before deciding whether to continue.

## Attempt and Iteration Semantics

An **attempt** is one domain execution followed by verification:

- PM: RESEARCH → VALIDATE
- Design: DESIGN → VERIFY/LINT
- Solo: ACT → VERIFY

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

**Task completion archival**: when a task transitions to `done` or `failed` (terminal states), session-end archives `loops/specs/<task>/iterations.log` to `loops/archives/iterations-<task>-<YYYYMMDD>.log` and removes the original from `loops/specs/<task>/`. This keeps the task directory clean (only active-task files remain: state.yaml, spec.md, review-evidence.md). The archived log is retained for audit but no longer loaded by session-start. If the same task scope is later re-opened as a fix task (`<original-task-id>-fix-<N>`), it creates a new `iterations.log` under the new task directory; the original archived log is NOT merged back.

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
| substage | Family-wide field with framework-local semantics. Solo uses enum {inline-passed, inline-failed, awaiting-full, full-running, full-passed, full-failed} (see Solo's LOOP.md); PM/Design use their own sub-stage values documented in each framework's LOOP.md |
| hard_limit_reached | Verification or explicit user-authorized reset |
| current_nested_task | Product-level orchestration only; aggregate progress remains in the canonical task board |

The accompanying `state.schema.json` validates the common shape. Domain LOOP.md files constrain the allowed `stage` values.

## Write Frequency (A5 — 2026-07-05)

To reduce disk-write overhead in Solo mode (single-session, push-to-end workflows), `state.yaml` is written to disk only at the following mandatory checkpoints. Intermediate state changes (e.g., substage transitions within a single iteration) stay in memory and are NOT persisted until the next mandatory checkpoint.

### Mandatory write checkpoints (circuit-breaker dependency)

| Checkpoint | When | Fields written | Rationale |
|---|---|---|---|
| 1. PLAN init | Workflow initialization | current_task, iteration=0, stage=plan, status=running, started_at, exploration_mode, spec_ref | Task identity + initial state must persist for session resume |
| 2. DESIGN success | After DESIGN stage completes, before VERIFY | iteration (+1), stage=design, status=running | Circuit-breaker reads iteration at VERIFY — must persist the increment before verify runs |
| 3. VERIFY/LINT complete | After verify (incl. lint) stage outcome | stage=verify/lint, status=retrying\|running, last_error, last_error_at | Circuit-breaker decision point — verify must read raw state.yaml here per LOOP.md rule |
| 4. review complete | After design-review (out-of-LOOP gate) outcome | stage=review, status=done\|retrying\|blocked, last_error, last_error_at | Terminal/near-terminal state must persist |

### Non-persisted (memory-only) state changes

The following stay in memory between checkpoints and are NOT written to disk:

- `substage` transitions within a single iteration (e.g., visual sub-stage → interaction sub-stage in ui-design LOOP): the substage field is updated in memory during execution, but only persisted at the next mandatory checkpoint (DESIGN success or VERIFY complete)
- Transient error details during a single verify pass that get resolved within the same verify call
- Progress counters not tied to the circuit-breaker (e.g., "3 of 5 lint rules passed so far")

### Circuit-breaker read guarantee (unchanged)

The hard rule from LOOP.md is preserved: at every VERIFY stage, the Agent **must** use the Read tool to read the raw `state.yaml` file to obtain the real `iteration` value. Referencing the iteration value from context memory is prohibited. This guarantees the circuit breaker checks against persisted truth, not hallucinated memory.

**A5 does NOT weaken this guarantee**: the mandatory checkpoint 2 (DESIGN success) writes the incremented iteration to disk before VERIFY runs. So when VERIFY reads state.yaml, the iteration value is already persisted and authoritative. The non-persisted fields (substage, transient progress) are not read by the circuit breaker — only `iteration` and `hard_limit_reached` are, and both are always persisted at checkpoint 2 and 3.

### Rationale

Solo-mode sessions typically push a task to completion in one go. The former behavior of writing state.yaml on every substage transition and transient progress update added disk I/O without value — the only readers of state.yaml between checkpoints are: (a) the circuit breaker at VERIFY (reads iteration, which is persisted at checkpoint 2), and (b) session resume after interruption (reads the last mandatory checkpoint, which captures enough to resume). Intermediate writes were pure overhead.
