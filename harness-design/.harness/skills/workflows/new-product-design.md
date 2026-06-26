---
workflow_id: G
name: new-product-design
description: "Design an entire product end-to-end: plan all pages, shared components, and user flows, then drive per-page new-design LOOPs, and finish with product-level consistency review"
default_mode: deep
---

# Workflow: new-product-design

> Product-level design workflow · Designs a complete product across all pages in one orchestrated run
> Difference from new-design: new-design handles a single page; new-product-design plans the whole product then drives per-page design with cross-page consistency. Use new-design for one-off page additions; use new-product-design for "design the whole product" / "design all pages".

## Applicable Scenarios

- Designing a complete product from scratch (multiple pages that must work together)
- User says "design the whole product" / "design all pages" / "design the full flow"
- Pages share components and user flows that must be consistent across the product
- First full design pass for a new product

## When to use new-design instead

- Adding a single page to an existing product → use new-design
- Iterating on an existing design → use design-iteration
- Redesigning an existing product → use redesign (it handles multi-page internally)
- Single component design → use design-system-setup

## Orchestration

```
session-start
  → design-brief (product-level, confirm page inventory)
  → Design System Gate (hard gate)
  → Product-level PLAN (produce DESIGN_PLAN.md)
  → [Phase 1] Shared Components LOOP (conditional, skip if all exist)
      └─ PC1: after all shared components complete
  → [Phase 2] Per-page new-design LOOPs (by priority + preference)
      └─ PC2: at P0 milestone
  → product-design-review (product-level consistency gate)
      └─ PC3: full cross-page check runs as part of review
  → Product-level Handoff (design-to-solo.md + component-map.json, product-level)
  → session-end
```

**Key principles**:
- Plan before designing: DESIGN_PLAN.md is the blueprint, drives all downstream per-page work
- Shared components first: avoids re-creating variants per page
- Per-page LOOPs run independently (each page = one new-design run, with its own spec/state/evidence)
- Cross-page consistency is a separate gate after all pages pass their own gates

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. design-brief (hard gate, product-level)

- Run the `design-brief` skill
- Produce `docs/visual/DESIGN_BRIEF.md` (product-level, with AC-xxx)
- **Difference from single-page brief**: AC-xxx here covers product-level acceptance (e.g., "all P0 pages have consistent header", "signup flow works end-to-end"), not just one page
- Hard gate: do not proceed if DESIGN_BRIEF.md incomplete

### 3. Design System Gate (hard gate)

Check whether a design system exists:

- [ ] Read `docs/design-system/DESIGN.md`
- [ ] If exists and complete (10 sections) → proceed to Product-level PLAN
- [ ] If missing or incomplete → pause, ask user:
  - Option A: run `design-onboarding` workflow first (fast skeleton)
  - Option B: run `design-system-setup` workflow first (full system with components)
  - Option C: user confirms they will provide design system externally, then proceed
- **Hard gate**: do not proceed to per-page design without a design system. visual-design and wireframe skills require DESIGN.md as input; proceeding without it causes silent failures.

### 4. Product-level PLAN

Produce `docs/visual/DESIGN_PLAN.md` based on the `DESIGN_PLAN-template.md`:

1. Read `docs/visual/DESIGN_BRIEF.md` for product scope, target audience, AC-xxx
2. Read upstream `docs/handoff/pm-to-design.md` (if present) for PRD context, persona, page hints
3. Read `docs/product/PRD.md` sections (if present): pages[], user_flows[], entities[]
4. Fill DESIGN_PLAN.md sections:
   - **Section 1 Product Overview**: from DESIGN_BRIEF
   - **Section 2 Page Inventory**: enumerate all pages to design this round, assign Page IDs (P01/P02/...), set priority (P0/P1/P2), set dependencies
   - **Section 3 Shared Component Inventory**: extract from DESIGN.md Section 10 Semantic Vocabulary, map which pages use which components
   - **Section 4 Page Dependency Graph**: page-level soft dependencies (preferred design order); unlike solo's hard dependencies, no topological sort required
   - **Section 5 Product User Flows**: cross-page flows with entry/exit/checkpoints
   - **Section 6 Design Execution Order**: shared components first, then pages by priority + dependency
   - **Section 7 Integration Checkpoints**: periodic cross-page consistency checks (PC1-PC3) during Phase 1/2
   - **Section 8 Cross-Page Consistency Constraints**: hard rules checked by product-design-review
   - **Section 9 Design System Dependency**: confirm gate passed
   - **Section 10 Key Decisions**: record major design decisions and their rationale
   - **Section 11 Open Items**: list unresolved questions and follow-ups
5. Initialize product-level `loops/specs/<product-task>/state.yaml` (stage=plan, iteration=0, status=running, substage=product-plan)
6. User confirms DESIGN_PLAN.md before per-page work begins (👤 human decision point)

> **Task naming**: Product-level task uses `<NNN>-<product-name>` (e.g., `001-shopping-app`). Per-page tasks use `<NNN>-<product-name>-<page-name>` (e.g., `001-shopping-app-home`). See LOOP.md task granularity section.

### 5. Phase 1: Shared Components LOOP (conditional)

**Trigger**: DESIGN_PLAN.md Section 3 lists shared components, AND `docs/design-system/components/<Component>.md` does not exist for them.

For each shared component (in priority order):
- Run `component-design` → `verify` → `design-lint` LOOP (loop type: `component`, max 5)
- Output: `docs/design-system/components/<Component>.md`
- Single component exceeding 5 iterations → pause the product workflow and report to the user; the user may choose to fix or skip that component

If all shared components already exist in the design system (e.g., design-system-setup was run before), skip this phase.

**PC1: Post-Phase-1 Integration Checkpoint** (operationalizes the PC1 node in the Orchestration diagram)

- **Trigger**: All shared components listed in DESIGN_PLAN.md Section 3 are complete — either newly designed in this phase, or pre-existing (when Phase 1 was skipped, PC1 still runs to verify consistency with planned usage before per-page work begins).
- **Check items**:
  - Component consistency: each shared component's states/variants in `docs/design-system/components/<Component>.md` match the usage declared in DESIGN_PLAN.md Section 3 (no missing states, no undeclared variants)
  - Token consistency: component styles reference tokens defined in `docs/design-system/tokens.json` (no hardcoded hex/durations; the same component uses the same token names)
- **On pass**: record PC1 result in `loops/specs/<product-task>/pc1-evidence.md`, proceed to Phase 2
- **On failure**: pause the workflow and report to the user with the specific component/token mismatch. Do not start Phase 2 per-page LOOPs until PC1 passes — per-page work would otherwise inherit inconsistent shared components and propagate the inconsistency across all pages.

### 6. Phase 2: Per-page LOOPs (drive new-design for each page)

For each page in DESIGN_PLAN.md Section 6 execution order:

1. Read DESIGN_PLAN.md entry for this page (Page ID, priority, dependencies, expected AC)
2. Drive the `new-design` workflow for this single page:
   - Skip design-brief (already done at product level); inherit product-level DESIGN_BRIEF.md + add page-specific AC if needed
   - PLAN (inline, initialize page-level `loops/specs/<product-task>-<page-name>/state.yaml`)
   - LOOP(wireframe → verify → design-lint) [wireframe, max 5]
   - LOOP(visual-design → verify → design-lint) [visual-design, max 5]
   - LOOP(interaction-design → verify → design-lint) [interaction-design, max 5] — conditional per new-design's interaction-design LOOP trigger rules
   - design-review (gate outside LOOP, per-page)
   - accessibility-audit (gate outside LOOP, per-page)
3. After each page completes, update DESIGN_PLAN.md Section 2 Status column (pending → done)
4. Update product-level state.yaml substage (e.g., `substage: page-P03`)

**PC2: P0 Milestone Integration Checkpoint** (operationalizes the PC2 node in the Orchestration diagram)

- **Trigger**: All P0-priority pages in DESIGN_PLAN.md Section 2 reach Status = done (each P0 page passed its own verify + lint + design-review + accessibility-audit). P1/P2 pages may still be pending. Runs once per product workflow, at the P0 milestone — not after every single page.
- **Check items**:
  - Cross-page navigation: navigation structure (header/footer/routing) is consistent across all P0 pages; no broken cross-page links; auth/route guards match the user flows in DESIGN_PLAN.md Section 5
  - Flow integrity: every user flow in DESIGN_PLAN.md Section 5 that traverses only P0 pages is navigable end-to-end (entry → critical checkpoints → exit); no dead-ends or unreachable states
- **On pass**: record PC2 result in `loops/specs/<product-task>/pc2-evidence.md`, continue with P1/P2 pages
- **On failure**: pause the workflow and report to the user with the specific navigation/flow gap. Do not start P1/P2 pages until PC2 passes — P1/P2 work would otherwise build on a broken P0 foundation, and the same gap would be re-discovered (more expensively) at PC3.

**Interruption handling**: If a per-page LOOP fails or hits hard circuit breaker, pause the entire product workflow, report to user. User can: fix the page and resume, or skip the page and continue with others (mark as "skipped" in DESIGN_PLAN.md).

**Context persistence**: Product-level state.yaml tracks overall progress; per-page state.yaml tracks page-level progress. On session resume, read product-level state first, then per-page state for the current page.

### 7. product-design-review (product-level consistency gate)

After all pages in DESIGN_PLAN.md Section 2 reach Status = done or skipped:

- Run the `product-design-review` skill
- Inputs: DESIGN_PLAN.md + all per-page outputs (visual/interaction/prototype) + component-map.json (with usedBy) + tokens.json
- Output: `loops/specs/<product-task>/product-review-evidence.md`
- Checks: navigation consistency / user flow completeness / component reuse / token consistency / responsive consistency / interaction consistency

**On failure**:
- Critical finding → return to the specific page's LOOP for fix, then re-run product-design-review
- Nit/FYI → record, proceed

**On pass**: proceed to design-handoff

### 8. design-handoff (product-level handoff)

Run the `design-handoff` workflow / `design-handoff-spec` skill at product level:

- Aggregate all per-page outputs
- Generate `docs/handoff/design-to-solo.md` (product-level, includes Page Inventory with navigation structure, Component Inventory with reuse matrix, Cross-Page Consistency Report, reference to DESIGN_PLAN.md)
- Generate `docs/handoff/component-map.json` (with `usedBy` field populated from DESIGN_PLAN.md Section 3)
- Run Pre-Delivery Checklist

### 9. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Product-level requirements (with AC-xxx) |
| docs/visual/DESIGN_PLAN.md | Product-level design plan (page inventory, shared components, user flows, execution order) |
| docs/design-system/components/<Component>.md | Shared component designs (Phase 1, if run) |
| docs/visual/<page>.md | Per-page visual designs (one per page) |
| docs/interaction/<page>.md | Per-page interaction designs (one per page) |
| docs/prototype/wireframe-<page>.md | Per-page wireframes (one per page, if wireframe LOOP ran) |
| docs/prototype/flow.md | Product user flow diagram |
| docs/handoff/design-to-solo.md | Product-level handoff (enhanced) |
| docs/handoff/component-map.json | Component map (with usedBy field) |
| loops/specs/<product-task>/state.yaml | Product-level loop state |
| loops/specs/<product-task>/product-review-evidence.md | Product-level review evidence |
| loops/specs/<product-task>-<page-name>/state.yaml | Per-page loop state (one per page) |
| loops/specs/<product-task>-<page-name>/evidence.md | Per-page review evidence (one per page) |
| loops/specs/<product-task>-<page-name>/iterations.log | Per-page iteration history (one per page) |

## Exit Criteria

- DESIGN_PLAN.md produced and user-confirmed
- Design system gate passed
- All shared components designed (Phase 1, if run)
- All pages in DESIGN_PLAN.md Section 2 reach Status = done or skipped (each non-skipped page passed its own verify + lint + design-review + accessibility-audit; skipped pages must be acknowledged in Open Items)
- product-design-review passed (no open Critical findings)
- design-handoff completed (design-to-solo.md + component-map.json + Pre-Delivery Checklist)
- Product-level state.yaml status = done

## Interaction Points

| Point | Type | Mode-dependent? |
|------|------|-----------------|
| design-brief assumptions confirmation | 👤 human decision | Always pause |
| Aesthetic direction selection | 👤 human decision | Always pause |
| Design system gate resolution (choose onboarding vs setup) | 👤 human decision | Always pause |
| DESIGN_PLAN.md confirmation before per-page work | 👤 human decision | Always pause |
| Per-page visual variant selection (2-3 options) | 👤 human decision | Always pause |
| Per-page design-review Critical findings | 👤 human decision | Always pause |
| Product-design-review Critical findings | 👤 human decision | Always pause |
| Module boundary pauses (between Phase 1 → Phase 2 → review → handoff) | ⏸ exploration dialog | Controlled by exploration_mode |

## Comparison with new-design

| Dimension | new-design | new-product-design |
|-----------|-----------|-------------------|
| Scope | Single page | Entire product (all pages) |
| Planning | None (jumps to wireframe) | DESIGN_PLAN.md (page inventory + shared components + flows) |
| Design system | Hard gate (triggers onboarding/setup if missing) | Hard gate (triggers onboarding/setup if missing) |
| Per-page LOOP | 3 LOOPs (wireframe/visual/interaction) | Drives new-design's 3 LOOPs per page |
| Cross-page consistency | None | product-design-review skill |
| Handoff | Single page design-to-solo.md | Product-level design-to-solo.md (with Page Inventory + reuse matrix + consistency report) |
| Task granularity | `<NNN>-<page-name>` | `<NNN>-<product-name>` (product) + `<NNN>-<product-name>-<page-name>` (per page) |
| When to use | "Design this page" | "Design the whole product" / "Design all pages" |
