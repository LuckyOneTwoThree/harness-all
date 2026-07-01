---
workflow_id: C
name: bugfix
description: "Repair a reproducible defect by locating root cause, adding a regression test, and following the canonical delivery gates"
default_mode: standard
---
# Workflow: Bugfix

Use for incorrect existing behavior. If the requested behavior is new rather than broken, route to new-feature.

## Route

1. session-start (on-demand) + Foundation gate.
2. Branch Isolation: ensure a dedicated branch or git worktree before mutation (per `engineering-pipeline.md` Canonical Path step 3).
3. systematic-debugging until the symptom is reproducible and the root-cause hypothesis is evidence-backed.
4. writing-plans with reproduction, affected surface, non-goals, and rollback.
5. LOOP: test-driven-development fixes the root cause (reproduce + fix + regression test) with inline verify-fast (regression test + affected suite required), consuming the reproduction test and root-cause analysis from systematic-debugging.
6. verify-full, code-review, session-end (on-demand baseline).

## Specialization

- Recommended failed-attempt limit: 3.
- Do not patch before reproduction unless an active incident requires a separately approved containment action.
- Check sibling call sites only when the same proven root cause can affect them; do not expand into speculative cleanup.

## Exit

The regression fails before the fix, passes after it, no affected regression remains, and review marks done.
