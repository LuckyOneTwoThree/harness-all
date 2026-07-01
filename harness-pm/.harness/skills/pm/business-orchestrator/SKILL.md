---
name: business-orchestrator
description: Used when designing or evaluating a product business model. Business Model Orchestrator, dispatching business-model-canvas/value-fit/pricing/strategy-report. Keywords: business model, business canvas, pricing strategy, business strategy report, how to make money, revenue model, charging model, business assessment.
---
# Business Model Design Orchestrator

## When to use
- Help me design a business model
- How does the product make money
- Design a pricing strategy
- Assess whether the business model is viable
- Create a business canvas

## Inputs
- rules/security.md
- loops/LOOP.md
- templates/orchestrator-protocol.md
- docs/strategy/business-strategy.md

## Outputs
- output/phase-reports/business-orchestrator.json
- memory/progress.md

## Core Principles

A business model is not designed, it is validated.

1. **Validation over design** — Business model assumptions must be verifiable; each canvas element should come with a validation method and success criteria
2. **Financial closed-loop driven** — Unit economics precede scale expansion assumptions; ensure single-point profitability logic holds before projecting growth
3. **Multi-option parallel comparison** — Pricing and revenue models generate multiple comparable options to avoid single-option lock-in thinking

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Section Ownership Matrix

`docs/strategy/business-strategy.md` is an aggregate file written by multiple skills. Each skill owns a specific section and MUST NOT write to sections owned by other skills. The final phase (business-strategy-report) performs assembly-only synthesis.

| Section | Owner Skill (Write) | Phase | Read By |
|---------|---------------------|-------|---------|
| "Business Model Canvas" section | business-model-canvas | phase-1 | business-value-fit, business-pricing, business-strategy-report, planning-north-star, planning-okr, positioning-strategy, product-proposal, stakeholder-analysis, strategic-analysis, metrics-system |
| "Value Fit" section | business-value-fit | phase-2 | business-strategy-report, positioning-strategy |
| "Pricing Strategy" section | business-pricing | phase-3 | business-strategy-report, product-proposal |
| Consolidated overwrite | business-strategy-report | phase-5 | Downstream consumers (planning-orchestrator, etc.) |

> **Write isolation rule**: A skill may ONLY write to its owned section. Reading other sections is allowed. The business-strategy-report (phase-5) performs assembly-only synthesis and may overwrite the consolidated file, but must preserve the content of sections owned by phases 1-4.

## Pipeline

```yaml
pipeline: business-orchestrator
version: 7.1

stages:
  - id: phase-1
    name: "Business Model Canvas"
    skills: [business-model-canvas]
    gate:
      condition: "BMC 9 blocks all filled, assumptions annotated"
      fail_action: "Fill in missing elements; those that cannot be filled are annotated as assumptions to be validated"

  - id: phase-2
    name: "Value Fit Validation"
    depends_on: [phase-1]
    skills: [business-value-fit]
    gate:
      condition: "Value proposition fit score ≥ 3.0"
      fail_action: "Adjust value proposition or target users, re-validate"

  - id: phase-3
    name: "Pricing Strategy"
    depends_on: [phase-1, phase-2]
    skills: [business-pricing]
    gate:
      condition: "3 pricing options generated"
      fail_action: "Supplement pricing options, ensure differentiation"

  - id: phase-4
    name: "Stakeholder Analysis"
    depends_on: [phase-1, phase-2]
    skills: [stakeholder-analysis]
    gate:
      condition: "Stakeholder map complete (power/interest grid + alignment risks)"
      fail_action: "Supplement stakeholder identification or re-assess alignment risks"

  - id: phase-5
    name: "Business Strategy Report"
    depends_on: [phase-1, phase-2, phase-3, phase-4]
    skills: [business-strategy-report]
    gate:
      condition: "Report executive summary complete, at least 2 strategic directions"
      fail_action: "Supplement strategic directions or flag 'strategic analysis supplementation recommended'"

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/business-orchestrator.json
```

## Stage Execution Plan

#### Call business-model-canvas

```
Skill: business-model-canvas
Inputs:
  product_context: from user-research-user-modeling / opportunity-definition
  market_data: from market-competitor-analysis
Output: docs/strategy/business-strategy.md ("Business Model Canvas" section)
Validation: BMC 9 blocks all filled, assumptions annotated
Mode: 🤖→👤
```

#### Call business-value-fit

```
Skill: business-value-fit
Inputs:
  bmc_value_proposition: from phase 1 docs/strategy/business-strategy.md ("Business Model Canvas" section)
  user_research_data: from user-research-user-modeling / user-research-voice-analysis
Output: docs/strategy/business-strategy.md ("Value Fit" section)
Validation: Value proposition fit score ≥ 3.0
Mode: 🤖
```

#### Call business-pricing

```
Skill: business-pricing
Inputs:
  bmc_data: from phase 1 docs/strategy/business-strategy.md ("Business Model Canvas" section)
  competitor_pricing_data: from market-competitor-analysis → competitor-analysis.json
  willingness_to_pay: user provided
Output: docs/strategy/business-strategy.md ("Pricing Strategy" section)
Validation: 3 pricing options generated
Mode: 🤖→👤
```

#### Call business-strategy-report

```
Skill: business-strategy-report
Inputs:
  bmc: from phase 1 docs/strategy/business-strategy.md ("Business Model Canvas" section)
  pricing_strategy: from phase 3 docs/strategy/business-strategy.md ("Pricing Strategy" section)
  stakeholder_analysis: from phase 4 docs/strategy/business-strategy.md ("Stakeholder Analysis" section)
  product_business_info: user provided
  optional_inputs: SWOT, OKR, roadmap, positioning, value curve, differentiation assessment, North Star Metric
Output: docs/strategy/business-strategy.md (consolidated overwrite)
Validation: Report executive summary complete, at least 2 strategic directions
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

After all sub-Skills have executed, a stage summary document must be generated and written to `output/phase-reports/business-orchestrator.json`, containing the following 6 structural items (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-Skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-Skill (1-3 items), cross-sub-Skill cross-cutting insights
3. **Decision Records**: Human decision points and decision results, AI automatic decisions and rationale
4. **Deliverables List**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks and TODOs**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-Skill output path | docs/strategy/ |
| Summary output path | output/phase-reports/business-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream Handoff:
  primary: planning-orchestrator (business model design complete, proceed to strategic planning)
  alternatives:
    - target: planning-orchestrator
      reason: Positioning is clear, proceed directly to strategic planning
      condition: When product positioning is determined during business model design
    - target: prd-orchestrator
      reason: Business model and positioning both determined, proceed directly to PRD generation
      condition: When both business model and positioning are complete and rapid entry into product construction is needed
  special_cases: []

## Stage Gates

| Gate | Condition | Fail Handling |
|------|------|------------|
| BMC generation complete | business-model-canvas output file generated and non-empty | Fill in missing elements; those that cannot be filled are annotated as assumptions to be validated |
| Pricing options complete | pricing output file generated and non-empty | Supplement missing options, ensure differentiated positioning |
| Business strategy report complete | strategy-report output file generated and non-empty | Supplement strategic directions or flag "strategic analysis supplementation recommended" |
| Stage summary generated | output/phase-reports/business-orchestrator.json generated and all 6 structural items non-empty | Regenerate after supplementing missing structural items |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| A sub-Skill in phase 1 fails | Pause orchestration, output failure diagnostics, request human intervention to fix and retry that phase |
| Upstream data missing | Flag missing data items, fill with reasonable assumptions (annotate confidence ≤0.3), continue execution and highlight in output |
| Key decision point not confirmed by human | Pause orchestration, output pending confirmation list, wait for human confirmation to continue |
| All upstream data missing | Flag "all data missing" status, output minimal template (only metadata and empty structure), set overall confidence to 0.3, force human confirmation on whether to continue. After human confirmation, generate based on user-provided info and AI knowledge base inference, all inferred content annotated with confidence≤0.5 and needs_human_validation:true |
| Stage summary generation fails | Generate partial summary based on completed sub-Skill outputs, missing items flagged "data missing", does not block orchestration completion |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Revenue model selection | phase 1 business-model-canvas generates multiple revenue model options | Human selects the final revenue model option |
| Pricing number sign-off | phase 3 business-pricing provides pricing analysis and options | Human decides specific pricing numbers and tier structure |
| Business strategy direction confirmation | phase 5 business-strategy-report recommends strategic directions | Human confirms the final strategic choice |
