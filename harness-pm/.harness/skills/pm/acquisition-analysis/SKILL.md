---
name: acquisition-analysis
description: Use when you need to evaluate acquisition channels or optimize the acquisition funnel. Acquisition Analysis Integrated Pipeline first analyzes 19 acquisition channels to calculate channel scale, conversion rate, and ROI, outputting a channel tier report, then analyzes acquisition funnel data to identify the biggest drop-off nodes and auto-generate optimization plans and A/B test designs. Keywords: acquisition channels, channel evaluation, ROI analysis, channel tiering, acquisition optimization, funnel optimization, conversion optimization, A/B testing, acquisition funnel, low conversion rate, which channel is best, how to improve conversion.
metadata:
  module: "Product Growth & Operations"
  sub-module: "Acquisition"
  type: "pipeline"
  version: "3.0"
  domain_tags: ["Internet", "SaaS", "General"]
  trigger_examples:
    - "Which channel has the best user acquisition performance"
    - "Help me check the ROI of each channel"
    - "Registration-to-activation conversion rate is too low"
    - "Where in the funnel is the most drop-off"
    - "How to improve acquisition conversion rate"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output acquisition channels and CAC analysis"
  deep_description: "Complete analysis + channel attribution model + CAC optimization simulation + acquisition experiment roadmap"
reads:
  - rules/security.md
  - loops/LOOP.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - docs/growth/growth-strategy.md
  - acquisition-analysis.json
  - acquisition-analysis.md
---

# Acquisition Analysis Integrated

## Core Principles

1. **Channels are a portfolio**: Each channel is an investment, evaluated on both ROI and scale dimensions, not a single metric
2. **Tiered management with dynamic adjustment**: Primary/Test/Observation three tiers with dynamic flow, data-driven promotion/demotion
3. **LTV perspective for ROI**: Channel ROI must consider user LTV rather than single-transaction revenue, avoiding short-sighted cuts to long-cycle high-value channels
4. **Drop-off is signal**: Every drop-off node is users voting with their feet; the node with the highest drop-off rate is the biggest optimization leverage
5. **Obstacle classification for targeted breakthrough**: Awareness/Trust/Action/Value obstacles require completely different optimization approaches
6. **Experiment validation over guessing**: Optimization plans must be validated through A/B testing, replacing intuition with data

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| 19 acquisition channels data | object | Yes | User-provided | Complete data for 19 acquisition channels |
| Historical channel performance | object | Yes | User-provided | Historical channel performance data |
| Channel config and cost | object | Yes | User-provided | Channel configuration and cost data |
| Historical optimization data | object | ○ | User-provided | Historical optimization experiment data |

## 19 Acquisition Channels List

### Paid Acquisition Channels
1. **Search Ads (SEM)** - Google Ads, Baidu PPC
2. **Social Ads** - Facebook/Instagram Ads, LinkedIn Ads, WeChat Moments Ads
3. **Display Ads** - DSP ads, native ads
4. **Video Ads** - YouTube Ads, Douyin/Kuaishou Ads
5. **App Store Ads** - Apple Search Ads, Google Play Ads

### Organic Acquisition Channels
6. **SEO/SEM Organic** - Search engine organic ranking
7. **Content Marketing** - Blog posts, white papers, case studies
8. **Social Media Organic** - Weibo, Xiaohongshu, Douyin organic content
9. **Community Operations** - Zhihu, Tieba, industry forums
10. **Viral Spread** - User sharing, word-of-mouth

### Partnership Acquisition Channels
11. **Affiliate Marketing** - Partner referral commissions
12. **Channel Distribution** - Dealer/agent networks
13. **Platform Partnerships** - App marketplace featuring, platform premieres
14. **Cross-industry Collaboration** - Brand co-branding events

### Sales Acquisition Channels
15. **SDR Outbound** - Telesales team proactive outreach
16. **Offline Events** - Industry exhibitions, offline salons
17. **Sales Referrals** - Sales lead referrals

### Other Channels
18. **Existing User Reach** - Email marketing, push notifications, SMS
19. **PR/Brand** - Media coverage, brand events

## Execution Steps

### Step 1: Channel Evaluation (from acquisition-channel) [Conditional]

Analyze 19 acquisition channels data, calculate channel scale, conversion rate, ROI, and output a channel tier report.

#### 1.1 Channel Scale Evaluation

Analyze the reachable scale and actual deployment scale of each channel:

- **Reachable scale**: Size of the channel's potential user pool
- **Actual deployment scale**: Number of users covered by current resource investment
- **Market share**: Investment share relative to competitors
- **Growth potential**: Growth trend of channel scale

#### 1.2 Conversion Rate Analysis

Calculate the complete conversion funnel for each channel:

| Metric | Description |
|------|------|
| Exposure → Click conversion rate | Ad display to user click |
| Click → Visit conversion rate | Ad click to page visit |
| Visit → Registration conversion rate | Page visit to account registration |
| Registration → Activation conversion rate | Account registration to first use |
| Overall conversion rate | End-to-end conversion from exposure to activation |

#### 1.3 ROI Calculation

Calculate the return on investment for each channel:

```
Channel ROI = (Revenue from channel - Channel investment cost) / Channel investment cost

LTV-based ROI = (User LTV from channel - Channel CAC) / Channel CAC
```

#### 1.4 Channel Tiering

Tier channels based on multi-dimensional scoring:

##### Primary Channels
- ROI ≥ target ROI
- Scalable
- Controllable acquisition cost
- High user quality

##### Test Channels
- ROI close to target but unstable
- Growth potential to be validated
- New acquisition method exploration
- Specific user segment targeting

##### Observation Channels
- ROI below target
- Strategic significance greater than short-term ROI
- Brand building focused
- In optimization phase

#### Scoring Model

```
Composite score = 0.3 × ROI score + 0.25 × Scale score + 0.25 × Quality score + 0.2 × Sustainability score
```

#### Channel Evaluation Decision Rules

| Situation | Handling |
|------|----------|
| Channel ROI ≥ target and scalable | Tier as Primary channel, increase investment |
| Channel ROI close to target but unstable | Tier as Test channel, continuous validation |
| Channel ROI < target and no strategic significance | Tier as Observation channel, reduce investment |
| New channel with no historical data | Small-traffic test, evaluate after 2 weeks |

### Step 2: Funnel Optimization (from acquisition-optimize) [Core]

Based on the channel evaluation data output by Step 1, analyze acquisition funnel data, identify the biggest drop-off nodes, and auto-generate optimization plans and A/B test designs.

#### Funnel Stage Definition

The standard acquisition funnel includes the following stages:

```
Exposure → Click → Visit → Registration → Activation → Payment
```

##### Stage 1: Exposure
- Ad displayed to target users
- Key metrics: impressions, CTR

##### Stage 2: Click
- User clicks ad to enter landing page
- Key metrics: clicks, CPM

##### Stage 3: Visit
- User visits landing page/product page
- Key metrics: UV, bounce rate, page dwell time

##### Stage 4: Registration
- User completes account registration
- Key metrics: registrations, registration rate

##### Stage 5: Activation
- User completes core behavior for the first time
- Key metrics: activations, activation rate

##### Stage 6: Payment (optional)
- User completes first payment
- Key metrics: paid conversions, paid conversion rate

#### 2.1 Funnel Stage Conversion Analysis

1. **Calculate conversion rate at each stage**: Identify conversion efficiency at each stage
2. **Benchmark comparison**: Compare with industry benchmarks and historical data
3. **Trend analysis**: Time trend of conversion rates at each stage
4. **Channel comparison**: Funnel performance differences across channels

#### 2.2 Biggest Drop-off Node Identification

1. **Calculate drop-off impact coefficient**:
   ```
   Impact coefficient = drop-off rate at this stage × conversion weight from this stage to final
   ```

2. **Multi-dimensional breakdown**:
   - Break down by channel
   - Break down by user persona
   - Break down by traffic source
   - Break down by time

3. **Drop-off cause inference**:
   - Quantitative analysis: user behavior data
   - Qualitative analysis: user feedback, interviews

#### 2.3 Optimization Plan Auto-Generation

Based on drop-off cause analysis, generate targeted optimization plans:

| Drop-off Type | Optimization Direction | Typical Solutions |
|---------|---------|---------|
| Awareness obstacle | Optimize ad creatives | Highlight value proposition, improve creative |
| Trust obstacle | Enhance social proof | Add reviews, cases, data |
| Action obstacle | Simplify flow | Reduce steps, lower threshold |
| Value obstacle | Strengthen value perception | Demo features, free trial |

#### 2.4 A/B Test Design

Design A/B tests for optimization plans:

1. **Hypothesis definition**: Clarify the optimization hypothesis being tested
2. **Sample calculation**: Determine sample size needed for statistical significance
3. **Test grouping**: Design control and treatment groups
4. **Monitoring metrics**: Determine primary and secondary monitoring metrics
5. **Decision rules**: Define when to stop the test and declare a winner

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Acquisition channels and CAC analysis | Core conclusions + minimum viable artifact |
| standard | Complete artifact (current default) | Complete artifact, including all Step outputs |
| deep | Complete analysis + channel attribution model + CAC optimization simulation + acquisition experiment roadmap | Complete artifact + extended analysis + deep inference |

## Output

**Storage path**: `docs/growth/growth-strategy.md ("Acquisition Analysis" section)`

**Output files**: acquisition-analysis.json, acquisition-analysis.md

**Output Schema**:

```json
{
  "type": "object",
  "required": ["channel_assessment", "funnel_analysis", "optimization_suggestions"],
  "properties": {
    "channel_assessment": {"type": "object", "description": "Channel evaluation results, including channel details, tiering, and summary metrics"},
    "funnel_analysis": {"type": "object", "description": "Funnel analysis, including stage data and key drop-off nodes"},
    "optimization_suggestions": {"type": "array", "description": "List of optimization recommendations, including priority, issue, plan, and expected lift"},
    "ab_test_designs": {"type": "array", "description": "List of A/B test design plans"}
  }
}
```

`acquisition_analysis`
```json
{
  "channel_assessment": {
    "channels": [
      {
        "name": "Education Industry Exhibition",
        "scale": "Annual reach of 50,000+ education institution decision makers",
        "volume": 10000,
        "conversion_rate": 0.035,
        "cost_per_acquisition": 45.00,
        "roi": 2.5,
        "quality_score": 0.85,
        "classification": "primary|test|observation"
      }
    ],
    "primary_channels": ["Education Industry Exhibition", "SEO/SEM Organic", "Content Marketing"],
    "test_channels": ["Social Ads", "Community Operations", "Affiliate Marketing"],
    "observation_channels": ["PR/Brand", "Cross-industry Collaboration", "Video Ads"],
    "total_new_users": 50000,
    "blended_cac": 35.00,
    "blended_roi": 2.2
  },
  "funnel_analysis": {
    "stages": [
      {
        "name": "Registration",
        "volume": 100000,
        "conversion_rate": 0.05,
        "drop_off_rate": 0.95,
        "avg_time_spent": 30
      }
    ],
    "critical_drop_off": {
      "from_stage": "Visit",
      "to_stage": "Registration",
      "drop_off_rate": 0.85,
      "impact_score": 0.9
    }
  },
  "optimization_suggestions": [
    {
      "priority": 1,
      "stage": "Visit→Registration",
      "issue": "Registration form has too many fields, education institution users have low willingness to fill out",
      "solution": "Simplify registration form to 3 required fields, support WeChat scan one-click registration",
      "expected_improvement": "Expected 15% conversion rate lift",
      "effort": "medium"
    }
  ],
  "ab_test_designs": [
    {
      "test_id": "TEST_001",
      "hypothesis": "Simplifying the registration flow can reduce visit-to-registration drop-off",
      "control": "Current 6-field registration form",
      "treatment": "3-field simplified registration form + WeChat scan registration",
      "primary_metric": "Visit→Registration conversion rate",
      "secondary_metrics": ["Registration completion time", "Post-registration activation rate"],
      "min_sample_size": 10000,
      "estimated_duration": "7 days"
    }
  ]
}
```

## A/B Test Design Template

```yaml
test_id: "ACQ_TEST_{seq}"
name: "Test name"
hypothesis: "If...then... hypothesis"
variants:
  control: "Control group plan description"
  treatment: "Treatment group plan description"
metrics:
  primary: "Primary metric"
  secondary: ["List of secondary metrics"]
  guardrail: ["Guardrail metrics"]
design:
  min_sample_per_variant: 1000
  runtime_days: 7
  mde: 0.05
success_criteria:
  - primary_metric_lift: ">=5%"
  - guardrail_metrics: "No significant decline"
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| channel_assessment | object | Yes | Channel evaluation results, must contain channels/primary_channels/test_channels/observation_channels |
| channel_assessment.channels | array | Yes | Channel evaluation details list, each item must contain name/scale/conversion_rate/roi/classification |
| channel_assessment.channels[].name | string | Yes | Channel name, cannot be empty |
| channel_assessment.channels[].scale | string | Yes | Channel scale description |
| channel_assessment.channels[].volume | number | No | Channel user volume |
| channel_assessment.channels[].conversion_rate | number | Yes | Conversion rate, range 0-1 |
| channel_assessment.channels[].cost_per_acquisition | number | No | Cost per acquisition |
| channel_assessment.channels[].quality_score | number | No | Quality score, range 0-1 |
| channel_assessment.channels[].classification | string | Yes | Channel tier, only primary/test/observation allowed |
| channel_assessment.channels[].roi | number | Yes | Channel ROI, must be calculated based on LTV |
| channel_assessment.primary_channels | array | Yes | Primary channel name list, at least 1 channel |
| channel_assessment.test_channels | array | Yes | Test channel name list |
| channel_assessment.observation_channels | array | Yes | Observation channel name list |
| channel_assessment.total_new_users | number | Yes | Total new users, must be >0 |
| channel_assessment.blended_cac | number | Yes | Blended CAC, must be >0 |
| channel_assessment.blended_roi | number | Yes | Blended ROI |
| funnel_analysis | object | Yes | Funnel analysis, must contain stages and critical_drop_off |
| funnel_analysis.stages | array | Yes | Stage data, each item must contain name/volume/conversion_rate/drop_off_rate |
| funnel_analysis.stages[].name | string | Yes | Stage name, cannot be empty |
| funnel_analysis.stages[].volume | number | Yes | Stage user volume, must be ≥0 |
| funnel_analysis.stages[].conversion_rate | number | Yes | Conversion rate, range 0-1 |
| funnel_analysis.stages[].drop_off_rate | number | Yes | Drop-off rate, range 0-1 |
| funnel_analysis.critical_drop_off | object | Yes | Critical drop-off node, must contain from_stage/to_stage/drop_off_rate/impact_score |
| funnel_analysis.critical_drop_off.from_stage | string | Yes | Drop-off start stage |
| funnel_analysis.critical_drop_off.to_stage | string | Yes | Drop-off target stage |
| funnel_analysis.critical_drop_off.drop_off_rate | number | Yes | Drop-off rate, range 0-1 |
| funnel_analysis.critical_drop_off.impact_score | number | Yes | Impact score, range 0-1 |
| optimization_suggestions | array | Yes | Optimization recommendations list, each item must contain priority/stage/issue/solution/expected_improvement |
| optimization_suggestions[].priority | number | Yes | Priority, starting from 1 |
| optimization_suggestions[].stage | string | Yes | Target stage, cannot be empty |
| optimization_suggestions[].issue | string | Yes | Issue description, cannot be empty |
| optimization_suggestions[].solution | string | Yes | Solution, cannot be empty |
| optimization_suggestions[].expected_improvement | string | Yes | Expected improvement |
| ab_test_designs | array | No | A/B test design plans list, each item must contain test_id/hypothesis/primary_metric |
| ab_test_designs[].test_id | string | Yes | Test ID, cannot be empty |
| ab_test_designs[].hypothesis | string | Yes | Test hypothesis, cannot be empty |
| ab_test_designs[].primary_metric | string | Yes | Primary metric, cannot be empty |

## Decision Rules

| Situation | Handling |
|------|----------|
| Channel ROI ≥ target and scalable | Tier as Primary channel, increase investment |
| Channel ROI close to target but unstable | Tier as Test channel, continuous validation |
| Channel ROI < target and no strategic significance | Tier as Observation channel, reduce investment |
| New channel with no historical data | Small-traffic test, evaluate after 2 weeks |
| Critical step drop-off rate >80% | Mark as highest priority optimization item |
| New channel conversion rate below 50% of average | Demote to Observation channel |
| A/B test primary metric lift ≥5% and statistically significant | Full release of optimization plan |
| Multiple drop-off nodes exist simultaneously | Sort by impact coefficient, prioritize the biggest impact item |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] Channel evaluation covers 4 dimensions: scale, conversion rate, ROI, quality
- [ ] Channel tiering criteria clear (Primary/Test/Observation)

### P1 Checks (standard/deep must pass)

- [ ] ROI calculation considers user LTV rather than single-transaction revenue
- [ ] Evaluation covers 19 acquisition channel types
- [ ] Funnel stage definition complete (exposure → activation/payment)
- [ ] Drop-off causes distinguish 4 obstacle types: awareness/trust/action/value
- [ ] Optimization plans include expected lift and implementation difficulty assessment
- [ ] A/B test design includes decision rules and stopping conditions

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| Channel data missing | User describes product type and target users → recommend channel mix | Channel scoring based on industry experience rather than actual data | Require user to provide traffic, conversion rate, and cost data for each acquisition channel |
| Historical performance missing | Skip channel historical performance evaluation, use industry benchmarks | Cannot identify validated high-efficiency channels | Require user to provide historical channel performance data (CAC, LTV, conversion rate per channel) |
| Both channel data and historical performance missing | User describes product type and target users → recommend channel mix | Output channel recommendations based on industry experience, marked "to be validated" | Require user to provide product type, target users, and acquisition budget |
| Historical optimization data missing | Skip historical comparison, analyze based on current data only | Cannot assess optimization trends | Require user to provide historical acquisition funnel data and optimization experiment results |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Product Type**: Product type and core features
- **Target Users**: Target user segment characteristics and scale
- **Budget Range** (optional): Budget available for acquisition
- **Funnel Data** (optional): User counts and conversion rates at each acquisition funnel step
- **Optimization Goals** (optional): Key conversion rate expected to improve

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| User-provided - Channel data | Data format change | channels field parsing | Adapt to new format, fill missing fields with default values |
| User-provided - Historical performance | Data granularity change | ROI calculation and trend comparison | Recalculate at new granularity, note data caliber change |
| User-provided - Channel config | Channel added/removed | 19 channel list and tiering | Update channel list, new channels default to Test tier |
| User-provided - Historical optimization data | Experiment results update | Benchmark comparison for optimization recommendations | Update comparison benchmark, adjust optimization priorities |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| activation-aha | Activation stage drop-off rate change | Write to output file | Registration→Activation conversion rate and drop-off analysis |
| acquisition-orchestrator | Channel evaluation and funnel optimization completed | Output file update | Channel tiering and funnel optimization completion status and key conclusions |
