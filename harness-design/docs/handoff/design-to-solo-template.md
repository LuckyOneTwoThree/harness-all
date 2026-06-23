# Handoff: harness-design → harness-solo

> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-design
> Target framework: harness-solo

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 visual design + interaction design + component mapping, including 3 core pages>

## Design System Assets

| Asset | Path | Notes |
|------|------|------|
| Design system | docs/design-system/DESIGN.md | Color / typography / spacing / shadow / radius / breakpoints (10-segment standard format) |
| Design tokens (JSON) | docs/design-system/tokens.json | Machine-readable token definitions |
| Design tokens (CSS) | docs/design-system/tokens.css | CSS variables for direct engineering consumption |
| Component spec | docs/interaction/component-spec.md | Component Props/States table |
| Component map | docs/handoff/component-map.json | Explicit mapping from design components to engineering components |

## Page List

| Page | Visual draft | Interaction draft | Wireframe |
|------|--------|--------|--------|
| <Home> | docs/visual/home.md | docs/interaction/home.md | - |
| <Login> | docs/visual/login.md | docs/interaction/login.md | - |

## Component List

<Component list + states + variants, see component-spec.md and component-map.json for details>

## Acceptance Criteria (AC-xxx)

> The following ACs directly reuse the acceptance_criteria numbering from the harness-pm PRD, do not renumber.
> harness-solo's writing-plans skill should mark these AC-xxx as "design-related AC" in spec.md, preserving the original IDs.
> If the design phase added design-specific acceptance points, use the DAC-xxx prefix (D = Design-derived) to distinguish from engineering ACs.

- [ ] AC-001: <testable description reused from PRD>
- [ ] AC-002: <testable description reused from PRD>
- [ ] AC-003: <testable description reused from PRD>
- [ ] DAC-001: <testable description added in design phase, e.g., "button hover state has a 200ms transition animation">
- [ ] DAC-002: <testable description added in design phase, e.g., "first screen LCP >= 2.5s">

## Interaction Flows

<Key flow descriptions, see docs/prototype/flow.md for details>

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose component library X | Tech stack match + design system alignment | Whole project |
| Skip responsive Y | Not in MVP scope | Scope boundary |

## Notes

<Points engineering should note during implementation, e.g.,:>
- The props Type in component-map.json has been matched to TECH_STACK; engineering can consume it directly
- Dark mode tokens are defined in tokens.json; switching logic must be implemented in the engineering codebase
- All touch targets >= 44px (hard accessibility constraint)

## Open Items

Issues for harness-solo to handle or confirm with harness-design:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Suggested Next Steps

harness-solo should prioritize:

1. Run the brainstorming skill, consume this file + component-map.json
2. Run the writing-plans skill, write AC-xxx + DAC-xxx into spec.md
3. Run the frontend-implementation skill, implement components per component-map.json

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Tech stack does not match component-map.json | High/Medium/Low | <action> |
| Design drafts deviate from PRD acceptance criteria | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-solo's brainstorming / writing-plans / frontend-implementation / verify skills will auto-detect this file and read the AC-xxx + DAC-xxx list and component-map.json.
If not auto-detected, you can manually point the Agent to this file path to read it.
