---
name: disaster-recovery-plan
description: Disaster recovery plan design, defining RTO/RPO targets, multi-AZ strategy, degradation plans, and cross-region disaster recovery
triggers:
  - When formulating a disaster recovery plan
  - When OPS_STRATEGY.md defines disaster recovery strategy
  - When business growth requires improved disaster recovery capabilities
  - When planning disaster recovery drills
  - When the user requests "design a disaster recovery plan"
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/infrastructure/disaster-recovery-plan.md
  - loops/specs/<task-name>/spec.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
operation_tier: propose
requires_approval: false
---

# Disaster Recovery Plan — Disaster Recovery Plan Design

## Ground Rules

1. **Disaster recovery has clear targets** — RTO/RPO must be quantified
2. **Tiered disaster recovery** — core services are highly available; non-core services can be degraded
3. **Disaster recovery is drillable** — cannot just be on paper; must be executable
4. **Disaster recovery is cost-aware** — do not blindly pursue the highest tier

## Process

### 1. Define Service Tiers

```
## Service Tiers

### Tier 0 (core, RTO<5min, RPO<1min)
- payment-service (payment)
- order-service (orders)
- user-service (user authentication)
- DR requirement: multi-AZ + cross-region hot standby + auto-failover

### Tier 1 (important, RTO<30min, RPO<1h)
- search-service (search)
- recommendation-service (recommendations)
- DR requirement: multi-AZ + periodic backups

### Tier 2 (general, RTO<4h, RPO<24h)
- admin-service (admin)
- report-service (reports)
- DR requirement: single-AZ + daily backups

### Tier 3 (non-core, RTO<24h, RPO<24h)
- log-analytics (log analysis)
- DR requirement: on-demand recovery
```

### 2. Design Multi-AZ Strategy

```yaml
# Multi-AZ deployment config
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
spec:
  replicas: 6
  template:
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: topology.kubernetes.io/zone
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
          matchLabels:
            app: payment-service
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  app: payment-service
              topologyKey: kubernetes.io/hostname
```

### 3. Design Cross-Region Disaster Recovery (if needed)

```
## Cross-Region DR Architecture

### Primary cluster (Beijing)
- Runs all services
- Database primary
- Real-time writes

### Secondary cluster (Shanghai)
- Runs Tier 0 services (cold/hot standby)
- Database read replica
- Asynchronous replication (lag < 1s)

### Failover Strategy
- Auto-failover: primary health check fails + secondary healthy
- Manual failover: primary regional outage
- Failover time: < 5 minutes (RTO)
- Data loss: < 1 second (RPO, async replication lag)
```

### 4. Design Degradation Plan

```yaml
# Degradation config
degradation:
  enabled: true
  levels:
    # Level 1: disable non-core features
    - trigger: "CPU > 80%"
      actions:
        - disable_feature: recommendation
        - disable_feature: search
        - reduce_log_level: WARN
    
    # Level 2: keep only the core path
    - trigger: "CPU > 90% or ErrorRate > 5%"
      actions:
        - enable_rate_limit: 1000 req/s
        - disable_feature: admin
        - enable_cache_mode: aggressive
    
    # Level 3: emergency mode
    - trigger: "Service unavailable"
      actions:
        - enable_maintenance_page
        - redirect_to_static_page
        - notify_oncall
```

### 5. Design Data Backup Strategy

```
## Data Backup Strategy

### Database
| Type | Frequency | Retention | Storage |
|------|------|--------|------|
| Full backup | Daily | 30 days | Cross-region S3 |
| Incremental backup | Hourly | 7 days | Same-region S3 |
| Binlog/WAL | Real-time | 24 hours | Local + remote |

### Object Storage
- Versioning: enabled
- Cross-region replication: enabled
- Retention policy: 90 days

### Configuration Data
- Git repo: multi-replica (GitHub + local mirror)
- Secrets: Vault multi-replica
```

### 6. Design Emergency Response Process

```
## Emergency Response Process

### 1. Detection (< 1 min)
- Monitoring alert triggered
- User feedback
- Patrol discovery

### 2. Assessment (< 5 min)
- Incident severity classification (P0/P1/P2)
- Impact scope assessment
- Decision: degrade / failover / recover

### 3. Response (< RTO)
- P0: immediately trigger DR failover
- P1: degrade + troubleshoot
- P2: troubleshoot + fix

### 4. Recovery (< RTO)
- Execute DR failover/degradation
- Verify service recovery
- Notify stakeholders

### 5. Post-mortem (< 24h)
- Root cause analysis
- Improvement actions
- Update the plan
```

### 7. Produce the DR Plan Document

Write to `docs/infrastructure/disaster-recovery-plan.md`, including all the above content.

### 8. Update Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Plan Version | Service Tiers | Max RTO | Max RPO | Multi-AZ | Cross-Region DR | Last Drill |
|---------|---------|---------|---------|------|---------|---------|
| v1.0 | 4 tiers | 5min | 1min | ✓ | Planned | Pending |
```

## Prohibitions

- Do not formulate disaster recovery plans that cannot be executed
- Do not pursue the highest DR tier for all services (cost considerations)
- Do not skip disaster recovery drills
- Do not include plaintext credentials in the plan

## Relationship to LOOP

**LOOP type**: none (planning skill)

This skill produces a disaster recovery plan document for human decision-making.
DR drills are executed by the recovery-drill skill.
Actual DR failover is triggered by the incident-response-workflow.
