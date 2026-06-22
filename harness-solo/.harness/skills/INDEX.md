# Skills 索引

> 纯索引，40 行内。需要选 Skill 时读。工作流编排见 `workflows/`。
> 添加新 Skill：在分类目录下创建 SKILL.md，然后本文件追加一行。
> 定位：harness-solo 是**工程开发框架**，只含写代码相关 skill。
> 产品/设计/增长见 harness 家族其他成员（通过 docs/handoff/ 交接）。

## 元
- **session-start** — 会话启动，加载上下文恢复工作状态
- **session-end** — 会话收尾，归档进度 + 写 baseline + 更新看板
- **skill-maintenance** — skill 健康检查
- **memory-maintenance** — memory retention 清理

## 工程
- **brainstorming** — 需求探索，硬门（过不去不许写代码）
- **writing-plans** — 任务拆解，输出 spec.md
- **executing-plans** — 计划执行，按任务序列推进带 checkpoint
- **test-driven-development** — TDD，红→绿→重构
- **test-coverage** — 给现有代码补测试，覆盖率缺口分析
- **systematic-debugging** — 系统化调试，根因分析
- **performance-optimization** — 性能优化，measure→fix→verify 闭环
- **migration** — 代码迁移，框架升级/API迁移，守护不回归
- **dependency-management** — 依赖管理，添加/升级/审计，对接宪法审批门
- **frontend-implementation** — 前端工程实现，组件/状态/样式（非视觉设计）
- **verify** — 交付验证，声称完成前的强制综合检查
- **webapp-testing** — 前端验证，纯 Agent 工具方式（构建/类型/lint/可访问性）
- **requesting-code-review** — 代码审查，质量把关
- **receiving-code-review** — 审查反馈处理，分类响应 + 修复 + 回复
- **writing-skills** — 按标准创建新 skill，支持框架扩展
- **writing-documentation** — 文档编写，ADR/API doc/CHANGELOG，document the why

## 工作流
- **setup** — 立项引导（install.sh 后引导填写 SOUL/constitution/PROJECT/TECH_STACK）
- **new-feature** — 新功能开发（brainstorming → LOOP → code-review）
- **bugfix** — Bug 修复（systematic-debugging → LOOP → code-review）
- **refactor** — 重构（brainstorming 确认边界 → LOOP 守护不回归 → code-review）
- **optimize** — 性能优化（performance-optimization measure→fix→verify → code-review）
- **migration** — 代码迁移（migration 决策 → LOOP 增量迁移 → 验证零用量 → 移除旧系统）
- **release** — 发版（verify 全量 → CHANGELOG → tag → 发布物验证）
