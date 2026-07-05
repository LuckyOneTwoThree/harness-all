---
workflow_id: B
name: new-feature
description: "Deliver one feature through clarification, one canonical plan, TDD attempts, final verification, and review"
default_mode: standard
---
# Workflow: New Feature

Use for one independently deliverable behavior/module. Use new-product-engineering for a coordinated multi-feature product, and quick-fix only when its risk gate passes.

## Route

Follow `.harness/rules/engineering-pipeline.md`:

1. session-start (on-demand: skip if no active state + unambiguous handoff) + Foundation gate;
2. Branch Isolation: ensure a dedicated branch or git worktree before mutation (per `engineering-pipeline.md` Canonical Path step 3);
3. Plan: brainstorming (skip only when a validated upstream spec is already unambiguous) → writing-plans, executed as one continuous stage without pause between them unless a material user-owned decision surfaces;
4. LOOP: test-driven-development with inline verify-fast (ACT owns the 4 fast-verify duties); route unknown failures to systematic-debugging;
5. verify-full once after all planned outcomes pass;
6. code-review;
7. session-end (on-demand: baseline only when source files changed).

## Specialization

- Recommended failed-attempt limit: 5.
- ACT success: affected tests pass and current stable AC/BAC/IAC IDs have evidence.
- Frontend tasks require the validated design contract in family mode and engineering-owned component bindings.

## Exit

Review owns `status: done`; session-end syncs FEATURES. A pass from verify alone is not completion.
