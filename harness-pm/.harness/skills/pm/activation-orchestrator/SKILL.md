---
name: activation-orchestrator
description: Use when identifying the Aha Moment or designing the Onboarding flow. User Activation Orchestrator dispatches activation-aha/onboarding.
---
# User Activation Orchestrator

## When to use
- Find the Aha Moment
- Design the onboarding flow
- Improve user activation rate
- Optimize Onboarding
- Keywords: user activation, Aha Moment, Onboarding, new user guidance, onboarding tutorial, activation rate

## Inputs
- rules/security.md
- loops/LOOP.md
- templates/orchestrator-protocol.md
- docs/growth/growth-strategy.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- output/phase-reports/activation-orchestrator.json
- output/approvals/activation-orchestrator/{stage-id}.approval.json

## Core Principles

**Aha Moment is the starting point of user retention**

The essence of user activation is helping users reach the Aha Moment as quickly as possible—that instant when users feel the core value of the product. Activation without an Aha Moment is merely flow completion, not value delivery.

## Orchestration Philosophy

1. **Aha Moment anchors Onboarding**: First identify the Aha Moment, then design the Onboarding path with the Aha Moment as the endpoint, ensuring guidance has a clear target
2. **Data flows from identification to design**: Aha Moment reach rate and path data directly drive Onboarding flow design

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: activation-orchestrator
version: 7.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/activation-orchestrator.json

stages:
  - id: phase-1
    name: "Aha Moment Identification"
    depends_on: []
    skills: [activation-aha]
    gate:
      condition: "At least 1 Aha Moment candidate behavior produced, with retention lift and reach rate data"
      fail_action: "Expand behavior search scope"

  - id: phase-2
    name: "Onboarding Design"
    depends_on: [phase-1]
    skills: [activation-onboarding]
    gate:
      condition: "Onboarding paths and content designed for each user segment"
      fail_action: "Supplement segment data or extend analysis period"
```

## Phase Execution Plan

> Compact routing table. Sub-skill Inputs/Outputs/Validation live in each sub-skill's SKILL.md — do not duplicate here. "Key upstream" notes only when the input source is non-obvious.

| Phase | Skill | Mode | Gate condition | Fail action |
|-------|-------|------|----------------|-------------|
| phase-1 | activation-aha | 🤖→👤 | At least 1 Aha Moment candidate behavior produced, with retention lift and reach rate data | Expand behavior search scope |
| phase-2 | activation-onboarding | 🤖→👤 | Onboarding paths and content designed for each user segment | Supplement segment data or extend analysis period |

**Key upstream notes** (only for non-obvious cross-module inputs):
- phase-1 activation-aha: pulls retention_data from analysis-retention → retention_analysis.json (cross-orchestrator input from analysis-orchestrator, not local docs/)
- phase-2 activation-onboarding: reads aha_moment_data from the "Aha Moment" section written by phase-1 in docs/growth/growth-strategy.md

### Phase Summary (post_pipeline)

After all sub-skills finish executing, a stage summary document must be generated and written to `output/phase-reports/activation-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary of each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Artifact Inventory**: All output file paths and content summaries, artifact quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/growth/ |
| Summary output path | output/phase-reports/activation-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: retention-management (user activation optimization complete, prevent user churn)
  alternatives:
    - target: growth-orchestrator
      reason: Activation is not the current bottleneck, fall back to growth diagnosis for re-evaluation
      condition: When activation rate optimization results fall short of expectations or activation is not the current biggest bottleneck
    - target: experiment-orchestrator
      reason: Activation strategy needs A/B test validation
      condition: When Onboarding scheme changes require quantitative validation
  special_cases:
    - target: activation-aha
      reason: Only need to identify Aha Moment, no need for full activation orchestration
      condition: When an Onboarding scheme already exists and only Aha Moment confirmation is needed

## Phase Gates

| Gate | Condition | Action if Not Met |
|------|------|------------|
| Aha Moment candidates identified | activation-aha output file generated and non-empty | Expand behavior search scope |
| Onboarding strategy generated | activation-onboarding output file generated and non-empty | Supplement segment data or extend analysis period |
| Stage summary generated | output/phase-reports/activation-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Aha Moment confirmation | Aha Moment candidate identification complete | Confirm the selection of the primary Aha Moment and Onboarding path design |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| No Aha Moment candidate passes screening threshold | Lower correlation threshold to 0.3 and re-search; if still no results, infer candidates based on product features, marked "pending data validation" |
| Onboarding data completely missing | Design a general Onboarding framework based on Aha Moment data, marked "pending Onboarding data supplement" |
| Sub-skill output validation failed | Fall back to current stage and re-execute, max 1 retry; if still fails, mark exception and escalate to human |
| Upstream/downstream data format incompatible | Perform field mapping and default value filling per downstream sub-skill input Schema, record mapping relationship |
| Stage summary generation failed | Generate partial summary based on completed sub-skill outputs, missing items marked "data missing", does not block orchestration completion |
