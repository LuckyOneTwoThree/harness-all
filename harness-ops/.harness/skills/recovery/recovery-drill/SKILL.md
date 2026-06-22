---
name: recovery-drill
description: 恢复演练，定期执行备份恢复测试，验证 RTO/RPO 达标
triggers:
  - 定期恢复演练时
  - 备份验证时
  - 容灾预案测试时
  - 用户要求"测试恢复"时
  - disaster-recovery-workflow 触发时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<task-name>/spec.md
  - loops/specs/<task-name>/evidence.md
  - loops/specs/<task-name>/iterations.log
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: mutate-staging
requires_approval: true
---

# Recovery Drill — 恢复演练

## 铁律

1. **演练在隔离环境** —— 不在 production 直接恢复，用独立 namespace
2. **演练有 RTO/RPO 目标** —— 不只验证"能恢复"，还要验证"多快恢复"
3. **演练记录完整** —— 记录每步耗时，便于优化
4. **演练失败必须报告** —— 不隐瞒，失败说明备份不可信

## 流程

### 1. 制定演练计划

```
## 恢复演练计划

### 目标
- 验证备份可恢复性
- 测量 RTO（恢复时间目标）
- 测量 RPO（恢复点目标）
- 验证数据完整性

### 范围
- 备份源: production-daily-backup-2026-06-22
- 恢复目标: namespace `recovery-test`
- 恢复内容: payment-service + 相关资源

### RTO/RPO 目标
- RTO: < 30 分钟（从开始恢复到服务可用）
- RPO: < 24 小时（数据丢失不超过 1 天）
```

### 2. 执行恢复

```bash
# 创建恢复测试 namespace
kubectl create namespace recovery-test

# 执行 Velero 恢复
velero restore create recovery-test-2026-06-22 \
  --from-backup production-daily-backup-2026-06-22 \
  --namespace-mappings production:recovery-test \
  --wait

# 查看恢复状态
velero restore describe recovery-test-2026-06-22 --details
```

### 3. 记录恢复时间线

```
## 恢复时间线

| 时间 | 步骤 | 耗时 |
|------|------|------|
| 00:00 | 开始恢复 | - |
| 00:02 | Velero 恢复资源对象 | 2min |
| 00:05 | PVC 恢复完成 | 3min |
| 00:12 | Pod 启动完成 | 7min |
| 00:15 | 服务健康检查通过 | 3min |
| 00:18 | 冒烟测试通过 | 3min |
| 00:18 | 恢复完成 | 总计 18min |

### RTO 结果
- 目标: 30 分钟
- 实际: 18 分钟
- 结论: ✓ 达标
```

### 4. 验证数据完整性

```bash
# 对比源数据和恢复数据
kubectl exec -n recovery-test deployment/payment-service -- \
  psql -c "SELECT COUNT(*) FROM orders WHERE created_at >= '2026-06-21'"

# 对比 production 数据
kubectl exec -n production deployment/payment-service -- \
  psql -c "SELECT COUNT(*) FROM orders WHERE created_at >= '2026-06-21'"

# 期望: 数量一致（或差异在 RPO 范围内）
```

#### 数据完整性报告
```
## 数据完整性验证

### 订单数据
| 指标 | Production | Recovery | 差异 |
|------|-----------|----------|------|
| 总订单数 | 125,678 | 125,678 | 0 |
| 6月21日订单 | 3,456 | 3,456 | 0 |
| 最新订单时间 | 2026-06-22 01:59 | 2026-06-22 01:59 | 0 |

### RPO 结果
- 备份时间: 2026-06-22 02:00
- 最新数据: 2026-06-22 01:59
- 数据丢失: 1 分钟
- 目标: < 24 小时
- 结论: ✓ 达标
```

### 5. 验证服务可用性

```bash
# 健康检查
kubectl exec -n recovery-test deployment/payment-service -- curl localhost:8080/health

# 冒烟测试
kubectl exec -n recovery-test deployment/payment-service -- \
  curl -X POST localhost:8080/api/orders -d '{"test": true}'
```

### 6. 清理演练环境

```bash
# 删除恢复测试 namespace
kubectl delete namespace recovery-test

# 删除演练用的 Velero 恢复记录
velero restore delete recovery-test-2026-06-22
```

### 7. 生成演练报告

```
## 恢复演练报告

### 演练信息
- 日期: 2026-06-22
- 备份源: production-daily-backup-2026-06-22
- 恢复目标: recovery-test namespace

### 结果汇总
| 指标 | 目标 | 实际 | 达标 |
|------|------|------|------|
| RTO | 30min | 18min | ✓ |
| RPO | 24h | 1min | ✓ |
| 数据完整性 | 100% | 100% | ✓ |
| 服务可用性 | 可用 | 可用 | ✓ |

### 发现的问题
1. PVC 恢复较慢（7min），考虑优化存储
2. Pod 启动时间可优化（预热）

### 建议
- 每月执行一次恢复演练
- 下次演练测试全集群恢复
- 优化 PVC 恢复性能
```

### 8. 更新知识库

`memory/knowledge-base.md` 追加：
```
| 演练日期 | 备份源 | RTO目标 | RTO实际 | RPO目标 | RPO实际 | 结果 | 报告 |
|---------|--------|---------|---------|---------|---------|------|------|
| 2026-06-22 | daily-backup | 30min | 18min | 24h | 1min | ✓通过 | docs/recovery/drill-2026-06-22.md |
```

## 禁止事项

- 不在 production 直接恢复（用隔离 namespace）
- 不跳过数据完整性验证
- 不隐瞒演练失败
- 不演练后不清理环境
- 不只测"能恢复"不测"多快恢复"

## 与 LOOP 的关系

**所属 LOOP 类型**：recovery

```
LOOP(recovery):
  PLAN:       制定演练计划 → 确定目标
  PROVISION:  执行恢复 → 记录时间线
  VERIFY:     验证数据完整性 + 服务可用性
  通过? DONE : 分析问题 → 优化备份策略
```
