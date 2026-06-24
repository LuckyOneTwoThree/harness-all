---
workflow_id: D
name: monitoring-deployment-workflow
description: "Deploy monitoring infrastructure with collectors, alerting rules, dashboards, and deployment verification"
default_mode: standard
---

# Workflow: Monitoring Deployment Workflow

> LOOP type: provision
> Trigger scenarios: New service launch requiring monitoring configuration, monitoring system missing needs setup
> Orchestration Skill: monitoring-setup → alerting-rules → dashboard-design → deployment-verify

## Flowchart

```
┌─────────────────────────────────────────────────────────┐
│ Assess monitoring requirements (read OPS_STRATEGY.md    │
│ monitoring alerting matrix)                             │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ monitoring-setup                 │  Deploy collector + storage + visualization
          │                                   │  Prometheus/Loki/Tempo/Grafana
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ alerting-rules                   │  Generate alerting rules
          │                                   │  Configure Alertmanager routing
          │                                   │  Define inhibition rules [Quality Gate]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ dashboard-design                 │  Generate Grafana Dashboard
          │                                   │  Four golden signals
          │                                   │  SLO threshold line [Quality Gate]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify                 │  Verify collection + query + alerting + visualization
          └─────────────────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| After monitoring deployment | Prometheus targets up + logs queryable + traces trackable | Fix collection config |
| After alerting rules generation | Each alert has runbook + severity + routing | Supplement alert metadata |
| After Dashboard generation | Golden signals complete + SLO threshold line marked | Supplement Dashboard |
| Final validation | Simulated alert can trigger + Dashboard accessible | Fix and re-validate |

## Usage

Tell the Agent:
- "Configure monitoring for new service" → Trigger this workflow
- "Deploy Prometheus + Grafana" → Start from monitoring-setup
- "Configure alerting rules" → Start from alerting-rules
