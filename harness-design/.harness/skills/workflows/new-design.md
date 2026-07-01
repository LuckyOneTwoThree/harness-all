---
workflow_id: B
name: new-design
description: "Design new pages or components from scratch through wireframe, visual, and interaction LOOPs"
default_mode: deep
---

# Workflow: new-design

> New design task workflow · Core workflow

## Applicable Scenarios

- New page/component design tasks
- Clear requirements, designing from scratch
- Project already has a design system

## When to use a different workflow

- Designing an entire product with multiple pages that must work together → use `new-product-design` (it plans page inventory + shared components + user flows, then drives this workflow per page)
- Iterating on an existing design → use `design-iteration`
- Redesigning an existing product → use `redesign`

## Orchestration

```
session-start
  → design-brief (hard gate)
  → Design System Gate (hard gate)
  → PLAN (inline, initialize LOOP state)
  → [Conditional] LOOP(wireframe → verify)            [wireframe, max 5]
  → LOOP(visual-design → verify)        [visual-design, max 5]
  → LOOP(interaction-design → verify)   [interaction-design, max 5]
  → design-review (gate outside LOOP, includes accessibility audit)
  → session-end
```

**Sequencing principle**: Structure first (when wireframe runs) → then visual → then interaction.
Doing visual design on top of a flawed structure is a waste of time; the same applies to interaction design on top of flawed visuals.

**Wireframe conditional trigger**: The wireframe LOOP is skipped by default when the project uses a component library (e.g., shadcn/ui, Ant Design, Material UI) that already guarantees structural consistency. The LOOP runs only when at least one of the following is met:
- The page has a non-standard custom layout that the component library cannot cover
- The user explicitly requests "see structure first" / "validate layout first"
- The design system lacks page-level layout patterns for this page type

Skipping wireframe does not skip structural validation: visual-design's verify step still checks information architecture and responsive structure.

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. design-brief (hard gate)

- Produce `docs/visual/DESIGN_BRIEF.md` (with AC-xxx list)
- Hard gate: do not proceed to the next step if not passed

### 3. Design System Gate (hard gate)

Check whether a design system exists before any wireframe/visual work:

- [ ] Read `docs/design-system/DESIGN.md`
- [ ] If exists and complete (10 sections) → proceed to PLAN
- [ ] If missing or incomplete → **refuse to proceed**, prompt user with options:
  - Option A: run `design-onboarding` workflow first (fast skeleton)
  - Option B: run `design-system-setup` workflow first (full system)
  - Option C: user provides an external design system, then continue
- **Hard gate rationale**: `wireframe` and `visual-design` skills require `docs/design-system/DESIGN.md` as input (see their SKILL.md Inputs). Proceeding without it causes silent failures — the skills will produce output disconnected from the design system, breaking token/component consistency.

### 4. PLAN (inline, no standalone skill)

- Read the AC-xxx list from DESIGN_BRIEF.md
- Constitution check
- Initialize `loops/specs/<task>/state.yaml` (stage=plan, iteration=0, status=running)
- Write `loops/specs/<task>/spec.md` (with AC list)

> **Task granularity**: `<task>` here is page-level or component-level. Use `<NNN>-<page-name>` (e.g., `001-login-page`) for page design, `<NNN>-<component-name>` (e.g., `002-button`) for component design. For product-level multi-page design, use `new-product-design` workflow instead, which uses `<NNN>-<product-name>` at product level and `<NNN>-<product-name>-<page-name>` per page. See LOOP.md "Task Granularity" section for full rules.

### 5. LOOP 1: wireframe (max 5, conditional)

**Trigger**: See "Wireframe conditional trigger" in the Orchestration section above. When skipped, proceed directly to LOOP 2 (visual-design).

```
wireframe → verify
  ↑            |
  └── on failure, back to wireframe ──┘
```

- **wireframe**: Low-fidelity wireframe (black/white/gray, validate structure)
- **verify**: Structural integrity check + AC check + mechanical lint rules (unified gate)
- Failure → back to wireframe, iteration +1
- More than 5 iterations → request human intervention

### 6. LOOP 2: visual-design (max 5)

```
visual-design → verify
  ↑                     |
  └──── on failure, back to visual-design ┘
```

- **visual-design**: Based on the approved wireframe (or directly on the design system when wireframe was skipped), produce variants per the visual-design skill's conditional trigger: multi-variant only when design system is incomplete or user requested exploration; otherwise single variant derived from design system
- **verify**: AC item-by-item check + constitution + quick accessibility + mechanical lint (unified gate)
- verify failure → back to visual-design, iteration +1
- More than 5 iterations → request human intervention

### 7. LOOP 3: interaction-design (max 5, conditional)

**Conditional trigger**: interaction-design LOOP runs only when at least one of the following is met (run if any):
- AC-xxx contains interaction-related acceptance criteria (states / motion / keyboard navigation / touch targets)
- The page involves interactive components (Button / Input / Modal / Dropdown / Toast, etc.)
- The page involves motion parameters (duration / easing / state transitions)

If the AC only involves static visuals (color / spacing / typography / layout) and the page has no interactive components, skip the interaction-design LOOP and proceed directly to step 8 (design-review).

```
interaction-design → verify
  ↑                     |
  └──── on failure, back to interaction-design ┘
```

- **interaction-design**: Based on the approved visual design, produce component states + state transitions + motion parameters
- **verify**: AC check + keyboard navigation check + mechanical lint (unified gate)
- Failure → back to interaction-design, iteration +1
- More than 5 iterations → request human intervention

### 8. design-review (gate outside LOOP, includes accessibility audit)

- Five-Axis Review (5 axes, Axis 5 performs WCAG 2.1 AA static-checkable subset audit; DOM-level checks deferred to harness-solo verify)
- Doubt-Driven (only Critical triggers adversarial debate; Nit/FYI are recorded directly)
- Severity Labeling
- Output `loops/specs/<task>/evidence.md` + `docs/visual/accessibility-report.md`
- Not passed → back to LOOP (fixable) or PLAN (needs re-planning)

### 9. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Requirements document (with AC-xxx) |
| docs/prototype/wireframe.md | Wireframe (structural validation) — conditional, only if wireframe LOOP ran |
| docs/visual/<page>.md | Visual design |
| docs/interaction/<page>.md | Interaction design |
| docs/visual/accessibility-report.md | WCAG 2.1 AA audit report (produced by design-review Axis 5) |
| loops/specs/<task>/spec.md | Design spec (with AC list) |
| loops/specs/<task>/state.yaml | Loop state |
| loops/specs/<task>/evidence.md | Validation evidence |
| loops/specs/<task>/iterations.log | Iteration history |
| loops/specs/<task>/lint-report.md | Lint report |

## Exit Criteria

- All triggered LOOPs passed (verify); wireframe LOOP is optional per the trigger rule
- design-review passed (includes accessibility audit)
- evidence.md contains a review conclusion of "passed"
- state.yaml status=done

## Interaction Points

| Point | Type | Mode-dependent? |
|------|------|-----------------|
| design-brief assumptions confirmation | 👤 human decision | Always pause |
| Design System Gate resolution | 👤 human decision | Always pause |
| visual variant selection (only when multi-variant triggered) | 👤 human decision | Always pause when triggered; skipped in single-variant mode |
| design-review Critical findings | 👤 human decision | Always pause |
| Module boundary pauses | ⏸ exploration dialog | Controlled by exploration_mode |
