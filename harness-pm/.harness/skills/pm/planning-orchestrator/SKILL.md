---
name: planning-orchestrator
description: Use when you need to do product project initiation, strategic planning, or roadmap creation. Strategic planning commander, orchestrating sub-skills such as product proposal, strategic analysis (SWOT/Ansoff/Porter's Five Forces), OKR, North Star, and roadmap.
---
# Strategic Planning & Roadmap Commander

## When to use
- Help me with product project initiation
- Create a strategic plan
- Set OKR objectives
- Plan the product roadmap
- Do a SWOT analysis
- Keywords: project initiation, strategic planning, SWOT, OKR, roadmap, strategic analysis, setting objectives, product planning, annual planning

## Inputs
- rules/security.md
- loops/LOOP.md
- templates/orchestrator-protocol.md
- docs/strategy/PRODUCT_STRATEGY.md
- docs/strategy/OKR.md
- docs/strategy/roadmap.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- output/phase-reports/planning-orchestrator.json
- output/approvals/planning-orchestrator/{stage-id}.approval.json

## Core Principles

Ensure doing the right things, rather than doing things right.

1. **Strategic alignment cascades** — From vision to OKR to roadmap, ensure each layer's objectives can be traced back to the upper layer's strategic intent
2. **Resource constraints up front** — Introduce resource boundary conditions during the planning phase to avoid producing idealized roadmaps that cannot be executed
3. **Decision points are not deferred** — Strategic choices at each stage must be completed in the current stage; passing "TBD" status downstream is prohibited

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

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

  - id: phase-4
    name: "OKR Setting"
    depends_on: [phase-3]
    skills:
      - planning-okr
    gate:
      condition: "OKR has been confirmed by humans"
      fail_action: "OKR with achievement probability < 0.3 is escalated for adjustment"

  - id: phase-5
    name: "Roadmap"
    depends_on: [phase-4]
    skills:
      - planning-roadmap
    gate:
      condition: "Roadmap resources have been approved by humans"
      fail_action: "Priority and resource allocation must be human decisions"
```

## Phase Execution Plan

> Compact routing table. Sub-skill Inputs/Outputs/Validation live in each sub-skill's SKILL.md — do not duplicate here. "Key upstream" notes only when the input source is non-obvious.

| Phase | Skill | Mode | Gate condition | Fail action |
|-------|-------|------|----------------|-------------|
| phase-1 | product-proposal | 🤖→👤 | Proposal document has been signed off by humans | Resubmit after supplementing data |
| phase-2 | strategic-analysis | 🤖→👤 | strategic-analysis.json has been generated, strategic conclusions have been integrated, human decision items have been confirmed | Items with confidence < 0.6 are escalated for human calibration; strategic direction must be selected by humans |
| phase-3 | planning-north-star | 👤→🤖 | North Star Metric has been selected by humans | North Star must be a human decision |
| phase-4 | planning-okr | 🤖→👤 | OKR has been confirmed by humans | OKR with achievement probability < 0.3 is escalated for adjustment |
| phase-5 | planning-roadmap | 🤖→👤 | Roadmap resources have been approved by humans | Priority and resource allocation must be human decisions |

**Key upstream notes** (only for non-obvious cross-module inputs):
- phase-1 product-proposal: inputs from market-orchestrator (competitor-analysis, tam-som) and user-research-orchestrator (user-research-report), not local docs/
- phase-2 strategic-analysis: inputs from market-orchestrator (competitor-analysis, tam-som, pest) and user-research-orchestrator (user-modeling, opportunity-definition)
- phase-3 planning-north-star: inputs from user-research-orchestrator (user-modeling, voice-analysis), not local docs/

### Phase Summary (post_pipeline)

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

## Phase Gates

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
