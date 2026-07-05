---
name: design-review
description: Final review combining Five-Axis review (Axis 5 = WCAG 2.1 AA static-checkable machine-assertable subset only; AI-debate portions stripped per B2; DOM-level checks deferred to harness-solo verify) with Doubt-Driven adversarial approach (Solo-mode degraded per A3: no fresh-context sub-agent in skip/standard mode). Use after LOOP passes, before design-handoff. Appends review sections to review-evidence.md (no separate accessibility-report.md per A2).
---
# Design Review

## When to use
- Final review after LOOP passes
- Before design-handoff
- Human-level comprehensive review needed (Axis 5 = WCAG 2.1 AA static-checkable machine-assertable subset only; DOM-level checks deferred to harness-solo verify)

## Modes

**Single-page mode (new-design workflow)**: Review one page. Inputs are that page's `docs/ui/<page>.md` (A1: combined visual + interaction) + spec + review-evidence.md (verify + lint sections already written by verify). Appends `## Five-Axis Review` + `## WCAG Audit` + `## Doubt-Driven Review` sections to the same `review-evidence.md`.

**Product-level unified mode (new-product-design workflow)**: Review all pages in one fresh-context sub-agent call (A3: sub-agent only in deep mode; skip/standard mode does main-context self-review). Inputs are all pages' `docs/ui/<page>.md` (A1: combined) + all specs + all review-evidence.md files + DESIGN.md + tokens.json. Appends a single unified `## Five-Axis Review` section (per-page Axis 1-5 findings, one subsection per page) + `## WCAG Audit` section (per-page WCAG audit subsections) to the product-level `review-evidence.md`.

In unified mode:
- Axis 1-4: scan each page; design-system-level issues (token mismatch, component inconsistency) are recorded once and marked "applies to all pages" to avoid redundant findings
- Axis 5: run per-page WCAG machine-assertable checks (B2: contrast computation / keyboard spec / semantic labels / responsive / reduced-motion / dark mode), record per-page results as subsections under the unified `## WCAG Audit` section
- Doubt-Driven: Critical findings from any page trigger adversarial debate (A3: sub-agent only in deep mode; skip/standard mode = main-context self-review); the debate focuses on that specific page's issue
- Per-page deep-dive: if a page has Critical findings requiring deep investigation, run a targeted single-page design-review for that page only (exception path, not default)

## Inputs
- .harness/craft/anti-ai-slop.md
- .harness/craft/common-rules.md
- .harness/craft/color.md
- .harness/data/design/ux-guidelines.csv
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/ui/ (A1: combined visual + interaction; formerly docs/visual/ + docs/interaction/)
- docs/prototype/
- loops/specs/<task>/spec.md
- loops/specs/<task>/review-evidence.md (verify + lint sections already written by verify; design-review appends the rest)

## Outputs
- loops/specs/<task>/review-evidence.md (appends `## Five-Axis Review` + `## WCAG Audit` + `## Doubt-Driven Review` sections; no separate evidence.md or accessibility-report.md)

## Overview

Final human-level comprehensive review combining Five-Axis review (Axis 5 = WCAG 2.1 AA static-checkable **machine-assertable subset only** per B2 — AI-debate portions like hypothetical focus-trap reasoning are stripped; DOM-level checks deferred to harness-solo verify) + Doubt-Driven adversarial approach (A3: Solo-mode degraded — no fresh-context sub-agent in skip/standard mode, only deep mode spawns one). Appends all review sections to the consolidated `review-evidence.md` (A2: no separate evidence.md / accessibility-report.md / unified-review-evidence.md).

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

#### Axis 5: Accessibility (WCAG 2.1 AA static-checkable — machine-assertable subset only, per B2)

Axis 5 audits **only the machine-assertable subset** of WCAG 2.1 AA. AI-debate portions (hypothetical focus-trap reasoning, imagined screen-reader output, speculative runtime ARIA behavior) are **stripped** — those belong to harness-solo's DOM-level verify (axe-core / real browser). Axis 5 uses the checklist in `Reference/wcag-checklist.md` and records results directly into `review-evidence.md`'s `## WCAG Audit` section (no separate accessibility-report.md).

**What stays (machine-assertable, no AI hallucination)**:
- Contrast: compute from hex values (formula in wcag-checklist.md §5.1) — pure arithmetic
- Keyboard nav spec: check the design annotations declare Tab order + focus visible + Esc-to-close (spec inspection, not runtime behavior)
- Semantic labels: check the design annotations declare semantic HTML regions + ARIA labels + alt text + form label associations (annotation inspection, not runtime)
- Responsive: check 375/768/1280 breakpoints are all annotated (annotation inspection)
- Reduced-motion: check the design annotations declare reduced-motion alternatives (annotation inspection)
- Dark mode: check the design annotations declare dark mode contrast values independently (annotation inspection)

**What is stripped (AI-debate, deferred to solo verify-full)**:
- Hypothetical focus-trap behavior reasoning ("assume the modal traps focus correctly")
- Speculative screen-reader output ("screen reader would announce...")
- Runtime ARIA behavior guesswork
- Any prose that begins with "would" / "should" / "likely" about runtime behavior

If the design annotations do not declare the above machine-assertable items, that is itself a Critical finding (annotation gap), not an invitation for AI to fill in the gap with hallucinated reasoning.

### 2. Doubt-Driven Adversarial Review (A3: Solo-mode degraded)

**Severity strongly bound to exit conditions** (prevents bikeshedding):
- `Critical` level: triggers adversarial debate
- `Nit` / `FYI` level: recorded directly, no debate (hard rule, never interrupted)

#### Mode-dependent debate execution (A3)

| exploration_mode | Debate execution | Rationale |
|------------------|------------------|-----------|
| `deep` | Spawn fresh-context sub-agent for CLAIM→EXTRACT→DOUBT→RECONCILE→STOP (original behavior) | Deep mode tolerates token cost for adversarial rigor |
| `standard` | Main-context self-review: the same agent performs DOUBT in a fresh mental frame (re-read the artifact without the CLAIM), no sub-agent spawn | Solo mode: avoid sub-agent spawn cost + avoid interrupting flow |
| `skip` | Main-context self-review (same as standard); Nit/FYI only, Critical still recorded but does not auto-spawn debate | Skip mode: minimal overhead, user opts in for speed |

**Why degrade in Solo mode**: Solo developers want to reach code fast. The fresh-context sub-agent is valuable for catching true blind spots in team settings, but in Solo mode the same human brain is author + reviewer — the sub-agent mostly adds latency and interrupts flow without proportional quality gain. Critical findings are still surfaced to the user for a human decision; only the automated adversarial debate is skipped.

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

**DOUBT** (A3: execution depends on exploration_mode):
- `deep` mode: launch a sub-agent, fresh-context adversarial review:
  ```
  Sub-agent prompt: "Find what is wrong with this artifact. Assume the author is overconfident.
  Do NOT validate. Do NOT summarize. Only report problems."
  Input: Artifact + Contract (do not pass CLAIM)
  ```
- `standard` / `skip` mode: main-context self-review. Re-read the artifact in a fresh mental frame (do not re-read your own CLAIM). Apply the same prompt internally: "Find what is wrong. Assume overconfidence. Only report problems."

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

Append the following sections to `loops/specs/<task>/review-evidence.md` (verify already wrote `## Verify Evidence` + `## Lint Report`; design-review appends the rest):

```markdown
## Five-Axis Review

### Axis 1: Visual Hierarchy
- ✓ One focal point per screen
- ✗ Under-title emphasis line (violates anti-ai-slop)

### Axis 2: Spacing and Alignment
- ✓ spacing scale consistent
- ✓ Alignment baseline consistent

### Axis 3: Color and Contrast
- ✓ token consistent
- ✓ WCAG AA compliant (body text ≥4.5:1, computed from hex)
- ✓ accent used ≤2 times per screen

### Axis 4: Component Consistency
- ✓ Follows the design system
- ✓ Same semantic component ≤3 implementations
- ✓ Component states complete

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

### Responsive
- 375px: ✓
- 768px: ✓
- 1280px: ✓

### Reduced-motion
- [x] All animations have reduced-motion alternatives declared

### Dark mode
- [x] Body text contrast declared ≥4.5:1
- [ ] Secondary text contrast not declared ← annotation gap

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

**Note on Doubt-Driven execution mode**: record which mode ran in the Doubt-Driven Review section header: `(mode: deep=sub-agent | standard=main-context self-review | skip=main-context self-review, Nit/FYI only)`.

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
- deep mode: not launching a sub-agent for fresh-context (pretending to do adversarial review in the main context)
- standard/skip mode (A3): claiming sub-agent was spawned when it was not — be honest about main-context self-review
- Contrast not actually computed (only eyeballed) — B2 requires hex-value computation
- Keyboard navigation spec not inspected from annotations (B2: annotation inspection, not runtime behavior guesswork)
- Runtime behavior hallucinated ("would trap focus", "screen reader would announce") — B2: these belong to solo verify-full, strip them
- Dark mode not independently checked
- Reduced-motion not checked
- Writing a separate accessibility-report.md (A2: must be a section in review-evidence.md, not a standalone file)

## Verification

- [ ] Five-Axis checked axis by axis (evidence: review-evidence.md `## Five-Axis Review` contains all 5 axes)
- [ ] Axis 5 WCAG 2.1 AA machine-assertable subset audited (evidence: review-evidence.md `## WCAG Audit` section with contrast/keyboard-spec/semantic-labels/responsive/reduced-motion/dark-mode)
- [ ] Contrast computed from hex values (evidence: WCAG Audit contains contrast table with computed ratios, not eyeballed)
- [ ] Keyboard nav spec inspected from annotations (evidence: WCAG Audit contains annotation inspection checklist)
- [ ] No AI-debate prose about runtime behavior in WCAG Audit (evidence: section contains only annotation inspection + hex computation, no "would" / "should" / "likely" runtime guesses)
- [ ] Three responsive breakpoints checked (evidence: 375/768/1280 all present)
- [ ] Reduced-motion check (evidence: WCAG Audit contains animation alternatives inspection)
- [ ] Dark mode independently checked (evidence: WCAG Audit contains dark mode contrast inspection)
- [ ] Critical findings went through CLAIM→EXTRACT→DOUBT→RECONCILE→STOP (evidence: review-evidence.md `## Doubt-Driven Review` contains process records)
- [ ] Nit/FYI recorded directly without debate (evidence: review-evidence.md contains Nit/FYI lists)
- [ ] Doubt loop ≤3 rounds (evidence: process records)
- [ ] Doubt-Driven execution mode recorded (evidence: `## Doubt-Driven Review` header states mode: deep=sub-agent | standard=main-context | skip=main-context)
- [ ] deep mode only: fresh-context achieved via sub-agent (evidence: sub-agent invocation record)
- [ ] All review sections appended to review-evidence.md (A2: no separate evidence.md / accessibility-report.md / unified-review-evidence.md files)
- [ ] Review conclusion clear (pass/fail + reason)

## Relationship with LOOP

- Out-of-LOOP unified gate; not run inside LOOP (avoids sub-agent per iteration—too costly)
- Inside LOOP, verify does quick checks (AC + quick a11y + lint) and writes `## Verify Evidence` + `## Lint Report` sections to review-evidence.md; design-review appends `## Five-Axis Review` + `## WCAG Audit` + `## Doubt-Driven Review` sections to the same file (A2: single consolidated evidence file)
- A3: Doubt-Driven spawns a fresh-context sub-agent only in deep mode; standard/skip modes do main-context self-review to avoid Solo-mode flow interruption
- B2: Axis 5 audits only the machine-assertable WCAG subset (contrast computation + annotation inspection); runtime behavior guesswork is stripped and deferred to harness-solo verify-full
- On failure: fixable → return to LOOP for re-DESIGN; critical (Doubt-Driven adversarial finding) → set `status: blocked`, surface to user for decision; needs replanning → return to PLAN; does not consume iterations
- On pass, proceeds directly to handoff
