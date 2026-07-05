---
name: session-start
description: Restores only the context needed for the requested work, validates inbound contracts, and records an explicit recovery point.
---
# Session Start

## When to use

- Standard/deep task or resumed task **with active state** (`loops/specs/*/state.yaml` nonterminal). If no active state exists and an upstream handoff is unambiguous, skip straight to Plan.
- Quick-fix uses its minimal context check unless active-task context may be affected.

## Inputs

- explicit user request
- `.harness/memory/progress.md`
- active `loops/specs/*/state.yaml`
- `docs/handoff/packages/` and current pointers
- conditional knowledge/task-board sources

## Output

- one new session block in progress.md
- concise restored-context report

## Process

### 1. Restore + Validate (merged)

Read progress.md and raw nonterminal state files; report last outcome, open/blocked tasks, current stage/iteration/breaker, and any conflict with the user request. Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep"). Load knowledge-base only when the task/progress references a durable decision or known pitfall; load FEATURES only when aggregate scope matters.

**Standalone mode detection** (short-circuit for single-framework users): check for `docs/handoff/packages/pm-to-solo-*` and `docs/handoff/packages/design-to-solo-*` current pointers, and for any prior receipt records in `docs/handoff/receipts/`. If all three are absent (no PM/Design pointer AND no prior receipt), the framework is in **standalone mode** — skip the entire handoff validation pipeline below and jump to "If the user request is explicit...". See `.harness/rules/handoff-protocol.md` "Standalone Mode" section for the rationale. Report "Standalone mode: no upstream handoff detected, skipping Consumer Gate" in the restored-context summary.

Discover `pm-to-solo.md` / `design-to-solo.md` current pointers and matching packages (only when not in standalone mode). Apply `.harness/rules/handoff-protocol.md` and run the installed validator before semantic use. Resolve PRD/design/token/component artifacts only inside a valid package and write `docs/handoff/receipts/<handoff_id>-receipt.json` with `consumer: harness-solo`, `consumed_at`, `manifest_sha256`, `status` (`accepted`/`rejected`), and `reasons`. Enforce family frontend routing: a ready Design package is required when PM marks design required, unless the PM contract carries a complete approved waiver (approver + reason + scope + review point, per PM's `design_waiver` field). A bare `design_status: waived` without the four-element `design_waiver` is invalid and must be rejected. Invalid packages are reported precisely and not partially consumed; the last valid delivery remains active.

**Cross-package AC traceability check** (when both `pm-to-solo.md` and `design-to-solo.md` are present): extract the AC-xxx IDs (excluding DAC-xxx) from the design-to-solo.md "Inherited AC-xxx" section and compare against the `ac_ids` in the pm-to-solo.md envelope. The design handoff's inherited AC-xxx list must be a superset of PM's AC-xxx (PM-owned ACs cannot be silently dropped during design). If an AC-xxx is missing from the design handoff and no corresponding entry is found in design-brief's `[AC Cleanup Log]` (located in `docs/visual/DESIGN_BRIEF.md`), flag the handoff as invalid with reason "AC-xxx silently dropped: <ID>" and reject consumption.

If the user request is explicit and does not conflict with active state, use it directly. Ask only when scope is materially ambiguous, conflicts with an active task/contract, or requires a user-owned decision.

### 1a. AC Change Impact Analysis (when supersedes an already-consumed handoff)

**Pre-condition check** (short-circuit when not applicable — avoids running 4-branch batch analysis on every session-start):

Skip this entire step (1a) when ANY of the following is true:
- **Standalone mode** (per step 1 detection above): no inbound handoff exists, so no AC change to analyze. `ac_change` field is NOT written to state.yaml.
- **First consumption** with `batch.type: full` or no `batch` field: all ACs are new by definition; route directly to Plan pipeline without writing `ac_change` (the ACs are simply the initial spec.md AC list, not a "change"). The first-consumption guard in branch 1 below still applies if you choose to run the analysis — but it's not required.
- **No `supersedes` field** in the envelope AND no prior receipt for this channel: nothing to compare against; no diff to compute.

Only when the pre-condition check fails to short-circuit (i.e., `supersedes` is present OR a prior receipt exists for this channel AND a new handoff is being consumed) does the full analysis below run.

When a newly accepted pm-to-solo.md or design-to-solo.md supersedes a previously consumed handoff, compare the new envelope `ac_ids` against the AC IDs already implemented in `loops/specs/*/spec.md` and recorded in `memory/progress.md`.

**Batch-aware detection** (when envelope contains a `batch` field):

1. **First-consumption guard**: if no prior handoff was consumed (check `memory/progress.md` for receipt records), treat ALL ACs in `ac_ids` as `[added]` — regardless of `batch.type`. This prevents AC loss when a previous handoff was produced but never consumed (the "unconsumed override" scenario).

2. **Incremental batch** (`batch.type: incremental`): use the `batch` field as the primary signal:
   - `batch.added_acs` → new scope. Route via the normal Plan pipeline (brainstorming/writing-plans).
   - `batch.modified_acs` → changed semantics. Per acceptance-id-protocol, modified ACs get new IDs (old ID superseded). Treat as added (new ID) + superseded (old ID).
   - `batch.superseded_acs` → old ACs replaced. Mark the owning task's corresponding AC as `[status: superseded]` in spec.md. If the owning task is `done`, do NOT reopen — create a `<original-task-id>-fix-<N>` task per STATE_PROTOCOL fix task exception.
   - `batch.unchanged_acs` → no action; existing evidence remains valid.

3. **Full batch** (`batch.type: full`) or **no batch field** (legacy handoffs): fall back to set-diff detection:
   - **Removed ACs** (in old set, not in new): identify the owning task. Flag for re-verification or rework.
   - **Added ACs** (in new set, not in old): new scope. Route via Plan pipeline.
   - **Unchanged ACs**: no action.

4. **Body change-tag cross-check**: for ACs listed in `ac_ids`, read the body's `Change` column. If an AC is marked `[superseded]` in the body but still appears in `ac_ids`, flag as invalid (superseded ACs must NOT appear in `ac_ids` — only their replacement does).

Record the diff in one authoritative place, plus a one-line summary in the session log:

1. **state.yaml** (active task's `ac_change` field, per state.schema.json): write `ac_change: {removed: [AC-xxx,...], added: [AC-yyy,...], superseded: [AC-zzz,...], affected_tasks: [task-id,...]}` to the current task's state.yaml. This is the machine-readable source of truth consumed by downstream skills (brainstorming/writing-plans read `ac_change` to scope rework; verify reads it to confirm all added ACs have evidence).
2. **progress.md** (session block, one-line summary only): `AC Change: N added, M superseded, K affected_tasks (see state.yaml.ac_change)`. Do NOT duplicate the full AC ID lists in progress.md — the summary plus pointer is enough for session-start narrative; downstream skills read state.yaml, not progress.md.

If removed or superseded ACs affect done tasks, surface this to the user before proceeding — per STATE_PROTOCOL.md fix task exception, done tasks are NOT re-opened; instead a `<original-task-id>-fix-<N>` task is created to address the withdrawn acceptance basis.

### 1b. Nested Task Switch (product-level resume only)

When resuming a product-level workflow with an active `current_nested_task` and the user request advances to the next nested task, apply the Nested Task Switch Protocol per `engineering-pipeline.md`: verify the outgoing nested task is `status: done`, verify worktree cleanliness (`git status --porcelain`), confirm the shared product branch strategy, then update `current_nested_task` and append the switch record to progress.md. Do not advance if the outgoing task is non-terminal or the worktree is dirty.

### 2. Write Recovery Point

Before production work, append:

```markdown
## Session: <timestamp>
### Goal
<explicit verifiable outcome>
### Context
- Active task/stage: <task or none>
- Handoffs consumed: <IDs or none>
- Constraints/blockers: <list or none>
```

If progress/knowledge files are absent on a first session, initialize only the missing framework-owned memory files from templates and report first-use status.

## Prohibited

- Starting standard/deep production without a recovery point.
- Re-asking an already answered scope question.
- Loading every memory file unconditionally.
- Reading `memory/baseline.json` at session-start (baseline.json is verify's input/output pair; session-start does not need it — only verify reads it as input, and session-end may refresh it when source files change).
- Auto-repairing corrupt state or consuming an invalid handoff.
