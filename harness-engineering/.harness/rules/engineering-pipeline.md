# Engineering Pipeline

The single routing contract for 4-phase engineering delivery. Phases are sequential checkpoints; each phase owns its own PLAN → ACT → VERIFY loop and pauses for user confirmation before the next phase begins.

## Phase Catalog

| Phase | ID | Consumes | Produces | ACT skill sequence |
|---|---|---|---|---|
| 0 | design-intake | upstream design assets, PRD | `contract.json`, `tokens.json`, `phase-0-design-intake-report.md` | design-intake |
| 1 | frontend | contract + tokens + assets | frontend code, `phase-1-frontend-report.md` | frontend-implementation → test-driven-development |
| 2 | backend | API contract (from phase 0/1) | backend implementation, `phase-2-backend-report.md` | data-layer → api-implementation → test-driven-development |
| 3 | integration | frontend + backend (mock→real) | e2e verification, `phase-3-integration-report.md` | mock-to-real-switch → contract-verify → e2e-verification → verify |

> Phase 2 ACT sequence: `data-layer` runs first (schema + ORM + migrations, produces BAC IDs for entity behaviors), then `api-implementation` (endpoints + auth + error codes, produces BAC IDs for API behaviors), then `test-driven-development` runs as the default ACT owner for any remaining behavior changes. Each runs its own inline verify-fast; `verify` runs verify-full once for the whole phase.
>
> Phase 3 ACT sequence: `mock-to-real-switch` flips the config (produces IAC IDs for the switch), then `contract-verify` checks frontend ↔ backend ↔ PRD consistency (produces IAC IDs for contract consistency), then `e2e-verification` runs AC-driven user flows (produces IAC IDs for end-to-end flows), then `verify` runs verify-full once for the whole phase.

## Canonical Phase Path

For each phase N in the active set (phases 1-3):

1. **Entry check** — verify the phase's preconditions (see Phase Entry Gates). If a prior phase is unconfirmed, halt and surface the missing confirmation.
2. **Plan** — `brainstorming` (only when material ambiguity exists) → `writing-plans` produces a phase-scoped spec. Phase 0 plan consumes design assets; phases 1-3 plan consumes the prior phase's report.
3. **Act** — the phase's ACT skill sequence (see Phase Catalog) increments `iteration` once before mutation, executes the smallest verifiable outcome, and runs inline verify-fast (test validation / AC-BAC-IAC check / changed-file security scan / append terminal outcome to `iterations.log`).
4. **Verify** — `verify` runs once after all planned phase outcomes pass inline fast verification; produces `evidence.md` for the phase.
5. **Checkpoint** — write `phase-N-<phase-name>-report.md` to `loops/specs/<task>/`; set `substage_progress[<phase>].completed = true`, `user_confirmed = false`, `report = <path>`. Set `status: needs-human`. Pause. Do not enter the next phase.
6. **Advance** — only after explicit user confirmation, set `substage_progress[<phase>].user_confirmed = true`, `status: running`, then enter the next phase's entry check.

### Phase 0 Exception

Phase 0 (design-intake) is a **simplified path** that does not run inside LOOP:

- **No PLAN→ACT→VERIFY→CHECKPOINT cycle**: design-intake executes its 4-step extraction process directly (classify → extract → parse → structure), not as a LOOP iteration.
- **No inline verify-fast**: design-intake does not increment `iteration` or append terminal outcomes to `iterations.log`.
- **No verify-full / no evidence.md**: design-intake does not run the `verify` skill. Phase 0's quality gate is the self-check checklist (step 7 in design-intake SKILL.md).
- **Report ownership**: design-intake writes `phase-0-design-intake-report.md` itself (not verify).
- **Checkpoint still applies**: after design-intake completes, `substage_progress.design-intake.completed = true`, `user_confirmed = false`, `report = <path>` is set, and the orchestrator pauses for user confirmation before advancing to Phase 1.

Phases 1-3 follow the full Canonical Phase Path.

`code-review` runs once after verify-full passes, before `status: done`. For multi-phase workflows (new-feature full / refactor), code-review runs at the end of Phase 3 (integration). For single-phase workflows (bugfix / optimize / migration), code-review runs within the single active phase — Phase 3 is not invoked because no cross-phase integration is needed. See the Workflow × Phase × ACT Sequence Matrix below for which workflows invoke code-review in which phase.

## Phase Entry Gates

| Phase | Precondition |
|---|---|
| design-intake | upstream design package present (or standalone-fallback waiver recorded); PROJECT.md + TECH_STACK.md confirmed |
| frontend | `substage_progress.design-intake.user_confirmed = true`; `contract.json` and `tokens.json` valid |
| backend | `substage_progress.frontend.user_confirmed = true` (when phase 1 ran) OR `substage_progress.design-intake.user_confirmed = true` (backend-only scope) |
| integration | `substage_progress.frontend.user_confirmed = true` AND `substage_progress.backend.user_confirmed = true` (for full-stack scope) |

## Phase Exit Conditions

| Phase | Exit condition |
|---|---|
| design-intake | `contract.json` + `tokens.json` valid; phase-0-design-intake-report.md cites acceptance evidence |
| frontend | affected tests pass; current AC IDs have evidence; component-bindings.json valid |
| backend | API contract implemented; affected tests pass; current BAC IDs have evidence |
| integration | mock→real migration complete; e2e suite passes; current IAC IDs have evidence; no unresolved blocking findings |

## Task Type Routing

`task_type` + `scope` selects which phases run. Skipped phases are marked `completed: true, user_confirmed: true` with `report: "skipped: <reason>"` so the checkpoint chain stays consistent.

### Workflow × Phase × ACT Sequence Matrix

| workflow (id) | task_type / scope | Phase 0 | Phase 1 | Phase 2 | Phase 3 |
|---|---|---|---|---|---|
| new-feature (B) | new-feature (full) | ✓ design-intake | ✓ frontend-impl → TDD | ✓ data-layer → api-impl → TDD | ✓ mock→real → contract-verify → e2e → verify |
| new-feature (B) | new-feature (frontend) | ✓ design-intake | ✓ frontend-impl → TDD | — | — |
| new-feature (B) | new-feature (backend) | — | — | ✓ data-layer → api-impl → TDD | — |
| new-feature (B) | incremental feature | incremental | incremental | incremental | full (always) |
| bugfix (C) | bugfix (frontend) | — | ✓ TDD (regression test + fix) | — | — (local verify + code-review, no integration phase) |
| bugfix (C) | bugfix (backend) | — | — | ✓ TDD (regression test + fix) | — (local verify + code-review, no integration phase) |
| refactor (D) | refactor | — | ✓ TDD | ✓ TDD | ✓ mock→real → contract-verify → e2e → verify |
| optimize (E) | optimize (frontend) | — | ✓ performance-optimization | — | — (local verify + code-review) |
| optimize (E) | optimize (backend) | — | — | ✓ performance-optimization | — (local verify + code-review) |
| migration (F) | migration | — | — | ✓ migration (schema + ORM + data) | — (local verify + code-review) |
| new-product-engineering (H) | orchestration | per nested task | per nested task | per nested task | per nested task + cross-feature review |

**Non-LOOP paths** (no phase routing, no task_type):
- **setup (A)**: configuration initialization; no code delivery
- **quick-fix (I)**: low-risk single-outcome path; scoped verification; no state file
- **release (G)**: validate release scope, review metadata/artifacts, and perform user-authorized version/tag actions; release-scope verify is owned by `release.md` (not the Phase 3 verify skill); no state.yaml

### Routing Rules (per cell)

- **✓**: phase runs with the ACT sequence listed in the cell
- **—**: phase is skipped (marked `completed: true, user_confirmed: true` with `report: "skipped: <reason>"`)
- **incremental**: a new task is created that consumes the prior phase report as baseline and produces a delta report. The prior confirmed phase remains terminal; it is NOT re-opened (see Routing Rules: "a confirmed phase is not re-opened; rework creates a follow-up task")
- **full (always)**: Phase 3 always runs in full because integration must re-verify the combined surface
- **per nested task**: new-product-engineering orchestrates multiple new-feature tasks; each nested task follows its own row in this matrix

### Bugfix Specialization

- A bugfix touches **exactly one phase** (frontend → Phase 1, backend → Phase 2)
- **Bugfix contract change detection**: after systematic-debugging identifies the root cause and before writing-plans, the agent must check whether the fix requires changing the API contract (path / method / request shape / response shape / status code / auth behavior). If yes, the bugfix is **upgraded to refactor workflow** — a bugfix that changes the public contract is by definition a behavior change, not a defect repair. Surface to the user: "The root-cause fix requires changing the API contract (<specific change>). This is a behavior change — upgrading to refactor workflow." Record the detection result in `memory/progress.md` regardless of upgrade outcome.
- **Bugfix verify-full + code-review**: bugfix runs verify-full and code-review **within its single phase** (not as Phase 3). The phase's verify step writes evidence; code-review writes review.md and marks `status: done`. Phase 3 (integration) is not invoked because no cross-phase integration is needed for a single-phase defect repair.

### Optimize Specialization

- Optimize touches **exactly one phase** (frontend → Phase 1, backend → Phase 2)
- The ACT owner is `performance-optimization` (specialist ACT), not the default ACT sequence
- verify-full + code-review run within the single phase, same as bugfix

### Incremental Feature Specialization

- "incremental feature" is a mode of the new-feature workflow (not a separate workflow)
- Phases that already produced a confirmed report run in incremental mode (new task + delta report)
- Phase 3 always runs in full because integration must re-verify the combined surface

## Session Interrupt Recovery

On `session-start` resume, read `state.yaml` `substage_progress` in phase order (0 → 1 → 2 → 3):

1. Find the lowest-numbered phase where `completed = false` and the phase is in the active set. Resume there.
2. If a completed phase has `user_confirmed = false`, surface the pending checkpoint and wait. Do not auto-advance.
3. If a phase has `completed = true, user_confirmed = true` but the next active phase has `completed = false`, enter the next phase's entry check.
4. If the breaker is active (`hard_limit_reached: true`), do not resume any LOOP stage; surface the breaker.

Resume order: (a) product state → `current_nested_task`; (b) nested task state → exact phase + LOOP position; (c) FEATURES.md → aggregate status.

## Checkpoint Discipline

- A `phase-N-<phase-name>-report.md` is the only artifact that satisfies a checkpoint. Verbal confirmation is insufficient.
- `user_confirmed` flips from `false` to `true` only on an explicit user message ("confirm phase N", "proceed", etc.).
- After confirmation, the orchestrator does not re-run the prior phase. A confirmed phase is terminal for that phase; rework creates a follow-up task.
- If the user rejects a checkpoint, set `substage_progress[<phase>].completed = false`, append the rejection reason to `iterations.log`, and route back to that phase's PLAN.

## Non-LOOP Paths

- **quick-fix**: low-risk, single-outcome path with scoped verification; no state file, no phase routing.
- **setup**: configuration initialization; no code delivery.
- **release**: validate release scope, review metadata/artifacts, perform only user-authorized version/tag actions.

## Routing Rules

- One change uses one primary workflow. Phases are sequential; do not run two phases in parallel within one task.
- Failure routes by cause: requirement/spec → phase PLAN; implementation/test → phase ACT; unknown cause → systematic-debugging; review finding → code-review response then ACT.
- `done` is terminal. Follow-up work creates a new task/spec.
- Phase-level `done` (checkpoint confirmed) is also terminal: a confirmed phase is not re-opened; rework creates a follow-up task.

## Contract Deviation Protocol

When any phase (1 / 2 / 3) discovers that `contract.json` (Phase 0 output) needs to deviate from the original design contract — whether due to engineering impracticality (a component property is impractical, an entity field type is wrong, a token value is inaccessible) or user manual adjustments during review — the agent must follow this protocol — **silent deviation is prohibited**.

1. **Detect** — the ACT skill (or the user, who informs the agent) identifies the deviation: which `component_id` / `entity_id` / token needs to change, and why.
2. **Classify** — determine the deviation severity:
   - **Minor** (token value adjustment, property default change, non-breaking field addition): does not affect downstream consumers.
   - **Major** (component property removed/renamed, entity field removed/retyped, breaking API shape change): affects downstream consumers. Requires user approval.
3. **Record** — append a deviation entry to `contract.json.deviations[]` (NOT to `memory/progress.md`) with: stable ID (`DEV-<task>-<N>`), `field` (dotted path to affected contract field), `reason`, `severity`, `detected_at_phase` (1/2/3), and optional `proposed_change`. The `deviations[]` array is the single source of truth — downstream phases and session-end read it directly, no second-copy sync needed.
4. **Update contract.json** — for Minor deviations, the ACT skill updates the affected contract field directly and re-validates against `component-contract.schema.json`. For Major deviations, the agent surfaces to the user: "Contract deviation DEV-xxx requires changing <field>. This is a breaking change — approve?" Only after user approval does the agent update `contract.json`.
5. **Propagate** — because deviations live in `contract.json.deviations[]`, downstream phases that already read `contract.json` (Phase 2 data-layer/api-implementation, Phase 3 contract-verify) automatically see them. Still, surface concrete deviations in the phase report's `## Downstream notes` section so the next phase knows where to look.
6. **Phase 3 reconciliation** — `contract-verify` in Phase 3 cross-checks the final `contract.json` (including `deviations[]`) against both frontend implementation and backend implementation. Deviations already recorded in `deviations[]` are recognized as intentional; only unrecorded drift surfaces as a `mismatch` finding.
7. **Phase 3 special case** — if the user directs the agent to adjust the contract during Phase 3 (after contract-verify or even after verify-full), the agent MUST: (a) record the DEV entry in `contract.json.deviations[]` before making the change; (b) update `contract.json` and re-validate; (c) re-run `contract-verify` to confirm the new contract is consistent across frontend/backend/PRD-pointer; (d) if verify-full already passed, re-run verify-full for the affected scope; (e) record the deviation in `phase-3-integration-report.md` `## Downstream notes`.

This protocol ensures contract changes are explicit, recorded, and propagated — never silent. The single source of truth is `contract.json.deviations[]`; downstream phases and PM handoff both read from it.

## State and Artifact Ownership

| Artifact / field | Sole owner |
|---|---|
| `spec.md`, initial `state.yaml` | writing-plans |
| `iteration`, `stage: act` | active ACT skill, before mutation |
| `substage` (engineering) | active ACT skill or verify (see LOOP.md substage table) |
| `substage_progress[<phase>].completed`, `.report` | the phase's verify step |
| `substage_progress[<phase>].user_confirmed` | orchestrator on user confirmation |
| `phase-N-<phase-name>-report.md` | the phase's verify step |
| per-attempt terminal outcome in `iterations.log` | active ACT skill (inline verify-fast) |
| `evidence.md` | verify |
| `review.md`, delivery-task `status: done` | code-review (after verify-full; phase 3 for multi-phase workflows, single active phase for single-phase workflows) |
| `.harness/FEATURES.md` aggregate status | session-end |
| baseline and outbound handoffs | session-end |
