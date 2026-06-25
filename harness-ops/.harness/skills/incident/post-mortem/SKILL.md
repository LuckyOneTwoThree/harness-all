---
name: post-mortem
description: Incident post-mortem report, summarizing timeline / root cause / impact / action items, and persisting to the knowledge base to prevent recurrence
operation_tier: inspect
requires_approval: false
---
# Post-Mortem — Incident Post-Mortem Report

## When to use
- After a P0/P1 incident is recovered
- After the incident LOOP completes
- When the user requests "write a post-mortem report
- When session-end detects a closed incident
- During periodic reviews of historical incidents

## Inputs
- loops/specs/<incident-id>/spec.md
- loops/specs/<incident-id>/evidence.md
- loops/specs/<incident-id>/iterations.log
- memory/knowledge-base.md
- docs/handoff/ops-to-pm-template.md

## Outputs
- docs/incident/<incident-id>-post-mortem.md
- docs/handoff/ops-to-pm.md
- memory/knowledge-base.md

## Ground Rules

1. **Focus on the issue, not the person** — post-mortem is for improvement, not for blame
2. **Do not conceal mistakes** — the Agent's own judgment errors must also be recorded truthfully
3. **Every action item must have an owner and a due date** — otherwise the post-mortem is meaningless
4. **Persist to the knowledge base** — post-mortem conclusions must be written to knowledge-base.md
5. **Report both successes and failures** — analyze both what worked and what didn't

## Process

### 1. Collect the Full Incident Picture

Read all related files:
- `spec.md` — incident spec
- `evidence.md` — root cause analysis report
- `iterations.log` — complete handling timeline
- `knowledge-base.md` — historical similar incidents

### 2. Build the Timeline

```
## Incident Timeline

| Time | Event | Source |
|------|------|------|
| 14:25:00 | Deployed v1.2.3 to production | deployment-pipeline |
| 14:30:00 | Error rate started rising (5%→8%) | Prometheus |
| 14:32:00 | Alertmanager triggered an alert | Alerting system |
| 14:33:00 | Agent received alert, created INC-xxx | incident-detection |
| 14:35:00 | Agent assessed as P0, notified humans | incident-detection |
| 14:37:00 | Human confirmed, Agent executed rollback | incident-mitigation |
| 14:40:00 | Rollback completed, error rate dropped | rollback |
| 14:45:00 | Service fully recovered | deployment-verify |
| 14:50:00 | Started root cause analysis | root-cause-analysis |
| 15:10:00 | Root cause identified: Migration missing index | root-cause-analysis |
```

### 3. Impact Assessment

```
## Impact Assessment

### Business Impact
- Duration: 15 minutes (14:30-14:45)
- Affected users: about 3000 failed payment requests
- Direct loss: about ¥45,000 (estimated at ¥15 average order value)
- SLA impact: this month's availability dropped from 99.95% to 99.92%

### Technical Impact
- Affected services: payment-service, order-service
- Resource consumption: CPU spiked to 95% during the incident
- Data impact: no data loss / corruption
```

### 4. Root Cause Summary

```
## Root Cause Analysis

### Direct Cause
The payment API timed out calling the database; the connection pool was exhausted, causing 500 errors.

### Root Cause
The v1.2.3 DB Migration added the `user_orders` table but missed an index,
causing `SELECT * FROM user_orders WHERE user_id = ?` to do a full table scan.
A single query took 10ms → 2s, and the connection pool was exhausted within 30 seconds.

### 5 Whys Analysis
1. Why 500? → Database connection timeout
2. Why connection timeout? → Connection pool exhausted
3. Why exhausted? → Slow queries holding connections
4. Why slow? → Missing index
5. Why missing? → Migration review process did not check indexes
```

### 5. Handling Assessment

```
## Handling Assessment

### What Went Well
- ✅ Timely alerting (triggered within 2 minutes)
- ✅ Fast Agent response (created record within 1 minute)
- ✅ Correct rollback decision (effective stop-the-bleeding)
- ✅ Accurate root cause identification

### What Needs Improvement
- ❌ Missing index in Migration was not detected before deployment
- ❌ Staging environment did not cover production data volume, did not expose slow queries
- ❌ From alert to rollback took 8 minutes, can be optimized to under 5 minutes
```

### 6. Action Items List

```
## Action Items

| ID | Action Item | Type | Owner | Due Date | Priority |
|------|--------|------|--------|---------|--------|
| IMP-001 | Add index checklist to Migration review | Process | @backend-lead | 2026-07-01 | P0 |
| IMP-002 | Add production-data-volume testing to staging | Tooling | @ops | 2026-07-15 | P1 |
| IMP-003 | Lower slow-query alert threshold from 1s to 500ms | Monitoring | @ops | 2026-06-25 | P1 |
| IMP-004 | Add "connection pool usage > 90%" to auto-rollback triggers | Automation | @ops | 2026-07-10 | P2 |
```

### 7. Produce Documents

#### 7.1 Post-Mortem Report
Write to `docs/incident/<incident-id>-post-mortem.md`, including all the above content.

#### 7.2 Notify PM (if needed)
If the incident affects business or requires product-side improvements, fill in per `ops-to-pm-template.md` and append to `docs/handoff/ops-to-pm.md`:
- Incident notification: incident summary + impact
- Improvement plan: items needing PM coordination

#### 7.3 Update Knowledge Base

Append to `memory/knowledge-base.md`:

**Incident library**:
```
| Incident ID | Severity | Phenomenon | Root Cause | Duration | Impact | Action Items | Date |
|--------|------|------|------|---------|------|--------|------|
| INC-2026-06-22-payment-500 | P0 | Payment 500 errors | Migration missing index | 15 minutes | ¥45k loss | 4 items | 2026-06-22 |
```

**Root cause library** (if a new pattern is discovered):
```
| Root Cause Pattern | Applicable Scenario | Identification Features | Handling | Source |
|---------|---------|---------|---------|------|
| Migration missing index | Slow query surge after deployment | Connection pool exhausted + CPU spike | Rollback + add index | INC-2026-06-22 |
```

**Pitfall records** (if there are lessons learned):
```
| Date | Issue | Solution | Related File |
|------|------|---------|---------|
| 2026-06-22 | Migration review did not check indexes | Add index checklist | docs/incident/INC-xxx-post-mortem.md |
```

## Prohibitions

- Do not tamper with the timeline (record truthfully)
- Do not conceal the Agent's own mistakes
- Do not provide action items without owners
- Do not skip knowledge base persistence
- Do not include user PII in the post-mortem report

## Relationship to LOOP

**LOOP type**: none (not a loop; executes after the incident LOOP completes)

This skill triggers after the incident LOOP status=done, and is a session-level/incident-level archiving action.
Usually triggered by session-end, or executed on explicit user request.

## Relationship to Other Skills

- **Upstream**: `root-cause-analysis` (root cause report), `incident-mitigation` (stop-the-bleeding record)
- **Collaboration**: invokes `ops-review` (if needed to roll up into a periodic report)
- **Downstream**: produces `ops-to-pm.md` (notify PM)
