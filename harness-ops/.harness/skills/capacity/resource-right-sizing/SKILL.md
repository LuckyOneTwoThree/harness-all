---
name: resource-right-sizing
description: Resource right-sizing recommendations, analyzing Pod resource usage based on Prometheus data and recommending optimal requests/limits
operation_tier: inspect
requires_approval: false
---
# Resource Right Sizing — Resource Right-Sizing Recommendations

## When to use
- During periodic resource optimization
- When cost optimization requires right-sizing
- When Pod resource utilization is persistently low/high
- When the user requests "optimize resources
- When the optimization LOOP triggers

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

1. **Data-driven, not guesswork** — at least 7 days of Prometheus data
2. **Keep headroom** — recommended values must not exceed 80% of actual usage (keep 20% headroom)
3. **Do not sacrifice stability** — resource compression must not cause OOM or performance degradation
4. **Adjust in batches** — do not make large adjustments all at once, converge gradually

## Process

### 1. Collect Resource Usage Data

Query Prometheus (at least 7 days):

```promql
# CPU utilization (by Pod)
avg(rate(container_cpu_usage_seconds_total{pod=~"payment-service-.*"}[7d])) by (pod)

# Memory utilization (by Pod)
avg(container_memory_working_set_bytes{pod=~"payment-service-.*"}[7d] / container_spec_memory_limit_bytes{pod=~"payment-service-.*"}) by (pod)

# CPU peak
max(rate(container_cpu_usage_seconds_total{pod=~"payment-service-.*"}[7d])) by (pod)

# Memory peak
max(container_memory_working_set_bytes{pod=~"payment-service-.*"}[7d]) by (pod)
```

### 2. Analyze Resource Usage Patterns

```
## Resource Usage Analysis

### payment-service (3 replicas)

| Metric | Current Config | Avg Usage | Peak Usage | Utilization |
|------|---------|---------|---------|--------|
| CPU requests | 200m | 50m | 120m | 25% |
| CPU limits | 500m | - | - | - |
| Memory requests | 256Mi | 180Mi | 220Mi | 70% |
| Memory limits | 512Mi | - | - | - |

### Analysis
- CPU utilization is low (25%), requests can be lowered
- Memory utilization is reasonable (70%), keep unchanged
- Peak CPU is 120m, current limits of 500m is too high

### Recommendation
| Metric | Current | Recommended | Savings |
|------|------|------|------|
| CPU requests | 200m | 100m | 50% |
| CPU limits | 500m | 300m | 40% |
| Memory requests | 256Mi | 256Mi | 0% |
| Memory limits | 512Mi | 512Mi | 0% |
```

### 3. Produce Right-Sizing Recommendations

```yaml
# Recommended resource configuration
resources:
  requests:
    cpu: 100m      # was 200m, based on peak 120m + 20% headroom
    memory: 256Mi   # keep unchanged
  limits:
    cpu: 300m      # was 500m, based on peak 120m * 2.5
    memory: 512Mi   # keep unchanged
```

### 4. Produce a GitOps PR

```
## Right-Sizing PR: payment-service

### Changes
- CPU requests: 200m → 100m
- CPU limits: 500m → 300m

### Data Backing
- 7-day average CPU usage: 50m
- 7-day peak CPU usage: 120m
- Recommendation basis: peak * 1.2 headroom = 144m → round to 150m

### Expected Benefits
- Per-Pod savings: 100m CPU
- 3 replicas total savings: 300m CPU
- Cluster can schedule 1-2 more Pods

### Risk
- Low risk (based on 7-day data, with 20% headroom)
- If CPU spikes, HPA will auto-scale
```

### 5. Verify Adjustment Effects

Continuously observe for 7 days after adjustment:
- Whether CPU utilization rises (expected to rise since requests are lowered)
- Whether CPU throttling occurs
- Whether performance metrics are affected (latency/error rate)
- Whether HPA triggers normally

### 6. Update Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Service | Resource Type | Before | After | Savings Ratio | Data Window | Adjustment Date |
|------|---------|--------|--------|---------|---------|---------|
| payment-service | CPU requests | 200m | 100m | 50% | 7d | 2026-06-22 |
```

## Prohibitions

- Do not make recommendations based on less than 7 days of data
- Do not compress resources below peak (must keep headroom)
- Do not make large adjustments all at once (single adjustment must not exceed 50%)
- Do not skip verification after adjustment (must observe continuously)

## Relationship to LOOP

**LOOP type**: optimization

```
LOOP(optimization):
  PLAN:       Collect data → analyze usage patterns → produce recommendations
  PROVISION:  Submit GitOps PR → adjust resource configuration
  VERIFY:     Observe for 7 days → confirm no negative impact
  Pass? DONE : Roll back adjustment → re-analyze
```
