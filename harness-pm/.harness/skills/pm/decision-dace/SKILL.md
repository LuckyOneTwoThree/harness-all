---
name: decision-dace
description: 当需要执行数据驱动决策闭环或将数据转化为可执行洞察时使用。DACE循环自动化，Define/Analyze由AI自动执行，Conclude由AI辅助人类决策，Execute由AI追踪执行效果。Analyze阶段融合洞察转化能力，将分析结果转化为故事化洞察、决策建议和决策边界标注。关键词：DACE循环、数据决策、决策闭环、数据驱动、决策框架、决策循环、数据分析闭环、用数据做决策、决策流程、怎么用数据推动行动、数据洞察、洞察转化、决策建议、故事化分析、数据故事、数据看不懂、把数据变成人话、数据说明了什么。
metadata:
  module: "产品度量运营"
  sub-module: "决策闭环"
  type: "pipeline"
  version: "2.0"
  domain_tags: ["通用"]
  trigger_examples:
    - "帮我用DACE方法做一个数据决策"
    - "从数据到行动的完整闭环怎么做"
    - "数据分析了但没人执行怎么办"
    - "这些数据说明了什么，帮我解读一下"
    - "把分析结果变成能讲的故事"
    - "数据太干了，帮我转化成可执行的建议"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "仅输出决策建议和关键依据"
  deep_description: "完整分析 + 决策树 + 敏感性分析 + 反事实推理"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/strategy/OKR.md
  - docs/metrics/experiment-report.md
  - docs/metrics/data-analysis-report.md
  - docs/metrics/decision-report.md
writes:
  - docs/metrics/decision-report.md
  - memory/progress.md
  - memory/knowledge-base.md
---

# DACE循环自动化（含洞察转化）

## 核心原则

1. **Define是方向，Analyze是证据**：没有明确目标的分析和没有证据支撑的决策同样危险
2. **Conclude权在人类，Execute追踪在系统**：AI提供选项和边界，人类做最终决策，系统负责追踪执行效果
3. **闭环才是完整**：DACE缺一不可，没有Execute的Conclude是空谈，没有Analyze的Conclude是赌博
4. **数据是起点，洞察是终点，行动是目的**：没有行动方向的洞察只是数据展示
5. **故事化而非术语化**：将"p=0.001"翻译为"99.9%可信度"，让决策者听懂才能行动
6. **边界标注比推荐更重要**：明确哪些可自动执行、哪些需人类确认，比简单推荐更有价值

## 交互模式

🤖→👤 AI建议人类审批

## 输入

| 输入项 | 类型 | 必填 | 来源 | 说明 |
|--------|------|------|------|------|
| OKR数据 | object | 是 | 用户提供 | 目标与关键结果、基线值与目标值 |
| KR进度 | object | 是 | docs/strategy/OKR.md | 各KR当前进度与偏差分析 |
| 实验结果 | object | 是 | docs/metrics/experiment-report.md（"实验结果"章节） | A/B测试结果、异常检测数据 |
| 分析结果-异常 | object | 是 | docs/metrics/data-analysis-report.md（"异常分析"章节） | anomaly报告 |
| 分析结果-漏斗 | object | 是 | docs/metrics/data-analysis-report.md（"漏斗分析"章节） | funnel报告 |
| 分析结果-留存 | object | 是 | docs/metrics/data-analysis-report.md（"留存分析"章节） | retention报告 |
| 业务上下文 | object | ○ | 用户提供 | 产品阶段、团队目标 |
| 历史洞察库 | object[] | ○ | docs/metrics/decision-report.md（"DACE决策"章节） | 避免重复 |

## 执行步骤

### DACE四阶段

```
┌────────────────────────────────────────────────────────┐
│                     DACE循环                            │
├────────────────────────────────────────────────────────┤
│                                                        │
│   ┌─────────┐                                          │
│   │  Define │  定义目标与成功指标                        │
│   └────┬────┘                                          │
│        │                                                │
│        ▼                                                │
│   ┌─────────┐                                          │
│   │ Analyze │  洞察生成：数据→故事→决策建议              │
│   └────┬────┘                                          │
│        │                                                │
│        ▼                                                │
│   ┌─────────┐                                          │
│   │Conclude │  得出结论与决策建议      ◀──────┐         │
│   └────┬────┘                               │         │
│        │                                    │         │
│        ▼                                    │         │
│   ┌─────────┐                               │         │
│   │ Execute │  执行策略并追踪效果 ───────────┘         │
│   └─────────┘       │                             │    │
│        │            │                             │    │
│        ▼            │                             │    │
│   返回Analyze ◀─────┘                             │    │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### Step 1: Define（定义）🤖 [核心]

自动建立OKR追踪体系，定义目标与成功指标（primary/supporting/guardrail）。

> 📋 详见 [Reference/step-define-conclude-execute.md](./Reference/step-define-conclude-execute.md)

### Step 2: Analyze（洞察生成）🤖 [核心]

故事化洞察转化、决策建议、决策边界、置信度评估。融合原 decision-insight 的洞察转化能力，将分析结果转化为故事化洞察。

#### 2.1 数据收集与分析 [核心]

自动收集和分析数据（metrics/experiments/events），执行异常检测、实验汇总、漏斗分析。

> 📋 详见 [Reference/step-analyze.md](./Reference/step-analyze.md)

#### 2.2 从数字到故事 [核心]

将数据分析转化为业务叙事，使用业务语言而非数据术语。

> 📋 详见 [Reference/step-analyze.md](./Reference/step-analyze.md)（含数据语言→业务语言映射表与叙事模板）

#### 2.3 决策建议生成 [条件]

生成多个可执行的决策选项（含预期效果、风险、置信度、资源需求、时间线、前置条件）。

> 📋 详见 [Reference/step-analyze.md](./Reference/step-analyze.md)

#### 2.4 决策边界标注 [深度]

区分 data_decision / data_reference / human_decision，标注自动执行资格与人工监督要求。

> 📋 详见 [Reference/step-analyze.md](./Reference/step-analyze.md)

#### 2.5 洞察汇总 [条件]

汇总已生成的洞察及其置信度与来源。

> 📋 详见 [Reference/step-analyze.md](./Reference/step-analyze.md)

### Step 3: Conclude（决策选项）🤖→👤 [核心]

AI辅助人类决策：AI生成决策建议（含优先级、依据、预期结果、风险等级），人类做出最终决定。

> 📋 详见 [Reference/step-define-conclude-execute.md](./Reference/step-define-conclude-execute.md)

### Step 4: Execute（执行追踪）🤖 [条件]

追踪执行效果，监控核心指标与护栏指标，设置监控告警阈值。

> 📋 详见 [Reference/step-define-conclude-execute.md](./Reference/step-define-conclude-execute.md)

## DACE状态追踪

追踪当前阶段、阶段历史、洞察统计、行动统计、结果统计。

> 📋 详见 [Reference/status-and-config.md](./Reference/status-and-config.md)

## 自动触发机制

> 📋 详见 [Reference/status-and-config.md](./Reference/status-and-config.md)（含触发条件→DACE响应映射表）

## OKR追踪配置

> 📋 详见 [Reference/status-and-config.md](./Reference/status-and-config.md)（含更新频率与告警规则）

## 洞察类型处理

针对异常洞察、漏斗洞察等不同类型生成对应叙述与决策选项。

> 📋 详见 [Reference/insight-types.md](./Reference/insight-types.md)

## 输出

**存储路径**：`docs/metrics/decision-report.md（"DACE决策"章节）`

### 输出深度分级

| 深度级别 | 输出范围 | 说明 |
|----------|----------|------|
| quick | 决策建议 + 关键依据 | 核心结论 + 最小可行产物，仅输出Define结论和Conclude推荐选项 |
| standard | 完整决策分析（当前默认） | 完整产物，包含DACE四阶段全部输出 |
| deep | 完整分析 + 扩展分析 | 完整产物 + 决策树 + 敏感性分析 + 反事实推理 + 决策记录 + 风险评估 |

**输出文件**：dace_status.json、okr_tracking.json、action_log.json、dace_cycle_report.md、decision_insight.json、insight_library.json

> 📋 输出Schema、洞察输出示例、输出文件结构、输出校验规则详见 [Reference/output-schemas.md](./Reference/output-schemas.md)

## 输出校验规则

> 📋 详见 [Reference/output-schemas.md](./Reference/output-schemas.md)（含字段路径、类型、必填、说明校验表）

## 上游变更响应

当上游输入发生变更时按响应策略调整对应阶段；当DACE状态/洞察自身变更时按通知机制通知下游 decision-culture。

> 📋 详见 [Reference/upstream-response.md](./Reference/upstream-response.md)（含上游变更响应策略表与下游通知机制表）

---

## 决策规则

| 情况 | 处理方式 |
|------|----------|
| KR进度落后>20% | 触发Conclude，生成决策建议 |
| KR无法完成 | 升级+OKR调整建议 |
| 实验结果统计显著 | 自动进入Conclude阶段 |
| 护栏指标被突破 | 暂停Execute，回退至Analyze |
| 洞察置信度≥0.8 + 护栏指标无下降 | 标记auto_execute_eligible，通知执行 |
| 洞察置信度≥0.8 + 护栏指标存在不确定性 | 标记data_reference，需人类确认 |
| 洞察置信度0.5-0.8 | 标记data_reference，需人类确认 |
| 洞察置信度<0.5 | 标记human_decision，人类主导 |
| 洞察涉及战略考量（影响≥3个OKR） | 标记human_decision，人类主导 |
| ≥3个独立洞察指向同一结论 | 合并洞察，置信度提升0.15 |
| 2个洞察指向同一结论 | 合并洞察，置信度提升0.1 |
| 洞察涉及收入影响≥10% | 强制标记human_decision |

## 质量检查

### P0 检查（quick/standard/deep 都必须通过）

- [ ] Define阶段目标可量化、有基线
- [ ] Analyze阶段覆盖所有数据源
- [ ] Conclude阶段提供至少2个决策选项

### P1 检查（standard/deep 必须通过）

- [ ] Execute阶段设置监控和回滚机制
- [ ] 洞察叙述使用业务语言而非数据术语
- [ ] 每个洞察至少提供2个决策选项
- [ ] 推荐行动有明确的下一步和负责人

### P2 检查（仅 deep 必须通过）

- [ ] 决策边界标注正确（auto/reference/human）
- [ ] 决策树已生成（各选项分支及概率评估）
- [ ] 敏感性分析已完成（关键变量对决策结论的影响程度）
- [ ] 反事实推理已完成（若选择其他选项的预期结果推演）

## 降级策略

### 上游文件缺失降级方案

| 缺失范围 | 降级方案 | 输出影响 |
|----------|----------|----------|
| OKR追踪缺失 | 用户提供当前指标数据 → 执行DACE分析 | Define阶段目标定义基于用户描述 |
| 异常检测缺失 | 跳过Analyze阶段的异常触发，基于用户提供的指标数据执行 | 分析维度受限，可能遗漏未关注异常 |
| OKR追踪 + 异常检测均缺失 | 用户提供当前指标数据 → 执行DACE分析 | 输出基于用户数据的DACE分析，Define和Analyze标注"待补充" |
| 分析结果缺失 | 用户提供数据发现 → 转化为洞察 | 洞察基于用户描述，可能缺乏深度归因 |
| 实验结果缺失 | 跳过实验相关洞察转化 | 实验洞察维度缺失 |
| 分析结果 + 实验结果均缺失 | 用户提供数据发现 → 转化为洞察 | 输出基于用户描述的洞察，归因和决策边界标注"待补充" |

### 数据获取说明

当上游文件缺失时，需用户提供以下信息以支撑降级生成：
- **当前指标数据**：关键指标的当前值、基线值和目标值
- **业务目标**（可选）：当前阶段的业务优先级和决策需求
- **已知问题**（可选）：已经发现的异常或待决策问题
- **数据发现**（可选）：观察到的数据变化、趋势或异常
- **期望决策方向**（可选）：希望洞察支持的决策类型

## 执行频率

| Phase | 执行频率 | 触发方式 |
|-------|---------|---------|
| Define | 季度/OKR变更 | 自动 |
| Analyze | 持续 | 定时+事件 |
| Conclude | 按需 | 分析完成 |
| Execute | 持续 | 决策批准 |
