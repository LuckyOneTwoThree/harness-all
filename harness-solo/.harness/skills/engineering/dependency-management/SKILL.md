---
name: dependency-management
description: 依赖管理，添加/升级/审计，对接宪法依赖审批门
triggers:
  - 新增依赖前（强制）
  - 依赖升级时
  - 安全审计时
  - verify 阶段检查依赖合规
reads:
  - rules/security.md
  - constitution.md
  - docs/engineering/TECH_STACK.md
writes:
  - loops/specs/<feature>/iterations.log
  - memory/knowledge-base.md
---

# Dependency Management — 依赖管理

## 铁律
**Code is a liability.** 每加一个依赖就是新增攻击面 + 维护成本。能用 50 行内代码解决的，不引入依赖。

## 添加依赖流程

### 1. 必要性评估（硬门）
回答以下问题，任何一条不满足 → 不引入：

- [ ] **真的需要吗？** 能否用 50 行内代码或现有 primitive 替代？
- [ ] **维护活跃度？** 最近 commit < 6 个月，有持续维护
- [ ] **下载量？** 有足够用户验证（避免 typosquat / 弃坑风险）
- [ ] **已知 CVE？** `npm audit` / `pip-audit` 无 critical/high 漏洞
- [ ] **宪法合规？** 检查 `constitution.md` 的依赖原则（如零运行时依赖项目则直接拒绝）

### 2. 安全审查
- **postinstall 脚本**：检查包是否有 `postinstall` / `preinstall`（任意代码执行风险）
- **typosquat 检查**：包名是否与知名包高度相似（`cross-env` vs `crossenv`）
- **依赖树深度**：间接依赖是否过多（攻击面膨胀）
- **license 兼容**：检查 license 是否与项目兼容（GPL / AGPL 需特别注意）

### 3. 用户确认（强制）
- 向用户说明：包名、用途、替代方案考虑、安全审查结果
- **等待用户明确授权**，不许自行安装
- 用户拒绝 → 回到步骤 1 寻找替代方案

### 4. 接入验证
- 安装依赖
- **写一个使用该依赖的测试用例**，确认能跑通
- 跑全量测试，确认无回归
- 记录到 `docs/engineering/TECH_STACK.md` 的依赖清单

## 升级依赖流程

### 1. 升级前
- 跑全量测试，确认当前状态全绿（建立 baseline）
- 读 CHANGELOG / Migration Guide，确认 breaking changes
- 大版本升级（如 v3→v4）单独走 migration skill

### 2. 升级
- 一次只升一个依赖（多个混升无法归因问题）
- 锁文件必须提交（`package-lock.json` / `yarn.lock` / `pnpm-lock.yaml`）
- CI 用 `npm ci` 而非 `npm install`（可复现构建，杜绝版本漂移）

### 3. 升级后
- 跑全量测试，对比 baseline
- 有失败 → 回退或修复（走 systematic-debugging）
- 全绿 → 记录到 iterations.log

## 安全审计流程

### 1. 运行审计
```bash
# Node
npm audit
# Python
pip-audit
```
展示完整输出，不能只写"审计通过"。

### 2. 分流处理（不是见红就修，也不是见红就忽略）
按"可达性 + 严重度"分流：

| 严重度 | 生产可达 | dev-only |
|--------|---------|----------|
| critical/high | 立即修 | 尽快修，不阻塞 |
| moderate | 下个 release 修 | 常规更新一起修 |
| low | 常规更新一起修 | 可忽略 |

### 3. 延期修复记录
无法立即修的漏洞，记录到 `memory/knowledge-base.md`：
```
## 技术决策
| 日期 | 决策/根因 | 理由 | 替代方案 |
|------|------|------|---------|
| YYYY-MM-DD | 延期修复 CVE-XXXX（<包名>） | dev-only 且不可达，review date: YYYY-MM-DD | 升级到 vX.Y |
```

## 反合理化表

| 借口 | 反驳 |
|------|------|
| "反正能用就行" | 能用 ≠ 安全，依赖是攻击面 |
| "就一个小包" | 小包也可能有恶意 postinstall |
| "lockfile 提交太麻烦" | 不提交 = 不可复现构建 = 隐患 |
| "见 audit 红就 --force" | 忽略 ≠ 解决，按分流策略处理 |
| "升级以后再说" | 延期越久 breaking changes 越多 |

## 禁止事项
- 不审查就添加依赖（违反 security.md 依赖审查）
- 不提交 lockfile（不可复现构建）
- CI 用 `npm install` 而非 `npm ci`（版本漂移）
- 见 audit 红就 `--force` 忽略（掩盖问题）
- 一次升级多个依赖（无法归因）
- 用 `curl | sh` 安装依赖（违反安全红线）

## 与 LOOP 的关系
本 skill 通常在 LOOP 之外触发（添加/升级/审计是独立操作）：
- 新功能开发需要新依赖 → brainstorming 阶段触发本 skill → 通过后继续 LOOP
- verify 阶段检查依赖合规 → 作为 verify 的子项

## 与其他 skill 的分工
| Skill | 职责 |
|-------|------|
| dependency-management | 依赖添加/升级/审计的流程把关 |
| brainstorming | 评估是否真的需要新依赖（必要性第一关） |
| verify | 依赖合规检查作为验证子项 |
| migration | 大版本升级（v3→v4）走迁移流程 |
