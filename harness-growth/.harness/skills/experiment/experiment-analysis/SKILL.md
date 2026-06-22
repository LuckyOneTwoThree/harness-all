---
name: experiment-analysis
description: 分析A/B测试数据，计算统计显著性/置信区间/效应量，检测SRM和分群异质性
triggers:
  - 实验数据收集完成后
  - 增长实验Loop的MEASURE阶段
  - 用户询问"实验结果如何"
reads:
  - loops/specs/<experiment>/spec.md
  - loops/LOOP.md
writes:
  - loops/specs/<experiment>/evidence.md
  - loops/specs/<experiment>/state.yaml
  - loops/specs/<experiment>/iterations.log
quality_gates: []
max_iterations: 2
---

# Experiment Analysis — 实验数据分析

## 铁律
- **没有数据不声称完成**——必须展示实际数据，不是"应该有效"
- 必须检查 **SRM（样本比例失调）**——SRM 触发则实验无效
- 必须报告**效应量和置信区间**，不只看 p 值
- 必须检查**分群异质性**——整体不显著不代表所有分群都不显著

## 流程

1. **读取实验设计**
   从 spec.md 读取：
   - 主指标及基线值/目标值
   - 护栏指标及阈值
   - 假设陈述及证伪条件
   - 预期样本量和实际样本量

2. **数据完整性检查**
   - 样本量是否达到预期？（如未达到，提示"样本不足，结论可靠性低"）
   - 实验时长是否覆盖完整周期？（至少 7 天）
   - 数据是否有缺失/异常？（如某天数据断档）

3. **SRM 检测（必做）**
   样本比例失调检测：
   ```
   预期比例: 对照组 50% / 实验组 50%
   实际比例: 对照组 N1 / 实验组 N2

   卡方统计量 = (|N1 - N_expected| - 0.5)² / N_expected × 2
   p_value = 1 - chi2.cdf(卡方统计量, df=1)

   如 p_value < 0.001 → SRM 触发，实验无效，需排查分流bug
   ```
   **SRM 触发时**：停止分析，记录到 iterations.log，要求排查分流实现

4. **主指标显著性检验**

   ### 比率型指标（z 检验）
   ```
   z = (p_control - p_variant) / sqrt(p_pooled × (1-p_pooled) × (1/n1 + 1/n2))
   p_value = 2 × (1 - norm.cdf(|z|))
   置信区间 = (p_v - p_c) ± 1.96 × SE
   ```

   ### 连续型指标（t 检验）
   ```
   t = (mean_c - mean_v) / sqrt(s_c²/n1 + s_v²/n2)
   自由度 = Welch-Satterthwaite 公式
   p_value = 2 × (1 - t.cdf(|t|, df))
   ```

5. **效应量计算**
   - 绝对提升：p_variant - p_control
   - 相对提升：(p_variant - p_control) / p_control × 100%
   - Cohen's h（比率型效应量）：h = 2 × arcsin(√p_v) - 2 × arcsin(√p_c)
   - 解读：h<0.2 小效应，0.2-0.5 中效应，0.5-0.8 大效应，>0.8 极大效应

6. **护栏指标检查**
   逐条检查 spec.md 定义的护栏指标：
   - 如任一护栏指标触发红线 → 标注"护栏触发"，不建议全量
   - 护栏指标未触发 → 标注"护栏通过"

7. **分群异质性分析**（必做）
   按预设维度拆分分析：
   - 新用户 vs 老用户
   - 移动端 vs 桌面端
   - 不同地区/渠道
   - 高频用户 vs 低频用户

   输出分群对比表：
   ```
   | 分群 | 对照组 | 实验组 | 提升 | p值 | 显著? |
   |------|--------|--------|------|-----|-------|
   | 新用户 | 30% | 36% | +6% | 0.02 | ✓ |
   | 老用户 | 45% | 46% | +1% | 0.45 | ✗ |
   ```
   **洞察**：如某分群显著但整体不显著，记录"分群异质性，建议针对该分群全量"

8. **写入 evidence.md**
   ```markdown
   # 实验证据: <experiment-name>

   ## 实验元信息
   - 实验周期: YYYY-MM-DD 至 YYYY-MM-DD
   - 总样本量: N
   - 分流比例: 50/50

   ## SRM 检测
   - 预期比例: 50/50
   - 实际比例: 50.2/49.8
   - p_value: 0.35
   - 结论: SRM 未触发 ✓

   ## 主指标结果
   | 指标 | 对照组 | 实验组 | 绝对提升 | 相对提升 | p值 | 置信区间 | 显著? |
   |------|--------|--------|---------|---------|-----|---------|-------|
   | 注册转化率 | 35.2% | 38.8% | +3.6% | +10.2% | 0.012 | [0.8%, 6.4%] | ✓ |

   ## 护栏指标
   | 指标 | 对照组 | 实验组 | 阈值 | 通过? |
   |------|--------|--------|------|-------|
   | 次日留存 | 42% | 41.5% | ≥41% | ✓ |
   | 页面加载 | 1.2s | 1.3s | ≤1.4s | ✓ |

   ## 分群异质性
   [分群对比表]

   ## 结论
   [显著/不显著 + 是否建议全量]
   ```

9. **更新 state.yaml**
   - stage: measure
   - status: done（如通过）或 retrying（如需重新设计）
   - last_error: 失败原因（如未达显著）

10. **追加 iterations.log**
    ```
    [YYYY-MM-DD HH:MM] iter=N stage=measure → [PASSED/FAILED]: [结论摘要]
    ```

## 禁止事项
- 不跳过 SRM 检测直接分析（SRM 会让结论完全失效）
- 不只看 p 值下结论（效应量和置信区间同样重要）
- 不忽略分群分析（整体不显著可能掩盖分群差异）
- 不在样本不足时强行下结论（低功效=高假阴性率）

## 与 LOOP 的关系
本 skill 在 LOOP 的 **MEASURE 阶段**执行。
PLAN → EXPERIMENT → MEASURE(本skill) → 通过? DONE : 回到 PLAN/EXPERIMENT

## 与 Workflow 的关系
本 skill 是 **growth-experiment-workflow** 的第 5 步（实验执行后的分析）。
产出供 experiment-conclusion 生成最终结论和决策建议。
