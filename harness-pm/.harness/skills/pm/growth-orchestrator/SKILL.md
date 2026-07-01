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

## Section Ownership Matrix

`docs/growth/growth-strategy.md` is an aggregate file written by multiple skills. Each skill owns a specific section and MUST NOT write to sections owned by other skills. The growth-strategy-report (phase-6) performs assembly-only synthesis.

| Section | Owner Skill (Write) | Phase | Read By |
|---------|---------------------|-------|---------|
| "Growth Model" section | growth-model | phase-1 | acquisition-analysis, activation-orchestrator, retention-management, revenue-orchestrator, growth-strategy-report |
| "Acquisition Analysis" section | acquisition-analysis | phase-2 | growth-strategy-report |
| "Aha Moment" section | activation-aha (via activation-orchestrator) | phase-3 | activation-onboarding, growth-strategy-report |
| "Onboarding" section | activation-onboarding (via activation-orchestrator) | phase-3 | growth-strategy-report |
| "Retention Management" section | retention-management | phase-4 | growth-strategy-report |
| "Revenue Funnel" section | revenue-funnel (via revenue-orchestrator) | phase-5 | revenue-nrr, growth-strategy-report |
| "NRR Analysis" section | revenue-nrr (via revenue-orchestrator) | phase-5 | revenue-upsell, growth-strategy-report |
| "Upsell" section | revenue-upsell (via revenue-orchestrator) | phase-5 | growth-strategy-report |
| Consolidated overwrite | growth-strategy-report | phase-6 | Downstream consumers |

> **Write isolation rule**: A skill may ONLY write to its owned section. Reading other sections is allowed. The growth-strategy-report (phase-6) performs assembly-only synthesis and may overwrite the consolidated file, but must preserve the content of sections owned by phases 1-5.

## Pipeline

```yaml
pipeline: growth-orchestrator
version: 8.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/growth-orchestrator.json

stages:
  # Dispatch-level rationale: phases 2 and 4 dispatch pipeline skills directly
  # (acquisition-analysis, retention-management) because these are single-skill
  # stages with no multi-skill orchestration needed. Phases 3 and 5 dispatch
  # sub-orchestrators (activation-orchestrator, revenue-orchestrator) because
  # activation and monetization each require multi-skill sub-pipelines
  # (activation-aha + activation-onboarding; revenue-funnel + revenue-nrr +
  # revenue-upsell). This is intentional, not inconsistent: the dispatch level
  # matches the complexity of the funnel stage.
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
    skills: [acquisition-analysis]
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
    skills: [retention-management]
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

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


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
