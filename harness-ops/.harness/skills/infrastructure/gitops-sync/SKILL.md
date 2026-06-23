---
name: gitops-sync
description: ArgoCD/Flux GitOps sync management, monitoring sync status, detecting drift, and managing Application CRDs
triggers:
  - When deploying via GitOps
  - When ArgoCD/Flux sync is abnormal
  - When creating/modifying Application CRDs
  - When configuration drift is detected
  - After deployment-pipeline generates a GitOps PR
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/infrastructure/
  - loops/specs/<task-name>/state.yaml
  - loops/specs/<task-name>/evidence.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: inspect
requires_approval: false
---

# GitOps Sync — ArgoCD/Flux Sync Management

## Ground Rules

1. **Git is the single source of truth** — cluster state must converge to Git; do not modify the cluster directly
2. **Pull over Push** — ArgoCD/Flux pull model; do not push credentials to the cluster
3. **Explicit sync policy** — auto-sync vs. manual-sync must be declared explicitly
4. **Drift means alert** — detected inconsistency between cluster and Git must be recorded
5. **Rollback = Git revert** — do not roll back at the cluster layer; revert the Git commit

## Process

### 1. Manage ArgoCD Applications

#### Application CRD Generation
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: payment-service-production
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: production
  source:
    repoURL: https://github.com/org/gitops-repo
    targetRevision: main
    path: production/payment-service
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true           # auto-prune resources deleted in Git
      selfHeal: true        # auto-fix drift
    syncOptions:
    - CreateNamespace=true
    - PruneLast=true
    - ApplyOutOfSyncOnly=true
  revisionHistoryLimit: 10
```

#### ApplicationSet (multi-environment management)
```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: payment-service
  namespace: argocd
spec:
  generators:
  - list:
      elements:
      - env: staging
        cluster: https://kubernetes.default.svc
      - env: production
        cluster: https://production-cluster.api
  template:
    metadata:
      name: 'payment-{{env}}'
    spec:
      source:
        repoURL: https://github.com/org/gitops-repo
        targetRevision: main
        path: '{{env}}/payment-service'
      destination:
        server: '{{cluster}}'
        namespace: '{{env}}'
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
```

### 2. Monitor Sync Status

```bash
# View sync status of all Applications
argocd app list

# View a specific Application
argocd app get payment-service-production

# View sync history
argocd app history payment-service-production

# Manually trigger sync (if needed)
argocd app sync payment-service-production
```

**Sync status categories**:
| Status | Meaning | Action |
|------|------|------|
| Synced | Cluster state matches Git | No action needed |
| OutOfSync | Cluster does not match Git | Auto-sync or manual trigger |
| Syncing | Syncing in progress | Wait for completion |
| Failed | Sync failed | Inspect errors, fix, and retry |
| Unknown | Cannot get status | Check ArgoCD health |

### 3. Drift Detection

```bash
# Detect drift
argocd app diff payment-service-production

# Example output
# === deployment/payment-service ===
# spec.template.spec.containers[0].image:
#   Git: registry.example.com/payment-service:v1.2.3
#   Live: registry.example.com/payment-service:v1.2.2
```

**Drift handling**:
- **selfHeal=true**: ArgoCD auto-fixes drift
- **selfHeal=false**: Agent reports drift, human decides
- **Frequent drift**: someone may be modifying the cluster manually; investigate

### 4. Flux Management (if using Flux)

```yaml
# Flux Kustomization
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: payment-service
  namespace: flux-system
spec:
  interval: 5m
  path: ./production/payment-service
  sourceRef:
    kind: GitRepository
    name: gitops-repo
  prune: true
  validation: server
  healthChecks:
  - apiVersion: apps/v1
    kind: Deployment
    name: payment-service
    namespace: production
```

```bash
# View Flux sync status
flux get kustomizations
flux get sources git

# Manually trigger sync
flux reconcile kustomization payment-service
```

### 5. GitOps PR Workflow

Standard flow when the Agent generates a GitOps PR:

```
1. Modify Manifest/values in the GitOps repo
2. git commit -m "deploy: payment-service v1.2.3"
3. gh pr create --title "Deploy payment-service v1.2.3" --body "..."
4. Wait for human review
5. After human merge, ArgoCD/Flux auto-detects and syncs
6. Agent monitors sync status
7. After sync completes, trigger deployment-verify
```

### 6. Rollback (Git revert)

```bash
# View commit history
git log --oneline -10

# Revert the deployment commit
git revert <commit-hash>
git push

# ArgoCD/Flux auto-detects the revert and syncs back to the old version
```

### 7. Update Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Application | Environment | Repo | Path | Sync Policy | Current Version | Last Sync |
|------------|------|------|------|---------|---------|---------|
| payment-production | production | gitops-repo | production/payment-service | auto+selfHeal | v1.2.3 | 2026-06-22 |
```

## Prohibitions

- Do not modify cluster resources directly (kubectl apply/edit); must go through Git
- Do not disable selfHeal in production (unless during a maintenance window)
- Do not delete an Application CRD without a finalizer (prevents resource leaks)
- Do not store plaintext Secrets in the GitOps repo (use Sealed Secrets / SOPS / External Secrets)
- Do not skip PR review and push directly to main

## Relationship to LOOP

**LOOP type**: provision

This skill executes in the PROVISION stage of deployment-pipeline:
- PLAN: generate Application CRD / Manifest
- PROVISION: submit GitOps PR → human merge → ArgoCD sync
- VERIFY: check sync status + deployment-verify

## Relationship to Other Skills

- **Upstream**: `kubernetes-manifest` (generate YAML), `helm-management` (generate values)
- **Collaboration**: `deployment-verify` (verify after sync)
- **Downstream**: `rollback` (rollback via Git revert)
