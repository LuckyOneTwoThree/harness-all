# monitoring-alert-detection Examples

> This document is split from the monitoring-alert-detection SKILL.md and contains all YAML configuration examples for alert rules, classification, correlation, dashboards, escalation, notifications, and on-call reports.

## Alert Rule Parameters

```yaml
alert_rule:
  name: api_response_time_p95_alert
  severity: critical | high | medium | low
  threshold:
    operator: > | < | >= | <=
    value: 2000
  baseline:
    method: historical | moving_average | seasonal
    window: 7d | 30d | custom
    deviation: 3σ
  sensitivity: high | medium | low
  evaluation_interval: 1m
  for: 5m
```

## Alert Classification Output

```yaml
classification:
  layer: system | application | business | external
  category: database
  confidence: 0.0-1.0
  related_alerts: [ALT-001, ALT-002]
```

## Correlation Analysis Output

```yaml
correlation:
  is_correlated: true | false
  correlation_type: time | topology | metrics | change
  related_alerts: [ALT-001, ALT-002]
  correlation_score: 0.0-1.0
  root_alert: ALT-001 | null
```

## Role Requirement Mapping

```yaml
role_requirements:
  - role: executive
    focus_areas:
      - business_health
      # ... same structure extensible
    alert_preference: critical_only
    refresh_rate: 15m
  # ... same structure extensible
```

## Metric Grouping Output

```yaml
metric_groups:
  - group_id: GRP-001
    group_name: Core Business Metrics
    role: executive
    metrics:
      - metric_name: api_response_time_p95
        data_source: apm
        visualization: time_series
      # ... same structure extensible
    priority: high | medium | low
    refresh_interval: 15
```

## Visualization Component Config

```yaml
widget_config:
  - widget_id: WDG-001
    widget_type: time_series | gauge | stat | table | alert_list | heatmap
    title: API Response Time Trend
    metrics:
      - name: api_response_time_p95
        aggregation: avg | sum | max | min
    visualization:
      color_scheme: green_yellow_red | blue | custom
      thresholds:
        warning: 1000
        critical: 2000
      time_range: 1h | 6h | 24h | 7d | custom
    layout:
      width: 1 | 2 | 4 | 6 | 12
      height: 1 | 2 | 3
      position: 1_2
```

## Dashboard Template Structure

```yaml
dashboard_template:
  - dashboard_id: DASH-001
    role: executive
    title: Business Overview
    description: Business health view for senior management
    widgets:
      - widget_id: WDG-001
        widget_type: stat
        title: Today's Order Volume
        metrics:
          - name: daily_orders
            data_source: business_db
        layout:
          width: 3
          height: 1
      # ... same structure extensible
    filters:
      - filter_type: time_range
        default: 7d
      # ... same structure extensible
    refresh_interval: 15m
```

## Alert Severity Grading Model

```yaml
alert_severity:
  critical:
    criteria:
      - service_availability < 99%
      - error_rate > 5%
      - response_time_p99 > 5000ms
      - affected_users > 10000
    response_time_sla: 5 minutes
  high:
    criteria:
      - service_availability < 99.5%
      - error_rate > 1%
      - response_time_p99 > 2000ms
      - affected_users > 1000
    response_time_sla: 15 minutes
  medium:
    criteria:
      - service_availability < 99.9%
      - error_rate > 0.5%
      - response_time_p99 > 1000ms
    response_time_sla: 1 hour
  low:
    criteria:
      - non_functional_metrics
      - warning_thresholds
    response_time_sla: next_business_day
```

## Severity Grading Output

```yaml
alert_classification:
  alert_id: ALT-001
  original_severity: high
  assessed_severity: critical
  confidence: 85%
  factors:
    - factor: service_impact
      contribution: 0.8
    # ... same structure extensible
  adjusted: true | false
  adjustment_reason: Affected users exceed 10,000, escalated to critical
```

## Escalation Rules

```yaml
escalation_rules:
  - rule_id: ESC-001
    trigger:
      severity: critical
      duration: 5 minutes
      not_acknowledged: true
    escalation_chain:
      - level: 1
        recipients: [oncall_primary]
        notification_channels: [sms, call, slack]
      # ... same structure extensible
  # ... same structure extensible
```

## Escalation Execution Output

```yaml
escalation_chain:
  alert_id: ALT-001
  current_level: 1
  escalation_history:
    - timestamp: 2026-06-15T10:05:00Z
      level: 1
      action: initial_notification
      recipients: [Zhang San]
      status: sent | delivered | acknowledged
  next_escalation:
    timestamp: 2026-06-15T10:10:00Z
    level: 2
    trigger_reason: Not acknowledged within 5 minutes, escalating to L2
```

## Notification Template

```yaml
notification:
  channels:
    - channel: sms
      content: |
        [CRITICAL] Order Service
        Response time P99 exceeds 5 seconds, affecting 5,000 users
        Details: https://monitor.example.com/alerts/ALT-001
    # ... same structure extensible
```

## Notification Send Status

```yaml
notification_status:
  alert_id: ALT-001
  notifications:
    - channel: sms
      recipient: 13800138000
      status: sent | delivered | failed
      sent_at: 2026-06-15T10:05:00Z
    # ... same structure extensible
  acknowledgment:
    required: true | false
    acknowledged_by: Zhang San
    acknowledged_at: 2026-06-15T10:08:00Z
```

## On-Call Report

```yaml
oncall_report:
  period:
    start: 2026-06-08T00:00:00Z
    end: 2026-06-15T00:00:00Z
  oncall_engineer:
    name: Li Si
    primary: true
  summary:
    total_alerts: 24
    critical: 2
    high: 5
    medium: 10
    low: 7
  response_metrics:
    average_acknowledgment_time: 3
    average_resolution_time: 45
    sla_compliance: 95%
  top_alerts:
    - alert_id: ALT-001
      severity: critical
      title: Order service response timeout
      acknowledged_at: 2026-06-15T10:08:00Z
      resolved_at: 2026-06-15T10:45:00Z
  unresolved_alerts:
    - alert_id: ALT-018
      severity: medium
      reason: Pending root cause confirmation, transferred to backend team
  action_items:
    - description: Optimize database connection pool config
      owner: Wang Wu
      deadline: 2026-06-20
```
