# WCAG 2.1 AA Static-Checkable Checklist (B2: machine-assertable subset only)

> **B2 scope (2026-07-05 audit)**: This checklist audits **only the machine-assertable subset** of WCAG 2.1 AA. AI-debate portions (hypothetical focus-trap reasoning, imagined screen-reader output, speculative runtime ARIA behavior) are **stripped** — those belong to harness-engineering's DOM-level verify (axe-core / real browser).
>
> **What stays**: contrast (hex computation), keyboard nav spec (annotation inspection), semantic labels (annotation inspection), responsive (annotation inspection), reduced-motion (annotation inspection), dark mode (annotation inspection).
>
> **What is stripped**: any prose beginning with "would" / "should" / "likely" about runtime behavior. If the design annotations do not declare the above items, that is itself a Critical finding (annotation gap), not an invitation for AI to fill in the gap with hallucinated reasoning.
>
> DOM-level verification (live focus trap behavior, runtime ARIA, real screen reader output) is deferred to harness-engineering's verify stage.

This checklist is run by `webapp-testing`. Run all checks below and record results directly into `evidence.md`'s `## WCAG Audit` section (no separate accessibility-report.md).

## 5.1 Contrast Check (machine-assertable: hex computation)

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

**B2 rule**: contrast must be computed from hex values (arithmetic), never eyeballed. If the design annotations don't declare hex values for a foreground/background pair, that is a Critical annotation gap.

## 5.2 Keyboard Navigation Check (machine-assertable: annotation inspection)

Inspect the design annotations (not runtime behavior) for declarations:
- [ ] Tab order = visual order (declared in spec)
- [ ] Focus visible (ring token, contrast ≥3:1, declared)
- [ ] Esc-to-close declared for all Modals/Drawers
- [ ] All interactive elements declared operable by keyboard
- [ ] Skip link (Skip to main content) declared

**B2 rule**: if an annotation is missing (e.g., Modal doesn't declare Esc behavior), record as Critical annotation gap. Do NOT write prose like "the modal would trap focus" — that is runtime behavior guesswork deferred to phase 3 verify-full.

## 5.3 Semantic Labels Check (machine-assertable: annotation inspection)

Inspect the design annotations for declarations:
- [ ] Semantic HTML regions declared (header/nav/main/section/footer)
- [ ] ARIA labels declared (aria-label/aria-describedby/aria-live) where needed
- [ ] alt text declared for all images (decorative images use alt="")
- [ ] Form labels declared (label associated with input)
- [ ] Error message announcement declared (aria-live="assertive")

**B2 rule**: annotation inspection only. Do NOT write prose like "screen reader would announce..." — that is runtime behavior guesswork deferred to phase 3 verify-full.

## 5.4 Responsive Check (machine-assertable: annotation inspection)

| Breakpoint | Check Items |
|------------|-------------|
| 375px (small phone) | No horizontal overflow / text readable / touch target ≥44pt (declared in annotations) |
| 768px (tablet) | Reasonable layout / no overflow (declared) |
| 1280px (desktop) | Reasonable layout / content not stretched too wide (declared) |

**B2 rule**: check that all 3 breakpoints are declared in the design annotations. Missing breakpoint = Critical annotation gap.

## 5.5 Reduced-motion Check (machine-assertable: annotation inspection)

- [ ] All animations have reduced-motion alternatives declared
- [ ] No purely decorative animations (hidden under reduced-motion, declared)
- [ ] Loading animations have static alternatives declared

**B2 rule**: annotation inspection only. Do NOT simulate animation behavior.

## 5.6 Dark Mode Check (machine-assertable: hex computation + annotation inspection)

- [ ] Dark mode body text contrast ≥4.5:1 (computed from declared dark-mode hex values)
- [ ] Dark mode secondary text contrast ≥3:1 (computed)
- [ ] Dividers visible in both themes (declared)
- [ ] Interactive states equivalent in both themes (declared)

**B2 rule**: dark mode contrast must be computed from declared dark-mode hex values, never assumed from light mode. Missing dark-mode declarations = Critical annotation gap.

## 5.7 Record Results (A2: no standalone file)

Record all results directly into `review-evidence.md`'s `## WCAG Audit` section (do NOT create a separate accessibility-report.md):

```markdown
## WCAG Audit (Axis 5 — machine-assertable subset only)

### Contrast (computed from hex values)
| Element | Foreground | Background | Contrast | Standard | Result |
|---------|-----------|------------|----------|----------|--------|
| Body text | #0F172A | #FFFFFF | 15.3:1 | 4.5:1 | ✓ |
| Button text | #FFFFFF | #3B82F6 | 4.2:1 | 4.5:1 | ✗ |

### Keyboard nav spec (annotation inspection)
- [x] Tab order = visual order (declared in spec)
- [x] Focus visible (ring token, contrast ≥3:1, declared)
- [ ] Esc-to-close declared for Modal ← annotation gap (Critical)

### Semantic labels (annotation inspection)
- [x] Semantic HTML regions declared
- [ ] Form label association declared ← annotation gap

### Responsive (annotation inspection)
- 375px: ✓
- 768px: ✓
- 1280px: ✓

### Reduced-motion (annotation inspection)
- [x] All animations have reduced-motion alternatives declared

### Dark mode (hex computation + annotation inspection)
- [x] Body text contrast declared ≥4.5:1 (computed: 14.2:1)
- [ ] Secondary text contrast not declared ← annotation gap

### Summary
- Passed: X
- Failed: Y (annotation gaps = Critical, must declare before handoff)
- AI-debate prose stripped (B2): 0 items (any runtime-behavior guesswork belongs to phase 3 verify-full)
```
