---
name: release-strategy
description: 发布策略选择与设计（蓝绿/灰度/滚动/A-B测试），根据影响面推荐最优发布方式
triggers:
  - 需要选择发布策略时
  - 高影响面变更需要灰度方案时
  - 用户要求"蓝绿部署"或"金丝雀发布"时
  - OPS_STRATEGY.md 需要定义发布规范时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - docs/handoff/solo-to-ops.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - docs/deployment/release-strategy.md
  - loops/specs/<task-name>/spec.md
quality_gates: []
max_iterations: 2
operation_tier: propose
requires_approval: false
---

# Release Strategy — 发布策略选择与设计

## 铁律

1. **影响面决定策略** —— 高影响面必须灰度，不允许一刀切全量
2. **每阶段都有健康门** —— 灰度每推进一个比例都必须通过健康检查
3. **随时可回滚** —— 任何阶段失败必须能立即回滚到上一版本
4. **不跳阶段** —— 灰度必须按 5%→25%→100% 推进，不跳过中间阶段

## 流程

### 1. 评估变更影响面

读取 `solo-to-ops.md` 的变更内容，评估影响面：

| 影响面 | 判定标准 | 推荐策略 |
|--------|---------|---------|
| **低** | 配置调整、Bug 修复、非核心功能 | 滚动更新（RollingUpdate） |
| **中** | 新功能、接口变更、性能优化 | 灰度发布（Canary 5%→25%→100%） |
| **高** | DB Migration、Breaking Change、核心链路改动 | 蓝绿部署 + 维护窗口 |

### 2. 选择发布策略

#### 滚动更新（RollingUpdate）
- 适用：低影响面，K8s 默认策略
- 参数：maxSurge=25%, maxUnavailable=25%
- 验证：新 Pod readiness 通过后继续滚动

#### 灰度发布（Canary）
- 适用：中影响面，需逐步验证
- 流程：
  ```
  5% 流量 → 观察 10 分钟（错误率/延迟/业务指标）
    ↓ 通过
  25% 流量 → 观察 30 分钟
    ↓ 通过
  100% 流量 → 完成
  ```
- 工具：Argo Rollouts / Flagger / Istio 流量切分

#### 蓝绿部署（Blue-Green）
- 适用：高影响面，需快速切换
- 流程：
  ```
  准备 Green 环境 → 部署新版本 → 冒烟测试
  → [人类审批] → 切换流量 → 观察 → 下线 Blue
  ```
- 优势：切换瞬间完成，回滚=切回 Blue

#### A/B 测试
- 适用：需要对比业务指标（转化率/点击率）
- 与 growth 框架协作：由 growth 设计实验，ops 负责流量切分

### 3. 生成发布方案

```yaml
# 发布方案示例
strategy: canary
target_environment: production
image: registry.example.com/app:v1.2.3
steps:
  - phase: canary-5
    traffic_percentage: 5
    duration_minutes: 10
    success_criteria:
      - error_rate < 1%
      - p95_latency < 200ms
      - business_metric_stable
    rollback_on_failure: true
  - phase: canary-25
    traffic_percentage: 25
    duration_minutes: 30
    success_criteria: [...]
  - phase: full
    traffic_percentage: 100
    duration_minutes: 60
    success_criteria: [...]
rollback:
  strategy: revert-traffic
  max_seconds: 30
```

### 4. 定义健康门（Success Criteria）

每阶段必须定义：
- **技术指标**：错误率 < 1%, p95 延迟 < 200ms, CPU < 80%
- **业务指标**：转化率/订单量/活跃数不下降
- **护栏指标**：不触发其他服务告警

### 5. 定义回滚方案

- 触发条件：任一健康门未通过
- 回滚方式：流量切回旧版本 / 镜像回退 / 配置回退
- 回滚时效：蓝绿 < 30秒, 灰度 < 5分钟, 滚动 < 10分钟

## 禁止事项

- 不对高影响面变更使用滚动更新（必须灰度或蓝绿）
- 不跳过灰度阶段（5%→100% 一蹴而就）
- 不在没有健康门的情况下推进灰度
- 不在没有回滚方案的情况下开始发布

## 与 LOOP 的关系

**所属 LOOP 类型**：provision

本 skill 在 PLAN 阶段执行，产出发布方案写入 spec.md。
PROVISION 阶段按方案执行，VERIFY 阶段检查健康门。
