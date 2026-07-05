---
name: analysis-retention
description: Use when analyzing user stickiness and churn risk. Retention Auto-Analysis, AI automatically executes full retention curve, Cohort analysis, Aha Moment search, and churn warning.
---
# Retention Auto-Analysis

## When to use
- New user 7-day retention is only 15%, help me analyze
- When do users start churning
- Help me find the Aha Moment
- Keywords: retention analysis, Cohort analysis, Aha Moment, churn warning, user stickiness, users not coming back, retention too poor, when users leave

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

**Output Schema** and full YAML example:

> See [Reference/output-schema-and-example.md](./Reference/output-schema-and-example.md) for the JSON schema and complete retention_analysis YAML example (overall retention, cohort trend, Aha Moment candidates, churn risk, reports).

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

> See [Reference/churn-warning-config.md](./Reference/churn-warning-config.md) for the churn_prediction YAML config (churn definition, early warning signals by day, and intervention strategies by user value tier).

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
