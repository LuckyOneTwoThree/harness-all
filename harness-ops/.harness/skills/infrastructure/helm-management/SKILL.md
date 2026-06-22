---
name: helm-management
description: Helm chart 管理与维护，生成/升级/回滚 Helm release，管理 values 文件
triggers:
  - 使用 Helm 部署应用时
  - 需要升级 Helm chart 版本时
  - Helm release 异常需要排查时
  - 用户要求"用 Helm 部署"时
  - 需要自定义 Helm values 时
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

# Helm Management — Helm Chart 管理与维护

## 铁律

1. **values 文件分环境** —— dev/staging/production 各一份，不混用
2. **chart 版本固定** —— 不使用 latest，显式指定 chart 版本
3. **不直接修改 upstream chart** —— 通过 values 覆盖，fork 需谨慎
4. **helm upgrade 必须 --atomic** —— 失败自动回滚
5. **release 命名规范** —— `<app-name>-<env>`，如 `payment-production`

## 流程

### 1. 评估 Helm 需求

确定部署方式：
- **upstream chart**：使用社区/官方 chart（如 bitnami/redis）
- **自定义 chart**：项目专有 chart
- **umbrella chart**：组合多个子 chart

### 2. 生成/维护 values 文件

#### 环境分层 values
```
charts/payment-service/
├── values.yaml              # 基础配置（默认值）
├── values-dev.yaml          # dev 环境覆盖
├── values-staging.yaml      # staging 环境覆盖
└── values-production.yaml   # production 环境覆盖
```

#### values.yaml 示例
```yaml
# 基础配置
image:
  repository: registry.example.com/payment-service
  tag: v1.2.3  # 固定版本
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

#### values-production.yaml 示例
```yaml
# production 环境覆盖
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

# production 专属配置
podDisruptionBudget:
  enabled: true
  minAvailable: 3

networkPolicy:
  enabled: true
```

### 3. 生成/维护自定义 Chart（如需）

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

### 4. 执行 Helm 操作

#### 首次安装
```bash
# lint 检查
helm lint charts/payment-service/

# dry-run
helm install payment-staging charts/payment-service/ \
  -f values-staging.yaml \
  --dry-run

# 实际安装（staging）
helm install payment-staging charts/payment-service/ \
  -f values-staging.yaml \
  -n staging

# 实际安装（production，需人类确认）
helm install payment-production charts/payment-service/ \
  -f values-production.yaml \
  -n production
```

#### 升级
```bash
# 升级（必须 --atomic 失败回滚）
helm upgrade payment-production charts/payment-service/ \
  -f values-production.yaml \
  --atomic \
  --timeout 5m \
  -n production

# 查看升级历史
helm history payment-production -n production
```

#### 回滚
```bash
# 回滚到上一版本
helm rollback payment-production 1 -n production

# 查看可回滚的版本
helm history payment-production -n production
```

### 5. Helm release 排查

```bash
# 查看所有 release
helm list -A

# 查看 release 状态
helm status payment-production -n production

# 查看 release 的 Manifest
helm get manifest payment-production -n production

# 查看 release 的 values
helm get values payment-production -n production

# 查看 release 的 hooks
helm get hooks payment-production -n production
```

### 6. 更新 IaC 资产库

`memory/knowledge-base.md` 的 IaC 资产库追加：
```
| Release 名 | Chart | 版本 | 环境 | 命名空间 | 最后升级 |
|------------|-------|------|------|---------|---------|
| payment-production | payment-service | 1.2.3 | production | production | 2026-06-22 |
```

## 禁止事项

- 不使用 latest chart 版本
- 不在生产环境执行 helm upgrade 不带 --atomic
- 不直接修改 upstream chart（通过 values 覆盖）
- 不删除 release 不验证依赖（helm uninstall 需确认）
- 不在 values 中硬编码 Secret（使用 secrets.yaml + 外部管理）

## 与 LOOP 的关系

**所属 LOOP 类型**：provision

```
LOOP(provision):
  PLAN:       评估需求 → 生成/修改 values → lint 检查
  PROVISION:  helm install / upgrade --atomic
  VERIFY:     helm status + deployment-verify
  通过? DONE : helm rollback → 分析原因 → 回到 PLAN
```

## 操作分级

| 操作 | staging | production |
|------|---------|------------|
| helm lint | Agent | Agent |
| helm install | Agent | 人类确认后 |
| helm upgrade --atomic | Agent | 人类确认后 |
| helm rollback | Agent 自动 | Agent 建议+人类确认 |
| helm uninstall | 人类确认 | 人类双重确认 |
