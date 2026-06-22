# Workflow: 基础设施搭建（Infrastructure Setup Workflow）

> 所属 LOOP 类型：provision
> 触发场景：新环境搭建、基础设施扩容、新服务上线需要配置资源
> 编排 Skill：infrastructure-as-code → kubernetes-manifest → helm-management → gitops-sync → deployment-verify

## 流程图

```
┌─────────────────────────────────────────────────────────┐
│ 评估基础设施需求（读取 OPS_STRATEGY.md）                  │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ infrastructure-as-code            │  生成 Terraform/Ansible
          │                                   │  terraform plan[质量门]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ [人类审批]                        │  production apply 需确认
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ terraform apply                   │  创建云资源
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ kubernetes-manifest              │  生成 K8s 部署配置
          │ 或 helm-management               │  或 Helm values
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ gitops-sync                       │  提交 GitOps PR
          │                                   │  [人类 review + merge]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify                 │  验证资源创建+配置正确
          └─────────────────────────────────┘
```

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| terraform plan 后 | 资源变更符合预期 + 无意外销毁 | 修正 IaC 代码 |
| K8s Manifest 生成后 | 最佳实践检查通过 | 修正 Manifest |
| apply 前（生产） | 人类确认 plan 摘要 | 拒绝则终止 |
| 部署后验证 | 资源 Running + 健康检查通过 | 排查并修复 |

## 使用方式

对 Agent 说：
- "搭建新的 staging 环境" → 触发本 workflow
- "为新服务配置基础设施" → 从 infrastructure-as-code 开始
- "扩容 EKS 节点组" → 从 infrastructure-as-code 开始
