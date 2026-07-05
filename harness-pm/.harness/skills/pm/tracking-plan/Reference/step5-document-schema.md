<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 5: Tracking Document Structure Schema

> Source: Document structure schema in SKILL.md "Step 5: Generate Tracking Document"

## Document Structure

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
