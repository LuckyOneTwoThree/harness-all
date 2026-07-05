# market-tam-som — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

Output file: `docs/discovery/market-analysis.md ("Market Size" section)`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["category_keywords", "geographic_scope", "time_range", "tam", "sam", "som", "confidence"],
  "properties": {
    "category_keywords": {"type": "string", "description": "Category keywords"},
    "geographic_scope": {"type": "string", "description": "Target market geographic scope"},
    "time_range": {"type": "string", "description": "Estimation time range"},
    "tam": {"type": "object", "description": "TAM total addressable market estimation, including top-down and bottom-up dual paths"},
    "sam": {"type": "object", "description": "SAM serviceable available market estimation"},
    "som": {"type": "object", "description": "SOM serviceable obtainable market estimation"},
    "confidence": {"type": "object", "description": "Confidence assessment, including data source reliability and sensitivity analysis"}
  }
}
```

**Output Validation Rules**:

| Field Path | Type | Required | Description |
|---------|------|------|------|
| category_keywords | string | Yes | Category keywords, cannot be empty |
| geographic_scope | string | Yes | Target market geographic scope, cannot be empty |
| time_range | string | Yes | Estimation time range, format like "2025-2027" |
| tam | object | Yes | TAM estimation result, must include top_down and bottom_up sub-objects |
| tam.top_down | object | Yes | Top-down estimation path, must include industry_total, category_ratio, estimates, data_sources |
| tam.top_down.industry_total | string | Yes | Industry total size, with unit |
| tam.top_down.category_ratio | string | Yes | Target category share, percentage format |
| tam.top_down.estimates | object | Yes | Must include optimistic, neutral, conservative range values |
| tam.top_down.data_sources | array | Yes | Data source list, can be empty array but cannot be missing |
| tam.bottom_up | object | Yes | Bottom-up estimation path, must include target_users, arpu, estimates, data_sources |
| tam.bottom_up.target_users | string | Yes | Total target users, with unit |
| tam.bottom_up.arpu | string | Yes | Average revenue per user per year, with unit |
| tam.bottom_up.estimates | object | Yes | Must include optimistic, neutral, conservative range values |
| tam.bottom_up.data_sources | array | Yes | Data source list, can be empty array but cannot be missing |
| sam | object | Yes | SAM estimation result |
| sam.geo_coefficient | string | Yes | Geographic filter coefficient, between 0-1 |
| sam.audience_coefficient | string | Yes | Audience filter coefficient, between 0-1 |
| sam.service_coefficient | string | Yes | Service capability coefficient, between 0-1 |
| sam.estimates | object | Yes | Must include optimistic, neutral, conservative range values |
| sam.data_sources | array | Yes | Data source list |
| som | object | Yes | SOM estimation result |
| som.base | string | Yes | Calculation base, fixed as "SAM" |
| som.competition_constraint | string | Yes | Competition constraint percentage, between 0-1 |
| som.resource_constraint | string | Yes | Resource constraint percentage, between 0-1 |
| som.acquisition_constraint | string | Yes | Acquisition constraint percentage, between 0-1 |
| som.calculation | string | Yes | Calculation formula, showing the full multiplication process |
| som.estimates | object | Yes | Must include optimistic, neutral, conservative range values |
| som.timeline | object | Yes | Achievable timeline, must include 6m, 12m, 24m milestones |
| som.data_sources | array | Yes | Data source list |
| confidence | object | Yes | Confidence assessment |
| confidence.overall_score | number | Yes | Overall confidence score, between 0-1 |
| confidence.data_source_reliability | array | Yes | Reliability score list for each data source |
| confidence.sensitivity_analysis | array | Yes | Sensitivity analysis results list |
| confidence.key_assumptions | array | Yes | Key assumption list, each must include assumption, basis, impact_direction |
| confidence.key_assumptions[].assumption | string | Yes | Assumption content description |
| confidence.key_assumptions[].basis | string | Yes | Assumption basis |
| confidence.key_assumptions[].impact_direction | string | Yes | Impact direction on results: positive/negative/bidirectional |
| confidence.key_assumptions[].sensitivity | string | No | Sensitivity annotation, marked as "high" when impact > 30% |
| confidence.key_assumptions[].needs_human_validation | boolean | No | Whether human validation is needed; defaults to true for highly sensitive assumptions |

```json
{
  "category_keywords": "Online Education",
  "geographic_scope": "Mainland China",
  "time_range": "2025-2027",
  "tam": {
    "top_down": {
      "industry_total": "500 billion",
      "category_ratio": "8%",
      "estimates": {
        "optimistic": "40 billion",
        "neutral": "30 billion",
        "conservative": "20 billion"
      },
      "data_sources": []
    },
    "bottom_up": {
      "target_users": "120 million",
      "arpu": "3000 yuan/year",
      "estimates": {
        "optimistic": "36 billion",
        "neutral": "28 billion",
        "conservative": "20 billion"
      },
      "data_sources": []
    }
  },
  "sam": {
    "geo_coefficient": "0.85",
    "audience_coefficient": "0.35",
    "service_coefficient": "0.60",
    "estimates": {
      "optimistic": "12 billion",
      "neutral": "8.5 billion",
      "conservative": "5.5 billion"
    },
    "data_sources": []
  },
  "som": {
    "base": "SAM",
    "competition_constraint": "0.60",
    "resource_constraint": "0.65",
    "acquisition_constraint": "0.50",
    "calculation": "SAM × (1 - 0.60) × (1 - 0.65) × (1 - 0.50) = SAM × 0.07",
    "estimates": {
      "optimistic": "0.9 billion",
      "neutral": "0.6 billion",
      "conservative": "0.3 billion"
    },
    "timeline": {
      "6m": "Complete product MVP, acquire first 1000 paid users",
      "12m": "Iterate product to v2.0, paid users exceed 10,000",
      "24m": "Establish brand influence, paid users reach 100,000"
    },
    "data_sources": []
  },
  "confidence": {
    "overall_score": 0.65,
    "data_source_reliability": [
      {
        "source": "Ministry of Education Education Statistics Yearbook",
        "type": "Official statistics",
        "reliability_score": 0.85
      },
      {
        "source": "China Internet Network Development Status Statistics Report (CNNIC)",
        "type": "Official statistics",
        "reliability_score": 0.80
      },
      {
        "source": "iResearch Online Education Industry Research Report",
        "type": "Third-party research report",
        "reliability_score": 0.70
      }
    ],
    "sensitivity_analysis": [
      {
        "assumption": "K12 online education penetration rate will continue to grow",
        "variation": "±20%",
        "impact_on_result": "TAM neutral value fluctuation range ±2.4 billion, SOM neutral value fluctuation range ±0.14 billion",
        "sensitivity": "high"
      },
      {
        "assumption": "ARPU maintained at 3000 yuan/year",
        "variation": "±20%",
        "impact_on_result": "bottom_up path TAM neutral value fluctuation ±5.6 billion",
        "sensitivity": "medium"
      }
    ],
    "key_assumptions": [
      {
        "assumption": "K12 online education penetration rate will continue to grow",
        "basis": "Ministry of Education promotes education digitalization policy",
        "impact_direction": "positive",
        "sensitivity": "high",
        "needs_human_validation": true
      }
    ]
  }
}
```
