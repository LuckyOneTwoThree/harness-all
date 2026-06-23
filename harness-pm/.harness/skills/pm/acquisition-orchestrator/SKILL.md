---
name: acquisition-orchestrator
description: Use when you need to evaluate acquisition channels or optimize the acquisition funnel. User Acquisition Orchestrator dispatches acquisition-analysis (Acquisition Analysis Integrated), achieving a closed loop from channel evaluation to funnel optimization. Keywords: user acquisition, acquisition channels, funnel optimization, channel evaluation, acquisition strategy, acquisition-analysis, user growth, acquisition.
metadata:
  module: "Product Growth & Operations"
  sub-module: "Acquisition"
  type: "orchestrator"
  version: "7.0"
  domain_tags: ["E-commerce", "Social", "Education", "General"]
  triggers:
    - "Evaluate the acquisition channels"
    - "Optimize the acquisition funnel"
    - "How to acquire new users"
    - "Acquisition cost is too high"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/growth/growth-strategy.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - output/phase-reports/acquisition-orchestrator.json
  - output/approvals/acquisition-orchestrator/{stage-id}.approval.json
---

# User Acquisition Orchestrator

## Core Principles

**Let the right users find the product**

User acquisition is not a traffic game, but a matching game. The goal is not more users, but more right users — those who can derive value from the product while creating value for the product.

## Orchestration Philosophy

1. **Channel evaluation and funnel optimization executed together**: acquisition-analysis internally completes channel evaluation first, then executes funnel optimization, ensuring optimization plans are supported by channel-level data
2. **Data flows between steps**: Channel evaluation output directly drives funnel optimization input, no orchestrator relay needed

## Orchestrator Positioning Statement

This orchestrator's current Pipeline contains only 1 sub-Skill (acquisition-analysis), making it a degenerate orchestrator after consolidation and simplification. Reasons for retaining this orchestrator:

1. **Unified entry point**: Provides a standardized invocation entry for the user acquisition sub-module; upstream orchestrators (e.g., release-orchestrator) need not care about the consolidation history of internal sub-Skills
2. **Stage summary**: Mandates generation of a stage summary document (post_pipeline), ensuring sub-module outputs are auditable and traceable
3. **Exception handling**: Provides unified exception handling strategies and degradation plans; sub-Skill's own degradation strategies do not override orchestrator-level exception interception
4. **Human decision points**: Provides human decision gates before and after sub-Skill execution, ensuring key conclusions are confirmed by human before being passed downstream

If this sub-module needs to be expanded into a multi-stage Pipeline in the future, this orchestrator can directly add stages without modifying upstream orchestrators' invocation methods.

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: acquisition-orchestrator
version: 7.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/acquisition-orchestrator.json

stages:
  - id: phase-1
    name: "Channel Evaluation and Funnel Optimization"
    depends_on: []
    skills: [acquisition-analysis]
    gate:
      condition: "Channel evaluation completed and funnel optimization plan generated"
      fail_action: "Provide missing channel data or extend analysis period"
```

## Stage Execution Plan

#### Invoke acquisition-analysis

```
Skill: acquisition-analysis
Input:
  channel_data: User-provided (19 acquisition channels data)
  historical_performance: User-provided (historical channel performance)
  channel_config_cost: User-provided (channel config and cost)
  historical_optimization: User-provided (optional, historical optimization experiment data)
Output: docs/growth/growth-strategy.md ("Acquisition Analysis" section)
Validation: Channel evaluation covers 4 dimensions: scale, conversion rate, ROI, quality; channel tiering criteria clear (Primary/Test/Observation); ROI calculation considers user LTV rather than single-transaction revenue; evaluation covers 19 acquisition channel types; funnel stage definition complete (exposure → activation/payment); drop-off causes distinguish 4 obstacle types: awareness/trust/action/value; optimization plans include expected lift and implementation difficulty assessment; A/B test design includes decision rules and stopping conditions
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

After all sub-Skills complete, a stage summary document must be generated and written to `output/phase-reports/acquisition-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-Skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-Skill (1-3 items), cross-sub-Skill insights
3. **Decision Records**: Human decision points and decision results, AI automatic decisions and rationale
4. **Output Inventory**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, suggested follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-Skill output path | docs/growth/ |
| Summary output path | output/phase-reports/acquisition-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: activation-orchestrator (acquisition optimization complete, improve new user conversion)
  alternatives:
    - target: growth-orchestrator
      reason: Acquisition is not the current bottleneck, roll back to growth diagnosis for re-evaluation
      condition: When acquisition channel ROI is below industry benchmark or optimization results fall short of expectations
    - target: experiment-orchestrator
      reason: Acquisition strategy needs A/B testing validation
      condition: When acquisition plan involves channel strategy changes requiring quantitative validation
  special_cases: []

## Stage Gates

| Gate | Condition | Action if Failed |
|------|------|------------|
| Acquisition analysis completed | acquisition-analysis output file generated and non-empty | Provide missing channel data or extend analysis period |
| Stage summary generated | output/phase-reports/acquisition-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structures |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Channel strategy confirmation | Channel evaluation completed, resource allocation needs adjustment | Confirm the division and budget allocation of Primary, Test, and Observation channels |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Severe channel data missing (>50% channels have no data) | Pause channel evaluation, require user to supplement core channel data before continuing |
| Funnel optimization A/B test sample insufficient | Extend test period until sample meets threshold, or relax significance requirement to 90% confidence |
| Sub-Skill output validation failed | Roll back to current stage and re-execute, retry up to 1 time; if still fails, mark exception and escalate to human |
| Upstream/downstream data format incompatible | Perform field mapping and default value filling per downstream sub-Skill input Schema, record mapping relationship |
| Stage summary generation failed | Generate partial summary based on completed sub-Skill outputs, mark missing items as "data missing", do not block orchestrator completion |
