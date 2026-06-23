---
workflow_id: A
name: growth-strategy-workflow
default_mode: deep
---

# Workflow: Growth Strategy Workflow

> LOOP type: experiment (strategy itself is a hypothesis, needs validation)
> Trigger scenarios: Quarterly/annual growth planning, new business cold start
> Orchestration Skill: nsm-definition → kpi-tree → aarr-diagnosis → growth-loop-design → four-fits-assessment

## Flowchart

```
┌─────────────────────┐
│ nsm-definition       │  North Star Metric definition
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ kpi-tree             │  KPI Tree breakdown
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ aarr-diagnosis       │  AARRR funnel diagnosis
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ growth-loop-design   │  Growth Loops design
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ four-fits-assessment │  Four Fits assessment
│    [Quality Gate]    │
└─────────┬───────────┘
          │ Any Fit not met
          ▼
   Back to nsm-definition for review
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| After four-fits-assessment | All four Fits meet standard | Any not met → back to nsm-definition |
| After aarr-diagnosis | Any P0 weak stage exists | Yes → prioritize experiments |

## Data Flow

| Stage | Output | Storage Location |
|------|------|---------|
| nsm-definition | North Star Metric | docs/operations/GROWTH_STRATEGY.md |
| kpi-tree | KPI Tree | docs/operations/GROWTH_STRATEGY.md |
| aarr-diagnosis | Funnel diagnosis | docs/operations/GROWTH_STRATEGY.md |
| growth-loop-design | Growth loop design | docs/operations/GROWTH_STRATEGY.md |
| four-fits-assessment | Four Fits assessment | docs/operations/GROWTH_STRATEGY.md |

## Interaction with LOOP

```
LOOP(experiment):
  PLAN:       nsm → kpi-tree → aarr → loop-design → four-fits
  EXPERIMENT: [design experiments per KPI Tree]
  MEASURE:    [validate strategy hypotheses via experiments]
  Pass? DONE : Back to PLAN (adjust strategy)
```

## Outputs

- Growth strategy document (GROWTH_STRATEGY.md) fully filled
- KPI Tree (guides experiment direction)
- Experiment Backlog (generate hypotheses from KPI Tree leaf metrics)
- Growth loop design (guides long-term growth engine)

## Usage

Tell the Agent:
- "Define growth strategy" → Trigger this workflow
- "Define North Star Metric" → Start from nsm-definition
- "Break down KPI" → Start from kpi-tree
- "Diagnose growth bottlenecks" → Start from aarr-diagnosis
- "Design growth loops" → Start from growth-loop-design
- "Assess growth feasibility" → Start from four-fits-assessment
