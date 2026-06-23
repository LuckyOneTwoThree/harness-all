---
name: retention-management
description: Use when reducing churn rate or improving user engagement. Retention Management Integrated Pipeline first builds a churn prediction model to identify high-risk users and automatically trigger interventions, then segments users by lifecycle stage to generate operation strategies and personalized outreach content. Keywords: churn prediction, churn intervention, churn model, user retention, user segmentation, tiered operations, lifecycle operations, personalized outreach, engagement improvement, user activity, high churn rate, how to retain, differentiated operations, operation segmentation.
metadata:
  module: "Product Growth & Operations"
  sub-module: "Retention"
  type: "pipeline"
  version: "3.0"
  domain_tags: ["Internet", "SaaS", "General"]
  trigger_examples:
    - "Users keep churning, what should I do"
    - "How to spot users about to leave early"
    - "Churn rate is too high, how to reduce it"
    - "How to run differentiated operations for different users"
    - "How to improve user engagement"
    - "How to do user segmentation"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Execute churn prediction and basic intervention strategy recommendations, output high-risk user list and intervention suggestions"
  deep_description: "Full tiered operation strategy + personalized outreach content + intervention ROI tracking + churn model optimization suggestions + user lifetime value prediction"
reads:
  - rules/security.md
  - loops/LOOP.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - docs/growth/growth-strategy.md
  - retention-management.json
  - retention-management.md
---

# Retention Management Integrated

## Core Principles

1. **Prevention beats recovery**: Intervening when churn signals appear is far cheaper and more successful than recalling after churn
2. **Interventions must match risk**: High-risk users need high-touch interventions; over-intervention on low-risk users pushes them away
3. **ROI closed-loop validation**: Every intervention strategy must track churn-prevention ROI; ineffective strategies are eliminated promptly
4. **Segmentation is strategy**: The purpose of user segmentation is differentiated operations; segmentation criteria must directly link to operational actions
5. **Health score is a leading indicator**: User health decline precedes behavioral churn; it's the best intervention window
6. **Outreach frequency must match value**: High-value content can be sent at high frequency; over-sending low-value content equals harassment

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| User behavior data | JSON | Yes | User-provided (active logs exported from data analytics platform, fields: user_id, last_active_date, active_days_30d) | Activity logs, feature usage, content interaction |
| Churn history data | JSON | Yes | User-provided (churn records exported from data analytics platform, fields: user_id, churn_date, churn_reason) | Behavioral characteristics of churned users |
| User account data | JSON | Yes | User-provided (account info exported from user system, fields: user_id, register_date, plan_type) | Basic info, payment status |
| User lifecycle stage | object | ○ | User-provided | Registration time, key milestones |

## Churn Definition

### Churn Criteria
| User Type | Churn Definition |
|---------|---------|
| Free users | No activity for 30 consecutive days |
| Paid users | No activity for 60 consecutive days or subscription cancelled |
| Enterprise users | No activity for 90 consecutive days or contract expired |

### Churn Types
- **Active churn**: User actively stops using or cancels subscription
- **Passive churn**: User becomes inactive without explicitly leaving
- **Paid churn**: Paid user downgrades or cancels subscription

## User Lifecycle Segmentation

### Segmentation Definition

| Tier | Time Criteria | User Behavior Characteristics | Core Needs |
|------|---------|-------------|---------|
| New user | 0-30 days | Exploring product features | Quick onboarding, experience value |
| Growing user | 30-90 days | Increasing usage frequency | Deep usage, habit formation |
| Mature user | 90+ days | Stable usage | Continuous value, prevent dormancy |
| Dormant user | 7-30 consecutive days inactive | Sudden activity drop | Reactivation, value recall |
| Churned user | 30+ consecutive days inactive | No activity | Targeted recall |

### Health Score

Comprehensively assess the user's health state across the lifecycle:

```
Health Score = 0.3 × Activity + 0.25 × Feature Depth + 0.25 × Payment Willingness + 0.2 × Social Engagement
```

## Execution Steps

### Step 1: Churn Prediction (from retention-churn) [Core]

Build a churn prediction model, identify high-risk users, and automatically trigger interventions.

#### 1.1 Churn Prediction Model Construction

##### Data Preparation
1. **Label data**: Historical churned user labels
2. **Feature engineering**: Build churn prediction features
3. **Data split**: Training set / validation set / test set

##### Churn Signal Features
| Feature Category | Specific Features |
|---------|---------|
| Activity features | Visit frequency, usage duration, feature usage count |
| Behavioral features | Core feature usage, key operation completion |
| Engagement features | Content interaction, social behavior |
| Payment features | Payment status, spend amount, payment cycle |
| Feedback features | NPS score, customer service contact, support tickets |

##### Model Training
Supports multiple model types:
- Logistic regression (high interpretability)
- XGBoost/LightGBM (high accuracy)
- Deep learning models (complex pattern recognition)
- Ensemble models (stable and reliable)

#### 1.2 High-Risk User Identification

##### Risk Tiering
| Risk Level | Risk Score | Definition | Response Strategy |
|---------|---------|------|---------|
| High risk | ≥0.7 | Very likely to churn | Immediate intervention |
| Medium risk | 0.4-0.7 | Higher churn likelihood | Focused attention |
| Low risk | 0.2-0.4 | Churn tendency | Preventive intervention |
| Stable | <0.2 | Normal user | Routine maintenance |

##### Churn Signal Analysis
Identify key factors leading to high risk:
- Activity decline signals
- Feature usage reduction signals
- Negative feedback signals
- Competitor usage signals

#### 1.3 Automated Intervention Triggering

##### Intervention Strategy Library
| Risk Level | Intervention Strategy | Outreach Channel | Response Time |
|---------|---------|---------|---------|
| High risk | Dedicated customer success, limited-time offer | Phone + SMS + Email | Immediate |
| Medium risk | Personalized value push, survey | Email + Push | Within 24 hours |
| Low risk | Content marketing, version update notification | Push + in-app message | Within 48 hours |

##### Intervention Content Types
1. **Value recall**: Showcase new product features and use cases
2. **Problem solving**: Provide solutions for known issues
3. **Incentive offer**: Provide renewal discounts or value-added services
4. **Human care**: Customer success proactive outreach to understand needs
5. **Social activation**: Invite friends to use together

##### Intervention Timing
- Trigger immediately after user behavior change
- Trigger preventive interventions before risk accumulates
- Avoid outreach during user busy hours

#### 1.4 Intervention Effectiveness Tracking

##### Core Metrics
| Metric | Description | Target Value |
|------|------|--------|
| Intervention coverage | Proportion of high-risk users intervened | ≥80% |
| Response rate | Proportion of users responding after intervention | ≥15% |
| Churn prevention rate | Proportion of users retained after intervention | ≥10% |
| ROI | Churn-prevention revenue / intervention cost | ≥3.0 |

##### Effectiveness Analysis
- Effect comparison across intervention strategies
- Intervention effect differences across user groups
- Impact of intervention timing on effectiveness
- Optimization directions for intervention content

### Step 2: Tiered Operations (from retention-engagement) [Conditional]

Based on the churn prediction results output by Step 1, segment users by lifecycle, generate operation strategies and personalized outreach content.

#### 2.1 User Segmentation

##### Segmentation Rule Engine
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

##### Segmentation Priority
Dormant and churned user identification takes priority over normal segmentation, ensuring timely triggering of churn-prevention strategies.

#### 2.2 Tier Characteristics Analysis

##### New User Analysis
- Activation path analysis
- Early behavior clustering
- Activation barrier identification

##### Growing User Analysis
- Feature depth usage analysis
- Usage frequency trends
- Value perception assessment

##### Mature User Analysis
- Feature usage stability
- Payment conversion potential
- Social activity level

##### Dormant User Analysis
- Last behavior before dormancy
- Dormancy triggers
- Potential recall value

##### Churned User Analysis
- Churn time distribution
- Churn reason inference
- Recall value assessment

#### 2.3 Automated Operation Strategy Generation

##### Tiered Operation Strategy

| User Tier | Operation Goal | Core Strategy | Key Metrics |
|---------|---------|---------|---------|
| New user | Activation + retention | Guide experience, habit formation | D7/D30 retention rate |
| Growing user | Deep usage | Feature expansion, value reinforcement | Feature usage count, usage duration |
| Mature user | Continuous activity | Prevent dormancy, value-added services | Monthly active rate, NRR |
| Dormant user | Reactivation | Value recall, problem solving | Wake-up rate, recall ROI |
| Churned user | Targeted recall | Incentive offers, emotional recall | Recall rate, recalled user LTV |

##### Strategy Trigger Rules
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

#### 2.4 Outreach Content Personalization

##### Content Type Matrix
| User Tier | Push Content | Content Style | Outreach Frequency |
|---------|---------|---------|---------|
| New user | Tutorials, feature intros | Friendly guidance | High |
| Growing user | Advanced tips, case studies | Value-oriented | Medium |
| Mature user | Feature updates, member benefits | Maintenance care | Low |
| Dormant user | Value recall, limited-time offers | Incentive-driven | Concentrated |
| Churned user | Recall campaigns, exclusive offers | Emotional appeal | Concentrated |

##### Personalized Content Generation
- Recommend relevant content based on user usage history
- Adjust content format based on user preference settings
- Adjust content theme based on user lifecycle stage

## Output

**Storage path**: `docs/growth/growth-strategy.md ("Retention Management" section)`

**Output files**: retention-management.json, retention-management.md

**Output Schema**:

```json
{
  "type": "object",
  "required": ["churn_prevention", "segments", "strategies"],
  "properties": {
    "churn_prevention": {"type": "object", "description": "Churn prediction and intervention results, including model, risk users, and intervention strategies"},
    "segments": {"type": "array", "description": "User segmentation data, including tier name, count, characteristics, and health score"},
    "segment_overview": {"type": "object", "description": "Overview per tier, including count and average health score"},
    "strategies": {"type": "array", "description": "List of tiered operation strategies, including goals, actions, and success metrics"},
    "personalized_content": {"type": "array", "description": "List of personalized outreach content, including content type, theme, and channel"}
  }
}
```

`retention_management`
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

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| churn_prevention | object | Yes | Churn prediction and intervention results, must include risk_model/high_risk_users/interventions |
| churn_prevention.risk_model | object | Yes | Prediction model, must include model_type/features/accuracy |
| churn_prevention.risk_model.model_type | string | Yes | Model type |
| churn_prevention.risk_model.features | array | Yes | Model feature list |
| churn_prevention.risk_model.features[].feature_name | string | Yes | Feature name |
| churn_prevention.risk_model.features[].importance | number | No | Feature importance |
| churn_prevention.risk_model.accuracy | number | Yes | Model accuracy, must be >0.75 |
| churn_prevention.risk_thresholds | object | Yes | Risk thresholds, must include high_risk/medium_risk/low_risk |
| churn_prevention.high_risk_users | array | Yes | High-risk user list, each item must include user_id/risk_score/risk_level |
| churn_prevention.high_risk_users[].user_id | string | Yes | User ID |
| churn_prevention.high_risk_users[].risk_score | number | Yes | Risk score, range 0-1 |
| churn_prevention.high_risk_users[].risk_level | string | Yes | Risk level, only allows high/medium/low/stable |
| churn_prevention.high_risk_users[].primary_churn_signals | string[] | No | Primary churn signals |
| churn_prevention.high_risk_users[].recommended_intervention | string | No | Recommended intervention |
| churn_prevention.interventions | array | Yes | Intervention strategy list, each item must include trigger_condition/intervention_type/channel |
| churn_prevention.interventions[].trigger_condition | string | Yes | Trigger condition |
| churn_prevention.interventions[].intervention_type | string | Yes | Intervention type, enum: email/in_app/push/call |
| churn_prevention.interventions[].channel | string | Yes | Outreach channel |
| churn_prevention.interventions[].content_theme | string | No | Content theme |
| churn_prevention.tracking | object | No | Effectiveness tracking, must include response_rate/churn_prevention_rate/roi |
| segments | array | Yes | User segmentation data, must cover at least new/growing/mature/dormant/churned 5 tiers |
| segments[].segment_id | string | Yes | Segment identifier, only allows new_user/growing_user/mature_user/at_risk/churned |
| segments[].count | number | Yes | Segment user count, must be ≥0 |
| segments[].health_score | number | Yes | Health score, range 0-1 |
| segments[].characteristics | object | No | Segment characteristics |
| segments[].characteristics.avg_tenure | string | No | Average lifecycle |
| segments[].characteristics.key_behaviors | string[] | No | Key behaviors |
| strategies | array | Yes | Operation strategy list, at least 5 (1 per tier) |
| strategies[].segment | string | Yes | Target segment |
| strategies[].key_actions | string[] | No | Key action list |
| strategies[].success_metrics | array | Yes | Success metric list, at least 1 |
| personalized_content | array | No | Personalized content list |
| personalized_content[].content_type | string | Yes | Content type, enum: email/in_app/push/sms |
| personalized_content[].theme | string | Yes | Content theme |
| personalized_content[].channels | string[] | No | Outreach channel list |
| personalized_content[].frequency | string | No | Outreach frequency |

## Decision Rules

| Situation | Action |
|------|----------|
| Risk score ≥0.7 (high risk) | Immediate intervention, dedicated customer success engagement |
| Paid user shows churn signals | Priority handling, respond within 48 hours |
| Intervention response rate <10% | Optimize intervention content and channels |
| High-value user churn warning | Full-channel outreach + human care |
| Dormant user proportion >15% | Trigger batch recall strategy |
| New user D7 retention <25% | Optimize Onboarding and activation guidance |
| Mature user health score drops | Trigger anti-dormancy strategy |
| Operation outreach response rate <5% | Optimize outreach content and channels |

## Quality Checks

- [ ] Churn definition distinguishes free/paid/enterprise users (P0)
- [ ] Prediction model accuracy >75% (P0)
- [ ] Intervention strategy matches risk level (P1)
- [ ] Intervention effectiveness tracking includes ROI calculation (P2)
- [ ] User segmentation covers full lifecycle (new/growing/mature/dormant/churned) (P1)
- [ ] Health score includes activity, feature depth, payment willingness, social engagement (P1)
- [ ] Operation strategy matches user tier (P1)
- [ ] Outreach content is personalized (P2)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| User behavior data missing | User provides user activity data → analyze churn characteristics | Churn attribution inferred from activity data, behavioral characteristic analysis limited | Require user to provide user activity data (active user count per period, churned user count) |
| No behavior data | Infer based on user interviews, mark confidence ≤0.3 | Churn characteristics inferred from interviews, low confidence, requires manual verification | Require user to provide user interview records and churned user descriptions |
| Churn history missing | Skip churn trend comparison, analyze only based on current data | Cannot assess churn trend changes | Require user to provide historical churn rate and churned user count trend data |
| User behavior data + churn history both missing | User provides user activity data → analyze churn characteristics | Output basic churn analysis, intervention strategies marked "pending validation" | Require user to provide user activity data and churn definition criteria |
| Lifecycle stage missing | Use generic lifecycle model (new/active/dormant/churned), marked "pending confirmation" | Segmentation criteria based on generic assumptions | Require user to provide user lifecycle stage definition and segmentation criteria |
| User behavior data + lifecycle stage both missing | User describes user groups → generate segmentation strategy | Output segmentation strategy based on description, marked "pending data validation" | Require user to provide user group description and core behavioral characteristics |
| User account data missing | Skip account-level churn analysis, analyze only based on aggregated data | Cannot identify high churn risk accounts | Require user to provide user account list, payment status, and activity data |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degraded generation:
- **User activity data**: Active user count and churned user count per period
- **Churn definition** (optional): The product's definition criteria for churned users
- **High-value user proportion** (optional): Proportion of high-value users among active users
- **User group description**: Main types and characteristics of product users
- **Activity distribution** (optional): Proportion of high/medium/low activity users
- **Operation resources** (optional): Resources and channels available for user operations

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| Data analytics platform - active logs | Behavioral event definition change | Churn signal features and model training | Update feature engineering, retrain model |
| Data analytics platform - churn records | Churn definition change | Churn labels and risk thresholds | Re-label per new definition, adjust thresholds |
| User system - account info | User attribute change | Risk tiering and intervention strategy | Update user characteristics, adjust intervention matching |
| User-provided - lifecycle | Milestone definition change | Segmentation criteria and strategy triggers | Adjust segmentation conditions and trigger rules |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| revenue-upsell | High-value user segmentation change | Write to output file | High-value user list and upgrade signals |
| retention-orchestrator | Churn prediction and tiered operations complete | Output file updated | Retention management completion status and key conclusions |

## Key Success Metrics

| Metric | Definition | Target Value |
|------|------|--------|
| Retention rate per tier | Proportion of users in each tier retained in the next period | Improve tier by tier |
| Dormant wake-up rate | Proportion of dormant users reactivated | ≥15% |
| Average user health score | Average health score across all users | ≥0.7 |
| Operation outreach response rate | Open/click rate of outreach messages | ≥10% |

## Notes

- The churn prediction model needs regular updates to adapt to product changes and user behavior changes
- Avoid over-intervention that disturbs users and degrades user experience
- High-value user intervention priority and resource investment should be higher
- Establish an intervention feedback mechanism to continuously optimize intervention strategies
