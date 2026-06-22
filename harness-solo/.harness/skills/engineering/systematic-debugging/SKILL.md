---
name: systematic-debugging
description: 系统化调试，根因分析而非症状修补
triggers:
  - 测试失败时
  - Bug 报告时
  - verify 阶段发现问题时
reads:
  - loops/LOOP.md
  - rules/security.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/iterations.log
  - memory/knowledge-base.md
---

# Systematic Debugging — 系统化调试

## 铁律
**找根因，不修症状。** "改到能跑"不是调试，是赌博。

## 流程

1. **复现**
   - 写一个能稳定复现 Bug 的测试
   - 确认测试失败（红）
   - 不能稳定复现 = 还没理解 Bug，不许动手修

2. **定位**
   - 二分法缩小范围：注释掉一半代码，Bug 还在吗？
   - 看错误堆栈，找到最早的失败点
   - 检查最近的相关变更（git log/diff）

3. **分析根因**
   问"为什么"至少 3 次：
   - 为什么失败？→ 因为 X 是 null
   - 为什么 X 是 null？→ 因为 Y 没初始化
   - 为什么 Y 没初始化？→ 因为 Z 的执行顺序错了
   - **根因是 Z 的顺序问题，不是"X 是 null"**

4. **修复根因**
   - 修真正的原因（Z 的顺序），不是症状（给 X 加 null 检查）
   - 修复后复现测试应该通过

5. **回归检查**
   - 跑全量测试，确认修复没引入新问题
   - 检查有没有同类问题（同样的根因可能在别处）

6. **记录教训**
   如果根因有普遍性，写入 `memory/knowledge-base.md` 的**"踩坑记录"表**（不是"技术决策"或"模式沉淀"表）：
   ```
   ## 踩坑记录
   | 日期 | 问题 | 解决方案 | 相关文件 |
   |------|------|---------|---------|
   | YYYY-MM-DD | [根因描述] | [修复方式] | [文件路径] |
   ```

## 状态维护

调试时按 `loops/LOOP.md` 的 "state.yaml Schema" 更新：
- `stage`: `debug`
- `last_error`: `"[根因描述]"`
- `status`: `retrying`

字段完整定义和写入责任见 LOOP.md。

**更新 iterations.log（必须追加，禁止覆盖）**：
- 工具方式：先 Read 当前 iterations.log → 拼接新行 → Write 回去
- 或终端命令：`echo "[YYYY-MM-DD HH:MM] iter=<N> stage=debug → root cause: <根因>" >> .harness/loops/specs/<feature>/iterations.log`
- 禁止用 Write 直接覆盖 iterations.log（会抹掉历史迭代记录）

追加格式：
```
[YYYY-MM-DD HH:MM] iter=<N> stage=debug → root cause: <根因>
```

## 禁止事项
- 不复现就修（改了不知道有没有用）
- 修症状不修根因（"加个 try-catch 吞掉异常"）
- 改到能跑就停（没跑全量测试）
- 同一个 Bug 反复修（说明根因没找对）

## 与 LOOP 的关系
本 skill 在 LOOP 失败时触发：
- tdd 失败 → systematic-debugging 找根因 → 回到 tdd 修
- verify 失败 → systematic-debugging 找根因 → 回到 tdd 修

Bug 修复工作流：
session-start → systematic-debugging → LOOP(tdd→verify) → code-review → session-end
