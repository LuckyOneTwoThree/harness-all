---
name: kpi-tree
description: 将北极星指标拆解为KPI Tree，产出可实验的输入指标
triggers:
  - NSM定义后需要拆解时
  - 增长战略制定Workflow
  - 用户要求"拆解指标"
reads:
  - docs/operations/GROWTH_STRATEGY.md
  - docs/handoff/pm-to-growth.md
writes:
  - docs/operations/GROWTH_STRATEGY.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# KPI Tree — 指标拆解

## 铁律
- 每一层指标必须**可被实验影响**
- 上下层必须有**因果而非仅相关**关系
- 拆解到**可操作的叶子指标**（能直接设计实验的层级）

## 流程

1. **读取 NSM**
   从 `docs/operations/GROWTH_STRATEGY.md` 读取已定义的北极星指标

2. **第一层拆解（公式拆解）**
   用数学公式拆解 NSM：
   ```
   NSM = A × B × C

   示例（Airbnb）:
   预订夜数 = 活跃房东数 × 房东平均被订夜数
            = (新增房东 + 存量房东×留存) × (被订率 × 平均被订天数)
   ```

3. **第二层拆解（漏斗拆解）**
   对每个一级指标，按漏斗拆解：
   ```
   新增房东 = 访客 × 注册转化率 × 房东认证转化率
   ```

4. **第三层拆解（可实验指标）**
   拆解到可直接设计实验的层级：
   ```
   注册转化率 = 落地页转化率 × 表单完成率 × 邮箱验证率
   ```

5. **标注可实验性**
   对每个叶子指标评估：
   - 可直接实验？（如"表单字段数"→可A/B测试）
   - 可间接影响？（如"品牌认知"→需通过内容/SEO间接影响）
   - 不可影响？（如"市场总量"→外部因素）

6. **产出 KPI Tree**
   ```
   NSM: [北极星指标]
   ├── 一级指标 A: [指标] (当前值 → 目标值)
   │   ├── 二级指标 A1: [指标]
   │   │   ├── 叶子指标 A1.1: [可实验指标] ← 实验方向
   │   │   └── 叶子指标 A1.2: [可实验指标]
   │   └── 二级指标 A2: [指标]
   └── 一级指标 B: [指标]
       └── ...
   ```

7. **写入增长战略文档**
   更新 `docs/operations/GROWTH_STRATEGY.md` 的"KPI Tree"章节

## 禁止事项
- 不拆解到无法实验的层级就停止（拆解的目的就是指导实验）
- 不用相关性代替因果性（相关不等于因果）
- 不忽略外部因素（标注哪些是不可控的）

## 与 LOOP 的关系
本 skill 不在 LOOP 内执行，是**战略级**拆解。

## 与 Workflow 的关系
本 skill 是 **growth-strategy-workflow** 的第 2 步。
产出供 hypothesis-generation 参考实验方向。
