# Handoff: harness-solo → harness-ops

> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-solo
> Target framework: harness-ops

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 core feature development and merged to main branch, ready for release>

## Deliverable Version

| Field | Value | Notes |
|------|-----|------|
| Image tag | <registry/image:tag> | If deploying with Docker image |
| Commit hash | <git-sha> | Commit hash of the main branch merge point |
| Branch | <main / master> | Name of the main branch merged into |
| Code repository | <repo URL> | |
| Current version | <v1.0.0> | SemVer-compliant version number |

> Required: provide at least one of image tag or commit hash; providing both is recommended for ops verification.

## Environment Variables List

> Configuration items to add/remove/modify for this deployment. List only the items changed this time; do not repeat unchanged existing items.

| Variable name | Operation | Value / Example | Sensitive? | Notes |
|--------|------|----------|---------|------|
| <NEW_KEY_1> | Add | <value or placeholder> | Yes/No | <purpose description> |
| <CHANGED_KEY_1> | Modify | <value or placeholder> | Yes/No | <change reason> |
| <REMOVED_KEY_1> | Remove | — | — | <removal reason> |

> For sensitive variables (e.g., keys, tokens), do not fill in plaintext here. Only mark "Sensitive: Yes" and note in the remarks which Secret Manager to fetch them from.

## Database Scripts

> Whether migrations are included and their execution order.

- Includes migrations: Yes / No
- Migration tool: <Flyway / Prisma Migrate / knex / hand-written SQL / ...>

| Execution order | Script path | Type | Notes |
|---------|---------|------|------|
| 1 | <db/migrations/V001__add_xxx.sql> | Pre | <schema change description> |
| 2 | <db/migrations/V002__seed_xxx.sql> | Data | <seed data description> |
| 3 | <db/migrations/V003__cleanup_xxx.sql> | Post | <post-deployment cleanup> |

**Execution timing**:
- Pre-scripts: execute before application deployment
- Post-scripts: execute after application deployment

**Rollback scripts**:
- <db/rollback/V001__revert.sql> (if no corresponding rollback script exists, explain the alternative)

## Smoke Tests

> Checkpoints to verify deployment success. After deployment completes, all must pass before declaring the release successful.

| # | Check item | Verification method | Expected result | Related feature |
|------|--------|---------|---------|---------|
| 1 | Health check | `GET /health` | 200 OK, returns `{"status":"ok"}` | Basic availability |
| 2 | Key API reachable | `GET /api/xxx` | 200 OK, response body matches schema | <feature 1> |
| 3 | Database connection | Execute a read-only query | Returns expected data | Data layer |
| 4 | Key page load | Visit `/` | 200 OK, no 5xx | Frontend |
| 5 | Tracking event reporting | Trigger a key event | Network request 200, event recorded | Growth pipeline |

> Smoke tests do not replace full regression testing; they only verify "the deployment itself didn't break the service".

## Rollback Plan

> Degradation or code rollback measures in case of errors.

### Rollback Triggers

- Any smoke test failure that cannot be fixed within 5 minutes
- Error rate > 5% sustained for 10 minutes
- A P0-level production incident occurs

### Rollback Steps

| Step | Operation | Command / Path | Estimated time |
|------|------|------------|---------|
| 1 | Revert to previous image version | `kubectl set image deployment/xxx container=registry/image:<prev-tag>` | <2min> |
| 2 | Roll back database | Execute `<db/rollback/V003__revert.sql>` | <5min> |
| 3 | Roll back environment variables | Restore config center to previous version snapshot | <2min> |
| 4 | Verify rollback | Re-run smoke tests | <5min> |

### Degradation Plan (if full rollback is not possible)

- <Feature flag off / rate-limit degradation / static fallback page, etc.>

## Known Risks

| Risk | Level | Impact scope | Mitigation |
|------|------|---------|---------|
| <Migration is irreversible> | High/Medium/Low | <scope> | <action> |
| <Depends on external service changes> | High/Medium/Low | <scope> | <action> |

## Open Items

Issues for harness-ops to handle or confirm with harness-solo:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Product-Level Engineering Summary (product-level handoff only)

> Product-level handoff only (new-product-engineering workflow). Single-feature handoff (new-feature) omits this section.
> Aggregates deployment-relevant info across all features, so harness-ops can deploy/rollback the whole product rather than per-feature. Supersedes the per-feature Environment Variables List above for product-level deployment.

### Full Dependency List (aggregated across features)

| Dependency | Version | Source features | Notes |
|------------|---------|-----------------|-------|
| <dep 1> | <x.y.z> | F01, F02, F03 | <purpose> |
| <dep 2> | <x.y.z> | F02, F03 | <purpose> |

> Aggregated from each feature's package.json / lockfile. Verified conflict-free by product-engineering-review.

### Integration Test Results (IC1-IC5)

| Checkpoint | Status | Notes |
|------------|--------|-------|
| IC1 (after Phase 1) | ✓ Pass | Shared infrastructure compiles + unit tests pass |
| IC2-IC4 (during Phase 2) | ✓ Pass | Cross-feature user flows work at milestones |
| IC5 (after all features) | ✓ Pass | Full integration test + product-engineering-review |

> Full evidence: `loops/specs/<product-task>/product-review-evidence.md`

### Environment Variable List (aggregated across features)

| Variable name | Source features | Sensitive? | Notes |
|--------|---------|---------|------|
| <KEY_1> | F01, F02 | Yes | <purpose> |
| <KEY_2> | F03 | No | <purpose> |

> Aggregated from each feature's env requirements. For product-level deployment, use this aggregated list rather than per-feature Environment Variables List above.

### Engineering Plan Reference

- **Path**: `docs/engineering/ENGINEERING_PLAN.md`
- **Contents**: Feature Inventory / Shared Infrastructure / Dependency Graph / Implementation Execution Order / Integration Checkpoints / Cross-Feature Consistency Constraints

## Suggested Next Steps

harness-ops should prioritize:

1. Pull the image / check out the commit per this file and deploy
2. Execute database migrations in order
3. Configure environment variables (fetch sensitive items from Secret Manager)
4. Run smoke tests after deployment; declare release success only after all pass
5. Monitor core metrics (error rate / latency / resource usage) for 1 hour post-release

---

## Downstream Framework Usage Notes

harness-ops's deployment/release skill will auto-detect this file and read the deliverable version + database scripts + rollback plan.
If not auto-detected, you can manually point the Agent to this file path to read it.
