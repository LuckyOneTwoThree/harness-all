---
name: incident-mitigation
description: 故障止血与缓解，执行白名单操作快速恢复服务（回滚/扩容/重启/降级）
triggers:
  - P0/P1 故障需要紧急止血时
  - incident-detection 完成分级后
  - 用户要求"紧急恢复服务"时
  - 监控告警显示服务不可用时
reads:
  - loops/specs/<incident-id>/spec.md
  - loops/specs/<incident-id>/state.yaml
  - docs/handoff/solo-to-ops.md
  - memory/knowledge-base.md
  - rules/security.md
  - loops/LOOP.md
writes:
  - loops/specs/<incident-id>/state.yaml
  - loops/specs/<incident-id>/evidence.md
  - loops/specs/<incident-id>/iterations.log
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 3
operation_tier: mutate-staging
requires_approval: true
---

# Incident Mitigation — 故障止血与缓解

## 铁律

1. **止血优先于根因** —— 先恢复服务，再分析原因
2. **白名单操作** —— 只执行安全操作（回滚/扩容/重启/降级），不执行破坏性操作
3. **生产环境需人类确认** —— P0 止血措施必须人类口头确认后执行
4. **止血后必须验证** —— 确认服务恢复，不是"执行了就行"
5. **记录所有操作** —— 止血过程全程记录，便于复盘

## 流程

### 1. 评估止血方案

读取 `spec.md` 了解故障现象，结合 `knowledge-base.md` 历史经验，评估可选止血方案：

| 止血方式 | 适用场景 | 时效 | 风险 |
|---------|---------|------|------|
| **回滚** | 新版本导致的故障 | 1-5 分钟 | 低（回到已知良好版本） |
| **扩容** | 流量激增/资源不足 | 2-10 分钟 | 低（成本增加） |
| **重启** | 内存泄漏/死锁 | 1-3 分钟 | 中（短暂中断） |
| **降级** | 依赖服务故障 | 即时 | 中（功能受限） |
| **熔断** | 防止级联失败 | 即时 | 中（影响下游） |
| **限流** | 保护后端 | 即时 | 中（拒绝部分请求） |

### 2. 选择止血策略

**优先级**：回滚 > 扩容 > 重启 > 降级 > 熔断 > 限流

**决策树**：
```
故障是否由近期部署引起?
  → 是: 回滚到上一版本
  → 否: 继续判断

是否资源不足（CPU/内存/连接）?
  → 是: 扩容
  → 否: 继续判断

是否单实例异常（其他正常）?
  → 是: 重启异常实例
  → 否: 继续判断

是否依赖服务故障?
  → 是: 降级（返回缓存/默认值）
  → 否: 限流保护 + 等待根因分析
```

### 3. 执行止血（按环境分层）

#### 回滚（调用 rollback skill）
- staging：Agent 直接执行
- production：Agent 生成 GitOps revert PR + 人类确认
- 紧急情况：Agent 建议，人类口头确认后执行 `kubectl rollout undo`

#### 扩容
```bash
# HPA 手动扩容
kubectl autoscale deployment <app> --min=5 --max=20 --cpu-percent=70

# 或直接修改副本数
kubectl scale deployment <app> --replicas=10
```
- staging：Agent 直接执行
- production：Agent 建议，人类确认后执行

#### 重启
```bash
# 重启异常 Pod
kubectl delete pod <pod-name> -n <namespace>

# 或滚动重启整个 Deployment
kubectl rollout restart deployment <app> -n <namespace>
```
- staging：Agent 直接执行
- production：Agent 建议，人类确认后执行

#### 降级
修改配置启用降级模式：
```yaml
# ConfigMap 修改
degradation:
  enabled: true
  fallback: cache  # 返回缓存数据
  features_disabled: [recommendation, search]  # 关闭非核心功能
```
- 通过 GitOps PR 修改
- 紧急情况：Agent 直接 patch ConfigMap + 重启

### 4. 验证止血效果

调用 `deployment-verify` skill：
- 错误率下降到正常水平 ✓
- 延迟恢复正常 ✓
- 业务指标恢复 ✓
- 告警消除 ✓

### 5. 记录止血过程

```
## 止血记录
- 故障 ID: [INC-xxx]
- 止血方案: [回滚/扩容/重启/降级]
- 执行时间: [ISO 8601]
- 执行环境: [staging/production]
- 审批方式: [Agent 自动/人类确认]
- 验证结果: [恢复/部分恢复/未恢复]
- 恢复耗时: [从止血决策到服务恢复]
- 后续动作: [根因分析/观察/修复]
```

追加到 `iterations.log`。

### 6. 决定下一步

- **止血成功**：进入 `root-cause-analysis` 深挖根因
- **部分恢复**：继续止血（尝试其他方案）或升级处理
- **止血失败**：升级到 P0，请求人类紧急介入

## 禁止事项

- 不执行破坏性操作（delete namespace / drop table / rm -rf）
- 不在 production 直接 kubectl delete（除非紧急且人类确认）
- 不跳过验证就声称"已恢复"
- 不在止血过程中同时修复 bug（先恢复，再修复）
- 不隐瞒止血失败（必须升级并通知）

## 与 LOOP 的关系

**所属 LOOP 类型**：incident（PROVISION 阶段）

```
LOOP(incident):
  PLAN(detect) → PROVISION(mitigate) → VERIFY
    ↓ 未恢复
  DEBUG(root-cause) → 回到 PROVISION（新止血方案）
```

**stage 字段写入**：provision

## 操作白名单

Agent 可执行的安全操作（staging 自动，production 需确认）：

| 操作 | 命令 | 风险 |
|------|------|------|
| 回滚 | `kubectl rollout undo` | 低 |
| 扩容 | `kubectl scale` / `kubectl autoscale` | 低 |
| 重启 Pod | `kubectl delete pod` / `kubectl rollout restart` | 中 |
| 降级 | 修改 ConfigMap（GitOps PR） | 中 |
| 限流 | 修改 Envoy/Istio 规则 | 中 |

**禁止操作**（任何环境都需人类审批）：
- `kubectl delete namespace`
- `kubectl delete deployment`（非滚动更新）
- `terraform destroy`
- `DROP TABLE` / `DELETE FROM`（无 WHERE）
- 修改 RBAC / NetworkPolicy
