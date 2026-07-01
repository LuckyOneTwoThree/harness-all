---
name: acquisition-analysis
description: Use when you need to evaluate acquisition channels or optimize the acquisition funnel. Acquisition Analysis Integrated Pipeline first analyzes 19 acquisition channels to calculate channel scale, conversion rate, and ROI, outputting a channel tier report, then analyzes acquisition funnel data to identify the biggest drop-off nodes and auto-generate optimization plans and A/B test designs. Keywords: acquisition channels, channel evaluation, ROI analysis, channel tiering, acquisition optimization, funnel optimization, conversion optimization, A/B testing, acquisition funnel, low conversion rate, which channel is best, how to improve conversion.
---
# Acquisition Analysis Integrated

## When to use
- Which channel has the best user acquisition performance
- Help me check the ROI of each channel
- Registration-to-activation conversion rate is too low
- Where in the funnel is the most drop-off
- How to improve acquisition conversion rate

## Mode Boundary

> ⚠️ **Standalone fallback only.**
>
> In **family mode** (with harness-growth installed), this skill is NOT directly invoked. PM produces `docs/handoff/pm-to-growth.md` instead, and harness-growth owns channel/content/SEO/user operations and experiment execution (per `DOMAIN_BOUNDARIES.md` Ownership Matrix).
>
> In **standalone mode** (PM is the only harness), this skill is the fallback for growth-related work. All outputs must be marked `mode: standalone-fallback`.
>
> **Detection rule**: If `docs/handoff/pm-to-growth.md` exists or harness-growth is installed, do NOT invoke this skill; produce/refresh `pm-to-growth.md` instead.

## Inputs
- rules/security.md
- loops/LOOP.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/growth/growth-strategy.md
- acquisition-analysis.json
- acquisition-analysis.md

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

> See [Reference/acquisition-channels-list.md](./Reference/acquisition-channels-list.md) for the full list of 19 acquisition channels across 5 categories (Paid, Organic, Partnership, Sales, Other).

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

**Output Schema**, full JSON example, and A/B test design template:

> See [Reference/output-schema-and-example.md](./Reference/output-schema-and-example.md) for the output JSON schema (channel_assessment, funnel_analysis, optimization_suggestions, ab_test_designs), a complete acquisition_analysis example, and the A/B test YAML template.

## Output Validation Rules

> See [Reference/output-validation-rules.md](./Reference/output-validation-rules.md) for the full field validation rules table covering channel_assessment, funnel_analysis, optimization_suggestions, and ab_test_designs.

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
| growth-orchestrator (phase-2) | Channel evaluation and funnel optimization completed | Output file update | Channel tiering and funnel optimization completion status and key conclusions |
