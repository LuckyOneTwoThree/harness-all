# Solo LOOP

Solo uses one persisted PLAN → ACT → VERIFY loop. Routing is defined in `.harness/rules/engineering-pipeline.md`; shared counting and breaker semantics are defined in `STATE_PROTOCOL.md`; `state.schema.json` is the machine-readable state shape.

## Core Loop

```text
PLAN (spec + task) → ACT (one attempt) → VERIFY-FAST
        ↑                    │                 │
        └── replan ──────────┴── fail by cause┘
                                             │ pass all tasks
                                             ▼
                                     VERIFY-FULL → CODE-REVIEW → DONE
```

## Loop Types

| Type | ACT owner | Recommended failed-attempt limit | Success condition |
|---|---|---:|---|
| feature | test-driven-development | 5 | stable criteria satisfied |
| bugfix | test-driven-development | 3 | regression reproduced then fixed |
| refactor | test-driven-development | 3 | behavior preserved and target improved |
| optimize | performance-optimization | 3 | benchmark target met without regression |
| migration | migration | 3 | behavior equivalent and old usage removed safely |

The recommended limit is an escalation point, not a second breaker. Further attempts require explicit user authorization. The hard cap and attempt-10 behavior come only from `STATE_PROTOCOL.md`.

## Attempt Lifecycle

1. Read raw `state.yaml`; reject terminal state or active breaker.
2. If `iteration >= 10`, do not start another ACT.
3. Increment iteration exactly once and persist `stage: act`, `status: running` before mutation.
4. Execute one independently verifiable outcome.
5. Run verify-fast. It writes the attempt's single terminal outcome to `iterations.log`.
6. Failure routes to ACT, PLAN, or systematic-debugging without another increment. The next ACT increments when it actually begins.
7. After all tasks pass, run verify-full once, then code-review.

## Persistent Artifacts

```text
loops/specs/<task>/
├── spec.md       # current approved plan; overwrite on explicit replan
├── state.yaml    # current state; overwrite
├── evidence.md   # final verification evidence; verify owns it
├── review.md     # final review and responses; code-review owns it
└── iterations.log# append-only attempt/review/reset events
```

Do not use evidence.md as an ACT scratchpad. Actual Red/Green output may be reused by the ACT skill's inline verify-fast only when it is still present in the same execution context and the command, code, and attempt have not changed; otherwise rerun.

## State Responsibilities

| Field | Plan | ACT skill | Verify | Code review | Debug |
|---|---:|---:|---:|---:|---:|
| task/start/mode | initialize | — | — | — | — |
| iteration | `0` | increment before ACT | never | never | never |
| stage | `plan` | `act` | `verify` | `review` | `debug` |
| status | `running` | running/retrying | running/retrying/needs-human/failed | done/retrying/needs-human | retrying/needs-human |
| last error | clear | observed ACT failure | observed gate failure | blocking finding | root cause |

`done` belongs exclusively to code-review. Verify-full success means “verified and awaiting review”, represented by `stage: verify`, `status: running`.

## Product Orchestration

Product-level state stores only the current nested task. Aggregate feature status lives in `.harness/FEATURES.md`; `ENGINEERING_PLAN.md` remains the approved scope, dependency graph, and execution order. Do not maintain duplicate aggregate-progress fields or mutable status columns in all three files.

Resume order:

1. product state → `current_nested_task`;
2. nested task state → exact LOOP position;
3. FEATURES.md → aggregate completion/dependency status.

## Failure Routing

| Cause | Route |
|---|---|
| incorrect/ambiguous requirement | brainstorming or writing-plans |
| known implementation/test defect | next ACT attempt |
| unknown root cause | systematic-debugging |
| upstream design/product contract defect | block and produce feedback; do not guess |
| recommended limit reached | `needs-human`; show attempts and alternatives |
| failed attempt 10 / attempt 11 requested | hard breaker per STATE_PROTOCOL.md |
| code-review change required | code-review records response, then re-enter ACT |

## Completion Gate

A task is complete only when:

- every planned stable AC/DAC has cited evidence;
- verify-full passes with actual command output;
- code-review has no unresolved blocking findings;
- `review.md` exists and code-review writes `status: done`;
- session-end synchronizes the task board.
