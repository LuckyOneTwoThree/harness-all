---
name: incident-detection
description: 故障检测与分类，接收告警/用户反馈，分类故障等级，触发应急响应流程
triggers:
  - 收到 Prometheus/Alertmanager 告警时
  - 用户报告"线上故障"或"服务异常"时
  - 监控指标异常波动时
  - 错误率/延迟突然飙升时
  - session-start 发现进行中的 incident LOOP 时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
  - loops/specs/*/state.yaml
writes:
  - loops/specs/<incident-id>/spec.md
  - loops/specs/<incident-id>/state.yaml
  - docs/incident/
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
operation_tier: inspect
requires_approval: false
---

# Incident Detection — 故障检测与分类

## 铁律

1. **先止血再查因** —— 检测到故障后优先恢复服务，根因分析其次
2. **不隐瞒故障** —— 任何故障必须记录，不因"已恢复"而跳过归档
3. **不低估等级** —— 拿不准时按高等级处理，宁可虚惊
4. **不独自决策 P0** —— P0 故障必须立即通知人类，Agent 不独自处置

## 流程

### 1. 接收故障信号

信号来源：
- **告警系统**：Prometheus Alertmanager / 云厂商监控告警
- **用户反馈**：用户报告"服务不可用"/"响应慢"/"数据错误"
- **自动检测**：Agent 主动巡检发现异常
- **上游通知**：solo/growth 框架反馈异常

### 2. 初步评估

```
## 故障初步评估
- 检测时间: [ISO 8601]
- 信号来源: [告警/用户/巡检/上游]
- 故障现象: [详细描述]
- 影响范围: [哪些服务/哪些用户/多少流量]
- 持续时间: [已持续多久]
- 是否仍在恶化: [是/否]
```

### 3. 故障分级

| 等级 | 判定标准 | 响应时效 | 决策权 |
|------|---------|---------|--------|
| **P0** | 核心功能不可用/数据丢失/安全事件 | 立即响应，5 分钟内介入 | 人类 + Agent |
| **P1** | 部分功能异常/性能严重下降 | 15 分钟内介入 | 人类 + Agent |
| **P2** | 非核心功能异常/间歇性问题 | 1 小时内介入 | Agent + 通知人类 |
| **P3** | 潜在风险/优化建议 | 排期处理 | Agent |

**分级示例**：
- P0：支付接口 500 错误率 > 5%
- P1：登录接口 p95 延迟 > 5 秒
- P2：后台管理页面间歇性 404
- P3：某 Pod CPU 使用率持续 > 80%

### 4. 创建故障记录

```
loops/specs/INC-<date>-<short-desc>/
├── spec.md          ← 故障规格（覆盖）
├── state.yaml       ← 循环状态
├── evidence.md      ← 证据（覆盖）
└── iterations.log   ← 处置历史（追加）
```

**spec.md 内容**：
```yaml
incident_id: INC-2026-06-22-payment-500
severity: P0
detected_at: "2026-06-22T14:30:00"
phenomenon: "支付接口返回 500 错误，错误率 8%"
affected_services: [payment-service, order-service]
affected_users: "约 30% 支付用户"
impact: "无法完成支付，直接影响营收"
```

**state.yaml 初始化**：
```yaml
current_task: INC-2026-06-22-payment-500
iteration: 0
stage: plan
status: running
started_at: "2026-06-22T14:30:00"
```

### 5. 触发应急响应

- **P0/P1**：立即通知人类（AskUserQuestion），同时启动 `incident-response-workflow`
- **P2**：启动 `incident-response-workflow`，通知人类
- **P3**：记录到 FEATURES.md，排期处理

### 6. 查询历史知识库

读取 `memory/knowledge-base.md`：
- 是否有类似故障的历史记录？
- 是否有已知的根因模式？
- 是否有验证过的处置方案？

**如找到匹配**：直接应用历史方案，跳过部分诊断步骤。
**如无匹配**：进入 `root-cause-analysis` skill 全面诊断。

## 禁止事项

- 不延迟 P0/P1 故障的响应
- 不独自决策 P0 故障的处置（必须人类参与）
- 不因"已自动恢复"而跳过记录
- 不在故障未恢复时声称"已完成"
- 不篡改故障等级（降级需人类确认）

## 与 LOOP 的关系

**所属 LOOP 类型**：incident（最大迭代 5 次）

本 skill 是 incident LOOP 的入口，在 PLAN 阶段执行：
```
LOOP(incident):
  PLAN(detect):     incident-detection → 分级 → 创建记录
  PROVISION:        incident-mitigation → 止血
  VERIFY:           deployment-verify → 确认恢复
    ↓ 未恢复
  DEBUG:            root-cause-analysis → 深度诊断
    ↓ 回到 PROVISION（新处置方案）
```

**stage 字段写入**：plan

## 与其他 skill 的关系

- **下游**：触发 `incident-mitigation`（止血）、`root-cause-analysis`（根因）
- **协作**：调用 `rollback`（如需回滚）、`log-analysis`（日志查询）
- **归档**：故障恢复后由 `post-mortem` 产出复盘报告
