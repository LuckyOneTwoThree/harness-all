---
workflow_id: E
name: optimize
description: "Optimize performance through measurement, bottleneck identification, and guarded iterative fixes"
default_mode: standard
---

# Workflow optimize

> Applicable scenario: Users report performance issues, benchmarks not met, Web Vitals degraded
> Core mode: performance-optimization (measure→fix→verify→guard) + LOOP (optimize loop)

## Differences from Other Workflows

| Dimension | new-feature | bugfix | refactor | **optimize** |
|------|-------------|--------|----------|------------|
| Prerequisite | brainstorming | systematic-debugging | brainstorming | **performance-optimization (MEASURE+IDENTIFY)** |
| TDD starting point | Write tests from AC | Write tests from reproduction | Build safety net | **Benchmarks guard against behavior regression** |
| verify focus | AC satisfied | Reproduction passes + no regression | Tests no regression + complexity drop | **Metrics improved + tests no regression** |
| LOOP cap | 5 | 3 | 3 | 3 (optimize type) |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm performance issues
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ performance-optimization                │
│                                         │
│  1. MEASURE — establish baseline        │
│     - Backend: QPS / P95 / P99 / memory │
│     - Frontend: Lighthouse / web-vitals │
│     - Record to evidence.md             │
│                                         │
│  2. IDENTIFY — locate the real bottleneck│
│     - Use profiler to find hotspots     │
│     - Only fix bottlenecks proven by    │
│       measurement                       │
│     - Don't fix "I think it's slow"     │
└────────┬────────────────────────────────┘
         │ Bottleneck found
         ▼
┌─────────────────────────────────────────┐
│              LOOP iterative optimization│
│  ┌─────────────────────────────────┐    │
│  │ performance-optimization (ACT)  │    │
│  │  FIX — fix only this one        │    │
│  │  bottleneck                     │    │
│  │  One change at a time (cannot   │    │
│  │  attribute effects otherwise)   │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ verify-fast (VERIFY, per iter)  │    │
│  │  - Re-test the same way,        │    │
│  │    compare before/after         │    │
│  │  - Full test suite no regression│    │
│  │    (mandatory)                  │    │
│  │  - No improvement → back to     │    │
│  │    IDENTIFY                     │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail                     │
│                   │                      │
│                   ▼                      │
│  ┌─────────────────────────────────┐    │
│  │ systematic-debugging            │    │
│  │  - Bottleneck misidentified,    │    │
│  │    re-analyze                   │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             └── Back to MEASURE/IDENTIFY ──┘
│                                          │
│  Iteration cap: 3 (optimize type)       │
│  Exceeded → request human intervention  │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│ verify-full     │  LOOP exit gate
│ Full test suite │  + comprehensive checks
│ + security scan │
└────────┬────────┘
         │
         ▼
┌─────────────────────┐
│ performance-optim.  │  GUARD against regression
│  - Add regression   │  - Benchmarks into CI
│    tests/monitoring │  - Lighthouse CI
│  - bundle size check│
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ requesting-code-    │  Review optimization quality
│ review              │  - Is the optimization effective
│                     │  - Is it over-optimized
│                     │  - Did readability drop
└──────────┬──────────┘
           │ Passed
           ▼
┌─────────────────┐
│ session-end     │  Archive + baseline
└─────────────────┘
```

## Key Checkpoints

- [ ] Are there baseline numbers? (None = not measured; don't change)
- [ ] Is the bottleneck profiler-confirmed or a guess?
- [ ] Did you change only one bottleneck at a time?
- [ ] Did you re-test the **same way** after optimization?
- [ ] Did you run the full test suite? (Behavior doesn't regress)
- [ ] Were the improvement numbers written to evidence.md? (before/after comparison)
- [ ] Did you add regression guards?
- [ ] Is it constitution-compliant? (Did the optimization introduce new dependencies? Did it violate project-specific clauses?)

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| Changed without a baseline | Stop; do MEASURE first |
| Changed but no improvement | Back to IDENTIFY to re-locate (wrong bottleneck fixed) |
| Test regression after optimization | Immediately roll back; correct behavior > performance |
| LOOP iterations exceed 3 | Bottleneck may not be at the code level; request human intervention |

## Safety Principles

1. **Behavior unchanged is the bottom line**: Performance optimization is a subset of refactoring; external observable behavior must not change
2. **No over-optimization**: Only optimize when a profile proves it's needed; don't pre-optimize for "might be slow"
3. **Don't trade readability for performance**: Unless numbers prove it's a critical bottleneck, avoid clever tricks
4. **One bottleneck at a time**: Changing multiple makes it impossible to attribute which one was effective
