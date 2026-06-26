---
name: product-design-review
description: Performs product-level cross-page consistency review after all pages are designed. Use after new-product-design's per-page LOOPs complete, before design-handoff. Complements single-page design-review.
---
# Product Design Review

## When to use
- After all pages in a DESIGN_PLAN.md complete their per-page LOOPs (verify + lint + design-review + accessibility-audit)
- Before product-level design-handoff
- Cross-page consistency check needed (single-page design-review cannot catch these)

## Inputs
- docs/visual/DESIGN_PLAN.md
- docs/visual/*.md (all page visual drafts)
- docs/interaction/*.md (all page interaction drafts)
- docs/prototype/wireframe-*.md (all wireframes)
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/handoff/component-map.json
- loops/specs/<task>/evidence.md (per-page review evidence)

## Outputs
- loops/specs/<task>/product-review-evidence.md

## Overview

Product-level cross-page consistency review. Single-page design-review checks one page in isolation; product-design-review checks whether all pages work together as a coherent product. Catches: broken user flows, navigation inconsistency, component duplication, token drift, responsive inconsistency, interaction inconsistency.

## Process

### 1. Navigation Consistency Check

For each page in DESIGN_PLAN.md Section 2:
- Read docs/visual/<page>.md
- Extract Header/Footer/Main Nav structure
- Compare across all pages

**Pass criteria**:
- Header/Footer component composition identical across pages (only active state / contextual items may differ)
- Logo position consistent
- Navigation item order consistent

**Fail example**:
```
P01 Home:    Header = [Logo, Nav(Home, Pricing, About), UserMenu]
P03 Dashboard: Header = [Logo, UserMenu, Nav(Dashboard, Settings)]  ← order inconsistent
```

### 2. User Flow Completeness Check

For each flow in DESIGN_PLAN.md Section 4:
- Trace entry → exit page by page
- Verify each transition has a trigger + target page
- Verify error/exception paths are handled

**Pass criteria**:
- Every flow navigable end-to-end
- No dead-ends (clicking a CTA leads nowhere)
- Error states defined at each risk point
- Loading states defined at each async point

**Fail example**:
```
Flow 1: Landing → Login → Dashboard
- Landing CTA "Get Started" → target page undefined ← broken
- Login error state missing ← exception path broken
```

### 3. Component Reuse Check

Cross-reference DESIGN_PLAN.md Section 3 (Shared Component Inventory) with component-map.json:
- Each shared component should have `usedBy` listing all expected pages
- No page should re-implement a shared component with a different name/props

**Pass criteria**:
- component-map.json's `usedBy` field matches DESIGN_PLAN.md Section 3
- No semantic duplication (e.g., two different "PrimaryButton" entries)
- Shared components have consistent states across pages

**Fail example**:
```
DESIGN_PLAN says Button is shared by P01/P02/P03
component-map.json Button.usedBy = ["home", "login"]  ← missing dashboard
P03 dashboard.md defines its own "ActionButton" with same props as Button  ← duplication
```

### 4. Token Consistency Check

Cross-page token usage:
- Grep all docs/visual/*.md for hardcoded hex colors
- Grep all docs/interaction/*.md for hardcoded motion values
- Verify all values reference tokens.json

**Pass criteria**:
- Zero hardcoded hex across all pages (design-lint L001-L005 already checks per-page; this is the cross-page aggregate)
- Motion parameters consistent for the same component across pages (e.g., Button hover = 150ms in all pages)

**Fail example**:
```
P01 home.md:        Button hover = 150ms ease-out
P03 dashboard.md:   Button hover = 200ms ease-out  ← inconsistent
```

### 5. Responsive Consistency Check

For each breakpoint (375px / 768px / 1280px):
- Verify all pages define behavior at that breakpoint
- Verify breakpoint semantics consistent (e.g., all use mobile-first, not desktop-first)

**Pass criteria**:
- All pages have 375px / 768px / 1280px annotations
- Breakpoint strategy uniform (all mobile-first or all desktop-first)
- No page uses custom breakpoints conflicting with design system

### 6. Interaction Consistency Check

For shared components used across pages:
- Verify state definitions match (e.g., Button has default/hover/active/disabled in all pages)
- Verify motion parameters match (same duration / easing for same transition)

**Pass criteria**:
- Shared component states identical across pages
- Motion params identical for same transition type
- Keyboard navigation rules consistent (Tab order logic, Esc behavior)

### 7. Severity Labeling

Same as design-review:

| Severity | Meaning | Handling |
|----------|---------|----------|
| `Critical:` | Blocking (broken flow, nav inconsistency) | Must fix; return to per-page LOOP |
| No prefix | Must change | Must fix |
| `Nit:` | Optional | Record directly |
| `FYI` | Informational | Record directly |

### 8. Output Review Report

Write to `loops/specs/<task>/product-review-evidence.md`:

```markdown
# Product Design Review Evidence

## Navigation Consistency
- ✓ Header structure consistent across P01/P02/P03
- ✗ Footer missing on P03 Dashboard

## User Flow Completeness
### Flow 1: New User Signup
- ✓ Landing → Login transition defined
- ✗ Login → Dashboard loading state missing

## Component Reuse
- ✓ Button usedBy matches DESIGN_PLAN
- ✗ P03 re-implements ActionButton (duplication of Button)

## Token Consistency
- ✓ Zero hardcoded hex across all pages
- ✗ Button hover duration drifts (150ms in P01, 200ms in P03)

## Responsive Consistency
- ✓ All pages have 375px/768px/1280px
- ✓ Mobile-first strategy uniform

## Interaction Consistency
- ✓ Button states consistent across pages
- ✗ Modal close animation differs (P03: 200ms, P04: 150ms)

## Critical Findings
#### C001: Footer missing on P03 Dashboard
- Impact: Navigation consistency broken
- Fix: Return to P03 LOOP, add Footer

## Nit Findings
- N001: P01 uses "Get Started" CTA, P02 uses "Sign Up" — consider unifying copy

## Review Conclusion
- [ ] Pass / [ ] Fail
- Failure reason: <if fail, list Critical findings>
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Each page passed design-review, product is fine" | Single-page review can't catch cross-page flow breaks or component drift |
| "Component reuse is engineering's problem" | Design-side duplication leaks into engineering as inconsistent components |
| "Token drift of 50ms is negligible" | Drift accumulates; users perceive inconsistency even if they can't articulate it |
| "Cross-page review is too slow" | 6 checks on a product is far cheaper than fixing inconsistency after engineering implementation |

## Red Flags

- Skipping flow completeness check (most common product-level failure)
- Treating component duplication as "intentional variant" without checking design-lint L006-L008
- Not cross-referencing component-map.json's usedBy field
- Approving with open Critical findings

## Verification

- [ ] Navigation consistency checked across all pages (evidence: report contains per-page comparison)
- [ ] All flows in DESIGN_PLAN Section 4 traced end-to-end (evidence: report contains flow-by-flow trace)
- [ ] component-map.json usedBy cross-referenced with DESIGN_PLAN Section 3 (evidence: report contains mismatch list)
- [ ] Token consistency checked across all pages (evidence: Grep results in report)
- [ ] Responsive consistency checked at all 3 breakpoints (evidence: report contains breakpoint matrix)
- [ ] Interaction consistency checked for shared components (evidence: report contains motion param comparison)
- [ ] Review conclusion clear (pass/fail + reason)

## Relationship with LOOP

- Stage: Out-of-LOOP gate, runs after all per-page LOOPs + per-page design-review + per-page accessibility-audit pass
- Product-level review; does not replace per-page design-review
- On failure: Critical → return to specific page's LOOP for fix; Nit/FYI → record only
- Does not consume iterations (out-of-LOOP)
- On pass, enters product-level design-handoff
