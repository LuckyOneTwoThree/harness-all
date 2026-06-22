---
name: disaster-recovery-plan
description: 容灾预案设计，定义 RTO/RPO 目标/多 AZ 策略/降级方案/异地容灾
triggers:
  - 制定容灾预案时
  - OPS_STRATEGY.md 定义容灾策略时
  - 业务增长需要提升容灾能力时
  - 容灾演练规划时
  - 用户要求"设计容灾方案"时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/infrastructure/disaster-recovery-plan.md
  - loops/specs/<task-name>/spec.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
operation_tier: propose
requires_approval: false
---

# Disaster Recovery Plan — 容灾预案设计

## 铁律

1. **容灾有明确目标** —— RTO/RPO 必须量化
2. **容灾分层** —— 核心服务高可用，非核心可降级
3. **容灾可演练** —— 不能只写在纸上，必须可执行
4. **容灾有成本意识** —— 不盲目追求最高级别

## 流程

### 1. 定义服务分级

```
## 服务分级

### Tier 0（核心，RTO<5min, RPO<1min）
- payment-service（支付）
- order-service（订单）
- user-service（用户认证）
- 容灾要求: 多 AZ + 异地热备 + 自动切换

### Tier 1（重要，RTO<30min, RPO<1h）
- search-service（搜索）
- recommendation-service（推荐）
- 容灾要求: 多 AZ + 定期备份

### Tier 2（一般，RTO<4h, RPO<24h）
- admin-service（后台管理）
- report-service（报表）
- 容灾要求: 单 AZ + 每日备份

### Tier 3（非核心，RTO<24h, RPO<24h）
- log-analytics（日志分析）
- 容灾要求: 按需恢复
```

### 2. 设计多 AZ 策略

```yaml
# 多 AZ 部署配置
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
spec:
  replicas: 6
  template:
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: topology.kubernetes.io/zone
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
          matchLabels:
            app: payment-service
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  app: payment-service
              topologyKey: kubernetes.io/hostname
```

### 3. 设计异地容灾（如需）

```
## 异地容灾架构

### 主集群（北京）
- 运行所有服务
- 数据库主库
- 实时写入

### 备集群（上海）
- 运行 Tier 0 服务（冷备/热备）
- 数据库只读副本
- 异步复制（延迟 < 1s）

### 切换策略
- 自动切换: 主库健康检查失败 + 备库健康
- 手动切换: 主集群区域性故障
- 切换时间: < 5 分钟（RTO）
- 数据丢失: < 1 秒（RPO，异步复制延迟）
```

### 4. 设计降级方案

```yaml
# 降级配置
degradation:
  enabled: true
  levels:
    # Level 1: 关闭非核心功能
    - trigger: "CPU > 80%"
      actions:
        - disable_feature: recommendation
        - disable_feature: search
        - reduce_log_level: WARN
    
    # Level 2: 只保留核心链路
    - trigger: "CPU > 90% or ErrorRate > 5%"
      actions:
        - enable_rate_limit: 1000 req/s
        - disable_feature: admin
        - enable_cache_mode: aggressive
    
    # Level 3: 紧急模式
    - trigger: "Service unavailable"
      actions:
        - enable_maintenance_page
        - redirect_to_static_page
        - notify_oncall
```

### 5. 设计数据备份策略

```
## 数据备份策略

### 数据库
| 类型 | 频率 | 保留期 | 存储 |
|------|------|--------|------|
| 全量备份 | 每天 | 30 天 | 跨区域 S3 |
| 增量备份 | 每小时 | 7 天 | 同区域 S3 |
| Binlog/WAL | 实时 | 24 小时 | 本地 + 远程 |

### 对象存储
- 版本控制: 启用
- 跨区域复制: 启用
- 保留策略: 90 天

### 配置数据
- Git 仓库: 多副本（GitHub + 本地镜像）
- Secret: Vault 多副本
```

### 6. 设计应急响应流程

```
## 应急响应流程

### 1. 检测（< 1 min）
- 监控告警触发
- 用户反馈
- 巡检发现

### 2. 评估（< 5 min）
- 故障等级判定（P0/P1/P2）
- 影响范围评估
- 决策: 降级 / 切换 / 恢复

### 3. 响应（< RTO）
- P0: 立即启动容灾切换
- P1: 降级 + 排查
- P2: 排查 + 修复

### 4. 恢复（< RTO）
- 执行容灾切换/降级
- 验证服务恢复
- 通知相关方

### 5. 复盘（< 24h）
- 根因分析
- 改进措施
- 更新预案
```

### 7. 生成容灾预案文档

写入 `docs/infrastructure/disaster-recovery-plan.md`，包含上述全部内容。

### 8. 更新知识库

`memory/knowledge-base.md` 追加：
```
| 预案版本 | 服务分级 | 最高RTO | 最高RPO | 多AZ | 异地容灾 | 最后演练 |
|---------|---------|---------|---------|------|---------|---------|
| v1.0 | 4级 | 5min | 1min | ✓ | 规划中 | 待演练 |
```

## 禁止事项

- 不制定无法执行的容灾预案
- 不为所有服务追求最高容灾级别（成本考虑）
- 不跳过容灾演练
- 不在预案中包含明文凭据

## 与 LOOP 的关系

**所属 LOOP 类型**：无（规划类 skill）

本 skill 产出容灾预案文档，供人类决策。
执行容灾演练时由 recovery-drill skill 实施。
实际容灾切换由 incident-response-workflow 触发。
