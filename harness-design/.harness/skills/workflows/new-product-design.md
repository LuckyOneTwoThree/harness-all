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
  → Product-level PLAN (produce DESIGN_PLAN.md + pre-generate per-page spec skeletons + create unified lint script)
  → [Phase 1] Shared Components LOOP (conditional, skip if all exist)
      └─ PC1: after all shared components complete
  → [Phase 2] Per-page LOOPs (no per-page PLAN, no per-page design-review)
      └─ PC2: at P0 milestone
  → product-design-review (product-level consistency gate)
  → Unified design-review (single product-level review, replaces N per-page reviews)
  → Product-level Handoff package (design-to-solo.md + component-contract.json)
  → session-end
```

**Key principles**:
- Plan before designing: DESIGN_PLAN.md is the blueprint, drives all downstream per-page work
- Pre-generate per-page specs at product-level PLAN: eliminates per-page PLAN step
- Shared components first: avoids re-creating variants per page
- Per-page LOOPs run independently (each page runs visual + interaction LOOPs only; PLAN and design-review are product-level)
- Unified design-review at the end: single sub-agent call scans all pages, replaces N per-page reviews
- Cross-page consistency is a separate gate after all pages pass their own LOOPs

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
- **Hard gate**: do not proceed to per-page design without a design system. ui-design (A1: replaces former visual-design + interaction-design) and wireframe skills require DESIGN.md as input; proceeding without it causes silent failures.

### 4. Product-level PLAN

Produce `docs/visual/DESIGN_PLAN.md` based on the `templates/DESIGN_PLAN-template.md`, and **pre-generate per-page spec skeletons** to skip per-page PLAN:

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
5. Initialize product-level `loops/specs/<product-task>/state.yaml` (stage=plan, iteration=0, status=running)
6. **Pre-generate per-page spec skeletons**: For each page in Section 2, create `loops/specs/<product-task>-<page-name>/spec.md` containing:
   - Page ID + page name + priority (from DESIGN_PLAN.md Section 2)
   - AC-xxx list for this page (extracted from product-level DESIGN_BRIEF.md, filtered to page-relevant ACs)
   - DAC-xxx placeholder (to be filled during per-page LOOP if design-specific ACs emerge)
   - Initial `state.yaml` (stage=design, iteration=0, status=running)
   
   This eliminates the per-page PLAN step. When a page enters its LOOP, the Agent directly loads the pre-generated spec.md, does a quick confirmation (< 30s), and starts ui-design (A1: combined visual + interaction). If page-specific ACs need adding, the Agent appends them in-place without a separate PLAN step.
7. **Create unified lint script**: Write `loops/specs/<product-task>/lint-all.mjs` once, parameterized to accept a page file path. Each per-page verify calls this script with the current page's path instead of writing a new one-off script. The script implements L001-L015 per the verify skill's lint rule list.
8. User confirms DESIGN_PLAN.md before per-page work begins (👤 human decision point)

> **Task naming**: Product-level task uses `<NNN>-<product-name>` (e.g., `001-shopping-app`). Per-page tasks use `<NNN>-<product-name>-<page-name>` (e.g., `001-shopping-app-home`). See LOOP.md task granularity section.

### 5. Phase 1: Shared Components LOOP (conditional)

**Trigger**: DESIGN_PLAN.md Section 3 lists shared components, AND `docs/design-system/components/<Component>.md` does not exist for them.

For each shared component (in priority order):
- Run `component-design` → `verify` LOOP (loop type: `component`, max 5; verify includes lint)
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

### 6. Phase 2: Per-page LOOPs (no per-page PLAN, no per-page design-review)

For each page in DESIGN_PLAN.md Section 6 execution order:

1. Read the pre-generated `loops/specs/<product-task>-<page-name>/spec.md` (from Product-level PLAN step 6)
2. Quick confirmation (< 30s): verify spec.md has the page's AC-xxx; if page-specific ACs are needed, append in-place (no separate PLAN step)
3. Run per-page LOOPs (design-brief and PLAN already done at product level; design-review deferred to product-level step 8):
   - [Conditional] LOOP(wireframe → verify) [wireframe, max 5] — skipped when component library covers the layout
   - LOOP(ui-design → verify) [ui-design, max 5] — A1: combined visual + interaction; single variant when design system is complete; interaction sub-stage conditional per ui-design skill's trigger rules
   - **No per-page design-review** — deferred to product-level unified design-review (step 8)
4. After each page's LOOPs pass, update DESIGN_PLAN.md Section 2 Status column (pending → loop-passed)
5. Update product-level state.yaml `current_nested_task` (e.g., `current_nested_task: <product-task>-<page-name>`)

**Why no per-page design-review?** When pages share the same design system, Axis 1-4 (visual hierarchy / spacing / color / component consistency) review criteria are identical across pages. A unified product-level design-review (step 8) scans all pages in one fresh-context sub-agent call, emits per-page findings, and avoids N redundant sub-agent invocations. Per-page design-review is reserved for pages with non-standard layouts or custom interactions flagged by the unified review.

**PC2: P0 Milestone Integration Checkpoint** (operationalizes the PC2 node in the Orchestration diagram)

- **Trigger**: All P0-priority pages in DESIGN_PLAN.md Section 2 reach Status = loop-passed (each P0 page passed its own verify for all triggered LOOPs). P1/P2 pages may still be pending. Runs once per product workflow, at the P0 milestone — not after every single page.
- **Check items**:
  - Cross-page navigation: navigation structure (header/footer/routing) is consistent across all P0 pages; no broken cross-page links; auth/route guards match the user flows in DESIGN_PLAN.md Section 5
  - Flow integrity: every user flow in DESIGN_PLAN.md Section 5 that traverses only P0 pages is navigable end-to-end (entry → critical checkpoints → exit); no dead-ends or unreachable states
- **On pass**: record PC2 result in `loops/specs/<product-task>/pc2-evidence.md`, continue with P1/P2 pages
- **On failure**: pause the workflow and report to the user with the specific navigation/flow gap. Do not start P1/P2 pages until PC2 passes — P1/P2 work would otherwise build on a broken P0 foundation, and the same gap would be re-discovered (more expensively) at the unified design-review.

**Interruption handling**: If a per-page LOOP fails or hits hard circuit breaker, pause the entire product workflow, report to user. User can: fix the page and resume, or skip the page and continue with others (mark as "skipped" in DESIGN_PLAN.md).

**Context persistence**: Product-level state.yaml tracks overall progress; per-page state.yaml tracks page-level progress. On session resume, read product-level state first, then per-page state for the current page.

### 7. product-design-review (product-level consistency gate, conditional depth)

After all pages in DESIGN_PLAN.md Section 2 reach Status = done or skipped:

- Run the `product-design-review` skill
  - Inputs: DESIGN_PLAN.md + all per-page outputs + component-contract.json (with used_by) + tokens.json + per-page `review-evidence.md` (reads `## Five-Axis Review` + `## WCAG Audit` sections)
  - **Trigger condition**: Full 6-check review runs when page count >= 3 AND shared component count >= 3; otherwise degrades to lightweight 2-check (navigation + flow completeness only)
- Output: appends `## Product-Level Review` section to `loops/specs/<product-task>/review-evidence.md` (A2: no separate product-review-evidence.md)
- Full mode checks: navigation consistency / user flow completeness / component reuse / token consistency / responsive consistency / interaction consistency
- Lightweight mode checks: navigation consistency / user flow completeness only

**On failure**:
- Critical finding → return to the specific page's LOOP for fix, then re-run product-design-review
- Nit/FYI → record, proceed

**On pass**: proceed to unified design-review

### 8. Unified design-review (product-level, replaces per-page design-review)

Run the `design-review` skill once at product level, scanning all designed pages (A3: fresh-context sub-agent only in deep mode; skip/standard mode does main-context self-review):

- **Inputs**: all `docs/ui/<page>.md` (A1: combined visual + interaction; formerly docs/visual/ + docs/interaction/) + DESIGN.md + tokens.json + all per-page spec.md + all per-page `review-evidence.md` (verify + lint sections)
- **Outputs** (A2: all appended to `loops/specs/<product-task>/review-evidence.md`, no separate files):
  - `## Five-Axis Review` section — per-page Axis 1-5 findings (one subsection per page)
  - `## WCAG Audit` section — per-page WCAG machine-assertable audit (B2: contrast computation + annotation inspection only, no AI-debate prose)
  - `## Doubt-Driven Review` section — Critical findings + Nit/FYI (A3: mode recorded in header)
- **Process**:
  - Axis 1-4: scan each page, record findings per page; design-system-level issues (token mismatch, component inconsistency) are recorded once and marked as "applies to all pages"
  - Axis 5 (WCAG audit, B2): run per-page machine-assertable checks (contrast computation / keyboard spec / semantic labels / responsive / reduced-motion / dark mode), record per-page results; strip AI-debate prose (deferred to solo verify-full)
  - Doubt-Driven (A3): only Critical findings trigger adversarial debate (deep mode = sub-agent; standard/skip = main-context self-review); Nit/FYI recorded directly
- **👤 Human decision point**: pause for Critical findings; user decides fix or accept risk

**Per-page deep-dive trigger** (conditional, only when needed):
- If the unified review flags a page with Critical findings that require deep investigation, run a targeted per-page design-review for that specific page only
- This is the exception path, not the default — most pages should be covered by the unified scan

**On failure**:
- Critical finding on a specific page → return to that page's LOOP for fix, then re-run unified review (or targeted per-page review for that page only)
- Design-system-level Critical (e.g., token inconsistency affecting all pages) → fix at design-system level, then re-verify affected pages' verify

**On pass**: proceed to design-handoff

### 9. design-handoff (product-level handoff)

Run the `design-handoff` workflow / `design-handoff-spec` skill at product level:

- Aggregate all per-page outputs
- Generate `docs/handoff/design-to-solo.md` (product-level, includes Page Inventory with navigation structure, Component Inventory with reuse matrix, Cross-Page Consistency Report, reference to DESIGN_PLAN.md)
- Generate `docs/handoff/component-contract.json` with `used_by` populated from DESIGN_PLAN.md Section 3
- Run Pre-Delivery Checklist

### 10. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|------|
| docs/visual/DESIGN_BRIEF.md | Product-level requirements (with AC-xxx) |
| docs/visual/DESIGN_PLAN.md | Product-level design plan (page inventory, shared components, user flows, execution order) |
| docs/design-system/components/<Component>.md | Shared component designs (Phase 1, if run) |
| docs/ui/<page>.md | Per-page combined visual + interaction designs (A1: one per page; formerly docs/visual/ + docs/interaction/) |
| docs/prototype/wireframe-<page>.md | Per-page wireframes (one per page, if wireframe LOOP ran) |
| docs/prototype/flow.md | Product user flow diagram |
| docs/handoff/design-to-solo.md | Product-level handoff (enhanced) |
| docs/handoff/component-contract.json | Semantic component contract (with used_by) |
| loops/specs/<product-task>/state.yaml | Product-level loop state |
| loops/specs/<product-task>/lint-all.mjs | Unified lint script (parameterized per page) |
| loops/specs/<product-task>/review-evidence.md | Product-level consolidated evidence (A2: Product-Level Review + Five-Axis + WCAG + Doubt-Driven sections) |
| loops/specs/<product-task>-<page-name>/spec.md | Per-page spec skeleton (pre-generated, AC-xxx) |
| loops/specs/<product-task>-<page-name>/state.yaml | Per-page loop state (one per page) |
| loops/specs/<product-task>-<page-name>/review-evidence.md | Per-page consolidated evidence (A2: Verify Evidence + Lint Report sections) |
| loops/specs/<product-task>-<page-name>/iterations.log | Per-page iteration history (one per page) |

## Exit Criteria

- DESIGN_PLAN.md produced and user-confirmed
- Per-page spec skeletons pre-generated (step 6 of Product-level PLAN)
- Unified lint script created (step 7 of Product-level PLAN)
- Design system gate passed
- All shared components designed (Phase 1, if run)
- All pages in DESIGN_PLAN.md Section 2 reach Status = loop-passed or skipped (each non-skipped page passed its own verify for all triggered LOOPs; skipped pages must be acknowledged in Open Items)
- product-design-review passed (no open Critical findings)
- Unified design-review passed (no open Critical findings; per-page Axis 1-5 findings recorded)
- design-handoff package completed and validated (contract + manifest + artifacts)
- Product-level state.yaml status = done

## Interaction Points

| Point | Type | Mode-dependent? |
|------|------|-----------------|
| design-brief assumptions confirmation | 👤 human decision | Always pause |
| Aesthetic direction selection | 👤 human decision | Always pause |
| Design system gate resolution (choose onboarding vs setup) | 👤 human decision | Always pause |
| DESIGN_PLAN.md confirmation before per-page work | 👤 human decision | Always pause |
| Per-page visual variant selection (only when multi-variant triggered) | 👤 human decision | Always pause when triggered; skipped in single-variant mode (complete design system) |
| Product-design-review Critical findings | 👤 human decision | Always pause |
| Unified design-review Critical findings | 👤 human decision | Always pause (single point, replaces N per-page review pauses) |
| Module boundary pauses (between Phase 1 → Phase 2 → review → handoff) | ⏸ exploration dialog | Controlled by exploration_mode |

## Comparison with new-design

| Dimension | new-design | new-product-design |
|-----------|-----------|-------------------|
| Scope | Single page | Entire product (all pages) |
| Planning | Inline PLAN (per page) | Product-level PLAN + pre-generated per-page spec skeletons |
| Design system | Hard gate (triggers onboarding/setup if missing) | Hard gate (triggers onboarding/setup if missing) |
| Per-page LOOP | 3 LOOPs (wireframe/visual/interaction) + per-page design-review | 2-3 LOOPs (wireframe/visual/interaction) only; no per-page PLAN, no per-page design-review |
| Design review | Per-page design-review (Five-Axis + WCAG audit) | Unified product-level design-review (single scan, per-page findings) |
| Lint script | One-off per page | Unified script created at product-level PLAN, reused per page |
| Cross-page consistency | None | product-design-review skill |
| Handoff | Single page design-to-solo.md | Product-level design-to-solo.md (with Page Inventory + reuse matrix + consistency report) |
| Task granularity | `<NNN>-<page-name>` | `<NNN>-<product-name>` (product) + `<NNN>-<product-name>-<page-name>` (per page) |
| When to use | "Design this page" | "Design the whole product" / "Design all pages" |
