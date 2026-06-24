---
workflow_id: C
name: incident-response-workflow
description: "Respond to P0/P1 incidents through detection, mitigation, root cause analysis, and post-mortem"
default_mode: skip
---

# Workflow: Incident Response Workflow

> LOOP type: incident
> Trigger scenarios: Received alert, user reports incident, monitoring anomaly, P0/P1 incident
> Orchestration Skill: incident-detection → incident-mitigation → deployment-verify → [not recovered] → root-cause-analysis → back to mitigation → [recovered] → post-mortem

## Flowchart

```
┌─────────────────────────────────────────────────────────┐
│ Incident signal (alert/user feedback/patrol anomaly)    │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ incident-detection               │  Assess + classify + create record
          │                                  │  Query historical knowledge base
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ P0/P1?             │
                  └─────────┬─────────┘
                    ↓ Yes   │    ↓ No (P2/P3)
                            │    Record + schedule for handling
                            ▼
          ┌─────────────────────────────────┐
          │ [Notify human]                   │  AskUserQuestion urgent notification
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ incident-mitigation              │  Mitigation (rollback/scale/restart/degrade)
          │                                  │  Allowlist operations
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify [mitigation    │  Confirm service recovery
          │   validation]                    │
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ Service recovered? │
                  └─────────┬─────────┘
                    ↓ Yes   │    ↓ No
                            │    Continue mitigation or escalate
                            ▼
          ┌─────────────────────────────────┐
          │ root-cause-analysis              │  Multi-source data correlation
          │                                  │  5 Why deep dive
          │                                  │  Produce root cause report
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ [Targeted fix]                   │  Execute fix based on root cause
          │                                  │  May trigger new deployment
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify [final         │  Confirm full recovery
          │   validation]                    │
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ Fully recovered?   │
                  └─────────┬─────────┘
                    ↓ Yes   │    ↓ No
                            │    Back to root-cause-analysis
                            ▼
          ┌─────────────────────────────────┐
          │ post-mortem                      │  Post-mortem report
          │                                  │  Improvement item list
          │                                  │  Knowledge base consolidation
          │                                  │  Produce ops-to-pm.md
          └─────────────────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| Classification gate | Incident severity classified accurately (P0/P1/P2/P3) | When unsure, treat as higher severity |
| Mitigation validation | Error rate decreased + business metrics recovered | Continue mitigation or escalate |
| Root cause validation | Root cause supported by evidence + 5 Why complete | Continue deep dive, no speculation |
| Final validation | All four checks pass + guardrail metrics normal | Back to root cause analysis |
| Post-mortem gate | Improvement items have owners + due dates | Complete then archive |

## Data Flow

| Stage | Output | Storage Location |
|------|------|---------|
| incident-detection | Incident record + classification | spec.md + state.yaml |
| incident-mitigation | Mitigation operation record | iterations.log + evidence.md |
| deployment-verify | Validation report | evidence.md |
| root-cause-analysis | Root cause report | evidence.md |
| post-mortem | Post-mortem report + improvement items | docs/incident/ + knowledge-base.md + ops-to-pm.md |

## Interaction with LOOP

```
LOOP(incident):
  PLAN(detect):     incident-detection → classify → create record → query history
  PROVISION:        incident-mitigation → mitigation (allowlist operations)
  VERIFY:           deployment-verify → confirm recovery
    ↓ Not recovered
  DEBUG:            root-cause-analysis → multi-source correlation → 5 Why
    ↓ Root cause found
  Back to PROVISION (targeted fix)
    ↓ Recovered
  DONE → post-mortem (archive outside LOOP)
```

**Iteration limit**: 5 (incident type)
**Over-limit handling**: Request emergency human intervention

## Response Time Requirements

| Severity | Detection | Engagement | Mitigation | Root cause | Post-mortem |
|------|------|------|------|------|------|
| P0 | Immediate | 5 minutes | 15 minutes | 1 hour | 24 hours |
| P1 | Immediate | 15 minutes | 30 minutes | 4 hours | 3 days |
| P2 | 5 minutes | 1 hour | 4 hours | 1 day | 1 week |
| P3 | Patrol | Scheduled | Scheduled | Scheduled | Monthly summary |

## Operation Allowlist (Mitigation Phase)

| Operation | staging | production |
|------|---------|------------|
| Rollback (rollout undo) | Agent auto | Execute after human confirmation |
| Scale | Agent auto | Execute after human confirmation |
| Restart Pod | Agent auto | Execute after human confirmation |
| Degrade (ConfigMap) | Agent auto | GitOps PR |
| Rate limit | Agent auto | Agent suggests + human confirms |

**Prohibited operations**: delete namespace / drop table / terraform destroy / modify RBAC

## Usage

Tell the Agent:
- "Production payment 500 error rate spiking" → Trigger this workflow
- "Received Alertmanager alert" → Start from incident-detection
- "Service recovered, write post-mortem report" → Start from post-mortem
- "What is the root cause of this incident" → Start from root-cause-analysis
