---
name: verify
description: In-LOOP verification combining acceptance criteria checks with mechanical design-system lint rules. Use in every LOOP iteration. Replaces the former separate verify + design-lint steps.
---
# Verify

## When to use
- Every iteration in LOOP
- Single in-LOOP gate (combines AC check + mechanical lint)

## Inputs
- loops/specs/<task>/spec.md
- loops/specs/<task>/state.yaml
- constitution.md
- docs/visual/DESIGN_BRIEF.md
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- .harness/craft/anti-ai-slop.md
- Design mockups to be checked (`docs/visual/<page>.md`)

## Outputs
- loops/specs/<task>/evidence.md
- loops/specs/<task>/lint-report.md
- loops/specs/<task>/state.yaml
- loops/specs/<task>/iterations.log

## Overview

Unified in-LOOP gate combining correctness checks (AC, constitution, quick accessibility) with mechanical design-system lint rules (token consistency, anti-AI-slop). Merges the former `verify` + `design-lint` two-step into a single step to halve the per-iteration gate cost.

## Process

### 1. Design Completeness Check

- Does the design mockup cover all acceptance criteria?
- Are there missing pages / components / states?

### 2. Acceptance Criteria Item-by-Item Check

Read AC-xxx from `loops/specs/<task>/spec.md`, annotate ✓/✗ for each:

```
AC-001: Login form contains email + password + submit button → ✓
AC-002: Submit button has 4 states → ✓
AC-003: No overflow at mobile 375px → ✗ (password input overflows)
```

### 3. Constitution Compliance Check

Check for violations of `constitution.md` principles:
- Design system first; do not reinvent components
- Accessibility WCAG 2.1 AA is a hard constraint
- Mobile first; responsive is mandatory

### 4. Quick Accessibility Check

- Contrast (body text ≥4.5:1)
- Keyboard navigation (Tab order + focus visible)

**Note**: Quick check only; deep WCAG review is the responsibility of the design-review skill's Axis 5 (accessibility-audit merged).

### 5. Deliverability Quick Check

- Annotations complete (size / color / border radius)
- Specifications complete (component states / variants)

### 6. Mechanical Lint Rules

**Single-page mode (new-design workflow)**: Write and run a one-off Node.js script that regex-scans the design mockups. **Key**: Real mechanical rules must be executed by real code, not LLM hallucination.

**Product-level mode (new-product-design workflow)**: Call the pre-created unified lint script `loops/specs/<product-task>/lint-all.mjs` (created at Product-level PLAN step 7), passing the current page's file path. Do NOT write a new script — the unified script implements L001-L015 and is parameterized per page.

```javascript
// Single-page mode: lint-design.mjs (one-off, discard after use)
// Product-level mode: lint-all.mjs (pre-created, reused per page)
//
// Usage in product-level mode:
//   node loops/specs/<product-task>/lint-all.mjs docs/visual/<page>.md loops/specs/<product-task>-<page-name>/lint-report.md
//
// The script implements L001-L015 per the lint rule list below.

import { readFileSync, writeFileSync } from 'fs';

const design = readFileSync(process.argv[2], 'utf8'); // page file path
const outputPath = process.argv[3]; // lint-report.md path
const tokens = JSON.parse(readFileSync('docs/design-system/tokens.json', 'utf8'));
const approvedOverrides = new Set([]); // Populate only from explicit, scoped rule IDs in constitution.md or DESIGN.md

const errors = [];

// L001: All colors must come from tokens (no hardcoded hex)
const hexMatches = design.matchAll(/#[0-9a-fA-F]{6}/g);
const tokenColors = Object.values(tokens.color || {}).map(t => t.$value.toLowerCase());
for (const match of hexMatches) {
  if (!tokenColors.includes(match[0].toLowerCase())) {
    errors.push({ rule: 'L001', severity: 'error', value: match[0], fix: 'use token from tokens.json' });
  }
}

// L011-L015: Anti AI-slop defaults (see full rule list below)
// ... (rule implementations per lint rule list)

writeFileSync(outputPath, formatReport(errors));
```

#### Lint Rule List

**Token Consistency**
- L001: All colors must come from tokens (no hardcoded hex)
- L002: All spacing must be on the spacing scale
- L003: All border radii must come from the radius scale
- L004: All font sizes must be on the type scale
- L005: All shadows must come from the elevation scale

**Component Consistency**
- L006: No more than 3 implementations for the same semantic component
- L007: Component variants differing by ≤2 props should be merged
- L008: Components must annotate all states

**Layout Consistency**
- L009: Consistent alignment baseline
- L010: Consistent grid column count (12-column grid)

**Anti AI-slop Defaults**
- L011: Forbid generic default fonts (Inter/Roboto/Arial) unless an approved brand override names L011
- L012: Forbid #6366f1 purple
- L013: Forbid purple-blue gradient
- L014: Forbid uniform border-radius — no more than 2 elements share the same `rounded-2xl`/`rounded-3xl`/`rounded-full` value unless they belong to the same component family
- L015: Forbid Lorem ipsum placeholder copy (error unless the artifact is explicitly a content-wireframe fixture)

A constitution/brand-system override may downgrade a named rule (L011-L015) when rationale, source, scope, and review point are recorded. Overrides never bypass WCAG, token consistency, interaction-state, or evidence gates.

#### Lint Result Handling
- `error` level: Must fix; return to DESIGN stage
- `warning` level: Recommended fix; annotate the decision ("fix" or "ignore with reason")
- `info` level: Informational only; no action needed

### 7. Write evidence.md

```markdown
# Verify Evidence (Iteration <N>)

## Acceptance Criteria
- AC-001: ✓
- AC-002: ✓
- AC-003: ✗ (password input overflows)

## Constitution Compliance
- ✓ Design system first
- ✓ WCAG 2.1 AA
- ✗ Mobile first (375px overflow)

## Quick Accessibility Check
- Contrast: ✓
- Keyboard navigation: ✓

## Deliverability Quick Check
- Annotations: ✓
- Specifications: ✓

## Lint Summary
- Errors: <count>
- Warnings: <count>
- Info: <count>
- Lint report: loops/specs/<task>/lint-report.md
- Critical lint errors (must fix before proceeding): <list>

## Conclusion
- [ ] Pass → proceed to next LOOP or out-of-LOOP gate
- [x] Fail → return to DESIGN stage
- Failure reason: AC-003 not satisfied, 375px password input overflows / L001: 2 hardcoded hex colors
```

### 8. Update state.yaml

```yaml
iteration: <N+1>
stage: verify
status: retrying  # or running (on pass)
last_error: "AC-003 not satisfied; L001: 2 hardcoded hex"  # or "" (on pass)
last_error_at: "<ISO 8601>"
```

### 9. Append iterations.log

```
[<timestamp>] iter=<N> stage=design → verify FAILED: AC-003 not satisfied; L001: 2 hardcoded hex colors
```

## Failure Handling

1. Write failure info to `state.yaml` `last_error`
2. Append a line to `iterations.log`
3. Analyze the failure reason:
   - AC failure or fixable lint error → return to DESIGN
   - Needs replanning (misunderstood requirements, direction drift) → return to PLAN
4. Iteration count +1; check whether max iterations exceeded

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Looks right is enough" | "Looks right" is never enough; there must be evidence |
| "Skip the quick check" | The quick check is the LOOP's quality gate; skipping it causes issues to accumulate |
| "AC is mostly satisfied" | AC is checked item by item ✓/✗; there is no "mostly" |
| "Lint rules are too strict and limit creativity" | Lint checks consistency, not creativity; creativity lives at the token definition layer |
| "LLM hallucinated checks are enough" | LLMs drift and hallucinate; scripts must be used |
| "Writing a script is too much trouble" | One-off scripts are discarded after use and are more reliable than manual checks |

## Red Flags

- Not checking AC item by item
- Not writing evidence.md
- Not updating state.yaml
- Not appending iterations.log
- Skipping the quick accessibility check
- No lint script written; only LLM hallucinated checks
- Claiming pass without running the lint script
- Continuing with unresolved error-level lint violations
- Warning-level lint violations without annotated decisions

## Verification

- [ ] AC annotated ✓/✗ item by item (evidence: evidence.md contains AC list)
- [ ] Constitution compliance check (evidence: evidence.md contains constitution check)
- [ ] Quick accessibility check (evidence: evidence.md contains contrast/keyboard)
- [ ] Lint script available (evidence: single-page mode — lint-design.mjs written; product-level mode — lint-all.mjs exists at `loops/specs/<product-task>/`)
- [ ] Lint script run (evidence: command execution record)
- [ ] lint-report.md generated (evidence: file exists)
- [ ] All error-level lint violations fixed (evidence: re-running the script yields no errors)
- [ ] Warning-level lint violations have decisions (evidence: each warning annotated "fix" or "ignore with reason")
- [ ] evidence.md written (evidence: file exists)
- [ ] state.yaml updated (evidence: iteration/stage/status updated)
- [ ] iterations.log appended (evidence: file contains new line)

## Relationship with LOOP

- Stage: VERIFY (inside LOOP)
- Runs inside the LOOP for all loop types; single unified gate (former verify + design-lint merged)
- Flow: DESIGN → VERIFY (includes lint)
- verify failure returns to DESIGN
- Loop type: applies to all loop types (visual-design / interaction-design / wireframe / component)
