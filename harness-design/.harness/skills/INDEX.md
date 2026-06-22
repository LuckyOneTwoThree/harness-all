# Skills 索引

> 纯索引，40 行内。需要选 Skill 时读。工作流编排见 `workflows/`。
> 添加新 Skill：在分类目录下创建 SKILL.md，然后本文件追加一行。
> 定位：harness-design 是**UI 设计框架**，只含设计相关 skill。
> 产品/工程/增长见 harness 家族其他成员（通过 docs/handoff/ 交接）。

## 元
- **session-start** — 会话启动，加载上下文恢复工作状态
- **session-end** — 会话收尾，归档进度 + 写 baseline + 更新看板 + 产出交接
- **skill-maintenance** — skill 健康检查
- **memory-maintenance** — memory retention 清理

## 设计
- **design-brief** — 需求探索硬门（+Vibe Translation +Anti AI-Slop）
- **design-recommendation** — 数据驱动设计推荐（产品类型→风格/配色/字体）
- **design-system** — 设计系统创建（DESIGN.md 10 段 + token 导出）
- **design-system-import** — 从现有代码导入设计系统
- **visual-design** — 视觉设计（反 AI-slop + 多方案变体）
- **interaction-design** — 交互设计（状态机 + 动效参数）
- **wireframe** — 低保真线框图（结构验证）
- **component-design** — 原子组件设计（Props/States/Variants/Composition Rules）
- **design-lint** — AI 设计 Linter（机械规则检查，脚本执行）
- **design-review** — 最终审查（Five-Axis + Doubt-Driven）
- **design-handoff-spec** — 工程交付（+component-map.json 显式映射）
- **accessibility-audit** — WCAG 2.1 AA 专项审查
- **verify** — LOOP 内快速检查
- **design-system-refactor** — 设计系统重构（合并/抽象/token 化）

## 工作流
- **setup** — 项目初始化（design-brief → design-recommendation → design-system）
- **new-design** — 新设计任务（3 个独立 LOOP + design-review）
- **design-iteration** — 设计迭代（Chesterton's Fence + LOOP）
- **redesign** — 重设计（design-system-import + 差异分析 + LOOP）
- **design-system-setup** — 设计系统建设（recommendation → system → LOOP）
- **design-handoff** — 设计交付（handoff-spec + accessibility + lint + verify）
