# Usage Example

This file is referenced by `SKILL.md` for the `validation-experiment` skill.

## Inputs

```json
{
  "assumption_map": [
    {"id": "A001", "assumption": "Users believe recommended content matches their interests", "risk_score": 20}
  ],
  "traffic_data": {
    "daily_active_users": 10000,
    "new_users_daily": 500
  }
}
```

## AI Analysis

```
Traffic assessment: DAU 10000 > 5000, can do A/B testing
Hypothesis type: Value hypothesis + Usability hypothesis
Recommended method: A/B testing

Experiment design:
- Split: 50/50
- Primary metric: Recommended content click-through rate
- Sample size: About 10000 (based on MDE=10%)
- Duration: 14 days
```

## Output

```json
{
  "validation_experiment": {
    "method": "A_B_TEST",
    "target_assumption": {
      "id": "A001",
      "assumption": "Users believe recommended content matches their interests"
    },
    "experiment_design": {
      "type": "A_B_TEST",
      "primary_metric": "Recommended content click-through rate",
      "sample_size": 10000,
      "duration_days": 14
    }
  }
}
```
