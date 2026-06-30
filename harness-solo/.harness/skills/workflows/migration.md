---
workflow_id: F
name: migration
description: "Replace an API, dependency, framework, or data shape incrementally with rollback and zero-usage evidence"
default_mode: standard
---
# Workflow: Migration

## Route

1. session-start + Foundation gate.
2. Run migration's decision gate: justified replacement, complete consumer inventory, compatibility target, rollback, and sufficient safety tests.
3. writing-plans orders replacement first, consumers incrementally, zero-usage verification, then cleanup.
4. LOOP uses migration as ACT owner for one consumer/batch per attempt; verify-fast checks equivalence and affected tests.
5. After all consumers move, prove zero active usage before removing old code/config/docs.
6. verify-full → code-review → session-end.

## Specialization

- Recommended failed-attempt limit: 3 per active migration task.
- Data migration requires backup/rollback and batch validation appropriate to risk.
- Absence of textual references alone is not zero traffic when runtime metrics are available.
- Cleanup is part of the approved migration, not an unrelated refactor.

## Exit

Replacement is live, behavior/contracts are preserved or intentionally versioned, old usage is zero, rollback is documented, and review marks done.
