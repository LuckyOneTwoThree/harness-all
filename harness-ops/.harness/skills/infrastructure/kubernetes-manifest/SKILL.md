---
name: kubernetes-manifest
description: K8s YAML Manifest generation and maintenance, following best practices (resource limits / probes / RBAC / NetworkPolicy)
triggers:
  - When K8s deployment config needs to be generated
  - When existing Manifests need to be modified
  - When K8s resources are abnormal and need troubleshooting
  - When deployment-pipeline generates deployment config
  - When the user requests "write a K8s deployment file"
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

# Kubernetes Manifest — K8s YAML Generation and Maintenance

## Ground Rules

1. **All Pods must have resource limits** — requests + limits, both mandatory
2. **All workloads must have probes** — liveness + readiness
3. **Do not use the latest tag** — image version must be pinned
4. **Do not use the default namespace** — namespace must be specified
5. **Secrets must not be hardcoded** — use references or external Secret management

## Process

### 1. Assess Workload Requirements

Read `solo-to-ops.md`:
- Image address and version
- Environment variable list
- Port exposure
- Resource requirements (CPU/memory estimate)
- Persistence requirements
- Health check endpoints

### 2. Generate Manifest

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
        image: registry.example.com/payment-service:v1.2.3  # pinned version
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

#### HPA (Horizontal Pod Autoscaler)
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

#### NetworkPolicy (security isolation)
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

### 3. Best Practice Checks

After generating the Manifest, auto-check:

| Check Item | Requirement | Severity |
|--------|------|--------|
| Image tag | not latest, pinned version | High |
| Resource limits | both requests + limits | High |
| Probes | liveness + readiness | High |
| namespace | not default | Medium |
| securityContext | runAsNonRoot + readOnlyRootFilesystem | High |
| Secret references | no hardcoded sensitive values | High |
| Replica count | ≥ 2 (production) | Medium |
| PDB | configure PodDisruptionBudget | Medium |

### 4. Generate GitOps PR

Write the Manifest to the GitOps repo:
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

Generate PR description:
```
## Deploy payment-service v1.2.3

### Changes
- Image upgrade: v1.2.2 → v1.2.3
- New env var: REDIS_URL
- Resource limit adjustment: CPU limits 500m → 800m

### Source
- solo-to-ops.md: [link]
- Impact: medium

### Verification
- [x] Best practice checks passed
- [x] Staging environment verified
- [ ] Production deployment pending approval
```

### 5. K8s Resource Troubleshooting (if needed)

When K8s resources are abnormal, run diagnostics:
```bash
# Pod abnormal status
kubectl get pods -n <ns> --field-selector=status.phase!=Running

# View events
kubectl describe pod <pod-name> -n <ns>

# View logs
kubectl logs <pod-name> -n <ns> --previous  # view logs before crash

# Resource usage
kubectl top pods -n <ns>
kubectl top nodes
```

Common issue diagnosis:
- **CrashLoopBackOff**: check startup logs, resource limits, probe config
- **OOMKilled**: increase memory limits or investigate memory leaks
- **ImagePullBackOff**: check image address, registry credentials
- **Pending**: check whether resources are sufficient, nodeSelector/affinity

## Prohibitions

- Do not use the latest image tag
- Do not hardcode Secret values
- Do not use the default namespace
- Do not set privileged: true
- Do not skip resource limits
- Do not run kubectl apply directly in production (go through a GitOps PR)

## Relationship to LOOP

**LOOP type**: provision (PLAN stage)

This skill is invoked during the PLAN stage of deployment-pipeline; after generating the Manifest, deployment-pipeline orchestrates the subsequent deployment.
