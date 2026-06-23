<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 输出总 Schema 与 tracking_plan Schema

> 来源：SKILL.md「输出」章节中的输出 Schema 与 tracking_plan schema

## 输出 Schema

```json
{
  "type": "object",
  "required": ["tracking_plan", "quality_check"],
  "properties": {
    "tracking_plan": {"type": "array", "description": "埋点事件列表，包含事件定义、属性、触发条件等"},
    "quality_check": {"type": "object", "description": "质量检查结果，包含命名合规性、属性完整性、路径覆盖率等"}
  }
}
```

## tracking_plan

```json
{
  "tracking_plan": [
    {
      "event_name": "string",
      "display_name": "string",
      "trigger": {
        "description": "string",
        "timing": "on_action|immediate|on_exit",
        "conditions": ["string"]
      },
      "properties": [
        {
          "name": "string",
          "type": "string|string[]|number|boolean",
          "required": true,
          "description": "string",
          "example": "string"
        }
      ],
      "analysis_purpose": "string",
      "linked_metric": "string",
      "priority": "high|medium|low",
      "status": "pending|approved|implemented"
    }
  ],
  "quality_check": {
    "naming_compliance": true,
    "property_completeness": 0.95,
    "core_path_coverage": 0.92,
    "anomaly_coverage": true,
    "redundancy_detected": [],
    "prd_consistency": {
      "forward_coverage": 0.92,
      "backward_coverage": 0.88,
      "consistency_score": 0.90,
      "status": "pass"
    }
  }
}
```
