# decision-culture Examples

> This document is split from the decision-culture SKILL.md and contains all YAML report examples, decision record templates, automation config, and culture metrics.

## Decision Record Template

```yaml
decision_record:
  decision_id: "DEC-2024-001"
  decision_date: "2024-01-15"
  decision_maker: "Product Manager"
  decision_context: "Whether to fully release the simplified registration flow"
  data_sources: ["Experiment results", "Feature data", "User feedback"]
  key_insights: ["Experimental group conversion rate improved 8.2%", "Positive user feedback", "No significant negative impact"]
  decision: "Full release"
  rationale: "Experiment results statistically significant, positive user feedback, controllable risk"
  expected_outcome: "Overall conversion rate improvement 7-9%"
  follow_up_date: "2024-01-22"
```

## Daily Summary Example

```yaml
daily_summary:
  generated_at: "2024-01-15T20:00:00Z"
  date: "2024-01-15"
  
  # Status
  status: "no_alerts"  # no_alerts / alerts_handled / critical
  
  # Key metrics
  key_metrics:
    dau:
      value: 10850000
      vs_yesterday: +0.8%
      vs_last_week: +2.1%
      status: "healthy"
      
    revenue:
      value: 1580000
      vs_yesterday: -1.2%
      vs_last_week: +5.3%
      status: "healthy"
      
    conversion_rate:
      value: 0.352
      vs_yesterday: +0.5%
      status: "healthy"
  
  # Experiment status
  experiments:
    running: 3
    summary:
      - id: "exp_001"
        name: "Simplified Registration Flow"
        day: 7
        current_lift: "+8.5%"
        status: "on_track"
        
      - id: "exp_002"
        name: "New Homepage"
        day: 4
        current_lift: "+2.1%"
        status: "monitoring"
        
      - id: "exp_003"
        name: "New Pricing Strategy"
        day: 2
        current_lift: "+0.3%"
        status: "early_monitoring"
  
  # Alert records (if any)
  alerts:
    count: 0
    details: []
  
  # Today's highlights
  highlights:
    - "All core metrics normal, no alerts"
    - "Simplified registration experiment progressing well, expected to complete early"
    - "No major product changes today"
    
  # Tomorrow's preview
  tomorrow:
    - "exp_001 expected to reach statistical significance"
    - "Planned release of v2.5.1 minor version"
```

## Weekly Feature Review Example

```yaml
weekly_feature_review:
  week: "2024-W03"
  review_date: "2024-01-15"
  
  features_reviewed:
    - feature: "Simplified Registration Flow"
      release_date: "2024-01-08"
      status: "released"
      
      metrics:
        registration_rate:
          before: 0.352
          after: 0.381
          lift: +8.2%
        user_feedback: "positive"
        
      verdict: "Feature successful, maintain current state"
      
    - feature: "Homepage Recommendation Optimization"
      release_date: "2024-01-10"
      status: "monitoring"
      
      metrics:
        click_rate:
          before: 0.12
          after: 0.128
          lift: +6.7%
          
      verdict: "Metrics positive, continue monitoring for 2 weeks"
```

## Weekly Experiment Summary Example

```yaml
weekly_experiment_summary:
  week: "2024-W03"
  
  experiments_summary:
    completed_this_week: 2
    positive: 1
    negative: 0
    inconclusive: 1
    
    details:
      - id: "exp_reg_001"
        name: "Simplified Registration Experiment"
        result: "positive"
        lift: "+8.2%"
        decision: "Full release"
        
      - id: "exp_pricing_001"
        name: "New Pricing Experiment"
        result: "inconclusive"
        lift: "+2.1%"
        decision: "Continue experiment"
        
  learnings:
    - "Simplifying operation steps has a significant positive impact on conversion"
    - "Pricing changes require longer validation"
    
  recommendations:
    - "Continue simplifying core product flows"
    - "Extend pricing experiments to 3-4 weeks"
```

## Weekly Report Example

```yaml
weekly_report:
  week: "2024-W03"
  period: "2024-01-08 to 2024-01-14"
  generated_at: "2024-01-14T18:00:00Z"
  
  # Executive summary
  executive_summary: |
    Overall performance this week was good.
    - DAU grew 2.1% vs. last week, reaching 10.85 million
    - Registration conversion rate improved 8.2% (experimental group)
    - Completed 2 experiments, 1 positive, 1 inconclusive
    
  # OKR progress
  okr_progress:
    obj_1_dau:
      target: 12000000
      current: 10850000
      progress: 35%
      on_track: true
      
    obj_2_revenue:
      target: 50000000  # Monthly
      current: 15500000  # Month-to-date
      progress: 31%
      on_track: true
  
  # Core metrics weekly
  metrics_weekly:
    dau:
      this_week_avg: 10820000
      last_week_avg: 10590000
      change: +2.2%
      
    d7_retention:
      this_week: 0.285
      last_week: 0.278
      change: +0.7pp
      
    revenue_daily:
      this_week_avg: 1560000
      last_week_avg: 1480000
      change: +5.4%
  
  # Experiment summary
  experiments:
    total: 5
    running: 3
    completed: 2
    positive_rate: 0.5
    
  # Insights and actions
  insights:
    - "Simplified registration flow effect is significant, recommend extending to other registration scenarios"
    - "iOS user conversion outperforms Android, needs targeted optimization"
    
  actions_for_next_week:
    - "Full release of simplified registration flow"
    - "Launch Android registration flow optimization experiment"
    - "New homepage feature grayscale testing"
```

## Monthly OKR Review Example

```yaml
monthly_okr_review:
  month: "2024-01"
  review_date: "2024-01-31"
  
  # OKR status
  objectives:
    - id: "obj_1"
      text: "Improve user engagement"
      progress: 72%
      status: "on_track"
      
      key_results:
        - kr: "DAU reaches 12 million"
          progress: 35%
          assessment: "Needs acceleration"
          
        - kr: "D7 retention reaches 30%"
          progress: 70%
          assessment: "Good progress"
          
    - id: "obj_2"
      text: "Improve commercial revenue"
      progress: 65%
      status: "on_track"
      
      key_results:
        - kr: "Monthly revenue reaches 50 million"
          progress: 31%
          assessment: "Half time passed, 31% completed, needs attention"
  
  # Deviation analysis
  deviation_analysis:
    - kr: "DAU target"
      gap: 1150000
      reasons:
        - "New user acquisition below expectations"
        - "Existing user churn rate slightly high"
      recommendations:
        - "Increase channel investment"
        - "Improve existing user re-engagement"
```

## Monthly Report Example

```yaml
monthly_report:
  month: "2024-01"
  generated_at: "2024-01-31T18:00:00Z"
  
  executive_summary: |
    January overall performance met expectations.
    DAU grew 2.1%, registration conversion improved 8.2%.
    Key feature simplified registration flow has been fully released.
    
  # Core metrics
  core_metrics:
    dau:
      monthly_avg: 10750000
      monthly_peak: 11200000
      trend: "up"
      
    retention:
      d1: 0.452
      d7: 0.285
      d30: 0.183
      trend: "improving"
      
    revenue:
      monthly_total: 46800000
      arpu: 4.35
      trend: "stable"
  
  # Experiment summary
  experiments:
    total_this_month: 8
    positive: 4
    negative: 2
    inconclusive: 2
    
    key_findings:
      - "Flow simplification has a broadly positive impact on conversion"
      - "Personalized recommendations have significant effects"
      - "Pricing strategy requires longer validation"
  
  # Data culture building
  data_culture:
    decisions_made: 15
    data_driven: 12
    data_driven_rate: 0.80
    
    report_engagement:
      daily_summary_open_rate: 0.95
      weekly_report_read_rate: 0.85
```

## Quarterly Metrics Review Example

```yaml
quarterly_metrics_review:
  quarter: "2024_Q1"
  
  # Metric effectiveness
  metric_effectiveness:
    high_value:
      - name: "Registration conversion rate"
        reason: "Directly reflects product usability"
        
      - name: "D7 retention"
        reason: "Core health metric"
        
    low_value:
      - name: "Feature usage rate"
        reason: "Vague definition, needs redefinition"
        
  # Adjustment recommendations
  recommended_changes:
    - action: "Add metric: Core action completion rate"
      rationale: "Better measure of user value"
      
    - action: "Adjust weight: Increase D7 retention weight"
      rationale: "Greater focus on user stickiness"
```

## Automated Report Configuration

```yaml
automation_config:
  # Daily report
  daily:
    enabled: true
    time: "20:00"
    channels: ["slack", "email"]
    skip_if_no_alerts: true
    
  # Weekly report
  weekly:
    enabled: true
    day: "Friday"
    time: "18:00"
    channels: ["slack", "email", "wiki"]
    
  # Monthly report
  monthly:
    enabled: true
    day: "last_day"
    time: "18:00"
    channels: ["email", "presentation"]
    include_okr_review: true
    
  # Quarterly report
  quarterly:
    enabled: true
    channels: ["presentation", "meeting"]
    human_dominated: true
```

## Team Data Culture Metrics

```yaml
data_culture_metrics:
  # Decision quality
  decision_quality:
    data_driven_decisions: 45
    total_decisions: 52
    rate: 0.87
    
  # Report usage
  report_usage:
    daily_summary_open: 0.95
    weekly_report_read: 0.88
    monthly_report_engagement: 0.75
    
  # Experimentation culture
  experimentation:
    experiments_per_month: 8
    experiment_decision_rate: 0.92
    fast_iteration_speed: "2 weeks avg"
    
  # Data literacy
  data_literacy:
    self_service_usage: 0.70
    sql_query_growth: "+20%"
```
