---
name: monitoring-setup
description: Prometheus/Grafana 监控体系部署，采集器/存储/告警/可视化四件套
triggers:
  - 新服务需要配置监控时
  - 需要部署 Prometheus/Grafana 时
  - 监控体系缺失需要搭建时
  - OPS_STRATEGY.md 定义监控规范时
  - monitoring-deployment-workflow 触发时
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

# Monitoring Setup — 监控体系部署

## 铁律

1. **无监控不上线** —— 服务上线前必须有基础监控
2. **三大信号齐全** —— Metrics + Logs + Traces 缺一不可
3. **告警必须有意义** —— 不告噪，每个告警都需要有人响应
4. **Dashboard 面向用户** —— 不是给开发者看的调试信息，是给运维决策的

## 流程

### 1. 评估监控需求

读取 `OPS_STRATEGY.md` 的监控告警矩阵：
- 业务网关：HTTP 错误率/延迟/吞吐
- 数据库层：连接数/慢查询/复制延迟
- 主机/Pod：CPU/内存/磁盘/网络
- 业务日志：ERROR 率/关键业务事件

确定监控栈：
- **Metrics**：Prometheus + Alertmanager
- **Logs**：Loki + Promtail / Elasticsearch + Fluentd
- **Traces**：Tempo / Jaeger
- **可视化**：Grafana

### 2. 部署 Prometheus 采集

#### ServiceMonitor（Prometheus Operator）
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

#### 应用埋点建议
```python
# 应用必须暴露的指标
- http_requests_total{method, path, status}  # 请求总数
- http_request_duration_seconds{method, path}  # 请求延迟
- http_inprogress_requests  # 当前进行中的请求
- app_business_events_total{event_type}  # 业务事件
```

### 3. 配置告警规则

调用 `alerting-rules` skill 生成告警规则。

### 4. 部署日志采集

#### Promtail（Loki 采集器）
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

#### Promtail 配置
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

### 5. 部署链路追踪

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

### 6. 部署 Grafana

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

调用 `dashboard-design` skill 生成 Dashboard。

### 7. 验证监控体系

- Prometheus targets 都 up
- 应用指标可查询
- 日志可查询（Loki）
- 链路可追踪（Tempo）
- Grafana Dashboard 可访问
- 告警规则可触发

### 8. 更新监控配置库

`memory/knowledge-base.md` 追加：
```
| 服务 | Metrics 端点 | 日志标签 | Dashboard URL | 告警规则 | 部署日期 |
|------|-------------|---------|--------------|---------|---------|
| payment-service | :8080/metrics | app=payment-service | grafana/d/payment | payment-alerts | 2026-06-22 |
```

## 禁止事项

- 不在无监控的情况下上线服务
- 不配置无意义的告警（"CPU > 50%" 这种）
- 不将日志采集器部署为 Deployment（必须 DaemonSet）
- 不在 Grafana 存储明文数据源密码
- 不跳过监控验证就声称"部署完成"

## 与 LOOP 的关系

**所属 LOOP 类型**：provision

```
LOOP(provision):
  PLAN:       评估监控需求 → 生成配置
  PROVISION:  部署 Prometheus/Loki/Tempo/Grafana
  VERIFY:     验证采集+查询+告警+可视化
  通过? DONE : 修复配置 → 回到 PROVISION
```
