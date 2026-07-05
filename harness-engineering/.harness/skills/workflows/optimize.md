---
workflow_id: E
name: optimize
description: "Improve a measured bottleneck while preserving behavior and installing a regression guard"
default_mode: standard
---
# Workflow: Optimize

## Route

1. session-start (on-demand) + Foundation gate.
2. Branch Isolation: ensure a dedicated branch or git worktree before mutation (per `engineering-pipeline.md` Canonical Path step 3).
3. performance-optimization measures a representative baseline, confirms target, and identifies one proven bottleneck.
4. writing-plans records metric, environment, target, behavioral guard, and rollback.
5. **Single-phase LOOP** (Phase 1 if frontend optimization, Phase 2 if backend): performance-optimization as ACT owner with inline verify-fast (same benchmark method + affected tests).
6. **Single-phase verify-full + code-review**: run within the same phase (not Phase 3). The phase's verify step writes evidence; code-review writes `review.md` and marks `status: done`. Phase 3 (integration) is not invoked — a single-phase optimization needs no cross-phase integration.
7. session-end (on-demand baseline).

## Specialization

- Optimize touches **exactly one phase** (frontend → Phase 1, backend → Phase 2); never spans multiple phases.
- The ACT owner is `performance-optimization` (specialist ACT), not the default ACT sequence.
- Recommended failed-attempt limit: 3.
- One performance variable per attempt; changed benchmark method invalidates comparison.
- No improvement routes back to identification, not random additional tuning.
- A passing optimization adds a repeatable benchmark/regression guard when practical.

## Exit

Target improves under the same conditions, behavior remains correct, and review marks done.
