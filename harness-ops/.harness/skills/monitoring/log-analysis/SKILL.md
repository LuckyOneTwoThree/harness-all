---
name: log-analysis
description: 日志查询与分析，生成 LogQL/ES DSL 查询，日志模式发现与异常聚类
triggers:
  - 故障排查需要查询日志时
  - root-cause-analysis 需要日志证据时
  - 用户要求"查日志"时
  - 监控告警需要日志关联时
  - 需要分析日志模式时
reads:
  - loops/specs/<incident-id>/spec.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<incident-id>/evidence.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
operation_tier: inspect
requires_approval: false
---

# Log Analysis — 日志查询与分析

## 铁律

1. **查询有时间范围** —— 不全量扫描，限定时间窗口
2. **查询有目的** —— 知道要找什么，不做无目的浏览
3. **日志不含 PII** —— 查询结果脱敏后再展示
4. **模式发现优先于逐行阅读** —— 用聚合查询，不逐行看

## 流程

### 1. 明确查询目的

- **故障诊断**：找 ERROR/Exception/堆栈
- **性能分析**：找慢查询/超时/重试
- **安全审计**：找异常访问/权限变更
- **业务分析**：找特定用户/订单的行为轨迹

### 2. 生成 LogQL 查询（Loki）

#### 基础查询
```logql
# 查询特定服务的日志
{app="payment-service", namespace="production"}

# 查询特定时间范围
{app="payment-service"} |= "2026-06-22T14:"

# 查询 ERROR 日志
{app="payment-service"} |= "ERROR" | json

# 查询异常堆栈
{app="payment-service"} |~ "Exception|Error|Traceback"

# 查询特定请求
{app="payment-service", request_id="abc-123"}
```

#### 聚合查询
```logql
# 错误日志计数（按时间）
sum(count_over_time({app="payment-service"} |= "ERROR" [5m]))

# 错误率趋势
sum(rate({app="payment-service"} |= "ERROR" [5m])) by (status)

# 日志模式发现
pattern({app="payment-service"} |= "ERROR")
```

### 3. 生成 ES DSL 查询（Elasticsearch）

```json
{
  "query": {
    "bool": {
      "must": [
        {"match": {"service": "payment-service"}},
        {"match": {"level": "ERROR"}},
        {"range": {"@timestamp": {"gte": "2026-06-22T14:00:00", "lte": "2026-06-22T15:00:00"}}}
      ]
    }
  },
  "sort": [{"@timestamp": "desc"}],
  "size": 100
}
```

### 4. 日志模式发现

#### 识别重复模式
```logql
# 使用 pattern 提取日志模式
{app="payment-service"} | pattern "<ip> <method> <path> <status> <duration>"
```

#### 异常聚类
- 相同堆栈的 ERROR 聚合
- 相同错误码的请求聚合
- 相同超时模式的查询聚合

### 5. 多源日志关联

#### 链路追踪关联
```
1. 从 trace_id 找到完整调用链
2. 找到失败的 span
3. 查询该 span 对应的日志
4. 查询上下游服务的日志
```

#### 时间线关联
```
14:30:00  payment-service  ERROR  Database connection timeout
14:30:01  postgres         LOG    too many connections
14:30:02  payment-service  WARN   Retrying (attempt 2/3)
14:30:05  payment-service  ERROR  Max retries exceeded
```

### 6. 生成日志分析报告

```
## 日志分析报告

### 查询条件
- 服务: payment-service
- 时间范围: 2026-06-22 14:25:00 ~ 14:45:00
- 关键词: ERROR / Exception

### 发现
1. 14:30:00 开始出现数据库连接超时错误
2. 错误模式: "Database connection timeout after 30s"
3. 频率: 每分钟约 50 次
4. 关联: postgres 日志显示 "too many connections" (max_connections=100)

### 异常模式
- 14:30-14:35: 连接超时错误密集（50/min）
- 14:35-14:40: 错误率下降（回滚生效）
- 14:40-14:45: 错误消失（服务恢复）

### 结论
根因指向数据库连接池耗尽，与 root-cause-analysis 的假设一致。
```

### 7. 更新知识库

如发现新的日志模式，追加到 `memory/knowledge-base.md`：
```
| 日志模式 | 含义 | 关联根因 | 处置方式 | 来源 |
|---------|------|---------|---------|------|
| "too many connections" | DB连接池耗尽 | 慢查询/连接泄漏 | 扩容/修复慢查询 | INC-xxx |
```

## 禁止事项

- 不全量扫描日志（必须限定时间范围）
- 不在日志中暴露用户 PII（查询时脱敏）
- 不无目的浏览日志（必须有查询假设）
- 不篡改日志（只读，不修改）
- 不将敏感日志内容写入交接文档

## 与 LOOP 的关系

**所属 LOOP 类型**：incident（DEBUG 阶段）

本 skill 在 root-cause-analysis 执行时被调用，提供日志证据。
也可在 incident-detection 阶段被调用，快速判断故障现象。
