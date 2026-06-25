---
name: log-analysis
description: Log query and analysis, generating LogQL/ES DSL queries, log pattern discovery and anomaly clustering
operation_tier: inspect
requires_approval: false
---
# Log Analysis — Log Query and Analysis

## When to use
- When troubleshooting requires querying logs
- When root-cause-analysis needs log evidence
- When the user requests "query logs
- When monitoring alerts need log correlation
- When log patterns need to be analyzed

## Inputs
- loops/specs/<incident-id>/spec.md
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md

## Outputs
- loops/specs/<incident-id>/evidence.md
- memory/knowledge-base.md

## Ground Rules

1. **Queries must have a time range** — do not scan everything; limit the time window
2. **Queries must have a purpose** — know what to look for; do not browse aimlessly
3. **Logs must not contain PII** — mask query results before displaying
4. **Pattern discovery over line-by-line reading** — use aggregation queries; do not read line by line

## Process

### 1. Clarify the Query Purpose

- **Incident diagnosis**: find ERROR/Exception/stack traces
- **Performance analysis**: find slow queries / timeouts / retries
- **Security audit**: find abnormal access / permission changes
- **Business analysis**: find the behavior trail of specific users / orders

### 2. Generate LogQL Queries (Loki)

#### Basic Queries
```logql
# Query logs of a specific service
{app="payment-service", namespace="production"}

# Query a specific time range
{app="payment-service"} |= "2026-06-22T14:"

# Query ERROR logs
{app="payment-service"} |= "ERROR" | json

# Query exception stack traces
{app="payment-service"} |~ "Exception|Error|Traceback"

# Query a specific request
{app="payment-service", request_id="abc-123"}
```

#### Aggregation Queries
```logql
# Error log count (over time)
sum(count_over_time({app="payment-service"} |= "ERROR" [5m]))

# Error rate trend
sum(rate({app="payment-service"} |= "ERROR" [5m])) by (status)

# Log pattern discovery
pattern({app="payment-service"} |= "ERROR")
```

### 3. Generate ES DSL Queries (Elasticsearch)

```json
{
  "query": {
    "bool": {
      "must": [
        {"match": {"service": "payment-service"}},
        {"match": {"level": "ERROR"}},
        {"range": {"@timestamp": {"gte": "2026-06-22T14:00:00", "lte": "2026-06-22T15:00:00"}}}
      ]
    }
  },
  "sort": [{"@timestamp": "desc"}],
  "size": 100
}
```

### 4. Log Pattern Discovery

#### Identify Repeated Patterns
```logql
# Use pattern to extract log patterns
{app="payment-service"} | pattern "<ip> <method> <path> <status> <duration>"
```

#### Anomaly Clustering
- Aggregate ERRORs with the same stack trace
- Aggregate requests with the same error code
- Aggregate queries with the same timeout pattern

### 5. Multi-Source Log Correlation

#### Trace Correlation
```
1. Find the full call chain from trace_id
2. Find the failed span
3. Query the logs corresponding to that span
4. Query the logs of upstream and downstream services
```

#### Timeline Correlation
```
14:30:00  payment-service  ERROR  Database connection timeout
14:30:01  postgres         LOG    too many connections
14:30:02  payment-service  WARN   Retrying (attempt 2/3)
14:30:05  payment-service  ERROR  Max retries exceeded
```

### 6. Generate Log Analysis Report

```
## Log Analysis Report

### Query Conditions
- Service: payment-service
- Time range: 2026-06-22 14:25:00 ~ 14:45:00
- Keywords: ERROR / Exception

### Findings
1. Database connection timeout errors started at 14:30:00
2. Error pattern: "Database connection timeout after 30s"
3. Frequency: about 50 per minute
4. Correlation: postgres logs show "too many connections" (max_connections=100)

### Anomaly Patterns
- 14:30-14:35: connection timeout errors dense (50/min)
- 14:35-14:40: error rate dropped (rollback took effect)
- 14:40-14:45: errors disappeared (service recovered)

### Conclusion
The root cause points to database connection pool exhaustion, consistent with the hypothesis from root-cause-analysis.
```

### 7. Update Knowledge Base

If new log patterns are discovered, append to `memory/knowledge-base.md`:
```
| Log Pattern | Meaning | Related Root Cause | Handling | Source |
|---------|------|---------|---------|------|
| "too many connections" | DB connection pool exhausted | Slow query / connection leak | Scale out / fix slow query | INC-xxx |
```

## Prohibitions

- Do not scan all logs (must limit the time range)
- Do not expose user PII in logs (mask when querying)
- Do not browse logs aimlessly (must have a query hypothesis)
- Do not tamper with logs (read-only, do not modify)
- Do not write sensitive log content into handoff documents

## Relationship to LOOP

**LOOP type**: incident (DEBUG stage)

This skill is invoked when root-cause-analysis executes, providing log evidence.
It can also be invoked during the incident-detection stage to quickly judge the incident phenomenon.
