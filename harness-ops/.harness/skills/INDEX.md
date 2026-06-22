# Skills Index — harness-ops

> 纯索引，40 行内。需要选 Skill 时读此文件，然后读对应 SKILL.md。
> 工作流编排见 `workflows/`。

## Meta Skill（4 个，✅ 已建设）

- **session-start** — 会话启动，加载上下文恢复工作状态
- **session-end** — 会话收尾，归档 + 产出 ops-to-pm.md
- **skill-maintenance** — skill 健康检查
- **memory-maintenance** — memory retention 清理

## 模块1 部署交付（4 个，✅ 已建设）

- **deployment-pipeline** — CI/CD 流水线编排与执行
- **release-strategy** — 发布策略选择（蓝绿/灰度/滚动）
- **rollback** — 回滚操作与验证
- **deployment-verify** — 部署验证与健康检查

## 模块2 基础设施（4 个，✅ 已建设）

- **infrastructure-as-code** — Terraform/Ansible IaC 管理
- **kubernetes-manifest** — K8s YAML 生成与维护
- **helm-management** — Helm chart 管理与维护
- **gitops-sync** — ArgoCD/Flux GitOps 同步管理

## 模块3 监控可观测（4 个，✅ 已建设）

- **monitoring-setup** — Prometheus/Grafana 监控体系部署
- **alerting-rules** — 告警规则生成与调优
- **log-analysis** — 日志查询与分析（LogQL/ES DSL）
- **dashboard-design** — Grafana Dashboard 生成

## 模块4 故障响应（4 个，✅ 已建设）

- **incident-detection** — 故障检测与分类
- **root-cause-analysis** — 根因分析（多源数据关联）
- **incident-mitigation** — 故障止血（白名单操作）
- **post-mortem** — 事后复盘报告

## 模块5 安全合规（4 个，✅ 已建设）

- **secret-management** — Secret 引用管理（不接触明文）
- **policy-as-code** — Kyverno 策略生成
- **security-scan** — Trivy/kube-bench 安全扫描
- **audit-review** — 审计日志分析

## 模块6 容量成本（3 个，✅ 已建设）

- **resource-right-sizing** — 资源右 sizing 建议
- **cost-analysis** — 云成本分析与优化
- **capacity-planning** — 容量规划建议

## 模块7 容灾备份（3 个，✅ 已建设）

- **backup-management** — Velero 备份管理
- **recovery-drill** — 恢复演练
- **disaster-recovery-plan** — 容灾预案设计

## 模块8 运维审查（2 个，✅ 已建设）

- **ops-review** — 运维回顾报告 + 产出 ops-to-pm.md
- **sla-report** — SLA 计算与报告

## 工作流（7 个，✅ 全部已建设）

- **deployment-workflow** — 部署全流程
- **incident-response-workflow** — 故障响应全流程
- **infrastructure-setup-workflow** — 基础设施搭建
- **monitoring-deployment-workflow** — 监控体系部署
- **security-audit-workflow** — 安全审计
- **disaster-recovery-workflow** — 容灾演练
- **ops-review-workflow** — 运维回顾
