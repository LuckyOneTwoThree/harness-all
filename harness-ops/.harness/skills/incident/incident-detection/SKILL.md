---
name: incident-detection
description: Incident detection and classification, receiving alerts/user feedback, classifying incident severity, and triggering the emergency response process
operation_tier: inspect
requires_approval: false
---
# Incident Detection — Incident Detection and Classification

## When to use
- When a Prometheus/Alertmanager alert is received
- When a user reports "production incident" or "service anomaly
- When monitoring metrics fluctuate abnormally
- When error rate / latency suddenly spikes
- When session-start detects an in-progress incident LOOP

## Inputs
- docs/infrastructure/OPS_STRATEGY.md
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md
- loops/specs/*/state.yaml

## Outputs
- loops/specs/<incident-id>/spec.md
- loops/specs/<incident-id>/state.yaml
- docs/incident/
- memory/knowledge-base.md

## Ground Rules

1. **Stop the bleeding before investigating the cause** — after detecting an incident, prioritize service recovery; root cause analysis comes second
2. **Do not conceal incidents** — every incident must be recorded; do not skip archiving because it "already recovered"
3. **Do not underestimate severity** — when unsure, treat as higher severity; better a false alarm
4. **Do not decide P0 alone** — P0 incidents must immediately notify humans; the Agent does not handle them alone

## Process

### 1. Receive Incident Signals

Signal sources:
- **Alerting system**: Prometheus Alertmanager / cloud provider monitoring alerts
- **User feedback**: users report "service unavailable" / "slow response" / "data error"
- **Automatic detection**: Agent proactively detects anomalies during patrol
- **Upstream notification**: solo/growth framework reports anomalies

### 2. Initial Assessment

```
## Initial Incident Assessment
- Detection time: [ISO 8601]
- Signal source: [alert / user / patrol / upstream]
- Phenomenon: [detailed description]
- Impact scope: [which services / which users / how much traffic]
- Duration: [how long it has lasted]
- Still deteriorating: [yes/no]
```

### 3. Incident Severity Classification

| Severity | Criteria | Response SLA | Decision Authority |
|------|---------|---------|--------|
| **P0** | Core functionality unavailable / data loss / security event | Immediate response, engage within 5 minutes | Human + Agent |
| **P1** | Partial functionality abnormal / severe performance degradation | Engage within 15 minutes | Human + Agent |
| **P2** | Non-core functionality abnormal / intermittent issues | Engage within 1 hour | Agent + notify human |
| **P3** | Potential risk / optimization suggestion | Schedule for handling | Agent |

**Classification examples**:
- P0: Payment API 500 error rate > 5%
- P1: Login API p95 latency > 5 seconds
- P2: Admin page intermittent 404
- P3: A Pod's CPU utilization persistently > 80%

### 4. Create Incident Record

```
loops/specs/INC-<date>-<short-desc>/
├── spec.md          ← Incident spec (overwrite)
├── state.yaml       ← Loop state
├── evidence.md      ← Evidence (overwrite)
└── iterations.log   ← Handling history (append)
```

**spec.md content**:
```yaml
incident_id: INC-2026-06-22-payment-500
severity: P0
detected_at: "2026-06-22T14:30:00"
phenomenon: "Payment API returns 500 errors, error rate 8%"
affected_services: [payment-service, order-service]
affected_users: "about 30% of payment users"
impact: "Cannot complete payment, directly affects revenue"
```

**state.yaml initialization**:
```yaml
current_task: INC-2026-06-22-payment-500
iteration: 0
stage: plan
status: running
started_at: "2026-06-22T14:30:00"
```

### 5. Trigger Emergency Response

- **P0/P1**: Immediately notify humans (AskUserQuestion), and start `incident-response-workflow`
- **P2**: Start `incident-response-workflow`, notify humans
- **P3**: Record to FEATURES.md, schedule for handling

### 6. Query Historical Knowledge Base

Read `memory/knowledge-base.md`:
- Are there historical records of similar incidents?
- Are there known root cause patterns?
- Are there verified handling procedures?

**If a match is found**: directly apply the historical solution, skip some diagnostic steps.
**If no match**: enter the `root-cause-analysis` skill for full diagnosis.

## Prohibitions

- Do not delay response to P0/P1 incidents
- Do not decide P0 incident handling alone (human participation required)
- Do not skip recording because it "auto-recovered"
- Do not claim "done" while the incident is not recovered
- Do not tamper with incident severity (downgrade requires human confirmation)

## Relationship to LOOP

**LOOP type**: incident (max 5 iterations)

This skill is the entry point of the incident LOOP, executing in the PLAN stage:
```
LOOP(incident):
  PLAN(detect):     incident-detection → classify → create record
  PROVISION:        incident-mitigation → stop the bleeding
  VERIFY:           deployment-verify → confirm recovery
    ↓ not recovered
  DEBUG:            root-cause-analysis → deep diagnosis
    ↓ back to PROVISION (new handling plan)
```

**stage field value**: plan

## Relationship to Other Skills

- **Downstream**: triggers `incident-mitigation` (stop the bleeding), `root-cause-analysis` (root cause)
- **Collaboration**: invokes `rollback` (if rollback is needed), `log-analysis` (log query)
- **Archive**: after incident recovery, `post-mortem` produces the post-mortem report
