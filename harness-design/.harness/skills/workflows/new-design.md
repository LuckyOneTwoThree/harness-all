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
  → LOOP(ui-design → verify)                           [ui-design, max 5]
  → design-review (gate outside LOOP, includes accessibility audit)
  → session-end
```

**Sequencing principle (A1)**: Structure first (when wireframe runs) → then combined visual + interaction. The former three-LOOP sequence (wireframe → visual → interaction) is collapsed into two LOOPs (wireframe → ui-design) because solo's `frontend-implementation` consumes visual + interaction together via `component-contract.json`. The "structure → visual → interaction" stage order is preserved within the ui-design LOOP (visual sub-stage passes before interaction sub-stage begins inside a single iteration).

**Wireframe conditional trigger**: The wireframe LOOP is skipped by default when the project uses a component library (e.g., shadcn/ui, Ant Design, Material UI) that already guarantees structural consistency. The LOOP runs only when at least one of the following is met:
- The page has a non-standard custom layout that the component library cannot cover
- The user explicitly requests "see structure first" / "validate layout first"
- The design system lacks page-level layout patterns for this page type

Skipping wireframe does not skip structural validation: ui-design's verify step still checks information architecture and responsive structure.

**A1 deprecated former sequence** (kept for migration reference):
- Former LOOP 2 (visual-design) + LOOP 3 (interaction-design) → merged into single LOOP (ui-design)
- Former outputs `docs/visual/<page>.md` + `docs/interaction/<page>.md` → merged into single `docs/ui/<page>.md`

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
- **Hard gate rationale**: `wireframe` and `ui-design` (A1: replaces former visual-design) skills require `docs/design-system/DESIGN.md` as input (see their SKILL.md Inputs). Proceeding without it causes silent failures — the skills will produce output disconnected from the design system, breaking token/component consistency.

### 4. PLAN (inline, no standalone skill)

- Read the AC-xxx list from DESIGN_BRIEF.md
- Constitution check
- Initialize `loops/specs/<task>/state.yaml` (stage=plan, iteration=0, status=running)
- Write `loops/specs/<task>/spec.md` (with AC list)

> **Task granularity**: `<task>` here is page-level or component-level. Use `<NNN>-<page-name>` (e.g., `001-login-page`) for page design, `<NNN>-<component-name>` (e.g., `002-button`) for component design. For product-level multi-page design, use `new-product-design` workflow instead, which uses `<NNN>-<product-name>` at product level and `<NNN>-<product-name>-<page-name>` per page. See LOOP.md "Task Granularity" section for full rules.

### 5. LOOP 1: wireframe (max 5, conditional)

**Trigger**: See "Wireframe conditional trigger" in the Orchestration section above. When skipped, proceed directly to LOOP 2 (ui-design).

```
wireframe → verify
  ↑            |
  └── on failure, back to wireframe ──┘
```

- **wireframe**: Low-fidelity wireframe (black/white/gray, validate structure)
- **verify**: Structural integrity check + AC check + mechanical lint rules (unified gate)
- Failure → back to wireframe, iteration +1
- More than 5 iterations → request human intervention

### 6. LOOP 2: ui-design (max 5, A1: combined visual + interaction)

```
ui-design → verify
  ↑            |
  └── on failure, back to ui-design ──┘
```

- **ui-design** (A1: replaces former visual-design + interaction-design two-LOOP sequence):
  - Visual sub-stage: based on the approved wireframe (or directly on the design system when wireframe was skipped), produce variants per the ui-design skill's conditional trigger: multi-variant only when design system is incomplete or user requested exploration; otherwise single variant derived from design system
  - Interaction sub-stage (conditional): only when AC-xxx contains interaction-related criteria or page has interactive components; produces component states + state transitions + motion parameters
  - Both sub-stages in one iteration; single output `docs/ui/<page>.md`
- **verify**: AC item-by-item check (covers both visual + interaction ACs) + constitution + quick accessibility + mechanical lint (single unified gate)
- verify failure → back to ui-design, iteration +1
- More than 5 iterations → request human intervention

**A1 migration note**: former LOOP 2 (visual-design) + LOOP 3 (interaction-design) are merged into this single LOOP. The iteration budget is shared (max 5 for the combined LOOP, not 5+5). This is intentional — solo consumes visual + interaction together, so a failure in either should re-do both in the next iteration.

### 7. design-review (gate outside LOOP, includes accessibility audit)

- Five-Axis Review (5 axes, Axis 5 performs WCAG 2.1 AA static-checkable subset audit; DOM-level checks deferred to harness-solo verify)
- Doubt-Driven (only Critical triggers adversarial debate; Nit/FYI are recorded directly)
- Severity Labeling
- Appends `## Five-Axis Review` + `## WCAG Audit` + `## Doubt-Driven Review` sections to `loops/specs/<task>/review-evidence.md` (no separate accessibility-report.md)
- Not passed → back to LOOP (fixable) or PLAN (needs re-planning)

### 8. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Requirements document (with AC-xxx) |
| docs/prototype/wireframe.md | Wireframe (structural validation) — conditional, only if wireframe LOOP ran |
| docs/ui/<page>.md | Combined visual + interaction design (A1: replaces former docs/visual/<page>.md + docs/interaction/<page>.md) |
| docs/prototype/preview.html | B5: optional visual preview (produced only when user requests or Browser Agent will inspect; NOT a contract) |
| loops/specs/<task>/spec.md | Design spec (with AC list) |
| loops/specs/<task>/state.yaml | Loop state (carries spec_ref pointer) |
| loops/specs/<task>/review-evidence.md | Consolidated evidence (verify + lint + five-axis + WCAG + doubt-driven, sectioned) |
| loops/specs/<task>/iterations.log | Iteration history |

## Exit Criteria

- All triggered LOOPs passed (verify); wireframe LOOP is optional per the trigger rule
- design-review passed (Five-Axis + WCAG audit, recorded in review-evidence.md)
- review-evidence.md contains a review conclusion of "passed"
- state.yaml status=done

## Interaction Points

| Point | Type | Mode-dependent? |
|------|------|-----------------|
| design-brief assumptions confirmation | 👤 human decision | Always pause |
| Design System Gate resolution | 👤 human decision | Always pause |
| visual variant selection (only when multi-variant triggered) | 👤 human decision | Always pause when triggered; skipped in single-variant mode |
| design-review Critical findings | 👤 human decision | Always pause |
| Module boundary pauses | ⏸ exploration dialog | Controlled by exploration_mode |
