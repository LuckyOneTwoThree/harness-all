---
name: design-brief
description: Guides agents through design requirement discovery. Use when starting a new design task or when requirements are unclear. Use when no DESIGN_BRIEF.md exists.
---
# Design Brief

## When to use
- New design task starting
- Requirements unclear
- No DESIGN_BRIEF.md

## Inputs
- .harness/rules/security.md
- .harness/data/design/vibes.csv
- .harness/craft/anti-ai-slop.md
- docs/handoff/pm-to-design.md
- docs/product/PRD.md (read-only; sections 3.2.3 interaction logic, 3.2.4 state design, 3.2.5 data model, 5.1 performance)
- docs/product/prd.json (read-only; pages[], entities[], user_flows[] for structured design input)

## Outputs
- docs/visual/DESIGN_BRIEF.md

## Overview

The entry skill for design tasks; forces requirement clarification and produces DESIGN_BRIEF.md. A 15-minute brief prevents hours of rework.

## Process

### 1. Surface Assumptions (Explicitly List Assumptions)

Before non-trivial decisions, explicitly list assumptions for user confirmation:

```
ASSUMPTIONS I'M MAKING:
1. This is web, not mobile
2. Use the project's existing color palette
3. Target modern browsers
 Correct me now or I'll proceed with these.
```

### 0.5 Read PRD Directly (Upstream Requirement Source)

Before consuming the handoff's AC-xxx list, read the PRD itself for full context:
- Read `docs/product/PRD.md` sections 3.2.3 (interaction logic), 3.2.4 (state design), 3.2.5 (data model), 5.1 (performance)
- Read `docs/product/prd.json` arrays: `pages[]` (page list + flows), `entities[]` (for form/component design), `user_flows[]` (for flow diagrams)
- The unified PRD always produces all arrays — no fallback needed
- These sections provide the structural foundation that handoff AC-xxx alone cannot convey

*Exit condition: PRD sections read and understood; key pages/entities/states are noted for design exploration.*

### 1.5 Review and Strip Overreach ACs (Push-back Mechanism)

Review the AC-xxx items passed down from upstream `pm-to-design.md`. If you find PM ACs that contain specific UI form directives (e.g., "put a shopping cart icon in the top nav bar", "pop up a red confirmation box"), you must **exercise push-back authority**:
1. Refuse the overreaching wording; preserve the original AC ID and text in the cleanup log for traceability.
2. Do not silently change meaning under the same ID. Request harness-pm to supersede the AC through a new PRD revision, or add a separately scoped DAC for a design-verifiable constraint.
3. Record the proposed UX-intent wording, affected ID, and required PM decision in the `[AC Cleanup Log]`; unresolved product AC defects block a ready handoff.

### 2. Product Type Identification

Identify the product type (SaaS / E-commerce / Finance / Healthcare / Education / ...) for downstream design-recommendation.

### 3. Extract the 4 Requirement Elements

- Product Type (required)
- Target Audience (required)
- Style Keywords (optional)
- Platform constraints (optional; framework choice belongs to harness-solo)

### 4. Vibe Translation

Accept vibe-word input and translate it into token recommendations:

1. Ask the user: "What feeling should this design convey?" (e.g., "warm, retro, niche")
2. Grep `.harness/data/design/vibes.csv` to match vibe words
3. **Fallback**: If vibes.csv has no match or is empty, invoke prior knowledge reasoning, but must add a warning:
   ```
   [WARNING: Using LLM Prior Knowledge due to empty/unmatched CSV]
   ```
4. Output: color palette / font / border radius / shadow / texture recommendations

### 5. Aesthetic Direction Selection

Provide 2-3 visual directions, each describing:
- Tone
- Applicable scenarios
- Risks

### 6. Reframe (Translate Vague Requirements into Testable ACs)

Preserve valid upstream `AC-<feature>-<sequence>` IDs. Add design-derived criteria only as stable `DAC-<page>-<sequence>` or `DAC-GLOBAL-<sequence>` IDs:

| Vague Requirement | Testable Condition (AC) |
|-------------------|-------------------------|
| "make it look better" | DAC-P01-001: Card spacing uses token scale / DAC-GLOBAL-001: Contrast ≥4.5:1 |
| "make a nice button" | DAC-GLOBAL-002: Button has required interaction states |
| "this page should be modern" | Clarify intended qualities first; then allocate scoped DAC IDs to testable design outcomes |

**Acceptance ID Rules**:
- Follow `.harness/rules/acceptance-id-protocol.md`; gaps are valid and IDs are never renumbered or reused.
- PM-owned AC meaning is immutable in Design. Design additions use DAC IDs and may reference related AC IDs.
- Every criterion records source, scope, revision introduced, and a verifiable value/condition/state.

### 7. Anti AI-Slop Explicit Field

Add an Anti AI-Slop Requirements field to DESIGN_BRIEF.md, referencing craft/anti-ai-slop.md.

### 8. Constitution Check

Check for violations of constitution.md.

### 9. Output

Write to `docs/visual/DESIGN_BRIEF.md`, format below.

## DESIGN_BRIEF.md Output Format

```markdown
# Design Brief

## Product Type
<Identification result>

## Target Audience
<Target users>

## Style Keywords
<Style keywords>

## Platform Constraints
<Device/browser/platform constraints, or "None known"; no framework selection required>

## Vibe Translation
- Input vibe words: <User input>
- Recommended color palette: <Matched from vibes.csv or prior knowledge>
- Recommended font: <...>
- Recommended border radius: <...>
- Recommended shadow: <...>

## Aesthetic Direction
<2-3 visual directions, user selects>

## Reframed Success Criteria
- AC-F01-001: <Preserved product criterion, if applicable>
- DAC-P01-001: <Page-scoped design criterion>
- DAC-GLOBAL-001: <Cross-page design criterion>

## AC Cleanup Log (Push-back Log)
> Records overreaching UI directives refused and rewritten by the design side
- Original AC-xxx: <PM's rigid directive> → Rewritten as: <Pure UX goal>

## Anti AI-Slop Requirements
- Defaults to avoid: purple-blue gradient / symmetric three-column / emoji icons / generic default font
- Approved brand overrides: <rule ID + source + rationale + scope + review point, or None>
- Required: Use the project design system's fonts and color palette

## Assumptions
1. <Assumption 1>
2. <Assumption 2>
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Requirements are clear, let's just start designing" | A 15-minute brief prevents hours of rework |
| "What the user says is what they want" | Users describe solutions, not requirements; Reframe them |
| "Vibe words are too subjective to act on" | Vibe Translation turns vibe words into executable tokens |
| "Assumptions are obvious, no need to list them" | Unlisted assumptions get silently filled in by the Agent, causing direction drift |

## Red Flags

- Skipping Surface Assumptions and starting design directly
- Copying upstream ACs containing rigid UI directives verbatim (abandoning professional design judgment)
- Using vague requirements as acceptance criteria
- Entering design without identifying the product type
- Missing the Anti AI-Slop field

## Hard Gate (5 checks)

DESIGN_BRIEF.md is treated as passed only when ALL of the following are satisfied; otherwise the workflow does not proceed:

1. **Requirements clear** — Product Type and Target Audience are explicit; Style Keywords and Platform Constraints are either explicit or recorded as not provided
2. **ACs testable** — every AC-xxx contains a specific value / condition / state and is verifiable
3. **Constitution compliant** — no violation of `constitution.md` (WCAG 2.1 AA, mobile-first, design-system-first, etc.)
4. **User confirmed** — Assumptions are explicitly listed and the user has confirmed them (evidence: conversation record)
5. **Technically feasible** — token and interaction recommendations respect known platform constraints without choosing harness-solo's tech stack

## Verification

- [ ] DESIGN_BRIEF.md contains required product/audience fields and explicit status for optional style/platform fields
- [ ] Assumptions explicitly listed and confirmed by the user (evidence: conversation record)
- [ ] Aesthetic Direction has 2-3 options (evidence: file content)
- [ ] Vibe Translation has output (evidence: file content; if prior knowledge used, has WARNING label)
- [ ] Anti AI-Slop Requirements field present (evidence: file content)
- [ ] If upstream overreaching ACs exist, push-back executed and recorded in "AC Cleanup Log" (evidence: file content)
- [ ] Reframed Success Criteria are testable and numbered as AC-xxx (evidence: each contains AC number + specific value/condition)

## Relationship with LOOP

- Not run inside LOOP (runs in the pre-LOOP design-brief stage)
- The AC-xxx list produced is consumed directly by the LOOP.md PLAN stage and written into spec.md
- The Aesthetic Direction produced is consumed by the visual-design skill
- The Anti AI-Slop Requirements produced are checked by the verify skill's lint step
