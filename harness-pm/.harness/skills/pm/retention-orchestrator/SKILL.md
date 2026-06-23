---
name: retention-orchestrator
description: Use when reducing churn rate or improving user engagement. User Retention Orchestrator dispatches retention-management (retention management integrated), achieving a closed loop from churn prevention to user reactivation. Keywords: user retention, churn prediction, tiered operations, engagement, retention strategy, retention-management, churn prevention, reactivation.
metadata:
  module: "Product Growth & Operations"
  sub-module: "Retention"
  type: "orchestrator"
  version: "7.0"
  domain_tags: ["E-commerce", "Social", "Gaming", "General"]
  triggers:
    - "User churn is severe"
    - "Improve user retention rate"
    - "Run a churn prediction"
    - "Design tiered operation strategy"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/growth/growth-strategy.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - output/phase-reports/retention-orchestrator.json
  - output/approvals/retention-orchestrator/{stage-id}.approval.json
---

# User Retention Orchestrator

## Core Principles

**Retention is the core metric that measures product value**

Acquisition determines the starting point; retention determines the endpoint. If users are unwilling to stay, it means the product has not yet delivered enough value. The root cause of retention issues is always a value issue, not an operations issue.

## Orchestration Philosophy

1. **Prediction and operations executed together**: retention-management internally first builds churn prediction to identify high-risk users, then designs differentiated operation strategies based on risk tiering
2. **Prediction data drives operation priority**: Churn risk level directly determines operation resource allocation and intervention intensity

## Orchestrator Positioning Statement

This orchestrator's current Pipeline contains only 1 sub-skill (retention-management), making it a degenerated orchestrator after merge simplification. Reasons for retaining this orchestrator:

1. **Unified entry point**: Provides a standardized call entry for the user retention sub-module; upstream orchestrators (e.g., release-orchestrator) do not need to know the internal sub-skill merge history
2. **Stage summary**: Forces generation of a stage summary document (post_pipeline), ensuring sub-module outputs are auditable and traceable
3. **Exception handling**: Provides unified exception handling strategies and degradation plans; sub-skill degradation strategies do not override orchestrator-level exception interception
4. **Human decision points**: Provides human decision gates before and after sub-skill execution, ensuring key conclusions are confirmed by humans before being passed downstream

If this sub-module needs to be expanded into a multi-stage Pipeline in the future, this orchestrator can directly add stages without modifying upstream orchestrator call methods.

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: retention-orchestrator
version: 7.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/retention-orchestrator.json

stages:
  - id: phase-1
    name: "Churn Prediction and User Segmentation"
    depends_on: []
    skills: [retention-management]
    gate:
      condition: "Churn prediction model built and user segmentation complete"
      fail_action: "Optimize model or supplement training data"
```

## Stage Execution Plan

#### Call retention-management

```
Skill: retention-management
Inputs:
  user_behavior_data: User-provided (active logs exported from data analytics platform, fields: user_id, last_active_date, active_days_30d)
  churn_history: User-provided (churn records exported from data analytics platform, fields: user_id, churn_date, churn_reason)
  user_account_data: User-provided (account info exported from user system, fields: user_id, register_date, plan_type)
  user_lifecycle_stage: User-provided (optional, registration time, key milestones)
Output: docs/growth/growth-strategy.md ("Retention Management" section)
Validation: Churn definition distinguishes free/paid/enterprise users; prediction model accuracy >75%; intervention strategy matches risk level; intervention effectiveness tracking includes ROI calculation; user segmentation covers full lifecycle (new/growing/mature/dormant/churned); health score includes activity, feature depth, payment willingness, social engagement; operation strategy matches user tier; outreach content is personalized
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

After all sub-skills finish executing, a stage summary document must be generated and written to `output/phase-reports/retention-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary of each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Artifact Inventory**: All output file paths and content summaries, artifact quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/growth/ |
| Summary output path | output/phase-reports/retention-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: revenue-orchestrator (retention optimization complete, optimize paid conversion)
  alternatives:
    - target: growth-orchestrator
      reason: Retention is not the current bottleneck, fall back to growth diagnosis for re-evaluation
      condition: When retention rate optimization results fall short of expectations or retention is not the current biggest bottleneck
    - target: experiment-orchestrator
      reason: Retention strategy needs A/B test validation
      condition: When churn intervention scheme changes require quantitative validation
  special_cases: []

## Stage Gates

| Gate | Condition | Action if Not Met |
|------|------|------------|
| Retention management complete | retention-management output file generated and non-empty | Optimize model or supplement training data |
| Stage summary generated | output/phase-reports/retention-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Intervention strategy confirmation | Churn prediction and tiered operation strategy generation complete | Confirm intervention strategy priority, outreach methods, and resource allocation |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Churn prediction model accuracy <75% | Reduce application scope, only use for high-confidence user prediction; mark "model pending optimization", recommend supplementing training data |
| User behavior data insufficient to support segmentation | Use simplified segmentation model (only active/silent/churned 3 tiers), mark "segmentation pending refinement" |
| Sub-skill output validation failed | Fall back to current stage and re-execute, max 1 retry; if still fails, mark exception and escalate to human |
| Upstream/downstream data format incompatible | Perform field mapping and default value filling per downstream sub-skill input Schema, record mapping relationship |
| Stage summary generation failed | Generate partial summary based on completed sub-skill outputs, missing items marked "data missing", does not block orchestration completion |
