---
name: requesting-code-review
description: 代码审查，质量把关——完成后审查，不是边写边审
triggers:
  - verify 通过后
  - 任务声称完成前
  - 合并分支前
reads:
  - rules/security.md
  - constitution.md
  - loops/specs/<feature>/spec.md
  - loops/specs/<feature>/evidence.md
writes:
  - loops/specs/<feature>/iterations.log
---

# Requesting Code Review — 代码审查

## 铁律
**verify 通过不等于能交付。** 测试过了只代表"功能对"，审查才代表"代码好"。

## 流程

1. **准备审查材料**
   - 读 spec.md 确认功能范围
   - 读 evidence.md 确认验证已通过
   - 列出本次变更的文件（git diff）

2. **逐项审查**

   ### 设计层面
   - [ ] 代码是否符合 spec.md 定义的设计？
   - [ ] 有没有过度设计？（YAGNI）
   - [ ] 有没有职责不清？（一个函数做太多事）
   - [ ] 命名是否清晰？（不需要注释就能懂）

   ### 实现层面
   - [ ] 有没有硬编码的魔法值？
   - [ ] 有没有重复代码？（DRY）
   - [ ] 错误处理是否完整？（边界情况）
   - [ ] 有没有安全隐患？（读 security.md 对照）

   ### 宪法合规
   - [ ] 是否引入未审批的新依赖？
   - [ ] 新增 API 是否有测试？
   - [ ] schema 变更是否有迁移脚本？

   ### 可维护性
   - [ ] 三个月后还能看懂吗？
   - [ ] 别人接手能看懂吗？
   - [ ] 关键决策有没有注释说明 why（不是 what）？

3. **记录审查结果**
   - 通过 → 在 iterations.log 追加：`[时间] code-review PASSED`
   - 不通过 → 列出问题清单（按 Critical/Major/Minor/Question/Nitpick 分类），交给 `receiving-code-review` skill 处理

4. **更新功能状态**
   审查通过后，该功能可以标记为 `done`（由 session-end 批量同步到 FEATURES.md）

## 审查反馈分类标准

| 级别 | 定义 | 示例 |
|------|------|------|
| **Critical** | 功能错误/安全漏洞/数据丢失 | SQL 注入、空指针崩溃、密码明文存储 |
| **Major** | 设计缺陷/性能问题/可维护性差 | 函数 500 行、循环嵌套 5 层、重复代码 |
| **Minor** | 命名/注释/风格 | 变量名 `a`、缺少类型注解、魔法数字 |
| **Question** | 审查者不确定，需讨论 | "这里为什么用 X 不用 Y？" |
| **Nitpick** | 个人偏好，无关紧要 | "我觉得这个空行可以删" |

问题清单交给 `receiving-code-review` skill 处理，本 skill 不负责修复。

## 禁止事项
- 跳过审查直接声称完成
- 审查只看"能不能跑"（那是 verify 的活）
- 审查发现问题但不修就放过
- 自己审自己还放水（要诚实，像审别人的代码一样）

## 与 LOOP 的关系
本 skill 在 LOOP 之外，是 LOOP 完成后的最终审查：
- LOOP(tdd → verify) 通过 → requesting-code-review → 通过 = 真正完成
- LOOP(tdd → verify) 通过 → requesting-code-review → 不通过 → 回到 tdd

## 与 verify 的分工
| 维度 | verify | code-review |
|------|--------|-------------|
| 关注点 | 功能对不对 | 代码好不好 |
| 时机 | LOOP 每次迭代 | LOOP 完成后一次 |
| 产出 | evidence.md | 审查结论 |
| 失败 | 回到 tdd | 交给 receiving-code-review |

## 与 receiving-code-review 的配合
| 阶段 | 职责 |
|------|------|
| requesting-code-review | 发起审查，列问题清单 |
| receiving-code-review | 响应反馈，修复/拒绝/讨论 |
| （如修复）tdd + verify | 修复后重新验证 |
| requesting-code-review（复审） | 确认修复有效 |
