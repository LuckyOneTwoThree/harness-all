# Retention Analysis - Output Schema and Example

> Extracted from SKILL.md. Output schema and full YAML example for retention analysis.

## Output Schema

```json
{
  "type": "object",
  "required": ["overall"],
  "properties": {
    "overall": {"type": "object", "description": "Overall retention data, including key nodes, curve shape, and historical comparison"},
    "cohort_trend": {"type": "object", "description": "Cohort trend analysis, including monthly cohorts and insights"},
    "aha_moment_candidates": {"type": "array", "description": "Aha Moment candidate list, including behavior, retention lift, and statistical significance"},
    "churn_prediction": {"type": "object", "description": "Churn prediction, including high-risk user list and warning model"},
    "lifecycle_stages": {"type": "array", "description": "Lifecycle stage partition"}
  }
}
```

## Full YAML Example

```yaml
retention_analysis:
  analysis_time: "2024-01-15T10:00:00Z"
  
  # Overall retention
  overall:
    # Key retention nodes
    d1: 45.2  # Day 1 retention 45.2%
    d7: 28.5  # Day 7 retention 28.5%
    d30: 18.3  # Day 30 retention 18.3%
    
    # Curve shape analysis
    curve_shape:
      type: "smooth_decline"
      description: "Slow steady decline, healthy shape"
      d1_to_d7_drop: -37%
      d7_to_d30_drop: -36%
      assessment: "healthy"
    
    # Historical comparison
    vs_last_period:
      d1_change: +2.1
      d7_change: +1.5
      d30_change: +0.8
      trend: "improving"
  
  # Cohort trend
  cohort_trend:
    summary: "Cohort retention has steadily improved over the past 3 months"
    
    monthly_cohorts:
      - cohort: "2023-12"
        d1: 44.5
        d7: 27.2
        d30: 17.1
        
      - cohort: "2023-11"
        d1: 43.8
        d7: 26.8
        d30: 16.9
        
      - cohort: "2023-10"
        d1: 42.1
        d7: 25.5
        d30: 16.2
    
    insight: "Cohort performance improving month over month, new user quality improving"
  
  # Aha Moment candidates
  aha_moment_candidates:
    - rank: 1
      behavior: "Publish UGC content 3 times in first week"
      retention_lift:
        with_behavior: 68.5
        without_behavior: 22.3
        lift: +46.2
      correlation: 0.82
      statistical_significance: 0.001
      recommendation: |
        Design guidance mechanisms to encourage users to publish UGC content in first week
      
    - rank: 2
      behavior: "Add 5 friends on first day"
      retention_lift:
        with_behavior: 72.1
        without_behavior: 31.5
        lift: +40.6
      correlation: 0.78
      statistical_significance: 0.002
      recommendation: |
        Optimize friend recommendation algorithm and add-friend flow
      
    - rank: 3
      behavior: "Participate in 3 community activities in first week"
      retention_lift:
        with_behavior: 65.3
        without_behavior: 25.8
        lift: +39.5
      correlation: 0.75
      statistical_significance: 0.003
      recommendation: |
        Optimize new user activity guidance
  
  # Churn risk
  churn_risk:
    # Risk distribution
    distribution:
      high_risk: 12500  # High-risk user count
      medium_risk: 35000
      low_risk: 85000
      healthy: 180000
    
    high_risk_count: 12500
    high_risk_rate: 4.8
    
    # Pre-churn behaviors
    pre_churn_behaviors:
      - "No app open for 3 consecutive days"
      - "Interaction frequency dropped 50%"
      - "Core feature usage decreased"
      - "Feedback/complaints increased"
    
    recommended_intervention:
      high_risk:
        - action: "Push recall"
          trigger: "No open for 2 consecutive days"
          template: "Recall template v2"
        - action: "Exclusive offer"
          trigger: "High-value user + no open for 3 consecutive days"
          offer: "7-day VIP experience"
        - action: "Customer service callback"
          trigger: "Churn warning + had complaints"
          channel: "Manual phone call"
          
      medium_risk:
        - action: "Personalized recommendation optimization"
          description: "Adjust recommendation algorithm, increase content users are interested in"
        - action: "Feature reminder"
          description: "Push features users may be interested in but haven't used"
  
  # Detailed data links
  reports:
    retention_curve: "docs/metrics/data-analysis-report.md (\"Retention Analysis\" section)"
    cohort_heatmap: "docs/metrics/data-analysis-report.md (\"Retention Analysis\" section)"
    aha_analysis: "docs/metrics/data-analysis-report.md (\"Retention Analysis\" section)"
    churn_users: "docs/metrics/data-analysis-report.md (\"Retention Analysis\" section)"
```
