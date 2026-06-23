# LOOP.md — 循环引擎定义 + 验证协议

> 作用：替代线性 workflow，实现增长循环验证闭环
> 增长循环：PLAN → EXPERIMENT → MEASURE

## 核心循环

```
┌──────────┐
│   PLAN   │ ← 定义增长假设 + 度量指标 + 实验设计 + 宪法检查
└────┬─────┘
     ▼
┌──────────────┐
│ EXPERIMENT   │ ← 执行实验（内容生产/SEO优化/A-B测试/用户运营）
└────┬─────────┘
     ▼
┌──────────┐
│  MEASURE │ ← 测量结果 + 统计显著性 + 决策 + 人类审批
└────┬─────┘
     │
     ├── 通过 → DONE → 记录 evidence + 结论写入知识库
     │
     └── 失败 → 分析原因
                   ├── 可修复 → 回到 EXPERIMENT
                   └── 需重新规划 → 回到 PLAN
```

## 循环类型

| 类型 | 触发场景 | 最大迭代 | 停止条件 |
|------|---------|---------|---------|
| **content** | 内容生产与优化 | 3 | 内容质量门通过 + 度量达标 |
| **seo** | SEO 优化 | 5 | 排名/流量提升达标 |
| **experiment** | A/B 测试、增长实验 | 3 | 统计显著性达成 |
| **optimization** | 转化漏斗、留存优化 | 3 | 核心指标提升达标 |
| **monetization** | 定价/付费转化优化 | 3 | NRR 达标（如 >120%） |
| **lifecycle** | 留存专项优化 | 5 | 留存曲线趋于水平且达标 |

## 成本控制

| 维度 | 限制 | 超限动作 |
|------|------|---------|
| 总循环次数 | 10 | **硬熔断**：写入 `hard_limit_reached: true` 到 state.yaml，status 改为 `failed`，**禁止继续循环**，必须请求人类介入 |

> **硬熔断执行规则（不可协商）**：
> 1. Agent 在每次 MEASURE 阶段**必须**读取 `state.yaml` 的 `iteration` 字段
> 1.5. **MEASURE 阶段必须强制读取 state.yaml 原始内容**：Agent 在每次 MEASURE 时，必须使用 Read 工具读取 `state.yaml` 的完整内容，获取真实的 iteration 值。**禁止从上下文记忆中引用 iteration 值**（防止幻觉状态下跳过熔断检查）。
> 2. 当 Read 工具读取的 `iteration >= 10` 时（必须来自文件原始内容，不是记忆引用），Agent **必须**执行以下操作，不得跳过：
>    - 将 `status` 改为 `failed`
>    - 将 `hard_limit_reached` 写为 `true`
>    - 将 `last_error` 写为"迭代超限（iteration >= 10），硬熔断触发"
>    - 向用户报告熔断原因，请求人类介入
> 3. 当 `hard_limit_reached: true` 时，Agent **禁止**继续执行当前任务的任何 LOOP 阶段
> 4. 只有用户显式指示"重置熔断"后，Agent 才可将 `hard_limit_reached` 改为 `false` 并重置 `iteration`
>
> Token 限制由用户在 IDE 中自行监控，不纳入框架规则（Agent 没有 token 计数器）。

## Specs 持久化

每次循环的 PLAN 阶段，将规格写入 `loops/specs/<experiment>/spec.md`。

## Evidence 追踪

每次 MEASURE 阶段的证据写入 `loops/specs/<experiment>/evidence.md`。

**文件写入语义区分（重要，避免混淆）**：

| 文件 | 写入语义 | 原因 | 操作方式 |
|------|---------|------|---------|
| `spec.md` | 覆盖 | 只保留最终通过的规格 | Write 直接覆盖 |
| `state.yaml` | 覆盖 | 只保留当前状态 | Write 直接覆盖 |
| `evidence.md` | 覆盖 | 只保留最终成功的证据 | Write 直接覆盖 |
| `iterations.log` | **追加** | 保留完整迭代历史 | Read+拼接+Write，或 `echo >>` |

```
loops/specs/001-blog-seo-experiment/
├── spec.md          ← 实验规格（覆盖：最终通过版本）
├── state.yaml       ← 循环状态（覆盖：当前状态）
├── evidence.md      ← 验证证据（覆盖：最终成功）
└── iterations.log   ← 迭代历史（append-only，完整轨迹）
```

iterations.log 示例：
```
[2026-06-20 14:30] iter=1 stage=experiment → measure FAILED: 样本量不足，无法得出显著结论
[2026-06-20 14:35] iter=2 stage=experiment → measure FAILED: 护栏指标触发，实验组留存下降
[2026-06-20 14:40] iter=3 stage=measure → PASSED: 转化率提升 12% (p<0.05)
```

为什么这样设计？
  - spec.md / state.yaml / evidence.md 覆盖写入 → 只保留最新状态，不污染上下文
  - iterations.log append-only → 保留完整迭代历史，复盘时能看到失败轨迹
  - 一个实验的所有产物在一个目录 → 内聚性好，不用跨目录找

## 状态维护

**决策：Agent 读写维护 state.yaml（每实验一个文件，落盘）**

`loops/specs/<experiment>/state.yaml` 由 experiment/measure skill 在循环中主动读写：
  - 记录当前迭代次数、上次失败原因、当前阶段
  - 会话中断后可断点续传（读取 state.yaml 恢复上下文）
  - measure skill 反正要写 evidence，多写一行 state 成本可忽略
  - 每实验一个文件，天然支持多实验并行

### state.yaml Schema（单一来源，各 SKILL.md 引用本节）

```yaml
# 必填字段
current_task: <NNN>-<experiment-name>      # 实验编号+名称，与目录名一致
iteration: <int>                            # 当前迭代次数，从 0 开始，每次 EXPERIMENT→MEASURE 循环 +1
stage: <enum>                               # 当前阶段，枚举见下表
status: <enum>                              # 实验状态，枚举见下表
started_at: "<ISO 8601>"                    # 实验开始时间，如 "2026-06-20T14:30:00"

# 可选字段（失败时填写）
last_error: "<错误描述>"                     # 最近一次失败原因，成功时清空为 ""
last_error_at: "<ISO 8601>"                 # 最近一次失败时间

# 可选字段（子阶段描述，用于多子阶段工作流）
substage: "<子阶段描述>"                     # 如 "ab-test" / "keyword-research" / "content-draft"，配合 stage 使用

# 可选字段（探索模式，growth 专属）
exploration_mode: "<enum>"                 # deep / standard / skip，默认 standard，控制 workflow 交互深度

# 可选字段（硬熔断标记）
hard_limit_reached: <bool>                 # true 时禁止继续循环，默认 false，仅 iteration >= 10 时置 true
```

**stage 枚举值**：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `plan` | 规划阶段 | PLAN 阶段初始化时 |
| `experiment` | 执行阶段 | 实验执行中 |
| `measure` | 度量阶段 | measure skill 执行检查时 |
| `revise` | 修订阶段 | 重新设计实验时 |

**status 枚举值**（与 harness 家族统一）：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `running` | 进行中 | PLAN 初始化 / 实验执行中 |
| `retrying` | 重试中 | measure 失败后 |
| `done` | 已完成 | measure 通过 + 增长审查通过 |
| `failed` | 失败（迭代超限，需人类介入） | 迭代超限 |
| `needs-human` | 需人类决策（非失败，但 Agent 无法继续） | 遇到宪法/伦理/权限边界 |
| `blocked` | 被阻塞（等待外部依赖） | 等待上游交接/数据/审批 |

**字段写入责任**：

| 字段 | PLAN | EXPERIMENT | MEASURE | revise |
|------|:---:|:---:|:---:|:---:|
| current_task | 写（初始化） | 不改 | 不改 | 不改 |
| iteration | 写（0） | 写（+1） | 不改 | 不改 |
| stage | 写（plan） | 写（experiment） | 写（measure） | 写（revise） |
| status | 写（running） | 写（running/retrying） | 写（done/retrying） | 写（retrying） |
| last_error | 写（""） | 写（失败时/成功清空） | 写（失败时/成功清空） | 写（原因描述） |
| started_at | 写（初始化） | 不改 | 不改 | 不改 |
| exploration_mode | 写（workflow default_mode） | 不改 | 不改 | 不改 |

**示例**：

```yaml
# loops/specs/001-blog-seo-experiment/state.yaml 示例
current_task: 001-blog-seo-experiment
iteration: 3
stage: measure
status: retrying
last_error: "样本量不足，p=0.12 未达显著阈值 0.05"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

## 验证协议

### MEASURE 阶段必做检查

1. **数据完整性**：实验数据是否完整（样本量、时长、分组）
2. **统计显著性**：核心指标是否达到显著阈值（通常 p<0.05）
3. **验收标准**：逐条检查 spec.md 里的假设是否被验证
4. **护栏指标**：检查是否有副作用（如留存下降、投诉上升）
5. **宪法合规**：检查是否违反 constitution.md 的原则（黑帽 SEO、刷量、PII 泄露等）

### 声称"完成"的前置条件

Agent 在声称实验完成前，**必须**：
- [ ] 展示实验数据（不是"应该有效"，而是实际数据）
- [ ] 逐条对照假设，标注 ✓/✗（验证/证伪/不确定）
- [ ] 检查统计显著性，展示 p 值或置信区间
- [ ] 检查护栏指标，确认无副作用
- [ ] 将证据写入 `loops/specs/<experiment>/evidence.md`
- [ ] 更新 `loops/specs/<experiment>/state.yaml` 的 status 为 done
- [ ] 将结论写入 `memory/knowledge-base.md`（有效/无效/不确定 + 行动建议）

**没有数据不声称完成**——这是 AGENTS.md 核心规则第 1 条。

### 失败处理

MEASURE 失败时：
1. 将失败信息写入 `state.yaml` 的 `last_error` 字段
2. 追加一行到 `iterations.log`
3. 分析失败原因：
   - 可修复（样本不足、时长不够）→ 回到 EXPERIMENT（延长实验/扩大样本）
   - 需重新规划（假设错误、设计缺陷）→ 回到 PLAN
4. 迭代次数 +1，检查是否超过最大迭代

### 断点续传

会话中断后恢复：
1. 读取 `loops/specs/<experiment>/state.yaml` 获取当前阶段和迭代次数
2. 读取 `iterations.log` 了解失败历史
3. 从中断点继续，不从头开始
