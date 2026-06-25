---
name: verify
description: Performs quick in-LOOP verification against acceptance criteria and constitution. Use in every LOOP iteration. Use before design-lint.
---
# Verify

## When to use
- Every iteration in LOOP
- Before design-lint
- Quick verification needed

## Inputs
- loops/specs/<task>/spec.md
- loops/specs/<task>/state.yaml
- constitution.md
- docs/visual/DESIGN_BRIEF.md
- docs/design-system/DESIGN.md

## Outputs
- loops/specs/<task>/evidence.md
- loops/specs/<task>/state.yaml
- loops/specs/<task>/iterations.log

## Overview

Quick in-LOOP check, run on every iteration. Checks "is the design correct", not "does the design follow the design system" (the latter is the responsibility of design-lint).

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

**Note**: Quick check only; deep review is the responsibility of the accessibility-audit skill.

### 5. Deliverability Quick Check

- Annotations complete (size / color / border radius)
- Specifications complete (component states / variants)

### 6. Write evidence.md

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

## Conclusion
- [ ] Pass → proceed to design-lint
- [x] Fail → return to visual-design
- Failure reason: AC-003 not satisfied, 375px password input overflows
```

### 7. Update state.yaml

```yaml
iteration: <N+1>
stage: verify
status: retrying  # or running (on pass)
last_error: "AC-003 not satisfied, 375px password input overflows"  # or "" (on pass)
last_error_at: "<ISO 8601>"
```

### 8. Append iterations.log

```
[<timestamp>] iter=<N> stage=design → review FAILED: AC-003 not satisfied, 375px password input overflows
```

## Failure Handling

1. Write failure info to `state.yaml` `last_error`
2. Append a line to `iterations.log`
3. Analyze the failure reason:
   - Fixable (insufficient contrast, missing states) → return to DESIGN
   - Needs replanning (misunderstood requirements, direction drift) → return to PLAN
4. Iteration count +1; check whether max iterations exceeded

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Looks right is enough" | "Looks right" is never enough; there must be evidence |
| "Skip the quick check" | The quick check is the LOOP's quality gate; skipping it causes issues to accumulate |
| "AC is mostly satisfied" | AC is checked item by item ✓/✗; there is no "mostly" |

## Red Flags

- Not checking AC item by item
- Not writing evidence.md
- Not updating state.yaml
- Not appending iterations.log
- Skipping the quick accessibility check

## Verification

- [ ] AC annotated ✓/✗ item by item (evidence: evidence.md contains AC list)
- [ ] Constitution compliance check (evidence: evidence.md contains constitution check)
- [ ] Quick accessibility check (evidence: evidence.md contains contrast/keyboard)
- [ ] evidence.md written (evidence: file exists)
- [ ] state.yaml updated (evidence: iteration/stage/status updated)
- [ ] iterations.log appended (evidence: file contains new line)

## Relationship with LOOP

- Stage: VERIFY (inside LOOP)
- Runs inside the LOOP for all loop types; after verify, design-lint runs
- Flow: DESIGN → VERIFY → LINT
- verify failure returns to DESIGN; design-lint failure also returns to DESIGN
- Loop type: applies to all loop types (visual-design / interaction-design / wireframe / component)
