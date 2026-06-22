---
name: migration
description: 代码迁移，框架升级/API迁移/数据迁移，守护不回归
triggers:
  - 框架/库大版本升级时
  - API 迁移时
  - 数据迁移时
  - 移除弃用代码时
reads:
  - loops/LOOP.md
  - rules/security.md
  - constitution.md
  - docs/engineering/TECH_STACK.md
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/evidence.md
  - loops/specs/<feature>/iterations.log
---

# Migration — 代码迁移

## 铁律
**先建替代品，再弃用旧系统。** 不要在没有替代品时 deprecate——用户（包括未来的你）会陷入既不能用旧的、又没有新的的困境。

## 循环类型
本 skill 对应 LOOP.md 的 **refactor** 循环：最大 3 次迭代，停止条件是测试无回归。

## 迁移决策（硬门）

启动迁移前，回答以下问题，任何一条不满足 → 不迁移：

- [ ] **旧系统还有独特价值吗？** 如果有，不能移除
- [ ] **多少消费者依赖？** 用 Grep 搜索旧 API 的调用点，列清单
- [ ] **替代品存在吗？** 不存在 → 先建替代品（走 new-feature workflow）
- [ ] **迁移成本 vs 维护成本？** 迁移成本 > 2-3 年维护成本 → 不值得
- [ ] **测试覆盖够吗？** 旧系统有测试守护吗？没有 → 先补测试（走 test-coverage skill）

**Hyrum's Law 警告**：足够多用户后，每个可观察行为（包括 bug、时序怪癖）都会被依赖。迁移比想象难。

## 流程

### 1. 建立替代品
- 替代品必须覆盖旧系统的所有关键用例
- 写迁移指南（`docs/migration-guide-<feature>.md`）
- 替代品必须有测试（走 tdd skill）

### 2. 选择迁移策略

| 策略 | 适用场景 | 风险 |
|------|---------|------|
| **Strangler Pattern** | 逐步替换，新旧并行 | 低，可随时回退 |
| **Adapter Pattern** | 旧接口委托新实现 | 低，接口兼容 |
| **Feature Flag** | 按用户灰度切换 | 中，需 flag 管理 |
| **Big Bang** | 一次性切换 | 高，不推荐 |

**默认用 Strangler Pattern**，除非替代品与旧系统接口完全兼容可用 Adapter。

### 3. 增量迁移
- **一次只迁移一个消费者**（用 Grep 找到调用点，逐个改）
- 每迁移一个：
  1. 改调用点指向新系统
  2. 跑全量测试，确认行为匹配
  3. 追加到 iterations.log：`[时间] iter=<N> migrated <消费者> ✓`
- 不许批量改多个消费者再测（错误累积，无法归因）

### 4. 验证零活跃用量
移除旧代码前，**必须**证明没有活跃消费者：
- 用 Grep 搜索旧 API 的调用点 → 应为 0
- 检查配置文件、环境变量是否还引用旧系统
- 如有 metrics/logs，确认零活跃流量

**没有零活跃用量证据，不许删旧代码。**

### 5. 移除旧系统
- 删除旧代码 + 旧测试 + 旧文档 + 旧配置
- 跑全量测试，确认无回归
- 更新 `docs/engineering/TECH_STACK.md`
- 如有 ADR，写新 ADR 记录迁移决策（supersede 旧的）

## 数据迁移专项

数据迁移（DB schema / 数据格式）额外要求：
- **必须生成迁移脚本**（constitution.md 要求）
- 迁移脚本必须有回滚脚本
- 先在备份数据上测试
- 大数据量分批迁移，每批验证

## 反合理化表

| 借口 | 反驳 |
|------|------|
| "It still works, why remove it?" | 无人维护的代码累积安全债 |
| "Someone might need it later" | 真需要时可以重建，"以防万一"留代码比重建更贵 |
| "Users will migrate on their own" | 他们不会，必须提供工具/文档 |
| "一次性改完更快" | Big Bang 风险高，增量迁移可回退 |
| "旧代码先留着不删" | 留着 = 继续维护成本 + 混淆 |

## 状态维护

按 LOOP.md 的 "state.yaml Schema" 更新：
- `stage`: `act`（迁移中）/ `verify`（验证零用量）
- `iteration`: +1（每迁移一个消费者）
- `last_error`: 失败时填"<消费者>迁移失败：<原因>"

**更新 iterations.log（追加，禁止覆盖）**：
```
[YYYY-MM-DD HH:MM] iter=<N> stage=act → migrated <消费者> ✓
[YYYY-MM-DD HH:MM] iter=<N> stage=verify → zero active usage confirmed
```

## 禁止事项
- 没有替代品就 deprecate 旧系统
- 没有零活跃用量证据就删旧代码
- Big Bang 式迁移（除非接口完全兼容且测试覆盖充分）
- 迁移不带测试守护（Beyonce Rule：没测试的代码迁移出问题不是迁移的错）
- 数据迁移无回滚脚本
- 新功能加到已弃用的旧系统上

## 与 LOOP 的关系
本 skill 对应 LOOP 的 refactor 循环：
- 建替代品 = PLAN（规划新系统）
- 增量迁移 = ACT（逐个改消费者）
- 验证零用量 + 测试无回归 = VERIFY
- 移除旧代码 = DONE

## 与其他 skill 的分工
| Skill | 职责 |
|-------|------|
| migration | 迁移决策 + 增量迁移流程 |
| tdd | 替代品的红绿重构 |
| test-coverage | 迁移前补测试守护（Beyonce Rule） |
| verify | 迁移后的无回归验证 |
| writing-documentation | 迁移指南 + ADR |
| dependency-management | 依赖升级（小版本走本 skill，大版本走 migration） |
