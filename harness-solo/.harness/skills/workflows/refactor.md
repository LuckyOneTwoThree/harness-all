---
workflow_id: D
name: refactor
description: "Improve structure without observable behavior change, guarded by a green baseline and measurable structural target"
default_mode: standard
---
# Workflow: Refactor

## Route

1. session-start + Foundation gate.
2. Clarify the exact structural target and behavior boundary; use brainstorming only when ambiguous.
3. Establish a green safety baseline. If characterization is missing, writing-plans makes test-coverage the first non-production-code task; no mutation occurs before PLAN.
4. writing-plans → LOOP(test-coverage safety task if needed → test-driven-development structural attempts → verify-fast).
5. verify-full → code-review → session-end.

## Specialization

- Recommended failed-attempt limit: 3.
- No fabricated failing behavior test is required; the baseline must be green before mutation.
- Each attempt changes one structural dimension and shows the target improved without behavior regression.
- New behavior becomes a separate new-feature task.

## Exit

Behavior remains equivalent, the named structural target improves, and code-review marks done.
