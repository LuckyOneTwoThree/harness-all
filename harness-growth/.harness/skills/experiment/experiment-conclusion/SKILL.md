---
name: experiment-conclusion
description: 生成实验结论与决策建议（全量/迭代/放弃），沉淀知识库条目
triggers:
  - 实验数据分析完成后
  - 增长实验Loop的MEASURE阶段，experiment-analysis之后
  - 需要产出实验复盘报告时
reads:
  - loops/specs/<experiment>/spec.md
  - loops/specs/<experiment>/evidence.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<experiment>/evidence.md
  - loops/specs/<experiment>/state.yaml
  - memory/knowledge-base.md
  - docs/handoff/growth-to-pm.md
quality_gates: []
max_iterations: 1
---

# Experiment Conclusion — 实验结论与沉淀

## 铁律
- 结论必须基于**证据**，不是"我觉得有效"
- 决策必须明确：全量 / 迭代 / 放弃——不允许"再观察观察"
- **实验失败也是结论**——必须记录"为什么失败"，避免重复踩坑
- 必须沉淀到知识库——不沉淀等于白做

## 流程

1. **读取实验证据**
   从 evidence.md 读取 experiment-analysis 的产出：
   - 主指标显著性结果
   - 护栏指标检查结果
   - 分群异质性分析
   - SRM 检测结果

2. **生成结论**
   基于证据，生成结构化结论：

   ```
   ## 实验结论

   ### 假设验证
   - 假设: 如果[改动X]，那么[指标Y]会[变化Z]，因为[理由]
   - 验证结果: [有效/无效/部分有效]
   - 证据: [p值/效应量/置信区间]

   ### 决策
   - 决策: [全量/迭代/放弃]
   - 理由: [基于证据的决策依据]

   ### 可复用洞察
   - 洞察1: [如"减少表单字段对激活率有显著正向影响"]
   - 洞察2: [如"该效应在新用户中更强，老用户无显著差异"]
   ```

3. **决策标准**

   | 情况 | 决策 | 理由 |
   |------|------|------|
   | 主指标显著 + 护栏通过 | **全量** | 假设验证，可放大 |
   | 主指标显著 + 护栏触发 | **迭代** | 有效果但有副作用，需优化方案 |
   | 主指标不显著 + 分群异质 | **迭代** | 整体无效但某分群有效，聚焦该分群 |
   | 主指标不显著 + 无分群异质 | **放弃** | 假设证伪，记录失败原因 |
   | 样本不足 | **延长** | 继续收集数据至样本量达标 |
   | SRM 触发 | **重做** | 分流bug，实验无效 |

4. **生成行动建议**
   - 如全量：制定 rollout 计划（渐进发布 5%→20%→50%→100%）
   - 如迭代：列出下一轮实验的调整方向
   - 如放弃：记录"为什么这个假设不成立"，更新假设库状态为"已证伪"

5. **沉淀到知识库**
   在 `memory/knowledge-base.md` 的"增长实验库"表追加一行：
   ```
   | G-<NNN> | [假设] | [主指标] | [有效/无效/不确定(p值)] | [全量/迭代/放弃] | [可复用洞察] | [标签] | [日期] |
   ```

   同时更新"增长假设库"表：
   - 如假设验证：状态改为"已验证"
   - 如假设证伪：状态改为"已证伪"，记录证伪原因

6. **更新 state.yaml**
   ```yaml
   stage: measure
   status: done
   last_error: ""
   ```

7. **产出交接文档**（可选）
   如实验结论值得反馈给 PM（有效/无效的重大发现）：
   - 追加到 `docs/handoff/growth-to-pm.md` 的"实验结果"章节
   - 或由 session-end 在会话结束时统一产出

## 结论报告模板

```markdown
# 实验复盘: <experiment-name>

## 一句话结论
[如：简化注册表单从6字段减至3字段，激活率提升10.2%(p=0.012)，建议全量]

## 实验设计回顾
- 假设: ...
- 主指标: ...
- 护栏指标: ...
- 样本量: ...
- 实验周期: ...

## 结果
[从 evidence.md 摘录关键数据]

## 决策与行动
- 决策: 全量
- Rollout 计划: ...
- 下一步: ...

## 学习沉淀
- 可复用洞察: ...
- 失败教训（如有）: ...
```

## 禁止事项
- 不在无证据时下结论
- 不做模糊决策（"再观察观察"不是决策）
- 不跳过知识库沉淀（不沉淀=白做实验）
- 不只记录成功不记录失败（失败实验的洞察同样有价值）

## 与 LOOP 的关系
本 skill 在 LOOP 的 **MEASURE 阶段**执行，是 MEASURE 的最后一步。
PLAN → EXPERIMENT → MEASURE(experiment-analysis → experiment-conclusion) → DONE

## 与 Workflow 的关系
本 skill 是 **growth-experiment-workflow** 的第 6 步（最后一步）。
产出的知识库条目会被 hypothesis-generation 在下一轮 Loop 中读取，形成复利。
