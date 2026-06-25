---
name: design-review
description: Performs final human-level design review with Five-Axis and Doubt-Driven approach. Use after LOOP passes. Use before design-handoff.
---
# Design Review

## When to use
- Final review after LOOP passes
- Before design-handoff
- Human-level comprehensive review needed

## Inputs
- .harness/craft/anti-ai-slop.md
- .harness/craft/common-rules.md
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/visual/
- docs/interaction/
- docs/prototype/
- loops/specs/<task>/spec.md
- loops/specs/<task>/lint-report.md

## Outputs
- loops/specs/<task>/evidence.md

## Overview

Final human-level comprehensive review, Five-Axis + Doubt-Driven. "Looks right" is never enough—there must be evidence.

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

#### Axis 5: Accessibility
- Keyboard navigation usable?
- Focus visible?
- Screen reader friendly?

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

## Red Flags

- Skipping Five-Axis and going straight to a conclusion
- Triggering adversarial debate on Nit/FYI levels
- Doubt loop exceeding 3 rounds without stopping
- Not launching a sub-agent for fresh-context (pretending to do adversarial review in the main context)

## Verification

- [ ] Five-Axis checked axis by axis (evidence: evidence.md contains 5 axes)
- [ ] Critical findings went through CLAIM→EXTRACT→DOUBT→RECONCILE→STOP (evidence: evidence.md contains process records)
- [ ] Nit/FYI recorded directly without debate (evidence: evidence.md contains Nit/FYI lists)
- [ ] Doubt loop ≤3 rounds (evidence: process records)
- [ ] fresh-context achieved via sub-agent (evidence: sub-agent invocation record)
- [ ] Review conclusion clear (pass/fail + reason)

## Relationship with LOOP

- Stage: Out-of-LOOP gate (runs after LOOP exits, in parallel with accessibility-audit)
- Not run inside LOOP (avoids launching a sub-agent for Doubt-Driven adversarial review on every iteration—too costly)
- Inside LOOP, verify + design-lint do quick checks; design-review does the final human-level comprehensive review
- On failure: fixable → return to LOOP for re-DESIGN; needs replanning → return to PLAN
- Does not consume iterations (out-of-LOOP failures don't count)
- On pass, enters accessibility-audit or proceeds directly to handoff (depending on workflow configuration)
