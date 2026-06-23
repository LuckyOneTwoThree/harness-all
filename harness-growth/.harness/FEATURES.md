# FEATURES.md — Growth task/experiment status board

> Dynamic status tracking (updated during operations).
> Division of labor with GROWTH_STRATEGY.md: GROWTH_STRATEGY.md is a static definition (written at project initiation), while this file is dynamic status (updated during operations).
> Update trigger: after the measure skill passes, change the corresponding experiment status to done.

## Skill build progress

| Module | Total | Built | Status |
|------|------|------|------|
| Meta | 4 | 4 | ✅ Complete |
| Module 1 Growth Strategy | 5 | 5 | ✅ Complete |
| Module 2 Growth Experiments | 6 | 6 | ✅ Complete |
| Module 3 Content Marketing | 5 | 5 | ✅ Complete |
| Module 4 SEO Optimization | 5 | 5 | ✅ Complete |
| Module 5 User Operations | 5 | 5 | ✅ Complete |
| Module 6 Acquisition | 3 | 3 | ✅ Complete |
| Module 7 Monetization | 3 | 3 | ✅ Complete |
| Module 8 Data Analysis | 3 | 3 | ✅ Complete |
| Module 9 Growth Review | 1 | 1 | ✅ Complete |
| **Total** | **40** | **40** | ✅ All complete |

## Workflow build progress

| Workflow | Status |
|----------|------|
| growth-experiment-workflow | ✅ Built |
| growth-review-workflow | ✅ Built |
| content-marketing-workflow | ✅ Built |
| seo-optimization-workflow | ✅ Built |
| lifecycle-operations-workflow | ✅ Built |
| growth-strategy-workflow | ✅ Built |

## Experiment/task status

| ID | Experiment/task | Priority | Status | Last updated | Note |
|------|----------|--------|------|---------|------|
| G-001 | [experiment/task name] | P1 | pending | | |

## Status definitions

- `pending` — not started
- `in_progress` — in progress (corresponding loops/specs/ has state.yaml)
- `review` — measure passed, awaiting growth review
- `done` — fully complete (growth review passed, conclusions archived)
- `blocked` — blocked (explain the reason)

## Update rules

1. **Start experiment**: change status to `in_progress`, create `loops/specs/<experiment>/`
2. **measure passed**: change status to `review`
3. **Growth review passed**: change status to `done`, write conclusions to knowledge-base.md
4. **session-end batch update**: scan experiments with status:done in `loops/specs/*/state.yaml`, batch sync to this file
