---
name: growth-orchestrator
description: Use when you need to formulate a growth strategy or systematically drive growth. The Growth Strategy Orchestrator first diagnoses the growth model, then dispatches acquisition/activation/retention/monetization sub-orchestrators as needed. Keywords: growth strategy, growth model, AARRR, growth flywheel, growth system, user growth, growth bottleneck, growth diagnosis.
---
# Growth Strategy Orchestrator

## When to use
- Help me formulate a growth strategy
- User growth has hit a bottleneck
- Diagnose the growth issue
- Build a growth system

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/growth/growth-strategy.md
- docs/growth/gtm.md
- docs/growth/operations-manual.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- output/phase-reports/growth-orchestrator.json
- output/approvals/growth-orchestrator/{stage-id}.approval.json

## Core Principles

**Diagnose the model first, then dispatch execution**

Growth is not about blindly stacking channels, but about first figuring out which growth model fits the product, then precisely investing resources into the highest-leverage stage. The growth model determines the strategy mix across acquisition, activation, retention, and monetization.

## Orchestration Philosophy

1. **Model first**: Diagnose the growth model (PLG/SLG/MLG/Hybrid) first, then decide strategies for each stage
2. **Leverage priority**: Identify the current highest-leverage stage based on the flywheel model and concentrate resources to break through
3. **Data-driven attribution**: End-to-end attribution from growth model to each stage, quantifying the contribution of every action
4. **Closed-loop iteration**: Growth strategy is continuously validated and iterated through data

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: growth-orchestrator
version: 8.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/growth-orchestrator.json

stages:
  - id: phase-1
    name: "Growth Model Diagnosis"
    depends_on: []
    skills: [growth-model]
    gate:
      condition: "Growth model determined and flywheel model constructed"
      fail_action: "Provide additional product features and user data"

  - id: phase-2
    name: "Acquisition Optimization"
    depends_on: [phase-1]
    skills: [acquisition-orchestrator]
    trigger: growth-model output bottleneck == "acquisition" or acquisition conversion rate below 50% of industry benchmark
    gate:
      condition: "Channel evaluation completed and funnel optimization plan generated"
      fail_action: "Provide missing channel data or extend analysis period"

  - id: phase-3
    name: "Activation Optimization"
    depends_on: [phase-1]
    skills: [activation-orchestrator]
    trigger: growth-model output bottleneck == "activation" or activation rate below 40%
    gate:
      condition: "Aha Moment candidates identified and Onboarding strategy generated"
      fail_action: "Expand behavior search scope or provide segmentation data"

  - id: phase-4
    name: "Retention Optimization"
    depends_on: [phase-1]
    skills: [retention-orchestrator]
    trigger: growth-model output bottleneck == "retention" or D7 retention rate below 20%
    gate:
      condition: "Churn prediction model built and user segmentation completed"
      fail_action: "Optimize model or provide training data"

  - id: phase-5
    name: "Monetization Optimization"
    depends_on: [phase-1]
    skills: [revenue-orchestrator]
    trigger: growth-model output bottleneck == "revenue" or paid conversion rate below 2%
    gate:
      condition: "Payment funnel analysis completed and NRR tracking established"
      fail_action: "Provide funnel step definitions or data"

  - id: phase-6
    name: "Growth Strategy Report"
    depends_on: [phase-1, phase-2, phase-3, phase-4, phase-5]
    skills: [growth-strategy-report]
    gate:
      condition: "Growth strategy report confirmed by human"
      fail_action: "Adjust strategy direction and execution roadmap"

  - id: phase-7
    name: "GTM Strategy"
    depends_on: [phase-1]
    skills: [gtm-strategy]
    trigger: New product launch / market expansion
    gate:
      condition: "GTM strategy confirmed by human"
      fail_action: "Confirm launch path and channel strategy"

  - id: phase-8
    name: "Operations Manual"
    depends_on: [phase-1]
    skills: [product-operations-manual]
    trigger: Operations manual creation request
    gate:
      condition: "Operations manual confirmed by human"
      fail_action: "Confirm operational SOPs and emergency procedures"
```

## Stage Execution Plan

### Stage 1: Growth Model Diagnosis

#### Invoke growth-model

```
Skill: growth-model
Input:
  product_features: User-provided (product features)
  user_data: analysis-retention → retention_analysis.json
  business_model: User-provided (business model)
Output: docs/growth/growth-strategy.md ("Growth Model" section)
Validation: North Star metric directly linked to ≥1 OKR Objective; growth model contains ≥3 quantifiable variables; growth flywheel contains ≥4 nodes forming a closed loop; bottleneck constraints identified ≤5, each with quantified impact assessment
Mode: 🤖→👤
```

### Stage 2: Bottleneck Stage Optimization (Conditional Branch)

Dispatch the corresponding sub-orchestrator based on the bottleneck stage diagnosed in Stage 1.

#### Invoke acquisition-orchestrator

```
Skill: acquisition-orchestrator
Input:
  growth_model: docs/growth/growth-strategy.md ("Growth Model" section)
  channel_data: User-provided
  funnel_data: User-provided
Output: docs/growth/growth-strategy.md ("Acquisition Analysis" section)
Validation: Channel evaluation covers 19 channel types; acquisition funnel conversion analysis completed for each stage, optimization recommendations output
Mode: 🤖→👤
```

#### Invoke activation-orchestrator

```
Skill: activation-orchestrator
Input:
  growth_model: docs/growth/growth-strategy.md ("Growth Model" section)
  user_behavior_data: User-provided
  retention_data: analysis-retention → retention_analysis.json
Output: docs/growth/growth-strategy.md ("Aha Moment" section)
Validation: Aha Moment candidates identified; Onboarding strategy generated
Mode: 🤖→👤
```

#### Invoke retention-orchestrator

```
Skill: retention-orchestrator
Input:
  growth_model: docs/growth/growth-strategy.md ("Growth Model" section)
  user_behavior_data: User-provided
  churn_history: User-provided (churn history data)
Output: docs/growth/growth-strategy.md ("Retention Management" section)
Validation: Churn prediction model built; user segmentation completed
Mode: 🤖→👤
```

#### Invoke revenue-orchestrator

```
Skill: revenue-orchestrator
Input:
  growth_model: docs/growth/growth-strategy.md ("Growth Model" section)
  payment_funnel_data: User-provided (payment funnel data)
  revenue_data: User-provided (revenue data)
Output: docs/growth/growth-strategy.md ("Revenue Funnel" section)
Validation: Payment funnel analysis completed; NRR tracking established
Mode: 🤖→👤
```

> **Multi-bottleneck scenario**: If multiple stages are bottlenecks, dispatch sub-orchestrators sequentially in flywheel order (acquisition → activation → retention → monetization).

### Stage 3: Growth Strategy Report

#### Invoke growth-strategy-report

```
Skill: growth-strategy-report
Input:
  growth_model: docs/growth/growth-strategy.md ("Growth Model" section)
  acquisition_plan: docs/growth/growth-strategy.md ("Acquisition Analysis" section)
  activation_plan: docs/growth/growth-strategy.md ("Aha Moment" section)
  retention_plan: docs/growth/growth-strategy.md ("Retention Management" section)
  revenue_plan: docs/growth/growth-strategy.md ("Revenue Funnel" section)
  business_goal: User-provided (optional)
Output: docs/growth/growth-strategy.md (aggregate overwrite)
Validation: Flywheel model completeness (at least 3 nodes + 2 causal links); strategy aligned with bottleneck; roadmap executable; funnel data complete (at least 3 of AARRR stages have data)
Mode: 🤖→👤
```

### Additional Stages (Triggered on Demand)

#### Invoke gtm-strategy

```
Skill: gtm-strategy
Input:
  positioning: positioning-strategy (optional)
  business_model: business-model-canvas (optional)
  pricing: business-pricing (optional)
  growth_model: docs/growth/growth-strategy.md ("Growth Model" section)
  product_info: User-provided
Output: docs/growth/gtm.md
Validation: ICP profile is specific (at least 3 dimensions: industry, size, role); launch path is justified; channel budget is executable; success metrics are quantifiable
Mode: 🤖→👤
```

#### Invoke product-operations-manual

```
Skill: product-operations-manual
Input:
  growth_model: docs/growth/growth-strategy.md ("Growth Model" section)
  activation_strategy: docs/growth/growth-strategy.md ("Onboarding" section)
  retention_strategy: docs/growth/growth-strategy.md ("Retention Management" section)
  revenue_strategy: docs/growth/growth-strategy.md ("Revenue Funnel" section)
  product_info: User-provided
Output: docs/growth/operations-manual.md
Validation: SOPs are executable; segmentation strategy is complete (covers at least new/active/dormant/churned users); emergency procedures are actionable (P0-P3 all have response SLAs and escalation paths); templates are ready to use
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

> This summary is an execution audit log for the orchestrator, recording sub-Skill execution status and cross-cutting insights. It does not duplicate the strategy content of growth-strategy-report.

After all sub-Skills complete, a stage summary document must be generated and written to `output/phase-reports/growth-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-Skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-Skill (1-3 items), cross-sub-Skill insights
3. **Decision Records**: Human decision points and decision results, AI automatic decisions and rationale
4. **Output Inventory**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, suggested follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-Skill output path | docs/growth/ |
| Summary output path | output/phase-reports/growth-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: acquisition-orchestrator (growth strategy formulation complete, proceed to acquisition optimization execution)
  alternatives:
    - target: experiment-orchestrator
      reason: Growth plan needs A/B testing to validate effectiveness
      condition: When the growth plan involves major strategy changes requiring quantitative validation
    - target: release-orchestrator
      reason: Growth plan validated, proceed to full release
      condition: When the growth plan has sufficient data support and no experiment validation is needed
    - target: growth-orchestrator
      reason: New product needs to launch, enter GTM strategy stage (internal phase-7)
      condition: When growth diagnosis concludes a new product needs to launch
  special_cases: []

## Stage Gates

| Gate | Condition | Action if Failed |
|------|------|------------|
| Growth model diagnosis completed | growth-model output file generated and non-empty | Provide additional product features and user data |
| Bottleneck stage identified | growth-model output file generated and non-empty | Extend analysis period or expand data scope |
| Growth strategy report confirmed | Growth strategy report confirmed by human | Adjust strategy direction and execution roadmap |
| Stage summary generated | output/phase-reports/growth-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structures |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Growth model confirmation | growth-model diagnosis completed | Confirm final growth model (PLG/SLG/MLG/Hybrid) |
| Bottleneck priority confirmation | Bottleneck stage identification completed | Confirm resource allocation priority |
| Flywheel model confirmation | Flywheel model construction completed | Confirm flywheel nodes and causal relationships |
| Growth strategy report confirmation | growth-strategy-report generation completed | Confirm strategy direction and execution roadmap |
| GTM strategy confirmation | gtm-strategy generation completed | Confirm launch path and channel strategy |
| Operations manual confirmation | product-operations-manual generation completed | Confirm operational SOPs and emergency procedures |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Growth model diagnosis cannot converge (multiple models have similar scores) | Mark as Hybrid model, list scores and rationale for each model, submit to human decision |
| Sub-orchestrator execution timeout or failure | Skip this bottleneck stage, continue executing other bottleneck stages, mark "this stage to be supplemented" in final report |
| Context overflow in multi-bottleneck scenario | Execute only the highest-priority bottleneck in flywheel order, record others as TODOs, execute in batches |
| Sub-Skill output validation failed | Roll back to current stage and re-execute, retry up to 1 time; if still fails, mark exception and escalate to human |
| Upstream/downstream data format incompatible | Perform field mapping and default value filling per downstream sub-Skill input Schema, record mapping relationship |
| Stage summary generation failed | Generate partial summary based on completed sub-Skill outputs, mark missing items as "data missing", do not block orchestrator completion |
