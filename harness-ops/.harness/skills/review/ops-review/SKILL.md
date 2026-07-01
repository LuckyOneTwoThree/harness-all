---
name: ops-review
description: Ops review report, aggregating SLA/incidents/deployments/costs, producing the ops-to-pm.md handoff document
operation_tier: inspect
requires_approval: false
---
# Ops Review — Ops Review Report

## When to use
- During weekly/monthly/quarterly reviews
- When session-end detects closed incidents
- When the user requests "summarize ops progress
- When ops-to-pm.md needs to be produced
- When ops-review-workflow triggers

## Inputs
- memory/knowledge-base.md
- memory/progress.md
- loops/specs/*/state.yaml
- loops/specs/*/evidence.md
- FEATURES.md
- docs/handoff/templates/ops-to-pm-template.md

## Outputs
- docs/handoff/ops-to-pm.md
- memory/knowledge-base.md

## Ground Rules

1. **Reports are based on actual data** — not "feels stable"
2. **Report both successes and failures** — incidents must be recorded truthfully
3. **Provide next-step recommendations** — review is not the goal, improvement is
4. **Produce ops-to-pm.md per the template** — fields must be complete

## Process

### 1. Collect Data

- Read the incident library / deployment record library / IaC asset library from `memory/knowledge-base.md`
- Read `memory/progress.md` to understand this period's work
- Scan `loops/specs/*/state.yaml` for tasks closed in this period
- Read `FEATURES.md` to understand overall status

### 2. Aggregate Core Metrics

```
## Ops Core Metrics Dashboard

### SLA Availability
| Service | Last Month SLA | This Month SLA | Target | Met? |
|------|---------|---------|------|-------|
| payment-service | 99.95% | 99.92% | 99.9% | ✓ |
| order-service | 99.98% | 99.99% | 99.9% | ✓ |
| user-service | 99.99% | 99.85% | 99.9% | ✗ |

### Deployment Statistics
| Metric | Last Month | This Month | Change |
|------|------|------|------|
| Deployments | 23 | 28 | +22% |
| Deployment success rate | 91% | 96% | +5% |
| Average deployment duration | 18min | 12min | -33% |
| Rollbacks | 3 | 1 | -67% |

### Incident Statistics
| Severity | Last Month | This Month | MTTR |
|------|------|------|------|
| P0 | 1 | 0 | - |
| P1 | 2 | 1 | 25min |
| P2 | 5 | 3 | 45min |

### Resource Utilization
| Metric | Last Month | This Month | Change |
|------|------|------|------|
| Cluster CPU utilization | 65% | 72% | +7% |
| Cluster memory utilization | 70% | 75% | +5% |
| Monthly cost | ¥43,000 | ¥45,678 | +6% |
```

### 3. Incident Review

```
## Key Incident Review

### P0 Incidents (if any)
None

### P1 Incidents
| Incident ID | Symptom | Root Cause | MTTR | Improvement |
|--------|------|------|------|--------|
| INC-2026-06-15 | user-service latency spike | Redis connection pool exhausted | 25min | Scale connection pool + add monitoring |

### P2 Incidents
[...]
```

### 4. Deployment Review

```
## Deployment Review

### Successful Deployments
- payment-service v1.2.3: canary release, no anomalies
- order-service v2.0.0: blue-green deployment, smooth cutover

### Failed Deployments
- user-service v1.5.0: staging verification failed (OOM), rolled back
  - Cause: memory limit set too low
  - Improvement: adjusted resource limits and redeployed
```

### 5. Cost Analysis

```
## Cost Analysis

### This Month's Cost: ¥45,678 (+6%)
- Growth driver: added 2 nodes (capacity planning)
- Optimization: identified ¥4,300 in optimization opportunities (see cost-analysis report)

### Cost Trend
[chart]
```

### 6. Improvement Item Progress

```
## Improvement Item Progress

### Last Month's Improvement Items
| Improvement Item | Status | Notes |
|--------|------|------|
| Add index check to migration review | ✅ Done | Landed as a Kyverno policy |
| Add production-scale data testing in staging | 🚧 In Progress | Expected to complete 7/15 |
| Adjust slow query alert threshold | ✅ Done | Adjusted from 1s to 500ms |

### New Improvement Items This Month
| Improvement Item | Owner | Due Date |
|--------|--------|---------|
| Scale Redis connection pool | @ops | 2026-07-01 |
| Disaster recovery drill | @ops | 2026-07-30 |
```

### 7. Next Phase Plan

```
## Next Phase Plan

### Theme: Improve Disaster Recovery Capabilities
- Execute the first full-cluster recovery drill
- Complete the cross-region DR design
- Raise user-service SLA to 99.95%

### Budget Requirements
- DR drill: additional ¥5,000 (test environment resources)
- Cross-region DR: estimated monthly increase of ¥8,000 (backup cluster)
```

### 8. Produce ops-to-pm.md

Fill in per the `ops-to-pm-template.md` template:
- Overall availability summary: this month's overall SLA + each service's achievement status
- Incidents and outage notifications: P0/P1 incidents and post-mortems
- Ops recommendations for the business: e.g., "user-service SLA not met, recommend prioritizing optimization in the next iteration"

**Note**: If ops-to-pm.md already exists, append this period's content; do not overwrite history.

### 9. Update the Knowledge Base

- Append this month's new incidents to the incident library
- Append reusable patterns to the ops patterns library
- Append lessons learned to the pitfall records

## Prohibitions

- Do not report only good news and hide bad news (incidents must be recorded)
- Do not list data without providing insights
- Do not omit the next phase plan
- Do not include user PII in ops-to-pm.md
- Do not tamper with SLA data

## Relationship to LOOP

**LOOP type**: none (session-level / periodic report)

This skill does not run inside a LOOP; it produces periodic reports.
Usually triggered by session-end, or executed on explicit user request.
It is the core step of ops-review-workflow.
