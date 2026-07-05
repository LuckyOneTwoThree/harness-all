---
name: metrics-system
description: Use when building a product metrics system. Metrics System Auto-Construction includes North Star metric validation and recommendation, L1/L2 metric breakdown, actionable metric identification, and vanity metric detection.
---
# Metrics System Auto-Construction

## When to use
- Help me organize the product's core metrics
- Validate the North Star metric selected by planning-north-star
- Build a metrics system (L1/L2 breakdown + tracking + dashboard)
- Keywords: metrics system, AARRR model, North Star metric, L1/L2 metrics, OSM model, measurement system, define metrics, core data

> **Ownership boundary**: North Star SELECTION (candidate generation + human decision) is owned by `planning-north-star`. This skill owns North Star VALIDATION (vanity-metric detection, product-type-fit scoring) + L1/L2 breakdown. If no North Star has been selected yet, route to `planning-north-star` first. The "North Star Not Defined" auto-recommendation branch below is a standalone-fallback only (when planning-north-star is unavailable).

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/metrics/metrics-system.md
- metric_system.json

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

> See [Reference/examples.md](./Reference/examples.md) for the product_context and existing_metrics JSON examples and product_type enum values.

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

> See [Reference/examples.md](./Reference/examples.md) for the Branch A Output JSON example.

---

#### Branch B: North Star Not Defined

When `product_context.north_star_metric` is not defined:

**Auto-Recommendation Logic**:

```
Based on product_context.product_type and business_model
Generate 3 North Star metric candidates
```

> See [Reference/examples.md](./Reference/examples.md) for the Product Type → North Star Metric Mapping table and Branch B Output JSON example.

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

> See [Reference/examples.md](./Reference/examples.md) for the North Star → L1 Weight Mapping example (E-commerce) and L1 Output JSON example.

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

> See [Reference/examples.md](./Reference/examples.md) for the L1 → L2 Breakdown example, L2 Metric Categories table, and L2 Output JSON example.

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

> See [Reference/examples.md](./Reference/examples.md) for the Actionable Metric Mapping example and Actionable Metrics Output JSON example.

---

### Step 5: Vanity Metric Auto-Detection [Deep]

**🤖 AI Processing**

**Detection Rules**: 4 rules covering Only-Increasing, No Time Bound, No Causal Link, and Non-Actionable detection. Each rule includes detection logic and problem metric examples with suggested replacements.

> See [Reference/examples.md](./Reference/examples.md) for the 4 detection rules, Problem Metric Examples, and Detection Result Output JSON example.

---

## Output

**Storage Path**: `docs/metrics/metrics-system.md`

**Output File**: `metric_system.json`

> See [Reference/schema.md](./Reference/schema.md) for the Output Schema (top-level + metric_system nested object) and Output Validation Rules table.

---

## Decision Rules

### Rule 1: North Star Metric Final Selection by Human

**Trigger**: `north_star_metric` not defined in product_context AND AI generated 3 North Star metric candidates.

**Execution Flow**: AI generates 3 candidates → Human product owner selects final North Star → Record selection rationale → Continue with subsequent steps.

**Human Decision Elements**: ✅ Reflects core user value / ✅ Directly influenced by team / ✅ Matches business stage / ✅ Data collection conditions met / ✅ Easy for whole company to understand.

---

### Rule 2: Vanity Metric Handling Plan Requires Advisory Approval

**Trigger**: High-severity vanity metrics exist AND AI recommended replacement metric plan.

**Execution Flow**: AI detects vanity metrics and generates recommendations → Mark metrics requiring approval → Human confirms (or modifies) handling plan → Execute metric replacement or deletion.

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

> See [Reference/examples.md](./Reference/examples.md) for the Escalation Output JSON example.

---
