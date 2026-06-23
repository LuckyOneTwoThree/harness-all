---
workflow_id: G
name: ops-review-workflow
default_mode: skip
---

# Workflow: Ops Review Workflow

> LOOP type: None (periodic report)
> Trigger scenarios: Weekly/monthly/quarterly review, session-end detects concluded tasks
> Orchestration Skill: sla-report + cost-analysis → ops-review → [produce ops-to-pm.md]

## Flowchart

```
┌─────────────────────────────────────────────────────────┐
│ Parallel data analysis                                  │
│  ├── sla-report         SLA calculation and report      │
│  └── cost-analysis      Cost analysis and optimization  │
│                         suggestions                      │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ ops-review                       │  Summarize metrics + incidents + deployments
          │                                   │  Produce ops-to-pm.md
          └─────────────────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| Before ops-review output | Data complete (at least this month's deployment/incident records) | Tag as "insufficient data" |
| Before ops-to-pm.md output | Fields complete (SLA/incidents/suggestions) | Supplement missing fields |

## Usage

Tell the Agent:
- "Generate this month's ops review" → Trigger this workflow
- "Prepare handoff to PM" → Trigger ops-review to produce ops-to-pm.md
- "Calculate this month's SLA" → Start from sla-report
- session-end auto-trigger (if concluded tasks exist)
