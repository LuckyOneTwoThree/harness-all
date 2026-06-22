# 交接文档目录

本目录存放 harness 家族框架之间的交接文档。

## 交接协议

每个交接文档遵循统一格式，让下游框架的 Agent 能快速理解上游产出。

## 文档命名规范

```
<源框架>-to-<目标框架>.md
```

例如：
- `pm-to-solo.md` — harness-pm 交给 harness-solo（产品 → 工程）
- `solo-to-pm.md` — harness-solo 交给 harness-pm（工程 → 产品，反馈）
- `pm-to-design.md` — harness-pm 交给 harness-design（产品 → 设计）
- `pm-to-growth.md` — harness-pm 交给 harness-growth（产品 → 增长）
- `growth-to-pm.md` — harness-growth 交给 harness-pm（增长 → 产品，数据反馈）

## 使用方式

1. 上游框架在完成自己阶段后，按模板生成交接文档放入本目录
2. 下游框架的 session-start skill 会自动检测并读取对应交接文档
3. 也可手动放入（如从其他项目复制 PRD 过来）

## 模板

- `handoff-template.md` — 通用交接模板
- `pm-to-solo-template.md` — harness-pm → harness-solo 专用模板（含 PRD 路径 + AC-xxx + 功能优先级 + 埋点方案）
- `pm-to-design-template.md` — harness-pm → harness-design 专用模板（含 PRD 路径 + AC-xxx + Persona + 风格关键词）
- `pm-to-growth-template.md` — harness-pm → harness-growth 专用模板（含 OKR + 北极星指标 + 增长假设）

复制后按实际情况填写。

## harness-pm 的交接职责

### 产出（pm 交给下游）
- `pm-to-solo.md` — PRD + 设计规范 + 埋点方案 → 交给工程开发
- `pm-to-design.md` — PRD + 定位陈述 → 交给 UI 设计
- `pm-to-growth.md` — 指标体系 + 增长策略 → 交给运营增长

### 消费（下游交给 pm）
- `solo-to-pm.md` — 工程反馈（已实现功能/技术约束/未决问题）
- `growth-to-pm.md` — 增长数据反馈（实验结果/用户反馈）
