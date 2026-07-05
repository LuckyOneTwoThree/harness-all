---
name: business-pricing
description: Used when formulating or optimizing a product pricing strategy. Auto-analyzes pricing strategy with AI suggestions and human approval, analyzing competitor pricing, inferring user willingness to pay, and generating 3 differentiated pricing options.
---
# Pricing Strategy Auto-Analysis

## When to use
- How should we price the product
- How to design pricing options
- Keywords: pricing strategy, competitive analysis, willingness to pay, tier design, unit economics, how to charge, pricing options

## Outputs
- docs/strategy/business-strategy.md
- memory/progress.md

## Core Principles

1. **Three-option comparison** — Must generate 3 differentiated pricing options (penetration/value/hybrid) for human selection
2. **Data-anchored pricing** — Competitor pricing and willingness to pay are hard constraints on pricing; do not price based on gut feeling
3. **Unit economics validation** — Each option must pass feasibility validation through unit economics metrics such as LTV/CAC
4. **Risk surfacing** — Risks such as pricing too low damaging the brand or too high hindering acquisition must be explicitly flagged

**Execution Cycle**: Triggered after Pipeline 2 (Value Proposition Fit) is complete

**Core Objective**: Based on the Business Model Canvas, competitive analysis, and user willingness-to-pay inference, generate 3 differentiated pricing options and complete unit economics analysis.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| BMC Data | JSON | Yes | docs/strategy/business-strategy.md ("Business Model Canvas" section) | Value propositions, revenue models, customer segments, cost structure |
| Competitor Pricing Data | JSON | Yes | docs/discovery/market-analysis.md ("Competitive Analysis" section) | Competitor pricing tiers, market positioning, market share |
| Willingness-to-Pay Inference Data | JSON | ○ | User provided | User willingness-to-pay range, inference method, confidence |

> See [Reference/examples.md](./Reference/examples.md) → "Inputs examples" for BMC Data, Competitor Pricing Data, and Willingness-to-Pay Inference Data JSON examples.

## Execution Steps

### Step 1: Competitor Pricing Matrix Analysis [Core]

**Task**: Integrate and systematically analyze competitor pricing strategies.

**Execution Logic**:
1. Collect competitor pricing data
2. Classify by price range and target market
3. Analyze pricing structure patterns (number of tiers, feature differentiation points)
4. Identify market pricing gaps
5. Assess market acceptance of competitor pricing

> See [Reference/examples.md](./Reference/examples.md) → "Step 1: Competitor Pricing Matrix Output" for the output format JSON example.

**Acceptance Criteria**:
- Covers major competitors
- Price range classification is clear
- Market gaps identified accurately

### Step 2: Willingness-to-Pay Inference [Conditional]

**Task**: Infer user willingness to pay based on multiple data sources.

**Inference Method Priority**:
1. Direct survey data (highest confidence)
2. Conjoint analysis results
3. Market analog method
4. Comparative judgment method

**Execution Logic**:
1. Integrate results from multiple inference methods
2. Calculate weighted average for a comprehensive willingness-to-pay range
3. Analyze by user segment
4. Assess inference confidence

> See [Reference/examples.md](./Reference/examples.md) → "Step 2: Willingness-to-Pay Analysis Output" for the output format JSON example.

**Acceptance Criteria**:
- Inference method is transparent
- Confidence has a basis
- Segment differences analyzed

### Step 3: Pricing Option Generation [Core]

**Task**: Generate 3 differentiated pricing options.

#### Option A: Penetration Pricing

**Positioning**: Market entry strategy, rapidly acquiring users at a competitive price

**Execution Logic**:
1. Reference competitor low-to-mid pricing
2. Consider the lower bound of willingness to pay
3. Set an acceptable early-stage loss tolerance period
4. Design conversion paths

> See [Reference/examples.md](./Reference/examples.md) → "Step 3 - Option A: Penetration Pricing" for the tier structure JSON example.

#### Option B: Value-Based Pricing

**Positioning**: Mid-to-high-end pricing based on value perception

**Execution Logic**:
1. Anchor to the optimal range of user willingness to pay
2. Emphasize the value premium of differentiated value
3. Design clear feature tiering
4. Include some bundled value

> See [Reference/examples.md](./Reference/examples.md) → "Step 3 - Option B: Value-Based Pricing" for the tier structure JSON example.

#### Option C: Hybrid Pricing

**Positioning**: Tiered coverage, maximizing market coverage and revenue potential

**Execution Logic**:
1. Introduce a free tier to build a user base
2. Middle tier as the primary revenue driver
3. High-end tier to capture high-value customers
4. Design a clear upgrade path

> See [Reference/examples.md](./Reference/examples.md) → "Step 3 - Option C: Hybrid Pricing" for the tier structure JSON example.

## Output

**Storage Path**: `docs/strategy/business-strategy.md ("Pricing Strategy" section)`

**Output File**: pricing_analysis.json

> See [Reference/schema.md](./Reference/schema.md) for output validation rules, complete pricing analysis report JSON, and data flow specification (input/output directories).

## Decision Rules

### Willingness-to-Pay Confidence Rules

**Handling when confidence < 0.5**:
1. Flag recommendation for pre-sale testing validation
2. Provide minimum sample size needed to reduce uncertainty
3. Recommend a conservative pricing strategy as an alternative
4. Explicitly flag that pricing numbers require human sign-off

### Pricing Number Rules

**Decisions requiring human sign-off**:
- Specific pricing numbers (for any option)
- Tier structure design
- Discount levels
- Timing of price adjustments

### AI Assistance Scope

**Analysis AI can complete automatically**:
- Competitor data integration and visualization
- Willingness-to-pay range inference
- Unit economics calculations
- Sensitivity analysis
- Option comparison table generation

## Quality Checks

### Self-Check List

- [ ] 3 pricing options generated (P0)
- [ ] Each option includes differentiated positioning (P0)
- [ ] Unit economics calculations correct: (P1)
  - ARPU calculation logic correct
  - CAC allocation reasonable
  - LTV calculation includes retention assumptions
  - Break-even analysis complete
- [ ] Risks fully flagged (P1)
- [ ] Competitor matrix covers major competitors (P0)
- [ ] Willingness-to-pay inference method transparent (P2)

### Calculation Validation

**Unit Economics Validation Checklist**:
- [ ] ARPU = Σ(tier price × tier user share) (P1)
- [ ] CAC includes acquisition costs (ads, BD, etc.) allocation (P1)
- [ ] LTV = ARPU × average lifetime (months) (P1)
- [ ] Payback period = CAC / (ARPU - marginal cost) (P2)
- [ ] LTV/CAC ≥ 3 (healthy standard) (P2)

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently.

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Degradation Strategy" for the full degradation table (missing input scenarios, impact, and data acquisition instructions).

## Data Acquisition Instructions

This Skill requires BMC and competitor pricing data. Please provide via one of the following methods:
  1. Directly describe product features, target users, and pricing expectations
  2. Upload bmc.json / competitor-analysis.json files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

---

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Upstream Change Impact Table" and "Downstream Notification Mechanism Table" for change impact and notification details.

---

## Human Review Checklist

Before submitting for human approval, ensure the following content is presented:

### Competitor Analysis
- [ ] Major competitor pricing covered
- [ ] Price range distribution clear
- [ ] Market gaps identified

### Willingness to Pay
- [ ] Inference method explained
- [ ] Confidence annotated
- [ ] Segment differences analyzed

### Pricing Options
- [ ] 3 options have clearly differentiated positioning
- [ ] Unit economics metrics calculated
- [ ] Risks flagged
- [ ] Option pros/cons comparison clear

### Recommendation
- [ ] Recommended option has clear rationale
- [ ] Alternative option provided
- [ ] Information needed for decision-making complete
