---
name: dashboard-design
description: Grafana Dashboard generation and optimization, designing visualization panels by service / tier / role
triggers:
  - When a Grafana Dashboard needs to be generated
  - When designing visualization after monitoring-setup deployment
  - When a Dashboard needs optimization
  - When the user requests "make a monitoring panel"
  - When a new service goes live and needs a Dashboard
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/monitoring/
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: propose
requires_approval: false
---

# Dashboard Design — Grafana Dashboard Generation

## Ground Rules

1. **Design for the role** — different roles view different Dashboards (ops / dev / business)
2. **Golden signals first** — latency / traffic / errors / saturation
3. **Mark threshold lines** — SLO target lines must be visualized
4. **Do not pile up charts** — every Panel has a clear purpose

## Process

### 1. Determine Dashboard Type

| Type | Target Audience | Core Metrics |
|------|---------|---------|
| **Service Overview** | Ops / Management | Availability / error rate / latency / throughput |
| **Service Details** | Dev | JVM / connection pool / slow queries / cache |
| **Infrastructure** | Ops | CPU / memory / disk / network |
| **Business Monitoring** | Business / Product | Order volume / conversion rate / revenue |
| **Alert View** | Oncall | Current alerts / historical trends |

### 2. Generate Dashboard JSON

#### Service Overview Dashboard
```json
{
  "title": "Payment Service - Overview",
  "tags": ["payment", "overview", "production"],
  "timezone": "browser",
  "refresh": "30s",
  "panels": [
    {
      "title": "Availability (SLO 99.9%)",
      "type": "stat",
      "gridPos": {"h": 4, "w": 6, "x": 0, "y": 0},
      "targets": [{
        "expr": "1 - (sum(rate(http_requests_total{service=\"payment-service\",status=~\"5..\"}[5m])) / sum(rate(http_requests_total{service=\"payment-service\"}[5m])))"
      }],
      "fieldConfig": {
        "defaults": {
          "thresholds": {
            "steps": [
              {"color": "red", "value": null},
              {"color": "yellow", "value": 0.99},
              {"color": "green", "value": 0.999}
            ]
          }
        }
      }
    },
    {
      "title": "Request Rate (req/s)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 6, "y": 0},
      "targets": [{
        "expr": "sum(rate(http_requests_total{service=\"payment-service\"}[5m]))"
      }]
    },
    {
      "title": "Error Rate (SLO < 0.1%)",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 4},
      "targets": [{
        "expr": "sum(rate(http_requests_total{service=\"payment-service\",status=~\"5..\"}[5m])) / sum(rate(http_requests_total{service=\"payment-service\"}[5m]))"
      }]
    },
    {
      "title": "Latency p50/p95/p99",
      "type": "timeseries",
      "gridPos": {"h": 8, "w": 12, "x": 12, "y": 4},
      "targets": [
        {"expr": "histogram_quantile(0.50, rate(http_request_duration_seconds_bucket{service=\"payment-service\"}[5m]))", "legend": "p50"},
        {"expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{service=\"payment-service\"}[5m]))", "legend": "p95"},
        {"expr": "histogram_quantile(0.99, rate(http_request_duration_seconds_bucket{service=\"payment-service\"}[5m]))", "legend": "p99"}
      ]
    }
  ]
}
```

### 3. Golden Signals Four-Part Suite

Every service Dashboard must include:

#### Latency
```promql
# p50/p95/p99 latency
histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

#### Traffic
```promql
# Request rate
sum(rate(http_requests_total[5m])) by (status)
```

#### Errors
```promql
# Error rate
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))
```

#### Saturation
```promql
# CPU utilization
avg(rate(container_cpu_usage_seconds_total[5m])) * 100

# Memory utilization
container_memory_usage_bytes / container_spec_memory_limit_bytes * 100

# Connection pool utilization
mysql_connection_pool_active / mysql_connection_pool_max
```

### 4. SLO Threshold Lines

Mark SLO targets on charts:
- Availability target line: 99.9%
- Latency target line: p95 < 200ms
- Error rate target line: < 0.1%

### 5. Import to Grafana

```bash
# Import via API
curl -X POST http://grafana:3000/api/dashboards/db \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  -H "Content-Type: application/json" \
  -d @dashboard.json
```

Or manage Dashboards via GitOps (recommended):
```
gitops-repo/
└── monitoring/
    └── grafana/
        └── dashboards/
            ├── payment-service-overview.json
            └── payment-service-details.json
```

### 6. Update Monitoring Config Library

Append to `memory/knowledge-base.md`:
```
| Dashboard | URL | Type | Target Audience | Last Updated |
|-----------|-----|------|---------|---------|
| Payment Overview | grafana/d/payment-overview | Overview | Ops | 2026-06-22 |
```

## Prohibitions

- Do not pile up meaningless charts (every Panel must have a purpose)
- Do not use absolute values instead of rates (use rate, not raw counter values)
- Do not hide SLO threshold lines (targets must be visualized)
- Do not expose sensitive data in Dashboards (e.g., user PII)
- Do not create Dashboards no one views (every Dashboard must have an audience)

## Relationship to LOOP

**LOOP type**: none (configuration skill)

This skill is invoked during the PLAN stage of monitoring-setup to generate Dashboard JSON.
It can also be executed as a standalone skill (to optimize existing Dashboards).
