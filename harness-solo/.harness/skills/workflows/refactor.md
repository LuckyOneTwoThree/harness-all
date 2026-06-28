---
workflow_id: D
name: refactor
description: "Refactor existing code to improve structure without changing external behavior, with test safety nets"
default_mode: standard
---

> **Default mode is `standard`.** For ambiguous requirements or new architecture, switch to `deep` mode. For trivial changes under 10 lines, use the `quick-fix` workflow instead.

# Workflow refactor

> Applicable scenario: Improve existing code structure without changing external behavior
> Core mode: brainstorming to confirm boundaries → LOOP (tdd safety net + verify no regression) → code-review

## Differences from New Feature / Bug Fix

| Dimension | New Feature | Bug Fix | Refactoring |
|------|--------|---------|------|
| Prerequisite | brainstorming (requirements exploration) | systematic-debugging (root cause analysis) | brainstorming (confirm refactoring boundaries) |
| TDD starting point | Write new tests from AC | Write tests from bug reproduction | **Build a safety net from existing tests** |
| verify focus | AC satisfied | Reproduction passes + no regression | **Full test suite no regression + complexity reduction** |
| LOOP cap | 5 | 3 | 3 (refactor type) |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm refactoring goals
└────────┬────────┘
         ▼
┌─────────────────┐
│ brainstorming   │  ★ Hard gate: refactoring boundaries must be clear
│                 │  - Refactor what? Why?
│                 │  - What behavior not to change? (boundaries)
│                 │  - Success criteria: tests don't regress + complexity drops
└────────┬────────┘
         │ Passed
         ▼
┌─────────────────┐
│ writing-plans   │  Task breakdown
│                 │  - Each step should be small (2-5 minutes)
│                 │  - Run the full test suite after each step
│                 │  - Output spec.md (with "no behavior change" boundaries)
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│              LOOP iterative refactoring │
│  ┌─────────────────────────────────┐    │
│  │ Pre-step: build test safety net │    │
│  │  - Run full test suite, confirm │    │
│  │    currently all green          │    │
│  │  - If tests are incomplete,     │    │
│  │    call test-coverage skill to  │    │
│  │    add tests before refactoring │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ test-driven-development (ACT)   │    │
│  │  - Route by task type (absorbs  │    │
│  │    executing-plans scheduling)  │    │
│  │  - Change structure, not        │    │
│  │    behavior                     │    │
│  │  - Run tests immediately after  │    │
│  │    each change                  │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ verify (VERIFY)                 │    │
│  │  - Full test suite no regression│    │
│  │    (mandatory)                  │    │
│  │  - Complexity metrics down      │    │
│  │    (entropy check)              │    │
│  │  - Behavior equivalence confirm │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail                     │
│                   │                      │
│                   ▼                      │
│  ┌─────────────────────────────────┐    │
│  │ systematic-debugging            │    │
│  │  - Roll back changes, re-analyze│    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             └── Back to tdd ─────────────┘
│                                          │
│  Iteration cap: 3 (refactor type)       │
│  Exceeded → request human intervention  │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────┐
│ requesting-code-review │  Review refactoring quality
│                       │  - Did structure improve
│                       │  - Was behavior preserved
│                       │  - Was readability improved
└──────────┬────────────┘
           │ Passed
           ▼
┌─────────────────┐
│ session-end     │  Archive + baseline + update FEATURES.md
└─────────────────┘
```

## Key Checkpoints

- [ ] Are the refactoring boundaries clear? (What to change, what behavior not to change)
- [ ] Was the full test suite green before refactoring? (Don't start if not green)
- [ ] Is the test safety net sufficient? (Core paths have test coverage)
- [ ] Did you run tests after every structural change?
- [ ] Did complexity drop after refactoring? (Entropy check)
- [ ] Didn't sneak in new features, right? (Refactoring ≠ adding features)

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| Tests not all green before refactoring | Add tests or fix bugs first; don't refactor on top of red |
| Test regression after refactoring | Immediately roll back changes and re-analyze |
| Refactoring introduces new features | Stop immediately; split new features into a new spec.md |
| LOOP iterations exceed 3 | Refactoring direction may be wrong; request human intervention |

## Refactoring Safety Principles

1. **Small steps, fast feedback**: Change one thing at a time; run tests immediately after each change
2. **Keep tests green**: Tests should be green at all times; roll back immediately if red
3. **No new features**: Don't add new features during refactoring; if you find one is needed, record it as a TODO and open a new spec after refactoring
4. **Behavior equivalence**: External observable behavior unchanged (API signatures, outputs, side effects)
