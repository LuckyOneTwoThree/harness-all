---
name: metrics-system
description: Use when building a product metrics system. Metrics System Auto-Construction includes North Star metric validation and recommendation, L1/L2 metric breakdown, actionable metric identification, and vanity metric detection. Keywords: metrics system, AARRR model, North Star metric, L1/L2 metrics, OSM model, measurement system, define metrics, core data.
metadata:
  module: "Product Metrics Design"
  sub-module: "Metrics System"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["Internet", "SaaS", "General"]
  trigger_examples:
    - "Help me organize the product's core metrics"
    - "We need to define the North Star metric"
    - "Build a metrics system"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Output North Star metric validation results and L1 metric breakdown"
  deep_description: "Full L1/L2 breakdown + actionable metric identification + vanity metric detection + metric health scoring + metric correlation analysis"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/strategy/OKR.md
  - docs/strategy/business-strategy.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - docs/metrics/metrics-system.md
  - metric_system.json
---

# Metrics System Auto-Construction

## Core Principles

1. **Full Analysis**: Systematically analyze all available data without missing key dimensions
2. **Real-time Awareness**: Metrics system design supports real-time monitoring and rapid response
3. **Automated Attribution**: Anomaly fluctuations are automatically attributed to specific causes, reducing manual investigation
4. **Explicit Decision Rules**: Every alert and escalation condition has clear quantitative rules

## Interaction Mode

**🤖→👤 AI Suggests, Human Approves**

This pipeline is automatically executed by AI for metrics system construction, but key decision points require human approval:
- **Must Approve**: North Star metric selection
- **Recommended to Approve**: Vanity metric handling plan

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| product_context | JSON | Yes | docs/strategy/OKR.md + docs/strategy/business-strategy.md ("Business Model Canvas" section) / User-provided | Product type, North Star metric, OKR, business model |
| existing_metrics | JSON array | ○ | User-provided | Existing metrics list (with name, definition, calculation, data source, layer) |

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

## Execution Steps

### Step 1: North Star Metric Validation [Core]

**🤖 AI Processing**

#### Branch A: North Star Already Defined

When `product_context.north_star_metric` is defined:

**Validation Items**:
1. **Definition Clarity Check**
   - Has a clear calculation formula
   - Has a clear data source
   - Can be decomposed into sub-metrics

2. **Vanity Metric Detection**
   ```
   IF meets any of the following conditions THEN mark as potential vanity metric
     - Only increases, never decreases (no time dimension)
     - No causal link (cannot guide action)
     - Not actionable (cannot be influenced by the team)
   ```

3. **Product Type Fit**
   ```
   score = North Star metric recommendation score based on product type
   IF score < 0.6 THEN suggest re-selecting North Star
   ```

**Output**:
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

#### Branch B: North Star Not Defined

When `product_context.north_star_metric` is not defined:

**Auto-Recommendation Logic**:

```
Based on product_context.product_type and business_model
Generate 3 North Star metric candidates
```

**Product Type → North Star Metric Mapping**:

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

**Output**:
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

### Step 2: L1 Metric Auto-Breakdown [Core]

**🤖 AI Processing**

**Input**: North Star metric definition

**Breakdown Logic**:

Based on the AARRR model, decompose the North Star metric into 5 L1 dimensions (3-5 may be selected depending on product type):

```
North Star Metric
  ↓ Breakdown
L1 Dimensions (by AARRR)
  ├── Acquisition
  ├── Activation
  ├── Retention
  ├── Revenue
  └── Referral
```

**Breakdown Rules**:

```
FOR each L1 dimension:
  1. Identify correlation with North Star
  2. Calculate weight (based on correlation strength)
  3. Define L1 metric
  4. Ensure L1 metric is independently measurable
```

**North Star → L1 Weight Mapping Example** (E-commerce):

| North Star Metric | Acquisition Weight | Activation Weight | Retention Weight | Revenue Weight | Referral Weight |
|-----------|----------------|---------------|-------------|-----------|-------------|
| GMV | 0.15 | 0.15 | 0.25 | 0.35 | 0.10 |
| Paid orders | 0.20 | 0.25 | 0.20 | 0.25 | 0.10 |
| Active buyers × AOV | 0.20 | 0.15 | 0.30 | 0.25 | 0.10 |

**Output**:
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

### Step 3: L2 Metric Auto-Breakdown [Conditional]

**🤖 AI Processing**

**Input**: L1 metric list

**Breakdown Logic**:

```
FOR each L1 metric:
  Break down 3-5 L2 metrics
  Ensure each L2 metric:
    1. Has a clear mathematical relationship with L1
    2. Is independently measurable
    3. Has a clear data source
    4. Can be owned by a specific team
```

**L1 → L2 Breakdown Example** (E-commerce - Activation):

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

**L2 Metric Categories**:

| Type | Description | Example |
|-----|------|------|
| Conversion Rate | Funnel step conversions | Click-through rate, registration rate, payment rate |
| Frequency | User usage frequency | Per-capita usage count, per-capita usage time |
| Quality | Usage effect/quality | Satisfaction score, feature usage depth |
| Efficiency | Operational efficiency metrics | Page load time, response time |
| Coverage | Feature/content coverage | Category coverage rate, feature usage rate |

**Output**:
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

### Step 4: Actionable Metric Auto-Identification [Conditional]

**🤖 AI Processing**

**Identification Logic**:

```
FOR each L2 metric:
  IF can be directly influenced by a specific team AND
     can be validated via A/B testing AND
     has a clear optimization path
  THEN mark as actionable metric
```

**Actionable Metric Characteristics**:

1. **Attributable**: Can be traced to specific causes
2. **Actionable**: Can be acted upon by a specific team
3. **Validatable**: Can be validated via A/B testing
4. **Iterable**: Can be continuously optimized in short cycles

**Actionable Metric Mapping Example**:

| L2 Metric | Actionable Metric | Optimization Direction |
|-------|---------|---------|
| New user activation time | Average registration flow duration | Simplify registration steps |
| First-order conversion rate | Onboarding flow conversion rate | Optimize onboarding copy |
| Core feature usage rate | Feature entry click-through rate | Optimize feature entry placement |
| Search result click-through rate | First result click-through rate | Optimize ranking algorithm |

**Output**:
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

### Step 5: Vanity Metric Auto-Detection [Deep]

**🤖 AI Processing**

**Detection Rules**:

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

**Detection Result Output**:

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

## Output

**Storage Path**: `docs/metrics/metrics-system.md`

**Output File**: `metric_system.json`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["metric_system"],
  "properties": {
    "metric_system": {"type": "object", "description": "Metrics system, including North Star metric, L1/L2 metrics, actionable metrics, and vanity metric alerts"}
  }
}
```

### metric_system

```json
{
  "metric_system": {
    "north_star": {
      "name": "string",
      "definition": "string",
      "calculation": "string",
      "data_source": "string",
      "validation": { "is_vanity_free": true, "validation_date": "2026-05-08" }
    },
    "l1_metrics": [
      {
        "layer": "Acquisition|Activation|Retention|Revenue|Referral",
        "name": "string",
        "weight": 0.20,
        "calculation": "string",
        "data_source": "string",
        "l2_metrics": [
          { "name": "string", "calculation": "string", "data_source": "string", "type": "string", "is_actionable": true }
          // ... Same structure can be extended, at least 3 L2 metrics per L1
        ]
      }
      // ... Same structure can be extended, at least 3 L1 dimensions, weights sum to 1.0
    ],
    "actionable_metrics": [
      { "name": "string", "linked_l2": "string", "linked_l1": "string", "optimization_approach": "string" }
      // ... Same structure can be extended
    ],
    "vanity_alerts": [
      { "metric_name": "string", "alert_type": "string", "severity": "high|medium|low", "recommendation": "string", "suggested_replacement": {} }
      // ... Same structure can be extended
    ]
  }
}
```

---

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| metric_system | object | Yes | Metrics system root object |
| metric_system.north_star | object | Yes | North Star metric |
| metric_system.north_star.name | string | Yes | North Star metric name |
| metric_system.north_star.definition | string | Yes | North Star metric definition |
| metric_system.north_star.calculation | string | Yes | Calculation formula |
| metric_system.north_star.data_source | string | Yes | Data source |
| metric_system.north_star.validation | object | Yes | Validation result |
| metric_system.north_star.validation.is_vanity_free | boolean | Yes | Whether free of vanity characteristics |
| metric_system.l1_metrics | array | Yes | L1 metric list, at least 3 dimensions |
| metric_system.l1_metrics[].layer | string | Yes | AARRR dimension enum value |
| metric_system.l1_metrics[].name | string | Yes | L1 metric name |
| metric_system.l1_metrics[].weight | number | Yes | Weight, all L1 weights should sum to 1.0 |
| metric_system.l1_metrics[].l2_metrics | array | Yes | L2 metric list, at least 3 per L1 |
| metric_system.l1_metrics[].l2_metrics[].name | string | Yes | L2 metric name |
| metric_system.l1_metrics[].l2_metrics[].calculation | string | Yes | Calculation formula |
| metric_system.l1_metrics[].l2_metrics[].is_actionable | boolean | Yes | Whether it is an actionable metric |
| metric_system.actionable_metrics | array | Yes | Actionable metric list |
| metric_system.actionable_metrics[].name | string | Yes | Actionable metric name |
| metric_system.actionable_metrics[].linked_l2 | string | Yes | Linked L2 metric |
| metric_system.actionable_metrics[].optimization_approach | string | Yes | Optimization approach |
| metric_system.vanity_alerts | array | No | Vanity metric alert list |

---

## Decision Rules

### Rule 1: North Star Metric Final Selection by Human

**Trigger Conditions**:
- `north_star_metric` not defined in product_context
- AI generated 3 North Star metric candidates

**Execution Flow**:

```
1. AI generates 3 North Star metric candidates (with scores)
2. Human product owner selects the final North Star metric
3. Record selection rationale
4. Continue with subsequent steps
```

**Human Decision Elements**:
- ✅ Whether it reflects core user value
- ✅ Whether it can be directly influenced by the team
- ✅ Whether it matches the business development stage
- ✅ Whether data collection conditions are met
- ✅ Whether it is easy for the whole company to understand

---

### Rule 2: Vanity Metric Handling Plan Requires Advisory Approval

**Trigger Conditions**:
- High-severity vanity metrics exist
- AI recommended replacement metric plan

**Execution Flow**:

```
1. AI detects vanity metrics and generates handling recommendations
2. Mark vanity metrics requiring approval
3. Human confirms handling plan (or modifies)
4. Execute metric replacement or deletion
```

---

## Quality Checks

| Check Item | Standard | Action if Not Met |
|--------|------|------------|
| North Star vanity metric detection (P0) | No "only-increasing" characteristic, has time dimension, can be linked to business goals, can be influenced by team | Mark specific issues, re-recommend North Star metric, trigger human decision flow |
| L1-L2 breakdown completeness (P1) | Each L1 layer (Acquisition/Activation/Retention/Revenue/Referral) has 3-5 L2 metrics | Auto-supplement missing L2 metrics, recommend based on AARRR model, mark supplements for human confirmation |
| Actionable metric traceability (P1) | Has clear data source, has executable optimization plan, can be validated via A/B testing | Mark non-traceable metrics, recommend supplementing data tracking, lower metric priority |
| Vanity metric detection coverage (P2) | All metrics have passed vanity metric detection, marking results complete | Supplement detection, mark undetected metrics |

---

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| product_context missing | Prompt user to provide product type and business goals, execute based on user input | North Star recommendation based on user description rather than structured input |
| existing_metrics missing | Skip existing metric validation, build metrics system from scratch | No existing metric comparison, cannot detect redundancy |
| product_context + existing_metrics both missing | User provides product type and business goals → recommend metrics system based on industry template | Output metrics system based on industry template, marked "to be confirmed" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Product Type**: Social/E-commerce/SaaS/Content/Gaming/Fintech/Online Education/Healthcare/Other
- **Business Goal**: Core business goal of the current phase (e.g., increase GMV, improve retention rate, etc.)
- **Business Model**: Product business model description (optional, helps with more accurate recommendation)

## Upstream Change Response

When upstream inputs change, this skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| OKR adjustment | North Star metric, L1 metrics | Mark affected metric layers, recommend human confirmation on whether to update metrics system |
| Business model change | Revenue metric definitions | Mark affected metrics, recommend human confirmation on whether to update |
| PRD feature change | Actionable metrics | Mark affected actionable metrics, recommend human confirmation on whether to update |

When the metrics system itself changes, the notification mechanism to downstream:

| Metric Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| North Star metric change | tracking-plan, metrics-dashboard, monitoring-alert-detection | Mark core metric change, trigger full-chain update |
| L1/L2 metric add/remove | tracking-plan, metrics-dashboard | Mark metric add/remove, trigger tracking and dashboard update |
| Actionable metric change | tracking-plan | Mark actionable metric change, trigger tracking update |
| Metric definition modification | tracking-plan, metrics-dashboard, monitoring-alert-detection | Mark definition change, trigger related skill re-evaluation |

---

## Escalation Path

### Escalation Trigger Conditions

When any of the following conditions are met, escalate to human handling:

1. **North Star Metric Candidate Recommendation Failed**
   - Cannot recommend North Star metric based on product type
   - Recommendation score confidence below 0.5

2. **Vanity Metric Handling Cannot Be Automated**
   - Number of high-severity vanity metrics > 3
   - Replacement metric plan has conflicts

3. **L2 Breakdown Logic Anomaly**
   - L2 metric count out of reasonable range (< 3 or > 10)
   - Cannot establish logical relationship between L2 and L1

---

### Escalation Output

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

---
