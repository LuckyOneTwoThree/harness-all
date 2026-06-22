---
name: kubernetes-manifest
description: K8s YAML Manifest 生成与维护，遵循最佳实践（资源限制/探针/RBAC/NetworkPolicy）
triggers:
  - 需要生成 K8s 部署配置时
  - 需要修改现有 Manifest 时
  - K8s 资源异常需要排查时
  - deployment-pipeline 生成部署配置时
  - 用户要求"写一个 K8s 部署文件"时
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

# Kubernetes Manifest — K8s YAML 生成与维护

## 铁律

1. **所有 Pod 必须有资源限制** —— requests + limits 缺一不可
2. **所有工作负载必须有探针** —— liveness + readiness
3. **不使用 latest 标签** —— 镜像必须固定版本
4. **不使用 default namespace** —— 必须指定 namespace
5. **Secret 不硬编码** —— 使用引用或外部 Secret 管理

## 流程

### 1. 评估工作负载需求

读取 `solo-to-ops.md`：
- 镜像地址和版本
- 环境变量清单
- 端口暴露
- 资源需求（CPU/内存预估）
- 持久化需求
- 健康检查端点

### 2. 生成 Manifest

#### Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
  namespace: production
  labels:
    app: payment-service
    version: v1.2.3
    managed-by: harness-ops
spec:
  replicas: 3
  selector:
    matchLabels:
      app: payment-service
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
  template:
    metadata:
      labels:
        app: payment-service
        version: v1.2.3
    spec:
      containers:
      - name: app
        image: registry.example.com/payment-service:v1.2.3  # 固定版本
        ports:
        - containerPort: 8080
        env:
        - name: DB_HOST
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: host
        - name: LOG_LEVEL
          value: "info"
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
        securityContext:
          runAsNonRoot: true
          runAsUser: 1000
          readOnlyRootFilesystem: true
          allowPrivilegeEscalation: false
```

#### Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: payment-service
  namespace: production
spec:
  selector:
    app: payment-service
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
```

#### ConfigMap
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: payment-service-config
  namespace: production
data:
  config.yaml: |
    cache:
      ttl: 300
      max_size: 1000
    feature_flags:
      new_checkout: true
```

#### HPA（水平扩缩容）
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: payment-service
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: payment-service
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

#### NetworkPolicy（安全隔离）
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: payment-service-network
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: payment-service
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api-gateway
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: postgres
    ports:
    - protocol: TCP
      port: 5432
```

### 3. 最佳实践检查

生成 Manifest 后自动检查：

| 检查项 | 要求 | 严重度 |
|--------|------|--------|
| 镜像标签 | 非 latest，固定版本 | 高 |
| 资源限制 | requests + limits 都有 | 高 |
| 探针 | liveness + readiness | 高 |
| namespace | 非 default | 中 |
| securityContext | runAsNonRoot + readOnlyRootFilesystem | 高 |
| Secret 引用 | 不硬编码敏感值 | 高 |
| 副本数 | ≥ 2（生产环境） | 中 |
| PDB | 配置 PodDisruptionBudget | 中 |

### 4. 生成 GitOps PR

将 Manifest 写入 GitOps 仓库：
```
gitops-repo/
├── production/
│   ├── payment-service/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── configmap.yaml
│   │   ├── hpa.yaml
│   │   └── networkpolicy.yaml
```

生成 PR 描述：
```
## 部署 payment-service v1.2.3

### 变更内容
- 镜像升级: v1.2.2 → v1.2.3
- 新增环境变量: REDIS_URL
- 资源限制调整: CPU limits 500m → 800m

### 来源
- solo-to-ops.md: [链接]
- 影响面: 中

### 验证
- [x] 最佳实践检查通过
- [x] staging 环境验证通过
- [ ] production 部署待审批
```

### 5. K8s 资源排查（如需）

当 K8s 资源异常时，执行诊断：
```bash
# Pod 异常状态
kubectl get pods -n <ns> --field-selector=status.phase!=Running

# 事件查看
kubectl describe pod <pod-name> -n <ns>

# 日志查看
kubectl logs <pod-name> -n <ns> --previous  # 查看崩溃前的日志

# 资源使用
kubectl top pods -n <ns>
kubectl top nodes
```

常见问题诊断：
- **CrashLoopBackOff**：检查启动日志、资源限制、探针配置
- **OOMKilled**：增加 memory limits 或排查内存泄漏
- **ImagePullBackOff**：检查镜像地址、仓库凭据
- **Pending**：检查资源是否足够、nodeSelector/affinity

## 禁止事项

- 不使用 latest 镜像标签
- 不硬编码 Secret 值
- 不使用 default namespace
- 不配置 privileged: true
- 不跳过资源限制
- 不在生产环境直接 kubectl apply（走 GitOps PR）

## 与 LOOP 的关系

**所属 LOOP 类型**：provision（PLAN 阶段）

本 skill 在 deployment-pipeline 的 PLAN 阶段被调用，生成 Manifest 后由 deployment-pipeline 编排后续部署。
