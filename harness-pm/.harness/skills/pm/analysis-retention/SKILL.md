---
name: analysis-retention
description: Use when analyzing user stickiness and churn risk. Retention Auto-Analysis, AI automatically executes full retention curve, Cohort analysis, Aha Moment search, and churn warning. Keywords: retention analysis, Cohort analysis, Aha Moment, churn warning, user stickiness, users not coming back, retention too poor, when users leave.
---
# Retention Auto-Analysis

## When to use
- New user 7-day retention is only 15%, help me analyze
- When do users start churning
- Help me find the Aha Moment

## Outputs
- docs/metrics/data-analysis-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Retention is the ultimate metric of product health**: Acquisition determines the ceiling, retention determines the floor
2. **Aha Moment is the lever of growth**: Finding the "aha moment" and improving reach rate is more efficient than generalized optimization
3. **Warning beats recall**: Intervening before users churn is far less costly and more effective than recalling after churn

## Interaction Mode

🤖 AI Auto-Execution (Data Analysis Type)

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| User Behavior Data | object | Yes | User-provided | All user behavior events |
| Segment Definition | object | ○ | User-provided | User segmentation configuration |
| Cohort Config | object | ○ | User-provided | Cohort partition rules |
| Baseline Date | string | ○ | User-provided | Analysis baseline time |

## Execution Steps

### Step 1: Full Retention Curve [Core]

```
Calculate standard retention curve
├── Define time period (day/week/month)
├── Calculate D+1/D+7/D+30 retention rates
├── Plot retention curve
└── Identify curve shape
```

### Step 2: Retention Curve Shape Judgment [Core]

| Curve Shape | Characteristics | Meaning |
|---------|------|------|
| Smile | Declines initially then recovers | Users continue using after forming habit |
| L-shape | Drops sharply initially then stabilizes | Product only meets one-time need |
| Steep Decline | Rapid continuous decline | Insufficient product stickiness |
| Smooth | Slow steady decline | Healthy stable user base |

### Step 3: Cohort Auto-Analysis [Core]

Analyze retention changes by Cohort (same-period group):

```
Cohort partition
├── Time Cohort: By first use date
├── Channel Cohort: By first source
├── Behavior Cohort: By first behavior type
└── Value Cohort: By first-day value
```

### Step 4: Aha Moment Auto-Search [Core]

```
Identify "aha moment"
├── Analyze early behavior differences between retained vs churned users
├── Calculate correlation coefficient of each behavior with retention
├── Find threshold behaviors (e.g., using a feature X times)
└── Validate hypothesis
```

### Step 5: Churn Warning Model [Core]

```
Churn risk assessment
├── Define churned user (inactive for N consecutive days)
├── Extract behavior features before churn
├── Build churn warning model
└── Output high-risk user list
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Retention analysis and churn causes | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full analysis + retention curve fitting + churn prediction model + retention optimization roadmap | Full artifact + extended analysis + deep inference |

## Output

**Storage Path**: `docs/metrics/data-analysis-report.md ("Retention Analysis" section)`
**Output File**: retention_analysis.json

Output files: retention_curve_{date}.png, cohort_heatmap_{date}.png, aha_moment_{date}.yaml, churn_risk_users_{date}.csv

**Output Schema**:

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

## Cohort Analysis Example

```yaml
# Time Cohort analysis
time_cohort:
  table:
    headers: ["Cohort", "Users", "D1", "D7", "D30"]
    rows:
      - ["2024-01", 50000, 46.2, 29.5, 19.2]
      - ["2023-12", 48000, 45.8, 28.8, 18.5]
      - ["2023-11", 45000, 44.5, 27.5, 17.2]
  
  insight: |
    Cohort D30 retention improved from 17.2% to 19.2%,
    a 11.6% year-over-year increase, mainly attributed to Aha Moment optimization

# Channel Cohort analysis
channel_cohort:
  organic:
    d30: 22.5
    quality: "high"
  paid:
    d30: 15.2
    quality: "medium"
  referral:
    d30: 28.3
    quality: "excellent"
```

## Aha Moment Discovery Logic

```
Step 1: Data Preparation
├── Extract new user behaviors for first N days
├── Mark retained users and churned users
└── Normalize behavior data

Step 2: Feature Analysis
├── Calculate retention lift for each behavior
├── Find optimal threshold (trigger X times for best effect)
├── Correlation analysis
└── Significance testing

Step 3: Validation
├── Group validation (retention comparison with/without behavior)
├── Time window validation (Aha for different periods)
└── User segment validation (whether applicable to all users)
```

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

## Execution Frequency

- **Daily Retention Calculation**: Updated daily at 8:00
- **Cohort Weekly Report**: Generates weekly Cohort report every Monday
- **Aha Moment Review**: Re-analyzed monthly
- **Churn Warning**: Calculated in real-time

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| retention_analysis | object | Yes | Retention analysis root object |
| retention_analysis.overall | object | Yes | Overall retention data |
| retention_analysis.overall.d1 | number | Yes | Day 1 retention rate |
| retention_analysis.overall.d7 | number | Yes | Day 7 retention rate |
| retention_analysis.overall.d30 | number | Yes | Day 30 retention rate |
| retention_analysis.overall.curve_shape | object | Yes | Curve shape analysis |
| retention_analysis.overall.curve_shape.type | string | Yes | Shape type, enum: smile/L/steep_decline/smooth |
| retention_analysis.cohort_trend | object | Yes | Cohort trend analysis |
| retention_analysis.aha_moment_candidates | array | Yes | Aha Moment candidate list, at least 1 |
| retention_analysis.aha_moment_candidates[].rank | number | Yes | Rank |
| retention_analysis.aha_moment_candidates[].behavior | string | Yes | Behavior description |
| retention_analysis.aha_moment_candidates[].retention_lift | object | Yes | Retention lift data |
| retention_analysis.aha_moment_candidates[].correlation | number | Yes | Correlation coefficient |
| retention_analysis.churn_risk | object | Yes | Churn risk analysis |
| retention_analysis.churn_risk.high_risk_count | number | Yes | High-risk user count |
| retention_analysis.churn_risk.high_risk_rate | number | Yes | High-risk user percentage |

## Upstream Change Response

When upstream inputs change, this skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| User behavior data update | Retention curve and Cohort | Recalculate retention curve, update Cohort analysis |
| Segment definition change | Cohort dimensions | Update segment config, re-execute Cohort analysis |
| Churn definition change | Churn warning model | Rebuild churn warning model, update high-risk user list |
| Baseline date change | Retention calculation baseline | Recalculate retention data, update trend judgment |

When retention analysis itself changes, the notification mechanism to downstream:

| Analysis Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| D7 retention decline > 5% | decision-dace | Mark alert, trigger insight conversion |
| Aha Moment candidate change | data-analysis-report | Mark candidate change, trigger report update |
| Churn risk level change | decision-dace | Mark risk change, trigger DACE Analyze |

---

## Decision Rules

| Situation | Handling Method |
|------|----------|
| D7 retention decline > 5% | Trigger churn warning, push alert |
| Retention curve shows steep decline | Mark insufficient product stickiness, recommend Aha optimization |
| Aha Moment reach rate < 20% | Recommend optimizing Onboarding guidance |
| High-risk churn users > 5% | Trigger intervention strategy recommendation |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] Retention calculated based on full users rather than sampling
- [ ] Cohort analysis covers time, channel, and behavior dimensions

### P1 Checks (standard/deep must pass)

- [ ] Aha Moment candidates pass significance testing
- [ ] Churn warning model accuracy > 70%

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| User behavior data missing | User provides retention data → direct analysis | Cannot perform Aha Moment search and Cohort drill-down |
| Segment definition missing | Analyze all users without segment distinction | Cannot perform segment comparison analysis |
| User behavior data + Segment definition both missing | User provides retention data → direct analysis | Output basic retention analysis, Cohort and Aha Moment marked "to be supplemented" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Retention Data**: Retention rate data for each period (D1/D7/D30, etc.)
- **Cohort Data** (optional): Retention rate matrix grouped by time
- **Key Behavior List** (optional): User behaviors that may be related to retention

## Key Metrics

| Metric | Description | Health Standard |
|-----|------|---------|
| Day 1 retention rate | D1 retention | > 40% excellent |
| Day 7 retention rate | D7 retention | > 25% good |
| Day 30 retention rate | D30 retention | > 15% acceptable |
| Retention curve shape | Curve trend | Smile/Smooth |
| Cohort improvement rate | Cohort D30 change | > 0% indicates improvement |
| Churn warning accuracy | Prediction accuracy | > 70% usable |
