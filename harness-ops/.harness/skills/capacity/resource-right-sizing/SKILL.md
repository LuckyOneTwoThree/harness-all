---
name: resource-right-sizing
description: 资源右 sizing 建议，基于 Prometheus 数据分析 Pod 资源使用，推荐最优 requests/limits
triggers:
  - 定期资源优化时
  - 成本优化需要右 sizing 时
  - Pod 资源使用率持续偏低/偏高时
  - 用户要求"优化资源"时
  - optimization LOOP 触发时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<task-name>/spec.md
  - loops/specs/<task-name>/evidence.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: inspect
requires_approval: false
---

# Resource Right Sizing — 资源右 sizing 建议

## 铁律

1. **基于数据，不基于猜测** —— 至少 7 天的 Prometheus 数据
2. **留有余量** —— 推荐值不超过实际使用的 80%（留 20% 余量）
3. **不牺牲稳定性** —— 资源压缩不能导致 OOM/性能下降
4. **分批调整** —— 不一次性大幅调整，逐步收敛

## 流程

### 1. 收集资源使用数据

查询 Prometheus（至少 7 天）：

```promql
# CPU 使用率（按 Pod）
avg(rate(container_cpu_usage_seconds_total{pod=~"payment-service-.*"}[7d])) by (pod)

# 内存使用率（按 Pod）
avg(container_memory_working_set_bytes{pod=~"payment-service-.*"}[7d] / container_spec_memory_limit_bytes{pod=~"payment-service-.*"}) by (pod)

# CPU 峰值
max(rate(container_cpu_usage_seconds_total{pod=~"payment-service-.*"}[7d])) by (pod)

# 内存峰值
max(container_memory_working_set_bytes{pod=~"payment-service-.*"}[7d]) by (pod)
```

### 2. 分析资源使用模式

```
## 资源使用分析

### payment-service（3 副本）

| 指标 | 当前配置 | 平均使用 | 峰值使用 | 利用率 |
|------|---------|---------|---------|--------|
| CPU requests | 200m | 50m | 120m | 25% |
| CPU limits | 500m | - | - | - |
| Memory requests | 256Mi | 180Mi | 220Mi | 70% |
| Memory limits | 512Mi | - | - | - |

### 分析
- CPU 利用率偏低（25%），requests 可下调
- 内存利用率合理（70%），保持不变
- 峰值 CPU 120m，当前 limits 500m 过高

### 推荐
| 指标 | 当前 | 推荐 | 节省 |
|------|------|------|------|
| CPU requests | 200m | 100m | 50% |
| CPU limits | 500m | 300m | 40% |
| Memory requests | 256Mi | 256Mi | 0% |
| Memory limits | 512Mi | 512Mi | 0% |
```

### 3. 生成右 sizing 建议

```yaml
# 推荐资源配置
resources:
  requests:
    cpu: 100m      # 原 200m，基于峰值 120m + 20% 余量
    memory: 256Mi   # 保持不变
  limits:
    cpu: 300m      # 原 500m，基于峰值 120m * 2.5
    memory: 512Mi   # 保持不变
```

### 4. 生成 GitOps PR

```
## 右 sizing PR: payment-service

### 变更
- CPU requests: 200m → 100m
- CPU limits: 500m → 300m

### 数据支撑
- 7 天平均 CPU 使用: 50m
- 7 天峰值 CPU 使用: 120m
- 推荐依据: 峰值 * 1.2 余量 = 144m → 取整 150m

### 预期收益
- 单 Pod 节省: 100m CPU
- 3 副本总节省: 300m CPU
- 集群可多调度: 1-2 个 Pod

### 风险
- 低风险（基于 7 天数据，留有 20% 余量）
- 如 CPU 飙升，HPA 会自动扩容
```

### 5. 验证调整效果

调整后持续观察 7 天：
- CPU 使用率是否上升（预期会上升，因 requests 降低）
- 是否出现 CPU throttling
- 是否影响性能指标（延迟/错误率）
- HPA 是否正常触发

### 6. 更新知识库

`memory/knowledge-base.md` 追加：
```
| 服务 | 资源类型 | 调整前 | 调整后 | 节省比例 | 数据周期 | 调整日期 |
|------|---------|--------|--------|---------|---------|---------|
| payment-service | CPU requests | 200m | 100m | 50% | 7d | 2026-06-22 |
```

## 禁止事项

- 不基于不足 7 天的数据做推荐
- 不将资源压缩到峰值以下（必须留余量）
- 不一次性大幅调整（单次调整不超过 50%）
- 不调整后不验证（必须持续观察）

## 与 LOOP 的关系

**所属 LOOP 类型**：optimization

```
LOOP(optimization):
  PLAN:       收集数据 → 分析使用模式 → 生成建议
  PROVISION:  提交 GitOps PR → 调整资源配置
  VERIFY:     观察 7 天 → 确认无负面影响
  通过? DONE : 回滚调整 → 重新分析
```
