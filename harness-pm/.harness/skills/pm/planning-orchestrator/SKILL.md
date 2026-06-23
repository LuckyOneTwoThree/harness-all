---
name: planning-orchestrator
description: Use when you need to do product project initiation, strategic planning, or roadmap creation. Strategic planning commander, orchestrating sub-skills such as product proposal, strategic analysis (SWOT/Ansoff/Porter's Five Forces), OKR, North Star, and roadmap. Keywords: project initiation, strategic planning, SWOT, OKR, roadmap, strategic analysis, setting objectives, product planning, annual planning.
metadata:
  module: "Product Business & Strategy"
  sub-module: "Strategic Planning & Roadmap"
  type: "orchestrator"
  version: "10.0"
  domain_tags: ["General"]
  trigger_examples:
    - "Help me with product project initiation"
    - "Create a strategic plan"
    - "Set OKR objectives"
    - "Plan the product roadmap"
    - "Do a SWOT analysis"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/strategy/PRODUCT_STRATEGY.md
  - docs/strategy/OKR.md
  - docs/strategy/roadmap.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - output/phase-reports/planning-orchestrator.json
  - output/approvals/planning-orchestrator/{stage-id}.approval.json
---

# Strategic Planning & Roadmap Commander

## Core Principles

Ensure doing the right things, rather than doing things right.

1. **Strategic alignment cascades** — From vision to OKR to roadmap, ensure each layer's objectives can be traced back to the upper layer's strategic intent
2. **Resource constraints up front** — Introduce resource boundary conditions during the planning phase to avoid producing idealized roadmaps that cannot be executed
3. **Decision points are not deferred** — Strategic choices at each stage must be completed in the current stage; passing "TBD" status downstream is prohibited

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline Definition

```yaml
pipeline: planning-orchestrator
version: 10.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/planning-orchestrator.json

stages:
  - id: phase-1
    name: "Product Proposal"
    skills: [product-proposal]
    gate:
      condition: "Proposal document has been signed off by humans"
      fail_action: "Resubmit after supplementing data"

  - id: phase-2
    name: "Strategic Analysis"
    depends_on: [phase-1]
    skills: [strategic-analysis]
    gate:
      condition: "strategic-analysis.json has been generated, strategic conclusions have been integrated, human decision items have been confirmed"
      fail_action: "Items with confidence < 0.6 are escalated for human calibration; strategic direction must be selected by humans"

  - id: phase-3
    name: "North Star Metric"
    depends_on: [phase-2]
    skills:
      - planning-north-star
    gate:
      condition: "North Star Metric has been selected by humans"
      fail_action: "North Star must be a human decision"

  - id: phase-3b
    name: "OKR Setting"
    depends_on: [phase-3]
    skills:
      - planning-okr
    gate:
      condition: "OKR has been confirmed by humans"
      fail_action: "OKR with achievement probability < 0.3 is escalated for adjustment"

  - id: phase-4
    name: "Roadmap"
    depends_on: [phase-3b]
    skills:
      - planning-roadmap
    gate:
      condition: "Roadmap resources have been approved by humans"
      fail_action: "Priority and resource allocation must be human decisions"
```

## Stage Execution Plan

### Stage 1: product-proposal

- **Skill**: product-proposal
- **Inputs**:
  - competitor_analysis: Competitor analysis report (from market-competitor-analysis → competitor-analysis.md)
  - tam_som: Market size data (from market-tam-som → tam-som.json)
  - user_research_report: User research report (from user-research-report → user-research-report.md)
  - opportunity_definition: Opportunity definition (from opportunity-definition → opportunity-definition.json)
  - positioning_strategy: Positioning strategy (from docs/strategy/positioning.md (optional))
  - product_name_category: Product name and category (user-provided)
  - business_goal: Business goal (user-provided)
  - resource_constraints: Resource constraints (optional, user-provided)
- **Output**: `docs/strategy/PRODUCT_STRATEGY.md ("Product Proposal" section)`
- **Validation**: Proposal document has been signed off by humans
- **Execution mode**: 🤖→👤 AI suggests, human approves
- **Gate**: Proposal document has been signed off by humans → Not passed: Resubmit after supplementing data

### Stage 2: strategic-analysis

- **Skill**: strategic-analysis
- **Inputs**:
  - exploration_output: Exploration phase output (from user-research-user-modeling / opportunity-definition)
  - competitor_analysis: Competitor analysis data (from market-competitor-analysis → competitor-analysis.json)
  - bmc: BMC business model canvas (from docs/strategy/business-strategy.md ("Business Model Canvas" section))
  - market_data: Market data (from market-tam-som → tam-som.json, optional)
  - industry_info: Industry information (from market-pest → pest.json, optional)
  - internal_capability: Internal capability assessment (optional, user-provided)
  - product_definition: Current product definition (optional, user-provided)
  - market_definition: Current market definition (optional, user-provided)
  - growth_goal: Growth goal (optional, from planning-okr → okr.json)
- **Output**: `docs/strategy/PRODUCT_STRATEGY.md ("Strategic Analysis" section)`
- **Validation**: strategic-analysis.json has been generated, framework selection is reasonable, all selected frameworks are fully analyzed, strategic conclusions have been integrated, human decision items have been confirmed
- **Execution mode**: 🤖→👤 AI suggests, human approves
- **Gate**: Strategic conclusions have been integrated, human decision items have been confirmed → Not passed: Items with confidence < 0.6 are escalated for human calibration; strategic direction must be selected by humans

### Stage 3: Goal Setting (planning-north-star → planning-okr)

This stage executes two sub-skills sequentially: first call planning-north-star to generate North Star Metric candidates, after human selection, then call planning-okr to generate OKR candidates based on the North Star Metric, for human confirmation.

#### Step 1: planning-north-star

- **Skill**: planning-north-star
- **Inputs**:
  - user_value_data: User value data (from user-research-user-modeling / user-research-voice-analysis)
  - bmc: BMC business model canvas (from docs/strategy/business-strategy.md ("Business Model Canvas" section))
  - business_status: Business status data (optional, user-provided)
- **Output**: `docs/strategy/PRODUCT_STRATEGY.md ("North Star" section)` (north_star.json → output/metrics/north-star.json)
- **Validation**: North Star Metric has been selected by humans
- **Execution mode**: 👤→🤖 Human executes, AI assists
- **Gate**: North Star Metric has been selected by humans → Not passed: Must be a human decision, AI only provides analytical support

#### Step 2: planning-okr

- **Skill**: planning-okr
- **Inputs**:
  - swot_strategy: SWOT strategic direction (from Stage 2 `docs/strategy/PRODUCT_STRATEGY.md ("Strategic Analysis" section)` swot.strategies)
  - north_star: North Star Metric (from Stage 3 Step 1 `docs/strategy/PRODUCT_STRATEGY.md ("North Star" section)`)
  - bmc: BMC business model canvas (optional, from docs/strategy/business-strategy.md ("Business Model Canvas" section)
  - business_status: Business status data (optional, user-provided)
- **Output**: `docs/strategy/OKR.md` (okr.json)
- **Validation**: OKR has been confirmed by humans
- **Execution mode**: 🤖→👤 AI suggests, human approves
- **Gate**: OKR has been confirmed by humans → Not passed: Achievement probability < 0.3 is escalated for adjustment, > 0.9 is escalated to increase challenge

### Stage 4: planning-roadmap

- **Skill**: planning-roadmap
- **Inputs**:
  - okr: OKR objectives and Key Results (from Stage 3 `docs/strategy/OKR.md`)
  - swot_strategy: SWOT strategic direction (from Stage 2 `docs/strategy/PRODUCT_STRATEGY.md ("Strategic Analysis" section)` swot.strategies)
  - priority_score: Requirement priority score (optional, overridden by design-prd)
  - resource_constraints: Resource constraints (optional, user-provided)
- **Output**: `docs/strategy/roadmap.md` (roadmap.json)
- **Validation**: Roadmap resources have been approved by humans
- **Execution mode**: 🤖→👤 AI suggests, human approves
- **Gate**: Roadmap resources have been approved by humans → Not passed: Priority and resource allocation must be human decisions

### Stage Summary (post_pipeline)

After all sub-skills have executed, a stage summary document must be generated and written to `output/phase-reports/planning-orchestrator.json`, containing the following 6 structures (none can be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Each sub-skill's core output summary (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automatic decisions and rationale
4. **Output Inventory**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, suggested follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/strategy/ |
| Summary output path | output/phase-reports/planning-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: prd-orchestrator (Strategic planning complete, convert strategy into PRD)
  alternatives:
    - target: metrics-orchestrator
      reason: Need to design the measurement system before entering design
      condition: When KRs in OKR lack quantifiable metric support
    - target: iteration-orchestrator
      reason: Roadmap is ready, directly start iteration planning
      condition: When strategic planning is sufficient and quick entry into iteration execution is needed
  special_cases: []

## Stage Gates

| Gate | Condition | Fail Handling |
|------|------|------------|
| Product proposal approved | Proposal document has been signed off by humans | Resubmit after supplementing data |
| Strategic analysis completed | strategic-analysis.json has been generated and is non-empty | Items with confidence < 0.6 are escalated for human calibration; strategic direction must be selected by humans |
| Goal setting completed | North Star Metric has been selected by humans, OKR has been confirmed by humans | North Star must be a human decision; OKR with achievement probability < 0.3 is escalated for adjustment |
| Roadmap completed | Roadmap resources have been approved by humans | Priority and resource allocation must be human decisions |
| Stage summary generated | output/phase-reports/planning-orchestrator.json has been generated and all 6 structures are non-empty | Regenerate after supplementing missing structure items |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| A sub-skill in Stage 1 fails | Pause orchestration, output failure diagnostic information, request human intervention to fix and retry that stage |
| strategic-analysis framework selection exception | Default to SWOT framework, annotate "Framework selection downgraded to SWOT" |
| A framework analysis in strategic-analysis fails | Skip the failed framework, generate strategic conclusions based on completed frameworks, annotate "XX framework analysis missing" |
| Upstream data missing | Annotate missing data items, fill with reasonable assumptions (annotate confidence ≤ 0.3), continue execution and highlight in output |
| Key decision point not confirmed by humans | Pause orchestration, output list of items pending confirmation, wait for human confirmation to continue |
| All upstream data missing | Annotate "All data missing" status, output minimal template (only metadata and empty structures), set overall confidence to 0.3, force human confirmation on whether to continue. After human confirmation, generate based on user-provided information and AI knowledge base inference, all inferred content tagged with confidence ≤ 0.5 and needs_human_validation: true |
| Stage summary generation fails | Generate partial summary based on completed sub-skill outputs, missing items annotated as "Data missing", does not block orchestration completion |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Project initiation approval | Stage 1 product-proposal generates product proposal document | Human decides whether to initiate the project |
| Strategic direction selection | Stage 2 strategic-analysis generates strategic conclusions | Human selects the final strategic direction and growth path |
| Goal setting confirmation | Stage 3 planning-north-star generates North Star candidates for human selection, planning-okr generates OKR candidates for human confirmation | Human selects the North Star Metric and confirms the OKR |
| Roadmap priority | Stage 4 planning-roadmap calculates RICE scores and ranks | Human decides the final priority and resource allocation |
