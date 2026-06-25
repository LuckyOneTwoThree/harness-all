---
name: analysis-funnel
description: Use when analyzing user conversion paths. Funnel Auto-Analysis, AI automatically executes full funnel calculation, multi-dimensional drill-down, drop-off node identification, and trend analysis. Keywords: funnel analysis, conversion analysis, drop-off node, conversion rate, user path, where users drop off, conversion too low, users can't complete the flow.
---
# Funnel Auto-Analysis

## When to use
- Registration flow conversion rate is too low, help me analyze
- At which step do users drop off the most
- Take a look at the payment conversion funnel

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

**Output Schema**:

```json
{
  "type": "object",
  "required": ["funnel_name", "steps", "overall_conversion"],
  "properties": {
    "funnel_name": {"type": "string", "description": "Funnel name"},
    "date_range": {"type": "object", "description": "Analysis time range, including start and end dates"},
    "steps": {"type": "array", "description": "Funnel step data, including event name, count, and conversion rate"},
    "overall_conversion": {"type": "number", "description": "Overall conversion rate"},
    "vs_last_period": {"type": "object", "description": "Comparison with previous period, including change trend and key steps"},
    "critical_drop": {"type": "object", "description": "Critical drop-off analysis, including dimension breakdown and potential causes"}
  }
}
```

```yaml
funnel_analysis:
  analysis_time: "2024-01-15T10:00:00Z"
  
  # Funnel basic info
  funnel_name: "E-commerce Purchase Conversion Funnel"
  date_range:
    start: "2024-01-08"
    end: "2024-01-14"
  
  # Funnel step data
  steps:
    - step: 1
      name: "Product Detail Page View"
      event: "product_view"
      count: 500000
      conversion_from_previous: 100.0  # First step is 100%
      
    - step: 2
      name: "Add to Cart"
      event: "add_to_cart"
      count: 80000
      conversion_from_previous: 16.0
      dropoff_from_previous: 420000
      
    - step: 3
      name: "Start Checkout"
      event: "checkout_start"
      count: 50000
      conversion_from_previous: 62.5
      dropoff_from_previous: 30000
      
    - step: 4
      name: "Complete Payment"
      event: "purchase_complete"
      count: 35000
      conversion_from_previous: 70.0
      dropoff_from_previous: 15000
  
  # Overall conversion rate
  overall_conversion: 7.0  # From first step to final payment
  
  # Comparison with previous period
  vs_last_period:
    change_pct: -5.2
    trend: "declining"
    significant_steps:
      - step: 2  # Add-to-cart conversion declined
        change: -8.3
      - step: 3  # Checkout conversion declined
        change: -3.1
  
  # Critical drop-off analysis
  critical_drop:
    step: 1_to_2  # From browse to add-to-cart
    dropoff_rate: 84.0  # Drop-off rate
    affected_users: 420000
    
    dimension_breakdown:
      platform:
        iOS: 82.0
        Android: 85.0
        Web: 88.0
      user_type:
        new_users: 78.0
        returning_users: 86.0
      traffic_source:
        search: 75.0
        recommendation: 90.0
        direct: 80.0
    
    potential_causes:
      - "Product price higher than user expectation"
      - "Detail page information not attractive enough"
      - "Recommendation algorithm not precise enough"
    
    optimization_suggestions:
      - "Optimize product pricing strategy"
      - "Improve detail page design and content"
      - "Optimize recommendation algorithm, improve relevance"
  
  # Detailed report links
  reports:
    funnel_chart: "docs/metrics/data-analysis-report.md (\"Funnel Analysis\" section)"
    trend_chart: "docs/metrics/data-analysis-report.md (\"Funnel Analysis\" section)"
    dimension_data: "docs/metrics/data-analysis-report.md (\"Funnel Analysis\" section)"
```

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

| Field Path | Type | Required | Description |
|----------|------|------|------|
| funnel_analysis | object | Yes | Funnel analysis root object |
| funnel_analysis.funnel_name | string | Yes | Funnel name |
| funnel_analysis.date_range | object | Yes | Analysis time range |
| funnel_analysis.date_range.start | string | Yes | Start date |
| funnel_analysis.date_range.end | string | Yes | End date |
| funnel_analysis.steps | array | Yes | Funnel step data, at least 2 steps |
| funnel_analysis.steps[].step | number | Yes | Step number |
| funnel_analysis.steps[].name | string | Yes | Step name |
| funnel_analysis.steps[].event | string | Yes | Event name |
| funnel_analysis.steps[].count | number | Yes | User count |
| funnel_analysis.steps[].conversion_from_previous | number | Yes | Step-to-step conversion rate |
| funnel_analysis.overall_conversion | number | Yes | Overall conversion rate |
| funnel_analysis.vs_last_period | object | Yes | Comparison with previous period |
| funnel_analysis.critical_drop | object | Yes | Critical drop-off analysis |
| funnel_analysis.critical_drop.step | string | Yes | Drop-off step |
| funnel_analysis.critical_drop.dropoff_rate | number | Yes | Drop-off rate |
| funnel_analysis.critical_drop.potential_causes | array | Yes | Potential causes list |

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
