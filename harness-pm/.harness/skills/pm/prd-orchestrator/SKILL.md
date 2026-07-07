---
name: prd-orchestrator
description: Use when you need to generate a PRD or assess the impact of PRD changes. Product Requirements Commander, orchestrating design-prd/change-impact-analysis. Responsible for PRD generation and PRD change impact assessment. Visual/interaction/component/prototype design assets are user-provided (Figma/v0/md); PM only collects their paths in pm-to-engineering.md. This orchestrator only handles the PM-compliant product requirements portion.
---
# Product Requirements Commander

## When to use
- Help me write a PRD
- Generate a product requirements document
- The PRD has changed, analyze the impact
- Assess the impact scope of this requirement change
- Keywords: product design, PRD, write PRD, product documentation, requirements document, change impact analysis

## Inputs
- rules/security.md
- loops/LOOP.md
- templates/orchestrator-protocol.md
- docs/product/PRD.md

## Outputs
- docs/product/PRD.md
- docs/product/prd.json
- output/phase-reports/prd-orchestrator.json
- memory/progress.md
- memory/knowledge-base.md

> **Handoff publication note**: After PRD production, the handoff document (`pm-to-engineering.md`) is published centrally by the `session-end` skill, following the publication gate (SHA-256 verification + package structure + envelope integrity). prd-orchestrator does not directly produce handoff documents, to avoid bypassing Consumer Gate verification.

## Core Principles

1. **Upstream quality determines downstream efficiency** — PRD quality gates cannot be bypassed; garbage in, garbage out
2. **PRD is the single contract** — PM collaborates with downstream (engineering) through PRD + AC-xxx numbering; design assets are user-provided (Figma/v0/md), PM only collects their paths
3. **Changes must assess impact** — When the PRD changes, trigger change-impact-analysis to assess the impact on downstream design/engineering

## Responsibility Boundaries

This orchestrator **only handles the PM-compliant product requirements portion**:
- ✅ PRD generation (design-prd)
- ✅ PRD change impact analysis (change-impact-analysis)
- ✅ Collaboration with downstream through `docs/handoff/pm-to-engineering.md`

This orchestrator **is not responsible** for the following (design assets are user-provided; PM only collects their paths in pm-to-engineering.md):
- ❌ Visual design (mockups, prototypes) → user-provided (Figma/v0/md/image)
- ❌ Interaction design specifications → user-provided
- ❌ Component design → user-provided
- ❌ Design asset production → user-owned; PM only records paths

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Sub-skill output file missing | Block the current phase, output the missing items list, prompt human to supplement upstream input |
| Sub-skill quality check failed | Block entry to the next phase, output failed item details, prompt human to confirm whether to fix or accept the risk |
| Context approaching limit | Prioritize retaining current phase content, summarize completed phase outputs as key conclusions and write to file |
| Human decision timeout without response | Pause the orchestration flow, retain current state, wait for human decision to continue |
| Upstream input data format exception | Attempt compatible parsing; if parsing fails, degrade to user-provided description, annotate "data format exception" |
| Phase summary generation failed | Generate partial summary based on completed sub-skill outputs, mark missing items as "data missing", do not block orchestration completion |

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: prd-orchestrator
version: 11.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/prd-orchestrator.json

stages:
  - id: phase-0
    name: "Upstream Feedback Handling"
    depends_on: []
    skills: []
    trigger: When engineering feedback (engineering-to-pm) exists
    gate:
      condition: "Feedback suggestions have been evaluated, accept/reject decisions made"
      fail_action: "Annotate unprocessed feedback, do not block main flow"

  - id: phase-1
    name: "Product Requirements Document"
    depends_on: [phase-0]
    skills: [design-prd]
    trigger: User requests PRD generation/update (regular path) OR phase 0 Branch B outputs a change request for accepted PRD-impact items (Branch B path)
    gate:
      condition: "All 4 PRD quality gates passed"
      fail_action: "Gate 1 or 2 failure blocks the flow, output missing items list"

  - id: phase-2
    name: "Change Impact Analysis"
    depends_on: [phase-1]
    skills: [change-impact-analysis]
    trigger: Triggered when PRD changes
    gate:
      condition: "Impact matrix covers all downstream outputs, rework list is actionable"
      fail_action: "Supplement missing downstream impact items"
```

## Phase Execution Plan

> Compact routing table. Sub-skill Inputs/Outputs/Validation live in each sub-skill's SKILL.md — do not duplicate here. "Key upstream" notes only when the input source is non-obvious.

| Phase | Skill | Mode | Gate condition | Fail action |
|-------|-------|------|----------------|-------------|
| phase-0 | — (engineering-to-pm feedback triage, no sub-skill) | 🤖→👤 | Feedback suggestions have been evaluated, accept/reject decisions made | Annotate unprocessed feedback, do not block main flow |
| phase-1 | design-prd | 🤖→👤 | All 4 PRD quality gates passed | Gate 1 or 2 failure blocks the flow, output missing items list |
| phase-2 | change-impact-analysis | 🤖→👤 | Impact matrix covers all downstream outputs, rework list is actionable | Supplement missing downstream impact items |

**Key upstream notes** (only for non-obvious cross-module inputs):
- phase-0: inputs from harness-engineering (docs/handoff/engineering-to-pm.md + portable package), not local docs/
- phase-1 design-prd: trigger paths are (a) regular user request, or (b) phase-0 Branch B accepted PRD-impact change request; design assets user-owned (Figma/v0/md), not generated here

### Phase Summary (post_pipeline)

After all sub-skills have executed, a phase summary document must be generated and written to `output/phase-reports/prd-orchestrator.json`, containing the following 6 structures (none can be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automatic decisions and rationale
4. **Output List**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks & Todos**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/product/PRD.md |
| Summary output path | output/phase-reports/prd-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: metrics-orchestrator (PRD complete, design metrics system and tracking plan for features)
  alternatives:
    - target: validation-orchestrator
      reason: High-risk assumptions in PRD need validation
      condition: When features marked as high-risk in PRD account for >30%
  special_cases:
    - target: harness-engineering (handoff via docs/handoff/pm-to-engineering.md)
      reason: After PRD is confirmed, harness-engineering consumes PRD + AC-xxx + user-provided design asset paths for engineering implementation
      condition: PRD passes 4 quality gates → prd-orchestrator signals session-end → session-end publishes pm-to-engineering.md (publication gate: SHA-256 + envelope integrity)

## Phase Gates

| Gate | Condition | Failure Handling |
|------|------|------------|
| PRD generation complete | design-prd output file generated and non-empty | Gate 1 or 2 failure blocks the flow, output missing items list |
| Change impact analysis complete | change-impact-analysis output file generated and non-empty | Supplement missing downstream impact items |
| Phase summary generated | output/phase-reports/prd-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Engineering feedback processing confirmation | phase-0, when a ready engineering-to-pm package exists | Confirm accept/reject/defer decisions that change product scope or AC meaning |
| PRD tier confirmation | AI auto-tiering confidence <0.7 | Confirm PRD tier (L/S/X) |
