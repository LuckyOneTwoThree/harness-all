---
workflow_id: I
name: quick-fix
description: "Fast path for one unambiguous low-risk outcome with scoped evidence and no LOOP state"
default_mode: skip
---
# Workflow: Quick Fix

Line count and elapsed time are signals, not gates.

## Risk Gate (Admission)

All must be true:

- one unambiguous outcome and a small reviewable diff;
- R0/R1 under `.harness/rules/risk-model.md`;
- no schema/migration, dependency, public API/contract, auth/security boundary, deployment, data-loss, or family frontend component-contract impact;
- verification command/path is known;
- no unresolved context or active task conflict.

Otherwise route to bugfix, new-feature, refactor, optimize, or migration.

## Route

1. Read the directly relevant file/context and current diff; full session restoration is optional only when no active-task context is implicated.
2. Record admission reason and verification plan.
3. Behavior/bug change: write and run a failing regression test first. Pure text/comment/format change may skip a new test.
4. Make the smallest edit.
5. Run the relevant test/check and changed-file security scan; show actual output and hit dispositions.
6. Review the final diff for scope. Commit only when requested.
7. Append one progress line with mode, reason, files, and verification result.

## Upgrade Triggers

Immediately stop and route to a standard workflow if the diff expands, a test path is unavailable, the reproduction does not fail, risk changes, or implementation requires a second independent outcome.

## Exit

No state/spec/review artifact is required, but actual verification and a scoped progress record are mandatory.
