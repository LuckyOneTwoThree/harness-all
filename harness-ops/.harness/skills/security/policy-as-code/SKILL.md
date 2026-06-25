---
name: policy-as-code
description: Kyverno/OPA policy generation, converting ops standards into machine-enforceable policy rules
operation_tier: propose
requires_approval: false
---
# Policy as Code — Kyverno/OPA Policy Generation

## When to use
- When K8s admission policies need to be configured
- When security compliance requires policy enforcement
- When OPS_STRATEGY.md defines standards that need to be enforced
- When resources are detected that do not conform to standards
- When the user requests "configure policies

## Inputs
- docs/infrastructure/OPS_STRATEGY.md
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md

## Outputs
- docs/infrastructure/
- loops/specs/<task-name>/spec.md
- memory/knowledge-base.md

## Ground Rules

1. **Policies before deployments** — policies take effect before resources are created, not as after-the-fact audits
2. **Every policy has documentation** — each policy maps to a standard and is traceable
3. **Policies have modes** — enforce (block) vs audit (log) vs warn (warn)
4. **Do not codify business logic** — only codify security/compliance/standards

## Process

### 1. Identify Policy Requirements

Extract standards requiring enforcement from `OPS_STRATEGY.md` and `security.md`:
- Images must use pinned versions (not latest)
- Resource limits must be set
- securityContext must be configured
- Privileged containers are prohibited
- hostPath mounts are prohibited
- NetworkPolicy must be configured

### 2. Generate Kyverno Policies

#### Validation Policies
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
      message: "Resources must have limits set"
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
      message: "Images must use a pinned version; latest is not allowed"
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
      message: "runAsNonRoot: true must be configured"
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
      message: "Privileged containers are prohibited"
      pattern:
        spec:
          containers:
          - securityContext:
              privileged: "false"
```

#### Mutation Policies
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

#### Generation Policies
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

### 3. Policy Mode Selection

| Mode | Behavior | Applicable Scenarios |
|------|------|---------|
| **enforce** | Blocks non-compliant resource creation | Security red lines (no privileged/latest) |
| **audit** | Logs but does not block | Observation period for new policies |
| **warn** | Warns but allows creation | Non-critical standards |

**Recommended rollout flow**: audit (1 week) → warn (1 week) → enforce

### 4. Policy Testing

```bash
# Test policies with the kyverno CLI
kyverno apply require-resource-limits.yaml --resource test-pod.yaml

# Verify the policy takes effect
kubectl apply -f test-non-compliant-pod.yaml
# Expected: rejected by Kyverno
```

### 5. Policy Violation Monitoring

```yaml
# Prometheus alerting rule
- alert: KyvernoPolicyViolation
  expr: increase(kyverno_policy_results_total{result="fail"}[5m]) > 0
  for: 1m
  labels:
    severity: P2
  annotations:
    summary: "Kyverno policy violation"
    description: "Policy {{ $labels.policy }} was violated {{ $value }} times within 5 minutes"
```

### 6. Update the Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Policy Name | Mode | Standard Source | Violations | Last Updated |
|--------|------|---------|---------|---------|
| require-resource-limits | enforce | OPS_STRATEGY §3.2 | 0 | 2026-06-22 |
```

## Prohibitions

- Do not codify business logic (e.g., "order amount must be > 0")
- Do not go straight to enforce mode without going through audit first
- Do not create conflicting policies
- Do not delete policies without recording the reason

## Relationship to LOOP

**LOOP type**: audit (PLAN stage)

This skill is invoked in security-audit-workflow to generate policy configurations.
Policies take effect continuously after deployment; violations are analyzed by the audit-review skill.
