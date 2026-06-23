<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 输入 Schema

> 来源：SKILL.md「输入」章节中的指标体系与现有埋点清单 JSON schema

## 指标体系（来自Pipeline 1）

```json
{
  "north_star": {
    "name": "string",
    "calculation": "string"
  },
  "l1_metrics": [...],
  "l2_metrics": [...],
  "actionable_metrics": [...]
}
```

---

## 现有埋点清单（可选）

```json
[
  {
    "event_name": "string",
    "trigger": "string",
    "properties": [
      {
        "name": "string",
        "type": "string"
      }
    ],
    "last_modified": "2026-01-01"
  }
]
```
