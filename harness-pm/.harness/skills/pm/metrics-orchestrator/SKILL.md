---
name: metrics-orchestrator
description: Use when building a product measurement system. Product Metrics Design Orchestrator dispatches sub-skills: metrics-system (metrics system auto-construction), tracking-plan (tracking plan auto-generation), metrics-dashboard (Dashboard auto-configuration).
---
# Product Metrics Design Orchestrator

## When to use
- Help me design a metrics system
- Plan the data tracking
- Design product KPIs
- Configure a data Dashboard
- Keywords: measurement design, metrics system, tracking plan, Dashboard configuration, data metrics, KPI design, data tracking

## Inputs
- rules/security.md
- loops/LOOP.md
- templates/orchestrator-protocol.md
- docs/metrics/metrics-system.md
- docs/metrics/tracking-plan.md
- docs/metrics/dashboard.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- output/phase-reports/metrics-orchestrator.json
- output/approvals/metrics-orchestrator/{stage-id}.approval.json

## Core Principles

Use data to reduce guesswork in decisions, not to back up decisions with data.

## Orchestration Philosophy

1. **Metrics first, tracking follows**: The metrics system is the foundation of measurement design; tracking and dashboards must be derived from the metrics system, not built in reverse
2. **Layered gates, progressive confirmation**: Each stage's output must pass human confirmation before being passed downstream, preventing errors from amplifying along the chain
3. **Data closed-loop, bidirectional validation**: Metrics → tracking → dashboard form a closed loop; upstream changes must propagate along the chain, downstream feedback must trace back to the source

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: metrics-orchestrator
version: 6.1

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/metrics-orchestrator.json

stages:
  - id: phase-1
    name: "Metrics System"
    depends_on: []
    skills: [metrics-system]
    gate:
      condition: "North Star metric selected by human"
      fail_action: "North Star metric must be a human decision; AI only provides candidates and analysis"

  - id: phase-2
    name: "Tracking Plan"
    depends_on: [phase-1]
    skills: [tracking-plan]
    gate:
      condition: "Tracking plan reviewed by human"
      fail_action: "Business logic correctness and privacy compliance must be confirmed by human"

  - id: phase-3
    name: "Dashboard Configuration"
    depends_on: [phase-1, phase-2]
    skills: [metrics-dashboard]
    gate:
      condition: "Dashboard layout confirmed by human"
      fail_action: "Layout reasonableness and alert thresholds require human review"
```

## Phase Execution Plan

#### Call metrics-system

```
Skill: metrics-system
Inputs:
  product_context: User-provided (product type, North Star metric, OKR, business model)
  existing_metrics: User-provided (existing metrics list)
Output: docs/metrics/metrics-system.md
Validation: North Star vanity metric check passed, L1-L2 breakdown complete (3-5 L2 per L1), actionable metrics trackable
Mode: 🤖→👤
```

#### Call tracking-plan

```
Skill: tracking-plan
Inputs:
  PRD: User-provided (product feature description, user flows, core paths, business rules)
  metric_system: docs/metrics/metrics-system.md
  existing_tracking: User-provided (existing tracking list)
Output: docs/metrics/tracking-plan.md
Validation: Naming conventions passed, core path coverage ≥90%, PRD consistency ≥90%
Mode: 🤖→👤
```

#### Call metrics-dashboard

```
Skill: metrics-dashboard
Inputs:
  metric_system: docs/metrics/metrics-system.md
  tracking_plan: docs/metrics/tracking-plan.md
  user_roles: User-provided
  dashboard_platform: User-provided
Output: docs/metrics/dashboard.md
Validation: All metrics assigned to Dashboards, each Dashboard has at least 1 Widget, North Star metric appears on strategic Dashboard, alert rules fully configured
Mode: 🤖→👤
```

### Phase Summary (post_pipeline)

After all sub-skills finish executing, a stage summary document must be generated and written to `output/phase-reports/metrics-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary of each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Artifact Inventory**: All output file paths and content summaries, artifact quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/metrics/ |
| Summary output path | output/phase-reports/metrics-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: monitoring-orchestrator (metrics design complete, land metrics system and tracking plan as monitoring configuration)
  alternatives:
    - target: prd-orchestrator
      reason: Metrics design found PRD feature gaps, need to backfill
      condition: When metrics system design finds PRD feature coverage <80%
    - target: growth-orchestrator
      reason: Metrics system ready, launch growth strategy
      condition: When product is live and metrics system is ready, need to drive growth
  special_cases:
    - target: tracking-plan
      reason: Only need to generate tracking plan, no need for full metrics design
      condition: When metrics system is already established, only need to update tracking plan

## Phase Gates

| Gate | Condition | Action if Not Met |
|------|------|------------|
| Metrics system complete | North Star metric selected by human | North Star metric must be a human decision; AI only provides candidates and analysis |
| Tracking plan complete | Tracking plan reviewed by human | Business logic correctness and privacy compliance must be confirmed by human |
| Dashboard complete | Dashboard layout confirmed by human | Layout reasonableness and alert thresholds require human review |
| Stage summary generated | output/phase-reports/metrics-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| North Star metric selection | AI recommends 3 candidate North Star metrics | Human selects the final metric |
| Tracking plan review | AI generates tracking plan | Human reviews business logic and privacy compliance |
| Dashboard layout confirmation | AI configures Dashboard | Human confirms layout and alert thresholds |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Sub-skill output validation failed | Pause downstream stage execution, output validation failure report, prompt human to fix and retry current stage |
| Stage gate not passed | Block pipeline progression, mark unmet gate conditions, wait for human decision to continue |
| Upstream input file missing | Execute per sub-skill degradation strategy, record degradation info, mark degradation impact scope in final output |
| Sub-skill execution timeout | Mark timeout stage, output completed partial results, prompt human to check input data quality |
| Human decision timeout without response | Pause pipeline, preserve current stage state, support resuming from breakpoint after human returns |
| Stage summary generation failed | Generate partial summary based on completed sub-skill outputs, missing items marked "data missing", does not block orchestration completion |
