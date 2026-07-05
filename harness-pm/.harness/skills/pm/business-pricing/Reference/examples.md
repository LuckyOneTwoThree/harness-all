# Business Pricing - 示例集

本文档收录 Business Pricing Skill 的输入与输出 JSON 示例。

## Inputs 示例

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

## Step 1: Competitor Pricing Matrix Output 示例

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

## Step 2: Willingness-to-Pay Analysis Output 示例

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

## Step 3 - Option A: Penetration Pricing 示例

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

## Step 3 - Option B: Value-Based Pricing 示例

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

## Step 3 - Option C: Hybrid Pricing 示例

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
