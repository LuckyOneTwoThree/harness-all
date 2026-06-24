---
workflow_id: F
name: diagnosis
description: "Diagnose product health decline and competitor threats, with optional product sunset planning"
default_mode: skip
---

# Workflow F: Product Diagnosis & Sunset

> Applicable scenario: Product health decline, competitor threat tracking, product sunset decision
> Core mode: Call diagnosis-orchestrator to complete diagnosis → human approval → downstream connection

## Differences from Other Workflows

| Dimension | optimization | health-check | **diagnosis** |
|------|--------------|--------------|---------------|
| Goal | Data-driven optimization | Periodic checkup | **Reactive diagnosis/sunset decision** |
| Trigger | Proactive optimization | Periodic | **Reactive (health decline/competitor moves/sunset need)** |
| Depth | Solution design + validation | Quick checkup | **Deep diagnosis + sunset plan** |
| LOOP | research→validate | None | **None (diagnosis-focused, sunset plan requires human approval)** |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm diagnosis trigger reason
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Product Diagnosis             │
│                                         │
│  - diagnosis-orchestrator               │
│    (Internally schedules 4 phases:      │
│     health diagnosis → competitor       │
│     tracking → competitor monitoring    │
│     report → product sunset plan        │
│     [conditional])                      │
│                                         │
│  Trigger scenario determines which       │
│  phases execute:                        │
│  - Health decline → phase 1-3           │
│  - Competitor moves → phase 2-3         │
│  - Sunset need → phase 1-4              │
│  - Periodic check → phase 1             │
│                                         │
│  Output: docs/monitoring/diagnosis-report.md │
└────────┬────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Human Decision Point (★ must approve)   │
│                                         │
│ - Health score calibration (when        │
│   deviation >±10%)                      │
│ - Competitor monitoring report          │
│   confirmation (threat assessment +     │
│   response suggestions)                 │
│ - Product sunset plan confirmation      │
│   (timeline + migration plan)           │
└────────┬────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Downstream Connection (choose based on  │
│   diagnosis conclusion)                 │
│                                         │
│ - Diagnosis complete → iteration-       │
│   orchestrator (adjust iteration plan)  │
│ - Lack of monitoring coverage →         │
│   monitoring-orchestrator               │
│ - Growth stagnation → growth-           │
│   orchestrator                          │
│ - Extremely low health and no           │
│   improvement → product-sunset-plan     │
│ - Only health check needed →            │
│   monitoring-orchestrator               │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ session-end     │  Archive + update progress.md
│                 │  + Record diagnosis conclusion to memory/knowledge-base.md
│                 │  + If sunset plan exists, output handoff document
└─────────────────┘
```

## Key Checkpoints

- [ ] Health score model calibrated? (Deviation <±10%)
- [ ] Competitor dynamics tracking complete? (Product/market/public opinion 3 dimensions)
- [ ] Competitor monitoring report human-reviewed?
- [ ] If sunset need exists, sunset plan human-confirmed?
- [ ] All 6 structures of phase summary generated?

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Health score deviation >±15% | Pause auto diagnosis, manually calibrate score model weights then rerun |
| Competitor data source unavailable | Generate snapshot analysis based on historical report, mark "data source unavailable" |
| Sub-skill output validation failed | Roll back to current phase and re-execute, max 1 retry |
| Sunset plan not human-approved | Supplement analysis or modify migration plan, resubmit for review |

## Next Steps

- Need iteration adjustment after diagnosis → enter **iteration** workflow
- Diagnosis discovers growth bottleneck → enter **growth** workflow
- Need data-driven optimization after diagnosis → enter **optimization** workflow
- Need enhanced monitoring after diagnosis → enter **launch** workflow's monitoring preparation
