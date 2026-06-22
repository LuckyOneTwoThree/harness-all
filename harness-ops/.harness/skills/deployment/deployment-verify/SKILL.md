---
name: deployment-verify
description: 部署验证与健康检查，执行健康检查/冒烟测试/监控验证/日志检查四件套
triggers:
  - 部署完成后验证时
  - 灰度发布每阶段健康门检查时
  - 回滚后验证恢复时
  - 用户要求"检查部署是否成功"时
  - LOOP 的 VERIFY 阶段执行时
reads:
  - loops/specs/<task-name>/spec.md
  - docs/handoff/solo-to-ops.md
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
writes:
  - loops/specs/<task-name>/evidence.md
  - loops/specs/<task-name>/state.yaml
  - loops/specs/<task-name>/iterations.log
quality_gates: []
max_iterations: 1
operation_tier: inspect
requires_approval: false
---

# Deployment Verify — 部署验证与健康检查

## 铁律

1. **没有证据不声称完成** —— 必须展示实际验证数据，不是"应该没问题"
2. **四件套缺一不可** —— 健康检查 + 冒烟测试 + 监控验证 + 日志检查
3. **护栏指标必须检查** —— 不只看主指标，还要确认无副作用
4. **验证失败立即回滚** —— 不存侥幸心理"再等等看"

## 流程

### 1. 健康检查（Health Check）

验证 Pod/服务是否正常运行：

```bash
# K8s Pod 状态
kubectl get pods -n <namespace> -l app=<app-name>
# 期望：所有 Pod Running + Ready 1/1

# Readiness Probe
kubectl describe pod <pod-name> | grep -A 5 Readiness
# 期望：Ready 状态

# HTTP 健康端点
curl -f http://<service>:<port>/health
# 期望：HTTP 200 + 响应体正常

# 启动时间检查
kubectl get pods -o custom-columns=NAME:.metadata.name,AGE:.metadata.creationTimestamp
# 期望：新 Pod 已启动且稳定运行 > 30 秒
```

**失败判定**：
- Pod 状态非 Running/Ready
- CrashLoopBackOff / ImagePullBackOff / OOMKilled
- HTTP 健康端点非 200
- 启动时间 < 30 秒（可能还在初始化）

### 2. 冒烟测试（Smoke Test）

读取 `solo-to-ops.md` 的冒烟测试检查点，逐项执行：

```
## 冒烟测试清单（来自 solo-to-ops.md）
- [ ] /health 端点返回 200
- [ ] /ready 端点返回 200
- [ ] 核心接口 [POST /api/orders] 返回 200
- [ ] 数据库连接正常（查询 users 表 limit 1）
- [ ] 缓存连接正常（Redis PING）
- [ ] 消息队列连接正常（RabbitMQ queue.list）
```

**执行方式**：
- Agent 通过 kubectl exec 或 curl 执行
- 每项记录实际响应，标注 ✓/✗
- 任一失败则整体失败

### 3. 监控验证（Metrics Verification）

检查部署后监控指标是否平稳：

```
## 监控指标检查（部署后 5-10 分钟）
### 错误率
- 部署前 5 分钟: [X%]
- 部署后 5 分钟: [Y%]
- 判定: Y ≤ X + 0.5% ✓ / Y > X + 1% ✗

### 延迟
- p50 部署前: [Xms] / 部署后: [Yms]
- p95 部署前: [Xms] / 部署后: [Yms]
- p99 部署前: [Xms] / 部署后: [Yms]
- 判定: Y ≤ X * 1.2 ✓ / Y > X * 1.5 ✗

### 吞吐量
- 部署前: [X req/s]
- 部署后: [Y req/s]
- 判定: Y ≥ X * 0.9 ✓ / Y < X * 0.7 ✗

### 资源使用
- CPU: [X%] (阈值 80%)
- Memory: [X%] (阈值 85%)
- 判定: 低于阈值 ✓
```

**数据来源**：Prometheus 查询（PromQL）/ Grafana Dashboard / 云厂商监控

### 4. 日志检查（Log Inspection）

检查部署后日志是否有异常：

```
## 日志检查
### 错误日志
kubectl logs -n <ns> -l app=<app> --since=10m | grep -E "ERROR|FATAL|Exception"
# 期望：无新增 ERROR，或 ERROR 数量不高于部署前

### 警告日志
kubectl logs -n <ns> -l app=<app> --since=10m | grep -E "WARN"
# 期望：无异常增长

### 启动日志
kubectl logs -n <ns> -l app=<app> --since=10m | grep -E "Started|Ready|Listening"
# 期望：看到正常启动日志
```

### 5. 护栏指标检查

确认部署未影响其他服务：
- 依赖本服务的下游服务无异常告警
- 本服务依赖的上游服务无连接异常
- 数据库连接池无泄漏
- 消息队列无积压

### 6. 生成验证报告

```
## 部署验证报告
- 任务: [task-name]
- 版本: [v1.2.3]
- 环境: [staging/production]
- 验证时间: [ISO 8601]

### 验证结果
| 检查项 | 结果 | 详情 |
|--------|------|------|
| 健康检查 | ✓/✗ | [详情] |
| 冒烟测试 | ✓/✗ | [通过数/总数] |
| 监控验证 | ✓/✗ | [指标摘要] |
| 日志检查 | ✓/✗ | [错误数] |
| 护栏指标 | ✓/✗ | [详情] |

### 结论
- 整体结果: [通过/失败]
- 下一步: [DONE / 触发回滚 / 继续观察]
```

写入 `loops/specs/<task>/evidence.md`。

### 7. 更新状态

- 验证通过：`state.yaml` status=done, stage=verify
- 验证失败：`state.yaml` status=retrying, stage=verify, last_error=[详情]
- 追加 `iterations.log`：记录本次验证结果

## 禁止事项

- 不跳过任何一项检查（四件套缺一不可）
- 不用"看起来正常"代替实际数据
- 不忽略护栏指标异常
- 不在验证失败后继续推进灰度
- 不篡改验证结果

## 与 LOOP 的关系

**所属 LOOP 类型**：provision（VERIFY 阶段）、incident（VERIFY 阶段）

本 skill 是 LOOP 的 VERIFY 阶段核心执行者。
- provision LOOP：部署后验证，失败触发 rollback
- incident LOOP：故障恢复后验证，失败继续排障

**stage 字段写入**：verify

## 声称"完成"的前置条件

- [ ] 健康检查通过（Pod Running/Ready, HTTP 200）
- [ ] 冒烟测试全部通过
- [ ] 监控指标平稳（错误率/延迟/吞吐）
- [ ] 日志无异常 ERROR
- [ ] 护栏指标无异常
- [ ] 验证报告写入 evidence.md
- [ ] state.yaml 更新
