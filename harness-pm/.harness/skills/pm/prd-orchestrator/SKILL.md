---
name: prd-orchestrator
description: Use when you need to generate a PRD or assess the impact of PRD changes. Product Requirements Commander, orchestrating design-prd/change-impact-analysis. Responsible for PRD generation and PRD change impact assessment. Visual/interaction/component/prototype design outputs have been migrated to harness-design; this orchestrator only handles the PM-compliant product requirements portion.
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

> **Handoff publication note**: PRD 产出后，handoff 文档（`pm-to-solo.md` / `pm-to-design.md`）由 `session-end` skill 的步骤 6a/6b 统一发布，遵循 publication gate（SHA-256 校验 + 包结构 + envelope 完整性）。prd-orchestrator 不直接产 handoff 文档，避免绕过 Consumer Gate 校验。

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
    name: "Upstream Feedback Handling"
    depends_on: []
    skills: []
    trigger: When user-provided (UI/UX feedback) or engineering feedback (solo-to-pm) exists
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

#### Handle Upstream Feedback (phase-0, conditional execution)

phase-0 handles two parallel feedback sources: Design→PM feedback and Engineering→PM feedback. Both run the same accept/reject/defer triage pattern but differ in content type and downstream routing.

##### Branch A: Design Feedback (design-to-pm)

```
Trigger condition: a validated ready `design-to-pm` package exists, or equivalent user-provided UI/UX feedback exists
Action: Evaluate Design→PM feedback without granting Design write authority over the PRD
Input:
  design_feedback: docs/handoff/design-to-pm.md + its portable package (preferred), or user-provided feedback
Process flow:
  1. Validate envelope, consumer, manifest, hashes, freshness, and AC-ID parity using `.harness/rules/handoff-protocol.md`
  2. Evaluate every stable feedback_id as accept / reject / defer with rationale and owner
  3. ⏸ Human confirms any product-scope or acceptance-meaning change
  4. For accepted items, update authoritative PRD.md, allocate new IDs when meaning changes, then regenerate prd.json
  5. Write a receipt and archive the feedback unchanged; never delete the source contract or package
  6. Reference `ac_change`: when session-start step 5a has already written `state.yaml.ac_change` for this design-to-pm handoff, Branch A consumes it to scope triage rather than re-deriving the diff. Do NOT re-record the diff here. If prd-orchestrator is invoked independently without a prior session-start, write `ac_change` here per `state.schema.json`.
Output: docs/product/design-feedback-decisions/<handoff_id>.md + receipt + optional new PRD revision
Validation: every feedback_id has a decision; accepted changes preserve stable-ID rules; history remains auditable
Mode: 🤖→👤
```

##### Branch B: Engineering Feedback (solo-to-pm)

```
Trigger condition: a validated ready `solo-to-pm` package exists (envelope status: ready)
Action: Evaluate Engineering→PM feedback without granting Solo write authority over the PRD; route accepted items to the appropriate downstream (PRD update via phase 1 / design re-brief staging / knowledge-base note)
Input:
  engineering_feedback: docs/handoff/solo-to-pm.md + its portable package
Process flow:
  1. Validate envelope, consumer, manifest, hashes, freshness using `.harness/rules/handoff-protocol.md`
  2. When envelope contains a `batch` field, use batch-aware detection: first-consumption guard (if no prior solo-to-pm was consumed, treat all feedback as new) / incremental batch (use batch.added_acs as primary signal for new feedback) / full or legacy fallback (set-diff on Affects AC)
  3. Pre-filter: if envelope contains batch.superseded_acs, identify feedback items whose owning ACs are in batch.superseded_acs. Mark these as "already-decided" and skip them in step 4 triage. Only triage items in batch.added_acs / batch.modified_acs as new feedback. (This implements the "do NOT re-triage already-decided items" rule from session-start 5a.)
  4. Evaluate each remaining feedback item (Technical Constraints / User Feedback Themes / Suggested Product Adjustments / Design Issues) as accept / reject / defer with rationale and owner
  5. ⏸ Human confirms any product-scope, acceptance-meaning, or feasibility change
  6. For accepted items, route by type:
     - PRD-impact items → defer to phase 1 (design-prd) for PRD update with 4 quality gates. Branch B only prepares the change request (list of accepted AC scope/meaning changes, new AC IDs to allocate, rationale) and hands off to phase 1. Do NOT directly edit PRD.md or regenerate prd.json in phase 0 — this preserves Core Principle 1 (quality gates cannot be bypassed) and AGENTS.md rule (PRD changes require 4 quality gates).
     - Design-impact items (Design Issues section) → annotate into a session-level staging area for PM session-end step 6b to publish via pm-to-design.md. Do NOT write directly to pm-to-design.md in phase 0 (per Handoff publication note: session-end owns handoff publication). PM retains single-write authority over pm-to-design.md.
     - Knowledge items → append to memory/knowledge-base.md (engineering constraints, TECH_STACK.md changes, architecture decisions)
  7. Write a receipt and archive the feedback unchanged; never delete the source contract or package
  8. Reference `ac_change`: session-start step 5a already wrote `state.yaml.ac_change` (machine-readable) + progress.md one-line summary when it scanned and routed this handoff. Branch B consumes `ac_change` to scope triage (added_acs / superseded_acs / affected_tasks) rather than re-deriving the diff. Do NOT re-record the diff here. If prd-orchestrator is invoked independently without a prior session-start (e.g., user directly triggers PRD update with a handoff), write `ac_change` here per `state.schema.json`.
Output: docs/product/engineering-feedback-decisions/<handoff_id>.md + receipt + optional change request for phase 1 + optional design-impact staging for session-end + optional knowledge-base.md update
Validation: every feedback item has a decision; PRD-impact items are routed to phase 1 (not directly applied); design-impact items are staged for session-end; history remains auditable
Mode: 🤖→👤
```

> **Routing note**: Branch B step 6 explicitly closes the previous "PM has no skill route for solo-to-pm" gap. PM session-start scans solo-to-pm.md and routes accepted consumption to this phase-0 Branch B. The Design Issues section's secondary routing to harness-design is now owned by Branch B step 6 (design-impact items staged for session-end publication), no longer a vacuum.
>
> **Phase 1 trigger note**: phase 1 (design-prd) can be triggered by two paths: (a) regular path — user requests PRD generation/update; (b) Branch B path — phase 0 Branch B outputs a change request for accepted PRD-impact items. In path (b), design-prd consumes the change request, applies the PRD update, and runs all 4 quality gates as usual.

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
      condition: PRD passes 4 quality gates → prd-orchestrator signals session-end → session-end step 6b publishes pm-to-design.md (publication gate: SHA-256 + envelope integrity)
    - target: harness-solo (handoff via docs/handoff/pm-to-solo.md)
      reason: After PRD is confirmed, harness-solo consumes PRD + AC-xxx for engineering implementation
      condition: PRD passes 4 quality gates → prd-orchestrator signals session-end → session-end step 6a publishes pm-to-solo.md (publication gate: SHA-256 + envelope integrity)

## Phase Gates

| Gate | Condition | Failure Handling |
|------|------|------------|
| PRD generation complete | design-prd output file generated and non-empty | Gate 1 or 2 failure blocks the flow, output missing items list |
| Change impact analysis complete | change-impact-analysis output file generated and non-empty | Supplement missing downstream impact items |
| Phase summary generated | output/phase-reports/prd-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Design feedback processing confirmation | phase-0, when a ready design-to-pm package exists | Confirm accept/reject/defer decisions that change product scope or AC meaning |
| PRD tier confirmation | AI auto-tiering confidence <0.7 | Confirm PRD tier (L/S/X) |
