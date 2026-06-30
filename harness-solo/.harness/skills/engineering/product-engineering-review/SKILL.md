---
name: product-engineering-review
description: Runs one cross-feature consistency and integration gate after required nested tasks are reviewed.
---
# Product Engineering Review

## When to use

- New-product-engineering has multiple completed nested tasks.
- Before product-level downstream handoff/release readiness.

Do not use for a single feature and do not repeat per-feature acceptance, security, style, or review checks.

## Inputs

- approved `ENGINEERING_PLAN.md`
- `.harness/FEATURES.md` and each required nested task's evidence/review
- combined source, dependency manifests, migrations/config
- semantic component contract + Solo binding when frontend is present

## Output

- `loops/specs/<product-task>/product-review-evidence.md`
- product-level `state.yaml` conclusion

## Entry Gate

- Every required nested task is `done` and has current verify/review evidence.
- Skipped tasks have explicit user approval, dependency impact, and downstream limitation.
- ENGINEERING_PLAN dependency graph and integration checkpoints are current.

Failure here returns to orchestration; do not disguise incomplete feature work as an integration finding.

## Checks

### 1. Contracts + Dependency (merged)

**Cross-feature contracts** — inspect only boundaries actually used across features: exported API input/output/error semantics match callers; shared data entity names/types/lifecycle align with migrations; config/environment/feature-flag names have one meaning; semantic component IDs join to one current binding and preserve shared states/properties; global/scoped DAC evidence is not contradictory across pages/features.

**Dependency and shared infrastructure** — one resolved version/major for shared dependencies with no peer/lock conflict; features import approved shared modules instead of reimplementing them; dependency direction follows the approved DAG; no new cycle. Use targeted searches and manifest/tool output. Do not claim semantic duplication solely from similar function names.

### 2. Checkpoints + Skipped-Work (merged)

Run each checkpoint defined in ENGINEERING_PLAN with actual command/flow output. The final checkpoint includes: clean build/start where applicable; full combined test suite; critical cross-feature user/data flow; migration/config startup compatibility; frontend build and shared navigation/design contract when applicable. This is integration evidence, not a second per-feature verify-full.

For each approved skip, state broken/unverified flows, blocked dependents, handoff limitation, owner, and required-before milestone. A dependent task cannot be considered integrated without an approved substitute.

## Findings

| Severity | Meaning | Route |
|---|---|---|
| Critical | runtime/integration/data-loss/deployment blocker | owning nested task LOOP, then rerun affected checkpoints |
| Major | contract/dependency/shared-module inconsistency | owning task, reverify, rerun affected checks |
| Minor | non-blocking integration debt | record owner/review point |

Findings cite producer/consumer, location, evidence, expected contract, and owning nested task. No arbitrary minimum count.

## Evidence Shape

```markdown
# Product Engineering Review

## Entry Gate
## Cross-Feature Contracts
## Dependency and Shared Infrastructure
## Integration Checkpoints
## Skipped-Work Impact
## Findings
## Conclusion
- reviewed_revision: <revision/hash>
- [ ] pass / [ ] fail
```

## Exit

Pass requires the current combined revision, all checkpoints passing, and no unresolved Critical/Major. This skill is the sole owner of the product-orchestrator conclusion: on pass it writes `stage: review`, `status: done`; on failure it writes `stage: review`, `status: retrying`, `needs-human`, or `blocked` according to the observed cause. Session-end then synchronizes the board and may publish requested product handoffs.

## Relationship with LOOP

Out-of-LOOP product gate; never increments product or nested iteration. A finding routes to the owning nested task; only affected checkpoints plus the final combined checkpoint rerun afterward. See `.harness/loops/LOOP.md`.
