---
name: design-system-refactor
description: Scans design system and suggests merges/abstractions/tokenization. Use when design system has accumulated redundancy. Use for design system evolution.
---
# Design System Refactor

## When to use
- Design system has redundancy
- Component count is bloating
- Design system refactor needed

## Inputs
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/visual/
- docs/interaction/

## Outputs
- docs/design-system/REFACTOR_REPORT.md

## Overview

Scans the existing design system and recommends merges / abstractions / tokenization. The design system is a living document that needs continuous evolution. Not refactoring is riskier—technical debt accumulates and becomes unrecoverable.

## Process

### 1. Scan All Components

Read all component definitions from the following directories:
- `docs/design-system/DESIGN.md` (Section 4 Component Stylings + Section 10 Semantic Vocabulary)
- `docs/visual/*.md` (component usage in visual design)
- `docs/interaction/*.md` (component states in interaction design)

### 2. Identify Duplicate/Similar Components

#### Name Similarity

Grep component names to identify similarly named components:
- PrimaryButton / MainButton / ActionButton
- ProductCard / ItemCard / ListCard

#### Structural Similarity

Compare component props and states to identify components differing only in props:
- 3 buttons differ only in padding
- 5 cards share the same structure, differing only in tokens

#### Visual Similarity

Compare component token usage to identify components differing only in tokens:
- 12 hardcoded #3B82F6 instances should use the token color.primary

### 3. Generate Refactor Recommendations

#### Merge Recommendation

```
Finding: PrimaryButton / MainButton / ActionButton—three components
Analysis: Differ only in padding (8px / 12px / 16px)
Recommendation: Merge into Button + size prop (sm/md/lg)
Impact: Component count 3 → 1, lower maintenance cost
```

#### Abstraction Recommendation

```
Finding: ProductCard / ItemCard / ListCard share the same structure
Analysis: Differ only in tokens (variant: product/item/list)
Recommendation: Abstract into Card + variant prop
Impact: Component count 3 → 1, improved extensibility
```

#### Tokenization Recommendation

```
Finding: 12 hardcoded #3B82F6 instances
Analysis: Should uniformly use the token color.primary
Recommendation: Replace all hardcoded values with token references
Impact: Improved maintainability, theme switching enabled
```

### 4. Output Refactor Report

Write to `docs/design-system/REFACTOR_REPORT.md`:

```markdown
# Design System Refactor Report

## Scan Scope
- Total components: <N>
- Total tokens: <N>
- Scan date: <ISO 8601>

## Merge Recommendations

### R001: Merge 3 button components
- Components involved: PrimaryButton / MainButton / ActionButton
- Difference: Only padding (8px / 12px / 16px)
- Recommendation: Merge into Button + size prop
- Before: 3 separate components
- After: 1 component + size prop
- Impact scope: <list of referencing files>

## Abstraction Recommendations

### R002: Abstract the Card component
- Components involved: ProductCard / ItemCard / ListCard
- Difference: Only variant token
- Recommendation: Abstract into Card + variant prop
- Before: 3 separate components
- After: 1 component + variant prop

## Tokenization Recommendations

### R003: Replace hardcoded colors
- Locations involved: 12 instances
- Current value: #3B82F6 (hardcoded)
- Recommended value: var(--color-primary)
- Impact scope: <list of files>

## Execution Priority
- P0: R003 (tokenization, zero risk)
- P1: R001 (merge buttons, low risk)
- P2: R002 (abstract Card, medium risk)
```

### 5. Execute Refactor After User Confirmation

After user confirmation, update:
- `docs/design-system/DESIGN.md` (Section 4 Component Stylings)
- `docs/design-system/tokens.json` (add/merge tokens)
- `docs/handoff/component-map.json` (update mappings)

### 6. Post-Refactor Verification

Run design-lint to confirm the refactor introduced no errors.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Once the design system is built, it doesn't need to change" | The design system is a living document that needs continuous evolution |
| "Refactoring is too risky" | Not refactoring is riskier—technical debt accumulates and becomes unrecoverable |
| "Abstract when there are more components" | Premature abstraction is debt, but so is late abstraction; 3 similar components should be abstracted |
| "Hardcoded colors also work" | Hardcoding breaks theme switching and maintainability |

## Red Flags

- Not scanning all component directories
- Refactor recommendations without Before/After comparison
- No execution priority annotated
- Not running design-lint to verify after refactoring

## Verification

- [ ] Scan covers all component directories (evidence: scan scope record)
- [ ] Each recommendation has a Before/After comparison (evidence: report content)
- [ ] Execution priority annotated (evidence: P0/P1/P2 markers)
- [ ] design-lint passes after refactoring (evidence: lint-report.md has no errors)
- [ ] DESIGN.md + tokens.json + component-map.json updated (evidence: file diff)

## Relationship with LOOP

- Not run inside LOOP (runs in the post-LOOP design system maintenance stage)
- Reads LOOP-produced docs/visual/ + docs/interaction/ as scan input
- After refactoring, calls the design-lint skill to verify no errors were introduced (reuses the in-LOOP lint skill but does not enter the loop)
- The REFACTOR_REPORT.md produced is for the user to confirm before executing merges / abstractions / tokenization
