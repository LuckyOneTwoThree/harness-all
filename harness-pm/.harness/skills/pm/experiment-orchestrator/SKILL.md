---
name: experiment-orchestrator
description: Used when designing or executing A/B test experiments. Experiment validation orchestrator, dispatches experiment-design/execution. Keywords: A/B testing, experiment design, statistical significance, experiment execution, effect validation, AB testing, controlled experiment.
metadata:
  module: "Product Metrics & Operations"
  sub-module: "Experiment Validation"
  type: "orchestrator"
  version: "8.0"
  domain_tags: ["General"]
  triggers:
    - "Design an A/B test"
    - "Validate the solution effect"
    - "Run a controlled experiment"
    - "Analyze experiment results"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/metrics/experiment-report.md
writes:
  - output/phase-reports/experiment-orchestrator.json
  - memory/progress.md
  - memory/knowledge-base.md
---

# Experiment Design Orchestrator

## Core Principles

**Experiments are the fastest way to learn**

Every experiment is a controlled exploration. The goal is not to prove the hypothesis correct, but to obtain reliable learning at the fastest speed. The value of experiments lies in learning velocity, not in the number of experiments.

## Orchestration Philosophy

1. **Design→Execution two phases are both indispensable**: Execution without design is blind; the execution phase includes result analysis and report generation
2. **Human review is a necessary gate for experiments**: Both experiment plans and experiment reports must go through human review; the execution process can be automated
3. **Guardrail metrics have veto power**: No matter how positive the primary metric is, a guardrail metric breach means pause

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: experiment-orchestrator
version: 8.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/experiment-orchestrator.json

stages:
  - id: phase-1
    name: "Experiment Design"
    depends_on: []
    skills: [experiment-design]
    gate:
      condition: "Experiment design confirmed by human review"
      fail_action: "Block experiment launch, revise and re-review"

  - id: phase-2
    name: "Experiment Execution"
    depends_on: [phase-1]
    skills: [experiment-execution]
    gate:
      condition: "Sufficient sample size and statistical testing complete, experiment report confirmed by human review"
      fail_action: "Extend experiment duration or increase traffic"
```

## Stage Execution Plan

#### Call experiment-design

```
Skill: experiment-design
Inputs:
  hypothesis: User-provided (hypothesis statement)
  available_traffic: User-provided (available traffic)
  metrics_system: metrics-system → metrics.json (optional)
  historical_data: analysis-funnel/analysis-retention (optional)
Output: docs/metrics/experiment-report.md ("Experiment Design" section)
Validation: Hypothesis structured (If-Then-Because-For); primary metric directly corresponds to hypothesis; guardrail metrics cover retention, revenue, and technical dimensions; sample size calculation parameters are justified
Mode: 🤖→👤
```

#### Call experiment-execution

```
Skill: experiment-execution
Inputs:
  experiment_design: docs/metrics/experiment-report.md ("Experiment Design" section)
  experiment_data: User-provided
  termination_conditions: docs/metrics/experiment-report.md ("Experiment Design" section)
  product_background: User-provided (optional)
Output: docs/metrics/experiment-report.md ("Experiment Results" section)
Validation: Experiment group traffic allocation correct; guardrail metrics did not trigger alerts; experiment data collection complete; statistical significance calculation correct; statistical conclusions consistent with data; action recommendations consistent with conclusions; guardrail metrics fully covered; heterogeneous effects analyzed (at least 3 segment dimensions)
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

After all sub-skills complete execution, a stage summary document must be generated and written to `output/phase-reports/experiment-orchestrator.json`, containing the following 6 structures (none can be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary of each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Record**: Human decision points and decision results, AI automatic decisions and rationale
4. **Output Inventory**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed with degradation, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/metrics/ |
| Summary output path | output/phase-reports/experiment-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: decision-orchestrator (experiment complete, convert experiment conclusions into decision actions)
  alternatives:
    - target: release-orchestrator
      reason: Experiment results significant, recommend full release
      condition: When experiment results are statistically significant (p<0.05) and business significance is met
    - target: analysis-orchestrator
      reason: Experiment results need deeper data analysis
      condition: When experiment results have anomalies or need multi-dimensional drill-down
  special_cases: []

## Stage Gates

| Gate | Condition | Non-pass Handling |
|------|------|------------|
| Experiment plan human-reviewed | Experiment design confirmed by human review | Block experiment launch, revise and re-review |
| Statistical significance judged | experiment-result output file generated and non-empty | Extend experiment duration or increase traffic |
| Experiment report reviewed | Experiment report confirmed by human review | Supplement analysis or revise conclusions |
| Stage summary generated | output/phase-reports/experiment-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Experiment plan review | Experiment design complete | Review hypothesis rationality, metric selection, traffic split plan |
| Full release/termination decision | Experiment result analysis complete | Decide full release, terminate experiment, or extend duration |
| Experiment report confirmation | Experiment report generation complete | Confirm report conclusions and action recommendations |

## Decision Rules

| Condition | Action |
|------|--------|
| Sample size reaches 100% | Immediately trigger result analysis |
| Statistically significant (p < 0.05) and stable | Consider early termination |
| Guardrail metrics significantly decline | Trigger alert, consider termination |
| Novelty effect significant | Extend experiment duration |
| Experiment group persistently negative | Consider early termination |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Experiment design fails human review | Block experiment launch, return to design phase for revision, do not enter execution phase |
| Guardrail metric breaches threshold | Immediately pause experiment execution, trigger alert, submit human decision on whether to terminate experiment |
| Experiment data collection anomaly | Flag data anomaly, pause statistical testing, prompt human to check data pipeline |
| Experiment report fails human review | Return to execution phase to supplement analysis, do not pass to downstream |
| Multiple experiments traffic conflict | Queue by priority, lower priority experiments pause, mark "traffic conflict" |
| Stage summary generation fails | Generate partial summary based on completed sub-skill outputs, missing items marked "data missing", do not block orchestration completion |
