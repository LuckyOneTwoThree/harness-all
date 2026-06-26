---
workflow_id: J
name: health-check
description: "Perform periodic product health checkups with multi-dimensional scoring and competitor snapshots"
default_mode: skip
---

# Workflow J: Periodic Health Check

> Applicable scenario: Product periodic checkup, quarterly health assessment, proactive issue discovery
> Core mode: Health diagnosis → competitor snapshot → report output (no LOOP, lightweight)

## Differences from Other Workflows

| Dimension | diagnosis | **health-check** |
|------|-----------|------------------|
| Trigger | Reactive (health decline) | **Proactive (periodic)** |
| Scope | Full diagnosis + sunset | **Health + competitor snapshot only** |
| Depth | Deep diagnosis | **Quick checkup** |
| Output | Diagnosis report + sunset plan | **Health report + improvement suggestions** |

## Trigger Conditions

- Periodic checkup (monthly/quarterly)
- Check after major version release
- Health confirmation before holidays
- Proactive issue discovery

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm check scope
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Health Diagnosis (diagnosis-  │
│ orchestrator phase-1)                   │
│                                         │
│  - diagnosis-health                     │
│    (Multi-dimensional data collection + │
│     composite scoring + trend           │
│     prediction + bottleneck             │
│     identification)                     │
│                                         │
│  Output: docs/monitoring/health-check-report.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Competitor Snapshot           │
│ (diagnosis-orchestrator phase-2,        │
│  lightweight version)                   │
│                                         │
│  - diagnosis-competition                │
│    (Quick scan of competitor dynamics,  │
│     not deep analysis)                  │
│                                         │
│  Output: docs/monitoring/competitor-monitoring-report.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ Health Report Generation                │
│                                         │
│  - Aggregate health score + trends +    │
│    competitor dynamics                  │
│  - Highlight metrics needing attention  │
│  - Provide improvement suggestions      │
│    (no deep solution design)            │
│                                         │
│  Output: docs/monitoring/health-check-report.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ session-end     │  Archive health report
│                 │  + Update memory/baseline.json
│                 │  + Record to memory/knowledge-base.md
│                 │  + No handoff document produced; results archived to memory/progress.md
└─────────────────┘
```

## Key Checkpoints

- [ ] Health score collected? (Multi-dimensional data)
- [ ] Trend analysis done? (MoM/YoY)
- [ ] Competitor snapshot scanned?
- [ ] Metrics needing attention highlighted?
- [ ] Improvement suggestions provided?

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Data source unavailable | Generate snapshot based on historical data, mark "data source limitation" |
| Health score abnormal | Trigger full diagnosis workflow for deep diagnosis |
| Competitor has major moves | Trigger full diagnosis workflow for deep analysis |

## Connection with diagnosis

- Health score drops beyond threshold → enter **diagnosis** workflow for full diagnosis
- Competitor has major moves → enter **diagnosis** workflow for deep analysis
- Growth bottleneck discovered → enter **growth** workflow
- Optimization opportunity discovered → enter **optimization** workflow

## Next Steps

- Health abnormality → enter **diagnosis** workflow
- Growth opportunity discovered → enter **growth** workflow
- Optimization opportunity discovered → enter **optimization** workflow
- All normal → archive report, wait for next check
