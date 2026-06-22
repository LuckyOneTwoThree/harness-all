---
name: verify
description: 交付验证，声称完成前的强制综合检查
triggers:
  - 声称任务完成前（强制）
  - LOOP 的 VERIFY 阶段
  - 合并/推送前
reads:
  - loops/LOOP.md
  - rules/security.md
  - constitution.md
  - docs/handoff/pm-to-solo.md
  - docs/handoff/design-to-solo.md
  - docs/handoff/component-map.json
  - loops/specs/<feature>/spec.md
writes:
  - loops/specs/<feature>/evidence.md
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/iterations.log
---

# Verify — 交付验证

## 铁律
**没有证据不声称完成。** "应该过了"不算证据，必须展示实际输出。

## 流程

### 1. 测试通过检查
运行项目测试命令，**展示完整输出**（不是"测试通过"四个字）：
```bash
<项目的测试命令>
```
- 全部通过 → 继续
- 有失败 → 写入 state.yaml 的 last_error，回到 tdd

### 2. 验收标准逐条对照
读 spec.md 的 AC-xxx 和 DAC-xxx，逐条检查（两源）：

**工程 AC**（来自 spec.md 的 AC-xxx）：
```
## 验收标准 - 工程 AC
- AC-001: ✓ <如何满足，引用测试或演示>
- AC-002: ✓ <如何满足>
- AC-003: ✗ <未满足，原因>
```

**设计 AC**（来自 spec.md 的 DAC-xxx，由 design-to-solo.md 流入）：
```
## 验收标准 - 设计 AC
- DAC-001: ✓ <如何满足，如"对比度 4.8:1 ≥ 4.5:1，用 axe-core 验证">
- DAC-002: ✓ <如何满足，如"375px 视口测试无溢出，截图见 evidence">
- DAC-003: ✗ <未满足，原因>
```

**设计 AC 检查方式**：
- 视觉类（对比度/间距/字号）→ 用设计 token 值对照，或用浏览器 DevTools 检查
- 响应式类（断点/溢出）→ 用 webapp-testing 的响应式测试
- 交互类（hover/focus/动画）→ 手动演示或 E2E 测试
- 如设计 AC 无法在工程层验证（如纯视觉感受），标注"需 harness-design 复核"

- 全部 ✓ → 继续
- 有 ✗ → 回到 tdd 补实现（工程 AC）或反馈给 harness-design（设计 AC 不合理时）

### 3. 宪法合规检查
读 constitution.md，逐条检查：
- [ ] 是否引入未审批的新依赖？（详见 `dependency-management` skill 的审批流程）
- [ ] 新增 API 是否有测试？
- [ ] schema 变更是否有迁移脚本？（详见 `migration` skill）
- [ ] 其他项目特定条款

### 4. 安全扫描（强制，跨平台）

**方式 A（推荐，Agent 用工具完成，不依赖 bash）**：

按 `rules/security.md` 的检查清单，Agent 用工具扫描本次变更的文件：

- **密钥泄露**：用 Grep 搜索变更文件中的敏感模式：
  ```
  (sk-|api[_-]?key|secret|password|token|AKIA|ghp_)[=:]\s*['"]?[A-Za-z0-9+/=_-]{16,}
  ```
  命中 → 标记为泄露，必须修复后重新验证

- **硬编码凭证**：用 Grep 搜索 IP/数据库连接串/私钥头：
  ```
  BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|mongodb://|postgres://|redis://.*:.*@
  ```

- **危险命令**：用 Grep 搜索 `rm -rf|curl.*\|.*sh|wget.*\|.*sh`

- **.gitignore 检查**：用 Read 读 .gitignore，确认 .env / node_modules / dist 等已忽略

**方式 B（可选脚本兜底）**：
如果当前环境 bash 可用，可执行：
```bash
bash .harness/scripts/security-check.sh
```
脚本逻辑与方式 A 一致，作为可选兜底。**Windows 或无 bash 环境下，必须用方式 A。**

**展示完整输出**，不能只写"安全检查通过"。
- 通过 → 继续
- 未通过 → 修复后重新验证

### 5. 熵检查（可选，跨平台）

**方式 A（推荐，Agent 用工具完成）**：

读取 `.harness/memory/baseline.json`（上次 session-end 写入），与当前指标对比：

- **files 增长率**：用 Glob 统计当前源文件数，对比 baseline.files
  - 增长 > 20% 且绝对值 > 50 → WARN（可能文件爆炸）
- **loc 增长率**：用 Read 累加当前代码行数，对比 baseline.loc
  - 增长 > 50% → WARN（可能过度实现）
- **deps 增长**：读依赖清单，对比 baseline.deps
  - 新增 > 3 个 → WARN（可能依赖膨胀）
- **todos 积压**：用 Grep 搜索 TODO/FIXME
  - 数量 > 20 或较 baseline 增长 > 50% → WARN（技术债积累）

**方式 B（可选脚本兜底）**：
如果当前环境 bash 可用，可执行：
```bash
bash .harness/scripts/entropy-check.sh
```

如果有 WARN，评估是否需要先重构再交付。

### 6. 前端验证（如涉及前端代码）
用 Glob 扫描本次变更的文件，如包含 `*.tsx` / `*.vue` / `*.svelte` / `*.html` / `*.css`，调用 `webapp-testing` skill 做前端专项验证：
- 构建验证（强制）
- 类型检查（如有 TypeScript）
- Lint 检查（如有）
- 结构验证（组件/可访问性/路由）
- 前端安全（XSS / 硬编码地址）

结果合并到 evidence.md 的"前端验证"章节。如无前端代码变更，跳过本步骤。

### 7. 写入证据
将以上 6 项的实际输出汇总写入 evidence.md：
```markdown
# 验证证据

## 时间
YYYY-MM-DD HH:MM

## 1. 测试结果
$ <命令>
<实际输出>

## 2. 验收标准
### 工程 AC
- AC-001: ✓ ...
- AC-002: ✓ ...

### 设计 AC（如涉及前端）
- DAC-001: ✓ ...
- DAC-002: ✓ ...
（如无 design-to-solo.md，填"无设计 AC"）

## 3. 宪法合规
- [x] 零新依赖
- [x] API 有测试
- [x] 迁移脚本

## 4. 安全扫描
方式：Agent Grep 扫描 / 可选 bash security-check.sh
<实际输出，列出扫描的模式和命中情况>

## 5. 熵检查
方式：Agent Glob+Read 统计 / 可选 bash entropy-check.sh
<实际输出或"跳过">

## 6. 前端验证（如涉及）
方式：调用 webapp-testing skill
<实际输出或"无前端代码变更，跳过">
```

### 8. 更新状态
按 `loops/LOOP.md` 的 "state.yaml Schema" 更新：
- `stage`: `verify`
- `status`: `done`（全部通过）或 `retrying`（有失败）
- `last_error`: 成功清空为 ""，失败填错误描述

字段完整定义和写入责任见 LOOP.md。

**更新 iterations.log（必须追加，禁止覆盖）**：
- 工具方式：先 Read 当前 iterations.log → 拼接新行 → Write 回去
- 或终端命令：`echo "[YYYY-MM-DD HH:MM] iter=<N> stage=verify → PASSED" >> .harness/loops/specs/<feature>/iterations.log`
- 禁止用 Write 直接覆盖 iterations.log（会抹掉历史迭代记录）

```
[YYYY-MM-DD HH:MM] iter=<N> stage=verify → PASSED
```

## 禁止事项
- 跳过任何一项检查
- 只写"通过"不展示实际输出（违反铁律）
- 测试失败还声称完成
- 安全扫描没跑就说"没问题"
- 涉及前端代码但跳过前端验证（步骤 6）

## 与 LOOP 的关系
本 skill 对应 LOOP 的 VERIFY 阶段。
- tdd（ACT）→ verify（VERIFY）→ 通过 → 可进入 code-review
- tdd（ACT）→ verify（VERIFY）→ 失败 → systematic-debugging → 回到 tdd

## 与其他 skill 的分工
| Skill | 职责 | 时机 |
|-------|------|------|
| tdd | 写测试、跑测试 | ACT 阶段 |
| verify | 综合验证（测试+AC+宪法+安全+熵） | VERIFY 阶段 |
| code-review | 代码质量审查 | LOOP 之后 |
