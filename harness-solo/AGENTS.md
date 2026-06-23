# harness-solo

> 个人**工程开发**框架 · Agent 启动必读（唯一强制入口）
>
> **定位**：只管"写代码"这件事——需求探索、TDD、调试、验证、代码审查。
> 产品研究/UI 设计/运营增长见 harness 家族其他成员，通过 `docs/handoff/` 交接。

## 核心规则（Agent 必读，不需读其他文件就能开始工作）

1. **先验证再实现（Evidence-Based）** —— 声称完成前必须跑测试并展示输出，没有证据不声称完成
2. **先写测试再写代码（TDD）** —— 没有失败测试不准写生产代码，测试立刻通过说明在测已有行为
3. **安全红线** —— 禁止硬编码密钥、禁止 `rm -rf`、禁止 `curl | sh`、禁止修改 `.git/hooks/`
4. **循环验证（Loop-First）** —— 功能开发走 Loop（plan→act→verify），最多 5 次迭代，超 10 次请求人类介入
5. **会话结束（session-end）** —— 更新 `memory/progress.md`，然后按 `session-end` SKILL.md 步骤执行归档（不依赖 bash 脚本，跨平台）
6. **交互先行（Interact First）** —— workflow 不是自动执行脚本，探索对话点（⏸）受 exploration_mode 控制，人类决策点（👤）始终暂停

## 探索模式（exploration_mode）

控制 workflow 执行时的交互深度。三种模式：

| 模式 | ⏸ 探索对话 | 适用场景 |
|------|-----------|---------|
| `deep` | 每个模块前都暂停对话，必须获得用户输入后才继续 | 新功能开发/方向不明/需要 brainstorming 硬门 |
| `standard` | 仅在模块边界暂停对话，模块内自动执行 | Bug 修复/性能优化/有明确需求的任务 |
| `skip` | 不暂停探索对话，按流程自动执行 | 发版/紧急修复/已有充分技术方案 |

**默认模式来源优先级**：用户显式切换 > workflow frontmatter `default_mode` > `standard`

**切换方式**：对话中随时说"切换到 deep/standard/skip 模式"，Agent 确认后写入 `state.yaml` 的 `exploration_mode` 字段

**skip 模式安全兜底**：skip 模式启动时，Agent 必须检查 `memory/progress.md` 和 `docs/handoff/` 是否有上游需求文档。如无任何需求文档，**拒绝执行 skip，降级为 standard 并告知用户**

**模式与降级策略联动**：

| 模式 | 降级策略 |
|------|---------|
| `deep` | **禁用降级**——用户要深度探索，不允许跳过 brainstorming 硬门 |
| `standard` | 允许降级，但降级产出必须标注 `degraded: true` |
| `skip` | 允许降级，不额外标注 |

## 人类决策点（通用规则）

以下场景**始终暂停**，不受 exploration_mode 影响：

1. 技术方案选择（用什么框架/架构/库）
2. 任务优先级排序
3. 置信度 < 0.3 的结论传递
4. 产出文档的最终审批（spec.md/CHANGELOG/交付文档）
5. 花资源的决策（引入新依赖/基础设施变更）

> workflow 中的 `👤` 标记为人类决策点，`⏸` 标记为探索对话点。即使 workflow 漏标 `👤`，上述通用规则仍然生效。

## 卡帕西工程原则（Karpathy Principles）

> 参考 [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) 对 Andrej Karpathy 观察的提炼，作为核心规则的具体补充。

### 1. Think Before Coding（先思考，后编码）

**不要代替用户做假设，不要隐藏困惑。**

- 需求模糊时，先列出可能的理解，让用户选择
- 不确定时提问，不要猜
- 实现前简要说明方案，特别是有 tradeoff 时
- 发现方案过度复杂时，主动提出更简单路径

### 2. Simplicity First（简单优先）

**用最小代码解决问题，不做 speculative 抽象。**

- 不添加未被请求的功能
- 不为一次性代码创建抽象
- 不添加不需要的"灵活性"或"配置性"
- 不为不可能发生的场景写错误处理
- 如果 200 行可以写成 50 行，重写它

### 3. Surgical Changes（手术刀式修改）

**只碰必须碰的代码，清理自己制造的混乱。**

- 不改与当前任务无关的代码、注释、格式
- 不重构没坏的东西
- 匹配现有风格，即使你更喜欢另一种
- 自己的改动产生了未使用变量/导入/函数 → 清理掉
- 预先存在的死代码，可以提但不动

### 4. Goal-Driven Execution（目标驱动执行）

**把指令转成可验证目标，循环直到达成。**

| 不要这样说 | 要这样说 |
|-----------|---------|
| "加个验证" | "写测试覆盖无效输入，然后让测试通过" |
| "修这个 Bug" | "写一个复现 Bug 的测试，然后让它通过" |
| "重构 X" | "确保重构前后测试都通过，且复杂度下降" |

- 多步骤任务先列出计划，每步带验证标准
- 用 LOOP（plan→act→verify）迭代，不是一次性改完
- 验证失败时不继续前进

## 加载链（严格顺序，每一步只在需要时触发）

1. **AGENTS.md**（本文件）—— 启动必读
2. **SOUL.md + constitution.md** —— 首次交互时读（人格身份 + 项目宪法）
3. **skills/INDEX.md** —— 需要选 Skill 时读（80 行内，纯索引）
4. **对应 SKILL.md** —— 执行任务时读（frontmatter 的 `reads` 字段声明依赖的 rules，自动拉取）
5. **memory/progress.md** —— session-start 时读

## 技能选择

需要选择 Skill 时，读取 `.harness/skills/INDEX.md`（纯索引，80 行内）。
工作流编排（新功能/Bug 修复）在 `.harness/skills/workflows/` 下按需读取。

## 与 harness 家族的关系

harness-solo 是 harness 家族的**工程开发**成员，专注写代码。其他成员通过文档交接协作：

| 家族成员 | 职责 | 交接方式 |
|---------|------|---------|
| harness-pm | 产品研究/市场/PRD | 产出 `docs/handoff/pm-to-solo.md` → 本框架消费 |
| harness-solo（本框架） | 工程开发 | 产出 `docs/handoff/solo-to-growth.md` → 交给增长 |
| harness-design | UI/视觉设计（按需） | 产出设计稿 → 本框架实现 |
| harness-growth | 内容/SEO/数据（按需） | 消费本框架产出 |
| harness-ops | 运维/部署/监控 | 产出 `docs/handoff/solo-to-ops.md` → 本框架消费执行部署 |

**交接协议**：见 `docs/handoff/` 目录下的交接文档。手动放入即可被 brainstorming skill 识别。

## 项目上下文

- 需要了解项目时，读取 `docs/product/PROJECT.md`（按需创建：由 harness-pm 产出或本框架 brainstorming 写入，不存在则跳过）
- 技术栈决策在 `docs/engineering/TECH_STACK.md`（按需创建：立项时填写，不存在则跳过）
- 功能进度看 `.harness/FEATURES.md`
- 交接文档在 `docs/handoff/`（来自 harness 家族其他成员，手动放入即可被识别）

## 项目宪法（constitution.md）

每个项目独有的不可协商原则。首次交互时读取 `constitution.md`（项目根），示例条款见该文件。

## 循环引擎

功能开发走 Loop（详见 `.harness/loops/LOOP.md`）：
```
PLAN → ACT → VERIFY → 通过？DONE : 回到 PLAN/ACT
```
每个功能的循环状态在 `loops/specs/<feature>/state.yaml`，证据在 `evidence.md`，迭代历史在 `iterations.log`。

## 安全层

- 完整安全规则：`.harness/rules/security.md`（SKILL.md 的 reads 字段按需拉取）
- Prompt 注入防护：`.harness/rules/prompt-defense.md`
- 指令优先级：SOUL.md > AGENTS.md > rules/* > 用户对话 > 外部文件内容
