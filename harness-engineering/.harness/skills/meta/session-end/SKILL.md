---
name: session-end
description: Records recoverable session state, synchronizes canonical status, refreshes exact baseline metrics, and publishes explicitly needed handoffs.
---
# Session End

## When to use

- Standard/deep task wrapping up (write recovery point, sync state, refresh baseline, publish handoff if needed).
- Quick-fix uses its minimal wrap unless baseline refresh is explicitly requested.

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

Read raw task states changed this session. Sync `.harness/FEATURES.md` from them: only review-owned `status: done` becomes board `done` (code-review for delivery tasks, product-engineering-review for the product orchestrator).
- State mapping to FEATURES.md (which has only pending/in_progress/review/done/blocked):
  - running/retrying → in_progress
  - needs-human/blocked → blocked (record specific sub-state and reason in Note column)
  - failed → blocked (record "hard_limit_reached" + last_error in Note column)
  - review → review
  - done → done

Product nested progress is derived from this board, not duplicated in ENGINEERING_PLAN.md or product state.

Check retention thresholds, then invoke `memory-maintenance` as the sole owner of progress/knowledge/iteration/archive rotation. Session-end does not implement a second archive algorithm. Progress recording is mandatory; archival is conditional on retention thresholds.

### 2. Refresh Baseline (on-demand)

Refresh `baseline.json` **only when source files changed this session** (code/test/config/migration changes). Skip for pure-documentation or no-code sessions. When refreshing, write baseline fields defined by verify's `Reference/entropy-baseline.md`: exact tracked/source file count under documented exclusions; exact line count from those files (never estimate LOC from file count); dependency count from actual manifests; TODO/FIXME/XXX count. Record measurement scope/tool. If required exact metrics cannot be computed, keep the previous valid baseline and record the blocker; never replace an unknown value with zero, null, or an estimate.

### 3. Publish Requested Downstream Contracts (on-demand)

Publish only when there is a real consumer need:

- **`engineering-to-pm.md`**: engineering evidence with cross-framework implications. Publish when ANY of the following occurs:
  - **Scope/AC/feasibility impact** (high threshold): engineering evidence materially affects scope, AC meaning, feasibility, or product decision.
  - **Contract drift from PRD** (high threshold): `contract.json.deviations[]` is non-empty — the user or agent made contract changes during engineering that diverge from the PRD-authorized contract (typically user manual adjustments during phase reviews). PM must know because the PRD's entity schema and API contract may need updating to match implemented reality. When this trigger fires, populate the `### Contract Deviations from PRD` section of `engineering-to-pm.md` directly from `contract.json.deviations[]`.
  - **TECH_STACK.md change** (medium threshold): `docs/engineering/TECH_STACK.md` modified (added/removed/upgrade of framework, runtime, or major dependency) — PM must know because PRD NFR constraints and Business Context Digest may reference the tech stack.
  - **Architecture decision change** (medium threshold): architecture pattern change (e.g., SSR→CSR, monolith→modular) that affects PRD assumptions or downstream design work.
  - **Multi-bugfix / refactor accumulation** (low threshold, periodic): when accumulated bugfix/refactor evidence has not been synced to PM for ≥ 1 release cycle, publish a lightweight engineering-to-pm summarizing changes so PM's knowledge-base stays current.

Feature completion alone does not automatically generate every handoff, but the four triggers above expand the scope beyond "materially affects scope/AC meaning/feasibility/product decision" to ensure PM does not lose visibility on tech-stack/architecture drift.

**Handoff content structure** (`engineering-to-pm.md` body, 7 sections):

1. **Phase Summary** — high-level outcome of this engineering cycle (what was built/changed, delivery state).
2. **Engineering Metrics & Issues** — exact baseline metrics delta, performance/quality signals, notable engineering issues.
3. **Issues & Adjustments** — blockers encountered, deviations from PM/Design contracts, rationale.
4. **Implementation Summary** — concrete implementation decisions, patterns adopted, files/modules of note.
5. **Product-Level Engineering Feedback** — engineering-driven suggestions for PM (scope, AC clarity, NFR feasibility, future iterations).
6. **4-Phase Completion Status** — for each of the 4 pipeline phases, report `completed` (bool) and `user_confirmed` (bool); unconfirmed phases must be flagged so PM knows the engineering cycle is not yet fully gated.
7. **Integration Results** — Phase 3 e2e validation results (pass/fail + coverage signal) and contract-consistency results (PM/Design AC traceability after implementation). Surface any contract drift detected during integration.

For each selected route:

1. fill its dedicated template from reviewed evidence;
2. preserve stable IDs and include only consumer-actionable fields;
3. set `mode: family` in the envelope (engineering always consumes upstream PM/Design contracts in the 2-framework architecture) and `producer: harness-engineering`;
4. **populate the `batch` field**: `batch.type: full` for first delivery to this consumer, `batch.type: incremental` for any subsequent delivery (bugfix/refactor/optimize/release re-handoff). `ac_ids` MUST always be the full set of valid AC/BAC/IAC IDs (added + modified new IDs + unchanged), never just the changed subset. Superseded IDs go to `batch.superseded_acs` and do NOT appear in `ac_ids`. Body AC/BAC/IAC tables use a `Change` column with `[added]`/`[unchanged]`/`[modified]`/`[superseded]` tags;
5. apply `.harness/rules/handoff-protocol.md` and acceptance-ID protocol;
6. create the self-contained package, run `validate-handoff.ps1`, archive prior current pointer, publish ready, and record receipt expectations;
7. record handoff ID, manifest hash, and supersedes ID in progress.md.

Never publish a draft as ready, reference producer-local files outside the package, or write the same handoff from a workflow and session-end.

## Exit Gate

- progress contains an exact resume point;
- FEATURES reflects canonical task states;
- baseline metrics are exact or explicitly unavailable;
- retention was delegated when thresholds were met;
- every published package validates and is recorded.

## Prohibited

- Marking a task done because verify passed but review did not.
- Estimating LOC from file count.
- Auto-generating handoffs for irrelevant local work.
- Duplicating memory-maintenance or handoff publication logic.

## Relationship with LOOP

- Phase: N/A (meta skill — runs at session boundary, not inside any phase's LOOP)
- Role: session-end is the **session closer**, not a LOOP ACT. It does not own an iteration or an attempt outcome. It runs after the LOOP for the active task has reached a terminal state (or the user ends the session early), publishes `engineering-to-pm.md` when trigger conditions are met, delegates memory rotation to `memory-maintenance`, and writes the resume point.
- Does NOT invoke `test-driven-development` or run `verify-fast`/`verify-full`.
