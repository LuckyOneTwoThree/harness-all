---
name: sla-report
description: SLA calculation and reporting, computing availability from monitoring data and generating SLA achievement reports
triggers:
  - During monthly SLA reporting
  - When the user requests "calculate SLA"
  - When SLA targets are not met and analysis is required
  - When ops-review needs data support
  - When contracts/compliance require SLA evidence
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - memory/knowledge-base.md
  - loops/LOOP.md
writes:
  - docs/monitoring/sla-report.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
operation_tier: inspect
requires_approval: false
---

# SLA Report — SLA Calculation and Reporting

## Ground Rules

1. **SLA is based on monitoring data** — no estimation; use actual Prometheus data
2. **SLA calculation has a clear formula** — reproducible and auditable
3. **SLA misses must be analyzed** — do not just report numbers, provide root causes
4. **SLA reports are shareable externally** — may be used for contracts/compliance

## Process

### 1. Define SLA Metrics

```
## SLA Metric Definition

### Availability
- Formula: (total time - downtime) / total time * 100%
- Downtime definition: error rate > 5% sustained for > 1 minute
- Target: 99.9% (monthly downtime < 43.2 minutes)

### Latency
- Formula: p95 latency
- Target: p95 < 200ms

### Error Rate
- Formula: 5xx requests / total requests
- Target: < 0.1%
```

### 2. Calculate SLA

```promql
# Availability calculation (this month)
1 - (
  sum(rate(http_requests_total{service="payment-service",status=~"5.."}[30d]))
  / sum(rate(http_requests_total{service="payment-service"}[30d]))
)

# Downtime calculation
sum(count_over_time(
  (sum(rate(http_requests_total{status=~"5.."}[1m])) / sum(rate(http_requests_total[1m])) > 0.05)[30d:]
)) * 60

# p95 latency (monthly average)
avg(histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[30d])))

# Error rate (this month)
sum(rate(http_requests_total{status=~"5.."}[30d])) / sum(rate(http_requests_total[30d]))
```

### 3. Generate the SLA Report

```
## Monthly SLA Report (May 2026)

### Service-Level SLA

| Service | Availability | Target | Met? | Downtime | p95 Latency | Latency Target | Error Rate | Error Target |
|------|--------|------|-------|-----------|---------|---------|--------|---------|
| payment-service | 99.92% | 99.9% | ✓ | 34min | 180ms | 200ms | 0.08% | 0.1% |
| order-service | 99.99% | 99.9% | ✓ | 4min | 95ms | 200ms | 0.01% | 0.1% |
| user-service | 99.85% | 99.9% | ✗ | 65min | 350ms | 200ms | 0.15% | 0.1% |

### Overall SLA
- Average availability: 99.92%
- Target: 99.9%
- Met: ✓ (but user-service did not meet the target)

### SLA Miss Analysis

#### user-service (99.85% vs target 99.9%)
- Downtime: 65 minutes
- Major incidents:
  1. 2026-05-15: Redis connection pool exhausted (25min)
  2. 2026-05-22: Deployment failed and rolled back (20min)
  3. 2026-05-28: Database slow queries (20min)
- Root cause: insufficient resource allocation + unstable dependencies
- Improvements: scale up + optimize slow queries + adjust deployment strategy
```

### 4. Generate SLA Trends

```
## SLA Trend (Last 6 Months)

| Month | payment | order | user | Overall |
|------|---------|-------|------|------|
| 2025-12 | 99.95% | 99.98% | 99.92% | 99.95% |
| 2026-01 | 99.93% | 99.99% | 99.90% | 99.94% |
| 2026-02 | 99.96% | 99.97% | 99.88% | 99.94% |
| 2026-03 | 99.94% | 99.99% | 99.91% | 99.95% |
| 2026-04 | 99.95% | 99.98% | 99.99% | 99.97% |
| 2026-05 | 99.92% | 99.99% | 99.85% | 99.92% |

### Trend Analysis
- payment-service: stable above 99.9%, slightly down this month
- order-service: consistently excellent
- user-service: high volatility, missed target this month, needs focused attention
```

### 5. Write the Report

Write to `docs/monitoring/sla-report-2026-05.md`.

### 6. Update the Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Month | Overall SLA | Target | Met | Services Missing Target | Primary Cause |
|------|---------|------|------|-----------|---------|
| 2026-05 | 99.92% | 99.9% | ✓ | user-service | Redis + deployment + slow queries |
```

## Prohibitions

- Do not calculate SLA based on estimation (must use monitoring data)
- Do not tamper with SLA data
- Do not conceal SLA misses
- Do not include user PII in the report

## Relationship to LOOP

**LOOP type**: none (reporting skill)

This skill produces SLA reports for ops-review to reference.
Usually executed monthly, or on explicit user request.
