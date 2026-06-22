---
name: post-mortem
description: 故障复盘报告，总结时间线/根因/影响/改进项，沉淀到知识库避免重复
triggers:
  - P0/P1 故障恢复后
  - incident LOOP 完成后
  - 用户要求"写复盘报告"时
  - session-end 检测到有结题的 incident 时
  - 定期回顾历史故障时
reads:
  - loops/specs/<incident-id>/spec.md
  - loops/specs/<incident-id>/evidence.md
  - loops/specs/<incident-id>/iterations.log
  - memory/knowledge-base.md
  - docs/handoff/ops-to-pm-template.md
writes:
  - docs/incident/<incident-id>-post-mortem.md
  - docs/handoff/ops-to-pm.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
operation_tier: inspect
requires_approval: false
---

# Post-Mortem — 故障复盘报告

## 铁律

1. **对事不对人** —— 复盘是为了改进，不是为了追责
2. **不隐瞒失误** —— Agent 自身的判断失误也要如实记录
3. **每个改进项必须有负责人和截止日期** —— 否则复盘无意义
4. **沉淀到知识库** —— 复盘结论必须写入 knowledge-base.md
5. **不报喜不报忧** —— 成功和失败都要分析

## 流程

### 1. 收集故障全貌

读取所有相关文件：
- `spec.md` — 故障规格
- `evidence.md` — 根因分析报告
- `iterations.log` — 完整处置时间线
- `knowledge-base.md` — 历史类似故障

### 2. 梳理时间线

```
## 故障时间线

| 时间 | 事件 | 来源 |
|------|------|------|
| 14:25:00 | 部署 v1.2.3 到 production | deployment-pipeline |
| 14:30:00 | 错误率开始上升（5%→8%） | Prometheus |
| 14:32:00 | Alertmanager 触发告警 | 告警系统 |
| 14:33:00 | Agent 接收告警，创建 INC-xxx | incident-detection |
| 14:35:00 | Agent 评估为 P0，通知人类 | incident-detection |
| 14:37:00 | 人类确认，Agent 执行回滚 | incident-mitigation |
| 14:40:00 | 回滚完成，错误率下降 | rollback |
| 14:45:00 | 服务完全恢复 | deployment-verify |
| 14:50:00 | 开始根因分析 | root-cause-analysis |
| 15:10:00 | 根因定位：Migration 漏加索引 | root-cause-analysis |
```

### 3. 影响评估

```
## 影响评估

### 业务影响
- 持续时间: 15 分钟（14:30-14:45）
- 影响用户: 约 3000 次支付请求失败
- 直接损失: 约 ¥45,000（按客单价 ¥15 估算）
- SLA 影响: 本月可用性从 99.95% 降至 99.92%

### 技术影响
- 受影响服务: payment-service, order-service
- 资源消耗: 故障期间 CPU 飙升至 95%
- 数据影响: 无数据丢失/损坏
```

### 4. 根因总结

```
## 根因分析

### 直接原因
支付接口调用数据库超时，连接池耗尽导致 500 错误。

### 根本原因
v1.2.3 的 DB Migration 新增了 `user_orders` 表但漏加索引，
导致 `SELECT * FROM user_orders WHERE user_id = ?` 全表扫描，
单查询耗时从 10ms 升至 2s，连接池在 30 秒内耗尽。

### 5 Why 分析
1. 为什么 500？→ 数据库连接超时
2. 为什么连接超时？→ 连接池耗尽
3. 为什么耗尽？→ 慢查询占用
4. 为什么慢？→ 漏加索引
5. 为什么漏加？→ Migration review 流程未检查索引
```

### 5. 处置评估

```
## 处置评估

### 做得好的
- ✅ 告警及时（2 分钟内触发）
- ✅ Agent 响应迅速（1 分钟内创建记录）
- ✅ 回滚决策正确（止血有效）
- ✅ 根因定位准确

### 待改进的
- ❌ 部署前未发现 Migration 缺失索引
- ❌ staging 环境未覆盖生产数据量级，未暴露慢查询
- ❌ 从告警到回滚耗时 8 分钟，可优化至 5 分钟内
```

### 6. 改进项清单

```
## 改进项

| 编号 | 改进项 | 类型 | 负责人 | 截止日期 | 优先级 |
|------|--------|------|--------|---------|--------|
| IMP-001 | Migration review 增加索引检查清单 | 流程 | @backend-lead | 2026-07-01 | P0 |
| IMP-002 | staging 环境增加生产数据量级测试 | 工具 | @ops | 2026-07-15 | P1 |
| IMP-003 | 慢查询告警阈值从 1s 调整为 500ms | 监控 | @ops | 2026-06-25 | P1 |
| IMP-004 | 自动回滚触发条件增加"连接池使用率>90%" | 自动化 | @ops | 2026-07-10 | P2 |
```

### 7. 产出文档

#### 7.1 复盘报告
写入 `docs/incident/<incident-id>-post-mortem.md`，包含上述全部内容。

#### 7.2 通知 PM（如需）
如故障影响业务或需要产品侧改进，按 `ops-to-pm-template.md` 填写并追加到 `docs/handoff/ops-to-pm.md`：
- 事故通报：故障摘要 + 影响
- 改进计划：需要 PM 协调的事项

#### 7.3 更新知识库

`memory/knowledge-base.md` 追加：

**故障库**：
```
| 故障ID | 等级 | 现象 | 根因 | 持续时间 | 影响 | 改进项 | 日期 |
|--------|------|------|------|---------|------|--------|------|
| INC-2026-06-22-payment-500 | P0 | 支付500错误 | Migration漏加索引 | 15分钟 | ¥45k损失 | 4项 | 2026-06-22 |
```

**根因库**（如发现新模式）：
```
| 根因模式 | 适用场景 | 识别特征 | 处置方式 | 来源 |
|---------|---------|---------|---------|------|
| Migration漏加索引 | 部署后慢查询激增 | 连接池耗尽+CPU飙升 | 回滚+补索引 | INC-2026-06-22 |
```

**踩坑记录**（如有教训）：
```
| 日期 | 问题 | 解决方案 | 相关文件 |
|------|------|---------|---------|
| 2026-06-22 | Migration review 未检查索引 | 增加索引检查清单 | docs/incident/INC-xxx-post-mortem.md |
```

## 禁止事项

- 不篡改时间线（如实记录）
- 不隐瞒 Agent 自身失误
- 不给出无负责人的改进项
- 不跳过知识库沉淀
- 不在复盘报告中包含用户 PII

## 与 LOOP 的关系

**所属 LOOP 类型**：无（非循环，incident LOOP 完成后执行）

本 skill 在 incident LOOP status=done 后触发，是会话级/故障级的归档动作。
通常由 session-end 触发，或用户显式要求时执行。

## 与其他 skill 的关系

- **上游**：`root-cause-analysis`（根因报告）、`incident-mitigation`（止血记录）
- **协作**：调用 `ops-review`（如需汇总到周期报告）
- **下游**：产出 `ops-to-pm.md`（通知 PM）
