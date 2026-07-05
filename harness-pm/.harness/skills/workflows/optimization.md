---
workflow_id: D
name: optimization
description: "Optimize existing products through data-driven diagnosis, iteration decisions, and solution validation"
default_mode: standard
---

# Workflow D: Data-Driven Optimization

> Applicable scenario: Existing product needs data-driven optimization of experience/performance/conversion
> Core mode: Data diagnosis → iteration decision → LOOP solution validation

## Boundary with iteration (trigger condition decision tree)

```
Have clear change requirements (user feedback/business needs/missing features)?
├── Yes → iteration (change-driven)
└── No → Have data but no clear solution?
    ├── Yes → optimization (data-driven) ← this workflow
    │   Characteristics: Have data identifying problems, but don't know how to change, need data diagnosis + solution exploration
    └── No → Need strategic-level adjustment?
        └── Yes → pivot (strategic adjustment)
```

| Dimension | iteration | optimization |
|------|-----------|--------------|
| Trigger | Clear change requirement | Data-identified problem |
| Starting point | Change impact analysis | Data diagnosis |
| Design | Change module PRD update | Optimization solution PRD + validation |
| LOOP | Data diagnosis→solution design | Solution design→validation |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm optimization goals
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 5: Data Diagnosis                │
│                                         │
│  - analysis-orchestrator                │
│    (Data analysis: anomaly detection+   │
│     funnel+retention+report)            │
│  - decision-orchestrator                │
│    (Decision loop: DACE decision cycle) │
│                                         │
│  ★ Hard gate check:                     │
│  - Is data sufficient? (Sample size/    │
│    time range)                          │
│  - Is problem located? (Root cause      │
│    analysis)                            │
│  - Is optimization direction clear?     │
│    (Data-supported)                     │
└────────┬────────────────────────────────┘
         │ Pass
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Iteration Decision            │
│                                         │
│  - iteration-orchestrator               │
│    (Backlog optimization + iteration    │
│     retrospective)                      │
│  - Determine optimization solution      │
│    priority                             │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│              LOOP Validation            │
│  ┌─────────────────────────────────┐    │
│  │ Module 3: Solution Design       │    │
│  │   (RESEARCH)                    │    │
│  │  - prd-orchestrator             │    │
│  │    (PRD update for optimization │    │
│  │     solution)                   │    │
│  │  - validation-orchestrator      │    │
│  │    (Validation: hypothesis map+ │    │
│  │     experiment+usability)       │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ VALIDATE                        │    │
│  │  - Optimization solution data-  │    │
│  │    supported                    │    │
│  │  - PRD quality gate             │    │
│  │  - Human approval               │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail → back to RESEARCH ─┘
│                                          │
│  Iteration limit: 3 times (iteration type)│
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│ session-end     │  Archive + update FEATURES.md
│                 │  + Output docs/handoff/pm-to-engineering.md (optimization solution handoff to engineering)
│                 │  + Record data insights to memory/knowledge-base.md
└─────────────────┘
```

## Key Checkpoints

- [ ] Data diagnosis has conclusions? (Root cause analysis, not surface symptoms)
- [ ] Optimization solution data-supported? (Based on analysis, not gut feeling)
- [ ] Optimization solution validated? (Hypothesis map/experiment/usability)
- [ ] Human approved?

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Insufficient data | Supplement data collection, wait for sufficient data before optimizing |
| Root cause unclear | Deep analysis, don't optimize surface symptoms |
| LOOP iteration exceeds 3 times | Request human intervention |

## Next Steps

- Optimization solution needs release → enter **launch** workflow
- Optimization involves strategic adjustment → enter **pivot** workflow
- After optimization, have clear change requirements → enter **iteration** workflow
