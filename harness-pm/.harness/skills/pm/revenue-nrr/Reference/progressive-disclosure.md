# revenue-nrr — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

**Storage path**: `docs/growth/growth-strategy.md ("NRR Analysis" section)`

**Output file**: nrr_analysis.json

**Output Schema**:

```json
{
  "type": "object",
  "required": ["current_nrr", "nrr_breakdown"],
  "properties": {
    "current_nrr": {"type": "number", "description": "Current Net Revenue Retention"},
    "nrr_breakdown": {"type": "object", "description": "NRR breakdown, including expansion/contraction/churn revenue ratios"},
    "trend": {"type": "array", "description": "NRR trend data, including monthly NRR and component ratios"},
    "churn_warnings": {"type": "array", "description": "Churn warning list, including risk signals and recommended actions"},
    "expansion_opportunities": {"type": "array", "description": "Expansion opportunity list, including upgrade signals and expected revenue growth"},
    "summary": {"type": "object", "description": "Revenue summary, including active revenue, expansion, churn, and net new"}
  }
}
```

`nrr_tracking`
```json
{
  "current_nrr": 1.15,
  "nrr_breakdown": {
    "expansion_revenue_ratio": 0.12,
    "contraction_revenue_ratio": 0.03,
    "churned_revenue_ratio": 0.05
  },
  "trend": [
    {
      "month": "2024-01",
      "nrr": 1.12,
      "expansion": 0.10,
      "contraction": 0.02,
      "churn": 0.06
    }
  ],
  "churn_warnings": [
    {
      "user_id": "EDU-20240156",
      "company_name": "Qihang Education Group",
      "monthly_revenue": 5000,
      "risk_signals": ["Usage decline", "Contact departure"],
      "risk_level": "high",
      "recommended_action": "Customer success proactive outreach"
    }
  ],
  "expansion_opportunities": [
    {
      "user_id": "EDU-20240203",
      "company_name": "Boxue Online Tech",
      "current_plan": "pro",
      "expansion_signals": ["Usage near limit", "High-frequency core feature usage"],
      "recommended_upgrade": "enterprise",
      "expected_revenue_increase": 3000
    }
  ],
  "summary": {
    "total_active_revenue": 500000,
    "expansion_this_month": 60000,
    "churn_this_month": 25000,
    "net_new_revenue": 35000,
    "at_risk_revenue": 80000,
    "expansion_pipeline": 150000
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| current_nrr | number | Yes | Current NRR, must be >0 |
| nrr_breakdown | object | Yes | NRR breakdown, must include expansion_revenue_ratio/contraction_revenue_ratio/churned_revenue_ratio |
| nrr_breakdown.expansion_revenue_ratio | number | Yes | Expansion revenue ratio, must be ≥0 |
| nrr_breakdown.contraction_revenue_ratio | number | Yes | Contraction revenue ratio |
| nrr_breakdown.churned_revenue_ratio | number | Yes | Churned revenue ratio, must be ≥0 |
| trend | array | No | NRR trend data, each item must include month/nrr |
| trend[].month | string | Yes | Month identifier |
| trend[].nrr | number | Yes | NRR value |
| trend[].expansion | number | No | Expansion revenue |
| trend[].contraction | number | No | Contraction revenue |
| trend[].churn | number | No | Churned revenue |
| churn_warnings | array | No | Churn warning list, each item must include user_id/risk_signals/risk_level |
| churn_warnings[].user_id | string | Yes | User ID |
| churn_warnings[].company_name | string | No | Company name |
| churn_warnings[].monthly_revenue | number | No | Monthly revenue |
| churn_warnings[].risk_signals | string[] | Yes | Risk signal list |
| churn_warnings[].risk_level | string | Yes | Risk level, enum: high/medium/low |
| churn_warnings[].recommended_action | string | No | Recommended action |
| expansion_opportunities | array | No | Expansion opportunity list, each item must include user_id/expansion_signals/recommended_upgrade |
| expansion_opportunities[].user_id | string | Yes | User ID |
| expansion_opportunities[].company_name | string | No | Company name |
| expansion_opportunities[].current_plan | string | No | Current plan |
| expansion_opportunities[].expansion_signals | string[] | Yes | Expansion signal list |
| expansion_opportunities[].recommended_upgrade | string | Yes | Recommended upgrade plan |
| expansion_opportunities[].expected_revenue_increase | number | No | Expected revenue increase |
| summary | object | No | Revenue summary, must include total_active_revenue |
| summary.total_active_revenue | number | Yes | Total active revenue |
| summary.expansion_this_month | number | No | Expansion revenue this month |
| summary.churn_this_month | number | No | Churned revenue this month |
| summary.net_new_revenue | number | No | Net new revenue |
| summary.at_risk_revenue | number | No | At-risk revenue |
| summary.expansion_pipeline | number | No | Expansion pipeline |
