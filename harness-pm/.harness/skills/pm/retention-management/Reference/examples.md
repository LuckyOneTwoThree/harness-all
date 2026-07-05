# Retention Management - Examples & Templates

This file collects YAML rule blocks, JSON output examples, and operation calendar templates referenced by `SKILL.md` for the `retention-management` skill.

## Segmentation Rule Engine (YAML)

```yaml
rules:
  - segment: "new_user"
    condition: "account_age_days <= 30 AND is_activated == true"

  - segment: "growing_user"
    condition: "account_age_days > 30 AND account_age_days <= 90 AND weekly_active_days >= 3"

  - segment: "mature_user"
    condition: "account_age_days > 90 AND weekly_active_days >= 2"

  - segment: "at_risk"
    condition: "consecutive_inactive_days >= 7 AND consecutive_inactive_days < 30"

  - segment: "churned"
    condition: "consecutive_inactive_days >= 30"
```

**Segmentation Priority**: Dormant and churned user identification takes priority over normal segmentation, ensuring timely triggering of churn-prevention strategies.

## Strategy Trigger Rules (YAML)

```yaml
trigger_rules:
  new_user:
    - event: "Registration complete"
      action: "Send welcome sequence"
    - event: "Activation complete"
      action: "Send advanced guidance"

  growing_user:
    - event: "Feature usage reaches threshold"
      action: "Recommend advanced features"
    - event: "Usage frequency drops"
      action: "Send value reminder"

  mature_user:
    - event: "Inactive for 3 consecutive days"
      action: "Send update notification"
    - event: "New feature released"
      action: "Send feature recommendation"

  at_risk:
    - event: "Enters dormancy"
      action: "Trigger recall flow"

  churned:
    - event: "Churned for 30 days"
      action: "Trigger recall campaign"
```

## Complete Output Example: retention_management

```json
{
  "churn_prevention": {
    "risk_model": {
      "model_type": "XGBoost",
      "features": ["Usage frequency", "Feature breadth", "Payment status"],
      "accuracy": 0.85,
      "precision": 0.78,
      "recall": 0.72
    },
    "risk_thresholds": {
      "high_risk": 0.7,
      "medium_risk": 0.4,
      "low_risk": 0.2
    },
    "high_risk_users": [
      {
        "user_id": "User ID",
        "risk_score": 0.85,
        "risk_level": "high",
        "primary_churn_signals": ["Signal 1", "Signal 2"],
        "recommended_intervention": "Intervention strategy"
      }
    ],
    "interventions": [
      {
        "intervention_id": "INT_001",
        "trigger_condition": "Risk score > 0.7",
        "intervention_type": "personalized_outreach",
        "channel": "email",
        "content_theme": "Value recall",
        "expected_effectiveness": 0.25
      }
    ],
    "tracking": {
      "total_interventions_sent": 5000,
      "response_rate": 0.15,
      "churn_prevention_rate": 0.12,
      "roi": 3.5
    }
  },
  "segments": [
    {
      "name": "New user",
      "segment_id": "new_user",
      "count": 5000,
      "percentage": 0.15,
      "characteristics": {
        "avg_age_days": 7,
        "avg_weekly_active_days": 3.5,
        "avg_features_used": 5,
        "paying_users_ratio": 0.08
      },
      "health_score": 0.72
    }
  ],
  "segment_overview": {
    "new_user": {"count": 5000, "avg_health": 0.72},
    "growing_user": {"count": 8000, "avg_health": 0.78},
    "mature_user": {"count": 15000, "avg_health": 0.85},
    "at_risk": {"count": 3000, "avg_health": 0.35},
    "churned": {"count": 2000, "avg_health": 0.1}
  },
  "strategies": [
    {
      "segment": "new_user",
      "objective": "Drive activation and early retention",
      "key_actions": ["Guide core feature usage", "Build usage habits"],
      "success_metrics": ["D30 retention rate", "Activation rate"]
    }
  ],
  "personalized_content": [
    {
      "segment": "new_user",
      "content_type": "onboarding_guidance",
      "theme": "Quickly experience core value",
      "channels": ["app_push", "email"],
      "frequency": "per_week"
    }
  ]
}
```

## Automated Operation Calendar

```
Weekly fixed outreach:
- Monday: Active user weekly report
- Wednesday: Feature usage reminder (new users)
- Friday: Content push to active users

Event-triggered outreach:
- On feature update: Notify all users
- On holiday events: Exclusive for high-value users
- On user milestones: Congratulate + incentivize
```
