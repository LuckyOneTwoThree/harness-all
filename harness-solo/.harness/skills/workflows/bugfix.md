---
workflow_id: C
name: bugfix
description: "Fix production bugs through systematic debugging, root cause analysis, and TDD-driven iterative repair"
default_mode: standard
---

# Workflow bugfix

> Applicable scenario: Fix production bugs, test failures, feature anomalies
> Core mode: systematic-debugging to find root cause → LOOP iterative fix → code-review

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm bug symptoms
└────────┬────────┘
         ▼
┌──────────────────────┐
│ systematic-debugging │  ★ Root cause analysis
│                      │  - Write reproduction test
│                      │  - Bisection to locate
│                      │  - 5 Whys to find root cause
│                      │  - Record to knowledge-base.md
└────────┬─────────────┘
         │ Root cause found
         ▼
┌─────────────────────────────────────────┐
│              LOOP iterative fix         │
│  ┌─────────────────────────────────┐    │
│  │ test-driven-development (ACT)   │    │
│  │  Reproduction test ready →      │    │
│  │  fix root cause                 │    │
│  │  Red (reproduce) → Green (fix)  │    │
│  │  → Refactor                     │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ verify (VERIFY)                 │    │
│  │  Reproduction test passes +     │    │
│  │  full test suite no regression  │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail                     │
│                   │                      │
│                   ▼                      │
│  ┌─────────────────────────────────┐    │
│  │ systematic-debugging            │    │
│  │  Re-analyze root cause          │    │
│  │  (last attempt was wrong)       │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             └── Back to tdd ─────────────┘
│                                          │
│  Iteration cap: 3 (bugfix type)         │
│  Exceeded → request human intervention  │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────┐
│ requesting-code-review │  Review fix quality
│                       │  - Did the fix introduce new issues
│                       │  - Are there similar issues to fix together
└──────────┬────────────┘
           │ Passed
           ▼
┌─────────────────┐
│ session-end     │  Archive + baseline
└─────────────────┘
```

## Differences from New Feature Development

| Dimension | New Feature | Bug Fix |
|------|--------|---------|
| Prerequisite | brainstorming (requirements exploration) | systematic-debugging (root cause analysis) |
| LOOP cap | 5 | 3 |
| tdd starting point | Write tests from acceptance criteria | Write tests from bug reproduction |
| verify focus | AC satisfied | Reproduction passes + no regression |
| code-review focus | Design quality | Whether the fix is thorough, whether similar issues exist |

## Key Checkpoints

- [ ] Can the bug be reliably reproduced? (Cannot reproduce = not yet understood)
- [ ] Are you finding the root cause or just symptoms? (5 Whys at least 3 times)
- [ ] Was the reproduction test written?
- [ ] Was the full test suite run? (Confirm no regression)
- [ ] Were similar issues checked? (The same root cause may exist elsewhere)
- [ ] Was the lesson recorded in knowledge-base.md?
- [ ] Were regression tests added? (Use the `test-coverage` skill to add regression tests for similar issues)

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| Cannot reliably reproduce | Don't start fixing; keep observing / add logging |
| LOOP iterations exceed 3 | Root cause was wrong; request human intervention |
| Fix introduces new issues | Roll back and re-analyze root cause |
| Multiple similar issues found | Fix them together; don't fix one and miss another |
