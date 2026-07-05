<!-- Reference material extracted from SKILL.md, consult as needed -->

# Input Schema

> Source: Metric system and existing tracking inventory JSON schema in SKILL.md "Input" section

## Metric System (from Pipeline 1)

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

## Existing Tracking Inventory (Optional)

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
