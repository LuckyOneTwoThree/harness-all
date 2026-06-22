# 交接文档目录

本目录存放 harness 家族框架之间的交接文档。

## 交接协议

每个交接文档遵循统一格式，让下游框架的 Agent 能快速理解上游产出。

## 文档命名规范

```
<源框架>-to-<目标框架>.md
```

例如：
- `pm-to-design.md` — harness-pm 交给 harness-design（产品 → 设计）
- `design-to-solo.md` — harness-design 交给 harness-solo（设计 → 工程）

## 使用方式

1. 上游框架在完成自己阶段后，按模板生成交接文档放入本目录
2. 下游框架的 design-brief skill 会自动检测并读取对应交接文档
3. 也可手动放入（如从其他项目复制 PRD 过来）

## 模板

- `handoff-template.md`：通用交接模板
- `design-to-solo-template.md`：harness-design → harness-solo 专用模板（含 AC-xxx/DAC-xxx 章节 + component-map.json 引用）

复制后按实际情况填写。
