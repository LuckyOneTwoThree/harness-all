<!-- Reference material extracted from SKILL.md, consult as needed -->

# Insight Type Handling

## Anomaly Insight

```yaml
anomaly_insight:
  type: "anomaly"

  narrative: |
    ## Anomaly Detection Insight

    Today's finding: Registration conversion rate dropped from 35% to 32%.
    Anomaly start time: Today 9:00.
    Affected users: About 15,000.

    Most likely cause: Registration flow change in v2.5.0.
    Confidence: 85%.

    Recommendation: Immediately check the new version implementation, prepare a rollback plan.

  action_options:
    - "Immediately roll back to the previous version"
    - "Release hotfix after emergency fix"
    - "Continue monitoring for 24 hours"

  decision_boundary:
    type: "data_decision"
    auto_execute_eligible: true
    condition: "Conversion rate continues to drop more than 5%"
```

## Funnel Insight

```yaml
funnel_insight:
  type: "funnel_analysis"

  narrative: |
    ## Purchase Conversion Funnel Insight

    Overall funnel conversion rate is 7.2%, down 0.5 percentage points from last week.

    Largest drop-off point: From browsing to add-to-cart, 84% of users are lost.
    Drop-off is mainly concentrated among: price-sensitive users, Android users.

    Recommended optimization directions: Price display strategy, add-to-cart guidance copy.

  action_options:
    - "Optimize price display (show discounts, comparisons)"
    - "Enhance add-to-cart guidance (overlay, prompts)"
    - "Conduct research with users who dropped off"
```
