# Handoff: harness-pm → harness-solo

> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-pm
> Target framework: harness-solo

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 PRD, including 3 core features + acceptance criteria + tracking plan>

## Product Basics

| Field | Value | Notes |
|------|-----|------|
| Product name | <name> | |
| Product type | <web app / mobile app / desktop / landing page / ...> | Determines engineering architecture |
| Tech stack | <React / Vue / Svelte / vanilla / ...> | Determines the props Type system in component-map.json |
| Platform | <iOS / Android / Web / desktop> | Determines deployment strategy |
| Current stage | <MVP / PMF / Scaling / ...> | Determines development priorities |

## Positioning Statement

<One-sentence positioning, from positioning skill output. e.g., A one-stop project management tool for indie developers>

## PRD Path and Acceptance Criteria

**PRD document**: `docs/product/PRD.md`
**PRD structured data**: `docs/product/prd.json` (machine-consumable; contains features[], entities[], non_functional_requirements[] for engineering consumption)

**Acceptance criteria list (AC-xxx)**:

> The following ACs directly reuse the acceptance_criteria from the PRD, already numbered with ac_id.
> harness-solo's writing-plans skill should reuse these IDs as-is, do not renumber.
> If harness-design produced a design-to-solo.md, the DAC-xxx entries there are design-specific acceptance points and must also be written into spec.md.

- [ ] AC-001: <Given-When-Then or testable description>
- [ ] AC-002: <testable description>
- [ ] AC-003: <testable description>

## Engineering-Consumable PRD Sections

> harness-solo's brainstorming should read these PRD sections as direct input (not just the AC-xxx list):

| PRD section | What engineering consumes | Where in prd.json |
|------|------|------|
| 3.2.1 Feature list | MoSCoW priorities, feature dependencies | `features[].priority` + `features[].dependencies` |
| 3.2.5 Data model | Entities, fields, relationships (for ER design + migration) | `entities[]` |
| 3.2.6 Interface definition | API contract input (method/path/params/response) | `features[].api_endpoints[]` (advisory; final API design by solo) |
| 4.2 Technical constraints | Architecture constraints, known tech debt | (in prd.md Section 4.2) |
| 5.1-5.4 NFR | Performance, availability, security, observability targets | `non_functional_requirements[]` |
| 7.1 Functional acceptance | AC-xxx (Happy Path + boundary + exception) | `features[].acceptance_criteria[]` |

## Business Context Digest

> Engineering-relevant constraints extracted by PM from user-research.md / market-analysis.md.
> harness-solo **must reference** these when making architecture and tech-stack decisions, to avoid technical choices detached from business reality.
>
> Extraction rules:
> - ✅ Extract: constraints that affect architecture / tech selection / performance requirements / capacity planning / data scale
> - ❌ Do not extract: user personas / mental models / aesthetic preferences (these go to harness-design, not engineering)

| Constraint | Engineering impact | Source |
|--------|---------|------|
| <e.g., single export can be up to 5GB> | <e.g., requires async queue, cannot generate synchronously> | <user-research.md#export-scenarios> |
| <e.g., 70% of target users on mobile> | <e.g., mobile-first, first screen < 2s> | <user-research.md#device-distribution> |
| <e.g., peak concurrency estimated at 1000 QPS> | <e.g., requires cache layer + rate limiting> | <market-analysis.md#capacity-estimate> |

> If user-research.md / market-analysis.md do not exist (early-stage project), fill in "No business context digest, judge based on ACs".

## Feature Priorities

| Priority | Feature | Source | Notes |
|--------|------|------|------|
| P0 | <core feature 1> | PRD | MVP must-do |
| P1 | <important feature 2> | PRD | Important but can be deferred |
| P2 | <enhancement 3> | PRD | Optional |

## Tracking Plan (if any)

| Asset | Path | Notes |
|------|------|------|
| Tracking plan | docs/metrics/tracking-plan.md | Event tracking definitions |
| Metric system | docs/metrics/metrics-system.md | North Star + key metrics |

> If not yet produced, fill in "To be supplemented".

## Design Assets (if any, from harness-design)

> The following paths are inside the harness-design project, not harness-pm. If harness-design has not run yet, fill in "Pending harness-design output".

| Asset | Path inside harness-design | Produced? |
|------|----------------------|-----------|
| Design handoff spec | docs/handoff/design-to-solo.md | <yes/no> |
| Component map | docs/handoff/component-map.json | <yes/no> |
| Design system | docs/design-system/DESIGN.md | <yes/no> |
| Design tokens | docs/design-system/tokens.json / tokens.css | <yes/no> |

## Out of Scope

Content explicitly excluded from this engineering scope:

- Not doing <X>
- Not doing <Y>

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose tech stack X | Team familiarity + mature ecosystem | Whole project |
| Skip feature Y | Not in MVP scope | Scope boundary |

## Open Items

Issues for harness-solo to handle or confirm with harness-pm:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Suggested Next Steps

harness-solo should prioritize:

1. Run the brainstorming skill, consume the AC-xxx + feature priorities in this file
2. Run the writing-plans skill, write AC-xxx (+ DAC-xxx if any) into spec.md
3. If design-to-solo.md exists, run the frontend-implementation skill, implement components per component-map.json

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Tech stack undecided | High/Medium/Low | <action> |
| Design assets not ready | High/Medium/Low | <action> |
| Tracking plan missing | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-solo's brainstorming / writing-plans / verify skills will auto-detect this file and read the AC-xxx list, feature priorities, and business context digest.
If not auto-detected, you can manually point the Agent to this file path to read it.
