# Engineering Pipeline

This is the single routing contract for Solo delivery. Workflows select a variant; skills own the detailed execution.

## Canonical Path

1. **Restore** — `session-start` loads active state and validates inbound handoffs.
2. **Foundation** — confirm `PROJECT.md`, `TECH_STACK.md`, and executable verification commands. Use `setup` only when missing.
3. **Clarify** — `brainstorming` resolves material ambiguity. Skip only when an existing valid spec or the quick-fix gate makes scope unambiguous.
4. **Plan** — `writing-plans` creates one spec and initializes one state file.
5. **Attempt** — the selected ACT skill increments iteration once before mutation, then executes the smallest verifiable outcome.
6. **Verify-fast** — validates the current attempt and routes failure. It may reuse fresh test output from the same attempt; resumed work reruns it.
7. **Verify-full** — runs once after every planned task passes fast verification.
8. **Code review** — reviews maintainability and resolves review feedback. Only this gate marks a delivery task `done`.
9. **Close** — `session-end` records progress, updates the task board, refreshes the baseline, and publishes only explicitly needed handoffs.

## State and Artifact Ownership

| Artifact / field | Sole owner |
|---|---|
| `spec.md`, initial `state.yaml` | writing-plans |
| `iteration`, `stage: act` | active ACT skill, immediately before mutation |
| verification evidence, verify outcome log | verify |
| `review.md`, delivery-task `status: done` | code-review |
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
