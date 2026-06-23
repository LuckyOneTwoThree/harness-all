<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# Step 5: 埋点文档结构 Schema

> 来源：SKILL.md「Step 5: 生成埋点文档」中的文档结构 schema

## 文档结构

```json
{
  "tracking_document": {
    "version": "1.0",
    "generated_date": "2026-05-08",
    "overview": {
      "total_events": 100,
      "new_events": 30,
      "updated_events": 10,
      "existing_events": 60
    },
    "events": [
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
        "status": "pending|approved|implemented",
        "source": "metrics_prd|existing|new"
      }
    ]
  }
}
```
