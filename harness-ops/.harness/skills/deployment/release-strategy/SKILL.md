---
name: release-strategy
description: Release strategy selection and design (blue-green / canary / rolling / A-B testing), recommending the optimal release method based on impact
operation_tier: propose
requires_approval: false
---
# Release Strategy — Release Strategy Selection and Design

## When to use
- When a release strategy needs to be selected
- When a high-impact change requires a canary plan
- When the user requests "blue-green deployment" or "canary release
- When OPS_STRATEGY.md needs to define release standards

## Inputs
- docs/infrastructure/OPS_STRATEGY.md
- docs/handoff/solo-to-ops.md
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md

## Outputs
- docs/deployment/release-strategy.md
- loops/specs/<task-name>/spec.md

## Ground Rules

1. **Impact dictates strategy** — high-impact changes must use canary; all-at-once full rollout is not allowed
2. **Health gate at every stage** — each canary increment must pass a health check before proceeding
3. **Rollback at any time** — failure at any stage must be able to immediately roll back to the previous version
4. **Do not skip stages** — canary must proceed as 5%→25%→100%, no skipping intermediate stages

## Process

### 1. Assess Change Impact

Read the change content from `solo-to-ops.md` and assess impact:

| Impact | Criteria | Recommended Strategy |
|--------|---------|---------|
| **Low** | Config adjustment, bug fix, non-core feature | Rolling Update |
| **Medium** | New feature, API change, performance optimization | Canary Release (5%→25%→100%) |
| **High** | DB Migration, Breaking Change, core path change | Blue-Green Deployment + maintenance window |

### 2. Select Release Strategy

#### Rolling Update
- Applicable: low impact, K8s default strategy
- Parameters: maxSurge=25%, maxUnavailable=25%
- Verification: continue rolling after new Pod readiness passes

#### Canary Release
- Applicable: medium impact, needs gradual verification
- Flow:
  ```
  5% traffic → observe 10 minutes (error rate / latency / business metrics)
    ↓ pass
  25% traffic → observe 30 minutes
    ↓ pass
  100% traffic → complete
  ```
- Tools: Argo Rollouts / Flagger / Istio traffic splitting

#### Blue-Green Deployment
- Applicable: high impact, needs quick switch
- Flow:
  ```
  Prepare Green environment → deploy new version → smoke test
  → [human approval] → switch traffic → observe → decommission Blue
  ```
- Advantage: switch is instant, rollback = switch back to Blue

#### A/B Testing
- Applicable: when business metrics need to be compared (conversion rate / click rate)
- Collaborate with the growth framework: growth designs the experiment, ops handles traffic splitting

### 3. Produce Release Plan

```yaml
# Release plan example
strategy: canary
target_environment: production
image: registry.example.com/app:v1.2.3
steps:
  - phase: canary-5
    traffic_percentage: 5
    duration_minutes: 10
    success_criteria:
      - error_rate < 1%
      - p95_latency < 200ms
      - business_metric_stable
    rollback_on_failure: true
  - phase: canary-25
    traffic_percentage: 25
    duration_minutes: 30
    success_criteria: [...]
  - phase: full
    traffic_percentage: 100
    duration_minutes: 60
    success_criteria: [...]
rollback:
  strategy: revert-traffic
  max_seconds: 30
```

### 4. Define Health Gates (Success Criteria)

Each stage must define:
- **Technical metrics**: error rate < 1%, p95 latency < 200ms, CPU < 80%
- **Business metrics**: conversion rate / order volume / active users do not drop
- **Guardrail metrics**: no alerts triggered on other services

### 5. Define Rollback Plan

- Trigger condition: any health gate not passed
- Rollback method: traffic switched back to old version / image revert / config revert
- Rollback time: blue-green < 30 seconds, canary < 5 minutes, rolling < 10 minutes

## Prohibitions

- Do not use rolling update for high-impact changes (must use canary or blue-green)
- Do not skip canary stages (5%→100% in one step)
- Do not advance canary without health gates
- Do not start a release without a rollback plan

## Relationship to LOOP

**LOOP type**: provision

This skill executes in the PLAN stage and produces a release plan written to spec.md.
The PROVISION stage executes the plan, and the VERIFY stage checks the health gates.
