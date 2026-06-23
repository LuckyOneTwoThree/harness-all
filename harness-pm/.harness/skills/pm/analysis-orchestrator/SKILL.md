---
name: analysis-orchestrator
description: Use when data anomaly detection, funnel analysis, or retention analysis is needed. Data Analysis Orchestrator dispatches analysis-anomaly/funnel/retention/data-analysis-report. Keywords: data analysis, anomaly detection, funnel analysis, retention analysis, Aha Moment, look at data, data is bad, data insights.
metadata:
  module: "Product Metrics Operations"
  sub-module: "Data Analysis"
  type: "orchestrator"
  version: "7.1"
  domain_tags: ["General"]
  trigger_examples:
    - "Help me analyze the data"
    - "There's a data anomaly, investigate it"
    - "Do a funnel analysis"
    - "Analyze user retention"
    - "Data is bad, find the cause"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/metrics/data-analysis-report.md
writes:
  - output/phase-reports/analysis-orchestrator.json
  - memory/progress.md
  - memory/knowledge-base.md
---

# Data Analysis Orchestrator

## Core Principles

**Use data to reduce guesswork in decisions**

The value of data analysis lies not in producing reports, but in converting uncertainty into quantifiable risk, and intuitive judgment into evidence-backed decisions.

## Orchestration Philosophy

1. **Detection first, analysis follows, report closes**: Anomaly detection runs 24/7, funnel and retention triggered on demand, report integrates and closes
2. **Every analysis result must be actionable**: Analysis results without action recommendations are not passed downstream
3. **Anomaly blocks, others execute in sequence**: P0 anomaly immediately blocks current flow, other stages execute in sequence

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: analysis-orchestrator
version: 7.1

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/analysis-orchestrator.json

stages:
  - id: phase-1
    name: "Anomaly Detection"
    depends_on: []
    skills: [analysis-anomaly]
    gate:
      condition: "Anomaly detection pipeline runs continuously without interruption"
      fail_action: "Immediately fix detection pipeline, start backup monitoring"

  - id: phase-2
    name: "Funnel Analysis"
    parallel_with: [phase-3]
    skills: [analysis-funnel]
    gate:
      condition: "Core business funnel defined and data complete"
      fail_action: "Supplement funnel definition, ensure core path coverage"

  - id: phase-3
    name: "Retention Analysis"
    parallel_with: [phase-2]
    skills: [analysis-retention]
    gate:
      condition: "At least 1 Aha Moment candidate behavior produced"
      fail_action: "Expand behavior search scope or extend analysis period"

  - id: phase-4
    name: "Data Analysis Report"
    depends_on: [phase-1, phase-2, phase-3]
    skills: [data-analysis-report]
    gate:
      condition: "Report executive summary complete, at least 3 action recommendations"
      fail_action: "Supplement analysis or mark recommendations for data supplementation"
```

## Stage Execution Plan

#### Call analysis-anomaly

```
Skill: analysis-anomaly
Inputs:
  metrics_system: metrics-system → metric_system.json
  real_time_data: User-provided (real-time metric snapshot exported from data platform)
  alert_rules: User-provided
  event_calendar: User-provided (optional)
Output: docs/metrics/data-analysis-report.md ("Anomaly Analysis" section)
Validation: Anomaly detection covers all key metrics; anomaly severity classified correctly (P0/P1/P2); root cause analysis supported by data; recommended actions are actionable
Mode: 🤖
```

#### Call analysis-funnel

```
Skill: analysis-funnel
Inputs:
  funnel_definition: User-provided
  event_data: User-provided
  segment_config: User-provided (optional)
  comparison_period: User-provided (optional)
Output: docs/metrics/data-analysis-report.md ("Funnel Analysis" section)
Validation: Funnel step definition complete, no omissions; conversion rate calculated based on full data; drop-off node identification includes cause hypotheses; multi-dimensional drill-down covers at least 3 dimensions
Mode: 🤖
```

#### Call analysis-retention

```
Skill: analysis-retention
Inputs:
  user_behavior_data: User-provided
  segment_definition: User-provided (optional)
  cohort_config: User-provided (optional)
  baseline_date: User-provided (optional)
Output: docs/metrics/data-analysis-report.md ("Retention Analysis" section)
Validation: Retention calculated based on full users rather than sampling; Cohort analysis covers time, channel, and behavior dimensions; Aha Moment candidates pass significance testing; churn warning model accuracy > 70%
Mode: 🤖
```

#### Call data-analysis-report

```
Skill: data-analysis-report
Inputs:
  funnel_analysis: docs/metrics/data-analysis-report.md ("Funnel Analysis" section)
  retention_analysis: docs/metrics/data-analysis-report.md ("Retention Analysis" section)
  anomaly_detection: docs/metrics/data-analysis-report.md ("Anomaly Analysis" section)
  decision_dace: decision-dace → decision_insight.json (optional)
  metrics_system: metrics-system → metric_system.json (optional)
  analysis_time_range: User-provided
  product_info: User-provided (optional)
Output: docs/metrics/data-analysis-report.md (consolidated coverage)
Validation: Executive summary contains 3 key findings + Top 1 recommendation; core metric dashboard complete; funnel analysis includes biggest drop-off point and improvement opportunity; retention analysis includes lifecycle stages; each insight has data facts + business implications; at least 3 action recommendations, each with priority and validation method; data definitions and limitations explained
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

After all sub-skills finish executing, a stage summary document must be generated and written to `output/phase-reports/analysis-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary of each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Artifact Inventory**: All output file paths and content summaries, artifact quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/metrics/ |
| Summary output path | output/phase-reports/analysis-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: decision-orchestrator (data analysis complete, convert analysis insights into actionable decisions)
  alternatives:
    - target: experiment-orchestrator
      reason: Analysis found hypotheses requiring A/B testing validation
      condition: When data analysis finds causal relationships uncertain and experimental validation needed
    - target: iteration-orchestrator
      reason: Analysis conclusions directly affect iteration priority
      condition: When data analysis produces clear iteration direction recommendations
  special_cases: []

## Stage Gates

| Gate | Condition | Action if Not Met |
|------|------|------------|
| Anomaly detection 24/7 running | Anomaly detection pipeline runs continuously without interruption | Immediately fix detection pipeline, start backup monitoring |
| Funnel core path coverage | Core business funnel defined and data complete | Supplement funnel definition, ensure core path coverage |
| Retention Aha Moment candidate identified | analysis-retention output file generated and non-empty | Expand behavior search scope or extend analysis period |
| Data insight report generated | Data insight report file generated and non-empty | Supplement analysis or mark "recommend data supplementation" |
| Stage summary generated | output/phase-reports/analysis-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| P0 anomaly immediate confirmation | P0-level anomaly detection triggered | Confirm anomaly authenticity, decide response strategy |

## Decision Rules

| Condition | Action |
|------|--------|
| P0 anomaly | Instant push + phone alert |
| P1 anomaly | Slack/WeCom notification within 2 hours |
| P2 anomaly | Daily summary report |
| P3 fluctuation | Record only, no alert |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Sub-skill output validation failed | Pause downstream stage execution, output validation failure report, prompt human to fix and retry current stage |
| P0 anomaly detection triggered | Immediately interrupt current stage, prioritize P0 anomaly handling, resume original flow after handling complete |
| Upstream data source unavailable | Execute per sub-skill degradation strategy, record degradation info, mark degradation impact scope in final output |
| Analysis result without action recommendations | Block passing to downstream, require current sub-skill to supplement action recommendations |
| Human decision timeout without response | Pause flow, preserve current stage state, support resuming from breakpoint after human returns |
| Stage summary generation failed | Generate partial summary based on completed sub-skill outputs, missing items marked "data missing", does not block orchestration completion |
