---
name: secret-management
description: Secret 引用管理，生成 ExternalSecret/SealedSecret CRD，永远不接触明文 Secret 值
triggers:
  - 需要配置 Secret 时
  - 部署需要数据库密码/API Key 时
  - Secret 轮转策略配置时
  - 安全审计发现明文 Secret 时
  - 用户要求"配置密钥"时
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
max_iterations: 1
operation_tier: propose
requires_approval: true
---

# Secret Management — Secret 引用管理

## 铁律

1. **永远不接触明文 Secret 值** —— Agent 只操作引用（路径/键名/CRD），不读取/生成/展示明文
2. **Secret 必须外部化** —— 使用 Vault/External Secrets/Sealed Secrets，不存明文到 Git
3. **最小权限** —— Secret 访问权限遵循最小权限原则
4. **轮转必须有策略** —— 每个 Secret 必须有轮转周期
5. **泄露必须立即响应** —— 检测到泄露立即通知人类

## 流程

### 1. 评估 Secret 需求

从 `solo-to-ops.md` 获取需要配置的 Secret 清单：
- 数据库密码
- API Key（第三方服务）
- TLS 证书
- 云厂商凭据
- 服务间认证 Token

### 2. 选择 Secret 管理方案

| 方案 | 适用场景 | 优势 |
|------|---------|------|
| **External Secrets + Vault** | 企业级，动态密钥 | 集中管理+自动轮转 |
| **External Secrets + AWS Secrets Manager** | AWS 环境 | 原生集成 |
| **Sealed Secrets** | GitOps 友好 | 加密后可存 Git |
| **SOPS** | 配置文件加密 | 简单易用 |

### 3. 生成 ExternalSecret CRD（不接触明文）

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: payment-service-secrets
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-backend
    kind: ClusterSecretStore
  target:
    name: payment-service-secrets
    creationPolicy: Owner
  data:
  - secretKey: db-password
    remoteRef:
      key: secret/data/payment/production
      property: db-password
  - secretKey: api-key
    remoteRef:
      key: secret/data/payment/production
      property: stripe-api-key
```

**注意**：Agent 只生成"引用"（secretKey + remoteRef），不生成明文值。明文值由人类通过 Vault CLI 等专用通道写入。

### 4. 生成 SecretStore 配置

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "https://vault.example.com"
      path: "secret"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "external-secrets"
```

### 5. 生成 SealedSecret（替代方案）

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: payment-service-secrets
  namespace: production
spec:
  encryptedData:
    # 这是加密后的内容，不是明文
    # 人类使用 kubeseal 生成，Agent 只引用
    db-password: AgB8m9...加密内容...
  template:
    metadata:
      name: payment-service-secrets
      namespace: production
```

### 6. 配置 Secret 轮转策略

```yaml
# Vault 动态密钥（自动轮转）
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-credentials
spec:
  refreshInterval: 24h  # 每 24 小时轮转
  data:
  - secretKey: db-password
    remoteRef:
      key: dynamic/database/production
      property: password
```

### 7. 验证 Secret 配置

```bash
# 验证 ExternalSecret 同步状态
kubectl get externalsecret -n production
# 期望: STATUS=True

# 验证 Secret 已生成（不查看内容）
kubectl get secret payment-service-secrets -n production
# 期望: Secret 存在

# 验证 Pod 可访问 Secret
kubectl exec -n production deployment/payment-service -- env | grep DB_PASSWORD
# 期望: 环境变量存在（不展示值）
```

### 8. 更新知识库

`memory/knowledge-base.md` 追加：
```
| Secret 名 | 类型 | 来源 | 轮转周期 | 最后轮转 | 访问权限 |
|-----------|------|------|---------|---------|---------|
| payment-db-password | 数据库密码 | Vault | 24h | 2026-06-22 | payment-service SA |
```

## 禁止事项

- **绝对禁止**读取/生成/展示明文 Secret 值
- 不在日志/报告/交接文档中包含明文 Secret
- 不在 Git 仓库存储明文 Secret（必须加密）
- 不在 ConfigMap 中存储 Secret（必须用 Secret 类型）
- 不跳过 Secret 轮转策略
- 不给 Agent 配置读取 Secret 值的权限

## 与 LOOP 的关系

**所属 LOOP 类型**：provision（PLAN 阶段）

本 skill 在 deployment-pipeline 的 PLAN 阶段被调用，生成 Secret 引用配置。
明文值由人类通过专用通道写入 Vault/Secrets Manager。

## 安全红线

| 操作 | Agent 权限 |
|------|-----------|
| 生成 ExternalSecret CRD | ✅ 允许 |
| 生成 SecretStore 配置 | ✅ 允许 |
| 读取 Secret 元数据（名/类型/状态） | ✅ 允许 |
| 读取 Secret 明文值 | ❌ 禁止 |
| 生成明文 Secret 值 | ❌ 禁止 |
| 修改 Vault 策略 | ❌ 禁止（人类操作） |
| 删除 Secret | ❌ 禁止（人类操作） |
