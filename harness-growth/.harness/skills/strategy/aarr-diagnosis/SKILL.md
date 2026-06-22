---
name: aarr-diagnosis
description: AARRR漏斗诊断，找出最薄弱环节作为增长优先方向
triggers:
  - 需要诊断增长瓶颈时
  - 增长战略制定Workflow
  - 增长回顾报告Workflow
  - 用户要求"诊断增长问题"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/GROWTH_STRATEGY.md
quality_gates: []
max_iterations: 1
---

# AARR Diagnosis — AARRR 漏斗诊断

## 铁律
- 诊断必须基于**实际数据**，不是"感觉留存有问题"
- 必须找出**最薄弱环节**——资源有限，聚焦最大瓶颈
- 必须给出**优先级建议**——先修哪个环节

## 流程

1. **收集 AARRR 各环节数据**
   | 环节 | 关键指标 | 当前值 | 行业基准 |
   |------|---------|--------|---------|
   | Acquisition | UV/注册数 | ? | - |
   | Activation | 激活率/首日留存 | ? | 30-60% |
   | Retention | 7日/30日留存 | ? | 20-40% |
   | Revenue | 付费转化率/ARPU | ? | 2-10% |
   | Referral | K因子/邀请率 | ? | 0.1-0.5 |

2. **计算漏斗转化率**
   ```
   访客 → 注册: X%
   注册 → 激活: Y%
   激活 → 留存: Z%
   留存 → 付费: W%
   付费 → 推荐: V%
   ```

3. **识别薄弱环节**
   - 哪个环节转化率**最低**？
   - 哪个环节**低于行业基准**最多？
   - 哪个环节**近期下降**最多？

4. **优先级评估**
   | 环节 | 转化率 | vs 基准 | 影响 NSM 程度 | 优先级 |
   |------|--------|---------|-------------|--------|
   | Activation | 15% | -45% | 高（影响留存） | P0 |
   | Retention | 25% | -15% | 高 | P1 |
   | Acquisition | - | - | 中 | P2 |

5. **产出诊断报告**
   ```
   ## AARRR 诊断结论
   最薄弱环节: [环节名]（转化率 X%，低于基准 Y%）
   优先方向: [先修哪个环节]
   预期影响: [修复后对 NSM 的影响]
   ```

## 禁止事项
- 不在无数据时诊断
- 不忽略行业基准（没有对比就没有判断）
- 不同时修所有环节（资源分散=都修不好）

## 与 LOOP 的关系
本 skill 不在 LOOP 内执行，是**诊断工具**。
产出供 hypothesis-generation 参考实验方向。

## 与 Workflow 的关系
本 skill 是 **growth-strategy-workflow** 的第 3 步，也是 **growth-review-workflow** 的组成部分。
