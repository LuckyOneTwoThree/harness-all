---
name: monitoring-setup
description: Prometheus/Grafana monitoring stack deployment, the four-part suite of collectors / storage / alerting / visualization
triggers:
  - When a new service needs monitoring configured
  - When Prometheus/Grafana needs to be deployed
  - When the monitoring stack is missing and needs to be built
  - When OPS_STRATEGY.md defines monitoring standards
  - When monitoring-deployment-workflow triggers
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

# Monitoring Setup — Monitoring Stack Deployment

## Ground Rules

1. **No monitoring, no go-live** — services must have basic monitoring before going live
2. **All three signals present** — Metrics + Logs + Traces, none can be missing
3. **Alerts must be meaningful** — no noise; every alert needs a responder
4. **Dashboards are user-facing** — not debug info for developers, but decision support for ops

## Process

### 1. Assess Monitoring Requirements

Read the monitoring/alerting matrix in `OPS_STRATEGY.md`:
- Business gateway: HTTP error rate / latency / throughput
- Database tier: connections / slow queries / replication lag
- Hosts/Pods: CPU / memory / disk / network
- Business logs: ERROR rate / key business events

Determine the monitoring stack:
- **Metrics**: Prometheus + Alertmanager
- **Logs**: Loki + Promtail / Elasticsearch + Fluentd
- **Traces**: Tempo / Jaeger
- **Visualization**: Grafana

### 2. Deploy Prometheus Collection

#### ServiceMonitor (Prometheus Operator)
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: payment-service
  namespace: production
  labels:
    release: prometheus
spec:
  selector:
    matchLabels:
      app: payment-service
  endpoints:
  - port: metrics
    interval: 30s
    path: /metrics
```

#### Application Instrumentation Recommendations
```python
# Metrics the application must expose
- http_requests_total{method, path, status}  # total requests
- http_request_duration_seconds{method, path}  # request latency
- http_inprogress_requests  # in-flight requests
- app_business_events_total{event_type}  # business events
```

### 3. Configure Alerting Rules

Invoke the `alerting-rules` skill to generate alerting rules.

### 4. Deploy Log Collection

#### Promtail (Loki collector)
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: promtail
  namespace: monitoring
spec:
  template:
    spec:
      containers:
      - name: promtail
        image: grafana/promtail:latest
        args:
        - -config.file=/etc/promtail/promtail.yaml
        volumeMounts:
        - name: logs
          mountPath: /var/log
        - name: config
          mountPath: /etc/promtail
      volumes:
      - name: logs
        hostPath:
          path: /var/log
```

#### Promtail Config
```yaml
# promtail.yaml
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://loki:3100/loki/api/v1/push
scrape_configs:
  - job_name: kubernetes-pods
    kubernetes_sd_configs:
    - role: pod
    relabel_configs:
    - source_labels: [__meta_kubernetes_namespace]
      target_label: namespace
    - source_labels: [__meta_kubernetes_pod_label_app]
      target_label: app
```

### 5. Deploy Distributed Tracing

#### OpenTelemetry Collector
```yaml
apiVersion: opentelemetry.io/v1alpha1
kind: OpenTelemetryCollector
metadata:
  name: otel-collector
  namespace: monitoring
spec:
  config:
    receivers:
      otlp:
        protocols:
          grpc:
          http:
    exporters:
      tempo:
        endpoint: tempo:4317
        tls:
          insecure: true
    service:
      pipelines:
        traces:
          receivers: [otlp]
          exporters: [tempo]
```

### 6. Deploy Grafana

#### Grafana DataSource
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasources
  namespace: monitoring
data:
  datasources.yaml: |
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus:9090
      access: proxy
      isDefault: true
    - name: Loki
      type: loki
      url: http://loki:3100
      access: proxy
    - name: Tempo
      type: tempo
      url: http://tempo:3200
      access: proxy
```

Invoke the `dashboard-design` skill to generate Dashboards.

### 7. Verify the Monitoring Stack

- All Prometheus targets up
- Application metrics queryable
- Logs queryable (Loki)
- Traces queryable (Tempo)
- Grafana Dashboard accessible
- Alerting rules can trigger

### 8. Update Monitoring Config Library

Append to `memory/knowledge-base.md`:
```
| Service | Metrics Endpoint | Log Label | Dashboard URL | Alerting Rules | Deploy Date |
|------|-------------|---------|--------------|---------|---------|
| payment-service | :8080/metrics | app=payment-service | grafana/d/payment | payment-alerts | 2026-06-22 |
```

## Prohibitions

- Do not go live with a service that has no monitoring
- Do not configure meaningless alerts (e.g., "CPU > 50%")
- Do not deploy log collectors as Deployments (must be DaemonSet)
- Do not store plaintext datasource passwords in Grafana
- Do not claim "deployment complete" without monitoring verification

## Relationship to LOOP

**LOOP type**: provision

```
LOOP(provision):
  PLAN:       Assess monitoring requirements → generate config
  PROVISION:  Deploy Prometheus/Loki/Tempo/Grafana
  VERIFY:     Verify collection + query + alerting + visualization
  Pass? DONE : Fix config → back to PROVISION
```
