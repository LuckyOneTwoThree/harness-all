---
name: backup-management
description: Velero backup management, configuring backup schedules, executing backups, and verifying backup integrity
operation_tier: propose
requires_approval: false
---
# Backup Management — Velero Backup Management

## When to use
- When backup policies need to be configured
- When running periodic backups
- When a backup is needed before deployment
- During backup integrity verification
- When the user requests "back up data

## Inputs
- docs/infrastructure/OPS_STRATEGY.md
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md

## Outputs
- loops/specs/<task-name>/spec.md
- loops/specs/<task-name>/evidence.md
- memory/knowledge-base.md

## Ground Rules

1. **Backups must be verified** — an unverified backup is equivalent to no backup
2. **Backups have a retention period** — do not retain indefinitely; clean up per policy
3. **Backups are encrypted at rest** — backup content may contain sensitive data
4. **Recovery drills must be run periodically** — a backup that is never drilled is not trustworthy

## Process

### 1. Configure Backup Schedule

#### Velero Schedule CRD
```yaml
apiVersion: velero.io/v1
kind: Schedule
metadata:
  name: production-daily-backup
  namespace: velero
spec:
  schedule: "0 2 * * *"  # every day at 2 AM
  template:
    includedNamespaces:
    - production
    - monitoring
    excludedResources:
    - events
    - pods
    storageLocation: default
    ttl: 720h  # retain for 30 days
    hooks:
      resources:
      - name: backup-hook
        includedNamespaces:
        - production
        preHooks:
        - exec:
            container: app
            command:
            - /bin/sh
            - -c
            - "pg_dump -U postgres dbname > /backup/db.sql"
        postHooks:
        - exec:
            container: app
            command:
            - /bin/sh
            - -c
            - "rm /backup/db.sql"
```

#### Backup Policy
| Type | Frequency | Retention | Scope | Storage |
|------|------|--------|------|------|
| Daily backup | Every day at 2:00 | 30 days | production namespace | S3/OSS |
| Weekly backup | Every Sunday at 3:00 | 90 days | Full cluster | S3/OSS (different region) |
| Pre-deployment backup | Triggered by deployment | 7 days | Resources related to the change | S3/OSS |
| Database snapshot | Hourly | 24 hours | RDS/PVC | Cloud provider snapshot |

### 2. Execute Backup

```bash
# Manually trigger a backup
velero backup create manual-backup-2026-06-22 \
  --include-namespaces production \
  --wait

# Pre-deployment backup (triggered by deployment-pipeline)
velero backup create pre-deploy-$(date +%Y%m%d-%H%M) \
  --include-namespaces production \
  --label-selector app=payment-service
```

### 3. Verify Backup Integrity

```bash
# View backup status
velero backup get

# View backup details
velero backup describe <backup-name> --details

# Verify backup content
velero backup download <backup-name>
tar -tzf <backup-name>.tar.gz | head -20

# Check whether the backup has errors
velero backup describe <backup-name> | grep -i error
```

#### Verification Report
```
## Backup Verification Report

### Backup: production-daily-backup-2026-06-22
- Status: Completed
- Start time: 2026-06-22 02:00:00
- End time: 2026-06-22 02:05:32
- Duration: 5 min 32 sec
- Resource count: 156
- Volume count: 8
- Total size: 2.3 GB
- Errors: 0
- Warnings: 0

### Verification Results
- [x] Backup status Completed
- [x] No errors
- [x] Resource count matches expectations
- [x] Volume data intact
- [x] Downloadable and extractable
```

### 4. Backup Monitoring

```yaml
# Prometheus alerting rules
- alert: VeleroBackupFailed
  expr: velero_backup_last_status{status="failed"} == 1
  for: 5m
  labels:
    severity: P1
  annotations:
    summary: "Velero backup failed"
    description: "Backup {{ $labels.schedule }} failed"

- alert: VeleroBackupStale
  expr: time() - velero_backup_last_timestamp > 86400
  for: 1h
  labels:
    severity: P2
  annotations:
    summary: "Velero backup has not run in over 24 hours"
```

### 5. Backup Cleanup

```bash
# Clean up by retention period (Velero does this automatically)
# Manually delete old backups
velero backup delete <old-backup-name> --confirm
```

### 6. Update Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Backup Name | Type | Time | Size | Status | Retain Until | Verified |
|--------|------|------|------|------|--------|------|
| daily-2026-06-22 | Daily | 02:00 | 2.3GB | Completed | 2026-07-22 | ✓ |
```

## Prohibitions

- Do not skip backup verification
- Do not retain backups indefinitely (clean up per policy)
- Do not test recovery in the production namespace (use an isolated namespace)
- Do not store backups in the same availability zone (must be cross-region)

## Relationship to LOOP

**LOOP type**: recovery (PLAN stage)

This skill configures backup schedules; the recovery-drill skill executes recovery drills.
