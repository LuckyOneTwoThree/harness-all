---
workflow_id: F
name: migration
description: "Replace an API, dependency, framework, or data shape incrementally with rollback and zero-usage evidence"
default_mode: standard
---
# Workflow: Migration

## Route

1. session-start (on-demand) + Foundation gate.
2. Run migration's decision gate: justified replacement, complete consumer inventory, compatibility target, rollback, and sufficient safety tests.
3. writing-plans orders replacement first, consumers incrementally, zero-usage verification, then cleanup.
4. LOOP: migration as ACT owner with inline verify-fast (equivalence + affected tests) for one consumer/batch per attempt.
5. After all consumers move, prove zero active usage before removing old code/config/docs.
6. verify-full → code-review → session-end (on-demand baseline).

## Specialization

- Recommended failed-attempt limit: 3 per active migration task.
- Data migration requires backup/rollback and batch validation appropriate to risk.
- Absence of textual references alone is not zero traffic when runtime metrics are available.
- Cleanup is part of the approved migration, not an unrelated refactor.

## Exit

Replacement is live, behavior/contracts are preserved or intentionally versioned, old usage is zero, rollback is documented, and review marks done.
