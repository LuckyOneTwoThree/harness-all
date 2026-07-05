---
name: market-orchestrator
description: Used when a complete market and competitive analysis workflow is required. Market & Competition Orchestrator, dispatches market-tam-som/pest/competitor-analysis.
---
# Market & Competition Orchestrator

## When to use
- Help me analyze the market
- See what competitors are doing
- Evaluate the market size
- Conduct competitive research
- Analyze industry trends
- Keywords: market analysis, competitive analysis, TAM/SAM/SOM, PEST, competitive intelligence, four-quadrant, market size, industry analysis, competitors, competitive research

## Inputs
- rules/security.md
- loops/LOOP.md
- templates/orchestrator-protocol.md
- docs/discovery/market-analysis.md

## Outputs
- output/phase-reports/market-orchestrator.json
- memory/progress.md

## Core Principles

1. **Market is a dynamic ecosystem** — The market is not a static arena; competitors flow, users migrate, and technology evolves. The orchestrator ensures analysis results are timestamped and a re-evaluation cycle is recommended.
2. **Macro-micro cross-validation** — TAM/PEST provide the macro view, competitor-analysis provides the micro view. Conclusions must integrate both macro and micro perspectives; single-perspective conclusions are unreliable.
3. **Parallel collection, serial integration** — TAM and PEST can be collected in parallel; competitor-analysis depends on macro inputs, so dependent steps must run serially.
4. **Human validation at key checkpoints** — Human judgment is required when TAM dual-path divergence > 20%; human validation is required when competitor strategy inference confidence is low; human confirmation is required for differentiation strategy prioritization.

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline Definition

```yaml
pipeline: market-orchestrator
version: 9.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/market-orchestrator.json

stages:
  - id: phase-1
    name: "Parallel Collection"
    skills:
      - market-tam-som
      - market-pest
    gate:
      condition: "tam-som.json + pest.json are both generated and pass validation"
      fail_action: "Provide additional category keywords and target market information, or check sub-skill execution results"

  - id: phase-2
    name: "Competitive Analysis"
    depends_on: [phase-1]
    skills: [market-competitor-analysis]
    gate:
      condition: "Executive summary contains 3 core findings + Top 1 strategy, four quadrants are populated, Feature Matrix is updated"
      fail_action: "Check whether the competitor list is sufficient or whether upstream data is complete"
```

## Phase Execution Plan

### Phase 1: Parallel Collection

#### Invoke market-tam-som

```
Skill: market-tam-som
Inputs:
  category_keywords: User-provided (category keywords)
  target_market: User-provided (target market geographic scope)
  time_range: User-provided (estimation time range)
Output: docs/discovery/market-analysis.md ("Market Size" section)
Validation: TAM/SAM/SOM three-tier estimation complete, each tier includes range estimates (optimistic/neutral/conservative), key assumptions annotated
Mode: 🤖→👤
```

#### Invoke market-pest

```
Skill: market-pest
Inputs:
  category_keywords: User-provided (category keywords)
  target_market: User-provided (target market)
Output: docs/discovery/market-analysis.md ("PEST Analysis" section)
Validation: All four dimensions (political/economic/social/technological) scanned, at least 3 trend summaries per dimension
Mode: 🤖
```

⏸ **Stage Gate**: tam-som.json + pest.json are both generated and pass validation → Not passed: Provide additional category keywords and target market information, or check sub-skill execution results

### Phase 2: Competitive Analysis

#### Invoke market-competitor-analysis

```
Skill: market-competitor-analysis
Inputs:
  competitor_list: User-provided (competitor list)
  category_keywords: User-provided (category keywords)
  monitor_config: User-provided (monitoring config, optional)
  tam_som_ref: docs/discovery/market-analysis.md ("Market Size" section)
  pest_ref: docs/discovery/market-analysis.md ("PEST Analysis" section)
  product_info: User-provided (own product info, optional)
Output: docs/discovery/market-analysis.md ("Competitive Analysis" section)
Validation: Executive summary contains 3 core findings + Top 1 strategy, four quadrants populated, Feature Matrix updated, at least 3 differentiation strategies
Mode: 🤖→👤
```

⏸ **Stage Gate**: Executive summary contains 3 core findings + Top 1 strategy, four quadrants populated, Feature Matrix updated → Not passed: Check whether the competitor list is sufficient or whether upstream data is complete

### Phase Summary (post_pipeline)

After all sub-skills complete execution, a stage summary document must be generated and written to `output/phase-reports/market-orchestrator.json`, containing the following 6 structural sections (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Record**: Human decision points and decision results, AI automated decisions and rationale
4. **Output Inventory**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks & Follow-ups**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/discovery/ |
| Summary output path | output/phase-reports/market-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: opportunity-definition (Market analysis complete; define product opportunities based on market size and competitive landscape)
  alternatives:
    - target: insight-analysis
      reason: Market data lacks user perspective; user insight supplementation needed
      condition: When market analysis conclusions lack user demand validation
    - target: positioning-strategy
      reason: Market landscape is clear; proceed directly to positioning strategy
      condition: When competitive analysis is sufficient and differentiated positioning needs to be determined
  special_cases:
    - target: market-competitor-analysis
      reason: Only competitor intelligence update needed; no full market analysis required
      condition: When market size is already assessed and only competitor dynamics tracking is needed

## Phase Gates

| Gate | Condition | Not-Passed Handling |
|------|------|------------|
| Stage 1 complete | tam-som.json + pest.json are both generated and non-empty | Provide additional category keywords and target market information, or check sub-skill execution results |
| Stage 2 complete | `docs/discovery/market-analysis.md` ("Competitive Analysis" section) is generated and non-empty | Check whether the competitor list is sufficient or whether upstream data is complete |
| Stage summary generated | output/phase-reports/market-orchestrator.json is generated and all 6 structural sections are non-empty | Regenerate after supplementing missing structural sections |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| TAM/SAM/SOM key assumption validation | market-tam-som complete | Confirm whether key assumptions are reasonable; human judgment required when dual-path divergence > 20% |
| Competitor strategy inference validation | market-competitor-analysis complete, strategy inference confidence < 0.5 | Confirm whether competitor strategic direction inference is reasonable |
| Differentiation strategy prioritization confirmation | market-competitor-analysis complete | Confirm the prioritization and resource allocation of differentiation strategies |
| Report conclusions and action recommendations approval | market-competitor-analysis complete | Approve final conclusions and action recommendations of the competitive analysis report |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| A sub-skill in Stage 1 fails | Do not block the other sub-skill; the failed sub-skill continues with a degraded solution, marked as "degraded execution" |
| Market Size dual-path divergence > 30% | Mark as "severe dual-path divergence", escalate to human judgment, use neutral values in the report |
| A dimension in PEST Analysis has completely missing data | Fill with industry benchmark values, mark as "inferred value", annotate the dimension as incomplete in the report |
| competitor-analysis competitor list is empty | Prompt user to provide competitor list or category keywords; infer competitors based on AI knowledge, mark as "competitor list is AI-inferred" |
| A quadrant in competitor-analysis is empty | Mark as "no competitors identified in this quadrant", suggest user provide leads, annotate quadrant coverage as incomplete in the report |
| All upstream data missing | Degrade to lightweight workflow: user provides category keywords → generate brief competitive analysis report based on AI knowledge base |
| Stage summary generation fails | Generate partial summary based on completed sub-skill outputs, mark missing items as "data missing", do not block orchestrator completion |
