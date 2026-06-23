# Handoff: harness-pm → harness-design

> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-pm
> Target framework: harness-design

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 PRD, including 3 core features>

## Product Basics

| Field | Value | Notes |
|------|-----|------|
| Product name | <name> | |
| Product type | <web app / mobile app / desktop / landing page / ...> | Determines design paradigm |
| Target audience | <audience description> | Influences style positioning |
| Tech stack | <React / Vue / Svelte / vanilla / ...> | Determines the props Type system in component-map.json |
| Platform | <iOS / Android / Web / desktop> | Determines responsive strategy |

## Positioning Statement

<One-sentence positioning, from positioning skill output. e.g., A one-stop project management tool for indie developers>

## Persona

| Persona | Path | Key traits |
|---------|------|---------|
| Primary user | docs/discovery/user-research.md ("User Personas" section) | <one-sentence trait> |
| Secondary user | docs/discovery/user-research.md ("User Personas" section) | <one-sentence trait> |

> Persona data is stored in the "User Personas" section of user-research.md. If not yet produced, fill in "To be supplemented" and note the impact scope.

## PRD Path and Acceptance Criteria

**PRD document**: `docs/product/PRD.md`

**Acceptance criteria list (AC-xxx)**:

> The following ACs directly reuse the acceptance_criteria from the PRD, already numbered with ac_id.
> harness-design's design-brief skill should reuse these IDs as-is, do not renumber.
> ⚠️ **Warning**: The ACs listed here by PM are limited to describing [business rules, data flows, pre/post-conditions]. Do NOT include specific UI layout, color, or typography instructions. The entire visual and interaction exploration space must be left 100% to harness-design.

- [ ] AC-001: <Given-When-Then or testable description>
- [ ] AC-002: <testable description>
- [ ] AC-003: <testable description>

## Style Keywords

<3-5 style keywords, from positioning or explicit user request. e.g., minimalist / professional / trustworthy / tech-feel>

> If not specified, fill in "Pending exploration by harness-design's design-brief skill".

## Out of Scope

Content explicitly excluded from this design scope:

- Not doing <X>
- Not doing <Y>

## Existing Design System Assets (if any)

> The following paths are inside the harness-design project (not harness-pm). PM only marks whether they exist; harness-design confirms.

| Asset | Path inside harness-design | Already exists? |
|------|----------------------|-----------|
| Design system | docs/design-system/DESIGN.md | <yes/no/unknown> |
| Design tokens | docs/design-system/tokens.json | <yes/no/unknown> |
| Component library | docs/design-system/components/ | <yes/no/unknown> |

> For a brand-new project, fill in "None". If PM is unsure, fill in "Unknown, to be confirmed by harness-design".

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose solution X | Supported by user research | Whole project |
| Skip feature Y | Not in MVP scope | Scope boundary |

## Open Items

Issues for harness-design to handle or confirm with harness-pm:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Suggested Next Steps

harness-design should prioritize:

1. Run the design-brief skill, consume the AC-xxx and style keywords in this file
2. Run the design-system-setup workflow, build the design system skeleton
3. Run the new-design workflow, enter the LOOP to produce design drafts

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Tech stack undecided | High/Medium/Low | <action> |
| Persona missing | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-design's design-brief skill will auto-detect this file and read the AC-xxx list.
If not auto-detected, you can manually point the Agent to this file path to read it.
