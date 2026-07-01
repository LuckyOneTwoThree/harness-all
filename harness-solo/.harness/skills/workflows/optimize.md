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
5. LOOP: performance-optimization as ACT owner with inline verify-fast (same benchmark method + affected tests).
6. verify-full → code-review → session-end (on-demand baseline).

## Specialization

- Recommended failed-attempt limit: 3.
- One performance variable per attempt; changed benchmark method invalidates comparison.
- No improvement routes back to identification, not random additional tuning.
- A passing optimization adds a repeatable benchmark/regression guard when practical.

## Exit

Target improves under the same conditions, behavior remains correct, and review marks done.
