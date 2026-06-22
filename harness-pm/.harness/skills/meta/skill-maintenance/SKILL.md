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
  - .harness/skills/pm/
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
- `.harness/skills/pm/` 目录结构完整

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
   - 用 Glob 扫描 `.harness/skills/meta/*/` 下的所有 SKILL.md
   - 用 Glob 扫描 `.harness/skills/workflows/*.md`
   - 用 Glob 扫描 `.harness/skills/pm/*/SKILL.md`（82 个 PM skill，扁平化组织）
   - 收集所有实际存在的 skill/workflow 名称

2. **解析 INDEX.md**
   - 读取 INDEX.md，提取已注册的 skill 名称和模块

3. **一致性对比**

   | 检查项 | 通过标准 | 失败处理 |
   |--------|---------|---------|
   | 元 skill 完整性 | meta/ 下 4 个 skill 都有 SKILL.md | 标记"缺失" |
   | 工作流完整性 | workflows/ 下 10 个 .md 都存在 | 标记"缺失" |
   | PM skill 完整性 | pm/ 下 82 个 skill 目录都有 SKILL.md | 标记"skill 缺失" |

4. **检查 SKILL.md frontmatter**
   对每个 SKILL.md 检查是否包含：
   - `name:` 且与目录名一致
   - `description:`
   - `triggers:` 或 `metadata`
   - 缺少任意一项 → 标记"frontmatter 不完整"

5. **检查 PM skill 目录结构**
   - 每个 skill 目录下有 SKILL.md
   - 目录名与 SKILL.md 的 `name` 字段一致
   - skill 扁平化组织在 `.harness/skills/pm/` 下（不再按模块分目录）

6. **输出健康报告**
   将结果写入 `memory/progress.md` 或本次会话报告：
   ```markdown
   ## Skill 健康检查

   | 检查项 | 状态 | 详情 |
   |--------|------|------|
   | 元 skill | ✓ / ✗ | 4/4 存在 |
   | 工作流 | ✓ / ✗ | 10/10 存在 |
   | PM skill | ✓ / ✗ | 82/82 skill 存在 |
   | frontmatter | ✓ / ✗ | [问题列表或"无"] |
   ```

7. **修复（仅在用户授权后）**
   - 空目录 → 询问用户后删除
   - 未注册 skill → 在 INDEX.md 对应分类追加一行
   - frontmatter 缺失 → 按 SKILL.md.template 补齐
   - 修复后重新运行检查，确认通过

## 证据要求

运行本 skill 后必须展示：
- 实际扫描到的 skill 列表（按模块统计）
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
