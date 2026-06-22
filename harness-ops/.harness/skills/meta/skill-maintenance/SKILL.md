---
name: skill-maintenance
description: Skill 维护与质量检查，确保所有 SKILL.md 符合规范
triggers:
  - 新增/修改 Skill 后
  - 定期质量检查
reads:
  - skills/INDEX.md
  - skills/*/SKILL.md
writes:
  - skills/INDEX.md
---

# Skill Maintenance — Skill 维护

## 铁律
所有 SKILL.md 必须有完整 frontmatter，INDEX.md 必须与实际文件同步

## 流程

1. **扫描 Skill 目录**
   用 Glob 扫描 `.harness/skills/*/*/SKILL.md`，获取所有 skill 文件列表

2. **检查 frontmatter 完整性**
   每个 SKILL.md 必须包含：
   - `name:`（与目录名一致）
   - `description:`（一句话描述）
   - `triggers:`（触发场景列表）
   - `reads:`（依赖文件列表）
   - `writes:`（产出文件列表）

3. **同步 INDEX.md**
   将实际扫描结果与 INDEX.md 对比：
   - 新增的 skill → 补充到 INDEX.md
   - 删除的 skill → 从 INDEX.md 移除
   - 名称不匹配 → 以目录名为准修正

4. **检查行数**
   - AGENTS.md ≤ 120 行
   - SKILL.md ≤ 300 行
   - 超限的文件标注警告

## 禁止事项
- 不检查就声称"所有 skill 正常"
- 修改 SKILL.md 内容（只检查，不修改；如需修改提示用户）

## 与 LOOP 的关系
本 skill 在 LOOP 之外执行，是维护性操作。
