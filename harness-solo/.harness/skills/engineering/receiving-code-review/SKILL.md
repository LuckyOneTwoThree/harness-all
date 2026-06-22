---
name: receiving-code-review
description: 接收并处理代码审查反馈，分类响应 + 修复 + 回复
triggers:
  - requesting-code-review 返回问题清单后
  - 收到外部代码审查反馈时
  - 用户指出代码问题时
reads:
  - rules/security.md
  - loops/specs/<feature>/spec.md
  - loops/specs/<feature>/evidence.md
  - loops/specs/<feature>/iterations.log
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/iterations.log
  - loops/specs/<feature>/evidence.md
---

# Receiving Code Review — 接收审查反馈

## 铁律
**每条反馈都必须有响应，不许忽略。** 响应 ≠ 接受，但必须明确"修/不修/讨论"。

## 流程

1. **收集反馈**
   - 从 `requesting-code-review` skill 获取问题清单
   - 或从外部审查（PR review、用户反馈）收集
   - 每条反馈记录原文

2. **分类**（按严重程度）

   | 级别 | 定义 | 处理方式 |
   |------|------|---------|
   | **Critical** | 功能错误/安全漏洞/数据丢失 | 必须修，立即回 tdd |
   | **Major** | 设计缺陷/性能问题/可维护性差 | 必须修，本轮内解决 |
   | **Minor** | 命名/注释/风格 | 应该修，可批量处理 |
   | **Question** | 审查者不确定，需讨论 | 回复说明，不一定要改 |
   | **Nitpick** | 个人偏好，无关紧要 | 可忽略，但礼貌回复 |

3. **逐条响应**

   对每条反馈，选择一种响应：

   - **接受并修复**：
     - 回到 `test-driven-development`：先写测试复现问题 → 修复 → 验证
     - 修复后在 iterations.log 追加：`[时间] review-fix: <反馈摘要> → FIXED`

   - **拒绝并说明**：
     - 给出理由（如"违反 YAGNI""与 spec.md 边界冲突""性能影响可忽略"）
     - 在 iterations.log 追加：`[时间] review-reject: <反馈摘要> → REJECTED: <理由>`

   - **讨论**：
     - 反馈本身需要更多信息才能决定
     - 向用户提问，等待澄清
     - 在 iterations.log 追加：`[时间] review-discuss: <反馈摘要> → PENDING DISCUSSION`

4. **更新 evidence.md**
   - 在 evidence.md 追加"代码审查响应"章节：
     ```markdown
     ## 代码审查响应

     | # | 级别 | 反馈 | 响应 | 状态 |
     |---|------|------|------|------|
     | 1 | Critical | [反馈] | 修复 | FIXED |
     | 2 | Major | [反馈] | 修复 | FIXED |
     | 3 | Minor | [反馈] | 接受 | FIXED |
     | 4 | Question | [反馈] | 说明 | RESOLVED |
     | 5 | Nitpick | [反馈] | 忽略 | WONTFIX |
     ```

5. **二次审查**（如有 Critical/Major 修复）
   - 修复 Critical/Major 后，重新调用 `requesting-code-review` 复审
   - 复审通过 → 审查闭环完成
   - 复审仍有问题 → 回到步骤 2

## 响应原则

- **诚实**：不为了"通过审查"而假装接受又偷偷不改
- **有理有据**：拒绝必须给理由，不能只说"我觉得不用改"
- **不防御**：审查是帮自己改进，不是攻击，不要为代码辩护
- **区分偏好与问题**：审查者的个人偏好可以拒绝，但客观问题必须修

## 禁止事项
- 忽略反馈不响应（哪怕 nitpick 也要说"忽略"）
- 假装修复但实际没改（违反诚实原则）
- 批量接受所有反馈不思考（有些反馈可能是错的）
- 修复后不跑测试就声称 FIXED

## 与其他 skill 的分工

| Skill | 职责 | 时机 |
|-------|------|------|
| requesting-code-review | 发起审查，列问题清单 | LOOP 之后 |
| **receiving-code-review** | 响应反馈，修复或拒绝 | 审查返回后 |
| test-driven-development | 修复审查发现的问题 | receiving-code-review 触发 |

## 与 LOOP 的关系
本 skill 在 LOOP 之外，是审查反馈的处理闭环：
- requesting-code-review → **receiving-code-review** → （如需修复）回 tdd → verify → 再 requesting-code-review
- 所有 Critical/Major 修复并复审通过 = 审查闭环完成
