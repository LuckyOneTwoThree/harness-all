<!-- Reference material extracted from SKILL.md, consult as needed -->

# Escalation Output Schema

> Source: Escalation output schema in SKILL.md "Escalation Path → Escalation Output"

## Escalation Output

```json
{
  "escalation": {
    "trigger": "string",
    "reason": "string",
    "affected_events": ["string"],
    "ai_recommendation": {},
    "requires_human_action": true,
    "human_decision_needed": [
      "Business logic confirmation",
      "Privacy compliance confirmation",
      "Tracking priority adjustment"
    ]
  }
}
```
