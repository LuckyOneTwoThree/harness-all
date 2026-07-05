---
name: session-start
description: Session start, load context to restore working state
---
# Session Start — Session Start

## When to use
- When the Agent receives a new task
- When resuming work across sessions

## Inputs
- SOUL.md
- constitution.md
- memory/progress.md
- memory/knowledge-base.md
- FEATURES.md
- loops/specs/*/state.yaml
- docs/handoff/

## Outputs
- memory/progress.md

## Core Rules
Context must be loaded before the session begins; working with "amnesia" is not allowed.

## Process

1. **Read the progress log**
   Read `.harness/memory/progress.md` to understand where the last session left off and what is pending.

2. **Read the knowledge base** (if relevant)
   Read `.harness/memory/knowledge-base.md` to find design decisions and pitfalls related to the current task.

3. **Check in-progress tasks**
   Scan `.harness/loops/specs/*/state.yaml` to find tasks with status `running` or `retrying`.
   If found, report to the user: "Found in-progress design task X. Continue?"
   Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep").

4. **Read the task board**
   Read `.harness/FEATURES.md` to understand overall project design progress.

5. **Check handoff documents** (from other harness family members)
   Scan `docs/handoff/` and validate inbound packages with `.harness/rules/handoff-protocol.md` before consumption:
   - If `pm-to-design.md` exists, report to the user: "Found handoff document (from harness-pm). Consume it in this session?"
   - Handoff documents may include PRD paths, key decisions, and open items; they are important input for design-brief
   - Resolve PRD and research artifacts from inside the package; producer-local `docs/...` paths outside it are invalid
   - Report valid unconsumed handoffs. Report exact validation failures and do not consume a package partially.
   - After successful consumption of `pm-to-design.md`, write `docs/handoff/receipts/<handoff_id>-receipt.json` with `consumer: harness-design`, `consumed_at`, `manifest_sha256`, `status` (`accepted`/`rejected`), and `reasons`. Never edit the producer contract.

### 5a. AC Change Impact Analysis (when supersedes an already-consumed handoff)

When a newly accepted pm-to-design.md supersedes a previously consumed handoff, compare the new envelope `ac_ids` against the AC IDs already implemented in `loops/specs/*/spec.md` and recorded in `memory/progress.md`.

**Batch-aware detection** (when envelope contains a `batch` field):

1. **First-consumption guard**: if no prior handoff was consumed (check `memory/progress.md` for receipt records), treat ALL ACs in `ac_ids` as `[added]` — regardless of `batch.type`. This prevents AC loss when a previous handoff was produced but never consumed (the "unconsumed override" scenario).

2. **Incremental batch** (`batch.type: incremental`): use the `batch` field as the primary signal:
   - `batch.added_acs` → new design scope. Route via design-brief → new-design or design-iteration workflow.
   - `batch.modified_acs` → changed semantics. Per acceptance-id-protocol, modified ACs get new IDs (old ID superseded). Treat as added (new ID) + superseded (old ID).
   - `batch.superseded_acs` → old ACs replaced. Mark the owning task's corresponding AC as `[status: superseded]` in spec.md. If the owning task is `done`, do NOT reopen — create a `<original-task-id>-fix-<N>` task per STATE_PROTOCOL fix task exception.
   - `batch.unchanged_acs` → no action; existing evidence remains valid.

3. **Full batch** (`batch.type: full`) or **no batch field** (legacy handoffs): fall back to set-diff detection:
   - **Removed ACs** (in old set, not in new): identify the design task owning each removed AC. Flag the corresponding task for re-verification or rework since its acceptance basis may have been withdrawn.
   - **Added ACs** (in new set, not in old): new design scope. Route via design-brief → new-design or design-iteration workflow.
   - **Unchanged ACs**: no action.

4. **Body change-tag cross-check**: for ACs listed in `ac_ids`, read the body's `Change` column. If an AC is marked `[superseded]` in the body but still appears in `ac_ids`, flag as invalid (superseded ACs must NOT appear in `ac_ids` — only their replacement does).

Record the diff in two places:

1. **progress.md** (session block): `AC Change: removed=[...], added=[...], superseded=[...], affected_tasks=[...]`
2. **state.yaml** (active task's `ac_change` field, per state.schema.json): write `ac_change: {removed: [AC-xxx,...], added: [AC-yyy,...], superseded: [AC-zzz,...], affected_tasks: [task-id,...]}` to the current task's state.yaml. This is the machine-readable source of truth consumed by downstream skills (design-brief reads `ac_change` to scope rework; verify reads it to confirm all added ACs have evidence).

If removed or superseded ACs affect done tasks, surface this to the user before proceeding — per STATE_PROTOCOL.md, `done` is terminal and further work creates a new task (e.g., `<original-task-id>-fix-<N>`) to address the withdrawn acceptance basis, rather than re-opening the original.

6. **Confirm task scope**
   Confirm with the user what this session will accomplish, and write a new session block to progress.md:
   ```
   ## Session: YYYY-MM-DD HH:MM
   ### Task
   [Session goal]
   ```

## Prohibited
- Starting work without reading progress.md (context will be lost)
- Starting work without confirming task scope (may drift off course)
- Reading `memory/baseline.json` at session-start (baseline.json is verify's input/output pair; session-start does not need it — only verify reads it as input, and session-end may refresh it when source files change)

## Relationship with LOOP
This skill runs before LOOP, preparing context for the loop.
session-start → design-brief → new-design/iteration/redesign workflow (with LOOP) → ... → session-end
