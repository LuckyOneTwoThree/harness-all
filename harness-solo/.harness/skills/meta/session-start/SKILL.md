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

Read progress.md and raw nonterminal state files; report last outcome, open/blocked tasks, current stage/iteration/breaker, and any conflict with the user request. Load knowledge-base only when the task/progress references a durable decision or known pitfall; load FEATURES only when aggregate scope matters.

Discover `pm-to-solo.md` / `design-to-solo.md` current pointers and matching packages. Apply `.harness/rules/handoff-protocol.md` and run the installed validator before semantic use. Resolve PRD/design/token/component artifacts only inside a valid package and write `docs/handoff/receipts/<handoff_id>-receipt.json` with `consumer: harness-solo`, `consumed_at`, `manifest_sha256`, `status` (`accepted`/`rejected`), and `reasons`. Enforce family frontend routing: a ready Design package is required when PM marks design required, unless the PM contract carries a complete approved waiver (approver + reason + scope + review point, per PM's `design_waiver` field). A bare `design_status: waived` without the four-element `design_waiver` is invalid and must be rejected. Invalid packages are reported precisely and not partially consumed; the last valid delivery remains active.

**Cross-package AC traceability check** (when both `pm-to-solo.md` and `design-to-solo.md` are present): extract the AC-xxx IDs (excluding DAC-xxx) from the design-to-solo.md "Inherited AC-xxx" section and compare against the `ac_ids` in the pm-to-solo.md envelope. The design handoff's inherited AC-xxx list must be a superset of PM's AC-xxx (PM-owned ACs cannot be silently dropped during design). If an AC-xxx is missing from the design handoff and no corresponding entry is found in design-brief's `[AC Cleanup Log]` (located in `docs/visual/DESIGN_BRIEF.md`), flag the handoff as invalid with reason "AC-xxx silently dropped: <ID>" and reject consumption.

If the user request is explicit and does not conflict with active state, use it directly. Ask only when scope is materially ambiguous, conflicts with an active task/contract, or requires a user-owned decision.

### 1a. AC Change Impact Analysis (when supersedes an already-consumed handoff)

When a newly accepted pm-to-solo.md or design-to-solo.md supersedes a previously consumed handoff, compare the new envelope `ac_ids` against the AC IDs already implemented in `loops/specs/*/spec.md` and recorded in `memory/progress.md`:

- **Removed ACs** (in old set, not in new): identify the feature/task owning each removed AC. Flag the corresponding task for re-verification or rework since its acceptance basis may have been withdrawn.
- **Added ACs** (in new set, not in old): new scope. Route via the normal Plan pipeline (brainstorming/writing-plans).
- **Unchanged ACs**: no action; existing evidence remains valid unless the AC text changed (per acceptance-id-protocol, changed meaning gets a new ID, so same ID = same semantics).

Record the diff in two places:

1. **progress.md** (session block): `AC Change: removed=[...], added=[...], affected_tasks=[...]`
2. **state.yaml** (active task's `ac_change` field, per state.schema.json): write `ac_change: {removed: [AC-xxx,...], added: [AC-yyy,...], affected_tasks: [task-id,...]}` to the current task's state.yaml. This is the machine-readable source of truth consumed by downstream skills (brainstorming/writing-plans read `ac_change` to scope rework; verify reads it to confirm all added ACs have evidence).

If removed ACs affect done tasks, surface this to the user before proceeding — per STATE_PROTOCOL.md fix task exception, done tasks are NOT re-opened; instead a `<original-task-id>-fix-<N>` task is created to address the withdrawn acceptance basis.

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

## Prohibitions

- Starting standard/deep production without a recovery point.
- Re-asking an already answered scope question.
- Loading every memory file unconditionally.
- Auto-repairing corrupt state or consuming an invalid handoff.
