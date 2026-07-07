---
workflow_id: D
name: refactor
description: "Improve structure without observable behavior change, guarded by a green baseline and measurable structural target"
default_mode: standard
---
# Workflow: Refactor

> **Matrix**: workflow `D` — see `engineering-pipeline.md` Workflow × Phase × ACT Matrix. Activates Phases 1-3 (full multi-phase: frontend TDD → backend TDD → integration mock→real → contract-verify → e2e → verify).

## Route

1. session-start (on-demand) + Foundation gate.
2. Branch Isolation: ensure a dedicated branch or git worktree before mutation (per `engineering-pipeline.md` Canonical Path step 3).
3. Plan: clarify the structural target and behavior boundary (brainstorming only when ambiguous) → writing-plans (makes test-coverage the first non-production-code task if characterization is missing).
4. LOOP: test-coverage safety task if needed → test-driven-development structural attempts with inline verify-fast; per `engineering-pipeline.md` Matrix, Phase 3 invokes mock-to-real-switch → contract-verify → e2e-verification when the refactor spans integration concerns.
5. verify-full → code-review → session-end (on-demand baseline).

## Specialization

- Recommended failed-attempt limit: 3.
- No fabricated failing behavior test is required; the baseline must be green before mutation.
- Each attempt changes one structural dimension and shows the target improved without behavior regression.
- New behavior becomes a separate new-feature task.

## Exit

Behavior remains equivalent, the named structural target improves, and code-review marks done.
