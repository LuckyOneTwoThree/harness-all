---
schema_version: "1.0"
handoff_id: "<SOLO-PM-YYYYMMDD-NNN>"
producer: "harness-solo"
consumer: "harness-pm"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
mode: family
ac_ids: []
artifacts: []
---

# solo-to-pm-template.md

> Engineering feedback handoff from harness-solo to harness-pm
>
> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-solo
> Target framework: harness-pm

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

## User Feedback from Implementation

| Feedback theme | Source | Severity | Suggested action |
|--------|------|--------|---------|
| <theme 1> | <dev observation / early user signal> | High/Medium/Low | <action> |
| <theme 2> | <dev observation / early user signal> | High/Medium/Low | <action> |

> Captured during implementation (dev-side observations + any early user signals). Not a substitute for harness-pm's formal user research.

## Technical Constraints Discovered

| Constraint | Rationale | Impact scope | Suggested adjustment |
|--------|------|---------|---------|
| <constraint 1, e.g., cannot use SSR with chosen stack> | <reason> | <scope> | <adjustment> |
| <constraint 2> | <reason> | <scope> | <adjustment> |

## Suggested Product Adjustments

| Suggestion | Reason | Priority | Affects AC |
|--------|------|--------|--------|
| <adjust feature X scope> | <engineering / feedback reason> | High/Medium/Low | AC-xxx |
| <drop / defer feature Y> | <reason> | High/Medium/Low | AC-xxx |

> These are engineering-side suggestions for harness-pm to triage. PM retains decision rights on whether to update the PRD (per the Contract-Driven principle).

## Design Issues (for PM to route to harness-design)

> Engineering-side design contract issues discovered during implementation. PM should triage and route accepted items to harness-design via `pm-to-design.md`. PM retains decision rights on whether to update the PRD or design scope (per the Contract-Driven principle; solo does NOT directly hand off to harness-design).

| Design issue | Affected component/page | Severity | Suggested design adjustment | Affects DAC |
|--------|---------|--------|---------|--------|
| <e.g., missing button disabled state> | <Button component> | High/Medium/Low | <add disabled state spec> | DAC-xxx |
| <e.g., token inconsistency> | <color.primary> | Medium | <align with tokens.json> | DAC-xxx |
| <e.g., component-contract.json gap> | <Modal> | High | <add missing contract field> | DAC-xxx |

> Leave this section empty if no design contract issues were found during implementation.

## Technical Implementation

| Field | Value | Notes |
|------|-----|------|
| Tech stack | <React / Vue / Svelte / ...> | |
| Code repository | <repo URL> | |
| Current version | <v1.0.0> | |

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose state management X | Team familiarity + performance | Whole project |
| Skip SSR | Not needed in MVP stage | Performance |

## Open Items

Issues for harness-pm to handle or confirm with harness-solo:

- TBD 1: <issue description>
- TBD 2: <issue description>

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
2. Triage design issues; route accepted items to harness-design via `pm-to-design.md` if design contract changes are needed
3. Feed user-feedback themes into discovery / user-research to validate
4. Re-sync updated PRD or positioning back to harness-solo via `pm-to-solo.md` if scope changes

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Performance below target | High/Medium/Low | <action> |
| Suggested adjustments delay roadmap | High/Medium/Low | <action> |
| Known bugs affecting user experience | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-pm's session-start skill will auto-detect this file and read the engineering metrics + suggested adjustments.
If not auto-detected, you can manually point the Agent to this file path to read it.
