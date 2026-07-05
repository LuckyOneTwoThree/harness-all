# Churn Warning Configuration

> Extracted from SKILL.md. Churn warning configuration YAML for retention analysis.

## Churn Warning Configuration

```yaml
# Churn warning configuration
churn_prediction:
  # Churn definition
  churn_definition:
    inactive_days: 7  # Defined as churn after 7 consecutive days of inactivity
  
  # Warning signals
  early_signals:
    - days: 2
      signals:
        - "No app open"
        - "Push not clicked"
        
    - days: 4
      signals:
        - "Core feature usage < 30%"
        - "DAU/MAU decline > 50%"
        
    - days: 6
      signals:
        - "Almost all feature usage dropped to zero"
        - "Obvious churn-intent behaviors"
  
  # Intervention strategies
  interventions:
    high_value:
      push_content: "Personalized recall"
      offer: "Exclusive offer/benefit"
      escalation: "Manual customer service"
      
    medium_value:
      push_content: "Content recommendation"
      offer: "Feature guidance"
      
    low_value:
      push_content: "Generic recall"
```
