# LOOP.md — 循环引擎定义 + 验证协议

> 来源：ospec (plan→act→verify) 改造为设计循环 (plan→design→verify+lint)
> 作用：替代线性 workflow，实现循环验证闭环
> 合并了原 verification.md 的内容

## 核心循环

```
┌─────────────────────────────────────────────────────┐
│  PLAN（内联，无独立 skill）                          │
│  - 读取 DESIGN_BRIEF.md 的 AC-xxx 列表              │
│  - 宪法检查                                          │
│  - 初始化 state.yaml + spec.md                      │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  LOOP（循环体内）                                    │
│  ┌─────────────┐                                    │
│  │   DESIGN    │ ← 执行设计（调用设计 skill）       │
│  └──────┬──────┘                                    │
│         ▼                                           │
│  ┌─────────────┐                                    │
│  │   VERIFY    │ ← verify skill：AC + 宪法 + 基础 a11y │
│  └──────┬──────┘                                    │
│         ▼                                           │
│  ┌─────────────┐                                    │
│  │    LINT     │ ← design-lint skill：机械规则（脚本执行） │
│  └──────┬──────┘                                    │
│         │                                           │
│         ├── 全部通过 → 退出 LOOP                     │
│         ├── 可修复 → 回到 DESIGN（iteration +1）     │
│         └── 超过 max iteration → 请求人类介入        │
└─────────────────────────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  LOOP 外门禁（最终审查，非循环）                     │
│  ┌─────────────────┐                                │
│  │ DESIGN-REVIEW   │ ← Five-Axis + Doubt-Driven     │
│  └────────┬────────┘                                │
│           ├── 通过 → 进入交付                        │
│           └── 不通过 → 回到 LOOP（可修复）或 PLAN（需重新规划） │
│                      ▼                              │
│  ┌─────────────────┐                                │
│  │ ACCESSIBILITY   │ ← WCAG 2.1 AA 专项审查         │
│  └────────┬────────┘                                │
│           ├── 通过 → 进入交付                        │
│           └── 不通过 → 回到 LOOP                     │
└─────────────────────────────────────────────────────┘
```

**关键边界**：
- LOOP 内 = verify + design-lint（快速检查，每次迭代都跑）
- LOOP 外 = design-review + accessibility-audit（深度审查，LOOP 退出后跑一次）
- design-review 不在 LOOP 内，避免每次迭代都启动子 agent 做 Doubt-Driven 对抗审查

## 循环类型

| 类型 | 触发场景 | 最大迭代 | 停止条件 |
|------|---------|---------|---------|
| **visual-design** | 视觉设计任务 | 5 | verify + lint 通过 + AC 满足 |
| **interaction-design** | 交互设计任务 | 5 | verify + lint 通过 + AC 满足 |
| **wireframe** | 线框图/低保真原型 | 5 | verify + lint 通过 + AC 满足 |
| **component** | 组件设计（Button/Input/Card 等） | 5 | verify + lint 通过 + AC 满足 |

**移除说明**：
- `prototype` 改为 `wireframe`，语义更准确（产出的是低保真线框图，不是可交互原型）
- `redesign` 移除（redesign 是 workflow 场景，内部仍用 visual-design 循环）

## 成本控制

| 维度 | 限制 | 超限动作 |
|------|------|---------|
| 单个 LOOP 内迭代次数 | 10 | 停止，请求人类介入 |

**语义说明**：
- "单个 LOOP" 指同一个循环类型（visual-design / interaction-design / wireframe / component）内的迭代次数
- 不同循环类型是不同任务，计数独立（如 new-design 的 wireframe/visual/interaction 3 个 LOOP 各自计数）
- workflow 内的 max 5 是建议上限，10 是硬性熔断阈值（5 < 10，留 5 次容错空间）

> Token 限制由用户在 IDE 中自行监控，不纳入框架规则（Agent 没有 token 计数器）。

## Specs 持久化

每次循环的 PLAN 阶段，将规格写入 `loops/specs/<task>/spec.md`。

## Evidence 追踪

每次 VERIFY/LINT 阶段的证据写入 `loops/specs/<task>/evidence.md`。

**文件写入语义区分（重要，避免混淆）**：

| 文件 | 写入语义 | 原因 | 操作方式 |
|------|---------|------|---------|
| `spec.md` | 覆盖 | 只保留最终通过的规格 | Write 直接覆盖 |
| `state.yaml` | 覆盖 | 只保留当前状态 | Write 直接覆盖 |
| `evidence.md` | 覆盖 | 只保留最终成功的证据 | Write 直接覆盖 |
| `iterations.log` | **追加** | 保留完整迭代历史 | Read+拼接+Write，或 `echo >>` |
| `lint-report.md` | 覆盖 | 只保留最新 lint 报告 | Write 直接覆盖 |

```
loops/specs/001-login-page/
├── spec.md          ← 设计规格（覆盖：最终通过版本）
├── state.yaml       ← 循环状态（覆盖：当前状态）
├── evidence.md      ← 验证证据（覆盖：最终成功）
├── lint-report.md   ← Lint 报告（覆盖：最新一次）
└── iterations.log   ← 迭代历史（append-only，完整轨迹）
```

iterations.log 示例：
```
[2026-06-20 14:30] iter=1 stage=design → verify FAILED: AC-002 未满足（缺少 hover 状态）
[2026-06-20 14:35] iter=2 stage=design → lint FAILED: L001 硬编码 #3B82F6
[2026-06-20 14:40] iter=3 stage=verify+lint → PASSED
```

为什么这样设计？
  - spec.md / state.yaml / evidence.md 覆盖写入 → 只保留最新状态，不污染上下文
  - iterations.log append-only → 保留完整迭代历史，debug 时能看到失败轨迹
  - lint-report.md 覆盖 → 只关心最新一次 lint 结果
  - 一个任务的所有产物在一个目录 → 内聚性好，不用跨目录找

## 状态维护

**决策：Agent 读写维护 state.yaml（每任务一个文件，落盘）**

`loops/specs/<task>/state.yaml` 由 design/verify/lint skill 在循环中主动读写：
  - 记录当前迭代次数、上次失败原因、当前阶段
  - 会话中断后可断点续传（读取 state.yaml 恢复上下文）
  - verify/lint skill 反正要写 evidence，多写一行 state 成本可忽略
  - 每任务一个文件，天然支持多设计任务并行

### state.yaml Schema（单一来源，各 SKILL.md 引用本节）

```yaml
# 必填字段
current_task: <NNN>-<task-name>           # 任务编号+名称，与目录名一致
iteration: <int>                           # 当前迭代次数，从 0 开始，每次 DESIGN→VERIFY+LINT 循环 +1
stage: <enum>                              # 当前阶段，枚举见下表
status: <enum>                             # 任务状态，枚举见下表
started_at: "<ISO 8601>"                   # 任务开始时间，如 "2026-06-20T14:30:00"

# 可选字段（失败时填写）
last_error: "<错误描述>"                    # 最近一次失败原因，成功时清空为 ""
last_error_at: "<ISO 8601>"                # 最近一次失败时间

# 可选字段（子阶段描述，用于多子阶段工作流）
substage: "<子阶段描述>"                    # 如 "visual" / "interaction" / "wireframe" / "component"
```

**stage 枚举值**：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `plan` | 规划阶段 | PLAN 内联初始化时 |
| `design` | 设计阶段 | visual-design/interaction-design/wireframe/component-design 完成时 |
| `verify` | 验证阶段 | verify skill 执行检查时 |
| `lint` | Lint 阶段 | design-lint skill 执行检查时 |
| `review` | 最终审查阶段（LOOP 外） | design-review 执行时 |

**status 枚举值（全局统一规范）**：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `running` | 任务正在执行中 | PLAN 初始化 / design 成功继续 |
| `retrying` | 任务失败，正在进行重试或自动回滚 | design/verify/lint 失败后 |
| `done` | 任务已成功验证并完成 | LOOP 退出 + design-review + accessibility-audit 通过 |
| `failed` | 任务失败且重试耗尽 | 迭代超限（达到 max iteration 熔断阈值） |
| `needs-human` | 需要人类干预（如：必须审批、自动修复失败） | 自动修复失败 / 遇到必须人类审批的操作 |
| `blocked` | 任务被阻塞（如：等待上游产出物、等待环境权限） | 等待上游产出物 / 等待环境权限 / 依赖未就绪 |

**字段写入责任**：

| 字段 | PLAN（内联） | design skill | verify/lint | design-review |
|------|:---:|:---:|:---:|:---:|
| current_task | 写（初始化） | 不改 | 不改 | 不改 |
| iteration | 写（0） | 写（+1） | 不改 | 不改 |
| stage | 写（plan） | 写（design） | 写（verify/lint） | 写（review） |
| status | 写（running） | 写（running/retrying） | 写（retrying/done） | 写（done/retrying） |
| last_error | 写（""） | 写（失败时/成功清空） | 写（失败时/成功清空） | 写（失败时/成功清空） |
| started_at | 写（初始化） | 不改 | 不改 | 不改 |

**示例**：

```yaml
# loops/specs/001-login-page/state.yaml 示例
current_task: 001-login-page
iteration: 3
stage: lint
status: retrying
last_error: "Lint L001: 硬编码 #3B82F6，应使用 token color.primary"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

## 验证协议（原 verification.md 内容）

### LOOP 内检查（VERIFY + LINT）

**VERIFY 阶段必做检查**（verify skill）：

1. **设计完整性**：设计稿是否覆盖所有验收标准
2. **验收标准**：逐条检查 spec.md 里的 AC-xxx 是否满足
3. **宪法合规**：检查是否违反 constitution.md 的原则
4. **基础可访问性**：对比度 + 键盘导航（快速检查，非全项）
5. **可交付性检查**：标注/规格是否齐全

**LINT 阶段必做检查**（design-lint skill）：

1. **Token 一致性**：L001-L005（颜色/间距/圆角/字号/阴影必须来自 token）
2. **组件一致性**：L006-L008（同语义组件 ≤3 种实现 / 变体合并 / 状态完整）
3. **布局一致性**：L009-L010（对齐基线 / 栅格列数）
4. **反 AI-slop**：L011-L015（禁用 Inter/紫渐变/统一圆角/Lorem ipsum）

**lint 失败处理**：design-lint 失败时，更新 state.yaml 的 `last_error` 字段，格式：`Lint L00X: <描述>`，复用现有字段，不新增 lint_status 字段。

### LOOP 外检查（最终门禁）

**DESIGN-REVIEW**（design-review skill）：

1. **Five-Axis Review**：视觉层级 / 间距对齐 / 色彩对比 / 组件一致性 / 可访问性
2. **Doubt-Driven 对抗式审查**：CLAIM → EXTRACT → DOUBT → RECONCILE → STOP
   - Nit/FYI 级别：直接记录，不触发对抗辩论
   - Critical 级别：才触发 fresh-context 子 agent 对抗
3. **Severity Labeling**：Critical / 无前缀 / Nit / FYI

**ACCESSIBILITY-AUDIT**（accessibility-audit skill）：

1. WCAG 2.1 AA 全项检查（对比度 / 键盘 / 屏幕阅读器 / 响应式 / reduced-motion）

### 声称"完成"的前置条件

Agent 在声称任务完成前，**必须**：
- [ ] LOOP 内 verify 全部通过（AC-xxx 逐条 ✓）
- [ ] LOOP 内 design-lint 全部通过（无 error 级违规）
- [ ] LOOP 外 design-review 通过（Five-Axis + Doubt-Driven）
- [ ] LOOP 外 accessibility-audit 通过（WCAG 2.1 AA）
- [ ] 将证据写入 `loops/specs/<task>/evidence.md`
- [ ] 更新 `loops/specs/<task>/state.yaml` 的 status 为 done

**没有证据不声称完成**——这是 AGENTS.md 核心规则。

### 失败处理

**LOOP 内失败**（verify/lint）：
1. 将失败信息写入 `state.yaml` 的 `last_error` 字段
2. 追加一行到 `iterations.log`
3. 分析失败原因：
   - 可修复（对比度不足、lint 违规、缺少状态）→ 回到 DESIGN
   - 需重新规划（需求理解错误、方向偏差）→ 回到 PLAN
4. 迭代次数 +1，检查是否超过最大迭代

**LOOP 外失败**（design-review/accessibility-audit）：
1. 将失败信息写入 `state.yaml` 的 `last_error` 字段
2. 分析失败原因：
   - 可修复（视觉层级问题、对比度不达标）→ 回到 LOOP（重新 DESIGN）
   - 需重新规划（方向偏差、需求理解错误）→ 回到 PLAN
3. 不消耗迭代次数（LOOP 外失败不计数）

### 断点续传

会话中断后恢复：
1. 读取 `loops/specs/<task>/state.yaml` 获取当前阶段和迭代次数
2. 读取 `iterations.log` 了解失败历史
3. 从中断点继续，不从头开始
4. 若 `stage` 为 `review`，说明 LOOP 已退出，应继续 LOOP 外门禁
