---
name: hypothesis-generation
description: 基于数据洞察和增长方法论生成可证伪的增长假设，产出"如果X，那么Y，因为Z"结构化假设
triggers:
  - 需要设计增长实验但还没假设时
  - AARRR诊断发现薄弱环节后
  - 用户反馈/数据分析发现机会点后
  - 增长实验Loop的PLAN阶段
reads:
  - memory/knowledge-base.md
  - docs/handoff/pm-to-growth.md
  - loops/LOOP.md
writes:
  - loops/specs/<experiment>/spec.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 3
---

# Hypothesis Generation — 增长假设生成

## 铁律
- 每个假设必须是**可证伪的**——能被实验数据推翻
- 假设必须包含三要素：如果[改动X]，那么[指标Y]会[变化Z]，因为[理由]
- 不允许"拍脑袋"假设——必须有数据或洞察支撑
- 生成假设前必须查知识库，避免重复已证伪的实验

## 流程

1. **收集输入**
   - 读取 `memory/knowledge-base.md` 的"增长假设库"和"增长实验结论"，了解已验证/已证伪的假设
   - 读取 `docs/handoff/pm-to-growth.md`（如有），获取 PM 提供的增长假设和 OKR
   - 读取 `docs/handoff/solo-to-growth.md`（如有），获取已实现功能和埋点事件
   - 如无交接文档，从用户对话获取业务目标和当前痛点

2. **识别机会点**
   - 基于数据分析（漏斗瓶颈、留存曲线异动、用户反馈聚类）
   - 基于增长方法论（AARRR 薄弱环节、Growth Loop 断点、HOOK 缺失环节）
   - 基于竞品分析（竞品做了什么有效、我们没做的）
   - 列出所有机会点，标注数据来源

3. **生成假设**
   对每个机会点，用标准模板生成假设：
   ```
   假设ID: H-<NNN>
   假设: 如果[具体改动]，那么[指标名]会[提升/降低] [X%]，
         因为[用户心理/行为机制/数据依据]
   主指标: [实验成败的判定指标]
   护栏指标: [防止副作用的监控指标]
   证伪条件: [什么数据结果会推翻这个假设]
   来源: [数据洞察/用户反馈/方法论/竞品]
   ```

4. **查重与去伪**
   - 对照知识库的"增长假设库"，标注哪些假设已被验证/证伪
   - 已证伪的假设不重复生成，除非有新的变量
   - 已验证的假设标注"已验证，可放大"

5. **写入 spec.md**
   将假设清单写入 `loops/specs/<experiment>/spec.md` 的"假设"章节
   每个假设单独编号，便于后续 ice-scoring 和 experiment-design 引用

6. **更新知识库**
   将新生成的假设写入 `memory/knowledge-base.md` 的"增长假设库"表，状态标为"待验证"

## 假设质量检查清单

- [ ] 假设是否可证伪？（有明确的证伪条件）
- [ ] 主指标是否可量化？（有基线值和目标值）
- [ ] 护栏指标是否覆盖副作用风险？
- [ ] 假设是否有数据/方法论支撑？（不是纯直觉）
- [ ] 是否查重？（知识库中无相同假设的重复）

## 禁止事项
- 不生成模糊假设（如"优化体验会提升留存"——无法证伪）
- 不生成无法度量的假设（如"用户会更开心"——无指标）
- 不生成无理由的假设（缺少"因为"部分）
- 不跳过查重直接生成（可能重复已证伪实验）

## 与 LOOP 的关系
本 skill 在 LOOP 的 **PLAN 阶段**执行，是实验循环的起点。
PLAN(hypothesis-generation → ice-scoring → experiment-design) → EXPERIMENT → MEASURE

## 与 Workflow 的关系
本 skill 是 **growth-experiment-workflow** 的第 1 步。
产出供 ice-scoring 排序，再供 experiment-design 设计实验方案。
