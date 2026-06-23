---
name: alerting-rules
description: Alerting rule generation and tuning, defining alert thresholds based on SLOs to prevent alert storms
triggers:
  - When alerting rules need to be configured
  - When alert storms need tuning
  - When alerts need to be generated after SLO definition
  - When configuring alerts after monitoring-setup deployment
  - When the user requests "configure alerts"
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/monitoring/
  - loops/specs/<task-name>/spec.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: propose
requires_approval: false
---

# Alerting Rules — Alerting Rule Generation and Tuning

## Ground Rules

1. **Alerts must be actionable** — every alert must have someone who knows how to handle it
2. **Alerts must have priority** — P0/P1/P2 tiers, with different responses per tier
3. **Alerts must be deduplicated** — do not alert repeatedly on the same issue
4. **Alert thresholds are based on SLOs** — do not set thresholds by feel
5. **Alert storms must be suppressed** — aggregate correlated alerts; do not send one by one

## Process

### 1. Define SLOs (Service Level Objectives)

```
## SLO Definition Example

### payment-service
- Availability SLO: 99.9% (monthly downtime < 43 minutes)
- Latency SLO: p95 < 200ms (95% of requests complete within 200ms)
- Error rate SLO: < 0.1% (proportion of error requests)
- Throughput SLO: > 1000 req/s (minimum throughput)
```

### 2. Generate Alerting Rules

#### PrometheusRule
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: payment-service-alerts
  namespace: production
  labels:
    release: prometheus
spec:
  groups:
  - name: payment-service.rules
    interval: 30s
    rules:
    # P0: service unavailable
    - alert: PaymentServiceDown
      expr: up{job="payment-service"} == 0
      for: 1m
      labels:
        severity: P0
        service: payment-service
      annotations:
        summary: "Payment service is down"
        description: "{{ $labels.instance }} has been down for 1 minute"
        runbook: "https://wiki.example.com/runbooks/payment-down"

    # P0: high error rate
    - alert: PaymentServiceHighErrorRate
      expr: |
        sum(rate(http_requests_total{service="payment-service",status=~"5.."}[5m]))
        / sum(rate(http_requests_total{service="payment-service"}[5m]))
        > 0.05
      for: 2m
      labels:
        severity: P0
        service: payment-service
      annotations:
        summary: "Payment service error rate > 5%"
        description: "Current error rate: {{ $value | humanizePercentage }}"
        runbook: "https://wiki.example.com/runbooks/payment-errors"

    # P1: high latency
    - alert: PaymentServiceHighLatency
      expr: |
        histogram_quantile(0.95,
          rate(http_request_duration_seconds_bucket{service="payment-service"}[5m])
        ) > 0.5
      for: 5m
      labels:
        severity: P1
        service: payment-service
      annotations:
        summary: "Payment service p95 latency > 500ms"
        description: "Current p95: {{ $value }}s"

    # P2: high resource usage
    - alert: PaymentServiceHighCPU
      expr: |
        avg(rate(container_cpu_usage_seconds_total{pod=~"payment-service-.*"}[5m]))
        * 100 > 80
      for: 10m
      labels:
        severity: P2
        service: payment-service
      annotations:
        summary: "Payment service CPU > 80%"
```

### 3. Configure Alertmanager Routing

```yaml
# alertmanager.yaml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname', 'service', 'severity']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  receiver: 'default'
  routes:
  - match:
      severity: P0
    receiver: 'pagerduty-critical'
    group_wait: 0s
    repeat_interval: 1h
  - match:
      severity: P1
    receiver: 'slack-warning'
    group_wait: 1m
    repeat_interval: 2h
  - match:
      severity: P2
    receiver: 'slack-info'
    group_wait: 5m
    repeat_interval: 8h

receivers:
- name: 'pagerduty-critical'
  pagerduty_configs:
  - service_key: '<pagerduty-key>'
- name: 'slack-warning'
  slack_configs:
  - api_url: '<slack-webhook>'
    channel: '#alerts-warning'
- name: 'slack-info'
  slack_configs:
  - api_url: '<slack-webhook>'
    channel: '#alerts-info'
- name: 'default'
  slack_configs:
  - api_url: '<slack-webhook>'
    channel: '#alerts-default'
```

### 4. Alert Inhibition Rules

```yaml
inhibit_rules:
# When a service is down, inhibit other alerts for that service
- source_match:
    alertname: PaymentServiceDown
  target_match:
    service: payment-service
  equal: ['service']

# When a node fails, inhibit Pod alerts on that node
- source_match:
    alertname: NodeDown
  target_match_re:
    pod: '.*'
  equal: ['node']
```

### 5. Alert Tuning

#### Alert Storm Handling
- Identify frequent alerts (same alert > 5 times within 1 hour)
- Adjust the `for` duration (extend to avoid flapping)
- Adjust thresholds (based on historical data)
- Add inhibition rules

#### Alert Quality Audit
```
## Alert Quality Audit (Monthly)

| Alert Name | Trigger Count | False Positive Rate | Avg Handling Time | Needed? |
|--------|---------|--------|------------|---------|
| PaymentServiceDown | 2 | 0% | 5min | Yes |
| PaymentServiceHighCPU | 50 | 80% | - | Tune threshold |
| PaymentServiceHighLatency | 10 | 20% | 15min | Yes |
```

### 6. Update Monitoring Config Library

Append to `memory/knowledge-base.md`:
```
| Alert Rule | Severity | Trigger Condition | Responder | Runbook | Last Tuned |
|---------|--------|---------|--------|---------|---------|
| PaymentServiceDown | P0 | up==0 for 1m | @oncall | /runbooks/down | 2026-06-22 |
```

## Prohibitions

- Do not configure alerts without a runbook (do not alert if no one knows how to handle it)
- Do not configure P0 alerts without notifying humans (P0 must have a human responder)
- Do not configure duplicate alerts without inhibition
- Do not set thresholds by feel (based on SLOs and historical data)
- Do not hardcode webhook URLs in Alertmanager config (use Secrets)

## Relationship to LOOP

**LOOP type**: none (configuration skill)

This skill is invoked during the PLAN stage of monitoring-setup to generate alerting rule config.
It can also be executed as a standalone skill for tuning (optimizing thresholds based on alert history).
