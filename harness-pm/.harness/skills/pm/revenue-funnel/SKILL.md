---
name: revenue-funnel
description: Use when analyzing and optimizing the payment conversion funnel. Payment Funnel Auto-Analysis Pipeline analyzes the full-link data from registration to payment, identifies payment barriers, calculates conversion optimization suggestions, and optimizes paywall timing. Keywords: payment funnel, payment conversion, paywall, conversion optimization, payment analysis, unwilling to pay, where payment gets stuck, how to get users to pay.
---
# Payment Funnel Auto-Analysis

## When to use
- Why are users unwilling to pay
- How to improve payment conversion rate
- Where is the best place to put the paywall

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
- revenue_funnel.json

## Core Principles

1. **Payment is value confirmation, not a barrier**: The timing and method of the paywall should make users feel "worth paying" rather than "forced to pay"
2. **Barrier type determines optimization direction**: Five barrier types—awareness/price/trust/need/timing—require completely different optimization strategies
3. **Paywall timing is conversion rate**: The same product can have a 3x difference in conversion rate under different paywall timing

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| Registration-to-payment full-link data | object | Yes | User-provided | Event logs, user behavior |
| Payment conversion data | object | Yes | docs/growth/growth-strategy.md ("NRR Analysis" section) | Paying users, payment amount, payment products |
| User characteristic data | object | ○ | User-provided | User profile, segment tags |

## Payment Funnel Stage Definition

```
Registration → Activation → Deep Usage → Payment Intent → First Payment → Repurchase
```

### Stage 1: Registered Users
- Users who completed account registration
- Key metrics: Registration volume, registration source

### Stage 2: Activated Users
- Completed activation behavior (Aha Moment reached)
- Key metrics: Activation rate, D1 retention

### Stage 3: Deep Usage Users
- Used core features multiple times
- Key metrics: Usage frequency, feature usage count

### Stage 4: Payment Intent Users
- Showed payment intent (viewed pricing, tried premium features)
- Key metrics: Payment intent conversion rate

### Stage 5: First Payment Users
- Completed first payment
- Key metrics: First payment conversion rate, first payment amount

### Stage 6: Repurchase Users
- Completed renewal or add-on purchase
- Key metrics: Renewal rate, add-on purchase rate

## Execution Steps

### Step 1: Payment Funnel Conversion Analysis per Stage [Core]

#### Funnel Calculation
Calculate conversion rate and drop-off rate per stage:

```
Stage conversion rate = Current stage user count / Previous stage user count
Stage drop-off rate = 1 - Stage conversion rate
```

#### Multi-dimensional Breakdown
- Break down by user segment (new/returning/high-value users)
- Break down by registration source (organic/paid/referral)
- Break down by product type
- Break down by time window

#### Trend Analysis
Analyze the time trend of conversion rate per stage:
- Week-over-week change
- Month-over-month change
- Anomaly detection

### Step 2: Payment Barrier Identification [Core]

#### Qualitative Barrier Analysis
| Barrier Type | Symptom | Inferred Cause |
|---------|------|---------|
| Awareness barrier | Doesn't understand payment value | Insufficient value delivery |
| Price barrier | Considers price too high | Pricing strategy issue |
| Trust barrier | Doesn't trust payment security | Insufficient trust building |
| Need barrier | Doesn't need premium features | Product-need mismatch |
| Timing barrier | Not the right time to pay | Inappropriate payment timing |

#### Quantitative Barrier Analysis
- User behavior analysis: Key behaviors not completed
- Funnel drop-off analysis: Identify main drop-off nodes
- Survey/interview analysis: User feedback summary
- Competitor comparison analysis: Differences from competitors

### Step 3: Conversion Optimization Suggestions [Deep]

#### Optimization Direction Matrix
| Barrier Type | Optimization Strategy | Implementation Plan |
|---------|---------|---------|
| Awareness barrier | Strengthen value demonstration | Feature demos, case studies |
| Price barrier | Optimize pricing structure | Tiered pricing, bundle discounts |
| Trust barrier | Enhance trust endorsement | User reviews, certifications |
| Need barrier | Guide need discovery | Trial experience, feature guidance |
| Timing barrier | Optimize payment timing | Paywall adjustment, trigger optimization |

#### Priority Ranking
Rank by impact coefficient and implementation difficulty:

```
Priority = Impact coefficient × Expected lift / Implementation difficulty
```

### Step 4: Paywall Timing Optimization [Core]

#### Paywall Types
| Type | Characteristics | Applicable Scenarios |
|------|------|---------|
| Hard paywall | Cannot use without payment | High-value B2B products |
| Soft paywall | Feature limits, trial available | Mass-market products |
| Hybrid paywall | Partial free + limited trial | Balance experience and conversion |

#### Optimal Payment Timing
Identify the best timing to trigger the paywall:
- After user completes Aha Moment
- When user reaches free version limit
- When user tries to use paid features
- When user usage peaks

#### Trial Strategy Optimization
- Trial duration: 7 days vs. 14 days vs. 30 days
- Trial features: Full features vs. core features
- Trial trigger: Trial on registration vs. behavior-triggered trial

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Payment funnel and conversion bottlenecks | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full analysis + funnel optimization simulation + pricing elasticity testing + revenue prediction model | Full artifact + extended analysis + deep reasoning |

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Decision Rules

| Situation | Action |
|------|----------|
| Active → Payment intent drop-off >80% | Prioritize optimizing value perception and trial experience |
| Inappropriate paywall trigger timing | A/B test different trigger timings |
| First payment conversion rate <3% | Optimize pricing strategy and payment guidance |
| Awareness barrier is the primary barrier | Strengthen feature demos and case studies |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Payment funnel covers the full link from registration to repurchase
- [ ] Barrier identification distinguishes qualitative and quantitative analysis

### P1 Checks (must pass for standard/deep)

- [ ] Optimization suggestions ranked by impact coefficient × implementation difficulty
- [ ] Paywall timing suggestions based on user behavior data

### P2 Checks (only required for deep)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| Registration-to-payment full-link data missing | User provides payment conversion data → analyze funnel | Funnel analysis only covers data nodes provided by user | Require user to provide user count and conversion rate per payment funnel stage |
| Historical payment data missing | Skip payment trend analysis, analyze only based on current data | Cannot assess payment conversion trends | Require user to provide historical payment conversion rate and paying user count trends |
| User characteristic data missing | Skip multi-dimensional breakdown analysis, output only overall funnel | Cannot break down funnel by user segment, barrier attribution precision reduced | Require user to provide user profile and segment tag data |
| Full-link data + historical payment data both missing | User provides payment conversion data → analyze funnel | Output basic payment funnel analysis, optimization suggestions marked "pending validation" | Require user to provide conversion data per stage, pricing plans, and paying user characteristics |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degraded generation:
- **Payment conversion data**: User count and conversion rate per payment funnel stage
- **Pricing plans** (optional): Product pricing tiers and prices
- **Paying user characteristics** (optional): Key differences between paying and free users

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| revenue-nrr | NRR data update | Payment conversion trends and funnel comparison | Update conversion rate baseline and trend analysis |
| User-provided - full-link data | Data definition change | Funnel calculation and barrier identification | Recompute funnel per new definition |
| User-provided - user characteristics | Segment dimension change | Multi-dimensional breakdown analysis | Re-break down funnel per new dimensions |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| revenue-upsell | Paywall timing change | Write to output file | New paywall timing and trial strategy |
| revenue-orchestrator | Payment funnel analysis complete | Output file updated | Funnel analysis completion status and key conclusions |

## Key Success Metrics

| Metric | Definition | Target Value |
|------|------|--------|
| Active user payment conversion rate | Paying users / Active users | ≥5% |
| Payment funnel overall conversion rate | First-payment users / Registered users | ≥3% |
| Average payment conversion cycle | Average days from registration to first payment | ≤14 days |
| First payment ARPU | Average first payment amount | Continuous improvement |
