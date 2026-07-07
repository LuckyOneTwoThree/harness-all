---
name: iteration-orchestrator
description: Used when planning iteration cycles or adjusting product priorities. Iteration Decision Commander that dispatches iteration-backlog-grooming and iteration-retrospective sub-skills. This orchestrator dispatches 2 sub-skills, responsible for Backlog grooming and iteration retrospective respectively.
---
# Iteration Decision Commander

## When to use
- Plan the next iteration
- Adjust priorities
- Optimize the Backlog
- Run an iteration retrospective
- Triage engineering feedback from harness-engineering (`docs/handoff/engineering-to-pm.md`) and feed accepted items into the iteration pipeline
- Keywords: iteration decision, Backlog optimization, priority adjustment, iteration retrospective, iteration planning, requirement restructuring, RICE scoring, iteration management

## Inputs
- rules/security.md
- loops/LOOP.md
- templates/orchestrator-protocol.md
- docs/monitoring/iteration-plan.md
- docs/monitoring/iteration-retrospective.md
# Note: engineering-to-pm.md is consumed by prd-orchestrator phase 0 Branch B, not directly by this orchestrator

## Outputs
- output/phase-reports/iteration-orchestrator.json
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

**Data-driven priority decisions, balancing short-term fixes with long-term value**

Iteration is not simply queuing requirements; it is making optimal trade-offs under constrained resources. Every priority adjustment seeks a balance between short-term fixes and long-term value. Data informs decisions but does not make them.

> **Engineering-feedback-driven trigger path**: When `docs/handoff/engineering-to-pm.md` is consumed, PM session-start routes accepted engineering feedback to prd-orchestrator phase 0 Branch B (engineering feedback triage). Branch B triages each feedback item (accept/reject/defer) and routes accepted PRD-impact items to phase 1 (design-prd) for PRD update with 4 quality gates. Iteration-orchestrator consumes the PRD changes (if any) produced by phase 1 to drive Backlog priority adjustment. Engineering feedback thus flows: `engineering-to-pm.md` → session-start → prd-orchestrator phase 0 Branch B → phase 1 (PRD update) → iteration-orchestrator (Backlog re-prioritization). Iteration-orchestrator never directly consumes `engineering-to-pm.md` (Branch B owns triage); it consumes the PRD changes downstream.

## Orchestration Philosophy

1. **Backlog optimization first, priority adjustment follows**: First optimize the Backlog to establish a clear priority baseline, then adjust based on trigger events—avoid adjusting on a chaotic Backlog
2. **Retrospective conclusions loop back to Backlog**: Improvement suggestions from iteration retrospectives must flow back to Backlog optimization, forming a continuous improvement loop of "execute → retrospective → optimize"

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

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

## Phase Execution Plan

> Compact routing table. Sub-skill Inputs/Outputs/Validation live in each sub-skill's SKILL.md — do not duplicate here. "Key upstream" notes only when the input source is non-obvious.

| Phase | Skill | Mode | Gate condition | Fail action |
|-------|-------|------|----------------|-------------|
| phase-1 | iteration-backlog-grooming | 🤖→👤 | iteration-backlog-grooming output file generated and prioritized_items non-empty | Handle per sub-skill failure reason, escalate to human if necessary |
| phase-2 | iteration-retrospective | 👤↔🤖 | iteration-retrospective output file generated | Handle per sub-skill failure reason, escalate to human if necessary |

**Key upstream notes** (only for non-obvious cross-module inputs):
- phase-1 iteration-backlog-grooming: monitoring_alerts/monitoring_data optionally from monitoring-orchestrator (monitoring-alert-detection); no hard cross-module dependency, can execute independently
- phase-2 iteration-retrospective: monitoring_data/monitoring_alerts optionally from monitoring-orchestrator (monitoring-alert-detection)

### Phase Summary (post_pipeline)

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

## Phase Gates

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
- Engineering feedback consumed (via prd-orchestrator phase 0 Branch B → phase 1 PRD update) → iteration-orchestrator re-prioritizes Backlog based on the PRD delta (engineering-feedback-driven trigger path)

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
