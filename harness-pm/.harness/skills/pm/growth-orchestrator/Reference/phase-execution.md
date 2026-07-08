# growth-orchestrator — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Phase Execution Plan

### Phase 1: Growth Model Diagnosis

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

### Phase 2: Bottleneck Stage Optimization (Conditional Branch)

Dispatch the corresponding sub-orchestrator based on the bottleneck stage diagnosed in Stage 1.

#### Invoke acquisition-analysis

```
Skill: acquisition-analysis
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

#### Invoke retention-management

```
Skill: retention-management
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

### Phase 3: Growth Strategy Report

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

### Phase Summary (post_pipeline)

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
  primary: acquisition-analysis (growth strategy formulation complete, proceed to acquisition optimization execution)
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
