---
schema_version: "1.0"
handoff_id: "<PM-DESIGN-YYYYMMDD-NNN>"
producer: "harness-pm"
consumer: "harness-design"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
ac_ids: []
artifacts: []
---

# Handoff: harness-pm → harness-design

> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-pm
> Target framework: harness-design

## Consumer Action Map

| Contract section | Design consumer action or gate |
|---|---|
| Product basics / audience / positioning | Inputs to design-brief and recommendation framing |
| PRD + stable AC IDs | Requirements gate; preserve IDs and report overreach through design-to-pm |
| Style keywords / existing assets | Exploration constraints; unknown values stay explicitly unknown |
| Out of scope | Scope gate for DESIGN_PLAN and review |
| Decisions / open items / risks | Apply, resolve with owner, or block publication when material |

Any context without a downstream action belongs under Notes, not a new required section.

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 PRD, including 3 core features>

## Product Basics

| Field | Value | Notes |
|------|-----|------|
| Product name | <name> | |
| Product type | <web app / mobile app / desktop / landing page / ...> | Determines design paradigm |
| Target audience | <audience description> | Influences style positioning |
| Platform constraints (optional) | <web/mobile/browser/device constraints, or unknown> | Design context only; harness-solo owns framework selection |
| Platform | <iOS / Android / Web / desktop> | Determines responsive strategy |

## Positioning Statement

<One-sentence positioning, from positioning skill output. e.g., A one-stop project management tool for indie developers>

## Persona

| Persona | Path | Key traits |
|---------|------|---------|
| Primary user | artifacts/research/user-research.md ("User Personas" section) | <one-sentence trait> |
| Secondary user | artifacts/research/user-research.md ("User Personas" section) | <one-sentence trait> |

> Persona data is stored in the "User Personas" section of user-research.md. If not yet produced, fill in "To be supplemented" and note the impact scope.

## PRD Path and Acceptance Criteria

**PRD document**: `artifacts/product/PRD.md`
**PRD structured data**: `artifacts/product/prd.json` (generated projection with matching source hash)

**Acceptance criteria list (AC-xxx)**:

> The following ACs directly reuse the acceptance_criteria from the PRD, already numbered with ac_id.
> harness-design's design-brief skill should reuse these IDs as-is, do not renumber.
> ⚠️ **Warning**: The ACs listed here by PM are limited to describing [business rules, data flows, pre/post-conditions]. Do NOT include specific UI layout, color, or typography instructions. The entire visual and interaction exploration space must be left 100% to harness-design.

- [ ] AC-F01-001: <stable Given-When-Then or testable description>
- [ ] AC-F01-002: <stable testable description>
- [ ] AC-F02-001: <stable testable description; gaps are valid>

## Design-Consumable PRD Sections

> harness-design's design-brief should read these PRD sections as direct input (not just the AC-xxx list):

| PRD section | What design consumes | Where in prd.json |
|------|------|------|
| 3.2.3 Interaction logic | Page flow, feedback requirements | `pages[].flow` + `user_flows[]` |
| 3.2.4 State design | Empty/loading/error/partial/permission states | `pages[].states[]` |
| 3.2.5 Data model | Entities + fields (for form and component design) | `entities[]` |
| 5.1 Performance requirements | Page load time, responsiveness targets | `non_functional_requirements.performance[]` |

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
| Existing design system | artifacts/existing-design/DESIGN.md | <yes/no/unknown> |
| Existing design tokens | artifacts/existing-design/tokens.json | <yes/no/unknown> |
| Existing component inventory | artifacts/existing-design/components.md | <yes/no/unknown> |

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

harness-design's session-start skill will auto-detect this file and read the AC-xxx list.
If not auto-detected, you can manually point the Agent to this file path to read it.
