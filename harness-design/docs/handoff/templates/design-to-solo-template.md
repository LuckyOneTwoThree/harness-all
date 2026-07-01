---
schema_version: "1.0"
handoff_id: "<DESIGN-SOLO-YYYYMMDD-NNN>"
producer: "harness-design"
consumer: "harness-solo"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
ac_ids: []
artifacts: []
---

# Handoff: harness-design → harness-solo

> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-design
> Target framework: harness-solo

## Consumer Action Map

| Contract section | Engineering consumer action or gate |
|---|---|
| Asset inventory + hashes | Validate and resolve package-relative files |
| Stable AC/DAC IDs | Copy unchanged into specs and verification evidence |
| Component contract (component-contract.json) | Create Solo-owned bindings and implement by stable component ID |
| Tokens / DESIGN.md | Enforce token and system compliance |
| Open items / risks | Assign an owner or block when implementation would require guessing |

Any context without a downstream action belongs under Notes, not a new required section.

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 visual design + interaction design + component mapping, including 3 core pages>

## Design System Assets

| Asset | Path | Notes |
|------|------|------|
| Design system | artifacts/design-system/DESIGN.md | Color / typography / spacing / shadow / radius / breakpoints |
| Design tokens (JSON) | artifacts/design-system/tokens.json | Machine-readable token definitions |
| Design tokens (CSS) | artifacts/design-system/tokens.css | CSS variables for direct engineering consumption |
| Component spec | artifacts/interaction/component-spec.md | Component properties/states table (explanatory) |
| Semantic component contract | artifacts/component-contract.json | **Machine-readable authority**; harness-solo's frontend-implementation reads this as the single source of truth for component semantics |
| Flow spec | artifacts/prototype/flow.md | Cross-page user flows with entry/exit/checkpoints (explanatory) |

> Component List (ID / states / variants / used_by) and Interaction Flows are **not duplicated here**. harness-solo's frontend-implementation reads them directly from `component-contract.json` (Contract Precedence #1) and `flow.md`. Refer to those files for full detail.

## Page List

> For single-page handoff (new-design workflow): list only the designed page.
> For product-level handoff (new-product-design workflow): list all pages with priority + dependencies. Full page inventory + navigation structure is in DESIGN_PLAN.md (reference only, not directly consumed by engineering).

| Page ID | Page | Priority | Depends On |
|---------|------|----------|------------|
| P01 | <Home> | P0 | — |
| P02 | <Login> | P0 | — |
| P03 | <Dashboard> | P0 | P02 |

**Navigation structure** (product-level handoff only):
- Global Header: [Logo, Nav(<pages>), UserMenu] — consistent across P01/P03/P04
- Global Footer: [Links, Copyright] — consistent across P01/P03/P04
- Authenticated vs anonymous header variants defined in artifacts/visual/header.md

## Acceptance Criteria (AC-xxx)

> The following ACs directly reuse the acceptance_criteria numbering from the harness-pm PRD, do not renumber.
> harness-solo's writing-plans skill should mark these AC-xxx as "design-related AC" in spec.md, preserving the original IDs.
> If the design phase added design-specific acceptance points, use the DAC-xxx prefix (D = Design-derived) to distinguish from engineering ACs.

- [ ] AC-F01-001: <stable testable description reused from PRD>
- [ ] AC-F01-002: <stable testable description reused from PRD>
- [ ] AC-F02-001: <stable testable description reused from PRD>
- [ ] DAC-P01-001: <stable page-scoped design criterion, e.g., "button hover state has a 200ms transition animation">
- [ ] DAC-GLOBAL-001: <stable cross-page design criterion, e.g., "first screen LCP <= 2.5s">

## Cross-Page Consistency Constraints

> Product-level handoff only (new-product-design workflow). Single-page handoff (new-design) omits this section.
> Hard constraints checked by product-design-review. Engineering should treat these as hard constraints during implementation.
> Full review evidence (pass/fail per dimension + critical findings): `loops/specs/<product-task>/product-review-evidence.md`

| Constraint | Status | Reference |
|------------|--------|-----------|
| Navigation consistency | ✓ Pass / ✗ <issue> | See evidence file |
| User flow completeness | ✓ Pass / ✗ <issue> | See evidence file |
| Component reuse (used_by match) | ✓ Pass / ✗ <issue> | See evidence file |
| Token consistency (zero hardcoded hex) | ✓ Pass / ✗ <issue> | See evidence file |
| Responsive consistency | ✓ Pass / ✗ <issue> | See evidence file |
| Interaction consistency | ✓ Pass / ✗ <issue> | See evidence file |

**Critical findings** (must fix before handoff, or acknowledged as accepted risk):
- None / <list with page reference and fix recommendation>

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose component library X | Tech stack match + design system alignment | Whole project |
| Skip responsive Y | Not in MVP scope | Scope boundary |

## Notes

<Points engineering should note during implementation, e.g.,:>
- component-contract.json is framework-neutral; harness-solo creates its local component-bindings.json
- Dark mode tokens are defined in tokens.json; switching logic must be implemented in the engineering codebase
- All touch targets >= 44px (hard accessibility constraint)

## Open Items

Issues for harness-solo to handle or confirm with harness-design:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Product Design Plan Reference

> Product-level handoff only (new-product-design workflow). For reference only; engineering does not directly consume this document, but it is the source of truth for page inventory, shared component inventory, and cross-page user flows. If any ambiguity arises about page scope or flow, consult this document first.

- **Path**: `artifacts/visual/DESIGN_PLAN.md`
- **Note**: The key content of DESIGN_PLAN.md (Page Inventory / Shared Component Inventory / Cross-Page User Flows / Cross-Page Consistency Constraints) is already carried inline in the sections above. Engineering can obtain the information it needs via those sections + component-contract.json, with no need to read DESIGN_PLAN.md directly. Consultation is optional, not mandatory.

## Suggested Next Steps

harness-solo should prioritize:

1. Run the brainstorming skill, consume this file + component-contract.json
2. Run the writing-plans skill, write AC-xxx + DAC-xxx into spec.md
3. Run the frontend-implementation skill, create component-bindings.json, then implement against both contracts

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Component contract cannot be bound to the selected tech stack | High/Medium/Low | <action> |
| Design drafts deviate from PRD acceptance criteria | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-solo's brainstorming / writing-plans / frontend-implementation / verify skills will auto-detect this file and read the stable AC/DAC list and component-contract.json.
If not auto-detected, you can manually point the Agent to this file path to read it.
