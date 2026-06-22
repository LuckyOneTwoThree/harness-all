---
name: dashboard-design
description: Grafana Dashboard 生成与优化，按服务/层级/角色设计可视化面板
triggers:
  - 需要生成 Grafana Dashboard 时
  - monitoring-setup 部署后设计可视化时
  - Dashboard 需要优化时
  - 用户要求"做个监控面板"时
  - 新服务上线需要 Dashboard 时
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

# Dashboard Design — Grafana Dashboard 生成

## 铁律

1. **面向角色设计** —— 不同角色看不同 Dashboard（运维/开发/业务）
2. **黄金信号优先** —— 延迟/流量/错误/饱和度
3. **阈值线标注** —— SLO 目标线必须可视化
4. **不堆砌图表** —— 每个 Panel 有明确目的

## 流程

### 1. 确定 Dashboard 类型

| 类型 | 目标用户 | 核心指标 |
|------|---------|---------|
| **服务总览** | 运维/管理 | 可用性/错误率/延迟/吞吐 |
| **服务详情** | 开发 | JVM/连接池/慢查询/缓存 |
| **基础设施** | 运维 | CPU/内存/磁盘/网络 |
| **业务监控** | 业务/产品 | 订单量/转化率/营收 |
| **告警视图** | Oncall | 当前告警/历史趋势 |

### 2. 生成 Dashboard JSON

#### 服务总览 Dashboard
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

### 3. 黄金信号四件套

每个服务 Dashboard 必须包含：

#### 延迟（Latency）
```promql
# p50/p95/p99 延迟
histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

#### 流量（Traffic）
```promql
# 请求速率
sum(rate(http_requests_total[5m])) by (status)
```

#### 错误（Errors）
```promql
# 错误率
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))
```

#### 饱和度（Saturation）
```promql
# CPU 使用率
avg(rate(container_cpu_usage_seconds_total[5m])) * 100

# 内存使用率
container_memory_usage_bytes / container_spec_memory_limit_bytes * 100

# 连接池使用率
mysql_connection_pool_active / mysql_connection_pool_max
```

### 4. SLO 阈值线

在图表上标注 SLO 目标：
- 可用性目标线：99.9%
- 延迟目标线：p95 < 200ms
- 错误率目标线：< 0.1%

### 5. 导入到 Grafana

```bash
# 通过 API 导入
curl -X POST http://grafana:3000/api/dashboards/db \
  -H "Authorization: Bearer $GRAFANA_TOKEN" \
  -H "Content-Type: application/json" \
  -d @dashboard.json
```

或通过 GitOps 管理 Dashboard（推荐）：
```
gitops-repo/
└── monitoring/
    └── grafana/
        └── dashboards/
            ├── payment-service-overview.json
            └── payment-service-details.json
```

### 6. 更新监控配置库

`memory/knowledge-base.md` 追加：
```
| Dashboard | URL | 类型 | 目标用户 | 最后更新 |
|-----------|-----|------|---------|---------|
| Payment Overview | grafana/d/payment-overview | 总览 | 运维 | 2026-06-22 |
```

## 禁止事项

- 不堆砌无意义的图表（每个 Panel 必须有目的）
- 不使用绝对值代替速率（用 rate 而非 counter 原值）
- 不隐藏 SLO 阈值线（必须可视化目标）
- 不在 Dashboard 中暴露敏感数据（如用户 PII）
- 不创建无人看的 Dashboard（每个 Dashboard 必须有受众）

## 与 LOOP 的关系

**所属 LOOP 类型**：无（配置类 skill）

本 skill 在 monitoring-setup 的 PLAN 阶段被调用，生成 Dashboard JSON。
也可作为独立 skill 执行（优化现有 Dashboard）。
