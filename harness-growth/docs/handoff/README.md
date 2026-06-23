# 交接文档目录

本目录存放 harness 家族框架之间的交接文档。

## 交接协议

每个交接文档遵循统一格式，让下游框架的 Agent 能快速理解上游产出。

## 文档命名规范

```
<源框架>-to-<目标框架>.md
```

例如：
- `solo-to-growth.md` — harness-solo 交给 harness-growth（工程 → 增长）
- `growth-to-pm.md` — harness-growth 交给 harness-pm（增长 → 产品，反馈增长数据）
- `pm-to-growth.md` — harness-pm 交给 harness-growth（产品 → 增长，传递产品策略）

## 本框架的交接文档

### 消费（上游 → 本框架）
- `solo-to-growth.md` — 来自 harness-solo，包含新功能上线信息、可埋点事件、API 端点等
- `pm-to-growth.md` — 来自 harness-pm，包含产品策略、目标用户、增长目标等

### 产出（本框架 → 下游）
- `growth-to-pm.md` — 反馈给 harness-pm，包含实验结论、增长数据、用户洞察等，帮助产品决策

## 使用方式

1. 上游框架在完成自己阶段后，按模板生成交接文档放入本目录
2. 下游框架的 session-start skill 会自动检测并读取对应交接文档
3. 也可手动放入（如从其他项目复制策略文档过来）

## 模板

| 模板 | 用途 |
|------|------|
| `handoff-template.md` | 通用交接模板 |
| `growth-to-pm-template.md` | 增长反馈给产品的专用模板 |

> 入站模板（pm-to-growth / solo-to-growth）由源框架提供，不在本框架存放。
