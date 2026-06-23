---
name: helm-management
description: Helm chart management and maintenance, generating / upgrading / rolling back Helm releases and managing values files
triggers:
  - When deploying an application with Helm
  - When upgrading a Helm chart version
  - When a Helm release is abnormal and needs troubleshooting
  - When the user requests "deploy with Helm"
  - When custom Helm values are needed
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - docs/handoff/solo-to-ops.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/infrastructure/
  - loops/specs/<task-name>/spec.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: propose
requires_approval: false
---

# Helm Management — Helm Chart Management and Maintenance

## Ground Rules

1. **values files separated by environment** — one each for dev/staging/production; do not mix
2. **Pin chart version** — do not use latest; explicitly specify the chart version
3. **Do not modify upstream charts directly** — override via values; forking requires caution
4. **helm upgrade must use --atomic** — auto-rollback on failure
5. **Release naming convention** — `<app-name>-<env>`, e.g., `payment-production`

## Process

### 1. Assess Helm Requirements

Determine the deployment method:
- **upstream chart**: use a community/official chart (e.g., bitnami/redis)
- **custom chart**: project-specific chart
- **umbrella chart**: combine multiple sub-charts

### 2. Generate/Maintain values Files

#### Environment-tiered values
```
charts/payment-service/
├── values.yaml              # base config (defaults)
├── values-dev.yaml          # dev environment overrides
├── values-staging.yaml      # staging environment overrides
└── values-production.yaml   # production environment overrides
```

#### values.yaml example
```yaml
# Base config
image:
  repository: registry.example.com/payment-service
  tag: v1.2.3  # pinned version
  pullPolicy: IfNotPresent

replicaCount: 2

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

probes:
  liveness:
    httpGet:
      path: /health
      port: 8080
  readiness:
    httpGet:
      path: /ready
      port: 8080

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: api.example.com
      paths:
        - path: /payment
          pathType: Prefix

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 20
  targetCPUUtilizationPercentage: 70
```

#### values-production.yaml example
```yaml
# production environment overrides
replicaCount: 5

resources:
  requests:
    cpu: 200m
    memory: 256Mi
  limits:
    cpu: 1000m
    memory: 1Gi

autoscaling:
  minReplicas: 5
  maxReplicas: 30

# production-specific config
podDisruptionBudget:
  enabled: true
  minAvailable: 3

networkPolicy:
  enabled: true
```

### 3. Generate/Maintain Custom Charts (if needed)

```
charts/payment-service/
├── Chart.yaml
├── values.yaml
├── values-*.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── configmap.yaml
    ├── hpa.yaml
    ├── ingress.yaml
    └── NOTES.txt
```

#### Chart.yaml
```yaml
apiVersion: v2
name: payment-service
description: Payment service Helm chart
type: application
version: 1.2.3
appVersion: "1.2.3"
dependencies:
  - name: redis
    version: 17.x.x
    repository: https://charts.bitnami.com/bitnami
    condition: redis.enabled
```

### 4. Execute Helm Operations

#### First-time Install
```bash
# lint check
helm lint charts/payment-service/

# dry-run
helm install payment-staging charts/payment-service/ \
  -f values-staging.yaml \
  --dry-run

# actual install (staging)
helm install payment-staging charts/payment-service/ \
  -f values-staging.yaml \
  -n staging

# actual install (production, requires human confirmation)
helm install payment-production charts/payment-service/ \
  -f values-production.yaml \
  -n production
```

#### Upgrade
```bash
# Upgrade (must use --atomic for rollback on failure)
helm upgrade payment-production charts/payment-service/ \
  -f values-production.yaml \
  --atomic \
  --timeout 5m \
  -n production

# View upgrade history
helm history payment-production -n production
```

#### Rollback
```bash
# Roll back to the previous version
helm rollback payment-production 1 -n production

# View rollback-able versions
helm history payment-production -n production
```

### 5. Helm Release Troubleshooting

```bash
# List all releases
helm list -A

# View release status
helm status payment-production -n production

# View the release Manifest
helm get manifest payment-production -n production

# View the release values
helm get values payment-production -n production

# View the release hooks
helm get hooks payment-production -n production
```

### 6. Update IaC Asset Library

Append to the IaC asset library in `memory/knowledge-base.md`:
```
| Release Name | Chart | Version | Environment | Namespace | Last Upgrade |
|------------|-------|------|------|---------|---------|
| payment-production | payment-service | 1.2.3 | production | production | 2026-06-22 |
```

## Prohibitions

- Do not use the latest chart version
- Do not run helm upgrade in production without --atomic
- Do not modify upstream charts directly (override via values)
- Do not delete a release without verifying dependencies (helm uninstall requires confirmation)
- Do not hardcode Secrets in values (use secrets.yaml + external management)

## Relationship to LOOP

**LOOP type**: provision

```
LOOP(provision):
  PLAN:       Assess requirements → generate/modify values → lint check
  PROVISION:  helm install / upgrade --atomic
  VERIFY:     helm status + deployment-verify
  Pass? DONE : helm rollback → analyze cause → back to PLAN
```

## Operation Tiers

| Operation | staging | production |
|------|---------|------------|
| helm lint | Agent | Agent |
| helm install | Agent | After human confirmation |
| helm upgrade --atomic | Agent | After human confirmation |
| helm rollback | Agent auto | Agent recommends + human confirms |
| helm uninstall | Human confirmation | Human double confirmation |
