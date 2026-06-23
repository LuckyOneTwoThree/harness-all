---
name: recovery-drill
description: Recovery drill, periodically executing backup recovery tests to verify RTO/RPO compliance
triggers:
  - During periodic recovery drills
  - During backup verification
  - When testing the disaster recovery plan
  - When the user requests "test recovery"
  - When disaster-recovery-workflow triggers
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<task-name>/spec.md
  - loops/specs/<task-name>/evidence.md
  - loops/specs/<task-name>/iterations.log
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: mutate-staging
requires_approval: true
---

# Recovery Drill — Recovery Drill

## Ground Rules

1. **Drills run in an isolated environment** — do not recover directly in production; use an isolated namespace
2. **Drills have RTO/RPO targets** — not only verify "can recover", but also "how fast"
3. **Drill records are complete** — record the duration of each step for optimization
4. **Drill failures must be reported** — do not conceal; failure means the backup is not trustworthy

## Process

### 1. Make a Drill Plan

```
## Recovery Drill Plan

### Goals
- Verify backup recoverability
- Measure RTO (Recovery Time Objective)
- Measure RPO (Recovery Point Objective)
- Verify data integrity

### Scope
- Backup source: production-daily-backup-2026-06-22
- Recovery target: namespace `recovery-test`
- Recovery content: payment-service + related resources

### RTO/RPO Targets
- RTO: < 30 minutes (from recovery start to service available)
- RPO: < 24 hours (data loss no more than 1 day)
```

### 2. Execute Recovery

```bash
# Create the recovery test namespace
kubectl create namespace recovery-test

# Execute Velero restore
velero restore create recovery-test-2026-06-22 \
  --from-backup production-daily-backup-2026-06-22 \
  --namespace-mappings production:recovery-test \
  --wait

# View restore status
velero restore describe recovery-test-2026-06-22 --details
```

### 3. Record the Recovery Timeline

```
## Recovery Timeline

| Time | Step | Duration |
|------|------|------|
| 00:00 | Start recovery | - |
| 00:02 | Velero restores resource objects | 2min |
| 00:05 | PVC restore completed | 3min |
| 00:12 | Pod startup completed | 7min |
| 00:15 | Service health check passed | 3min |
| 00:18 | Smoke test passed | 3min |
| 00:18 | Recovery complete | Total 18min |

### RTO Result
- Target: 30 minutes
- Actual: 18 minutes
- Conclusion: ✓ Met
```

### 4. Verify Data Integrity

```bash
# Compare source data and recovered data
kubectl exec -n recovery-test deployment/payment-service -- \
  psql -c "SELECT COUNT(*) FROM orders WHERE created_at >= '2026-06-21'"

# Compare with production data
kubectl exec -n production deployment/payment-service -- \
  psql -c "SELECT COUNT(*) FROM orders WHERE created_at >= '2026-06-21'"

# Expected: counts match (or difference is within RPO)
```

#### Data Integrity Report
```
## Data Integrity Verification

### Order Data
| Metric | Production | Recovery | Difference |
|------|-----------|----------|------|
| Total orders | 125,678 | 125,678 | 0 |
| Orders on June 21 | 3,456 | 3,456 | 0 |
| Latest order time | 2026-06-22 01:59 | 2026-06-22 01:59 | 0 |

### RPO Result
- Backup time: 2026-06-22 02:00
- Latest data: 2026-06-22 01:59
- Data loss: 1 minute
- Target: < 24 hours
- Conclusion: ✓ Met
```

### 5. Verify Service Availability

```bash
# Health check
kubectl exec -n recovery-test deployment/payment-service -- curl localhost:8080/health

# Smoke test
kubectl exec -n recovery-test deployment/payment-service -- \
  curl -X POST localhost:8080/api/orders -d '{"test": true}'
```

### 6. Clean Up the Drill Environment

```bash
# Delete the recovery test namespace
kubectl delete namespace recovery-test

# Delete the Velero restore record used for the drill
velero restore delete recovery-test-2026-06-22
```

### 7. Generate the Drill Report

```
## Recovery Drill Report

### Drill Information
- Date: 2026-06-22
- Backup source: production-daily-backup-2026-06-22
- Recovery target: recovery-test namespace

### Results Summary
| Metric | Target | Actual | Met |
|------|------|------|------|
| RTO | 30min | 18min | ✓ |
| RPO | 24h | 1min | ✓ |
| Data integrity | 100% | 100% | ✓ |
| Service availability | Available | Available | ✓ |

### Issues Found
1. PVC restore is slow (7min); consider optimizing storage
2. Pod startup time can be optimized (pre-warming)

### Recommendations
- Run a recovery drill monthly
- Test full-cluster recovery in the next drill
- Optimize PVC restore performance
```

### 8. Update Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Drill Date | Backup Source | RTO Target | RTO Actual | RPO Target | RPO Actual | Result | Report |
|---------|--------|---------|---------|---------|---------|------|------|
| 2026-06-22 | daily-backup | 30min | 18min | 24h | 1min | ✓ Pass | docs/recovery/drill-2026-06-22.md |
```

## Prohibitions

- Do not recover directly in production (use an isolated namespace)
- Do not skip data integrity verification
- Do not conceal drill failures
- Do not skip environment cleanup after a drill
- Do not only test "can recover" without testing "how fast"

## Relationship to LOOP

**LOOP type**: recovery

```
LOOP(recovery):
  PLAN:       Make a drill plan → define targets
  PROVISION:  Execute recovery → record timeline
  VERIFY:     Verify data integrity + service availability
  Pass? DONE : Analyze issues → optimize backup strategy
```
