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
- `.harness/memory/index.json` (optional — if present, read to discover archived sessions)
- active `loops/specs/*/state.yaml`
- `docs/handoff/packages/` and current pointers
- conditional knowledge/task-board sources

## Output

- one new session block in progress.md
- concise restored-context report

## Process

### 1. Restore + Validate (merged)

Read progress.md and raw nonterminal state files; report last outcome, open/blocked tasks, current stage/iteration/breaker, and any conflict with the user request. Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep"). If `memory/index.json` exists, read it to discover archived sessions; use the index to locate relevant archive files in `memory/archives/` on demand when the user's task references prior work that may have been archived. Load knowledge-base only when the task/progress references a durable decision or known pitfall; load FEATURES only when aggregate scope matters.

Discover `pm-to-engineering.md` current pointers and matching packages. Apply `.harness/rules/handoff-protocol.md` and run the installed validator before semantic use. Resolve PRD/contract/token artifacts only inside a valid package and write `docs/handoff/receipts/<handoff_id>-receipt.json` with `consumer: harness-engineering`, `consumed_at`, `manifest_sha256`, `status` (`accepted`/`rejected`), and `reasons`. Invalid packages are reported precisely and not partially consumed; the last valid delivery remains active.

**AC traceability check**: extract the AC-xxx IDs from `pm-to-engineering.md` and confirm they match the `ac_ids` in the envelope. Superseded ACs (marked `[superseded]` in the body) must NOT appear in `ac_ids` — only their replacement does. Flag mismatches as invalid with reason "AC-xxx silently dropped: <ID>" or "superseded AC still in ac_ids: <ID>" and reject consumption.

If the user request is explicit and does not conflict with active state, use it directly. Ask only when scope is materially ambiguous, conflicts with an active task/contract, or requires a user-owned decision.

### 1a. AC Change Impact Analysis (when supersedes an already-consumed handoff)

**Pre-condition check** (short-circuit when not applicable — avoids running 4-branch batch analysis on every session-start):

Skip this entire step (1a) when ANY of the following is true:
- **First consumption** with `batch.type: full` or no `batch` field: all ACs are new by definition; route directly to Plan pipeline without writing `ac_change` (the ACs are simply the initial spec.md AC list, not a "change"). The first-consumption guard in branch 1 below still applies if you choose to run the analysis — but it's not required.
- **No `supersedes` field** in the envelope AND no prior receipt for this channel: nothing to compare against; no diff to compute.

Only when the pre-condition check fails to short-circuit (i.e., `supersedes` is present OR a prior receipt exists for this channel AND a new handoff is being consumed) does the full analysis below run.

When a newly accepted pm-to-engineering.md supersedes a previously consumed handoff, compare the new envelope `ac_ids` against the AC IDs already implemented in `loops/specs/*/spec.md` and recorded in `memory/progress.md`.

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

**Self-check** (after writing `ac_change` to state.yaml):
- [ ] `ac_change` field is present in `state.yaml` (not null/absent when a supersede occurred).
- [ ] Superseded AC IDs do NOT appear in the current `ac_ids` list.
- [ ] `affected_tasks` lists every task ID owning a removed/superseded AC.
- [ ] If any affected task is `done`, a fix task creation is surfaced to the user (not silently skipped).

### 1b. Nested Task Switch (product-level resume only)

When resuming a product-level workflow with an active `current_nested_task` and the user request advances to the next nested task, apply the Nested Task Switch Protocol per `engineering-pipeline.md`: verify the outgoing nested task is `status: done`, verify worktree cleanliness (`git status --porcelain`), confirm the shared product branch strategy, then update `current_nested_task` and append the switch record to progress.md. Do not advance if the outgoing task is non-terminal or the worktree is dirty.

### 1c. Substage Recovery

The engineering pipeline divides work into 4 phases, each split into substages with explicit user-confirmation gates. On resume, read the active task's `state.yaml` for `substage` and `substage_progress`:

1. Locate the current `substage` identifier and its entry in `substage_progress` (an object keyed by phase name — `design-intake` / `frontend` / `backend` / `integration`; each value is `{completed, user_confirmed, report, verify_state}`).
2. Read `user_confirmed` for the current substage:
   - `user_confirmed: false` → the substage's work is complete but awaiting user confirmation. Prompt the user to confirm the previous phase's output before advancing. Do NOT enter the next substage.
   - `user_confirmed: true` → the substage is fully confirmed. Advance to the next substage per `engineering-pipeline.md`.
3. If `substage` is absent (first session or pre-pipeline task), skip substage recovery — the pipeline initializes it on first stage entry.
4. Record the resumed substage in the session block: `Substage: <id> (completed=<bool>, user_confirmed=<bool>)`.

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

## Relationship with LOOP

- Phase: N/A (meta skill — runs at session boundary, not inside any phase's LOOP)
- Role: session-start is the **session opener**, not a LOOP ACT. It does not own an iteration or an attempt outcome. It reads `state.yaml` to recover substage position, validates inbound PM handoff, writes `ac_change`, and hands off to the active phase's ACT (or to `writing-plans` for a new task).
- Does NOT invoke `test-driven-development` or run `verify-fast`/`verify-full`.
