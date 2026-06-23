---
name: business-pricing
description: Used when formulating or optimizing a product pricing strategy. Auto-analyzes pricing strategy with AI suggestions and human approval, analyzing competitor pricing, inferring user willingness to pay, and generating 3 differentiated pricing options. Keywords: pricing strategy, competitive analysis, willingness to pay, tier design, unit economics, how to charge, pricing options.
metadata:
  module: "Product Business & Strategy"
  sub-module: "Business Model Design"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["SaaS", "E-commerce", "General"]
  triggers:
    - "How should we price the product"
    - "How to design pricing options"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Generate a competitor pricing matrix overview and 1 recommended pricing option, including basic unit economics validation"
  deep_description: "Additionally includes 3 complete pricing option comparisons, willingness-to-pay multi-method cross-inference, sensitivity analysis, pricing adjustment roadmap, and competitor pricing trend forecasting"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/strategy/business-strategy.md
  - docs/discovery/market-analysis.md
writes:
  - docs/strategy/business-strategy.md
  - memory/progress.md
---

# Pricing Strategy Auto-Analysis

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

### Required Inputs

**BMC Data (from Pipeline 1):**
```json
{
  "value_propositions": [...],
  "revenue_models": [...],
  "customer_segments": [...],
  "cost_structure": {...}
}
```

**Competitor Pricing Data:**
```json
{
  "competitor_pricing": [
    {
      "competitor_name": "Competitor Name",
      "product_name": "Product Name",
      "pricing_tiers": [
        {
          "tier_name": "Tier Name",
          "price": "Price",
          "billing_cycle": "monthly/annual/one-time",
          "features": ["Feature 1", "Feature 2"],
          "target_segment": "Target Users"
        }
      ],
      "market_position": "premium/mid-market/budget",
      "market_share": "Market Share Estimate"
    }
  ]
}
```

**User Willingness-to-Pay Inference Data:**
```json
{
  "willingness_to_pay": {
    "inferred_price_range": {
      "min": "Minimum Price",
      "max": "Maximum Price",
      "optimal": "Optimal Price Estimate"
    },
    "confidence": 0.7,
    "inference_method": "direct_survey/conjoint_analysis/market_analog/comparative_judgment",
    "sample_size": 50,
    "segment_variations": [
      {
        "segment_id": "segment-1",
        "price_sensitivity": "high/medium/low",
        "willingness_range": {"min": "X", "max": "Y"}
      }
    ]
  }
}
```

## Execution Steps

### Step 1: Competitor Pricing Matrix Analysis [Core]

**Task**: Integrate and systematically analyze competitor pricing strategies.

**Execution Logic**:
1. Collect competitor pricing data
2. Classify by price range and target market
3. Analyze pricing structure patterns (number of tiers, feature differentiation points)
4. Identify market pricing gaps
5. Assess market acceptance of competitor pricing

**Output Format:**
```json
{
  "competitor_pricing_matrix": {
    "premium_segment": {
      "price_range": "¥200-500/month",
      "players": ["Competitor A", "Competitor B"],
      "typical_features": ["Full features", "Premium support"],
      "positioning": "Enterprise / high-demand users"
    },
    "mid_market_segment": {
      "price_range": "¥50-200/month",
      "players": ["Competitor C"],
      "typical_features": ["Core features + some premium"],
      "positioning": "Growth-stage teams"
    },
    "budget_segment": {
      "price_range": "¥0-50/month",
      "players": ["Competitor D", "Competitor E"],
      "typical_features": ["Basic features"],
      "positioning": "Individual users / entry-level"
    },
    "market_gaps": [
      {
        "gap_description": "Gap description",
        "target_segment": "Target Users",
        "opportunity": "Opportunity description"
      }
    ]
  }
}
```

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

**Output Format:**
```json
{
  "willingness_to_pay_analysis": {
    "overall_range": {
      "floor": "¥30/month",
      "ceiling": "¥300/month",
      "optimal": "¥80/month"
    },
    "confidence": 0.65,
    "confidence_breakdown": {
      "direct_survey_weight": 0.4,
      "conjoint_analysis_weight": 0.3,
      "market_analog_weight": 0.2,
      "comparative_judgment_weight": 0.1
    },
    "segment_analysis": [
      {
        "segment_id": "segment-1",
        "segment_name": "Segment Name",
        "price_floor": "¥50/month",
        "price_ceiling": "¥200/month",
        "price_optimal": "¥80/month",
        "price_sensitivity": "medium"
      }
    ],
    "key_factors": [
      "Feature completeness is the primary value driver",
      "Competitor price anchoring effect is significant",
      "Annual subscription willingness is higher than monthly"
    ]
  }
}
```

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

**Tier Structure Example:**
```json
{
  "pricing_option_a": {
    "name": "Penetration Pricing",
    "positioning": "Market entry / user acquisition",
    "tiers": [
      {
        "tier_name": "Starter",
        "price": 29,
        "billing_cycle": "monthly",
        "annual_price": 290,
        "features": ["Core features", "5GB storage", "Basic support"],
        "limitations": ["User limit of 5", "No advanced analytics"],
        "target_segment": "Individual users / small teams"
      },
      {
        "tier_name": "Pro",
        "price": 79,
        "billing_cycle": "monthly",
        "annual_price": 790,
        "features": ["Full features", "50GB storage", "Priority support", "API access"],
        "target_segment": "Growth-stage teams"
      }
    ],
    "unit_economics": {
      "average_revenue_per_user": 54,
      "estimated_conversion_rate": "15%",
      "customer_acquisition_cost": 120,
      "payback_period_months": 3,
      "ltv_cac_ratio": 3.5
    },
    "risks": [
      "Pricing too low may damage brand perception",
      "Early-stage losses affect cash flow",
      "Limited room for price adjustments"
    ],
    "recommended_timeline": "Evaluate price increase after 12-18 months"
  }
}
```

#### Option B: Value-Based Pricing

**Positioning**: Mid-to-high-end pricing based on value perception

**Execution Logic**:
1. Anchor to the optimal range of user willingness to pay
2. Emphasize the value premium of differentiated value
3. Design clear feature tiering
4. Include some bundled value

**Tier Structure Example:**
```json
{
  "pricing_option_b": {
    "name": "Value-Based Pricing",
    "positioning": "Value-driven / quality-first",
    "tiers": [
      {
        "tier_name": "Standard",
        "price": 99,
        "billing_cycle": "monthly",
        "annual_price": 990,
        "features": ["Core features+", "20GB storage", "Email support"],
        "target_segment": "Small and medium businesses"
      },
      {
        "tier_name": "Enterprise",
        "price": 299,
        "billing_cycle": "monthly",
        "annual_price": 2990,
        "features": ["Complete features", "Unlimited storage", "Dedicated support", "SSO integration", "SLA guarantee"],
        "target_segment": "Large enterprises"
      }
    ],
    "unit_economics": {
      "average_revenue_per_user": 199,
      "estimated_conversion_rate": "8%",
      "customer_acquisition_cost": 150,
      "payback_period_months": 2,
      "ltv_cac_ratio": 5.2
    },
    "risks": [
      "Higher acquisition difficulty",
      "Requires strong value delivery support"
    ],
    "recommended_timeline": "Continuous execution"
  }
}
```

#### Option C: Hybrid Pricing

**Positioning**: Tiered coverage, maximizing market coverage and revenue potential

**Execution Logic**:
1. Introduce a free tier to build a user base
2. Middle tier as the primary revenue driver
3. High-end tier to capture high-value customers
4. Design a clear upgrade path

**Tier Structure Example:**
```json
{
  "pricing_option_c": {
    "name": "Hybrid Pricing",
    "positioning": "Full coverage / revenue maximization",
    "tiers": [
      {
        "tier_name": "Free",
        "price": 0,
        "features": ["Basic features", "1GB storage", "Community support"],
        "limitations": ["Limited features", "Usage limits"],
        "target_segment": "Individual users / trial"
      },
      {
        "tier_name": "Paid",
        "price": 59,
        "billing_cycle": "monthly",
        "annual_price": 590,
        "features": ["Advanced features", "30GB storage", "Priority support"],
        "target_segment": "Professional users"
      },
      {
        "tier_name": "Team",
        "price": 199,
        "billing_cycle": "monthly",
        "annual_price": 1990,
        "features": ["Team collaboration", "100GB storage", "Dedicated CSM", "Advanced permissions"],
        "target_segment": "Teams / departments"
      }
    ],
    "unit_economics": {
      "average_revenue_per_user": 89,
      "free_to_paid_conversion": "5%",
      "paid_tier_conversion": "12%",
      "customer_acquisition_cost": 80,
      "payback_period_months": 2.5,
      "ltv_cac_ratio": 4.2
    },
    "risks": [
      "Free tier operational costs",
      "Pricing tier management complexity",
      "Internal cannibalization may occur"
    ],
    "recommended_timeline": "Adjust tiers based on early data"
  }
}
```

## Output

**Storage Path**: `docs/strategy/business-strategy.md ("Pricing Strategy" section)`

**Output File**: pricing_analysis.json

### Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| pricing_analysis.competitor_pricing_matrix | object | Yes | Includes premium/mid/budget three-segment analysis |
| pricing_analysis.competitor_pricing_matrix.premium_segment | object | No | Premium market segment |
| pricing_analysis.competitor_pricing_matrix.premium_segment.price_range | string | Conditionally required | Premium price range |
| pricing_analysis.competitor_pricing_matrix.premium_segment.players | string[] | Conditionally required | Premium market competitor list |
| pricing_analysis.competitor_pricing_matrix.mid_market_segment | object | No | Mid-market segment |
| pricing_analysis.competitor_pricing_matrix.mid_market_segment.price_range | string | Conditionally required | Mid-market price range |
| pricing_analysis.competitor_pricing_matrix.mid_market_segment.players | string[] | Conditionally required | Mid-market competitor list |
| pricing_analysis.competitor_pricing_matrix.budget_segment | object | No | Budget market segment |
| pricing_analysis.competitor_pricing_matrix.budget_segment.price_range | string | Conditionally required | Budget price range |
| pricing_analysis.competitor_pricing_matrix.budget_segment.players | string[] | Conditionally required | Budget market competitor list |
| pricing_analysis.willingness_to_pay | object | Yes | Includes overall range, confidence, segment analysis |
| pricing_analysis.willingness_to_pay.overall_range | object | Yes | Overall willingness-to-pay range |
| pricing_analysis.willingness_to_pay.overall_range.floor | string | Yes | Price floor |
| pricing_analysis.willingness_to_pay.overall_range.ceiling | string | Yes | Price ceiling |
| pricing_analysis.willingness_to_pay.confidence | number | Yes | Inference confidence, 0-1 |
| pricing_analysis.willingness_to_pay.segment_analysis | array | No | Willingness-to-pay analysis by segment |
| pricing_analysis.willingness_to_pay.segment_analysis[].segment_name | string | Yes | Segment name |
| pricing_analysis.willingness_to_pay.segment_analysis[].price_sensitivity | string | Yes | Price sensitivity, enum: high/medium/low |
| pricing_analysis.pricing_options.option_a | object | Yes | Penetration pricing option, includes tiers and unit_economics |
| pricing_analysis.pricing_options.option_a.tiers | array | Yes | Tier list, at least 1 |
| pricing_analysis.pricing_options.option_a.tiers[].tier_name | string | Yes | Tier name, cannot be empty |
| pricing_analysis.pricing_options.option_a.tiers[].price | number | Yes | Price |
| pricing_analysis.pricing_options.option_a.tiers[].features | string[] | Yes | Included features list |
| pricing_analysis.pricing_options.option_a.unit_economics | object | Yes | Unit economics metrics |
| pricing_analysis.pricing_options.option_b | object | Yes | Value-based pricing option, includes tiers and unit_economics |
| pricing_analysis.pricing_options.option_b.tiers | array | Yes | Tier list, at least 1 |
| pricing_analysis.pricing_options.option_b.tiers[].tier_name | string | Yes | Tier name, cannot be empty |
| pricing_analysis.pricing_options.option_b.tiers[].price | number | Yes | Price |
| pricing_analysis.pricing_options.option_b.tiers[].features | string[] | Yes | Included features list |
| pricing_analysis.pricing_options.option_b.unit_economics | object | Yes | Unit economics metrics |
| pricing_analysis.pricing_options.option_c | object | Yes | Hybrid pricing option, includes tiers and unit_economics |
| pricing_analysis.pricing_options.option_c.tiers | array | Yes | Tier list, at least 1 |
| pricing_analysis.pricing_options.option_c.tiers[].tier_name | string | Yes | Tier name, cannot be empty |
| pricing_analysis.pricing_options.option_c.tiers[].price | number | Yes | Price |
| pricing_analysis.pricing_options.option_c.tiers[].features | string[] | Yes | Included features list |
| pricing_analysis.pricing_options.option_c.unit_economics | object | Yes | Unit economics metrics |
| pricing_options.*.unit_economics.ltv_cac_ratio | number | Yes | LTV/CAC ratio, healthy standard ≥3 |
| pricing_options.*.unit_economics.payback_period_months | number | Yes | Payback period (months) |
| pricing_analysis.recommendation.recommended_option | string | Yes | A/B/C |
| pricing_analysis.recommendation.reasoning | string | Yes | Recommendation rationale |

### Complete Pricing Analysis Report

```json
{
  "pricing_analysis": {
    "competitor_pricing_matrix": {...},
    "willingness_to_pay": {...},
    "pricing_options": {
      "option_a": {...},
      "option_b": {...},
      "option_c": {...}
    },
    "recommendation": {
      "recommended_option": "A/B/C",
      "reasoning": "Recommendation rationale",
      "alternative_for_mitigation": "Alternative option"
    }
  }
}
```

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

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| bmc.json | User provides product description → recommend pricing based on industry benchmarks | Value proposition and cost structure lack BMC data support, pricing may deviate from reality | Require user to provide product features, target users, and cost structure description or upload bmc.json file |
| Competitor pricing data (competitor-analysis.json) | User provides product description → recommend pricing based on industry benchmarks | Competitor matrix is empty, market gaps cannot be identified, pricing lacks competitor anchoring | Require user to provide competitor names, pricing tiers, and prices or upload competitor-analysis.json file |
| bmc.json + Competitor pricing data | User provides product description and target market → recommend pricing based on industry benchmarks | Overall confidence reduced, options lack data anchoring | Require user to provide product description, competitor pricing, and industry benchmark data |
| All upstream files missing | Prompt user to execute prior stages first, or recommend pricing based on user-provided product description and industry benchmarks | Overall confidence significantly reduced, options are only industry benchmark references | Require user to provide product features, target users, competitor pricing, and cost structure info |
| Willingness-to-pay inference data (user provided) | If user does not provide willingness-to-pay inference data, prompt user to provide or skip related steps | Willingness-to-pay analysis missing, pricing options lack user-side validation | Require user to provide user willingness-to-pay survey data or price sensitivity test results |

## Data Acquisition Instructions

This Skill requires BMC and competitor pricing data. Please provide via one of the following methods:
  1. Directly describe product features, target users, and pricing expectations
  2. Upload bmc.json / competitor-analysis.json files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

---

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| bmc.json value proposition update | Value anchors of pricing options need adjustment | Reassess pricing rationale of each option, update value premium basis |
| bmc.json customer segment change | Willingness-to-pay segmentation and tier target users | Re-execute Step 2 and Step 3, adjust pricing by new segments |
| bmc.json cost structure change | Unit economics metrics need recalculation | Recalculate LTV/CAC and payback period |
| competitor-analysis competitor pricing update | Competitor pricing matrix and market gaps | Re-execute Step 1, update competitor benchmarking |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Pricing option adjustment | business-strategy-report, stakeholder-analysis | Output file version number + change summary |
| Unit economics metric change | business-strategy-report | Output file version number + change summary |
| Competitor pricing matrix update | positioning-strategy | Output file version number + change summary |

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

## Data Flow Specification

### Input Directory
```
output/
├── pm-strategy/business-model-canvas/
│   └── bmc.json
├── pm-discovery/market-competitor-analysis/
│   └── competitor-analysis.json
└── pm-discovery/user-research-user-modeling/
    └── user_modeling.json
```

### Output Directory
```
docs/strategy/business-strategy.md ("Pricing Strategy" section)
```
