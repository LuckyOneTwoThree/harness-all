---
workflow_id: F
name: growth-review-workflow
default_mode: skip
---

# Workflow: Growth Review Workflow

> LOOP type: None (non-cyclic, periodic report)
> Trigger scenarios: Weekly/monthly/quarterly review, session-end detects concluded experiments
> Orchestration Skill: funnel-analysis + cohort-analysis + metric-anomaly-detection → aarr-diagnosis → growth-review

## Flowchart

```
┌─────────────────────────────────────────┐
│ Parallel data analysis (if data exists) │
│  ├── funnel-analysis      Funnel analysis
│  ├── cohort-analysis      Cohort analysis
│  └── metric-anomaly-detection Metric anomaly
└───────────────────┬─────────────────────┘
                    ▼
          ┌─────────────────────┐
          │ aarr-diagnosis       │  AARRR funnel diagnosis
          └─────────┬───────────┘
                    ▼
          ┌─────────────────────┐
          │ growth-review        │  Summary report + produce growth-to-pm.md
          └─────────────────────┘
```

## Notes

- Data analysis skills (funnel-analysis / cohort-analysis / metric-anomaly-detection) are already built; growth-review calls them to obtain analysis data
- aarr-diagnosis is already built; growth-review calls it to obtain AARRR diagnosis results

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| Before growth-review output | Data complete (at least this cycle's experiment records) | Tag as "insufficient data, report is qualitative summary" |
| Before growth-to-pm.md output | Fields complete (experiment results/suggestions/anomalies) | Supplement missing fields |

## Data Flow

| Stage | Output | Storage Location |
|------|------|---------|
| Data analysis (parallel) | Funnel/Cohort/anomaly reports | evidence.md (if corresponding experiments exist) |
| aarr-diagnosis | AARRR weak stages | Inline in report |
| growth-review | Growth review report + growth-to-pm.md | docs/handoff/growth-to-pm.md + knowledge-base.md |

## Usage

Tell the Agent:
- "Generate this month's growth review" → Trigger this workflow
- "Prepare handoff to PM" → Trigger growth-review to produce growth-to-pm.md
- session-end auto-trigger (if concluded experiments exist)
