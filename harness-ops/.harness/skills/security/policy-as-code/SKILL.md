---
name: policy-as-code
description: Kyverno/OPA 策略生成，将运维规范转化为可机器执行的策略规则
triggers:
  - 需要配置 K8s 准入策略时
  - 安全合规需要策略 enforcement 时
  - OPS_STRATEGY.md 定义规范需要落地时
  - 检测到资源不符合规范时
  - 用户要求"配置策略"时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
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

# Policy as Code — Kyverno/OPA 策略生成

## 铁律

1. **策略先于部署** —— 策略在资源创建前生效，不是事后审计
2. **策略必须有文档** —— 每个策略对应一条规范，可追溯
3. **策略分模式** —— enforce（阻断）vs audit（记录）vs warn（警告）
4. **不策略化业务逻辑** —— 只策略化安全/合规/规范

## 流程

### 1. 识别策略需求

从 `OPS_STRATEGY.md` 和 `security.md` 提取需要 enforcement 的规范：
- 镜像必须固定版本（非 latest）
- 必须设置资源限制
- 必须配置 securityContext
- 禁止特权容器
- 禁止 hostPath 挂载
- 必须配置 NetworkPolicy

### 2. 生成 Kyverno 策略

#### 验证策略（Validation）
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-resource-limits
spec:
  validationFailureAction: enforce
  rules:
  - name: check-resource-limits
    match:
      resources:
        kinds:
        - Pod
    validate:
      message: "资源必须设置 limits"
      pattern:
        spec:
          containers:
          - resources:
              limits:
                memory: "?*"
                cpu: "?*"

---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-latest-tag
spec:
  validationFailureAction: enforce
  rules:
  - name: require-image-tag
    match:
      resources:
        kinds:
        - Pod
    validate:
      message: "镜像必须使用固定版本，不允许 latest"
      pattern:
        spec:
          containers:
          - image: "!*:latest"

---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-security-context
spec:
  validationFailureAction: enforce
  rules:
  - name: require-run-as-non-root
    match:
      resources:
        kinds:
        - Pod
    validate:
      message: "必须配置 runAsNonRoot: true"
      pattern:
        spec:
          securityContext:
            runAsNonRoot: "true"

---
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-privileged
spec:
  validationFailureAction: enforce
  rules:
  - name: no-privileged-containers
    match:
      resources:
        kinds:
        - Pod
    validate:
      message: "禁止特权容器"
      pattern:
        spec:
          containers:
          - securityContext:
              privileged: "false"
```

#### 变异策略（Mutation）
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: add-default-network-policy
spec:
  rules:
  - name: default-deny-ingress
    match:
      resources:
        kinds:
        - Namespace
    mutate:
      patchStrategicMerge:
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
          name: default-deny-ingress
          namespace: "{{request.object.metadata.name}}"
        spec:
          podSelector: {}
          policyTypes:
          - Ingress
```

#### 生成策略（Generation）
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: generate-default-networkpolicy
spec:
  rules:
  - name: default-networkpolicy
    match:
      resources:
        kinds:
        - Namespace
    generate:
      apiVersion: networking.k8s.io/v1
      kind: NetworkPolicy
      name: default-deny
      namespace: "{{request.object.metadata.name}}"
      data:
        spec:
          podSelector: {}
          policyTypes:
          - Ingress
          - Egress
```

### 3. 策略模式选择

| 模式 | 行为 | 适用场景 |
|------|------|---------|
| **enforce** | 阻断不合规资源创建 | 安全红线（禁止特权/latest） |
| **audit** | 记录但不阻断 | 新策略上线观察期 |
| **warn** | 警告但允许创建 | 非关键规范 |

**推荐上线流程**：audit（1 周）→ warn（1 周）→ enforce

### 4. 策略测试

```bash
# 使用 kyverno CLI 测试策略
kyverno apply require-resource-limits.yaml --resource test-pod.yaml

# 验证策略生效
kubectl apply -f test-non-compliant-pod.yaml
# 期望: 被 Kyverno 拒绝
```

### 5. 策略违规监控

```yaml
# Prometheus 告警规则
- alert: KyvernoPolicyViolation
  expr: increase(kyverno_policy_results_total{result="fail"}[5m]) > 0
  for: 1m
  labels:
    severity: P2
  annotations:
    summary: "Kyverno 策略违规"
    description: "策略 {{ $labels.policy }} 在 5 分钟内被违反 {{ $value }} 次"
```

### 6. 更新知识库

`memory/knowledge-base.md` 追加：
```
| 策略名 | 模式 | 规范来源 | 违规次数 | 最后更新 |
|--------|------|---------|---------|---------|
| require-resource-limits | enforce | OPS_STRATEGY §3.2 | 0 | 2026-06-22 |
```

## 禁止事项

- 不策略化业务逻辑（如"订单金额必须>0"）
- 不在 enforce 模式下未经 audit 直接上线
- 不创建相互冲突的策略
- 不删除策略不记录原因

## 与 LOOP 的关系

**所属 LOOP 类型**：audit（PLAN 阶段）

本 skill 在 security-audit-workflow 中被调用，生成策略配置。
策略部署后持续生效，违规事件由 audit-review skill 分析。
