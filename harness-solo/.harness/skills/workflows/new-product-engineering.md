---
workflow_id: H
name: new-product-engineering
description: "Implement an entire product end-to-end: plan all features, shared infrastructure, and dependency order, then drive per-feature new-feature LOOPs, and finish with product-level consistency review"
default_mode: deep
---

# Workflow: new-product-engineering

> Product-level engineering workflow · Implements a complete product across all features in one orchestrated run
> Difference from new-feature: new-feature handles a single feature; new-product-engineering plans the whole product then drives per-feature implementation with cross-feature consistency. Use new-feature for one-off feature additions; use new-product-engineering for "implement the whole product" / "implement all features".

## Applicable Scenarios

- Implementing a complete product from scratch (multiple features that must work together)
- User says "implement the whole product" / "implement all features" / "build the full system"
- Features share infrastructure (auth, API client, state management) that must be consistent across the product
- First full implementation pass for a new product

## When to use new-feature instead

- Adding a single feature to an existing product → use new-feature
- Fixing a production bug → use bugfix
- Refactoring existing code → use refactor
- Optimizing performance → use optimize
- Migrating to a new framework → use migration
- Releasing a version → use release (after product-engineering is complete)

## Orchestration

```
session-start
  → Engineering Foundation Gate (hard gate)
  → brainstorming (product-level, confirm feature inventory)
  → Product-level PLAN (produce ENGINEERING_PLAN.md)
  → [Phase 1] Shared Infrastructure LOOP (auth/API client/state management/utils)
      └─ IC1: after all infra modules complete
  → [Phase 2] Per-feature LOOPs (drive new-feature for each feature, by topological sort)
      └─ IC2-IC4: at milestone points during Phase 2
  → product-engineering-review (product-level consistency gate)
      └─ IC5: full integration test runs as part of review
  → Product-level Handoff (solo-to-growth.md + solo-to-ops.md, product-level)
  → session-end
```

**Key principles**:
- Plan before implementing: ENGINEERING_PLAN.md is the blueprint, drives all downstream per-feature work
- Shared infrastructure first: features hard-depend on infrastructure (unlike design's shared components, infrastructure cannot be stubbed)
- Per-feature LOOPs run independently (each feature = one new-feature run, with its own spec/state/evidence)
- Cross-feature consistency is a separate gate after all features pass their own gates
- Integration checkpoints during Phase 2 catch integration issues early, not just at the end

## Detailed Steps

### 1. session-start

Read `memory/progress.md` to restore context.

### 2. Engineering Foundation Gate (hard gate)

Check whether engineering foundation exists:

- [ ] Read `docs/engineering/TECH_STACK.md` — must exist and have test/build/lint commands filled in
- [ ] Read `docs/product/PROJECT.md` — must exist with acceptance criteria
- [ ] If either is missing or incomplete → pause, ask user:
  - Option A: run `setup` workflow first (initialize config files)
  - Option B: user confirms they will provide config externally, then proceed
- **Hard gate rationale**: brainstorming / writing-plans / executing-plans / verify all depend on TECH_STACK.md for test/build/lint commands. Proceeding without it causes silent failures — commands cannot run, verify cannot validate.

### 3. brainstorming (product-level)

- Run the `brainstorming` skill at product level
- Confirm feature inventory from upstream sources:
  - `docs/handoff/pm-to-solo.md` (product requirements + AC-xxx)
  - `docs/handoff/design-to-solo.md` (design handoff + DAC-xxx, if frontend is involved; contains Product Design Plan Reference section that indirectly carries DESIGN_PLAN.md's page inventory)
  - `docs/handoff/component-map.json` (component contract, if frontend is involved)
  - `docs/product/PRD.md` (feature list, data model, interface definitions)
- Update `docs/product/PROJECT.md` if scope changes
- Hard gate: do not proceed if product requirements are ambiguous

### 4. Product-level PLAN

Produce `docs/engineering/ENGINEERING_PLAN.md` based on the `ENGINEERING_PLAN-template.md`:

1. Read upstream sources (brainstorming outputs + handoff documents + DESIGN_PLAN.md)
2. Fill ENGINEERING_PLAN.md sections:
   - **Section 1 Product Overview**: from brainstorming + PROJECT.md
   - **Section 2 Feature Inventory**: enumerate all features to implement this round, assign Feature IDs (F01/F02/...), set priority (P0/P1/P2), set dependencies (hard dependencies only — code-level imports/API calls/data model sharing)
   - **Section 3 Shared Infrastructure**: extract modules used by multiple features (auth/API client/state management/utils), assign Infra IDs (I01/I02/...)
   - **Section 4 Dependency Graph**: draw feature + infrastructure dependency relationships, verify no circular dependencies
   - **Section 5 Implementation Execution Order**: shared infrastructure first (Phase 1), then features by topological sort of dependencies (Phase 2/3)
   - **Section 6 Integration Checkpoints**: define periodic integration checks (after Phase 1, after P0 features, after all features)
   - **Section 7 Cross-Feature Consistency Constraints**: hard rules checked by product-engineering-review
   - **Section 8 Engineering Foundation Dependency**: confirm gate passed
   - **Section 9 Key Decisions**: record major engineering decisions made during planning (e.g., state management library, API style, feature-flag strategy) with rationale and impact scope
   - **Section 10 Open Items**: list unresolved TBDs discovered during planning (e.g., uncertain scope items, pending technical questions) to be resolved before/during implementation
3. Initialize product-level `loops/specs/<product-task>/state.yaml` (stage=plan, iteration=0, status=running; set status: planning during ENGINEERING_PLAN.md production)
4. User confirms ENGINEERING_PLAN.md before per-feature work begins (👤 human decision point)

> **Task naming**: Product-level task uses `<NNN>-<product-name>` (e.g., `001-shopping-app`). Per-feature tasks use `<NNN>-<product-name>-<feature-name>` (e.g., `001-shopping-app-auth`). See LOOP.md task granularity section.

### 5. Phase 1: Shared Infrastructure LOOP

For each shared infrastructure module in ENGINEERING_PLAN.md Section 3 (in priority order):

- Run a mini new-feature workflow for the infrastructure module:
  - writing-plans (produce spec.md for the module, e.g., `loops/specs/<NNN>-<product-name>-infra-<module-name>/spec.md`)
  - LOOP(tdd → verify) [feature type, max 5]
  - code-review (gate outside LOOP)
- Output: functional shared infrastructure module + tests
- After all infrastructure modules complete, run **Integration Checkpoint IC1**: shared infrastructure compiles + unit tests pass

**Interruption handling**: If an infrastructure LOOP fails, pause the entire product workflow. Infrastructure is a hard dependency for all features; cannot proceed without it.

### 6. Phase 2: Per-feature LOOPs (drive new-feature for each feature)

For each feature in ENGINEERING_PLAN.md Section 5 execution order (topological sort):

1. **Dependency gate check**: verify all features in this feature's "Depends On" column have Status = done in FEATURES.md. If not, STOP — cannot start a feature whose dependencies are incomplete.
2. Read ENGINEERING_PLAN.md entry for this feature (Feature ID, priority, dependencies, expected AC)
3. Drive the `new-feature` workflow for this single feature:
   - Skip brainstorming (already done at product level); inherit product-level context + add feature-specific AC if needed
   - PLAN (writing-plans, initialize feature-level `loops/specs/<product-task>-<feature-name>/state.yaml`)
   - LOOP(tdd → verify) [feature type, max 5]
   - code-review (gate outside LOOP)
4. After each feature completes:
   - Update ENGINEERING_PLAN.md Section 2 Status column (pending → done)
   - Update FEATURES.md status board
   - Update product-level state.yaml nested_progress (e.g., `nested_progress: feature-F03 in progress`)
5. **Integration Checkpoints** (per Section 6): when a checkpoint trigger is reached, run the checkpoint checks before continuing to the next feature.

**Interruption handling**: If a per-feature LOOP fails or hits hard circuit breaker, pause the entire product workflow, report to user. User can: fix the feature and resume, or skip the feature and continue with others (mark as "skipped" in ENGINEERING_PLAN.md — but dependent features cannot start).

**Context persistence**: Product-level state.yaml tracks overall progress; per-feature state.yaml tracks feature-level progress. On session resume, read product-level state first, then per-feature state for the current feature.

### 7. Phase 3: Integration Checkpoints

Integration checkpoints (IC1-IC5 from ENGINEERING_PLAN.md Section 6) run during Phase 2, not just at the end:

- **IC1** (after Phase 1): shared infrastructure compiles + unit tests pass
- **IC2-IC4** (during Phase 2): cross-feature user flows work at milestone points
- **IC5** (after all features): full integration test — runs as part of product-engineering-review

If an integration checkpoint fails, pause the product workflow, report to user. The failing feature's LOOP must be revisited.

### 8. product-engineering-review (product-level consistency gate)

After all features in ENGINEERING_PLAN.md Section 2 reach Status = done or skipped:

- Run the `product-engineering-review` skill
- Inputs: ENGINEERING_PLAN.md + all per-feature outputs + source code + lockfile + migrations
- Output: `loops/specs/<product-task>/product-review-evidence.md`
- Checks: API contract consistency / dependency conflict / data model consistency / config consistency / shared module reuse / integration runnability

**On failure**:
- Critical finding → return to the specific feature's LOOP for fix, then re-run product-engineering-review
- Nit → record, proceed

**On pass**: proceed to product-level handoff

### 9. Product-level Handoff

> **Division of labor with session-end**: The actual handoff document writing is executed by session-end (steps 6-8). Step 9 only prepares the product-level aggregated content (cross-feature summaries, shared infrastructure list, aggregated tracking events / env vars / dependency list) for session-end to consume — it does not write the handoff files itself.

Run the handoff skills at product level:

- Generate `docs/handoff/solo-to-growth.md` (product-level, includes Feature Inventory implementation summary + shared infrastructure list + tracking event list aggregated across features)
- Generate `docs/handoff/solo-to-ops.md` (product-level, includes product-level deployment requirements + full dependency list + integration test results + environment variable list aggregated across features)
- Optionally generate `docs/handoff/solo-to-pm.md` (engineering feedback to PM, if scope/AC changes discovered during implementation)

### 10. session-end

Update `memory/progress.md` and archive the session.

## Deliverables

| File | Description |
|------|-------------|
| docs/engineering/ENGINEERING_PLAN.md | Product-level engineering plan (feature inventory + shared infrastructure + dependency graph + execution order) |
| .harness/FEATURES.md | Dynamic status board (updated per feature completion) |
| Source code for shared infrastructure | Phase 1 outputs (auth/API client/state management/utils) |
| Source code for all features | Phase 2 outputs (one per feature) |
| loops/specs/<product-task>/state.yaml | Product-level loop state |
| loops/specs/<product-task>/product-review-evidence.md | Product-level review evidence |
| loops/specs/<NNN>-<product-name>-infra-<module-name>/ | Per-infrastructure-module loop artifacts (spec.md + state.yaml + evidence.md + iterations.log) |
| loops/specs/<product-task>-<feature-name>/ | Per-feature loop artifacts (spec.md + state.yaml + evidence.md + iterations.log) |
| docs/handoff/solo-to-growth.md | Product-level handoff to growth |
| docs/handoff/solo-to-ops.md | Product-level handoff to ops |

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| Shared infrastructure LOOP fails (Phase 1) | Pause the entire product workflow; infrastructure is a hard dependency for all features. Fix and re-run IC1 before any feature starts |
| Per-feature LOOP fails or hits hard circuit breaker (Phase 2) | Pause the product workflow, report to user. Options: fix the feature and resume, or mark it "skipped" in ENGINEERING_PLAN.md (dependent features cannot start) |
| Integration checkpoint (IC1-IC5) fails | Pause the product workflow, report to user. The failing feature's LOOP must be revisited before continuing |
| product-engineering-review fails (Critical finding) | Return to the specific feature's LOOP for fix, then re-run product-engineering-review. Nit findings: record and proceed |

## Exit Criteria

- ENGINEERING_PLAN.md produced and user-confirmed
- Engineering foundation gate passed
- All shared infrastructure implemented (Phase 1) + IC1 passed
- All features in ENGINEERING_PLAN.md Section 2 reach Status = done or skipped (each non-skipped feature passed its own tdd → verify → code-review; skipped features must be acknowledged in Open Items)
- All integration checkpoints (IC1-IC5) passed
- product-engineering-review passed (no open Critical findings)
- Product-level handoff completed (solo-to-growth.md + solo-to-ops.md)
- FEATURES.md status board fully updated
- Product-level state.yaml status = done

## Interaction Points

| Point | Type | Mode-dependent? |
|------|------|-----------------|
| brainstorming assumptions confirmation | 👤 human decision | Always pause |
| Engineering foundation gate resolution (choose setup vs external) | 👤 human decision | Always pause |
| ENGINEERING_PLAN.md confirmation before per-feature work | 👤 human decision | Always pause |
| Dependency gate violation (feature cannot start) | 👤 human decision | Always pause |
| Per-feature design variant selection (if frontend) | 👤 human decision | Always pause |
| Per-feature code-review Critical findings | 👤 human decision | Always pause |
| Integration checkpoint failure | 👤 human decision | Always pause |
| product-engineering-review Critical findings | 👤 human decision | Always pause |
| Module boundary pauses (between Phase 1 → Phase 2 → review → handoff) | ⏸ exploration dialog | Controlled by exploration_mode |

## Comparison with new-feature

| Dimension | new-feature | new-product-engineering |
|-----------|------------|----------------------|
| Scope | Single feature | Entire product (all features) |
| Planning | None (jumps to brainstorming) | ENGINEERING_PLAN.md (feature inventory + shared infrastructure + dependency graph) |
| Engineering foundation | Hard gate (triggers setup if missing) | Hard gate (triggers setup if missing) |
| Shared infrastructure | Not handled | Phase 1 dedicated implementation |
| Per-feature LOOP | tdd → verify → code-review | Drives new-feature's LOOP per feature |
| Cross-feature consistency | None | product-engineering-review skill |
| Integration testing | Per-feature tests only | Integration checkpoints + full test suite |
| Handoff | Single feature solo-to-growth.md / solo-to-ops.md | Product-level handoff (aggregated) |
| Task granularity | `<NNN>-<feature-name>` | `<NNN>-<product-name>` (product) + `<NNN>-<product-name>-<feature-name>` (per feature) |
| When to use | "Implement this feature" | "Implement the whole product" / "Implement all features" |
