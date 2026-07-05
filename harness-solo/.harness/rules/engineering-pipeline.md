# Engineering Pipeline

This is the single routing contract for Solo delivery. Workflows select a variant; skills own the detailed execution.

## Canonical Path

1. **Restore** — `session-start` loads active state and validates inbound handoffs. **On-demand**: skip when no active state exists and an upstream handoff is unambiguous; go straight to Plan.
2. **Foundation** — confirm `PROJECT.md`, `TECH_STACK.md`, and executable verification commands. Use `setup` only when missing.
3. **Branch Isolation** — before any code mutation, ensure work happens on a dedicated branch (not `main`/`master`) or a git worktree. **Standalone single-task workflow**: create `feature/<task-id>` per task. **Product-level nested task**: use the shared `feature/<product-task-id>` across all nested tasks (see Nested Task Switch Protocol below for the rationale and switch gates). Quick-fix may skip this when the change is single-file and low-risk.
   - **Iteration branch strategy** (subsequent delivery rounds after MVP): when a new pm-to-solo.md supersedes a previous one (batch.type: incremental) and Solo starts work on new features (AC-F06/F07), create a new branch `feature/<product-task-id>-iter-<N>` where N is the iteration number (e.g., `feature/PROD-001-iter-2`). Do NOT reuse the original `feature/<product-task-id>` branch — done is terminal, and the original branch's task state is frozen. The iteration branch is treated as a new product-level nested task workflow: new session-start/end, new spec.md files for new ACs, original done tasks remain untouched.
4. **Clarify + Plan (merged)** — `brainstorming` resolves material ambiguity, then `writing-plans` immediately consumes the resolved requirements to produce one spec + state. The two skills run as one continuous Plan stage without a pause between them unless a material user-owned decision surfaces. Skip brainstorming only when an existing valid spec or the quick-fix gate makes scope unambiguous.
   - **PLAN prerequisite (conditional)**: for refactor / migration / optimize workflows, `test-coverage` may run as a PLAN-time prerequisite (Beyonce Rule: add tests to guard existing behavior before changing it). Triggered when the target code lacks sufficient test coverage to safely restructure/migrate/optimize. This is a PLAN-stage activity — it does not consume an ACT iteration and its terminal outcome is independent of the main task's iterations.log.
5. **Attempt + inline verify-fast (merged)** — the selected ACT skill increments iteration once before mutation, executes the smallest verifiable outcome, then performs the 4 fast-verify duties inline (test validation / AC-DAC check / changed-file security scan / append terminal outcome to iterations.log). verify-fast is no longer a separate skill invocation.
6. **Verify-full** — owned by `verify`; runs once after every planned task passes inline fast verification.
7. **Code review** — reviews maintainability and resolves review feedback. Only this gate marks a delivery task `done`.
8. **Close** — `session-end` records progress, syncs the task board, refreshes baseline **only when source files changed**, and publishes only explicitly needed handoffs.

**Product orchestration (new-product-engineering)**: session-start/end run once at product level; nested features do not re-run session ceremony. Integration checkpoints are inlined into the owning nested task's verify-full rather than a separate stage.

## Nested Task Switch Protocol (product-level only)

When `current_nested_task` transitions from one nested task to the next in a product-level workflow, the orchestrator (new-product-engineering workflow, acting through session-start on resume) must execute these switch gates in order:

1. **Completion gate** — the outgoing nested task's `state.yaml` must read `status: done` (terminal). If it reads `retrying`/`needs-human`/`blocked`/`failed`, do not advance; surface the blocker. This prevents building downstream on an incomplete upstream task.
2. **Worktree cleanliness gate** — run `git status --porcelain` (or equivalent) on the outgoing task's branch. Uncommitted changes must be committed or stashed before switching. This prevents outgoing WIP from polluting the incoming task.
3. **Branch strategy** — use a single shared product branch `feature/<product-task-id>` across all nested tasks, not per-nested branches. Rationale: nested tasks in a product have interdependencies (F02 consumes F01's code), and per-nested branches would require merge-before-switch with conflict risk. The shared branch accumulates each nested task's reviewed commits; each nested task's code-review "done" commits to this branch. Quick-fix within a nested task may use a short-lived sub-branch merged back before review.
4. **Update `current_nested_task`** — only after gates 1-2 pass, overwrite `current_nested_task` in the product `state.yaml` with the incoming task ID. Append a switch record to the product-level session block in `progress.md`: `Nested switch: <outgoing> → <incoming> at <timestamp>, outgoing status: done, worktree: clean`.

This protocol is the authoritative switch mechanism; `current_nested_task` is never updated outside these gates. The workflow's `current_nested_task` field ownership (STATE_PROTOCOL.md) is exercised through this protocol on session-start resume and on nested task completion.

## State and Artifact Ownership

| Artifact / field | Sole owner |
|---|---|
| `spec.md`, initial `state.yaml` | writing-plans |
| `iteration`, `stage: act` | active ACT skill, immediately before mutation |
| `substage` (Solo only) | active ACT skill (inline-passed/inline-failed/awaiting-full) or verify (full-running/full-passed/full-failed); see Solo LOOP.md substage table |
| per-attempt terminal outcome in `iterations.log` | active ACT skill (inline verify-fast) |
| `evidence.md` (full verification) | verify |
| `review.md`, delivery-task `status: done`, AC `[status: done]` in spec.md | code-review |
| product-orchestrator `status: done` | product-engineering-review, after all nested reviews and integration checks pass |
| `.harness/FEATURES.md` aggregate status | session-end |
| `ENGINEERING_PLAN.md` scope/order | product workflow; not a second status board |
| baseline and outbound handoffs | session-end |
| retention/archive operations | memory-maintenance |

No other skill may redefine state enums, increment rules, or completion ownership.

## Workflow Variants

| Workflow | Clarify/PLAN specialization | ACT skill | Fast success condition | Recommended failed-attempt limit |
|---|---|---|---|---:|
| new-feature | product behavior and stable AC/DAC | test-driven-development | affected tests + current criteria | 5 |
| bugfix | reproducible symptom + root cause | test-driven-development | regression test + affected suite | 3 |
| refactor | behavior boundary + safety baseline | test-driven-development | behavior preserved + structural target | 3 |
| optimize | measured baseline + bottleneck | performance-optimization | benchmark improves + affected tests | 3 |
| migration | replacement/rollback/consumer order | migration | migrated consumer equivalent | 3 |
| new-product-engineering | product plan + nested tasks | per-task variant | each nested task passes its own path | per nested task |

At a recommended limit, set `needs-human` and present evidence. Continued attempts require explicit authorization and remain capped by `STATE_PROTOCOL.md`.

## Non-LOOP Paths

- **quick-fix**: low-risk, single-outcome path with scoped verification; no state file.
- **setup**: configuration initialization; no code delivery.
- **release**: validates a selected release scope, reviews release metadata/artifacts, then performs only user-authorized version/tag actions.

## Routing Rules

- A workflow describes only ordering, specialization, and gates; it does not duplicate a skill's process.
- One change uses one primary workflow. Invoke specialist skills as steps, not nested competing workflows.
- Failures route by cause: requirement/spec → PLAN; implementation/test → ACT; unknown cause → systematic-debugging; review finding → code-review response then ACT if code changes.
- `done` is terminal. Follow-up work creates a new task/spec rather than reopening a completed state file.
