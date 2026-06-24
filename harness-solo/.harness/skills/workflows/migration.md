---
workflow_id: F
name: migration
description: "Migrate code, frameworks, or APIs through incremental replacement with zero-usage verification and cleanup"
default_mode: standard
---

# Workflow E: Code Migration

> Applicable scenario: Framework/library major version upgrades, API migrations, data migrations, removing deprecated code
> Core mode: migration (build replacement → incremental migration → verify zero usage → remove) + LOOP (refactor loop guards no regression)

## Differences from Other Workflows

| Dimension | refactor | **migration** |
|------|----------|--------------|
| Goal | Improve structure, don't change behavior | Replace system / upgrade framework, behavior equivalent |
| Prerequisite | brainstorming to confirm boundaries | **migration decision hard gate + brainstorming** |
| Tests | Build safety net | **test-coverage adds safety net + migration guide** |
| After LOOP | code-review | **Verify zero active usage → remove old system** |
| LOOP cap | 3 | 3 (refactor type) |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm migration goals
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ migration — migration decision hard gate│
│                                         │
│  - Does the old system still have       │
│    unique value?                        │
│  - How many consumers depend on it?     │
│    (Grep for call sites)                │
│  - Does a replacement exist? If not →   │
│    build one first (new-feature)        │
│  - Migration cost vs 2-3 year           │
│    maintenance cost?                    │
│  - Is test coverage sufficient? If not →│
│    use test-coverage to add             │
│                                         │
│  ★ If any is not met → don't migrate    │
└────────┬────────────────────────────────┘
         │ Decision passed
         ▼
┌─────────────────┐
│ brainstorming   │  Confirm migration boundaries
│                 │  - Migrate what? Why?
│                 │  - What behavior not to change?
│                 │  - Pick a strategy: Strangler/Adapter/Flag
└────────┬────────┘
         │ Passed
         ▼
┌─────────────────┐
│ writing-plans   │  Task breakdown
│                 │  - Migrate one consumer at a time
│                 │  - Run full test suite after each step
│                 │  - Output spec.md + migration guide
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│              LOOP iterative migration   │
│  ┌─────────────────────────────────┐    │
│  │ executing-plans (scheduler)     │    │
│  │  Advance per task sequence,     │    │
│  │  checkpoint per task            │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ migration (ACT) — incremental   │    │
│  │  migration                      │    │
│  │  - Point one consumer at a time │    │
│  │    to the new system            │    │
│  │  - Run full test suite, behavior│    │
│  │    matches                      │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ verify (VERIFY)                 │    │
│  │  - Full test suite no regression│    │
│  │    (mandatory)                  │    │
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
│  │  - Behavior not equivalent,     │    │
│  │    find root cause              │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             └── Back to migration ───────┘
│                                          │
│  Iteration cap: 3 (refactor type)       │
│  Exceeded → request human intervention  │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ migration — verify zero active usage    │
│                                         │
│  ★ Without zero-active-usage evidence,  │
│    don't delete old code                │
│                                         │
│  - Grep for old API call sites → should │
│    be 0                                 │
│  - Check whether configs/env vars       │
│    reference the old system             │
│  - If metrics exist, confirm zero       │
│    active traffic                       │
└────────┬────────────────────────────────┘
         │ Zero usage confirmed
         ▼
┌─────────────────────────────────────────┐
│ migration — remove the old system       │
│                                         │
│  - Delete old code + old tests + old    │
│    docs + config                        │
│  - Run full test suite, confirm no      │
│    regression                           │
│  - Update docs/engineering/TECH_STACK.md│
│  - Write an ADR recording the migration │
│    decision (supersede the old one)     │
└────────┬────────────────────────────────┘
         │
         ▼
┌─────────────────────┐
│ requesting-code-    │  Review migration quality
│ review              │  - Was behavior preserved
│                     │  - Was the old system cleaned up
│                     │  - Is the migration guide complete
└──────────┬──────────┘
           │ Passed
           ▼
┌─────────────────┐
│ session-end     │  Archive + baseline
└─────────────────┘
```

## Key Checkpoints

- [ ] Did the migration decision hard gate pass? (All 5 conditions met)
- [ ] Is the replacement built? (Don't deprecate the old system without one)
- [ ] Is the test safety net sufficient? (If not, run test-coverage first to add)
- [ ] Are you migrating one consumer at a time? (Batch changes can't be attributed)
- [ ] Did you run the full test suite after each migration?
- [ ] Was zero active usage verified? (**Don't delete old code without evidence**)
- [ ] Were old code/tests/docs/config all cleaned up?
- [ ] Was an ADR written for the migration decision?

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| Decision hard gate not passed | Don't migrate; evaluate alternative options |
| Replacement doesn't exist | Run the new-feature workflow first to build the replacement |
| Test safety net insufficient | Run the test-coverage skill first to add tests |
| Behavior not equivalent | Roll back; run systematic-debugging to find root cause |
| Zero-usage verification failed | Consumers still in use; continue migrating or keep the old system |
| LOOP iterations exceed 3 | Migration strategy may be wrong; request human intervention |

## Data Migration Specifics

Data migrations (DB schema / data format) have additional requirements:
- **Must generate a migration script** (required by constitution.md)
- The migration script must have a rollback script
- Test on backed-up data first
- For large data volumes, migrate in batches and validate each batch

## Safety Principles

1. **Build before deprecating**: Don't deprecate the old system without a replacement
2. **Delete only at zero usage**: Don't delete old code without zero-active-usage evidence
3. **Incremental migration**: One consumer at a time; can roll back at any time
4. **Behavior equivalence**: External observable behavior unchanged (API signatures, outputs, side effects)
5. **Data is rollback-able**: Data migrations must have a rollback script
