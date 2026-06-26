# Metrics System Examples

This document contains all JSON examples, mapping tables, and detection rules referenced by the Metrics System Auto-Construction skill.

## Input Examples

### product_context (Required)

```json
{
  "product_type": "string",        // Product type enum
  "north_star_metric": "string",   // Validate if defined, otherwise auto-recommend
  "okr": {
    "objective": "string",         // Current phase objective
    "key_results": ["string"]     // Key results
  },
  "business_model": "string"       // Business model description
}
```

**product_type enum values**:
- `social` - Social product
- `ecommerce` - E-commerce product
- `saas` - SaaS product
- `content` - Content platform
- `gaming` - Gaming product
- `fintech` - Fintech
- `education` - Online education
- `healthcare` - Healthcare
- `other` - Other

---

### existing_metrics (Optional)

```json
[
  {
    "name": "string",
    "definition": "string",
    "calculation": "string",
    "data_source": "string",
    "layer": "north_star|l1|l2|actionable"
  }
]
```

---

## Step 1: North Star Metric Validation

### Branch A Output (North Star Already Defined)

```json
{
  "north_star": {
    "name": "string",
    "definition": "string",
    "calculation": "string",
    "data_source": "string",
    "validation": {
      "is_valid": true,
      "is_vanity_free": true,
      "product_type_match": 0.85,
      "issues": []
    }
  }
}
```

---

### Branch B Output (North Star Not Defined)

```json
{
  "north_star_candidates": [
    {
      "rank": 1,
      "name": "string",
      "definition": "string",
      "calculation": "string",
      "data_source": "string",
      "pros": ["string"],
      "cons": ["string"],
      "recommendation_score": 0.85
    }
  ],
  "requires_human_decision": true
}
```

---

### Product Type → North Star Metric Mapping

| Product Type | Recommended North Star Metric Candidates |
|---------|------------------|
| Social | 1. DAU × Average interactions per user<br>2. Daily messaging users<br>3. Social network density (active friend ratio) |
| E-commerce | 1. GMV<br>2. Paid orders<br>3. Active buyers × Average order value |
| SaaS | 1. Paid ARR<br>2. Weekly active users of core feature<br>3. NRR (Net Revenue Retention) |
| Content | 1. Total user time spent<br>2. Per-capita content consumption × Consuming users<br>3. Content interaction rate |
| Gaming | 1. DAU<br>2. DAU × Average session length<br>3. Paying user LTV |
| Fintech | 1. Active user loan/wealth management conversion rate<br>2. AUM (Assets Under Management)<br>3. Risk approval rate × Loan disbursement |
| Online Education | 1. Course completion rate × Paying students<br>2. Student completion rate × NPS<br>3. Active learning users × Per-capita learning time |
| Healthcare | 1. Core service usage rate<br>2. User health metric improvement rate<br>3. User satisfaction × Repurchase rate |

---

## Step 2: L1 Metric Auto-Breakdown

### North Star → L1 Weight Mapping Example (E-commerce)

| North Star Metric | Acquisition Weight | Activation Weight | Retention Weight | Revenue Weight | Referral Weight |
|-----------|----------------|---------------|-------------|-----------|-------------|
| GMV | 0.15 | 0.15 | 0.25 | 0.35 | 0.10 |
| Paid orders | 0.20 | 0.25 | 0.20 | 0.25 | 0.10 |
| Active buyers × AOV | 0.20 | 0.15 | 0.30 | 0.25 | 0.10 |

### L1 Output

```json
{
  "l1_metrics": [
    {
      "layer": "Acquisition",
      "name": "User Acquisition",
      "weight": 0.20,
      "calculation": "string",
      "data_source": "string",
      "relationship_to_north_star": "Direct positive correlation",
      "l2_metrics_count": 3
    }
  ]
}
```

---

## Step 3: L2 Metric Auto-Breakdown

### L1 → L2 Breakdown Example (E-commerce - Activation)

```json
{
  "l1": "User Activation",
  "l2_metrics": [
    {
      "name": "New user first-order conversion rate",
      "calculation": "New users with first order / Total new users",
      "data_source": "Order system",
      "is_actionable": true,
      "optimization_team": "Growth team"
    }
    // ... Same structure can be extended: new user activation time, core feature first-use rate, onboarding completion rate, etc.
  ]
}
```

### L2 Metric Categories

| Type | Description | Example |
|-----|------|------|
| Conversion Rate | Funnel step conversions | Click-through rate, registration rate, payment rate |
| Frequency | User usage frequency | Per-capita usage count, per-capita usage time |
| Quality | Usage effect/quality | Satisfaction score, feature usage depth |
| Efficiency | Operational efficiency metrics | Page load time, response time |
| Coverage | Feature/content coverage | Category coverage rate, feature usage rate |

### L2 Output

```json
{
  "l1_metrics": [
    {
      "layer": "Activation",
      "name": "User Activation",
      "l2_metrics": [
        {
          "name": "string",
          "calculation": "string",
          "data_source": "string",
          "type": "conversion_rate|frequency|quality|efficiency|coverage",
          "is_actionable": true,
          "optimization_team": "string"
        }
      ]
    }
  ]
}
```

---

## Step 4: Actionable Metric Auto-Identification

### Actionable Metric Mapping Example

| L2 Metric | Actionable Metric | Optimization Direction |
|-------|---------|---------|
| New user activation time | Average registration flow duration | Simplify registration steps |
| First-order conversion rate | Onboarding flow conversion rate | Optimize onboarding copy |
| Core feature usage rate | Feature entry click-through rate | Optimize feature entry placement |
| Search result click-through rate | First result click-through rate | Optimize ranking algorithm |

### Actionable Metrics Output

```json
{
  "actionable_metrics": [
    {
      "name": "Average registration flow duration",
      "linked_l2": "New user activation time",
      "linked_l1": "User Activation",
      "optimization_approach": "Validate the effect of simplifying registration steps via A/B testing",
      "estimated_impact": "Each 1-second reduction can increase activation rate by 3%",
      "measurement_method": "A/B testing"
    }
  ]
}
```

---

## Step 5: Vanity Metric Auto-Detection

### Detection Rules and Problem Metric Examples

#### Rule 1: Only-Increasing Detection

```
IF metric calculation meets any of the following:
  - Cumulative value (no time dimension)
  - Irreversible metric
THEN mark as "only-increasing" vanity metric
```

**Problem Metric Examples**:
- ❌ Cumulative user count → ✅ Daily Active Users
- ❌ Total registrations → ✅ Daily new registrations
- ❌ Total page views → ✅ Per-capita page views

---

#### Rule 2: No Time Bound Detection

```
IF metric definition has no clear time dimension:
  - No defined statistical period
  - Cannot calculate change trend
THEN mark as "no time bound" vanity metric
```

**Problem Metric Examples**:
- ❌ Total users → ✅ DAU / MAU
- ❌ Total revenue → ✅ Monthly MRR / Annual ARR

---

#### Rule 3: No Causal Link Detection

```
IF metric cannot meet any of the following:
  - Can be linked to North Star metric
  - Can guide specific action
  - Can be attributed to specific cause
THEN mark as "no causal link" vanity metric
```

**Problem Metric Examples**:
- Feature usage rate unrelated to core value
- Multiple independent metrics that cannot form a logical chain

---

#### Rule 4: Non-Actionable Detection

```
IF metric cannot meet any of the following:
  - Can be influenced by a specific team
  - Can be changed via product/operations means
  - Can show effect within a reasonable time
THEN mark as "non-actionable" vanity metric
```

**Problem Metric Examples**:
- ❌ Brand awareness → ✅ Brand keyword search volume
- ❌ User satisfaction → ✅ NPS sub-metrics
- ❌ Market share → ✅ Vertical market penetration rate

---

### Detection Result Output

```json
{
  "vanity_alerts": [
    {
      "metric_name": "Cumulative user count",
      "alert_type": "only-increasing",
      "severity": "high",
      "recommendation": "Replace with 'Daily Active Users' or 'Monthly Active Users'",
      "suggested_replacement": {
        "name": "DAU",
        "calculation": "Active users on the day"
      }
    }
    // ... Same structure can be extended: no time bound, no causal link, non-actionable, etc.
  ],
  "summary": {
    "total_detected": 2,
    "high_severity": 1,
    "medium_severity": 1,
    "all_resolved": false
  }
}
```

---

## Escalation Output

```json
{
  "escalation": {
    "trigger": "string",
    "reason": "string",
    "current_status": {},
    "ai_recommendation": {},
    "requires_human_action": true,
    "human_decision_needed": [
      "North Star metric selection",
      "Vanity metric handling plan"
    ]
  }
}
```
