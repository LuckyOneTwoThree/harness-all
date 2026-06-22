---
name: ice-scoring
description: 对增长假设清单进行ICE/RICE评分排序，确定实验优先级
triggers:
  - 有多个假设需要排序时
  - 增长实验Loop的PLAN阶段，hypothesis-generation之后
reads:
  - loops/specs/<experiment>/spec.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<experiment>/spec.md
quality_gates: []
max_iterations: 2
---

# ICE Scoring — 假设优先级排序

## 铁律
- 每个假设必须打分，不允许"凭感觉"排序
- 打分基于证据而非乐观——Confidence 必须有数据/案例支撑
- 排序结果必须记录理由，便于复盘"为什么当时选了这个"

## 流程

1. **读取假设清单**
   从 `loops/specs/<experiment>/spec.md` 读取 hypothesis-generation 产出的假设列表

2. **ICE 评分**
   对每个假设打三个维度分（1-10 分）：

   | 维度 | 含义 | 打分依据 |
   |------|------|---------|
   | **Impact** | 对北极星指标/主指标的影响程度 | 10=直接影响NSM，5=影响二级指标，1=影响微弱 |
   | **Confidence** | 假设成立的信心度 | 10=有数据/案例强支撑，5=有理论依据但无数据，1=纯猜测 |
   | **Ease** | 实施难度（越高越容易） | 10=几小时搞定，5=需1-2周，1=需跨团队多月 |

   ICE Score = Impact × Confidence × Ease

3. **RICE 扩展（可选）**
   如需更精细排序，升级为 RICE：
   - Reach：影响多少用户（按周期内触达用户数估）
   - Impact：对单个用户的影响（0.25/0.5/1/2/3）
   - Confidence：信心度（50%/80%/100%）
   - Effort：人周数（越高越难）
   - RICE Score = (Reach × Impact × Confidence) / Effort

4. **排序与筛选**
   - 按 ICE/RICE Score 降序排列
   - 标注 Top 3 假设为"本周优先实验"
   - 标注低分假设为"暂缓"并记录原因

5. **记录决策理由**
   在 spec.md 追加排序表：
   ```
   | 假设ID | 假设摘要 | Impact | Confidence | Ease | ICE Score | 决策 | 理由 |
   |--------|---------|--------|------------|------|-----------|------|------|
   | H-001 | ... | 8 | 7 | 9 | 504 | 优先 | 高影响+高信心+易实施 |
   | H-002 | ... | 9 | 4 | 5 | 180 | 暂缓 | 影响大但信心不足，需先做调研 |
   ```

6. **更新 spec.md**
   将排序结果写入 spec.md 的"优先级排序"章节

## 打分参考标准

### Impact 打分参考
| 分数 | 含义 | 示例 |
|------|------|------|
| 9-10 | 直接影响北极星指标 | 提升激活率→直接影响NSM(周活) |
| 7-8 | 影响一级输入指标 | 提升注册转化率→影响新用户数 |
| 5-6 | 影响二级指标 | 提升页面停留→间接影响转化 |
| 1-4 | 影响微弱或间接 | 改个按钮颜色 |

### Confidence 打分参考
| 分数 | 含义 | 支撑类型 |
|------|------|---------|
| 8-10 | 强信心 | 有历史实验数据/行业案例/用户调研 |
| 5-7 | 中信心 | 有理论依据/竞品做法/定性反馈 |
| 1-4 | 弱信心 | 纯直觉/无数据 |

### Ease 打分参考
| 分数 | 含义 | 实施成本 |
|------|------|---------|
| 8-10 | 快速可做 | 几小时-1天，无需开发 |
| 5-7 | 中等成本 | 1-2周，需少量开发 |
| 1-4 | 高成本 | 跨团队/多月/大重构 |

## 禁止事项
- 不跳过打分直接选假设（失去排序依据）
- 不给所有假设打满分（失去区分度）
- 不忽略 Confidence（高影响低信心的假设风险大）

## 与 LOOP 的关系
本 skill 在 LOOP 的 **PLAN 阶段**执行，在 hypothesis-generation 之后。
PLAN(hypothesis-generation → ice-scoring → experiment-design) → EXPERIMENT → MEASURE

## 与 Workflow 的关系
本 skill 是 **growth-experiment-workflow** 的第 2 步。
