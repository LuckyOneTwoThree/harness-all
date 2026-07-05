# Skills Index

> Pure index, under 80 lines. Read when selecting a Skill. For workflow orchestration, see `workflows/`.
> To add a new Skill: create a SKILL.md in the category directory, then append a line to this file.
> Positioning: harness-design is a **UI design framework**, containing only design-related skills.
> Product / engineering are handled by other members of the harness family (via docs/handoff/).

## Meta
- **session-start** — Session startup, load context and restore working state
- **session-end** — Session wrap-up, archive progress + write baseline + update board + produce handoff
- **skill-maintenance** — Skill health check
- **memory-maintenance** — Memory retention cleanup

## Design
- **design-brief** — Requirements exploration hard gate (AC transmission + Anti AI-Slop; B4: style exploration condensed)
- **design-recommendation** — Data-driven design recommendation (product type → style/color/typography)
- **design-system** — Design system creation (DESIGN.md 10 sections + token export)
- **design-system-import** — Import design system from existing code
- **ui-design** — Combined visual + interaction design (A1: replaces former visual-design + interaction-design; anti AI-slop + variants + state machine + motion)
- **wireframe** — Low-fidelity wireframe (structure validation)
- **component-design** — Atomic component design (Props/States/Variants/Composition Rules)
- **design-review** — Final review (Five-Axis + WCAG 2.1 AA machine-assertable subset B2 + Doubt-Driven A3 Solo-mode degraded)
- **product-design-review** — Product-level cross-page consistency review (after all pages designed, before handoff)
- **design-handoff-spec** — Engineering handoff with portable semantic component contract
- **verify** — Inside-LOOP unified gate (AC check + quick a11y + mechanical lint)
- **design-system-refactor** — Design system refactor (merge/abstract/tokenize)

## Workflows
> `default_mode`: deep=forced exploration / standard=pause at module boundaries / skip=direct execution (user can switch at any time)
- **design-onboarding** [skip] — First-time onboarding, quick design system skeleton (brief → recommendation → system)
- **new-product-design** [deep] — Product-level design (plan all pages + pre-gen per-page specs → shared components → per-page LOOPs → product-review → unified design-review → handoff)
- **new-design** [deep] — New design task (wireframe LOOP + ui-design LOOP + design-review; A1: former 3 LOOPs merged to 2)
- **design-iteration** [standard] — Design iteration (Chesterton's Fence + LOOP)
- **redesign** [deep] — Redesign (design-system-import + diff analysis + LOOP)
- **design-system-setup** [standard] — Full design system build (recommendation → system → component LOOP → review)
- **design-system-refactor** [standard] — Standalone design system maintenance (scan → recommend → user-confirm → execute → verify lint). No separate workflow file; invoke the skill directly. Triggered when the design system has accumulated redundancy or bloat.
- **design-handoff** [skip] — Design handoff (handoff-spec; reviews already passed upstream)
- **image-to-contract** [skip] — A4: Multimodal fast-path (image → tokens + contract; skips brief style exploration + recommendation)
