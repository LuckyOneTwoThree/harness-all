# Skills 索引

> 纯索引，40 行内。需要选 Skill 时读。工作流编排见 `workflows/`。
> 定位：harness-pm 是**产品管理框架**，PM 方法论 skill 在 `.harness/skills/pm/` 目录下（82 个）。
> 工程开发见 harness 家族其他成员（通过 docs/handoff/ 交接）。

## 元 skill（.harness/skills/meta/）
- **session-start** — 会话启动，加载上下文恢复工作状态
- **session-end** — 会话收尾，归档进度 + 写 baseline + 更新看板 + 产出交接文档
- **skill-maintenance** — skill 健康检查
- **memory-maintenance** — memory retention 清理

## 工作流（.harness/skills/workflows/，10 个）
- **setup** — 立项引导（install.sh 后引导填写 SOUL/constitution/PRODUCT_STRATEGY 骨架）
- **new-product** — 从 0 到 1 做新产品（模块1→2→3→4→7监控准备）
- **iteration** — 已有产品功能迭代（模块3→5→7，变更驱动）
- **growth** — 增长突破（模块6→5实验→7发布）
- **optimization** — 数据驱动优化（模块5→7→3，数据驱动）
- **launch** — 验收发布（模块7，含埋点补充能力）
- **diagnosis** — 产品诊断与下线（模块7，被动触发）
- **pivot** — 战略调整（模块1→2，战略级变更）
- **incident-response** — 危机响应（模块7，P0事故紧急通道）
- **health-check** — 定期健康检查（模块7，主动体检）

## PM 方法论 skill（.harness/skills/pm/，82 个 = 19 orchestrator + 63 pipeline，7 个模块）
- **模块1 探索发现**：10 pipeline + 2 orchestrator = 12（user-research / market，insight/opportunity 退化壳已删）
- **模块2 商业战略**：11 pipeline + 2 orchestrator = 13（business / planning，positioning/stakeholder 退化壳已删）
- **模块3 构思设计**：7 pipeline + 2 orchestrator = 9（prd / validation，ideation 退化壳已删，视觉交互已交 harness-design）
- **模块4 度量设计**：3 pipeline + 1 orchestrator = 4（metrics-system / tracking-plan / dashboard）
- **模块5 度量运营**：8 pipeline + 3 orchestrator = 11（analysis / decision / experiment）
- **模块6 增长运营**：11 pipeline + 5 orchestrator = 16（growth / acquisition / activation / retention / revenue）
- **模块7 监控迭代**：13 pipeline + 4 orchestrator = 17（monitoring / diagnosis / iteration / release）

> 详细 skill 清单见 `.harness/skills/pm/` 下各 skill 目录的 SKILL.md。
> skill 按功能命名扁平化组织（如 `user-research-orchestrator/`、`design-prd/`），不再按模块分目录。
> 视觉/交互/组件/原型等设计产出已迁移至 harness-design，PM 仅负责 PRD 和产品策略。
