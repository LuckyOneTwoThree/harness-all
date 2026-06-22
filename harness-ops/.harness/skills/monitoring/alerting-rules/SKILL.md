---
name: alerting-rules
description: 告警规则生成与调优，基于 SLO 定义告警阈值，避免告警风暴
triggers:
  - 需要配置告警规则时
  - 告警风暴需要调优时
  - SLO 定义后需要生成告警时
  - monitoring-setup 部署后配置告警时
  - 用户要求"配置告警"时
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

# Alerting Rules — 告警规则生成与调优

## 铁律

1. **告警必须可执行** —— 每个告警都要有人知道怎么处理
2. **告警必须有优先级** —— P0/P1/P2 分级，不同级别不同响应
3. **告警必须去重** —— 同一问题不重复告警
4. **告警阈值基于 SLO** —— 不凭感觉设阈值
5. **告警风暴必须抑制** —— 关联告警聚合，不逐条发送

## 流程

### 1. 定义 SLO（Service Level Objective）

```
## SLO 定义示例

### payment-service
- 可用性 SLO: 99.9%（每月宕机 < 43 分钟）
- 延迟 SLO: p95 < 200ms（95% 请求在 200ms 内完成）
- 错误率 SLO: < 0.1%（错误请求占比）
- 吞吐量 SLO: > 1000 req/s（最低吞吐）
```

### 2. 生成告警规则

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
    # P0: 服务不可用
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

    # P0: 高错误率
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

    # P1: 高延迟
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

    # P2: 资源使用高
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

### 3. 配置 Alertmanager 路由

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

### 4. 告警抑制规则

```yaml
inhibit_rules:
# 服务下线时，抑制该服务的其他告警
- source_match:
    alertname: PaymentServiceDown
  target_match:
    service: payment-service
  equal: ['service']

# 节点故障时，抑制该节点上的 Pod 告警
- source_match:
    alertname: NodeDown
  target_match_re:
    pod: '.*'
  equal: ['node']
```

### 5. 告警调优

#### 告警风暴处理
- 识别频繁告警（同一告警 1 小时内 > 5 次）
- 调整 `for` 持续时间（延长避免抖动）
- 调整阈值（基于历史数据）
- 添加抑制规则

#### 告警质量审计
```
## 告警质量审计（每月）

| 告警名 | 触发次数 | 误报率 | 平均处理时间 | 是否需要 |
|--------|---------|--------|------------|---------|
| PaymentServiceDown | 2 | 0% | 5min | 是 |
| PaymentServiceHighCPU | 50 | 80% | - | 调优阈值 |
| PaymentServiceHighLatency | 10 | 20% | 15min | 是 |
```

### 6. 更新监控配置库

`memory/knowledge-base.md` 追加：
```
| 告警规则 | 严重度 | 触发条件 | 响应人 | Runbook | 最后调优 |
|---------|--------|---------|--------|---------|---------|
| PaymentServiceDown | P0 | up==0 for 1m | @oncall | /runbooks/down | 2026-06-22 |
```

## 禁止事项

- 不配置无 runbook 的告警（不知道怎么处理就别告）
- 不配置 P0 告警不通知人类（P0 必须有人响应）
- 不配置重复告警不抑制
- 不凭感觉设阈值（基于 SLO 和历史数据）
- 不在 Alertmanager 配置中硬编码 webhook URL（用 Secret）

## 与 LOOP 的关系

**所属 LOOP 类型**：无（配置类 skill）

本 skill 在 monitoring-setup 的 PLAN 阶段被调用，生成告警规则配置。
调优时可作为独立 skill 执行（基于告警历史数据优化阈值）。
