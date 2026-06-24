---
name: validation-orchestrator
description: Used when validating product solutions. Solution validation sub-module orchestrator, dispatches sub-skills: validation-assumption-map, validation-mvp, validation-experiment, validation-usability. Keywords: solution validation, hypothesis validation, MVP, usability testing, experiment design, assumption map, risk assessment, validate idea, minimum viable product.
metadata:
  module: "Product Ideation & Design"
  sub-module: "Solution Validation"
  type: "orchestrator"
  version: "6.1"
  domain_tags: ["General"]
  triggers:
    - "Validate the product solution"
    - "Design MVP scope"
    - "Do some hypothesis validation"
    - "Assess the solution risks"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/product/PRD.md
  - docs/metrics/experiment-report.md
writes:
  - output/phase-reports/validation-orchestrator.json
  - memory/progress.md
  - memory/knowledge-base.md
---

# Solution Validation Orchestrator

## Core Principles

1. **Validate hypotheses, not solutions**—acquire maximum confidence at minimum cost; the goal of MVP is learning, not delivery
2. **Hypothesis-driven validation order**—validate highest-risk hypotheses first; validation results determine solution direction
3. **Validation loop must be complete**—hypothesis→experiment→data→conclusion→decision; any broken link is waste

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Sub-skill output file missing | Block current stage, prompt human to supplement upstream input or provide alternative data |
| Assumption map incomplete feature coverage | Flag missing feature points, suggest human confirm whether to supplement hypotheses |
| MVP share exceeds 60% | Escalate to human judgment, output trimming recommendations, confirm whether to adjust MVP scope |
| Experiment plan cannot meet statistical significance | Lower confidence level or increase sample size, mark "insufficient statistical power" |
| Usability test participants fewer than 5 | Results for reference only, mark "insufficient sample size", suggest supplementary testing |
| Human decision timeout without response | Pause orchestration flow, preserve current state, wait for human decision to continue |
| Context approaching limit | Prioritize preserving current stage content, summarize completed stage outputs as key conclusions written to file |
| Stage summary generation fails | Generate partial summary based on completed sub-skill outputs, missing items marked "data missing", do not block orchestration completion |

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: validation-orchestrator
version: 6.1

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/validation-orchestrator.json

stages:
  - id: phase-1
    name: "Assumption Map"
    depends_on: []
    skills: [validation-assumption-map]
    gate:
      condition: "Maximum risk hypothesis identified, at least 1 hypothesis per feature point"
      fail_action: "At least 1 hypothesis per feature point, maximum risk hypothesis must have a validation plan"

  - id: phase-2
    name: "MVP Scope Definition"
    depends_on: [phase-1]
    skills: [validation-mvp]
    gate:
      condition: "MVP share < 60%, Must Have features all have hypothesis associations"
      fail_action: "MVP share > 60% escalate to human judgment, confirm whether to adjust"

  - id: phase-3
    name: "Experiment Design"
    depends_on: [phase-1, phase-2]
    skills: [validation-experiment]
    gate:
      condition: "Experiment plan human-reviewed, includes validation method, sample size, duration, termination conditions"
      fail_action: "All experiment plans must be human-reviewed"

  - id: phase-4
    name: "Usability Testing"
    depends_on: [phase-1, phase-2, phase-3]  # phase-3 is conditional dependency: when phase-3 selects usability testing, phase-4 consumes phase-3's method selection
    skills: [validation-usability]
    gate:
      condition: "Problem severity grading reasonable (P0/P1/P2/P3), insights correspond to assumption map"
      fail_action: "Test execution must be led by a human researcher"
```

## Stage Execution Plan

#### Call validation-assumption-map

```
Skill: validation-assumption-map
Inputs:
  design_output: User-provided or harness-design output (optional)
  prd: docs/product/PRD.md
Output: docs/product/PRD.md ("Assumption Map" section)
Validation: Maximum risk hypothesis identified, at least 1 hypothesis per feature point
Mode: 🤖
```

#### Call validation-mvp

```
Skill: validation-mvp
Inputs:
  design_output: User-provided or harness-design output (optional)
  assumption_map: docs/product/PRD.md ("Assumption Map" section)
  resource_constraints: Optional
Output: docs/product/PRD.md ("MVP Plan" section)
Validation: MVP share < 60%, Must Have features all have hypothesis associations
Mode: 🤖→👤
```

#### Call validation-experiment

```
Skill: validation-experiment
Inputs:
  assumption_map: docs/product/PRD.md ("Assumption Map" section)
  mvp_scope: docs/product/PRD.md ("MVP Plan" section)
  traffic_data: Optional (available traffic/user data)
Output: docs/metrics/experiment-report.md ("Experiment Design" section)
Validation: Experiment plan human-reviewed, includes validation method, sample size, duration, termination conditions
Mode: 🤖→👤
```

#### Call validation-usability

```
Skill: validation-usability
Inputs:
  test_plan: docs/product/PRD.md ("Assumption Map" section)
  participants: User-provided
  test_scenarios: User-provided or harness-design output
  experiment_method: docs/metrics/experiment-report.md ("Experiment Design" section)
Output: docs/product/PRD.md ("Usability Testing" section)
Validation: Problem severity grading reasonable (P0/P1/P2/P3), insights correspond to assumption map
Mode: 👤→🤖
```

### Stage Summary (post_pipeline)

After all sub-skills complete execution, a stage summary document must be generated and written to `output/phase-reports/validation-orchestrator.json`, containing the following 6 structures (none can be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary of each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Record**: Human decision points and decision results, AI automatic decisions and rationale
4. **Output Inventory**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed with degradation, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/product/ and docs/metrics/ |
| Summary output path | output/phase-reports/validation-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: prd-orchestrator (solution validation complete, update PRD based on validation conclusions)
  alternatives:
    - target: experiment-orchestrator
      reason: Validation conclusion needs A/B testing for further confirmation
      condition: When validation result is uncertain (confidence < 80%), needs quantitative experiment validation
    - target: ideation-workshop
      reason: Validation negates current solution, needs re-ideation divergence
      condition: When MVP validation conclusion is negative, core hypothesis not established
  special_cases:
    - target: validation-usability
      reason: Only usability testing needed, no full validation flow required
      condition: When solution has passed hypothesis validation, only user experience testing needed

## Stage Gates

| Gate | Condition | Non-pass Handling |
|------|------|------------|
| Assumption map complete | validation-assumption-map output file generated and non-empty | At least 1 hypothesis per feature point, maximum risk hypothesis must have a validation plan |
| MVP scope complete | validation-mvp output file generated and non-empty | MVP share > 60% escalate to human judgment, confirm whether to adjust |
| Experiment design complete | Experiment plan human-reviewed | All experiment plans must be human-reviewed |
| Usability testing complete | validation-usability output file generated and non-empty | Test execution must be led by a human researcher |
| Stage summary generated | output/phase-reports/validation-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| MVP scope confirmation | MVP scope definition complete, MVP share > 60% or Must Have disputed | Human approval and decide final MVP scope |
| Experiment plan review | Experiment plan design complete | Human review and approve experiment plan |
| Validation conclusion decision | Usability testing complete, validation data organized | Human makes final product solution decision |
