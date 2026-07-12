---
workflow_id: C
name: bugfix
description: "Repair a reproducible defect by locating root cause, adding a regression test, and following the canonical delivery gates"
default_mode: standard
---
# Workflow: Bugfix

Use for incorrect existing behavior. If the requested behavior is new rather than broken, route to new-feature.

> **Matrix**: workflow `C` — see `engineering-pipeline.md` Workflow × Phase × ACT Matrix. Defaults to one owning phase (Phase 1 frontend or Phase 2 backend); Phase 3 not invoked. If root cause crosses phase boundaries, upgrade to refactor workflow.

## Route

1. session-start (on-demand) + Foundation gate.
2. Branch Isolation: ensure a dedicated branch or git worktree before mutation (per `engineering-pipeline.md` Canonical Path step 3).
3. systematic-debugging until the symptom is reproducible and the root-cause hypothesis is evidence-backed.
4. **Contract change detection**: check whether the root-cause fix requires changing the API contract (path / method / request shape / response shape / status code / auth behavior). If yes, **upgrade to refactor workflow** — surface to the user: "The root-cause fix requires changing the API contract (<specific change>). This is a behavior change — upgrading to refactor workflow." Record the detection result in `memory/progress.md`. If no contract change, continue.
5. writing-plans with reproduction, affected surface, non-goals, and rollback.
6. **Single-phase LOOP** (Phase 1 if frontend bug, Phase 2 if backend): test-driven-development fixes the root cause (reproduce + fix + regression test) with inline verify-fast (regression test + affected suite required), consuming the reproduction test and root-cause analysis from systematic-debugging.
7. **Single-phase verify-full + code-review**: run within the same phase (not Phase 3). The phase's verify step writes evidence; code-review writes `review.md` and marks `status: done`. Phase 3 (integration) is not invoked — a single-phase defect repair needs no cross-phase integration.
8. session-end (on-demand baseline).

## Specialization

- A bugfix defaults to **one owning phase** (frontend → Phase 1, backend → Phase 2). If root cause is proven to cross phase boundaries (e.g., backend error code causing frontend rendering failure), upgrade to refactor workflow for multi-phase coordination. See `engineering-pipeline.md` "Cross-phase upgrade signals" for details.
- Recommended failed-attempt limit: 3.
- Do not patch before reproduction unless an active incident requires a separately approved containment action.
- Check sibling call sites only when the same proven root cause can affect them; do not expand into speculative cleanup.

## Exit

The regression fails before the fix, passes after it, no affected regression remains, and review marks done.
