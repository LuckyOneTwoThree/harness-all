---
name: capacity-planning
description: Capacity planning recommendations, forecasting resource needs based on growth trends and planning scale-out in advance
operation_tier: inspect
requires_approval: false
---
# Capacity Planning — Capacity Planning Recommendations

## When to use
- During quarterly capacity planning
- When business growth requires scale-out
- When resource utilization trends consistently high
- During capacity assessment before major campaigns or events
- When the user requests "capacity planning

## Inputs
- docs/infrastructure/OPS_STRATEGY.md
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md

## Outputs
- loops/specs/<task-name>/spec.md
- loops/specs/<task-name>/evidence.md
- memory/knowledge-base.md

## Ground Rules

1. **Forecast based on historical trends** — at least 3 months of data, identify growth trends
2. **Reserve 30% headroom** — never plan to 100% utilization
3. **Distinguish steady-state from peak** — routine capacity vs. campaign capacity
4. **Plan with cost awareness** — do not scale out blindly, consider cost

## Process

### 1. Collect Capacity Data

```promql
# CPU utilization trend over the past 3 months
avg(rate(container_cpu_usage_seconds_total[3m])) by (service)

# Memory utilization trend over the past 3 months
avg(container_memory_working_set_bytes / container_spec_memory_limit_bytes) by (service)

# Traffic trend over the past 3 months
sum(rate(http_requests_total[5m])) by (service)

# Storage growth over the past 3 months
sum(kubelet_volume_stats_used_bytes) by (persistentvolumeclaim)
```

### 2. Analyze Growth Trends

```
## Capacity Trend Analysis

### payment-service

#### Traffic Growth
| Month | Daily Avg Requests | MoM Growth | Cumulative Growth |
|------|---------|--------|---------|
| 2026-03 | 1.2M | - | - |
| 2026-04 | 1.5M | +25% | +25% |
| 2026-05 | 1.8M | +20% | +50% |
| 2026-06 (forecast) | 2.2M | +22% | +83% |

#### Resource Utilization
| Month | CPU Utilization | Memory Utilization | Replicas |
|------|----------|-----------|--------|
| 2026-03 | 35% | 50% | 3 |
| 2026-04 | 42% | 55% | 3 |
| 2026-05 | 50% | 62% | 4 |
| 2026-06 (current) | 58% | 68% | 4 |

#### Trend Forecast
- At the current growth rate, CPU utilization will reach 85% in 3 months
- At the current growth rate, memory utilization will reach 80% in 3 months
- Recommendation: scale to 6 replicas within 3 months
```

### 3. Identify Capacity Bottlenecks

```
## Capacity Bottleneck Identification

### 1. CPU Bottleneck (within 3 months)
- Current: 4 replicas * 500m = 2000m
- Demand in 3 months: estimated 3000m
- Bottleneck: insufficient total cluster CPU
- Recommendation: expand node pool or optimize code

### 2. Memory Bottleneck (within 6 months)
- Current: 4 replicas * 512Mi = 2048Mi
- Demand in 6 months: estimated 2800Mi
- Bottleneck: per-Pod memory limit
- Recommendation: raise limits or scale out replicas

### 3. Database Connection Bottleneck (imminent)
- Current connection pool: 100
- Peak usage: 85
- Bottleneck: connection pool near exhaustion
- Recommendation: immediately scale connection pool to 200

### 4. Storage Bottleneck (within 12 months)
- Current: 500GB
- Monthly growth: 30GB
- In 12 months: 860GB
- Bottleneck: disk capacity
- Recommendation: plan a data archival strategy
```

### 4. Produce Capacity Plan

```
## Capacity Planning Report

### Short-term (1-3 months)
1. [Immediate] Scale database connection pool 100 → 200
2. [1 month] Scale payment-service 4 → 6 replicas
3. [2 months] Expand cluster node pool by +2 nodes

### Mid-term (3-6 months)
4. [3 months] Upgrade RDS instance (db.r5.large → db.r5.xlarge)
5. [4 months] Scale Redis cluster
6. [5 months] Expand storage 500GB → 1TB

### Long-term (6-12 months)
7. [6 months] Evaluate multi-cluster architecture
8. [9 months] Build data archival system
9. [12 months] Disaster recovery with active-active across regions

### Campaign / Event Specific
- Double 11 forecast traffic: 3x daily traffic
- Required temporary scale-out: payment-service 6 → 12 replicas
- Database: upgrade to db.r5.2xlarge
- Budget: additional ¥10,000/day
```

### 5. Cost Estimate

```
## Capacity Planning Cost Estimate

| Item | Current Monthly Cost | Planned Monthly Cost | Increment | Timeline |
|------|-----------|-------------|------|------|
| payment-service scale-out | ¥1,200 | ¥1,800 | +¥600 | 1 month |
| Cluster node expansion | ¥8,000 | ¥10,000 | +¥2,000 | 2 months |
| RDS upgrade | ¥3,000 | ¥5,000 | +¥2,000 | 3 months |
| Redis scale-out | ¥800 | ¥1,500 | +¥700 | 4 months |
| Storage expansion | ¥500 | ¥1,000 | +¥500 | 5 months |
| **Total** | **¥13,500** | **¥19,300** | **+¥5,800** | 5 months |
```

### 6. Update Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Plan Date | Time Range | Current Capacity | Planned Capacity | Cost Increment | Primary Bottleneck |
|---------|---------|---------|---------|---------|---------|
| 2026-06-22 | 3-12 months | 4 replicas/500GB | 6 replicas/1TB | +¥5,800/month | CPU + DB connections |
```

## Prohibitions

- Do not make long-term plans based on less than 3 months of data
- Do not plan to 100% utilization (must keep 30% headroom)
- Do not consider only the present without factoring in growth
- Do not scale out blindly without considering cost

## Relationship to LOOP

**LOOP type**: none (planning skill, not a loop)

This skill produces a planning report for human decision-making.
Scale-out execution is handled by deployment-pipeline / infrastructure-as-code.
