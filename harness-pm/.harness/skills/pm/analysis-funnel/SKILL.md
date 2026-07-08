---
name: analysis-funnel
description: Use when analyzing user conversion paths. Funnel Auto-Analysis, AI automatically executes full funnel calculation, multi-dimensional drill-down, drop-off node identification, and trend analysis.
---
# Funnel Auto-Analysis

## When to use
- Registration flow conversion rate is too low, help me analyze
- At which step do users drop off the most
- Take a look at the payment conversion funnel
- Keywords: funnel analysis, conversion analysis, drop-off node, conversion rate, user path, where users drop off, conversion too low, users can't complete the flow

## Outputs
- docs/metrics/data-analysis-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Drop-off equals opportunity**: Every drop-off node is an optimization entry point; the biggest drop-off point = biggest improvement space
2. **Drill-down enables attribution**: Overall conversion rate only tells you "there's a problem"; multi-dimensional drill-down tells you "where the problem is"
3. **Comparison enables judgment**: Absolute values are meaningless; period-over-period and year-over-year comparisons can judge trend health

## Interaction Mode

🤖 AI Auto-Execution (Data Analysis Type)

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| Funnel Definition | object | Yes | User-provided | Step definitions and event configuration for the funnel |
| Event Data | object | Yes | User-provided | Tracking event data |
| Segment Config | object | ○ | User-provided | Optional user segmentation dimensions |
| Comparison Period | string | ○ | User-provided | Which time period to compare against |

## Supported Funnel Types

| Type | Example |
|-----|------|
| Conversion Funnel | Browse → Click → Add to Cart → Place Order → Pay |
| Activation Funnel | Register → First Use → Complete Onboarding |
| Payment Funnel | Impression → Click → Detail → Pay → Repurchase |
| Search Funnel | Search → Results Page → Detail Page → Add to Cart |

## Execution Steps

### Step 1: Full Funnel Calculation [Core]

```
Get funnel definition
├── Query event data for each step
├── Calculate user count per step
├── Calculate step-to-step conversion rate
└── Calculate overall conversion rate
```

### Step 2: Multi-Dimensional Drill-Down [Core]

Split and analyze the funnel across multiple dimensions:

| Dimension | Split Items |
|-----|--------|
| Platform | iOS, Android, Web, Mini Program |
| Channel | Organic traffic, paid channels, referral sources |
| User Type | New/Returning users, Paid/Free, High-value/Regular |
| Version | Grouped by App version |
| Region | Grouped by country/province |
| Time | Grouped by hour/day/week |

### Step 3: Biggest Drop-off Node Identification [Core]

```
Analyze drop-off rate for each step
├── Find the step with the highest drop-off rate
├── Analyze characteristics of dropped users at this step
├── Correlate user behaviors before drop-off
└── Identify drop-off cause hypotheses
```

### Step 4: Trend Analysis [Core]

- **Time Trend**: Daily/weekly/monthly changes in conversion rate per step
- **Comparative Analysis**: Compare with previous period
- **Forecast**: Predict future performance based on trends

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Funnel analysis and conversion bottlenecks | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full analysis + funnel segment breakdown + conversion optimization simulation + multi-dimensional attribution analysis | Full artifact + extended analysis + deep inference |

## Output

**Storage Path**: `docs/metrics/data-analysis-report.md ("Funnel Analysis" section)`
**Output File**: funnel_analysis.json

**Output Schema**, complete funnel_analysis YAML example, and **field validation rules**:

> See [Reference/output-schema.md](./Reference/output-schema.md) for the output JSON schema (funnel_name, date_range, steps, overall_conversion, vs_last_period, critical_drop), a complete funnel_analysis YAML example (e-commerce purchase funnel with 4 steps, critical drop-off analysis with dimension breakdown and potential causes), and the field validation rules table.

## Multi-Dimensional Drill-Down Example

```yaml
# Platform dimension analysis
platform_breakdown:
  ios:
    step1_count: 200000
    step4_count: 15000
    conversion: 7.5
    vs_avg: +0.5
    
  android:
    step1_count: 250000
    step4_count: 16000
    conversion: 6.4
    vs_avg: -0.6
    
  web:
    step1_count: 50000
    step4_count: 4000
    conversion: 8.0
    vs_avg: +1.0

# User type dimension analysis
user_type_breakdown:
  new_users:
    conversion: 5.2
    main_drop: "step_2_to_3"  # Checkout stage has high drop-off
    
  returning_users:
    conversion: 9.8
    main_drop: "step_1_to_2"  # Add-to-cart stage has high drop-off
```

## Funnel Definition Configuration

```yaml
# Funnel configuration example
funnel_definitions:
  - name: "purchase_conversion"
    description: "E-commerce Purchase Conversion Funnel"
    steps:
      - name: "Product Detail Page View"
        event: "product_view"
        conditions:
          page_type: "product_detail"
          
      - name: "Add to Cart"
        event: "add_to_cart"
        
      - name: "Start Checkout"
        event: "checkout_start"
        
      - name: "Complete Payment"
        event: "purchase_complete"
        conditions:
          payment_status: "success"
    
    conversion_window: 7d  # Counts as conversion if completed within 7 days
    
    exclusion_events:
      - event: "refund_complete"
        window: 30d
```

## Execution Frequency

- **Daily Analysis**: Executes daily at 8:00
- **On-demand Analysis**: Manually triggered for specific funnel analysis
- **Real-time Monitoring**: Real-time monitoring of core conversion nodes

## Output Validation Rules

> See [Reference/output-schema.md](./Reference/output-schema.md#output-validation-rules) for the field validation rules table (funnel_analysis, funnel_name, date_range, steps[], overall_conversion, vs_last_period, critical_drop).

## Upstream Change Response

When upstream inputs change, this skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Funnel definition change | Step configuration and conversion calculation | Re-execute full funnel calculation, mark changed steps |
| Event data update | Conversion rate and drop-off analysis | Incrementally update conversion data, re-evaluate drop-off nodes |
| Segment config change | Multi-dimensional drill-down dimensions | Update drill-down dimensions, re-execute segment analysis |
| Comparison period change | Period-over-period/year-over-year comparison | Re-execute comparison analysis, update trend judgment |

When funnel analysis itself changes, the notification mechanism to downstream:

| Analysis Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Key step conversion rate decline > 10% | decision-dace | Mark alert, trigger insight conversion |
| Drop-off node change | data-analysis-report | Mark drop-off change, trigger report update |
| Overall conversion rate trend change | decision-dace | Mark trend change, trigger DACE Analyze |

---

## Decision Rules

| Situation | Handling Method |
|------|----------|
| Key step conversion rate decline > 10% | Trigger alert, mark as priority optimization item |
| Overall conversion rate below industry benchmark | Generate full-link optimization recommendations |
| New user conversion rate significantly lower than returning users | Recommend optimizing new user onboarding flow |
| Multi-dimensional drill-down finds significant differences | Generate targeted optimization plan |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] Funnel step definition complete, no omissions
- [ ] Conversion rate calculated based on full data

### P1 Checks (standard/deep must pass)

- [ ] Drop-off node identification includes cause hypotheses
- [ ] Multi-dimensional drill-down covers at least 3 dimensions

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Funnel definition missing | Prompt user to provide funnel steps and per-step data, directly calculate conversion rate | Funnel steps based on user description, may be incomplete |
| Event data missing | User provides funnel steps and per-step data → directly calculate conversion rate | Cannot auto-fetch data, depends on user input |
| Funnel definition + Event data both missing | User provides funnel steps and per-step data → directly calculate conversion rate | Output basic conversion rate calculation, multi-dimensional drill-down marked "to be supplemented" |

- If user does not provide segment config, prompt user to provide or skip steps related to this input
- If user does not provide comparison period, prompt user to provide or skip steps related to this input

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Funnel Steps**: Names and order of each step in the conversion funnel
- **Per-step Data**: User count or event count for each step
- **Comparison Period** (optional): Time period to compare against

## Key Metrics

| Metric | Calculation | Healthy Range |
|-----|---------|---------|
| Overall conversion rate | Final conversion / Entered users | Varies by business |
| Step conversion rate | Next step / Current step | Varies by step |
| Drop-off rate | Dropped users / Previous step users | < 50% ideal |
| Funnel efficiency | Actual conversion / Theoretical optimal | > 60% good |
