---
name: performance-optimization
description: 性能优化，measure→identify→fix→verify→guard 闭环
triggers:
  - 用户报告性能问题时
  - 性能基准测试未达标时
  - LOOP 的 optimize 循环
  - 前端 Web Vitals 指标恶化时
reads:
  - loops/LOOP.md
  - rules/security.md
  - constitution.md
  - docs/product/PROJECT.md
  - docs/engineering/TECH_STACK.md
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/evidence.md
  - loops/specs/<feature>/iterations.log
---

# Performance Optimization — 性能优化

## 铁律
**Measure before optimize.** 没有 profile 数据的优化就是猜测，猜测导致 premature optimization——增加复杂度却没改善真正的问题。

## 循环类型
本 skill 对应 LOOP.md 的 **optimize** 循环：最大 3 次迭代，停止条件是基准测试达标。

## 流程

### 1. MEASURE — 建立 baseline
没有数字就没有优化。先测，后改。

**优化目标来源**：读 `docs/product/PROJECT.md` 的"非功能需求"字段，作为优化目标基线（如 P95 < 200ms）。如 PROJECT.md 无明确性能要求，与用户确认目标后再开始。

**后端/通用**：
- 用项目已有的基准测试命令（读 `docs/engineering/TECH_STACK.md` 确认）
- 无基准测试 → 用 `time` 命令或语言内置 profiler 测关键路径
- 记录：QPS / 延迟（P50/P95/P99）/ 内存 / CPU

**前端**（如涉及）：
- Lighthouse（Synthetic）：Performance score + LCP / CLS / INP
- web-vitals（RUM，如已接入）：真实用户数据
- Bundle size：`npm run build` 后记录 gzipped 大小

**性能预算参考**（不是硬性要求，作为对标）：
- JS bundle：< 200KB gzipped
- LCP：≤ 2.5s
- INP：≤ 200ms
- CLS：≤ 0.1

将 baseline 数字写入 evidence.md。

### 2. IDENTIFY — 定位真实瓶颈
**只修测量证实的瓶颈，不修"我觉得慢"的地方。**

- 用 profiler 输出找热点（耗时最多的函数 / 渲染最慢的组件 / 最慢的 SQL）
- 用症状树定位：慢在哪一层？（网络 / DB / 计算 / 渲染）
- 二分法验证：注释掉可疑模块，性能改善了吗？

常见瓶颈速查：
- DB：N+1 查询、缺索引、全表扫描
- 前端：未分页的长列表、无 `loading="lazy"` 的图片、无 `width/height` 导致 CLS
- 计算：循环嵌套过深、重复计算可缓存
- 网络：未压缩、未缓存、过多串行请求

### 3. FIX — 只改这一个瓶颈
- 一次只改一个瓶颈（改多个无法判断哪个有效）
- 改动遵循 surgical changes 原则——只碰必须碰的代码
- 不许顺手重构无关代码（那是 refactor 的活）

### 4. VERIFY — 再测一次，确认改善
- 用与步骤 1 **相同的**测量方式重新测
- 展示前后对比数字：
  ```
  ## 性能对比
  | 指标 | Before | After | 改善 |
  |------|--------|-------|------|
  | P95 延迟 | 850ms | 320ms | -62% |
  | Bundle size | 340KB | 185KB | -46% |
  ```
- 跑全量测试，确认**行为无回归**（性能优化是 refactor 的子集，行为不变）
- 数字没改善 → 回到 IDENTIFY 重新定位（可能改错了瓶颈）

### 5. GUARD — 防止回退
- 加回归测试或监控，防止性能回退：
  - 后端：基准测试纳入 CI
  - 前端：bundle size 检查 / Lighthouse CI
- 如项目无 CI 基础设施，在 evidence.md 记录"建议加监控"

## 反合理化表

| 借口 | 反驳 |
|------|------|
| "我觉得这里慢" | 你的感觉不是证据，先 profile |
| "优化后应该快了" | "应该"不是证据，再测一次对比 |
| "这个优化肯定有效" | 改完测了才知道，先改一个再测 |
| "React.memo 加上总没坏处" | 过度使用和欠使用一样糟，profile 证明它需要 |
| "用户机器应该不慢" | 你的机器不是用户的机器，测代表性环境 |

## 状态维护

按 LOOP.md 的 "state.yaml Schema" 更新：
- `stage`: `act`（FIX 阶段）/ `verify`（VERIFY 阶段）
- `iteration`: +1（每次 MEASURE→FIX→VERIFY 循环）
- `last_error`: 失败时填"指标未改善：<详情>"

**更新 iterations.log（追加，禁止覆盖）**：
```
[YYYY-MM-DD HH:MM] iter=<N> stage=verify → P95 850ms→320ms ✓
```

## 禁止事项
- 不测就改（猜测式优化）
- 一次改多个瓶颈（无法归因）
- 优化后不跑测试（行为回归比性能问题更严重）
- 只优化不守护（性能会悄悄回退）
- 过度使用 memo/useMemo/缓存（增加复杂度却无实测收益）

## 与 LOOP 的关系
本 skill 对应 LOOP 的 optimize 循环：
- MEASURE/IDENTIFY = PLAN（定位问题）
- FIX = ACT（改代码）
- VERIFY = VERIFY（对比数字 + 测试无回归）
- GUARD = DONE 后的防护

## 与其他 skill 的分工
| Skill | 职责 |
|-------|------|
| performance-optimization | 测量→定位→优化→验证闭环 |
| tdd | 优化过程中的行为保护（测试不能回归） |
| verify | 优化完成后的综合验证 |
| systematic-debugging | 性能问题根因分析（当瓶颈不明显时） |
