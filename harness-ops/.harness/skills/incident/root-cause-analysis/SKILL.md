---
name: root-cause-analysis
description: 根因分析，多源数据关联（日志/指标/链路/事件），识别故障根本原因
triggers:
  - 故障止血后需要定位根因时
  - incident LOOP 的 DEBUG 阶段执行时
  - 反复出现的间歇性问题需要深挖时
  - 监控告警无法用已知模式解释时
  - 用户要求"分析故障原因"时
reads:
  - loops/specs/<incident-id>/spec.md
  - loops/specs/<incident-id>/state.yaml
  - loops/specs/<incident-id>/iterations.log
  - memory/knowledge-base.md
  - rules/security.md
  - loops/LOOP.md
writes:
  - loops/specs/<incident-id>/evidence.md
  - loops/specs/<incident-id>/iterations.log
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 3
operation_tier: inspect
requires_approval: false
---

# Root Cause Analysis — 根因分析

## 铁律

1. **基于证据，不基于猜测** —— 每个根因假设必须有数据支撑
2. **多源关联，不单一维度** —— 日志+指标+链路+事件交叉验证
3. **找根因，不找症状** —— "CPU 高"是症状，"死循环"是根因
4. **5 Why 深挖** —— 不停留在第一层原因，连续追问

## 流程

### 1. 收集故障上下文

读取 `spec.md` 和 `iterations.log`：
- 故障现象：什么服务、什么错误、什么时间
- 已尝试的处置：止血措施是否有效
- 已有的假设：之前是否分析过

### 2. 多源数据采集

#### 2.1 日志分析
调用 `log-analysis` skill：
- 查询故障时间窗口的 ERROR/WARN 日志
- 识别异常模式（堆栈、超时、连接拒绝）
- 聚类相似错误（log pattern mining）

#### 2.2 指标分析
查询 Prometheus（PromQL）：
```promql
# 错误率
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])

# 延迟分布
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# 资源使用
rate(container_cpu_usage_seconds_total[5m])
container_memory_usage_bytes / container_spec_memory_limit_bytes

# 依赖服务
rate(redis_command_duration_seconds_sum[5m])
rate(mysql_query_duration_seconds_sum[5m])
```

对比故障前后指标变化，定位异常时间点。

#### 2.3 链路追踪
查询 Tempo/Jaeger：
- 找到失败请求的 trace
- 识别哪个 span 失败/超时
- 查看完整调用链路

#### 2.4 事件关联
查询 K8s 事件：
```bash
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
# 关注：OOMKilled, FailedScheduling, Unhealthy, BackOff
```

查询部署历史：
- 故障前是否有部署？
- 是否有配置变更？
- 是否有 DB Migration？

### 3. 生成根因假设

基于多源数据，列出所有可能的根因：

```
## 根因假设清单

### 假设 1: [描述]
- 证据: [日志/指标/链路]
- 置信度: [高/中/低]
- 验证方式: [如何确认]

### 假设 2: [描述]
- 证据: [...]
- 置信度: [...]
- 验证方式: [...]

### 假设 3: [描述]
- 证据: [...]
- 置信度: [...]
- 验证方式: [...]
```

### 4. 5 Why 深挖

对每个假设追问 5 层：

```
现象: 支付接口 500 错误率 8%

Why 1: 为什么 500？→ 数据库连接超时
Why 2: 为什么连接超时？→ 连接池耗尽
Why 3: 为什么连接池耗尽？→ 慢查询占用连接
Why 4: 为什么慢查询？→ 缺失索引，全表扫描
Why 5: 为什么缺失索引？→ Migration 漏加索引

根因: Migration 漏加索引导致慢查询，耗尽连接池
```

### 5. 验证根因

- **直接验证**：执行验证命令（如 EXPLAIN 慢查询）
- **对比验证**：与正常时段对比指标差异
- **排除验证**：排除其他假设

### 6. 产出根因报告

```
## 根因分析报告

### 故障摘要
- 故障 ID: [INC-xxx]
- 等级: [P0/P1/P2]
- 持续时间: [X 分钟]
- 影响范围: [描述]

### 根因
- 直接原因: [症状层]
- 根本原因: [根因层]
- 置信度: [高/中/低]
- 验证证据: [数据]

### 时间线
| 时间 | 事件 |
|------|------|
| 14:30 | 错误率开始上升 |
| 14:32 | 告警触发 |
| 14:35 | Agent 介入诊断 |
| 14:40 | 根因定位 |
| 14:45 | 止血措施执行 |
| 14:50 | 服务恢复 |

### 5 Why 分析
[完整链路]

### 建议修复
- 短期: [止血措施，已完成]
- 中期: [修复根因，如加索引]
- 长期: [预防措施，如加 Migration 检查]
```

写入 `evidence.md`。

### 7. 更新知识库

- `memory/knowledge-base.md` 故障库追加一行
- `memory/knowledge-base.md` 根因库追加（如发现新模式）
- `memory/knowledge-base.md` 踩坑记录追加（如有教训）

## 禁止事项

- 不在没有证据的情况下下结论
- 不停留在症状层（"CPU 高"不是根因）
- 不忽略多个假设（只找一个根因可能遗漏）
- 不篡改时间线（必须如实记录）
- 不隐瞒不确定项（置信度低的假设也要记录）

## 与 LOOP 的关系

**所属 LOOP 类型**：incident（DEBUG 阶段）

```
LOOP(incident):
  PLAN(detect) → PROVISION(mitigate) → VERIFY
    ↓ 未恢复或需根因
  DEBUG(root-cause-analysis)
    ↓ 找到根因
  回到 PROVISION（针对性修复）
```

**stage 字段写入**：debug

## 与其他 skill 的关系

- **上游**：`incident-detection`（创建故障记录）、`incident-mitigation`（止血后）
- **协作**：调用 `log-analysis`（日志）、查询 Prometheus/Grafana（指标）
- **下游**：产出根因报告供 `post-mortem` 使用
