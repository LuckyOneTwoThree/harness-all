---
name: rollback
description: Rollback operations and verification, supporting image revert, config revert, and database rollback to ensure fast business recovery
triggers:
  - When post-deployment health check fails
  - When monitoring alerts indicate the new version is abnormal
  - When the user requests "roll back to the previous version"
  - When a canary release stage fails the health gate
  - When incident-response triggers an emergency rollback
reads:
  - loops/specs/<task-name>/spec.md
  - loops/specs/<task-name>/state.yaml
  - docs/handoff/solo-to-ops.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<task-name>/state.yaml
  - loops/specs/<task-name>/evidence.md
  - loops/specs/<task-name>/iterations.log
  - docs/incident/
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: mutate-staging
requires_approval: true
---

# Rollback — Rollback Operations and Verification

## Ground Rules

1. **Rollback before root cause** — when business is abnormal, roll back to recover first, then analyze the root cause
2. **Rollback must be verifiable** — after rollback, must confirm business recovery, not just "rolled back, that's it"
3. **Database rollback requires caution** — rollbacks with schema changes must be confirmed by DBA; may be irreversible
4. **Rollback is not failure** — rollback is a normal safety mechanism; must be recorded but not blamed

## Process

### 1. Confirm the Rollback Decision

Rollback trigger scenarios:
- **Automatic trigger**: deployment-verify health check failed, canary health gate not passed
- **Manual trigger**: user requests rollback, incident-response decides to roll back
- **Monitoring trigger**: error rate spike, latency degradation, business metric drop

Confirm the rollback scope:
```
## Rollback Decision
- Trigger reason: [health check failure / alert / manual]
- Rollback scope: [single service / multiple services / full]
- Current version: [image Tag / Commit]
- Target version: [previous stable version]
- Database state: [whether SQL rollback is needed]
- Impact assessment: [business impact during rollback]
```

### 2. Select Rollback Strategy

#### Image Revert (most common)
- Applicable: anomalies caused by code changes
- Method: change the Deployment image tag to the previous version
- Time: K8s rolling update, about 1-5 minutes
- Production: generate a GitOps PR; sync after human merge

#### Config Revert
- Applicable: anomalies caused by ConfigMap/Secret changes
- Method: revert ConfigMap to the previous version
- Time: seconds (takes effect after Pod restart)

#### Database Rollback (high risk)
- Applicable: data issues caused by Migration
- Precondition: solo-to-ops.md provides `db_revert_v*.sql`
- Flow:
  ```
  [Human DBA confirmation] → execute rollback SQL → verify data consistency → roll back image
  ```
- **Warning**: irreversible Migrations (e.g., DROP COLUMN) cannot be rolled back; only forward-fix is possible

#### Traffic Switchback (blue-green deployment)
- Applicable: blue-green deployment mode
- Method: switch traffic back to the Blue environment
- Time: seconds

#### GitOps Revert
- Applicable: all changes deployed via GitOps
- Method: `git revert <commit>` + merge
- Advantage: traceable, automatically triggers ArgoCD/Flux sync

### 3. Execute Rollback

**Staging environment**:
- Agent directly executes rollback (kubectl set image / helm rollback)
- Record the rollback operation in iterations.log

**Production environment**:
- Agent generates a GitOps revert PR
- Use AskUserQuestion to request human confirmation
- Emergency: Agent recommends, after human verbal confirmation Agent executes kubectl rollout undo
- Record the rollback operation in iterations.log

### 4. Verify Rollback Effect

Invoke the `deployment-verify` skill:
- Health check recovered ✓
- Error rate dropped to normal levels ✓
- Business metrics recovered ✓
- Monitoring alerts cleared ✓

### 5. Record and Archive

```
## Rollback Record
- Time: [ISO 8601]
- Task: [task-name]
- Trigger reason: [detailed description]
- Rollback strategy: [image / config / DB / traffic]
- Pre-rollback version: [v1.2.3]
- Post-rollback version: [v1.2.2]
- Verification result: [health check passed / business metrics recovered]
- Duration: [total time from decision to recovery]
- Initial root cause assessment: [to be analyzed / identified]
```

Write to:
- `loops/specs/<task>/evidence.md` — rollback evidence
- `loops/specs/<task>/iterations.log` — append rollback record
- `docs/incident/<date>-rollback.md` — if a production incident is involved
- `memory/knowledge-base.md` — append a row to the incident library

## Prohibitions

- Do not roll back blindly without confirming the impact scope
- Do not skip DBA confirmation for database rollback
- Do not skip verification after rollback (must confirm business recovery)
- Do not conceal rollback events (must record and notify)
- Do not fix bugs while rolling back (recover first, fix later)

## Relationship to LOOP

**LOOP type**: provision (as the rollback stage after VERIFY failure)

```
LOOP(provision):
  PLAN → PROVISION → VERIFY
    ↓ fail
  ROLLBACK → verify rollback
    ↓ recovered
  Analyze root cause → fixable back to PROVISION / re-plan back to PLAN
```

**stage field value**: rollback

**Status values**:
- Rolling back: status=retrying, stage=rollback
- Rollback succeeded: status=running (back to PLAN to re-plan) or status=done (if this release is abandoned)
- Rollback failed: status=needs-human (request human intervention)
