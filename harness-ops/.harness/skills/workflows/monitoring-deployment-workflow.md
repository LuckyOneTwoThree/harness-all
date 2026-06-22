# Workflow: 监控体系部署（Monitoring Deployment Workflow）

> 所属 LOOP 类型：provision
> 触发场景：新服务上线需要配置监控、监控体系缺失需要搭建
> 编排 Skill：monitoring-setup → alerting-rules → dashboard-design → deployment-verify

## 流程图

```
┌─────────────────────────────────────────────────────────┐
│ 评估监控需求（读取 OPS_STRATEGY.md 监控告警矩阵）         │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ monitoring-setup                 │  部署采集器+存储+可视化
          │                                   │  Prometheus/Loki/Tempo/Grafana
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ alerting-rules                   │  生成告警规则
          │                                   │  配置 Alertmanager 路由
          │                                   │  定义抑制规则[质量门]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ dashboard-design                 │  生成 Grafana Dashboard
          │                                   │  黄金信号四件套
          │                                   │  SLO 阈值线[质量门]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify                 │  验证采集+查询+告警+可视化
          └─────────────────────────────────┘
```

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| 监控部署后 | Prometheus targets up + 日志可查 + 链路可追踪 | 修复采集配置 |
| 告警规则生成后 | 每个告警有 runbook + 有严重度 + 有路由 | 补全告警元数据 |
| Dashboard 生成后 | 黄金信号齐全 + SLO 阈值线标注 | 补全 Dashboard |
| 最终验证 | 模拟告警可触发 + Dashboard 可访问 | 修复并重验 |

## 使用方式

对 Agent 说：
- "为新服务配置监控" → 触发本 workflow
- "部署 Prometheus + Grafana" → 从 monitoring-setup 开始
- "配置告警规则" → 从 alerting-rules 开始
