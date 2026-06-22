# LOOP.md — PM 循环引擎定义 + 验证协议

> 作用：替代线性 workflow，实现产品工作的循环验证闭环
> 与 harness-solo 的 LOOP 区别：solo 是 plan→act→verify（测试驱动），pm 是 plan→research→validate（数据驱动）

## 核心循环

```
┌──────────┐
│   PLAN   │ ← 定义研究目标 + 决策标准 + 宪法检查
└────┬─────┘
     ▼
┌──────────┐
│ RESEARCH │ ← 执行调研/分析/建模（调用 PM skill）
└────┬─────┘
     ▼
┌──────────┐
│ VALIDATE │ ← 验证结论 + 人类评审 + 置信度检查
└────┬─────┘
     │
     ├── 通过 → DELIVER → 记录 evidence + 产出交付物
     │
     └── 失败 → 分析原因
                   ├── 数据不足 → 回到 RESEARCH
                   └── 方向错误 → 回到 PLAN
```

## 循环类型

| 类型 | 触发场景 | 最大迭代 | 停止条件 |
|------|---------|---------|---------|
| **research** | 用户研究/市场分析 | 5 | 数据充分 + 置信度 ≥ 0.7 |
| **prd** | PRD 生成/方案设计 | 5 | 质量门禁通过 + 人类审批 |
| **iteration** | 已有产品迭代 | 3 | 验收标准满足 |
| **growth** | 增长实验 | 3 | 实验结果达标 |
| **pivot** | 战略调整/重新定位 | 5 | 战略一致性 + 人类审批 |

## 成本控制

| 维度 | 限制 | 超限动作 |
|------|------|---------|
| 总循环次数 | 10 | 停止，请求人类介入 |

> Token 限制由用户在 IDE 中自行监控，不纳入框架规则（Agent 没有 token 计数器）。

## Specs 持久化

每次循环的 PLAN 阶段，将规格写入 `loops/specs/<task>/spec.md`。

## Evidence 追踪

每次 VALIDATE 阶段的证据写入 `loops/specs/<task>/evidence.md`。

**文件写入语义区分（重要，避免混淆）**：

| 文件 | 写入语义 | 原因 | 操作方式 |
|------|---------|------|---------|
| `spec.md` | 覆盖 | 只保留最终通过的规格 | Write 直接覆盖 |
| `state.yaml` | 覆盖 | 只保留当前状态 | Write 直接覆盖 |
| `evidence.md` | 覆盖 | 只保留最终成功的证据 | Write 直接覆盖 |
| `iterations.log` | **追加** | 保留完整迭代历史 | Read+拼接+Write，或 `echo >>` |

```
loops/specs/001-market-research/
├── spec.md          ← 任务规格（覆盖：最终通过版本）
├── state.yaml       ← 循环状态（覆盖：当前状态）
├── evidence.md      ← 验证证据（覆盖：最终成功）
└── iterations.log   ← 迭代历史（append-only，完整轨迹）
```

iterations.log 示例：
```
[2026-06-20 14:30] iter=1 stage=research → validate FAILED: 用户反馈数据不足（<500条）
[2026-06-20 14:35] iter=2 stage=research → validate FAILED: Persona 置信度 < 0.7
[2026-06-20 14:40] iter=3 stage=validate → PASSED: 置信度 0.8，人类审批通过
```

## 状态维护

**决策：Agent 读写维护 state.yaml（每任务一个文件，落盘）**

`loops/specs/<task>/state.yaml` 由 PM skill 在循环中主动读写：
  - 记录当前迭代次数、上次失败原因、当前阶段
  - 会话中断后可断点续传（读取 state.yaml 恢复上下文）
  - 每任务一个文件，天然支持多产品线并行

### state.yaml Schema（单一来源，各 SKILL.md 引用本节）

```yaml
# 必填字段
current_task: <NNN>-<task-name>          # 任务编号+名称，与目录名一致
iteration: <int>                          # 当前迭代次数，从 0 开始，每次 RESEARCH→VALIDATE 循环 +1
stage: <enum>                             # 当前阶段，枚举见下表
status: <enum>                            # 任务状态，枚举见下表
started_at: "<ISO 8601>"                  # 任务开始时间，如 "2026-06-20T14:30:00"

# 可选字段（失败时填写）
last_error: "<错误描述>"                   # 最近一次失败原因，成功时清空为 ""
last_error_at: "<ISO 8601>"               # 最近一次失败时间

# 可选字段（子阶段描述，用于多子阶段工作流）
substage: "<子阶段描述>"                   # 如 "voice-analysis" / "persona-modeling" / "prd-generation"
```

**stage 枚举值**：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `plan` | 规划阶段 | 任务初始化时 |
| `research` | 调研阶段 | PM skill 执行调研/分析时 |
| `validate` | 验证阶段 | 质量门禁/人类评审时 |
| `revise` | 修订阶段 | 根据反馈修订产出时 |

**status 枚举值**：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `running` | 进行中 | 任务初始化 / 调研成功继续 |
| `retrying` | 重试中 | 验证失败后 |
| `done` | 已完成 | 验证通过 + 人类审批通过 |
| `failed` | 失败（需人类介入） | 迭代超限 |

**字段写入责任**：

| 字段 | 任务初始化 | PM skill（research） | verify（validate） |
|------|:---:|:---:|:---:|
| current_task | 写 | 不改 | 不改 |
| iteration | 写（0） | 写（+1） | 不改 |
| stage | 写（plan） | 写（research） | 写（validate） |
| status | 写（running） | 写（running/retrying） | 写（done/retrying） |
| last_error | 写（""） | 写（失败时/成功清空） | 写（失败时/成功清空） |
| started_at | 写（初始化） | 不改 | 不改 |

**示例**：


**status 枚举（全局统一规范）**：
- `running`: 任务正在执行中。
- `retrying`: 任务失败，正在进行重试或自动回滚。
- `done`: 任务已成功验证并完成。
- `failed`: 任务失败且重试耗尽。
- `needs-human`: 需要人类干预（如：必须审批、自动修复失败）。
- `blocked`: 任务被阻塞（如：等待上游产出物、等待环境权限）。

```yaml
# loops/specs/001-market-research/state.yaml 示例
current_task: 001-market-research
iteration: 3
stage: validate
status: retrying
last_error: "Persona 置信度 0.6 < 0.7，需补充数据"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

## 验证协议

### VALIDATE 阶段必做检查

1. **数据充分性**：检查产出 JSON 的必填字段是否完整（按各 skill 的输出校验规则）
2. **置信度检查**：推断性字段置信度 ≥ 0.7 可自动传递，< 0.3 阻断
3. **质量门禁**：PRD 等契约产出必须通过 4 道门禁（完整性/一致性/歧义消除/可追溯性）
4. **宪法合规**：检查是否违反 constitution.md 的原则
5. **人类审批**：关键决策点（方案选择/优先级/策略方向）必须人类确认

### 声称"完成"的前置条件

Agent 在声称任务完成前，**必须**：
- [ ] 展示实际产出（JSON/Markdown，不是"应该生成了"）
- [ ] 逐条对照验收标准，每条标注 ✓/✗
- [ ] 检查置信度，低置信度项标注并请求人类确认
- [ ] 执行质量门禁检查（如涉及 PRD 等契约产出）
- [ ] 将证据写入 `loops/specs/<task>/evidence.md`
- [ ] 更新 `loops/specs/<task>/state.yaml` 的 status 为 done

**没有证据不声称完成**——这是 AGENTS.md 核心规则第 3 条。

### 失败处理

VALIDATE 失败时：
1. 将失败信息写入 `state.yaml` 的 `last_error` 字段
2. 追加一行到 `iterations.log`
3. 分析失败原因：
   - 数据不足（反馈少/样本小）→ 回到 RESEARCH 补充数据
   - 方向错误（假设不成立/需求变更）→ 回到 PLAN 重新规划
   - 质量不达标（门禁未过/置信度低）→ 回到 RESEARCH 优化产出
4. 迭代次数 +1，检查是否超过最大迭代

### 断点续传

会话中断后恢复：
1. 读取 `loops/specs/<task>/state.yaml` 获取当前阶段和迭代次数
2. 读取 `iterations.log` 了解失败历史
3. 从中断点继续，不从头开始
