---
name: revenue-upsell
description: Use when optimizing upgrade conversion strategy. Upsell Automation Pipeline identifies upgrade signal users, automatically generates personalized upgrade content, optimizes outreach timing, and designs A/B tests. Keywords: upgrade conversion, add-on, Upsell, upgrade strategy, cross-sell, push higher tier, get customers to buy more, upgrade plan.
---
# Upsell Automation

## When to use
- How to get users to upgrade their plan
- Which users are suitable for add-on recommendations
- How to do cross-selling

## Mode Boundary

> ⚠️ **Standalone fallback only.** In family mode (harness-growth installed), this skill is NOT invoked; PM produces `pm-to-growth.md` instead (per `DOMAIN_BOUNDARIES.md`). In standalone mode, this skill is the fallback — mark outputs `mode: standalone-fallback`. Detection: if `pm-to-growth.md` exists or harness-growth is installed, do NOT invoke.

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/growth/growth-strategy.md
- upsell_strategy.json

## Core Principles

1. **Upgrade is value extension, not sales**: Upgrade recommendations must be based on users' real usage needs and scenarios, not sales quotas
2. **Signal strength determines timing**: Multiple strong signals trigger immediate guidance; weak signals require continuous nurturing; avoid premature or late outreach
3. **Personalization is conversion rate**: The more the upgrade content fits the user's current usage scenario, the higher the conversion rate

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| User behavior data | object | Yes | User-provided | Usage volume, feature usage, collaboration behavior |
| Payment history data | object | Yes | docs/growth/growth-strategy.md ("NRR Analysis" section) | Historical plans, payment amount, payment cycle |
| Product usage data | object | ○ | User-provided | Feature usage details, usage statistics |

## Upgrade Signal Types

### Type 1: Usage Limit Signals
| Signal | Description | Upgrade Potential |
|------|------|---------|
| Storage reaches limit | File storage approaching free version limit | High |
| API calls exceed limit | API calls approaching quota | High |
| Seats fully used | Team size reaches free version limit | High |
| Feature usage exceeds limit | Some features have usage count limits | Medium |

### Type 2: Feature Demand Signals
| Signal | Description | Upgrade Potential |
|------|------|---------|
| Premium feature access | Frequently accesses paid exclusive features | High |
| Collaboration feature usage | Uses team collaboration features | High |
| Advanced API usage | Uses advanced API features | High |
| Customization needs | Shows customization needs | Medium |

### Type 3: Behavioral Signals
| Signal | Description | Upgrade Potential |
|------|------|---------|
| High-frequency usage | Usage frequency far exceeds average users | High |
| Long-duration usage | Usage duration far exceeds average users | Medium |
| Multi-project operation | Simultaneously operates multiple projects/workspaces | High |
| Key feature usage | Uses core business features | High |

### Type 4: Intent Signals
| Signal | Description | Upgrade Potential |
|------|------|---------|
| Pricing page visit | Frequently views paid pricing | High |
| Comparison page visit | Views plan comparison | High |
| Trial application | Applies for paid feature trial | High |
| Customer service inquiry | Inquires about upgrade-related questions | High |

## Execution Steps

### Step 1: Upgrade Signal Identification [Core]

#### Signal Detection Rules
```yaml
signal_rules:
  usage_limit:
    - condition: "storage_usage >= 0.8 * free_limit"
      weight: 0.9
    - condition: "storage_usage >= 0.6 * free_limit"
      weight: 0.6

  feature_access:
    - condition: "premium_feature_access_count >= 5"
      weight: 0.8

  behavioral:
    - condition: "daily_active_days >= 5 AND avg_session > 30min"
      weight: 0.7
```

#### Signal Strength Calculation
```python
signal_strength = (
    signal_type_weight * 0.4 +
    behavior_frequency * 0.3 +
    recency_factor * 0.3
)
```

#### Upgrade Opportunity Scoring
```python
upgrade_score = (
    usage_signals * 0.35 +
    feature_signals * 0.30 +
    behavioral_signals * 0.20 +
    intent_signals * 0.15
)
```

#### Priority Tiering
| Priority | Score Range | Characteristics | Response Strategy |
|--------|---------|------|---------|
| P0 | ≥0.8 | Multiple strong signals | Immediate upgrade guidance |
| P1 | 0.6-0.8 | Obvious upgrade need | Proactive upgrade recommendation |
| P2 | 0.4-0.6 | Some upgrade signals | Scenario-based upgrade guidance |
| P3 | <0.4 | Potential upgrade need | Continuous nurturing |

### Step 2: Upgrade Content Personalization [Core]

#### Personalization Elements
| Element | Content Source | Description |
|------|---------|------|
| User name | User profile | Personalized greeting |
| Current usage | Product data | "You have used 80%" |
| Usage limit | Product data | Specific limit scenario |
| Upgrade benefits | Product info | What you get after upgrading |
| Recommended plan | Product pricing | Most suitable plan |

#### Personalized Content Template
```
Title: {user_name}, you have reached the {product_name} {limit_type} limit

Body:
You have used {current_usage}/{free_limit} this month.
When usage reaches 100%, some features will be restricted.

Upgrade to {recommended_plan}, you can:
✓ {benefit_1}
✓ {benefit_2}
✓ {benefit_3}

{incentive_info}

[Upgrade Now] [Learn More]
```

### Step 3: Outreach Timing Optimization [Core]

#### Optimal Outreach Timing
| Timing | Trigger Condition | Effect |
|------|---------|------|
| Real-time trigger | When usage limit is reached | Most relevant |
| Behavior peak | During user activity peak hours | High outreach rate |
| After feature usage | After accessing/trying paid features | Clear need |
| Periodic reminder | Beginning of month / weekend | Sufficient decision time |

#### Outreach Channel Selection
| User Type | Recommended Channel | Priority |
|---------|---------|--------|
| High-activity users | App popup + Push | Real-time |
| Medium-activity users | Email + in-app message | Periodic |
| Low-activity users | Email + SMS | Reinforced |
| High-value users | Email + Phone | Full-channel |

### Step 4: A/B Test Design [Core]

#### Test Types
| Test Type | Test Content | Goal |
|---------|---------|------|
| Timing test | Effect of different trigger timings | Find the best trigger point |
| Content test | Conversion effect of different copy | Optimize copy |
| Incentive test | Conversion of different discount levels | Balance conversion rate and profit |
| Channel test | Effect of different outreach channels | Optimize outreach efficiency |

#### A/B Test Template
```yaml
test_id: "UPSELL_TEST_{sequence}"
test_name: "Test name"
hypothesis: "If...then... hypothesis"

variants:
  control:
    name: "Control group"
    description: "Current scheme"
  treatment:
    name: "Treatment group"
    description: "Test scheme"

metrics:
  primary: "Upgrade conversion rate"
  secondary: ["Upgrade GMV", "Upgrade user count"]
  guardrail: ["Retention rate", "NPS"]

design:
  min_sample_per_variant: 500
  runtime_days: 14
  mde: 0.1

success_criteria:
  - primary_metric_lift: ">=10%"
  - guardrail_metrics: "No significant decline"
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Upsell strategy and opportunity list | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full strategy + upsell trigger design + customer-tiered upsell model + upsell experiment plan | Full artifact + extended analysis + deep reasoning |

## Output

**Storage path**: `docs/growth/growth-strategy.md ("Upsell" section)`

**Output file**: upsell_strategy.json

**Output Schema**, complete upsell_automation example, and **field validation rules**:

> See [Reference/output-schema-validation-example.md](./Reference/output-schema-validation-example.md) for the output JSON schema (upgrade_signals, personalized_offers, ab_tests, tracking), a complete upsell_automation example (user upgrade signals, personalized offers, A/B test design, tracking metrics), and the field validation rules table (upgrade_signals[], personalized_offers[], ab_tests[], tracking).

## Output Validation Rules

> See [Reference/output-schema-validation-example.md](./Reference/output-schema-validation-example.md#output-validation-rules) for the field validation rules table (upgrade_signals, personalized_offers, ab_tests, tracking).

## Decision Rules

| Situation | Action |
|------|----------|
| Upgrade score ≥0.8 (P0) | Trigger upgrade guidance immediately |
| Usage limit + feature demand dual signals | Prioritize recommending matching plan |
| Upgrade conversion rate below 5% | Outreach content or timing needs A/B test optimization |
| Guardrail metrics (retention/NPS) decline | Pause upgrade push, investigate cause |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Upgrade signal identification covers 4 signal types (usage/feature/behavior/intent)
- [ ] Personalized content includes 3 elements: user name, usage, and benefits

### P1 Checks (must pass for standard/deep)

- [ ] A/B test design includes guardrail metrics
- [ ] Upgrade ROI calculation includes outreach cost

### P2 Checks (only required for deep)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| User behavior data missing | User describes paying user characteristics → generate upgrade strategy | Upgrade signals based on user description, lacking behavior data validation | Require user to provide paying user usage behavior and feature usage frequency |
| Payment history missing | Skip payment pattern analysis, use generic upgrade trigger rules | Upgrade timing judgment based on generic rules | Require user to provide historical plan distribution and payment cycle data |
| Product usage data missing | Skip feature usage detail analysis, upgrade signals based only on behavior and payment data | Upgrade signals lack feature dimension, upgrade recommendation precision reduced | Require user to provide feature usage details and usage statistics data |
| User behavior + payment history both missing | User describes paying user characteristics → generate upgrade strategy | Output upgrade strategy based on description, marked "pending data validation" | Require user to provide paying user characteristic description, product tiers, and upgrade barriers |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degraded generation:
- **Paying user characteristics**: Current paying users' usage behavior and payment patterns
- **Product tiers** (optional): Pricing and feature differences across paid tiers
- **Upgrade barriers** (optional): Known reasons why users don't upgrade

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| revenue-nrr | Expansion opportunity change | Upgrade signal identification and recommended plan | Update expansion signals and upgrade recommendations |
| User-provided - behavior data | Usage metric change | Signal detection rules and scoring | Update signal weights and scoring formula |
| User-provided - payment history | Payment pattern change | Personalized content and outreach timing | Adjust content templates and trigger conditions |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| revenue-orchestrator | Upgrade strategy output complete | Output file updated | Upgrade conversion completion status and key conclusions |
| retention-management | High-value user upgrade signal | Write to output file | Upgrade signal user list |

## Key Success Metrics

| Metric | Definition | Target Value |
|------|------|--------|
| Upgrade conversion rate | Upgrading users / Upgrade opportunity users | ≥8% |
| Upgrade GMV | Monthly revenue increase from upgrades | Continuous growth |
| Upgrade response rate | Proportion of users responding after outreach | ≥15% |
| Upgrade ROI | Upgrade GMV / Outreach cost | ≥3 |
| Post-upgrade retention rate | 12-month retention rate of upgrading users | ≥85% |
