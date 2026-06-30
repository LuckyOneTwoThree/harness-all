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

1. session-start + Foundation gate;
2. brainstorming (skip only when a validated upstream spec is already unambiguous);
3. writing-plans;
4. LOOP with test-driven-development → verify-fast; route unknown failures to systematic-debugging;
5. verify-full once after all planned outcomes pass;
6. code-review;
7. session-end.

## Specialization

- Recommended failed-attempt limit: 5.
- ACT success: affected tests pass and current stable AC/DAC IDs have evidence.
- Frontend tasks require the validated Design contract in family mode and Solo-owned component bindings.

## Exit

Review owns `status: done`; session-end syncs FEATURES. A pass from verify alone is not completion.
