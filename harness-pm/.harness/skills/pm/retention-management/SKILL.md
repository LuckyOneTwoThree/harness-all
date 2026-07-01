---
name: retention-management
description: Use when reducing churn rate or improving user engagement. Retention Management Integrated Pipeline first builds a churn prediction model to identify high-risk users and automatically trigger interventions, then segments users by lifecycle stage to generate operation strategies and personalized outreach content. Keywords: churn prediction, churn intervention, churn model, user retention, user segmentation, tiered operations, lifecycle operations, personalized outreach, engagement improvement, user activity, high churn rate, how to retain, differentiated operations, operation segmentation.
---
# Retention Management Integrated

## When to use
- Users keep churning, what should I do
- How to spot users about to leave early
- Churn rate is too high, how to reduce it
- How to run differentiated operations for different users
- How to improve user engagement
- How to do user segmentation

## Mode Boundary

> ⚠️ **Standalone fallback only.**
>
> In **family mode** (with harness-growth installed), this skill is NOT directly invoked. PM produces `docs/handoff/pm-to-growth.md` instead, and harness-growth owns channel/content/SEO/user operations and experiment execution (per `DOMAIN_BOUNDARIES.md` Ownership Matrix).
>
> In **standalone mode** (PM is the only harness), this skill is the fallback for growth-related work. All outputs must be marked `mode: standalone-fallback`.
>
> **Detection rule**: If `docs/handoff/pm-to-growth.md` exists or harness-growth is installed, do NOT invoke this skill; produce/refresh `pm-to-growth.md` instead.

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/growth/growth-strategy.md
- retention-management.json
- retention-management.md

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

> See [Reference/examples.md](./Reference/examples.md#segmentation-rule-engine-yaml) for the segmentation rule engine YAML (new_user / growing_user / mature_user / at_risk / churned conditions).

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

> See [Reference/examples.md](./Reference/examples.md#strategy-trigger-rules-yaml) for the strategy trigger rules YAML (event-driven actions per tier: new_user / growing_user / mature_user / at_risk / churned).

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

**Output Schema**: See [Reference/output-schema.md](./Reference/output-schema.md) for the JSON output schema and field-level validation rules.

**Complete Output Example**: See [Reference/examples.md](./Reference/examples.md#complete-output-example-retention_management) for a populated `retention_management` JSON example.

## Automated Operation Calendar

> See [Reference/examples.md](./Reference/examples.md#automated-operation-calendar) for the weekly fixed outreach and event-triggered outreach calendar template.

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

> See [Reference/decision-tables.md](./Reference/decision-tables.md#degradation-strategy) for the upstream file missing degradation plan and data acquisition instructions.

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md#upstream-change-response) for the upstream change impact table and downstream notification mechanism table.

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
