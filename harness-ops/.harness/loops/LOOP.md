# LOOP.md — 循环引擎定义 + 验证协议

> 来源：SRE 实践 (plan→provision→verify) + loop-engineering CLI
> 作用：替代线性 workflow，实现循环验证闭环
> 合并了原 verification.md 的内容

## 核心循环

```
┌──────────┐
│   PLAN   │ ← 定义变更目标 + 验证指标 + 宪法检查 + 回滚方案
└────┬─────┘
     ▼
┌──────────┐
│ PROVISION │ ← 执行部署（IaC apply / kubectl / Helm / CI 流水线）
└────┬─────┘
     ▼
┌──────────┐
│  VERIFY  │ ← 检查健康指标 + 监控大盘 + 冒烟测试
└────┬─────┘
     │
     ├── 通过 → DONE → 记录 evidence
     │
     └── 失败 → ROLLBACK → 分析原因
                   ├── 可修复 → 回到 PROVISION
                   └── 需重新规划 → 回到 PLAN
```

## 循环类型

| 类型 | 触发场景 | 最大迭代 | 停止条件 |
|------|---------|---------|---------|
| **provision** | 基础设施部署 / 版本发布 | 3 | 健康检查通过 + 监控指标平稳 |
| **incident** | 线上排障 / 应急响应 | 5 | 故障恢复 + 根因定位 |
| **optimization** | 性能/成本/资源优化 | 3 | 核心指标提升达标 + 无负面影响 |
| **recovery** | 容灾恢复演练 | 3 | RTO/RPO 达标 + 数据完整 |
| **audit** | 安全审计与合规检查 | 3 | 所有违规项修复或确认 |

## 成本控制

| 维度 | 限制 | 超限动作 |
|------|------|---------|
| 总循环次数 | 10 | 停止，请求人类介入 |

> Token 限制由用户在 IDE 中自行监控，不纳入框架规则（Agent 没有 token 计数器）。

## Specs 持久化

每次循环的 PLAN 阶段，将规格写入 `loops/specs/<task>/spec.md`。

## Evidence 追踪

每次 VERIFY 阶段的证据写入 `loops/specs/<task>/evidence.md`。

**文件写入语义区分（重要，避免混淆）**：

| 文件 | 写入语义 | 原因 | 操作方式 |
|------|---------|------|---------|
| `spec.md` | 覆盖 | 只保留最终通过的规格 | Write 直接覆盖 |
| `state.yaml` | 覆盖 | 只保留当前状态 | Write 直接覆盖 |
| `evidence.md` | 覆盖 | 只保留最终成功的证据 | Write 直接覆盖 |
| `iterations.log` | **追加** | 保留完整迭代历史 | Read+拼接+Write，或 `echo >>` |

```
loops/specs/001-deploy-v2/
├── spec.md          ← 变更规格（覆盖：最终通过版本）
├── state.yaml       ← 循环状态（覆盖：当前状态）
├── evidence.md      ← 验证证据（覆盖：最终成功）
└── iterations.log   ← 迭代历史（append-only，完整轨迹）
```

iterations.log 示例：
```
[2026-06-20 14:30] iter=1 stage=provision → verify FAILED: /health 返回 503
[2026-06-20 14:35] iter=2 stage=rollback → provision → verify FAILED: DB 连接超时
[2026-06-20 14:40] iter=3 stage=verify → PASSED
```

## 状态维护

**决策：Agent 读写维护 state.yaml（每任务一个文件，落盘）**

`loops/specs/<task>/state.yaml` 由部署/排障 skill 在循环中主动读写：
  - 记录当前迭代次数、上次失败原因、当前阶段
  - 会话中断后可断点续传（读取 state.yaml 恢复上下文）
  - verify skill 反正要写 evidence，多写一行 state 成本可忽略
  - 每任务一个文件，天然支持多任务并行

### state.yaml Schema（单一来源，各 SKILL.md 引用本节）

```yaml
# 必填字段
current_task: <NNN>-<task-name>       # 任务编号+名称，与目录名一致
iteration: <int>                       # 当前迭代次数，从 0 开始，每次 PROVISION→VERIFY 循环 +1
stage: <enum>                          # 当前阶段，枚举见下表
status: <enum>                         # 任务状态，枚举见下表
started_at: "<ISO 8601>"               # 任务开始时间，如 "2026-06-20T14:30:00"

# 可选字段（失败时填写）
last_error: "<错误描述>"                # 最近一次失败原因，成功时清空为 ""
last_error_at: "<ISO 8601>"            # 最近一次失败时间

# 可选字段（子阶段描述，用于 incident 等多子阶段工作流）
substage: "<子阶段描述>"                # 如 "detect" / "mitigate" / "root-cause" / "recover"
```

**stage 枚举值**：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `plan` | 规划阶段 | 变更初始化时 |
| `provision` | 执行部署阶段 | IaC apply / kubectl / Helm 执行时 |
| `verify` | 验证阶段 | 健康检查 / 监控验证时 |
| `rollback` | 回滚阶段 | 验证失败触发回滚时 |
| `debug` | 排障阶段 | incident 循环中根因分析时 |

**status 枚举值**（与全家族统一 Schema 对齐）：

| 值 | 含义 | 写入时机 |
|----|------|---------|
| `running` | 进行中 | 任务初始化 / 部署成功继续验证 |
| `retrying` | 重试中 | 部署/验证失败后 |
| `done` | 已完成 | 验证通过 + 监控指标平稳 |
| `failed` | 失败（需人类介入） | 迭代超限 |
| `needs-human` | 需人类介入 | 破坏性操作待审批 / 需人工决策 |
| `blocked` | 被阻塞 | 等待上游修复 / 等待资源就绪 |

**字段写入责任**：

| 字段 | plan（初始化） | provision | verify | rollback |
|------|:---:|:---:|:---:|:---:|
| current_task | 写（初始化） | 不改 | 不改 | 不改 |
| iteration | 写（0） | 写（+1） | 不改 | 不改 |
| stage | 写（plan） | 写（provision） | 写（verify） | 写（rollback） |
| status | 写（running） | 写（running/retrying） | 写（done/retrying） | 写（retrying） |
| last_error | 写（""） | 写（失败时/成功清空） | 写（失败时/成功清空） | 写（回滚原因） |
| started_at | 写（初始化） | 不改 | 不改 | 不改 |

**示例**：

```yaml
# loops/specs/001-deploy-v2/state.yaml 示例
current_task: 001-deploy-v2
iteration: 2
stage: verify
status: retrying
last_error: "健康检查 /health 返回 503，新版本 Pod 启动失败"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

## 验证协议

### VERIFY 阶段必做检查

1. **健康检查**：调用 `/health` 或等价接口，确认返回 200
2. **监控指标**：检查 Grafana/Prometheus 大盘，确认核心指标平稳（CPU/内存/错误率/延迟）
3. **冒烟测试**：执行关键链路的冒烟测试脚本
4. **宪法合规**：检查是否违反 constitution.md 的原则（IaC 文件存在、无明文秘钥等）
5. **安全扫描**：按 verify SKILL.md 的方式用 Grep 工具扫描秘钥泄漏（跨平台）

### 声称"完成"的前置条件

Agent 在声称任务完成前，**必须**：
- [ ] 健康检查通过（实际 HTTP 响应，不是"应该通过"）
- [ ] 监控指标平稳（实际数值，不是"看起来正常"）
- [ ] 冒烟测试通过（实际输出）
- [ ] 执行安全扫描并展示输出
- [ ] 将证据写入 `loops/specs/<task>/evidence.md`
- [ ] 更新 `loops/specs/<task>/state.yaml` 的 status 为 done

**没有证据不声称完成**——这是 AGENTS.md 核心规则第 1 条。

### 失败处理

VERIFY 失败时：
1. 触发 ROLLBACK（执行 spec.md 中的回滚方案）
2. 将失败信息写入 `state.yaml` 的 `last_error` 字段
3. 追加一行到 `iterations.log`
4. 分析失败原因：
   - 可修复（配置错误、资源不足）→ 回到 PROVISION
   - 需重新规划（方案错误、需求变更）→ 回到 PLAN
5. 迭代次数 +1，检查是否超过最大迭代

### 断点续传

会话中断后恢复：
1. 读取 `loops/specs/<task>/state.yaml` 获取当前阶段和迭代次数
2. 读取 `iterations.log` 了解失败历史
3. 从中断点继续，不从头开始
