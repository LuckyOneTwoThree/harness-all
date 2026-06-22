---
name: gitops-sync
description: ArgoCD/Flux GitOps 同步管理，监控同步状态/检测漂移/管理 Application CRD
triggers:
  - 通过 GitOps 部署时
  - ArgoCD/Flux 同步异常时
  - 需要创建/修改 Application CRD 时
  - 检测到配置漂移时
  - deployment-pipeline 生成 GitOps PR 后
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

# GitOps Sync — ArgoCD/Flux 同步管理

## 铁律

1. **Git 是唯一真理源** —— 集群状态必须向 Git 收敛，不直接改集群
2. **Pull 优先于 Push** —— ArgoCD/Flux 拉取模式，不向集群推送凭据
3. **同步策略明确** —— 自动同步 vs 手动同步需显式声明
4. **漂移即告警** —— 检测到集群与 Git 不一致必须记录
5. **回滚=Git revert** —— 不在集群层回滚，回滚 Git commit

## 流程

### 1. 管理 ArgoCD Application

#### Application CRD 生成
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
      prune: true           # 自动清理 Git 中删除的资源
      selfHeal: true        # 自动修复漂移
    syncOptions:
    - CreateNamespace=true
    - PruneLast=true
    - ApplyOutOfSyncOnly=true
  revisionHistoryLimit: 10
```

#### ApplicationSet（多环境管理）
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

### 2. 监控同步状态

```bash
# 查看所有 Application 同步状态
argocd app list

# 查看特定 Application
argocd app get payment-service-production

# 查看同步历史
argocd app history payment-service-production

# 手动触发同步（如需）
argocd app sync payment-service-production
```

**同步状态分类**：
| 状态 | 含义 | 处理 |
|------|------|------|
| Synced | 集群状态与 Git 一致 | 无需操作 |
| OutOfSync | 集群与 Git 不一致 | 自动同步或手动触发 |
| Syncing | 正在同步 | 等待完成 |
| Failed | 同步失败 | 查看错误，修复后重试 |
| Unknown | 无法获取状态 | 检查 ArgoCD 健康 |

### 3. 漂移检测

```bash
# 检测漂移
argocd app diff payment-service-production

# 输出示例
# === deployment/payment-service ===
# spec.template.spec.containers[0].image:
#   Git: registry.example.com/payment-service:v1.2.3
#   Live: registry.example.com/payment-service:v1.2.2
```

**漂移处理**：
- **selfHeal=true**：ArgoCD 自动修复漂移
- **selfHeal=false**：Agent 报告漂移，人类决策
- **频繁漂移**：可能有人手动改集群，需排查

### 4. Flux 管理（如使用 Flux）

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
# 查看 Flux 同步状态
flux get kustomizations
flux get sources git

# 手动触发同步
flux reconcile kustomization payment-service
```

### 5. GitOps PR 工作流

Agent 生成 GitOps PR 的标准流程：

```
1. 修改 GitOps 仓库的 Manifest/values
2. git commit -m "deploy: payment-service v1.2.3"
3. gh pr create --title "Deploy payment-service v1.2.3" --body "..."
4. 等待人类 review
5. 人类 merge 后，ArgoCD/Flux 自动检测并同步
6. Agent 监控同步状态
7. 同步完成后触发 deployment-verify
```

### 6. 回滚（Git revert）

```bash
# 查看提交历史
git log --oneline -10

# revert 部署提交
git revert <commit-hash>
git push

# ArgoCD/Flux 自动检测 revert 并同步回旧版本
```

### 7. 更新知识库

`memory/knowledge-base.md` 追加：
```
| Application | 环境 | 仓库 | 路径 | 同步策略 | 当前版本 | 最后同步 |
|------------|------|------|------|---------|---------|---------|
| payment-production | production | gitops-repo | production/payment-service | auto+selfHeal | v1.2.3 | 2026-06-22 |
```

## 禁止事项

- 不直接修改集群资源（kubectl apply/edit），必须通过 Git
- 不在生产环境关闭 selfHeal（除非维护窗口）
- 不删除 Application CRD 不加 finalizer（防止资源泄漏）
- 不在 GitOps 仓库存储明文 Secret（用 Sealed Secrets / SOPS / External Secrets）
- 不跳过 PR review 直接 push 到 main

## 与 LOOP 的关系

**所属 LOOP 类型**：provision

本 skill 在 deployment-pipeline 的 PROVISION 阶段执行：
- PLAN：生成 Application CRD / Manifest
- PROVISION：提交 GitOps PR → 人类 merge → ArgoCD 同步
- VERIFY：检查同步状态 + deployment-verify

## 与其他 skill 的关系

- **上游**：`kubernetes-manifest`（生成 YAML）、`helm-management`（生成 values）
- **协作**：`deployment-verify`（同步后验证）
- **下游**：`rollback`（通过 Git revert 回滚）
