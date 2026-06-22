---
name: sla-report
description: SLA 计算与报告，基于监控数据计算可用性，生成 SLA 达成报告
triggers:
  - 月度 SLA 报告时
  - 用户要求"计算 SLA"时
  - SLA 未达标需要分析时
  - ops-review 需要数据支撑时
  - 合同/合规需要 SLA 证明时
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

# SLA Report — SLA 计算与报告

## 铁律

1. **SLA 基于监控数据** —— 不估算，用 Prometheus 实际数据
2. **SLA 计算有明确公式** —— 可复现，可审计
3. **SLA 未达标必须分析** —— 不只报数字，给原因
4. **SLA 报告可对外** —— 可能用于合同/合规

## 流程

### 1. 定义 SLA 指标

```
## SLA 指标定义

### 可用性（Availability）
- 公式: (总时间 - 不可用时间) / 总时间 * 100%
- 不可用定义: 错误率 > 5% 持续 > 1 分钟
- 目标: 99.9%（每月不可用 < 43.2 分钟）

### 延迟（Latency）
- 公式: p95 延迟
- 目标: p95 < 200ms

### 错误率（Error Rate）
- 公式: 5xx 请求数 / 总请求数
- 目标: < 0.1%
```

### 2. 计算 SLA

```promql
# 可用性计算（本月）
1 - (
  sum(rate(http_requests_total{service="payment-service",status=~"5.."}[30d]))
  / sum(rate(http_requests_total{service="payment-service"}[30d]))
)

# 不可用时间计算
sum(count_over_time(
  (sum(rate(http_requests_total{status=~"5.."}[1m])) / sum(rate(http_requests_total[1m])) > 0.05)[30d:]
)) * 60

# p95 延迟（本月平均）
avg(histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[30d])))

# 错误率（本月）
sum(rate(http_requests_total{status=~"5.."}[30d])) / sum(rate(http_requests_total[30d]))
```

### 3. 生成 SLA 报告

```
## SLA 月度报告（2026年5月）

### 服务级 SLA

| 服务 | 可用性 | 目标 | 达成? | 不可用时间 | p95延迟 | 延迟目标 | 错误率 | 错误目标 |
|------|--------|------|-------|-----------|---------|---------|--------|---------|
| payment-service | 99.92% | 99.9% | ✓ | 34min | 180ms | 200ms | 0.08% | 0.1% |
| order-service | 99.99% | 99.9% | ✓ | 4min | 95ms | 200ms | 0.01% | 0.1% |
| user-service | 99.85% | 99.9% | ✗ | 65min | 350ms | 200ms | 0.15% | 0.1% |

### 整体 SLA
- 平均可用性: 99.92%
- 目标: 99.9%
- 达成: ✓（但 user-service 未达标）

### SLA 未达标分析

#### user-service（99.85% vs 目标 99.9%）
- 不可用时间: 65 分钟
- 主要事件:
  1. 2026-05-15: Redis 连接池耗尽（25min）
  2. 2026-05-22: 部署失败回滚（20min）
  3. 2026-05-28: 数据库慢查询（20min）
- 根因: 资源配置不足 + 依赖服务不稳定
- 改进: 扩容 + 优化慢查询 + 调整部署策略
```

### 4. 生成 SLA 趋势

```
## SLA 趋势（近 6 个月）

| 月份 | payment | order | user | 整体 |
|------|---------|-------|------|------|
| 2025-12 | 99.95% | 99.98% | 99.92% | 99.95% |
| 2026-01 | 99.93% | 99.99% | 99.90% | 99.94% |
| 2026-02 | 99.96% | 99.97% | 99.88% | 99.94% |
| 2026-03 | 99.94% | 99.99% | 99.91% | 99.95% |
| 2026-04 | 99.95% | 99.98% | 99.99% | 99.97% |
| 2026-05 | 99.92% | 99.99% | 99.85% | 99.92% |

### 趋势分析
- payment-service: 稳定在 99.9%+，本月略降
- order-service: 持续优秀
- user-service: 波动较大，本月未达标，需重点关注
```

### 5. 写入报告

写入 `docs/monitoring/sla-report-2026-05.md`。

### 6. 更新知识库

`memory/knowledge-base.md` 追加：
```
| 月份 | 整体SLA | 目标 | 达成 | 未达标服务 | 主要原因 |
|------|---------|------|------|-----------|---------|
| 2026-05 | 99.92% | 99.9% | ✓ | user-service | Redis+部署+慢查询 |
```

## 禁止事项

- 不基于估算计算 SLA（必须用监控数据）
- 不篡改 SLA 数据
- 不隐瞒 SLA 未达标
- 不在报告中包含用户 PII

## 与 LOOP 的关系

**所属 LOOP 类型**：无（报告类 skill）

本 skill 产出 SLA 报告，供 ops-review 引用。
通常月度执行，或用户显式要求时执行。
