---
name: accessibility-audit
description: Performs deep WCAG 2.1 AA accessibility audit. Use before design-handoff. Use for accessibility compliance verification.
---
# Accessibility Audit

## When to use
- Pre-handoff accessibility review
- Before design-handoff
- Accessibility compliance verification needed

## Inputs
- .harness/craft/color.md
- .harness/data/design/ux-guidelines.csv

## Outputs
- docs/visual/accessibility-report.md

## Overview

In-depth WCAG 2.1 AA audit. Accessibility is a hard constraint, not an afterthought.

## Process

### 1. Contrast Check

| Text Type | Minimum Contrast | Check Method |
|-----------|------------------|--------------|
| Body text (<18pt) | 4.5:1 | Compute contrast from hex values |
| Large text (≥18pt or 14pt+bold) | 3:1 | Same as above |
| UI component boundaries | 3:1 | Same as above |
| Non-text decorative | ≥2:1 (recommended) | Same as above |

Contrast calculation formula:
```
L = 0.2126 * R + 0.7152 * G + 0.0722 * B (R/G/B must be gamma-corrected first)
contrast = (L1 + 0.05) / (L2 + 0.05)
```

### 2. Keyboard Navigation Check

- [ ] Tab order = visual order
- [ ] Focus visible (ring token, contrast ≥3:1)
- [ ] No keyboard traps (all focus states can be exited via Esc/Tab)
- [ ] All interactive elements operable by keyboard
- [ ] Skip link (Skip to main content) present

### 3. Screen Reader Check

- [ ] Semantic HTML (header/nav/main/section/footer)
- [ ] ARIA labels (aria-label/aria-describedby/aria-live)
- [ ] alt text (all images have alt, decorative images use alt="")
- [ ] Form labels (label associated with input)
- [ ] Error messages readable by screen readers (aria-live="assertive")

### 4. Responsive Check

| Breakpoint | Check Items |
|------------|-------------|
| 375px (small phone) | No horizontal overflow / text readable / touch target ≥44pt |
| 768px (tablet) | Reasonable layout / no overflow |
| 1280px (desktop) | Reasonable layout / content not stretched too wide |

### 5. Reduced-motion Check

- [ ] All animations have reduced-motion alternatives
- [ ] No purely decorative animations (hidden under reduced-motion)
- [ ] Loading animations have static alternatives

### 6. Dark Mode Check

- [ ] Dark mode body text contrast ≥4.5:1
- [ ] Dark mode secondary text contrast ≥3:1
- [ ] Dividers visible in both themes
- [ ] Interactive states equivalent in both themes

### 7. Output Audit Report

Write to `docs/visual/accessibility-report.md`:

```markdown
# Accessibility Audit Report

## Contrast Check
| Element | Foreground | Background | Contrast | Standard | Result |
|---------|-----------|------------|----------|----------|--------|
| Body text | #0F172A | #FFFFFF | 15.3:1 | 4.5:1 | ✓ |
| Button text | #FFFFFF | #3B82F6 | 4.2:1 | 4.5:1 | ✗ |

## Keyboard Navigation
- [x] Tab order = visual order
- [x] Focus visible
- [ ] No keyboard traps (Modal missing Esc to close)

## Screen Reader
- [x] Semantic HTML
- [ ] Form label association (Login form missing)

## Responsive
- 375px: ✓
- 768px: ✓
- 1280px: ✓

## Reduced-motion
- [x] All animations have alternatives

## Dark Mode
- [x] Body text contrast meets standard
- [ ] Secondary text contrast insufficient

## Summary
- Passed: X
- Failed: Y
- Must fix: <list Critical items>
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "We'll add accessibility later" | WCAG 2.1 AA is a hard constraint, not an afterthought |
| "Contrast is close enough" | 4.5:1 is a hard standard; off by 0.1 is still a failure |
| "Nobody uses keyboard navigation" | Accessibility is a compliance requirement, not optional |
| "Dark mode contrast is close enough" | Dark mode requires independent checks; do not assume light values work |

## Red Flags

- Contrast not actually computed (only eyeballed)
- Keyboard navigation not actually tested
- Dark mode not independently checked
- Reduced-motion not checked

## Verification

- [ ] Contrast computed item by item (evidence: report contains contrast values)
- [ ] Keyboard navigation checked item by item (evidence: report contains ✓/✗)
- [ ] Screen reader check completed (evidence: report contains semantic/ARIA/alt checks)
- [ ] Three responsive breakpoints checked (evidence: 375/768/1280 all present)
- [ ] Reduced-motion check (evidence: report contains animation alternatives)
- [ ] Dark mode independently checked (evidence: report contains dark mode contrast)

## Relationship with LOOP

- Stage: Out-of-LOOP gate (runs after LOOP exits, in parallel with design-review)
- Not run inside LOOP (avoids running full WCAG 2.1 AA checks on every iteration—too costly)
- Inside LOOP, the verify skill performs quick basic accessibility checks (contrast + keyboard navigation)
- On failure, returns to LOOP for re-DESIGN without consuming an iteration
- On pass, enters the handoff stage (design-handoff-spec)
