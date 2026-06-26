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
- If prd.json is absent (PRD-L might not produce all arrays), fall back to PRD.md narrative
- These sections provide the structural foundation that handoff AC-xxx alone cannot convey

*Exit condition: PRD sections read and understood; key pages/entities/states are noted for design exploration.*

### 1.5 Review and Strip Overreach ACs (Push-back Mechanism)

Review the AC-xxx items passed down from upstream `pm-to-design.md`. If you find PM ACs that contain specific UI form directives (e.g., "put a shopping cart icon in the top nav bar", "pop up a red confirmation box"), you must **exercise push-back authority**:
1. Refuse to copy rigid UI layouts verbatim; preserve the professional independence of design.
2. Reframe them as pure business intent or UX goals (e.g., "users can conveniently access the shopping cart from any page", "provide a high-priority, mis-tap-resistant confirmation mechanism").
3. Record such changes for disclosure to the user in the `[AC Cleanup Log]` section of the output document.

### 2. Product Type Identification

Identify the product type (SaaS / E-commerce / Finance / Healthcare / Education / ...) for downstream design-recommendation.

### 3. Extract the 4 Requirement Elements

- Product Type (required)
- Target Audience (required)
- Style Keywords (optional)
- Tech Stack (optional)

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

Translate vague requirements into testable conditions, numbered as AC-xxx (for direct consumption by the PLAN stage of LOOP.md):

| Vague Requirement | Testable Condition (AC) |
|-------------------|-------------------------|
| "make it look better" | AC-001: Card spacing 8px consistent / AC-002: Contrast ≥4.5:1 / AC-003: No overflow at mobile 375px |
| "make a nice button" | AC-001: Button has 4 states (default/hover/active/disabled) / AC-002: Annotate size + color + radius |
| "this page should be modern" | AC-001: Page uses 12-column grid / AC-002: Primary color #xxx / AC-003: 8px spacing baseline |

**AC Numbering Rules**:
- Format: `AC-<3-digit number>` (e.g., AC-001, AC-002)
- Globally unique (no duplicates within the same DESIGN_BRIEF.md)
- Each AC must be verifiable (containing specific values / conditions / states)

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

## Tech Stack
<Tech stack>

## Vibe Translation
- Input vibe words: <User input>
- Recommended color palette: <Matched from vibes.csv or prior knowledge>
- Recommended font: <...>
- Recommended border radius: <...>
- Recommended shadow: <...>

## Aesthetic Direction
<2-3 visual directions, user selects>

## Reframed Success Criteria
- AC-001: <Testable condition 1>
- AC-002: <Testable condition 2>
- AC-003: <Testable condition 3>

## AC Cleanup Log (Push-back Log)
> Records overreaching UI directives refused and rewritten by the design side
- Original AC-xxx: <PM's rigid directive> → Rewritten as: <Pure UX goal>

## Anti AI-Slop Requirements
- Forbidden: purple-blue gradient / symmetric three-column / emoji icons / Inter font
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

## Verification

- [ ] DESIGN_BRIEF.md contains the 4 elements (evidence: file exists and fields are complete)
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
- The Anti AI-Slop Requirements produced are checked by the design-lint skill
