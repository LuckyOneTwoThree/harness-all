---
name: prd-orchestrator
description: Use when you need to generate a PRD or assess the impact of PRD changes. Product Requirements Commander, orchestrating design-prd/change-impact-analysis. Responsible for PRD generation and PRD change impact assessment. Visual/interaction/component/prototype design outputs have been migrated to harness-design; this orchestrator only handles the PM-compliant product requirements portion. Keywords: product design, PRD, write PRD, product documentation, requirements document, change impact analysis.
metadata:
  module: "Product Ideation & Design"
  sub-module: "Product Requirements"
  type: "orchestrator"
  version: "11.0"
  domain_tags: ["General"]
  triggers:
    - "Help me write a PRD"
    - "Generate a product requirements document"
    - "The PRD has changed, analyze the impact"
    - "Assess the impact scope of this requirement change"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/product/PRD.md
writes:
  - docs/product/PRD.md
  - docs/handoff/pm-to-design.md
  - docs/handoff/pm-to-solo.md
  - output/phase-reports/prd-orchestrator.json
  - memory/progress.md
  - memory/knowledge-base.md
---

# Product Requirements Commander

## Core Principles

1. **Upstream quality determines downstream efficiency** — PRD quality gates cannot be bypassed; garbage in, garbage out
2. **PRD is the single contract** — PM collaborates with downstream (design/solo) through PRD + AC-xxx numbering, and does not directly produce design files
3. **Changes must assess impact** — When the PRD changes, trigger change-impact-analysis to assess the impact on downstream design/engineering

## Responsibility Boundaries

This orchestrator **only handles the PM-compliant product requirements portion**:
- ✅ PRD generation (design-prd)
- ✅ PRD change impact analysis (change-impact-analysis)
- ✅ Collaboration with downstream through `docs/handoff/pm-to-design.md` and `docs/handoff/pm-to-solo.md`

This orchestrator **is not responsible** for the following (migrated to harness-design):
- ❌ Information Architecture (IA) → harness-design's wireframe + design-brief
- ❌ User flows → harness-design's interaction-design
- ❌ Prototype design → harness-design's wireframe + visual-design
- ❌ Interaction specifications → harness-design's interaction-design
- ❌ Design handoff → harness-design's design-handoff-spec

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
    name: "UI Feedback Handling"
    depends_on: []
    skills: []
    trigger: When user-provided (UI/UX feedback) exists
    gate:
      condition: "Feedback suggestions have been evaluated, accept/reject decisions made"
      fail_action: "Annotate unprocessed feedback, do not block main flow"

  - id: phase-1
    name: "Product Requirements Document"
    depends_on: [phase-0]
    skills: [design-prd]
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

#### Handle UI Feedback (phase-0, conditional execution)

```
Trigger condition: User-provided (UI/UX feedback) exists
Action: Evaluate UI→PM feedback suggestions
Input:
  design_feedback: User-provided (UI/UX feedback)
Process flow:
  1. Read design_feedback.json
  2. Group suggestions by target_artifact
  3. Evaluate each suggestion:
     - Accept: Mark as accepted, include in subsequent phase modification scope
     - Reject: Mark as rejected, record rejection reason
  4. ⏸ Human confirms feedback processing results
  5. For accepted suggestions:
     - If target_artifact is prd.json: Include in modification scope in phase-1
  6. Delete design_feedback.json after processing to avoid duplicate consumption
Output: Feedback processing results (accepted/rejected list)
Validation: Feedback suggestions have been evaluated item by item, processing results confirmed by human
Mode: 🤖→👤
```

#### Call design-prd

```
Skill: design-prd
Input:
  ideation_workshop: docs/product/PRD.md ("Creative Solutions" section)
  strategic_output: User-provided
  requirement_context: User-provided (product_name required)
Output: docs/product/PRD.md
Validation: All 4 PRD quality gates passed
Mode: 🤖→👤
```

#### Call change-impact-analysis

```
Skill: change-impact-analysis
Input:
  prd_change: User-provided (PRD change content)
  current_prd: docs/product/PRD.md
Output: docs/product/PRD.md ("Change Impact Analysis" section)
Validation: Impact matrix covers all downstream outputs; rework list is actionable
Mode: 🤖→👤
```

> Note: Change impact analysis previously assessed the impact on design outputs such as IA/userflow/prototype/interaction-spec.
> These outputs have been migrated to harness-design. This phase now only assesses the impact on the PRD itself and downstream handoff contracts.
> Impact assessment on design outputs is handled by harness-design, notified via docs/handoff/pm-to-design.md.

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
    - target: harness-design (handoff via docs/handoff/pm-to-design.md)
      reason: After PRD is confirmed, harness-design consumes PRD for visual/interaction/component design
      condition: Handoff document generation is automatically triggered after PRD passes quality gates
    - target: harness-solo (handoff via docs/handoff/pm-to-solo.md)
      reason: After PRD is confirmed, harness-solo consumes PRD + AC-xxx for engineering implementation
      condition: Handoff document generation is automatically triggered after PRD passes quality gates

## Phase Gates

| Gate | Condition | Failure Handling |
|------|------|------------|
| PRD generation complete | design-prd output file generated and non-empty | Gate 1 or 2 failure blocks the flow, output missing items list |
| Change impact analysis complete | change-impact-analysis output file generated and non-empty | Supplement missing downstream impact items |
| Phase summary generated | output/phase-reports/prd-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| UI feedback processing confirmation | phase-0, when design_feedback.json exists | Confirm accept/reject of UI-side feedback suggestions |
| PRD tier confirmation | AI auto-tiering confidence <0.7 | Confirm PRD tier (L/S/X) |
