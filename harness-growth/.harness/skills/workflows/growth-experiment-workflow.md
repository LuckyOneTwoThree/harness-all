---
workflow_id: B
name: growth-experiment-workflow
default_mode: standard
---

# Workflow: Growth Experiment Workflow

> LOOP type: experiment
> Trigger scenarios: Weekly experiment cycle, when new hypotheses need validation
> Orchestration Skill: hypothesis-generation → ice-scoring → experiment-design → sample-size-calc → [execute] → experiment-analysis → experiment-conclusion

## Flowchart

```
┌─────────────────────┐
│ hypothesis-generation│  Generate falsifiable hypotheses
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ ice-scoring          │  ICE/RICE scoring and ranking
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ experiment-design    │  Design experiment plan (variables/metrics/guardrails/audience)
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ sample-size-calc     │  Calculate sample size and experiment duration
└─────────┬───────────┘
          ▼
   [Experiment execution, external]
   (Engineering team launches experiment, wait for data collection)
          ▼
┌─────────────────────┐
│ experiment-analysis  │  Statistical analysis (significance/SRM/segmentation)
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ experiment-conclusion│  Conclusion + decision + knowledge base consolidation
└─────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| After hypothesis-generation | Hypothesis falsifiable + deduplicated | Rewrite hypothesis |
| After experiment-design | Single primary metric + complete guardrails + fallback plan | Supplement design |
| After sample-size-calc | Feasible sample size + duration ≥ 7 days | Adjust MDE or split experiment |
| After experiment-analysis | SRM not triggered + sufficient sample | If SRM triggered, redo experiment |

## Data Flow

| Stage | Output | Storage Location |
|------|------|---------|
| hypothesis-generation | Hypothesis list | spec.md + knowledge-base.md |
| ice-scoring | Ranking table | spec.md |
| experiment-design | Experiment plan + state.yaml | spec.md + state.yaml |
| sample-size-calc | Sample size calculation result | spec.md |
| experiment-analysis | Evidence report | evidence.md + iterations.log |
| experiment-conclusion | Conclusion + decision + knowledge base entry | evidence.md + knowledge-base.md + growth-to-pm.md |

## Interaction with LOOP

```
LOOP(experiment):
  PLAN:   hypothesis-generation → ice-scoring → experiment-design → sample-size-calc
  EXPERIMENT: [external execution]
  MEASURE: experiment-analysis → experiment-conclusion
  Pass? DONE : Back to PLAN (new hypothesis) / EXPERIMENT (adjust plan)
```

## Usage

Tell the Agent:
- "Start a growth experiment" → Trigger this workflow
- "Validate this hypothesis: if... then..." → Start from hypothesis-generation
- "Experiment data is ready, analyze it" → Start from experiment-analysis
