# Output Schema and Validation Rules

This file is referenced by `SKILL.md` for the `revenue-upsell` skill.

## Output Schema

```json
{
  "type": "object",
  "required": ["upgrade_signals", "personalized_offers"],
  "properties": {
    "upgrade_signals": {"type": "array", "description": "Upgrade signal user list, including signal type, score, and recommended plan"},
    "personalized_offers": {"type": "array", "description": "Personalized upgrade offer list, including value proposition and incentive"},
    "ab_tests": {"type": "array", "description": "A/B test design plan list"},
    "tracking": {"type": "object", "description": "Upgrade effectiveness tracking, including conversion rate, revenue impact, and ROI"}
  }
}
```


## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| upgrade_signals | array | Yes | Upgrade signal user list, at least 1 user |
| upgrade_signals[].user_id | string | No | User ID |
| upgrade_signals[].current_plan | string | No | Current plan |
| upgrade_signals[].overall_score | number | Yes | Upgrade score, range 0-1 |
| upgrade_signals[].signal_type | string | No | Signal type, enum: usage/feature/behavior/intent |
| upgrade_signals[].strength | string | No | Signal strength, enum: strong/medium/weak |
| upgrade_signals[].description | string | No | Signal description |
| upgrade_signals[].recommended_plan | string | Yes | Recommended plan, cannot be empty |
| personalized_offers | array | Yes | Personalized offer list, at least 1 |
| personalized_offers[].offer_type | string | No | Offer type, enum: upgrade/addon/trial_discount |
| personalized_offers[].headline | string | No | Offer headline |
| personalized_offers[].value_proposition | string | Yes | Value proposition, cannot be empty |
| personalized_offers[].incentive | string | No | Incentive content |
| personalized_offers[].cta_text | string | No | Call-to-action copy |
| ab_tests | array | No | A/B test list, each item must include test_id/hypothesis |
| ab_tests[].test_id | string | Yes | Test ID |
| ab_tests[].test_name | string | No | Test name |
| ab_tests[].hypothesis | string | Yes | Test hypothesis |
| ab_tests[].variants | array | No | Variant list |
| ab_tests[].primary_metric | string | No | Primary metric |
| tracking | object | No | Effectiveness tracking, must include upgrade_conversion_rate/roi |
| tracking.upgrade_conversion_rate | number | No | Upgrade conversion rate |
| tracking.roi | number | No | Upgrade ROI |

