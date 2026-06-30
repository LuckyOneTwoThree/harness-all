---
name: session-end
description: Records recoverable session state, synchronizes canonical status, refreshes exact baseline metrics, and publishes explicitly needed handoffs.
---
# Session End

## Inputs

- current session block and changed task states
- `.harness/FEATURES.md`
- final `evidence.md` / `review.md`
- outbound handoff templates when a downstream delivery is requested

## Outputs

- progress/knowledge/task-board updates
- exact `.harness/memory/baseline.json`
- optional portable handoff packages

## Process

### 1. Record + Sync (merged)

Complete the current progress block with outcomes/evidence, current task and stage, pending work, blockers, decisions, and next action. Promote only durable decisions/pitfalls to knowledge-base.md.

Read raw task states changed this session. Sync `.harness/FEATURES.md` from them: only review-owned `status: done` becomes board `done` (code-review for delivery tasks, product-engineering-review for the product orchestrator); running/retrying/needs-human/blocked/failed remain distinct and are not collapsed to in-progress; product nested progress is derived from this board, not duplicated in ENGINEERING_PLAN.md or product state.

Check retention thresholds, then invoke `memory-maintenance` as the sole owner of progress/knowledge/iteration/archive rotation. Session-end does not implement a second archive algorithm. Progress recording is mandatory; archival is conditional on retention thresholds.

### 2. Refresh Baseline (on-demand)

Refresh `baseline.json` **only when source files changed this session** (code/test/config/migration changes). Skip for pure-documentation or no-code sessions. When refreshing, write baseline fields defined by verify's `Reference/entropy-baseline.md`: exact tracked/source file count under documented exclusions; exact line count from those files (never estimate LOC from file count); dependency count from actual manifests; TODO/FIXME/XXX count. Record measurement scope/tool. If required exact metrics cannot be computed, keep the previous valid baseline and record the blocker; never replace an unknown value with zero, null, or an estimate.

### 3. Publish Requested Downstream Contracts (on-demand)

Publish only when there is a real consumer need:

- **`solo-to-growth.md`**: explicit growth handoff need and implemented instrumentation/user-visible behavior.
- **`solo-to-ops.md`**: explicit release/deployment intent, or environment/migration/deployment contract requested for a release candidate.
- **`solo-to-pm.md`**: engineering evidence materially affects scope, AC meaning, feasibility, or product decision.

Feature completion alone does not automatically generate every handoff.

For each selected route:

1. fill its dedicated template from reviewed evidence;
2. preserve stable IDs and include only consumer-actionable fields;
3. apply `.harness/rules/handoff-protocol.md` and acceptance-ID protocol;
4. create the self-contained package, run `validate-handoff.ps1`, archive prior current pointer, publish ready, and record receipt expectations;
5. record handoff ID, manifest hash, and supersedes ID in progress.md.

Never publish a draft as ready, reference producer-local files outside the package, or write the same handoff from a workflow and session-end.

## Exit Gate

- progress contains an exact resume point;
- FEATURES reflects canonical task states;
- baseline metrics are exact or explicitly unavailable;
- retention was delegated when thresholds were met;
- every published package validates and is recorded.

## Prohibitions

- Marking a task done because verify passed but review did not.
- Estimating LOC from file count.
- Auto-generating Growth/Ops handoffs for irrelevant local work.
- Duplicating memory-maintenance or handoff publication logic.
