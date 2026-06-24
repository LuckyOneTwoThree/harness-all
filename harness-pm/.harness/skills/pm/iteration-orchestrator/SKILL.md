---
name: iteration-orchestrator
description: Used when planning iteration cycles or adjusting product priorities. Iteration Decision Commander that dispatches iteration-backlog-grooming and iteration-retrospective sub-skills. Keywords: iteration decision, Backlog optimization, priority adjustment, iteration retrospective, iteration planning, requirement restructuring, RICE scoring, iteration management. This orchestrator dispatches 2 sub-skills, responsible for Backlog grooming and iteration retrospective respectively.
metadata:
  module: "Product Monitoring & Iteration"
  sub-module: "Iteration Optimization"
  type: "orchestrator"
  version: "11.0"
  domain_tags: ["General"]
  triggers:
    - "Plan the next iteration"
    - "Adjust priorities"
    - "Optimize the Backlog"
    - "Run an iteration retrospective"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/monitoring/iteration-plan.md
  - docs/monitoring/iteration-retrospective.md
  - docs/handoff/growth-to-pm.md
  - docs/handoff/ops-to-pm.md
writes:
  - output/phase-reports/iteration-orchestrator.json
  - memory/progress.md
  - memory/knowledge-base.md
---

# Iteration Decision Commander

## Core Principles

**Data-driven priority decisions, balancing short-term fixes with long-term value**

Iteration is not simply queuing requirements; it is making optimal trade-offs under constrained resources. Every priority adjustment seeks a balance between short-term fixes and long-term value. Data informs decisions but does not make them.

## Orchestration Philosophy

1. **Backlog optimization first, priority adjustment follows**: First optimize the Backlog to establish a clear priority baseline, then adjust based on trigger events—avoid adjusting on a chaotic Backlog
2. **Retrospective conclusions loop back to Backlog**: Improvement suggestions from iteration retrospectives must flow back to Backlog optimization, forming a continuous improvement loop of "execute → retrospective → optimize"

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

### Orchestrator-Specific Conventions

This orchestrator dispatches 2 sub-skills: iteration-backlog-grooming (Backlog grooming) and iteration-retrospective (iteration retrospective). The two sub-skills form a clear unidirectional data flow: Backlog grooming → iteration retrospective, eliminating circular dependencies entirely.

> Note: iteration-retrospective's iteration plan and completion data are provided by the user or read from the project management system, with no cross-module hard dependencies.

## Pipeline

```yaml
pipeline: iteration-orchestrator
version: 11.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/iteration-orchestrator.json

stages:
  - id: phase-1
    name: "Backlog Grooming"
    depends_on: []
    skills: [iteration-backlog-grooming]
    gate:
      condition: "iteration-backlog-grooming output file generated and prioritized_items non-empty"
      fail_action: "Handle per sub-skill failure reason, escalate to human if necessary"
  - id: phase-2
    name: "Iteration Retrospective"
    depends_on: [phase-1]
    skills: [iteration-retrospective]
    gate:
      condition: "iteration-retrospective output file generated"
      fail_action: "Handle per sub-skill failure reason, escalate to human if necessary"
```

## Stage Execution Plan

#### Call iteration-backlog-grooming (phase-1)

```
Skill: iteration-backlog-grooming
Inputs:
  requirement_pool: Project management system (requirement pool)
  tech_debt: Code quality platform (technical debt)
  monitoring_alerts: monitoring-alert-detection → alert data (optional)
  user_feedback: Feedback system (optional)
  resource_constraints: User-provided (optional)
  quality_metrics: Test platform/CI/CD (optional)
  monitoring_data: monitoring-alert-detection (optional)
Output: docs/monitoring/iteration-plan.md
Validation: Output file generated and prioritized_items non-empty
Mode: 🤖→👤
Note: No cross-module dependencies, can execute independently. Outputs prioritized_items for iteration-retrospective or downstream consumption.
```

#### Call iteration-retrospective (phase-2)

```
Skill: iteration-retrospective
Inputs:
  current_sprint_plan: User-provided or project management system (Sprint plan)
  iteration_completion: User-provided or project management system (iteration completion)
  resource_constraints: User-provided (optional)
  trigger_event: Monitoring system/feedback system (optional)
  change_request: User-provided (optional)
  quality_metrics: Test platform/CI/CD
  team_feedback: Retro tool (optional)
  monitoring_data: monitoring-alert-detection (optional)
  monitoring_alerts: monitoring-alert-detection (optional)
Output: docs/monitoring/iteration-retrospective.md
Validation: Output file generated and content complete
Mode: 👤↔🤖
Note: Iteration plan and completion data are provided by the user or read from the project management system.
```

### Stage Summary (post_pipeline)

After all sub-skills complete, a stage summary document must be generated and written to `output/phase-reports/iteration-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Deliverables List**: All output file paths and content summaries, deliverable quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, suggested follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/monitoring/ |
| Summary output path | output/phase-reports/iteration-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: prd-orchestrator (iteration retrospective complete, write iteration requirement changes to PRD)
  alternatives:
    - target: release-orchestrator
      reason: Iteration decision is for direct release
      condition: When iteration decision is for hotfix or minor version release
    - target: monitoring-orchestrator
      reason: Enhanced monitoring needed after iteration
      condition: When iteration involves core feature changes requiring enhanced post-launch monitoring
  special_cases: []

## Stage Gates

| Gate | Condition | Handling on Failure |
|------|------|------------|
| phase-1 output file generated | iteration-backlog-grooming output generated and prioritized_items non-empty | Handle per sub-skill failure reason, escalate to human if necessary |
| phase-2 output file generated | iteration-retrospective output generated | Handle per sub-skill failure reason, escalate to human if necessary |
| Stage summary generated | output/phase-reports/iteration-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structures |

## Downstream Handoff

- Backlog grooming complete → prd-orchestrator (consumes prioritized_items to update PRD)
- Iteration retrospective complete → prd-orchestrator (update PRD changes)
- Hotfix/minor version → release-orchestrator
- Core feature changes requiring monitoring → monitoring-orchestrator

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Backlog grooming result confirmation | iteration-backlog-grooming priority sorting complete | Confirm whether priority sorting and restructuring suggestions are adopted |
| Iteration adjustment plan confirmation | iteration-retrospective priority adjustment plan generated | Confirm adjustment plan, resource reallocation, and risk acceptance |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Sub-skill execution failure | Roll back to current stage and retry, max 1 retry; if still fails, mark exception and escalate to human |
| Upstream data missing | Mark missing data items, fill with reasonable assumptions, continue execution and highlight in output |
| Stage summary generation failure | Generate partial summary based on completed sub-skill outputs, mark missing items as "data missing", do not block orchestration completion |
