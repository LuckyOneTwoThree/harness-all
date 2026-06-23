---
name: revenue-orchestrator
description: Use when optimizing payment conversion or increasing revenue. Monetization Orchestrator dispatches revenue-funnel (payment funnel analysis), revenue-nrr (NRR tracking and early warning), and revenue-upsell (upgrade conversion), achieving a closed loop from payment funnel analysis to upsell strategy. Keywords: monetization, payment funnel, NRR, upsell strategy, revenue optimization, revenue-funnel, revenue-nrr, revenue-upsell, make money, monetization, payment conversion.
metadata:
  module: "Product Growth & Operations"
  sub-module: "Monetization"
  type: "orchestrator"
  version: "7.0"
  domain_tags: ["E-commerce", "SaaS", "Finance", "Education", "Gaming", "General"]
  triggers:
    - "Optimize payment conversion rate"
    - "Increase product revenue"
    - "Analyze the payment funnel"
    - "Design upsell strategy"
    - "Improve NRR"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/growth/growth-strategy.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - output/phase-reports/revenue-orchestrator.json
  - output/approvals/revenue-orchestrator/{stage-id}.approval.json
---

# Monetization Orchestrator

## Core Principles

**Monetization is a win-win for user value and business value**

Good monetization is not extracting value from users, but creating more value for users while receiving reasonable returns. Users are willing to pay because the product makes their lives or work better, not because they were designed into payment traps.

## Orchestration Philosophy

1. **Funnel diagnosis sets direction, NRR tracking monitors health, upgrade conversion captures opportunities**: Three stages from diagnosis to monitoring to action, forming a complete monetization closed loop
2. **Data flows progressively through funnel → NRR → upgrade**: Outputs from earlier stages directly drive strategy formulation in later stages

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: revenue-orchestrator
version: 7.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/revenue-orchestrator.json

stages:
  - id: phase-1
    name: "NRR Tracking"
    depends_on: []
    skills: [revenue-nrr]
    gate:
      condition: "NRR calculation and trend tracking running normally, churn warnings and expansion opportunities identified"
      fail_action: "Improve revenue data collection"

  - id: phase-2
    name: "Payment Funnel"
    depends_on: [phase-1]
    skills: [revenue-funnel]
    gate:
      condition: "Registration-to-payment full-link conversion analysis complete, bottlenecks identified"
      fail_action: "Supplement funnel step definitions or data"

  - id: phase-3
    name: "Upgrade Conversion"
    depends_on: [phase-2]
    skills: [revenue-upsell]
    gate:
      condition: "Upgrade conversion strategy and personalized plan generated"
      fail_action: "Optimize upgrade signal identification or supplement user behavior data"
```

## Stage Execution Plan

#### Call revenue-nrr

```
Skill: revenue-nrr
Inputs:
  revenue_data: User-provided (revenue data)
  user_account_data: User-provided
  user_behavior_data: User-provided (optional)
Output: docs/growth/growth-strategy.md ("NRR Analysis" section)
Validation: NRR calculation includes expansion, contraction, and churn components; churn warning covers activity, feature, financial, and organizational 4 signal types; expansion opportunity identification has scoring and recommendation strategy; multi-dimensional NRR calculation covers user segments and product lines
Mode: 🤖→👤
```

#### Call revenue-funnel

```
Skill: revenue-funnel
Inputs:
  payment_funnel_data: User-provided (registration-to-payment full-link data)
  conversion_data: docs/growth/growth-strategy.md ("NRR Analysis" section)
  user_profile_data: User-provided (optional)
Output: docs/growth/growth-strategy.md ("Revenue Funnel" section)
Validation: Payment funnel covers the full link from registration to repurchase; barrier identification distinguishes qualitative and quantitative analysis; optimization suggestions ranked by impact coefficient × implementation difficulty; paywall timing suggestions based on user behavior data
Mode: 🤖→👤
```

#### Call revenue-upsell

```
Skill: revenue-upsell
Inputs:
  user_behavior_data: User-provided
  payment_history: docs/growth/growth-strategy.md ("NRR Analysis" section)
  product_usage_data: User-provided (optional)
Output: docs/growth/growth-strategy.md ("Upsell" section)
Validation: Upgrade signal identification covers 4 signal types (usage/feature/behavior/intent); personalized content includes 3 elements: user name, usage, and benefits; A/B test design includes guardrail metrics; upgrade ROI calculation includes outreach cost
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

After all sub-skills finish executing, a stage summary document must be generated and written to `output/phase-reports/revenue-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary of each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Artifact Inventory**: All output file paths and content summaries, artifact quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/growth/ |
| Summary output path | output/phase-reports/revenue-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: growth-orchestrator (monetization optimization complete, return to growth diagnosis to assess overall growth flywheel effectiveness)
  alternatives:
    - target: experiment-orchestrator
      reason: Monetization plan needs A/B test validation
      condition: When pricing or paywall strategy changes require quantitative validation
    - target: metrics-orchestrator
      reason: Monetization metrics need supplemental measurement design
      condition: When payment funnel key metrics lack tracking support
  special_cases: []

## Stage Gates

| Gate | Condition | Action if Not Met |
|------|------|------------|
| NRR tracking established | revenue-nrr output file generated and non-empty | Improve revenue data collection |
| Payment funnel analysis complete | revenue-funnel output file generated and non-empty | Supplement funnel step definitions or data |
| Upgrade conversion strategy generated | revenue-upsell output file generated and non-empty | Optimize upgrade signal identification or supplement user behavior data |
| Stage summary generated | output/phase-reports/revenue-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Pricing strategy confirmation | Payment funnel analysis and NRR tracking complete | Confirm pricing adjustments, upgrade plans, and resource allocation strategy |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Payment funnel data severely missing (cannot build complete funnel) | Build partial funnel based on available data, missing stages marked "pending supplement", human confirms whether to continue |
| NRR calculation anomaly (NRR <80% or >150%) | Mark data anomaly warning, recommend manual verification of revenue data definition before recalculation |
| No valid candidates for upgrade signal identification | Relax signal thresholds and re-search; if still no results, infer upgrade scenarios based on product features, marked "pending data validation" |
| Sub-skill output validation failed | Fall back to current stage and re-execute, max 1 retry; if still fails, mark exception and escalate to human |
| Upstream/downstream data format incompatible | Perform field mapping and default value filling per downstream sub-skill input Schema, record mapping relationship |
| Stage summary generation failed | Generate partial summary based on completed sub-skill outputs, missing items marked "data missing", does not block orchestration completion |
