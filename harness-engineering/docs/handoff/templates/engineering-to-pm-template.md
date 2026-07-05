---
schema_version: "1.0"
handoff_id: "<ENGINEERING-PM-YYYYMMDD-NNN>"
producer: "harness-engineering"
consumer: "harness-pm"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
mode: family
ac_ids: []
batch:
  id: 1
  type: full
  added_acs: []
  modified_acs: []
  superseded_acs: []
  unchanged_acs: []
artifacts: []
---

# engineering-to-pm-template.md

> Engineering feedback handoff from harness-engineering to harness-pm
>
> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-engineering
> Target framework: harness-pm
>
> **Template structure (5 core sections + 2 tail sections)**:
> 1. Phase Summary — one-sentence overview
> 2. Engineering Metrics & Issues — quantified signals + known bugs/debt
> 3. Issues & Adjustments — merged: user feedback + product suggestions + design issues + open items
> 4. Implementation Summary — merged: tech stack + implemented features + key decisions
> 5. Product-Level Engineering Feedback (product-level handoff only)
> Tail: Suggested Next Steps + Risk Notes

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 core feature development, surfaced 2 technical constraints and 3 user-feedback themes to feed back to PM>

## Engineering Metrics & Issues

| Metric / Issue | Current value | Target value | Notes |
|--------|--------|--------|------|
| First screen load (LCP) | <X.Xs> | <2.5s> | Core Web Vitals |
| Interaction latency (INP) | <Xms> | <200ms> | Core Web Vitals |
| Avg API response | <Xms> | <200ms> | |
| Test coverage | <XX%> | <80%> | |
| <known bug 1> | P2 | — | <impact scope + planned fix> |
| <tech debt 1> | P3 | — | <not addressing for now> |

## Issues & Adjustments

> Merged section combining 4 feedback categories. PM triages each item per the Contract-Driven principle (PM retains decision rights on PRD/scope changes). Engineering does NOT directly hand off to a separate design framework; design-impact items are routed by PM via `pm-to-engineering.md`.
>
> **Batch delivery rule** (when `batch.type: incremental`):
> - `ac_ids` envelope field MUST contain ALL valid AC IDs referenced by feedback items (unchanged + added + modified), never just the new feedback subset — this prevents feedback loss if a previous engineering-to-pm was never consumed.
> - The `Change` column marks each item: `[added]` (new in this batch), `[unchanged]` (carried forward, prior decision still pending), `[modified]` (item refined), `[superseded]` (item withdrawn or replaced).
> - PM's batch-aware detection uses `batch.added_acs` as primary signal for new feedback; `batch.superseded_acs` marks items already decided (PM should NOT re-triage them).

### User Feedback Themes

| Feedback theme | Source | Severity | Suggested action |
|--------|------|--------|---------|
| <theme 1> | <dev observation / early user signal> | High/Medium/Low | <action> |
| <theme 2> | <dev observation / early user signal> | High/Medium/Low | <action> |

> Captured during implementation (dev-side observations + any early user signals). Not a substitute for harness-pm's formal user research.

### Technical Constraints Discovered

| Constraint | Rationale | Impact scope | Suggested adjustment |
|--------|--------|---------|---------|
| <constraint 1, e.g., cannot use SSR with chosen stack> | <reason> | <scope> | <adjustment> |
| <constraint 2, e.g., cannot use SSR with chosen stack> | <reason> | <scope> | <adjustment> |

### Suggested Product Adjustments

| Suggestion | Reason | Priority | Affects AC | Change |
|--------|--------|--------|--------|--------|
| <adjust feature X scope> | <engineering / feedback reason> | High/Medium/Low | AC-xxx | [added] |
| <drop / defer feature Y> | <reason> | High/Medium/Low | AC-xxx | [added] |

### Design Issues (for PM to route via pm-to-engineering.md)

> Engineering-side design contract issues discovered during implementation. PM triages each item (accept/reject/defer) in prd-orchestrator phase 0 Branch B step 6; accepted design-impact items are NOT written directly to `pm-to-engineering.md` in phase 0 — they are staged in a session-level staging area and published by PM session-end step 6b via `pm-to-engineering.md` (preserving session-end's single-write authority over handoff publication).

| Design issue | Affected component/page | Severity | Suggested design adjustment | Affects AC |
|--------|---------|--------|---------|--------|
| <e.g., missing button disabled state> | <Button component> | High/Medium/Low | <add disabled state spec> | AC-xxx |
| <e.g., token inconsistency> | <color.primary> | Medium | <align with tokens.json> | AC-xxx |

> Leave empty if no design contract issues were found during implementation.

### Open Items

Issues for harness-pm to handle or confirm with harness-engineering:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Implementation Summary

### Tech Stack

| Field | Value | Notes |
|------|-----|------|
| Tech stack | <React / Vue / Svelte / ...> | |
| Code repository | <repo URL> | |
| Current version | <v1.0.0> | |

### Implemented Features

> Feature-level implementation status, consumed by PM session-start for FEATURES.md Cross-Framework Reconciliation (see the family-level DOMAIN_BOUNDARIES.md in the harness-all repo root). For each feature marked `done`, PM advances its FEATURES.md status to at least `developing`.

| Feature ID | Feature | Status | Path/Endpoint | Notes |
|--------|------|------|---------|------|
| F-xxx | <feature name> | pending/in_progress/review/done | <path or endpoint> | <notes> |

> Status values align with harness-engineering's FEATURES.md definitions: `pending` / `in_progress` / `review` / `done` / `blocked`. PM maps these to its own lifecycle per the family-level DOMAIN_BOUNDARIES.md reconciliation table (in the harness-all repo root).

### Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose state management X | Team familiarity + performance | Whole project |
| Skip SSR | Not needed in MVP stage | Performance |

## Product-Level Engineering Feedback (product-level handoff only)

> Product-level handoff only (new-product-engineering workflow). Single-feature handoff (new-feature) omits this section.
> Aggregates engineering feedback across all features, so harness-pm sees product-wide technical constraints and suggested adjustments rather than per-feature signals.

### Cross-Feature Engineering Metrics (aggregated)

| Metric | Aggregated value | Target | Notes |
|--------|--------|--------|------|
| Test coverage (product-wide) | <XX%> | <80%> | Aggregated across all features |
| <cross-feature constraint> | — | — | <impact scope> |

### Aggregated Suggested Product Adjustments

| Suggestion | Affected features | Reason | Priority | Affects AC |
|--------|---------|---------|--------|--------|
| <adjustment> | F0x, F0y | <reason> | High/Medium/Low | AC-xxx |

> Aggregated from each feature's implementation feedback. Supersedes per-feature suggestions for product-level roadmap decisions.

### Product Review Reference

- **Full review evidence**: `loops/specs/<product-task>/product-review-evidence.md`

## Suggested Next Steps

harness-pm should prioritize:

1. Triage suggested product adjustments; update the authoritative PRD only through a new approved revision and stable-ID rules
2. Triage design issues; route accepted items via `pm-to-engineering.md` if design contract changes are needed
3. Feed user-feedback themes into discovery / user-research to validate
4. Re-sync updated PRD or positioning back to harness-engineering via `pm-to-engineering.md` if scope changes

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Performance below target | High/Medium/Low | <action> |
| Suggested adjustments delay roadmap | High/Medium/Low | <action> |
| Known bugs affecting user experience | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-pm's session-start skill will auto-detect this file, report its feedback items to the user, and route accepted consumption to prd-orchestrator phase 0 Branch B (engineering feedback triage). When the envelope contains a `batch` field, PM applies batch-aware detection to identify new vs superseded feedback items.
If not auto-detected, you can manually point the Agent to this file path to read it.
