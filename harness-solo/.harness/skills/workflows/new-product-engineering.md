---
workflow_id: H
name: new-product-engineering
description: "Plan and deliver a coordinated multi-feature product through nested canonical tasks and one cross-feature integration review"
default_mode: deep
---
# Workflow: New Product Engineering

Use only when multiple features share infrastructure/contracts and require coordinated order. A single feature uses new-feature.

## Canonical Sources

- `ENGINEERING_PLAN.md`: approved scope, dependencies, shared infrastructure, order, checkpoints; not a live status board.
- `.harness/FEATURES.md`: aggregate nested-task status.
- product `state.yaml`: only current orchestration position (`current_nested_task`).
- nested `state.yaml`: exact LOOP state for that task.

Do not duplicate status across all three.

## Route

### 1. Foundation and Product Plan

1. session-start (product-level, runs once) validates PM/Design packages and project foundation.
2. product-level Plan: when PM handoff provides an executable feature inventory with stable criteria and boundaries, skip brainstorming and let writing-plans consume it directly; otherwise run brainstorming + writing-plans as one continuous merge. Either way produce `ENGINEERING_PLAN.md` (feature IDs + stable criteria; shared infrastructure only when used by multiple features; hard dependency DAG + topological order; integration checkpoints tied to real cross-feature boundaries; technical decisions, open items, rollback/operational impact).
3. Initialize product state with `iteration: 0`, `stage: plan`, `status: running`, and empty/current `current_nested_task`; validate against the state schema.
4. **Plan-stage Gate (sole break point in Plan)**: the writing-plans Gate applies at product level — unresolved material architecture/scope decisions become `needs-human` before nested delivery. In family mode with PM-provided architecture/scope, this Gate is satisfied by the upstream contract and does not pause. In standalone mode, pause 👤 for material decisions not derivable from existing sources. No additional Plan-stage break points; brainstorming and writing-plans run as one continuous stage and escalate to this Gate only.

### 2. Nested Delivery (no per-feature session ceremony)

Execute each infrastructure module/feature as its own canonical task. The product-level session owns the whole product's recovery point and board sync; nested tasks do not re-run session-start/session-end (per `engineering-pipeline.md` Canonical Path). Each nested task runs directly:

- select workflow variant (normally new-feature; bug/refactor/migration only when that is the actual work);
- Plan (brainstorming if ambiguous → writing-plans creates nested spec/state);
- nested LOOP (ACT with inline verify-fast → verify-full → code-review);
- product state changes only `current_nested_task`.

### 3. Integration Checkpoints (inlined)

Checkpoints run after shared infrastructure and at dependency-bound milestones, inlined into the owning nested task's verify-full (per `engineering-pipeline.md` Canonical Path). Each checkpoint has a command/flow, expected result, and evidence path written into the nested task's evidence. Failure routes to the owning nested task; it does not increment product-level iteration.

### 4. Product Review

After every non-skipped nested task is done, run product-engineering-review once for cross-feature API/data/config/dependency/shared-module/design consistency and full integration runnability. It does not repeat per-feature acceptance/security review.

Skipped work requires explicit user approval, dependency impact, and downstream limitation; dependent tasks cannot be marked done without an approved alternative.

### 5. Close and Handoff

Prepare aggregated facts for session-end. Session-end alone publishes requested Solo→PM packages; this workflow does not write the same handoff twice.

Product-engineering-review marks the product state done only after every required nested task is done and the integration review passes. Then session-end syncs FEATURES and records handoff IDs.

## Exit

- approved ENGINEERING_PLAN with acyclic dependency order;
- all required nested tasks reviewed/done;
- checkpoints and product review pass with evidence;
- one canonical aggregate status board;
- requested handoffs published once by session-end.
