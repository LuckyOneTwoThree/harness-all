---
name: design-review
description: Final review combining Five-Axis review (including WCAG 2.1 AA static-checkable accessibility audit; DOM-level checks deferred to harness-solo verify) with Doubt-Driven adversarial approach. Use after LOOP passes. Use before design-handoff. Replaces the former separate design-review + accessibility-audit steps.
---
# Design Review

## When to use
- Final review after LOOP passes
- Before design-handoff
- Human-level comprehensive review needed (includes WCAG 2.1 AA static-checkable audit; DOM-level checks deferred to harness-solo verify)

## Modes

**Single-page mode (new-design workflow)**: Review one page. Inputs are that page's visual/interaction outputs + spec + lint-report. Outputs evidence.md + accessibility-report.md for that page.

**Product-level unified mode (new-product-design workflow)**: Review all pages in one fresh-context sub-agent call. Inputs are all pages' visual/interaction outputs + all specs + all lint-reports + DESIGN.md + tokens.json. Outputs `unified-review-evidence.md` (per-page Axis 1-5 findings, one section per page) + `docs/visual/accessibility-report.md` (per-page WCAG audit sections).

In unified mode:
- Axis 1-4: scan each page; design-system-level issues (token mismatch, component inconsistency) are recorded once and marked "applies to all pages" to avoid redundant findings
- Axis 5: run per-page WCAG checks, record per-page results in the unified accessibility report
- Doubt-Driven: Critical findings from any page trigger adversarial debate; the debate focuses on that specific page's issue
- Per-page deep-dive: if a page has Critical findings requiring deep investigation, run a targeted single-page design-review for that page only (exception path, not default)

## Inputs
- .harness/craft/anti-ai-slop.md
- .harness/craft/common-rules.md
- .harness/craft/color.md
- .harness/data/design/ux-guidelines.csv
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/visual/
- docs/interaction/
- docs/prototype/
- loops/specs/<task>/spec.md
- loops/specs/<task>/lint-report.md

## Outputs
- loops/specs/<task>/evidence.md
- docs/visual/accessibility-report.md

## Overview

Final human-level comprehensive review combining Five-Axis review (with Axis 5 now performing the WCAG 2.1 AA static-checkable subset audit, formerly the separate accessibility-audit skill; DOM-level checks deferred to harness-solo verify) + Doubt-Driven adversarial approach. Merges the former `design-review` + `accessibility-audit` two-step into a single out-of-LOOP gate to halve the post-LOOP gate cost.

## Process

### 1. Five-Axis Review

Check axis by axis:

#### Axis 1: Visual Hierarchy
- One focal point per screen?
- Reasonable distribution of visual weight?
- Hierarchy built with font weight / size / color (not under-title emphasis lines)?

#### Axis 2: Spacing and Alignment
- spacing scale consistent?
- Alignment baseline consistent?
- 4/8dp spacing rhythm?

#### Axis 3: Color and Contrast
- token consistent?
- WCAG AA compliant (body text ≥4.5:1)?
- accent used ≤2 times per screen?

#### Axis 4: Component Consistency
- Follows the design system?
- Same semantic component ≤3 implementations?
- Component states complete?

#### Axis 5: Accessibility (WCAG 2.1 AA static-checkable subset audit)

**Formerly the separate accessibility-audit skill. Performs the static-checkable subset of WCAG 2.1 AA (contrast / keyboard nav spec / semantic labels / responsive / reduced-motion / dark mode). Accessibility is a hard constraint, not an afterthought. DOM-level verification (live focus trap behavior, runtime ARIA, real screen reader output) is deferred to harness-solo's verify stage — this skill audits design-stage annotations and token-level values only.**

##### 5.1 Contrast Check

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

##### 5.2 Keyboard Navigation Check

- [ ] Tab order = visual order
- [ ] Focus visible (ring token, contrast ≥3:1)
- [ ] No keyboard traps (all focus states can be exited via Esc/Tab)
- [ ] All interactive elements operable by keyboard
- [ ] Skip link (Skip to main content) present

##### 5.3 Screen Reader Check

- [ ] Semantic HTML (header/nav/main/section/footer)
- [ ] ARIA labels (aria-label/aria-describedby/aria-live)
- [ ] alt text (all images have alt, decorative images use alt="")
- [ ] Form labels (label associated with input)
- [ ] Error messages readable by screen readers (aria-live="assertive")

##### 5.4 Responsive Check

| Breakpoint | Check Items |
|------------|-------------|
| 375px (small phone) | No horizontal overflow / text readable / touch target ≥44pt |
| 768px (tablet) | Reasonable layout / no overflow |
| 1280px (desktop) | Reasonable layout / content not stretched too wide |

##### 5.5 Reduced-motion Check

- [ ] All animations have reduced-motion alternatives
- [ ] No purely decorative animations (hidden under reduced-motion)
- [ ] Loading animations have static alternatives

##### 5.6 Dark Mode Check

- [ ] Dark mode body text contrast ≥4.5:1
- [ ] Dark mode secondary text contrast ≥3:1
- [ ] Dividers visible in both themes
- [ ] Interactive states equivalent in both themes

##### 5.7 Output Accessibility Report

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

### 2. Doubt-Driven Adversarial Review

**Severity strongly bound to exit conditions** (prevents bikeshedding):
- `Critical` level: triggers adversarial debate
- `Nit` / `FYI` level: recorded directly, no debate

#### For Critical-level CLAIM → EXTRACT → DOUBT → RECONCILE → STOP

**CLAIM** (2-3 lines stating the design decision + why it matters):
```
CLAIM: The visual hierarchy of this card is correct—title uses text-2xl + 700, body uses text-base + 400.
Importance: Establishes a visual focal point and guides the user's reading order.
```

**EXTRACT** (extract the minimal reviewable unit, strip the reasoning):
- Artifact: card design mockup
- Contract: title text-2xl/700, body text-base/400
- **Do not pass CLAIM** (prevents reviewer bias)

**DOUBT** (launch a sub-agent, fresh-context adversarial review):
```
Sub-agent prompt: "Find what is wrong with this artifact. Assume the author is overconfident.
Do NOT validate. Do NOT summarize. Only report problems."
Input: Artifact + Contract (do not pass CLAIM)
```

**RECONCILE** (classify into 4 categories):
1. Contract misread → fix the contract first
2. Valid + actionable → modify the artifact, re-loop
3. Valid trade-off → record
4. Noise → annotate; ask "could adding context avoid the false positive?"

**STOP** (bounded loop):
- Next round returns only trivial findings, or
- Already 3 rounds, or
- User says "ship it"
- 3 rounds still with Critical = artifact not ready; escalate to user

**Doubt Theater signal**: 2+ consecutive rounds where the reviewer reports substantive issues but zero are classified as actionable—you are validating, not doubting; stop escalating.

### 3. Severity Labeling

Each finding is labeled with severity:

| Severity | Meaning | Handling |
|----------|---------|----------|
| `Critical:` | Blocking (e.g., contrast fails) | Must fix; triggers adversarial debate |
| No prefix | Must change | Must fix; no debate |
| `Nit:` | Optional (style preference) | Record directly; no debate |
| `FYI` | Informational only | Record directly; no debate |

### 4. Output Review Report

Write to `loops/specs/<task>/evidence.md`:

```markdown
# Design Review Evidence

## Five-Axis Review

### Visual Hierarchy
- ✓ One focal point per screen
- ✗ Under-title emphasis line (violates anti-ai-slop)

### Spacing and Alignment
- ✓ spacing scale consistent
- ✓ Alignment baseline consistent

## Doubt-Driven Review

### Critical Findings

#### C001: <Finding title>
- CLAIM: <Design decision>
- DOUBT: <Reviewer finding>
- RECONCILE: <Classification + handling>

### Nit Findings (recorded directly, no debate)
- N001: <Finding>
- N002: <Finding>

### FYI (informational only)
- F001: <Finding>

## Review Conclusion
- [ ] Pass / [ ] Fail
- Failure reason: <...>
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Looks right is enough" | "Looks right" is never enough; there must be evidence |
| "AI-generated code is probably fine" | AI code needs more review, not less |
| "Tests passed, that's enough" | Tests are necessary but not sufficient; they don't catch architecture/security/readability |
| "Nit-level issues must also be debated" | Nits are recorded without debate; avoid endless bikeshedding |
| "If the reviewer disagrees, I'm wrong" | The reviewer lacks your context; disagreement is information, not a verdict |
| "We'll add accessibility later" | WCAG 2.1 AA is a hard constraint, not an afterthought |
| "Contrast is close enough" | 4.5:1 is a hard standard; off by 0.1 is still a failure |
| "Nobody uses keyboard navigation" | Accessibility is a compliance requirement, not optional |
| "Dark mode contrast is close enough" | Dark mode requires independent checks; do not assume light values work |

## Red Flags

- Skipping Five-Axis and going straight to a conclusion
- Triggering adversarial debate on Nit/FYI levels
- Doubt loop exceeding 3 rounds without stopping
- Not launching a sub-agent for fresh-context (pretending to do adversarial review in the main context)
- Contrast not actually computed (only eyeballed)
- Keyboard navigation not actually tested
- Dark mode not independently checked
- Reduced-motion not checked

## Verification

- [ ] Five-Axis checked axis by axis (evidence: evidence.md contains 5 axes)
- [ ] Axis 5 WCAG 2.1 AA static-checkable audit completed (evidence: accessibility-report.md with contrast/keyboard/screen-reader/responsive/reduced-motion/dark-mode)
- [ ] Contrast + keyboard + screen reader checks done item by item (evidence: report contains values + ✓/✗ + semantic/ARIA/alt)
- [ ] Three responsive breakpoints checked (evidence: 375/768/1280 all present)
- [ ] Reduced-motion check (evidence: report contains animation alternatives)
- [ ] Dark mode independently checked (evidence: report contains dark mode contrast)
- [ ] Critical findings went through CLAIM→EXTRACT→DOUBT→RECONCILE→STOP (evidence: evidence.md contains process records)
- [ ] Nit/FYI recorded directly without debate (evidence: evidence.md contains Nit/FYI lists)
- [ ] Doubt loop ≤3 rounds (evidence: process records)
- [ ] fresh-context achieved via sub-agent (evidence: sub-agent invocation record)
- [ ] Review conclusion clear (pass/fail + reason)

## Relationship with LOOP

- Out-of-LOOP unified gate (former design-review + accessibility-audit merged); not run inside LOOP (avoids sub-agent per iteration—too costly)
- Inside LOOP, verify does quick checks (AC + quick a11y + lint); design-review does final review including WCAG 2.1 AA static-checkable subset (DOM-level checks deferred to harness-solo verify)
- On failure: fixable → return to LOOP for re-DESIGN; critical (Doubt-Driven adversarial finding) → set `status: blocked`, surface to user for decision; needs replanning → return to PLAN; does not consume iterations
- On pass, proceeds directly to handoff
