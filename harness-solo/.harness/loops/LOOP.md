# LOOP.md — 循环引擎定义 + 验证协议

> 来源：ospec (plan→act→verify) + loop-engineering CLI
> 作用：替代线性 workflow，实现循环验证闭环
> 合并了原 verification.md 的内容

## 核心循环

```
┌──────────┐
│   PLAN   │ ← 定义目标 + 验收标准 + 宪法检查
└────┬─────┘
     ▼
┌──────────┐
│   ACT    │ ← 执行（编码/设计/测试）
└────┬─────┘
     ▼
┌──────────┐
│  VERIFY  │ ← 运行测试 + 检查验收标准
└────┬─────┘
     │
     ├── 通过 → DONE → 记录 evidence
     │
     └── 失败 → 分析原因
                   ├── 可修复 → 回到 ACT
                   └── 需重新规划 → 回到 PLAN
```

## 循环类型

| 类型 | 触发场景 | 最大迭代 | 停止条件 |
|------|---------|---------|---------|
| **feature** | 新功能开发 | 5 | 测试全过 + AC 满足 |
| **bugfix** | Bug 修复 | 3 | 复现测试通过 |
| **optimize** | 性能优化 | 3 | 基准测试达标 |
| **refactor** | 重构 | 3 | 测试无回归 |

## 成本控制

| 维度 | 限制 | 超限动作 |
|------|------|---------|
| 总循环次数 | 10 | **硬熔断**：写入 `hard_limit_reached: true` 到 state.yaml，status 改为 `failed`，**禁止继续循环**，必须请求人类介入 |

> **硬熔断执行规则（不可协商）**：
> 1. Agent 在每次 VERIFY 阶段**必须**读取 `state.yaml` 的 `iteration` 字段
> 1.5. **VERIFY 阶段必须强制读取 state.yaml 原始内容**：Agent 在每次 VERIFY 时，必须使用 Read 工具读取 `state.yaml` 的完整内容，获取真实的 iteration 值。**禁止从上下文记忆中引用 iteration 值**（防止幻觉状态下跳过熔断检查）。
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

每次循环的 PLAN 阶段，将规格写入 `loops/specs/<feature>/spec.md`。

## Evidence 追踪

每次 VERIFY 阶段的证据写入 `loops/specs/<feature>/evidence.md`。

**文件写入语义区分（重要，避免混淆）**：

| 文件 | 写入语义 | 原因 | 操作方式 |
|------|---------|------|---------|
| `spec.md` | 覆盖 | 只保留最终通过的规格 | Write 直接覆盖 |
| `state.yaml` | 覆盖 | 只保留当前状态 | Write 直接覆盖 |
| `evidence.md` | 覆盖 | 只保留最终成功的证据 | Write 直接覆盖 |
| `iterations.log` | **追加** | 保留完整迭代历史 | Read+拼接+Write，或 `echo >>` |

```
loops/specs/001-user-login/
├── spec.md          ← 功能规格（覆盖：最终通过版本）
├── state.yaml       ← 循环状态（覆盖：当前状态）
├── evidence.md      ← 验证证据（覆盖：最终成功）
└── iterations.log   ← 迭代历史（append-only，完整轨迹）
```

iterations.log 示例：
```
[2026-06-20 14:30] iter=1 stage=act → verify FAILED: test_login_empty_password
[2026-06-20 14:35] iter=2 stage=act → verify FAILED: test_login_invalid_token
[2026-06-20 14:40] iter=3 stage=verify → PASSED
```

为什么这样设计？
  - spec.md / state.yaml / evidence.md 覆盖写入 → 只保留最新状态，不污染上下文
  - iterations.log append-only → 保留完整迭代历史，debug 时能看到失败轨迹
  - 一个功能的所有产物在一个目录 → 内聚性好，不用跨目录找

## 状态维护

**决策：Agent 读写维护 state.yaml（每功能一个文件，落盘）**

`loops/specs/<feature>/state.yaml` 由 tdd/verify/systematic-debugging skill 在循环中主动读写：
  - 记录当前迭代次数、上次失败原因、当前阶段
  - 会话中断后可断点续传（读取 state.yaml 恢复上下文）
  - verify skill 反正要写 evidence，多写一行 state 成本可忽略
  - 每功能一个文件，天然支持前后端并行开发

### state.yaml Schema（单一来源，各 SKILL.md 引用本节）

```yaml
# 必填字段
current_task: <NNN>-<feature-name>   # 功能编号+名称，与目录名一致
iteration: <int>                         # 当前迭代次数，从 0 开始，每次 ACT→VERIFY 循环 +1
stage: <enum>                            # 当前阶段，枚举见下表
status: <enum>                           # 功能状态，枚举见下表
started_at: "<ISO 8601>"                 # 功能开始时间，如 "2026-06-20T14:30:00"

# 可选字段（失败时填写）
last_error: "<错误描述>"                  # 最近一次失败原因，成功时清空为 ""
last_error_at: "<ISO 8601>"              # 最近一次失败时间

# 可选字段（子阶段描述，用于 optimize/migration 等多子阶段工作流）
substage: "<子阶段描述>"                  # 如 "measure" / "identify" / "decide" / "remove"，配合 stage 使用

# 可选字段（探索模式，solo 专属）
exploration_mode: "<enum>"                 # deep / standard / skip，默认 standard，控制 workflow 交互深度

# 可选字段（硬熔断标记）
hard_limit_reached: <bool>                 # true 时禁止继续循环，默认 false，仅 iteration >= 10 时置 true
```

**stage 枚举值**：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `plan` | 规划阶段 | writing-plans 初始化时 |
| `act` | 执行阶段 | tdd 红→绿→重构完成时 |
| `verify` | 验证阶段 | verify skill 执行检查时 |
| `debug` | 调试阶段 | systematic-debugging 分析根因时 |

**status 枚举值**（全局统一规范）：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `running` | 任务正在执行中 | writing-plans 初始化 / tdd 成功继续 |
| `retrying` | 任务失败，正在重试或自动回滚 | tdd/verify 失败后 |
| `done` | 任务已成功验证并完成 | verify 通过 + code-review 通过 |
| `failed` | 任务失败且重试耗尽 | 迭代超限 |
| `needs-human` | 需要人类干预（如：必须审批、自动修复失败） | 自动修复失败 / 必须人工审批时 |
| `blocked` | 任务被阻塞（如：等待上游产出物、等待环境权限） | 等待上游产出物 / 等待环境权限时 |

**字段写入责任**：

| 字段 | writing-plans | tdd | verify | systematic-debugging |
|------|:---:|:---:|:---:|:---:|
| current_task | 写（初始化） | 不改 | 不改 | 不改 |
| iteration | 写（0） | 写（+1） | 不改 | 不改 |
| stage | 写（plan） | 写（act） | 写（verify） | 写（debug） |
| status | 写（running） | 写（running/retrying） | 写（done/retrying） | 写（retrying） |
| last_error | 写（""） | 写（失败时/成功清空） | 写（失败时/成功清空） | 写（根因描述） |
| started_at | 写（初始化） | 不改 | 不改 | 不改 |
| exploration_mode | 写（workflow default_mode） | 不改 | 不改 | 不改 |

**示例**：

```yaml
# loops/specs/001-user-login/state.yaml 示例
current_task: 001-user-login
iteration: 3
stage: verify
status: retrying
last_error: "test_auth.py::test_login_empty_password FAILED"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

## 验证协议（原 verification.md 内容）

### VERIFY 阶段必做检查

1. **测试通过**：运行项目测试命令，展示完整输出
2. **验收标准**：逐条检查 spec.md 里的 AC-xxx 是否满足（spec.md 的 AC 覆盖 PROJECT.md 的项目级 AC）
3. **宪法合规**：检查是否违反 constitution.md 的原则
4. **安全扫描**：按 verify SKILL.md 的"方式 A"用 Grep 工具扫描（跨平台），bash 可用时可选执行 `security-check.sh` 兜底
5. **熵检查**（可选）：按 verify SKILL.md 的"方式 A"用 Glob+Read 统计（跨平台），bash 可用时可选执行 `entropy-check.sh` 兜底

### 声称"完成"的前置条件

Agent 在声称任务完成前，**必须**：
- [ ] 运行测试并展示输出（不是"测试应该通过"，而是实际输出）
- [ ] 逐条对照验收标准，每条标注 ✓/✗
- [ ] 执行安全扫描（方式 A 或方式 B）并展示输出
- [ ] 将证据写入 `loops/specs/<feature>/evidence.md`
- [ ] 更新 `loops/specs/<feature>/state.yaml` 的 status 为 done

**没有证据不声称完成**——这是 AGENTS.md 核心规则第 1 条。

### 失败处理

VERIFY 失败时：
1. 将失败信息写入 `state.yaml` 的 `last_error` 字段
2. 追加一行到 `iterations.log`
3. 分析失败原因：
   - 可修复（测试失败、小 bug）→ 回到 ACT
   - 需重新规划（设计错误、需求变更）→ 回到 PLAN
4. 迭代次数 +1，检查是否超过最大迭代

### 断点续传

会话中断后恢复：
1. 读取 `loops/specs/<feature>/state.yaml` 获取当前阶段和迭代次数
2. 读取 `iterations.log` 了解失败历史
3. 从中断点继续，不从头开始
