# Business Pricing - Schema 定义

本文档收录 Business Pricing Skill 的输出字段验证规则、完整报告 JSON 与数据流规范。

## Output Validation Rules

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

## Complete Pricing Analysis Report

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
