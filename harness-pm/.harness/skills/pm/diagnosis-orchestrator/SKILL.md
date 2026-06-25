---
name: diagnosis-orchestrator
description: Used when diagnosing product health or tracking competitor dynamics. Intelligent diagnosis orchestrator dispatching diagnosis-health, diagnosis-competition, competitor-monitoring-report, and product-sunset-plan sub-skills. Keywords: intelligent diagnosis, health score, competitor tracking, issue attribution, MTTR, competitor monitoring, product sunset, product diagnosis, issue troubleshooting.
---
# Intelligent Diagnosis Orchestrator

## When to use
- Diagnose product health
- Track competitor dynamics
- Troubleshoot product issues
- Evaluate whether to sunset a product

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/monitoring/diagnosis-report.md
- docs/monitoring/product-sunset-plan.md

## Outputs
- output/phase-reports/diagnosis-orchestrator.json
- memory/progress.md
- memory/knowledge-base.md

## Core Principle

**Rapidly locate root causes, reduce MTTR**

The value of diagnosis lies not in producing reports, but in shortening the time from issue discovery to root cause localization. Every additional minute of uncertainty means an additional minute of risk exposure and resource waste.

## Orchestration Philosophy

1. **Health first, competitors follow**: First diagnose own health to locate issues, then track competitor dynamics to find external causes; combining internal and external perspectives enables complete attribution
2. **Diagnosis data drives competitor response**: The bottleneck conclusions from health diagnosis directly determine the focus direction and response strategy priority of competitor tracking

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: diagnosis-orchestrator
version: 10.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/diagnosis-orchestrator.json

stages:
  - id: phase-1
    name: "Health Diagnosis"
    depends_on: []
    skills: [diagnosis-health]
    parallel_with: [phase-2]
    gate:
      condition: "Health score deviation within ±10%"
      fail_action: "Calibrate scoring model or supplement data"

  - id: phase-2
    name: "Competitor Tracking"
    skills: [diagnosis-competition]
    parallel_with: [phase-1]
    gate:
      condition: "Competitor dynamics tracked"
      fail_action: "Supplement competitor data sources or extend tracking period"

  - id: phase-3
    name: "Competitor Monitoring Report"
    depends_on: [phase-2]
    skills: [competitor-monitoring-report]
    gate:
      condition: "Competitor monitoring report confirmed by human review"
      fail_action: "Supplement analysis or modify response recommendations"

  - id: phase-4
    name: "Product Sunset Plan"
    depends_on: [phase-1]
    skills: [product-sunset-plan]
    trigger: Product sunset requirement
    gate:
      condition: "Product sunset plan confirmed by human review"
      fail_action: "Supplement analysis or modify migration plan"
```

## Stage Execution Plan

#### Invoke diagnosis-health

```
Skill: diagnosis-health
Input:
  performance_data: APM/monitoring system
  availability_data: monitoring system
  user_satisfaction: feedback system
  business_metrics: data analytics platform
  competitor_dynamics: diagnosis-competition → competitor report (optional)
Output: docs/monitoring/diagnosis-report.md ("Health Diagnosis" section)
Validation: Data collection completeness ≥90%; scoring calculation accuracy; trend forecast deviation ±10%; bottleneck identification coverage ≥90%
Mode: 🤖→👤
```

#### Invoke diagnosis-competition

```
Skill: diagnosis-competition
Input:
  competitor_data: competitor monitoring system
  self_data: product data platform
  market_data: industry report (optional)
  historical_tracking: diagnosis-competition → historical report (optional)
Output: docs/monitoring/diagnosis-report.md ("Competitor Diagnosis" section)
Validation: Competitor coverage completeness ≥90%; feature change identification timeliness ≤7 days; strategy executability ≥80%
Mode: 🤖→👤
```

#### Invoke competitor-monitoring-report

```
Skill: competitor-monitoring-report
Input:
  competitor_tracking: diagnosis-competition
  competitor_analysis: market-competitor-analysis (optional)
  monitoring_period: user-provided (optional)
Output: docs/monitoring/diagnosis-report.md ("Competitor Monitoring Report" section)
Validation: Dynamics coverage complete (product/market/sentiment 3 dimensions all analyzed); threat assessment evidence-based; response recommendations executable
Mode: 🤖→👤
```

#### Invoke product-sunset-plan

```
Skill: product-sunset-plan
Input:
  health_diagnosis: diagnosis-health
  retention_data: retention-management (optional)
  sunset_target: user-provided (sunset target)
  sunset_reason: user-provided (sunset reason)
Output: docs/monitoring/product-sunset-plan.md
Validation: Impact assessment complete (users/revenue/brand 3 dimensions); migration plan feasible; data disposal compliant; timeline executable
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

After all sub-skills have completed execution, a stage summary document must be generated and written to `output/phase-reports/diagnosis-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary of each sub-skill (1-3 items), cross-sub-skill cross-cutting insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Output Inventory**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks and TODOs**: Items that failed validation, items executed with degradation, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/monitoring/ |
| Summary output path | output/phase-reports/diagnosis-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: iteration-orchestrator (diagnosis complete, adjust iteration plan based on diagnosis conclusions)
  alternatives:
    - target: monitoring-orchestrator
      reason: Diagnosis conclusion indicates need to establish monitoring alerts
      condition: When diagnosis reveals product lacks effective monitoring coverage
    - target: growth-orchestrator
      reason: Diagnosis conclusion indicates growth bottleneck, need growth strategy
      condition: When health decline is mainly due to growth stagnation
    - target: iteration-orchestrator
      reason: Health extremely low with no room for improvement, need to formulate iteration improvement or sunset plan
      condition: When health score <30 and no improvement for 3 consecutive cycles
  special_cases:
    - target: monitoring-orchestrator
      reason: Only health diagnosis needed, no need for complete diagnosis orchestration
      condition: When competitor data already exists, only product health check needed

## Stage Gates

| Gate | Condition | Fail Handling |
|------|------|------------|
| Health score deviation ±10% | diagnosis-health output file generated and non-empty | Calibrate scoring model or supplement data |
| Competitor dynamics tracked | diagnosis-competition output file generated and non-empty | Supplement competitor data sources or extend tracking period |
| Competitor monitoring report reviewed | Competitor monitoring report confirmed by human review | Supplement analysis or modify response recommendations |
| Product sunset plan reviewed | Product sunset plan confirmed by human review | Supplement analysis or modify migration plan |
| Quality acceptance | If acceptance needed, hand off to release-orchestrator to execute quality-acceptance | — |
| Stage summary generated | output/phase-reports/diagnosis-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Downstream Handoff

- Diagnosis complete → iteration-orchestrator (adjust iteration plan)
- Lacks monitoring coverage → monitoring-orchestrator
- Growth stagnation → growth-orchestrator
- Health extremely low → iteration-orchestrator (formulate iteration improvement or sunset plan)
- Only health check needed → monitoring-orchestrator

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Health score calibration | Health score deviation from actual perception exceeds ±10% | Confirm scoring model calibration plan and weight adjustment |
| Competitor monitoring report confirmation | Competitor monitoring report generation completed | Confirm threat assessment and response recommendations |
| Product sunset plan confirmation | Product sunset plan generation completed | Confirm sunset timeline and user migration plan |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Health score model deviation too large (>±15%) | Pause automated diagnosis, require manual calibration of scoring model weights before rerun |
| Competitor data source unavailable | Generate snapshot analysis based on most recent historical report, label "data source unavailable, based on historical data" |
| Sub-skill output validation failed | Roll back to current stage for re-execution, max 1 retry; if still fails, mark exception and escalate to human |
| Upstream/downstream data format incompatible | Perform field mapping and default value filling per downstream sub-skill input schema, record mapping relationship |
| Stage summary generation failed | Generate partial summary based on completed sub-skill outputs, missing items labeled "data missing", does not block orchestration completion |
