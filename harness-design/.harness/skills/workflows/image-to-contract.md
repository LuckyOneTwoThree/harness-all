---
workflow_id: H
name: image-to-contract
description: "Reverse-engineer tokens.json + component-contract.json from a user-provided image (hand-drawn sketch / reference screenshot / mockup). Skips design-brief style exploration and design-recommendation; the image is the style authority. Keeps AC transmission + token derivation + verify lint."
default_mode: skip
---

# Workflow: image-to-contract

> A4 (2026-07-05 audit): Multimodal fast-path for Solo mode. When the user provides a reference image (hand-drawn sketch / reference screenshot / existing mockup), the image is the style authority — skip design-brief's style exploration (B4) and design-recommendation entirely. The image is reverse-engineered into tokens + component contract directly.
>
> **Acceleration**: design brief + recommendation steps that normally take 10-30 minutes collapse to ~2 minutes of image analysis. The LOOP still runs (image may contain dirty hex values that lint must catch), but the brief/recommendation overhead is gone.

## Applicable Scenarios

- User provides a hand-drawn sketch (paper photo / tablet export)
- User provides a reference screenshot (existing app / Dribbble / Behance)
- User provides a mockup image (Figma export / design tool output)
- User wants to clone/adapt an existing visual style
- Solo mode fast-path: user already knows what they want visually

## When to use a different workflow

- No image available, requirements are text-based → use `new-design`
- Designing an entire multi-page product → use `new-product-design` (image can seed the design system, but page inventory + flows still need text-based planning)
- Iterating on an existing design → use `design-iteration`
- First-time project setup with no design system → use `design-onboarding` or `design-system-setup`

## Orchestration

```
session-start
  → image-intake (hard gate: image present + AC-xxx from PM)
  → token-reverse-engineering (image → tokens.json)
  → design-system-gate (hard gate: DESIGN.md must exist or be derived from image)
  → PLAN (inline, initialize LOOP state)
  → LOOP(ui-design → verify)                           [ui-design, max 5]
  → design-review (gate outside LOOP, includes accessibility audit)
  → design-handoff (produce component-contract.json + design-to-solo.md)
  → session-end
```

**What is skipped vs new-design**:
- ~~design-brief's Vibe Translation / Aesthetic Direction~~ (B4 already condensed; here fully skipped — image is the style authority)
- ~~design-recommendation~~ (image already encodes the style decision; no CSV grep needed)

**What is kept (mandatory)**:
- design-brief's AC transmission (AC-xxx comes from PM handoff, not from image — image is visual style only, not product requirements)
- design-brief's Anti AI-Slop field (image may contain AI-slop patterns that lint must catch)
- design-system-gate (DESIGN.md must exist; if missing, derive a minimal design system from the image first)
- verify lint (image-derived tokens may contain hardcoded hex / non-scale spacing — lint catches this)
- design-review (Five-Axis + WCAG audit still runs — image may have contrast issues)

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. image-intake (hard gate)

**Inputs**:
- User-provided image (hand-drawn sketch / reference screenshot / mockup)
- `docs/handoff/pm-to-design.md` (AC-xxx source — mandatory, image does not replace product requirements)
- Handoff package's `artifacts/product/PRD.md` + `prd.json` (same as design-brief's PRD reading)

**Process**:
1. Read the image (multimodal vision capability)
2. Extract visual style attributes from the image:
   - Color palette (extract dominant + accent colors as hex values)
   - Typography (font family if recognizable, size hierarchy)
   - Spacing rhythm (estimate 4dp/8dp grid from element gaps)
   - Border radius patterns
   - Shadow / elevation patterns
   - Layout structure (grid columns, regions)
3. Read AC-xxx from `pm-to-design.md` (AC transmission is mandatory — image is style only, not requirements)
4. Read PRD sections 3.2.3 / 3.2.4 / 3.2.5 / 5.1 for structural context
5. Identify components visible in the image (Button / Input / Card / Modal / etc.)
6. Anti AI-Slop check on the image itself:
   - Is the image an AI-slop default (Inter font + purple gradient + uniform radius)? If yes, warn the user and ask whether to proceed or override
   - Record any AI-slop patterns detected in the image as lint-watching items

**Hard gate**: Do not proceed if:
- No image provided
- No AC-xxx from PM handoff (image is not a substitute for product requirements)
- Image is unparseable (pure noise / wrong format)

**Output**: `docs/visual/IMAGE_INTAKE.md` (condensed: image source + extracted style attributes + AC-xxx inherited from PM + Anti AI-Slop observations). This replaces the former DESIGN_BRIEF.md in this workflow — much shorter because style exploration is skipped.

### 3. token-reverse-engineering

Convert the extracted visual style attributes into W3C-format tokens:

1. Map extracted hex colors → `tokens.json` color tokens (color.primary / color.secondary / color.neutral / etc.)
2. Map extracted spacing → spacing scale tokens (spacing.4 / spacing.8 / spacing.16 / etc.)
3. Map extracted border radius → radius scale tokens (radius.sm / radius.md / radius.lg)
4. Map extracted typography → type scale tokens (font.size.xs / sm / md / lg / xl)
5. Map extracted shadows → elevation tokens (elevation.1 / 2 / 3)
6. Validate: every extracted value must land on a token; reject raw hex in the final token set

**Output**: `docs/design-system/tokens.json` (W3C format) + `docs/design-system/tokens.css`

**Note**: If `tokens.json` already exists (project has a design system), this step **merges** image-derived tokens with existing ones — image tokens fill gaps, never silently override existing tokens. Conflicts (same token name, different value) pause for user decision.

### 4. design-system-gate (hard gate)

Same as new-design's Design System Gate, but with an image-aware twist:

- [ ] Read `docs/design-system/DESIGN.md`
- [ ] If exists and complete (10 sections) → proceed to PLAN
- [ ] If missing or incomplete:
  - Option A: derive a minimal DESIGN.md from the image-derived tokens (auto-generate sections 1-6 from tokens; sections 7-10 use defaults)
  - Option B: run `design-onboarding` workflow first (fast skeleton)
  - Option C: user provides an external design system, then continue
- **Hard gate rationale**: `ui-design` skill requires DESIGN.md as input. Image-derived tokens alone are not enough — DESIGN.md encodes component styling rules that tokens alone don't capture.

### 5. PLAN (inline, no standalone skill)

- Read the AC-xxx list from `docs/visual/IMAGE_INTAKE.md`
- Constitution check
- Initialize `loops/specs/<task>/state.yaml` (stage=plan, iteration=0, status=running, spec_ref pointer)
- Write `loops/specs/<task>/spec.md` (with AC list)

### 6. LOOP: ui-design (max 5, A1: combined visual + interaction)

```
ui-design → verify
  ↑            |
  └── on failure, back to ui-design ──┘
```

- **ui-design**: Produce `docs/ui/<page>.md` based on the image-derived tokens + DESIGN.md + AC-xxx. The image is the visual reference — the output should match the image's visual style while satisfying the AC-xxx from PM.
  - Visual sub-stage: derive layout + colors + typography from image + tokens
  - Interaction sub-stage (conditional): if image shows interactive components, infer states from image + standard state tables
- **verify**: AC item-by-item check + constitution + quick accessibility + mechanical lint (image-derived tokens may contain hardcoded hex that lint catches)

### 7. design-review (gate outside LOOP, includes accessibility audit)

- Five-Axis Review (5 axes, Axis 5 = WCAG 2.1 AA machine-assertable subset per B2)
- Doubt-Driven (A3: Solo mode degrades — standard/skip do main-context self-review)
- Special focus: does the output match the image's visual intent? (Axis 1-4 check against image, not just against design system)
- Appends review sections to `loops/specs/<task>/review-evidence.md`

### 8. design-handoff

Run the `design-handoff-spec` skill:
- Produce `docs/handoff/design-to-solo.md` (AC/DAC inherited from PM + image-derived decisions)
- Produce `docs/handoff/component-contract.json` (components identified from image + tokens)
- Produce `docs/interaction/component-spec.md` + `docs/prototype/flow.md`

### 9. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/IMAGE_INTAKE.md | Condensed brief (image source + extracted style + AC-xxx + Anti AI-Slop observations) |
| docs/design-system/tokens.json | Image-derived tokens (W3C format, merged with existing if present) |
| docs/design-system/tokens.css | Image-derived tokens (CSS) |
| docs/design-system/DESIGN.md | Design system (existing or minimal-derived from image) |
| docs/ui/<page>.md | Combined visual + interaction design (A1) |
| docs/handoff/design-to-solo.md | Handoff envelope (AC/DAC + asset inventory) |
| docs/handoff/component-contract.json | Semantic component contract (framework-neutral) |
| docs/interaction/component-spec.md | Component + page-level specs |
| docs/prototype/flow.md | User flow diagram |
| loops/specs/<task>/spec.md | Design spec (with AC list) |
| loops/specs/<task>/state.yaml | Loop state (carries spec_ref pointer) |
| loops/specs/<task>/review-evidence.md | Consolidated evidence (sectioned) |
| loops/specs/<task>/iterations.log | Iteration history |

## Exit Criteria

- image-intake hard gate passed (image + AC-xxx both present)
- tokens.json validates against W3C format
- DESIGN.md exists (10 sections, either pre-existing or image-derived)
- ui-design LOOP passed (verify)
- design-review passed (Five-Axis + WCAG audit, recorded in review-evidence.md)
- component-contract.json validates and contains no engineering binding
- design-to-solo.md has exactly one valid envelope and all required sections

## Interaction Points

| Point | Type | Mode-dependent? |
|------|------|-----------------|
| image-intake: image unparseable or AI-slop detected | 👤 human decision | Always pause |
| token-reverse-engineering: conflict with existing token | 👤 human decision | Always pause when conflict |
| design-system-gate: DESIGN.md missing | 👤 human decision | Always pause |
| ui-design variant selection (only when multi-variant triggered) | 👤 human decision | Always pause when triggered |
| design-review Critical findings | 👤 human decision | Always pause |

## A4 rationale

**Why this workflow exists**: In Solo mode, users often have a clear visual target (a reference app, a hand-drawn sketch, a Dribbble shot). The former new-design workflow forced them through design-brief's style exploration (B4 already condensed this, but it still asks for style keywords) and design-recommendation (CSV grep for vibes/styles). When the user provides an image, the image IS the style decision — re-exploring it is pure overhead.

**What makes this safe**:
- AC transmission is never skipped (image is style, not product requirements)
- verify lint still runs (image may contain dirty hex / non-scale spacing)
- design-review still runs (image may have contrast issues)
- component-contract.json is still framework-neutral (image doesn't dictate React/Vue/Svelte)

**What makes this fast**:
- Skips design-brief's style exploration entirely (image is the style authority)
- Skips design-recommendation entirely (no CSV grep)
- token-reverse-engineering is a direct image→tokens mapping (no vibe-word translation)
- Net effect: ~2 minutes from image to tokens + contract, vs 10-30 minutes for the full new-design brief+recommendation path
