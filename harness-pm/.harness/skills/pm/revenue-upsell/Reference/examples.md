# Output Examples

## Complete upsell_automation Example

```json
{
  "upgrade_signals": [
    {
      "user_id": "EDU-20240389",
      "current_plan": "free",
      "upgrade_signals": [
        {
          "signal_type": "usage_limit",
          "description": "Usage reaches 80% of free version limit",
          "strength": "strong"
        },
        {
          "signal_type": "feature_access",
          "description": "Frequently accesses premium features",
          "strength": "medium"
        }
      ],
      "overall_score": 0.8,
      "recommended_plan": "pro",
      "expected_revenue_increase": 99
    }
  ],
  "personalized_offers": [
    {
      "offer_id": "OFFER_001",
      "target_segment": "free_user_usage_limit",
      "offer_type": "upgrade_cta",
      "headline": "You have used 80% of free version capacity",
      "value_proposition": "Upgrade to Pro, unlock unlimited usage",
      "incentive": "20% off first year",
      "cta_text": "Upgrade Now",
      "personalization_elements": ["User usage", "Limit scenario", "Upgrade benefits"]
    }
  ],
  "ab_tests": [
    {
      "test_id": "UPSELL_TEST_001",
      "test_name": "Upgrade popup timing optimization",
      "hypothesis": "Showing the upgrade popup at 70% usage is more effective than at 90%",
      "target_segment": "Free version users",
      "variants": {
        "control": "Trigger at 90%",
        "treatment_a": "Trigger at 70%",
        "treatment_b": "Trigger at 80%"
      },
      "primary_metric": "Upgrade conversion rate",
      "expected_lift": "15%"
    }
  ],
  "tracking": {
    "total_upgrade_opportunities": 5000,
    "upgrade_messages_sent": 3000,
    "upgrade_conversion_rate": 0.08,
    "revenue_impact": 150000,
    "roi": 4.5
  }
}
```
