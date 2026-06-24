---
workflow_id: F
name: disaster-recovery-workflow
description: "Run disaster recovery drills with backup validation, recovery execution, and RTO/RPO verification"
default_mode: skip
---

# Workflow: Disaster Recovery Workflow

> LOOP type: recovery
> Trigger scenarios: Periodic disaster recovery drill, DR plan validation, backup recovery test
> Orchestration Skill: backup-management → recovery-drill → [validation] → [report]

## Flowchart

```
┌─────────────────────────────────────────────────────────┐
│ Determine drill scope (services/data/scenarios)         │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ backup-management                │  Confirm backup available
          │                                   │  Validate backup integrity [Quality Gate]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ recovery-drill                   │  Execute recovery in isolated environment
          │                                   │  Record RTO/RPO
          │                                   │  Validate data integrity [Quality Gate]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ Generate drill report            │
          │ Improvement suggestions + plan   │
          │ update                           │
          └─────────────────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| Backup validation | Backup status Completed + no errors | Re-backup |
| Recovery validation | RTO/RPO meet target + data intact | Analyze bottleneck + optimize |
| Service validation | Health check pass + smoke test pass | Troubleshoot recovery issues |

## Usage

Tell the Agent:
- "Run disaster recovery drill" → Trigger this workflow
- "Test backup recovery" → Start from recovery-drill
- "Validate DR plan" → Start from disaster-recovery-plan
