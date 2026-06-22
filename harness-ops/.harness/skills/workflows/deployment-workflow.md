# Workflow: 部署全流程（Deployment Workflow）

> 所属 LOOP 类型：provision
> 触发场景：收到 solo-to-ops.md 交接文档、用户要求部署新版本、CI/CD 流水线触发
> 编排 Skill：deployment-pipeline → release-strategy → [staging部署] → deployment-verify → [GitOps PR] → [人类审批] → [production部署] → deployment-verify → [产出 ops-to-pm.md]

## 流程图

```
┌─────────────────────────────────────────────────────────┐
│ 消费 solo-to-ops.md（前置硬门，字段缺失不开始）            │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-pipeline              │  评估影响面 + 编排流水线
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ release-strategy                 │  选择发布策略（滚动/灰度/蓝绿）
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ [staging 部署]                   │  Agent 可直接执行
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify[质量门1]       │  staging 健康检查+冒烟测试
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ staging 验证通过?  │
                  └─────────┬─────────┘
                    ↓ 是    │    ↓ 否
                            │    回滚 → 分析原因 → 回到部署
                            ▼
          ┌─────────────────────────────────┐
          │ 生成 GitOps PR（production）     │  Agent 生成，不直接 apply
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ [人类审批门]                     │  AskUserQuestion 请求确认
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ 人类批准?          │
                  └─────────┬─────────┘
                    ↓ 是    │    ↓ 否
                            │    终止部署，记录原因
                            ▼
          ┌─────────────────────────────────┐
          │ [production 部署]                │  GitOps 同步（ArgoCD/Flux）
          │ 灰度: 5%→25%→100%               │  每阶段 deployment-verify
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify[质量门2]       │  production 健康检查+监控验证
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ production 验证通过?│
                  └─────────┬─────────┘
                    ↓ 是    │    ↓ 否
                            │    rollback → 通知人类 → 退出
                            ▼
          ┌─────────────────────────────────┐
          │ 归档：部署记录 + 知识库          │
          │ 产出 ops-to-pm.md（如需）        │
          └─────────────────────────────────┘
```

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| 前置硬门 | solo-to-ops.md 字段完整（6 项必填） | 要求 solo 补全，不开始部署 |
| staging 验证 | 健康检查+冒烟测试+监控平稳 | 自动回滚 staging，分析原因 |
| 人类审批门 | 人类 review GitOps PR | 拒绝则终止，记录原因 |
| 灰度每阶段 | 错误率<1% + 延迟正常 + 业务指标稳定 | 自动回滚到上一阶段 |
| production 验证 | 四件套全通过（健康+冒烟+监控+日志） | 触发 rollback，通知人类 |

## 数据流

| 阶段 | 产出 | 存储位置 |
|------|------|---------|
| 消费交接 | 交接文档解析结果 | progress.md |
| deployment-pipeline | 部署方案 + 流水线配置 | spec.md + docs/deployment/ |
| release-strategy | 发布策略方案 | spec.md |
| staging 部署 | K8s Manifest / Helm values | docs/deployment/ |
| staging 验证 | 验证报告 | evidence.md |
| GitOps PR | PR 内容 + diff | Git 仓库 |
| production 部署 | 部署记录 | iterations.log |
| production 验证 | 最终验证报告 | evidence.md |
| 归档 | 部署记录 + ops-to-pm.md | docs/deployment/ + docs/handoff/ + knowledge-base.md |

## 与 LOOP 的交互

```
LOOP(provision):
  PLAN:       deployment-pipeline → release-strategy → 生成配置
  PROVISION:  staging 部署 → [GitOps PR] → [人类审批] → production 部署
  VERIFY:     deployment-verify（staging + production 每阶段）
  通过? DONE : rollback → 分析原因 → 可修复回 PROVISION / 需重新规划回 PLAN
```

## 环境分层执行

| 操作 | staging | production |
|------|---------|------------|
| 生成配置 | Agent | Agent |
| kubectl apply | Agent | ❌ GitOps PR |
| 健康检查 | Agent | Agent |
| 回滚 | Agent 自动 | Agent 建议 + 人类确认 |
| 数据库 Migration | Agent | 人类执行 |

## 使用方式

对 Agent 说：
- "solo 交付了新版本，开始部署" → 触发本 workflow
- "部署 v1.2.3 到 staging" → 从 deployment-pipeline 开始
- "staging 验证通过了，推进到 production" → 从 GitOps PR 开始
- "部署失败了，回滚" → 触发 rollback skill
