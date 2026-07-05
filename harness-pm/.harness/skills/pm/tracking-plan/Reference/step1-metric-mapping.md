<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 1: Metric-Derived Tracking Mapping Table and Output

> Source: Derivation mapping table and output schema in SKILL.md "Step 1: Derive Tracking Requirements from the Metric System"

## Derivation Mapping Table

| Metric Type | Required Behavior Data | Tracking Event Example |
|---------|------------|-------------|
| Conversion rate metric | Page/feature exposure + click | page_view + button_click |
| Frequency metric | Behavior occurrence count | feature_use |
| Duration metric | Behavior start + end time | session_start + session_end |
| Quality metric | Behavior result + rating | action_result + feedback |
| Coverage rate metric | Feature used vs. unused comparison | feature_use vs non_use |

## Output

```json
{
  "metrics_to_track": [
    {
      "metric_name": "string",
      "required_behavior": "string",
      "proposed_event": {
        "event_name": "string",
        "trigger": "string",
        "required_properties": ["string"]
      }
    }
  ]
}
```
