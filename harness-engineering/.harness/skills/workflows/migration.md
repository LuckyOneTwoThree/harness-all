---
workflow_id: F
name: migration
description: "Replace an API, dependency, framework, or data shape incrementally with rollback and zero-usage evidence"
default_mode: standard
---
# Workflow: Migration

> **Matrix**: workflow `F` — see `engineering-pipeline.md` Workflow × Phase × ACT Matrix. Activates exactly one phase — Phase 1 (frontend scope) or Phase 2 (backend scope) — with `migration` as specialist ACT; Phase 3 not invoked.

## Route

1. session-start (on-demand) + Foundation gate.
2. Branch Isolation: ensure a dedicated branch or git worktree before mutation (per `engineering-pipeline.md` Canonical Path step 3).
3. Run migration's decision gate: justified replacement, complete consumer inventory, compatibility target, rollback, and sufficient safety tests.
4. writing-plans orders replacement first, consumers incrementally, zero-usage verification, then cleanup.
5. **Single-phase LOOP** (Phase 1 frontend or Phase 2 backend): migration as ACT owner with inline verify-fast (equivalence + affected tests) for one consumer/batch per attempt.
6. After all consumers move, prove zero active usage before removing old code/config/docs.
7. **Single-phase verify-full + code-review**: run within the single active phase (Phase 1 or Phase 2, not Phase 3). The phase's verify step writes evidence; code-review writes `review.md` and marks `status: done`. Phase 3 (integration) is not invoked — a single-phase migration needs no cross-phase integration.
8. session-end (on-demand baseline).

## Specialization

- Migration touches **exactly one phase** — Phase 1 (frontend scope: component/framework migration) or Phase 2 (backend scope: schema/API/data migration); never spans multiple phases.
- The ACT owner is `migration` (specialist ACT), not the default ACT sequence.
- Recommended failed-attempt limit: 3 per active migration task.
- Data migration requires backup/rollback and batch validation appropriate to risk.
- Absence of textual references alone is not zero traffic when runtime metrics are available.
- Cleanup is part of the approved migration, not an unrelated refactor.

## Exit

Replacement is live, behavior/contracts are preserved or intentionally versioned, old usage is zero, rollback is documented, and review marks done.
