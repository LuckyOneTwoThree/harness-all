---
name: skill-maintenance
description: 框架 skill 健康检查，发现空目录、未注册 skill、frontmatter 缺失
triggers:
  - 用户说"检查框架健康"/"排查 skill"/"skill 索引不一致"时
  - session-start 可选调用（发现异常时报告）
  - 添加/删除 skill 后验证一致性
reads:
  - .harness/skills/INDEX.md
  - .harness/templates/SKILL.md.template
writes:
  - .harness/skills/INDEX.md
  - memory/knowledge-base.md
  - memory/progress.md
---

# Skill Maintenance — Skill 健康维护

## 核心原则
**If you can't find a skill, it doesn't exist. If it's registered but has no SKILL.md, it's broken.**

Skill 是框架的器官。本 skill 确保所有器官都在正确位置、都有正确结构、都能被索引发现。

## 什么是 skill 维护

**维护的是：**
- INDEX.md 与实际目录一致
- 每个 skill 都有 SKILL.md
- 每个 SKILL.md 都有完整的 frontmatter
- 没有空目录占位
- reads/writes 声明合理

**不是：**
- 修改 skill 的业务逻辑（那是该 skill 自己的事）
- 创建新 skill（用 `writing-skills`）
- 删除正在使用的 skill（必须人工确认）

## 何时运行

| 场景 | 动作 |
|------|------|
| 添加新 skill 后 | 立即运行，确认注册成功 |
| 删除 skill 后 | 立即运行，确认无残留引用 |
| 发现 skill 找不到 | 运行定位问题 |
| session-start 时 | 可选轻量检查，异常时报告 |

## 流程

1. **扫描实际 skill 目录**
   - 用 Glob 扫描 `.harness/skills/design/*/` 下的所有 SKILL.md
   - 用 Glob 扫描 `.harness/skills/meta/*/` 下的所有 SKILL.md
   - 用 Glob 扫描 `.harness/skills/workflows/*.md`
   - 收集所有实际存在的 skill/workflow 名称

2. **解析 INDEX.md**
   - 读取 INDEX.md，提取已注册的 skill 名称
   - 提取工作流名称

3. **一致性对比**

   | 检查项 | 通过标准 | 失败处理 |
   |--------|---------|---------|
   | 已注册 vs 实际存在 | INDEX.md 中列出的每个 skill 都必须有对应 SKILL.md | 标记"注册但未找到" |
   | 实际存在 vs 已注册 | 每个有 SKILL.md 的目录都必须在 INDEX.md 中注册 | 标记"未注册" |
   | 空目录 | design/meta 下每个子目录必须包含 SKILL.md 或文件 | 标记"空目录" |
   | 重复 skill | 同一 skill 名不能同时出现在 design 和 meta | 标记"重复" |

4. **检查 SKILL.md frontmatter**
   对每个 SKILL.md 检查是否包含：
   - `name:` 且与目录名一致
   - `description:`
   - `triggers:`
   - `reads:`
   - `writes:`
   - 缺少任意一项 → 标记"frontmatter 不完整"

5. **检查 reads/writes 合理性**
   - 如涉及 state.yaml → 必须读取 `loops/LOOP.md`
   - 如涉及安全 → 必须读取 `rules/security.md`
   - 如涉及 docs/handoff/ → 必须声明在 reads 或 writes 中
   - 未满足 → 标记"依赖声明缺失"

6. **输出健康报告**
   将结果写入 `memory/progress.md` 或本次会话报告：
   ```markdown
   ## Skill 健康检查

   | 检查项 | 状态 | 详情 |
   |--------|------|------|
   | INDEX 一致性 | ✓ / ✗ | 已注册 X 个，实际 Y 个 |
   | 空目录 | ✓ / ✗ | [列表或"无"] |
   | frontmatter | ✓ / ✗ | [问题列表或"无"] |
   | reads/writes | ✓ / ✗ | [问题列表或"无"] |
   ```

7. **修复（仅在用户授权后）**
   - 空目录 → 询问用户后删除
   - 未注册 skill → 在 INDEX.md 对应分类追加一行
   - frontmatter 缺失 → 按 SKILL.md.template 补齐
   - 修复后重新运行检查，确认通过

## 证据要求

运行本 skill 后必须展示：
- 实际扫描到的 skill 列表
- INDEX.md 中注册的 skill 列表
- 两者差异（如有）
- 空目录列表（如有）
- frontmatter 问题列表（如有）

不能只写"检查通过"。

## 禁止事项
- 不展示扫描结果就声称"一致"
- 未经用户授权删除非空 skill 目录
- 修改 skill 正文内容（只修结构/注册）
- 忽略空目录（空目录就是问题）

## 与 session-start 的关系
session-start 可以轻量调用本 skill 的检查逻辑：
- 发现异常 → 向用户报告，建议运行 skill-maintenance
- 无异常 → 不阻塞会话启动
