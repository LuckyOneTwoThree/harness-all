---
name: root-cause-analysis
description: Root cause analysis, correlating multi-source data (logs / metrics / traces / events) to identify the root cause of incidents
triggers:
  - When root cause needs to be identified after incident stop-the-bleeding
  - During the DEBUG stage of the incident LOOP
  - When recurring intermittent issues need deep investigation
  - When monitoring alerts cannot be explained by known patterns
  - When the user requests "analyze the incident cause"
reads:
  - loops/specs/<incident-id>/spec.md
  - loops/specs/<incident-id>/state.yaml
  - loops/specs/<incident-id>/iterations.log
  - memory/knowledge-base.md
  - rules/security.md
  - loops/LOOP.md
writes:
  - loops/specs/<incident-id>/evidence.md
  - loops/specs/<incident-id>/iterations.log
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 3
operation_tier: inspect
requires_approval: false
---

# Root Cause Analysis — Root Cause Analysis

## Ground Rules

1. **Evidence-based, not guesswork** — every root cause hypothesis must be backed by data
2. **Multi-source correlation, not single-dimension** — cross-validate logs + metrics + traces + events
3. **Find the root cause, not the symptom** — "high CPU" is a symptom, "infinite loop" is the root cause
4. **5 Whys deep dive** — do not stop at the first layer, keep asking

## Process

### 1. Collect Incident Context

Read `spec.md` and `iterations.log`:
- Phenomenon: which service, which error, when
- Handling already attempted: whether stop-the-bleeding was effective
- Existing hypotheses: whether analysis was done before

### 2. Multi-Source Data Collection

#### 2.1 Log Analysis
Invoke the `log-analysis` skill:
- Query ERROR/WARN logs in the incident time window
- Identify anomaly patterns (stack traces, timeouts, connection refused)
- Cluster similar errors (log pattern mining)

#### 2.2 Metrics Analysis
Query Prometheus (PromQL):
```promql
# Error rate
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])

# Latency distribution
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Resource usage
rate(container_cpu_usage_seconds_total[5m])
container_memory_usage_bytes / container_spec_memory_limit_bytes

# Dependency services
rate(redis_command_duration_seconds_sum[5m])
rate(mysql_query_duration_seconds_sum[5m])
```

Compare metrics before and after the incident to locate the anomaly time point.

#### 2.3 Distributed Tracing
Query Tempo/Jaeger:
- Find the trace of the failed request
- Identify which span failed / timed out
- View the full call chain

#### 2.4 Event Correlation
Query K8s events:
```bash
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
# Focus on: OOMKilled, FailedScheduling, Unhealthy, BackOff
```

Query deployment history:
- Was there a deployment before the incident?
- Was there a config change?
- Was there a DB Migration?

### 3. Generate Root Cause Hypotheses

Based on multi-source data, list all possible root causes:

```
## Root Cause Hypothesis List

### Hypothesis 1: [description]
- Evidence: [logs / metrics / traces]
- Confidence: [high / medium / low]
- Verification method: [how to confirm]

### Hypothesis 2: [description]
- Evidence: [...]
- Confidence: [...]
- Verification method: [...]

### Hypothesis 3: [description]
- Evidence: [...]
- Confidence: [...]
- Verification method: [...]
```

### 4. 5 Whys Deep Dive

For each hypothesis, ask 5 layers:

```
Phenomenon: Payment API 500 error rate 8%

Why 1: Why 500? → Database connection timeout
Why 2: Why connection timeout? → Connection pool exhausted
Why 3: Why connection pool exhausted? → Slow queries holding connections
Why 4: Why slow queries? → Missing index, full table scan
Why 5: Why missing index? → Migration missed the index

Root cause: Migration missed the index, causing slow queries that exhausted the connection pool
```

### 5. Verify the Root Cause

- **Direct verification**: execute verification commands (e.g., EXPLAIN on the slow query)
- **Comparative verification**: compare metric differences with normal periods
- **Elimination verification**: rule out other hypotheses

### 6. Produce Root Cause Report

```
## Root Cause Analysis Report

### Incident Summary
- Incident ID: [INC-xxx]
- Severity: [P0/P1/P2]
- Duration: [X minutes]
- Impact scope: [description]

### Root Cause
- Direct cause: [symptom layer]
- Root cause: [root cause layer]
- Confidence: [high / medium / low]
- Verification evidence: [data]

### Timeline
| Time | Event |
|------|------|
| 14:30 | Error rate started rising |
| 14:32 | Alert triggered |
| 14:35 | Agent engaged for diagnosis |
| 14:40 | Root cause identified |
| 14:45 | Stop-the-bleeding executed |
| 14:50 | Service recovered |

### 5 Whys Analysis
[Full chain]

### Recommended Fixes
- Short-term: [stop-the-bleeding measures, completed]
- Mid-term: [fix the root cause, e.g., add index]
- Long-term: [preventive measures, e.g., add Migration check]
```

Write to `evidence.md`.

### 7. Update Knowledge Base

- Append a row to the incident library in `memory/knowledge-base.md`
- Append to the root cause library in `memory/knowledge-base.md` (if a new pattern is discovered)
- Append to the pitfall records in `memory/knowledge-base.md` (if there are lessons learned)

## Prohibitions

- Do not draw conclusions without evidence
- Do not stop at the symptom layer ("high CPU" is not a root cause)
- Do not ignore multiple hypotheses (finding only one root cause may miss things)
- Do not tamper with the timeline (must record truthfully)
- Do not conceal uncertain items (low-confidence hypotheses must also be recorded)

## Relationship to LOOP

**LOOP type**: incident (DEBUG stage)

```
LOOP(incident):
  PLAN(detect) → PROVISION(mitigate) → VERIFY
    ↓ not recovered or root cause needed
  DEBUG(root-cause-analysis)
    ↓ root cause found
  Back to PROVISION (targeted fix)
```

**stage field value**: debug

## Relationship to Other Skills

- **Upstream**: `incident-detection` (creates incident record), `incident-mitigation` (after stop-the-bleeding)
- **Collaboration**: invokes `log-analysis` (logs), queries Prometheus/Grafana (metrics)
- **Downstream**: produces root cause report for `post-mortem` to use
