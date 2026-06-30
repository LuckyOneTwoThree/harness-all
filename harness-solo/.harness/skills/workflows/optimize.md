---
workflow_id: E
name: optimize
description: "Improve a measured bottleneck while preserving behavior and installing a regression guard"
default_mode: standard
---
# Workflow: Optimize

## Route

1. session-start + Foundation gate.
2. performance-optimization measures a representative baseline, confirms target, and identifies one proven bottleneck.
3. writing-plans records metric, environment, target, behavioral guard, and rollback.
4. LOOP uses performance-optimization as ACT owner; verify-fast repeats the same benchmark method plus affected tests.
5. verify-full → code-review → session-end.

## Specialization

- Recommended failed-attempt limit: 3.
- One performance variable per attempt; changed benchmark method invalidates comparison.
- No improvement routes back to identification, not random additional tuning.
- A passing optimization adds a repeatable benchmark/regression guard when practical.

## Exit

Target improves under the same conditions, behavior remains correct, and review marks done.
