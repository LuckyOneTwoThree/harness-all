---
name: session-start
description: Restores only the context needed for the requested work, validates inbound contracts, and records an explicit recovery point.
---
# Session Start

## When to use

- Every standard/deep task or resumed task.
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

### 1. Restore Canonical State

Read progress.md and raw nonterminal state files. Report last outcome, open/blocked tasks, current stage/iteration/breaker, and any conflict between the user request and an active task.

Load knowledge-base only when the task/progress references a durable decision or known pitfall. Load FEATURES when aggregate scope/dependencies/status matter. Do not read both by ritual.

### 2. Validate Inbound Contracts

Discover `pm-to-solo.md` / `design-to-solo.md` current pointers and matching packages. Apply `.harness/rules/handoff-protocol.md` and run the installed validator before semantic use. Resolve PRD/design/token/component artifacts only inside a valid package and write acceptance/rejection receipts.

Enforce family frontend routing: a ready Design package is required when PM marks design required, unless the PM contract carries a complete approved waiver.

Invalid packages are reported precisely and not partially consumed; the last valid delivery remains active.

### 3. Resolve Scope Without Redundant Questions

- If the user request is explicit and does not conflict with active state, use it directly.
- Ask only when scope is materially ambiguous, conflicts with an active task/contract, or requires a user-owned decision.
- Do not ask “what should we work on?” after the user already stated it.

### 4. Write Recovery Point

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
