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
- memory/index.json (optional — if present, read to discover archived sessions)
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

1a. **Read the memory index** (if present)
   Read `.harness/memory/index.json` (if it exists) to discover archived sessions. If the user's task references prior work that may have been archived, use the index to locate relevant archive files in `memory/archives/` and read them on demand. Do not load all archive files — only those the index identifies as relevant to the current task.

2. **Read the knowledge base** (if relevant)
   Read `.harness/memory/knowledge-base.md` to find product decisions, user insights, and pitfalls related to the current task.

3. **Check in-progress tasks**
   Scan `.harness/loops/specs/*/state.yaml` to find tasks with status `running` or `retrying`.
   If found, report to the user: "Found in-progress task X (phase Y, iteration Z). Continue?"
   Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep").

4. **Read the feature board**
   Read `.harness/FEATURES.md` to understand overall product progress.
   - **Cross-framework reconciliation**: if an `engineering-to-pm.md` handoff has been consumed (receipt exists in `docs/handoff/receipts/`), cross-check engineering's reported "Implemented Features" status against PM's `FEATURES.md`. For each feature engineering reports as `done`, PM's status should be at least `developing`. If PM shows `approved` while engineering reports `done`, flag the drift to the user: "Feature F-XXX is done in engineering but still 'approved' in PM — advance to 'developing' or 'launched'?". See the family-level DOMAIN_BOUNDARIES.md (in the harness-all repo root; absent in standalone PM install) "FEATURES.md Cross-Framework Reconciliation" for the full status mapping.

5. **Check handoff documents** (from other harness family members)
   Scan `docs/handoff/` and apply `.harness/rules/handoff-protocol.md` before consuming any contract:
   - If `engineering-to-pm.md` exists (from harness-engineering), validate it, report its feedback items, and route accepted consumption to prd-orchestrator phase 0 Branch B (engineering feedback triage). Apply batch-aware detection (see step 5a below).
   - Engineering feedback may include: implemented features, technical constraints, open issues, integration results, BAC/IAC acceptance results.
   - If valid unconsumed handoffs exist, remind the user to prioritize them. Report invalid handoffs precisely and do not consume them partially.
   - After successful consumption of any inbound handoff, write `docs/handoff/receipts/<handoff_id>-receipt.json` with `consumer: harness-pm`, `consumed_at`, `manifest_sha256`, `status` (`accepted`/`rejected`), and `reasons`. Never edit the producer contract.

### 5a. Batch-aware Detection (for engineering-to-pm with batch field)

When a newly accepted `engineering-to-pm.md` supersedes a previously consumed handoff and contains a `batch` field, use batch-aware detection to identify change scope:

1. **First-consumption guard**: if no prior handoff of this type was consumed (check `memory/progress.md` for receipt records), treat ALL feedback items / ACs as new — regardless of `batch.type`. This prevents feedback loss when a previous handoff was produced but never consumed.

2. **Incremental batch** (`batch.type: incremental`): use the `batch` field as the primary signal:
   - `batch.added_acs` → new feedback scope (ACs newly referenced by this feedback delivery)
   - `batch.modified_acs` → feedback content changed (same AC ID; re-triage needed). Note: for reverse feedback channels (engineering-to-pm), modified_acs contains SAME AC IDs with changed feedback content — NOT new replacement IDs. See HANDOFF_PROTOCOL.md "Forward vs Reverse batch semantics".
   - `batch.superseded_acs` → feedback withdrawn or replaced (mark owning feedback items as superseded; do NOT re-triage already-decided items; these AC IDs do NOT appear in `ac_ids`)
   - `batch.unchanged_acs` → no action; previous decisions remain valid

3. **Full batch** (`batch.type: full`) or **no batch field** (legacy handoffs): fall back to set-diff detection on Affects AC lists.

4. **Body change-tag cross-check**: for ACs listed in `ac_ids`, read the body's `Change` column. If an AC is marked `[superseded]` in the body but still appears in `ac_ids`, flag as invalid.

Record the diff in two places (per the family-level ARCHITECTURE.md contract in the harness-all repo root and state.schema.json; absent in standalone PM install):

1. **state.yaml** (active task's `ac_change` field): write `ac_change: {removed: [AC-xxx,...], added: [AC-yyy,...], superseded: [AC-zzz,...], affected_tasks: [task-id,...]}` to the current task's state.yaml. This is the machine-readable source of truth consumed by downstream PM skills (prd-orchestrator phase 0 Branch A/B reads `ac_change` to scope triage; change-impact-analysis reads it to assess blast radius of added/superseded ACs). For reverse feedback channels (engineering-to-pm), `added` = newly referenced ACs, `superseded` = feedback withdrawn, `removed` = unused for reverse channels (use `superseded` instead).
2. **progress.md** (session block, one-line summary only): `Feedback Change: N added, M superseded, K affected_tasks (see state.yaml.ac_change)`. Do NOT duplicate the full AC ID lists in progress.md — downstream skills read state.yaml, not progress.md.

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
- Starting a new task without checking in-progress tasks (may duplicate work)
- Reading `memory/baseline.json` at session-start (baseline.json is verify's input/output pair; session-start does not need it — only verify reads it as input, and session-end may refresh it when source files change)

## Relationship with LOOP
This skill runs before LOOP, preparing context for the loop.
session-start → exploration/design/analysis → LOOP → ... → session-end
