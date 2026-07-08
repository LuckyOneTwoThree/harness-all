# Output Validation Rules and Example

This file is referenced by `SKILL.md` for the `product-proposal` skill.

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| proposal_metadata.product_name | string | Yes | Product name |
| proposal_metadata.generated_at | string | Yes | Generation timestamp |
| proposal_metadata.data_sources | array | Yes | Data source list |
| proposal_metadata.overall_confidence | number | Yes | Overall confidence 0-1 |
| executive_summary.product_name | string | Yes | Product name |
| executive_summary.target_user | string | Yes | Target users |
| executive_summary.core_value | string | Yes | Core value |
| executive_summary.business_model | string | Yes | Business model |
| executive_summary.market_opportunity | string | Yes | Market opportunity |
| executive_summary.key_risks | array | Yes | Top 3 risks |
| executive_summary.decision_requests | array | Yes | Items requiring approval |
| product_definition.vision | string | Yes | Product vision |
| product_definition.target_users | array | Yes | Target user group list |
| product_definition.target_users[].segment_name | string | Yes | User group name |
| product_definition.target_users[].description | string | Yes | Group description |
| product_definition.target_users[].core_needs | array | Yes | Core needs list |
| product_definition.target_users[].scenarios | array | Yes | Use scenario list |
| product_definition.core_value_proposition | string | Yes | Core value proposition |
| product_definition.feature_scope | object | Yes | Feature scope |
| product_definition.feature_scope.mvp_features | array | Yes | MVP feature list |
| product_definition.feature_scope.mvp_features[].name | string | Yes | Feature name |
| product_definition.feature_scope.mvp_features[].priority | string | Yes | Priority: must/should/could |
| product_definition.feature_scope.mvp_features[].description | string | Yes | Feature description |
| product_definition.feature_scope.v2_features | array | Yes | V2.0 feature planning list |
| business_analysis.market_analysis | object | Yes | Market analysis |
| business_analysis.market_analysis.tam | string | Yes | Total Addressable Market |
| business_analysis.market_analysis.sam | string | Yes | Serviceable Available Market |
| business_analysis.market_analysis.som | string | Yes | Serviceable Obtainable Market |
| business_analysis.market_analysis.growth_trend | string | Yes | Growth trend |
| business_analysis.business_model | object | Yes | Business model |
| business_analysis.business_model.revenue_model | string | Yes | Revenue model |
| business_analysis.business_model.pricing_strategy | string | Yes | Pricing strategy overview |
| business_analysis.business_model.cost_structure | array | Yes | Major cost items list |
| business_analysis.business_model.unit_economics | string | Yes | Unit economics |
| business_analysis.competitive_analysis | object | Yes | Competitive analysis |
| business_analysis.competitive_analysis.key_competitors | array | Yes | Key competitor list |
| business_analysis.competitive_analysis.differentiation | string | Yes | Differentiated advantage |
| business_analysis.competitive_analysis.competitive_moat | string | Yes | Competitive moat |
| execution_plan.okr | object | Yes | Objectives and Key Results |
| execution_plan.okr.objective | string | Yes | Annual objective |
| execution_plan.okr.key_results | array | Yes | Key Results list |
| execution_plan.okr.key_results[].kr | string | Yes | Key Result |
| execution_plan.okr.key_results[].metric | string | Yes | Measurement metric |
| execution_plan.okr.key_results[].target | string | Yes | Target value |
| execution_plan.roadmap | object | Yes | Product roadmap |
| execution_plan.roadmap.now | array | Yes | Current phase items |
| execution_plan.roadmap.next | array | Yes | Next phase items |
| execution_plan.roadmap.later | array | Yes | Long-term planning items |
| execution_plan.resource_needs | object | Yes | Resource requirements |
| execution_plan.resource_needs.team | string | Yes | Team configuration |
| execution_plan.resource_needs.budget | string | Yes | Budget requirements |
| execution_plan.resource_needs.timeline | string | Yes | Time planning |
| execution_plan.dependencies | array | Yes | Key dependency list |
| risk_assessment.risks | array | Yes | Risk list |
| risk_assessment.risks[].category | string | Yes | Risk category: market/technology/resource/execution |
| risk_assessment.risks[].description | string | Yes | Risk description |
| risk_assessment.risks[].severity | string | Yes | Severity: high/medium/low |
| risk_assessment.risks[].probability | string | Yes | Probability: high/medium/low |
| risk_assessment.risks[].mitigation | string | Yes | Mitigation measure |
| risk_assessment.risk_matrix_summary | string | Yes | Risk matrix overview |
| decision_requests | array | Yes | Decision requests |

## Complete product-proposal.json Example

```json
{
  "proposal_metadata": {
    "product_name": "Product name",
    "generated_at": "Timestamp",
    "data_sources": [],
    "overall_confidence": 0.0
  },
  "executive_summary": {
    "product_name": "Product name",
    "target_user": "Target users",
    "core_value": "Core value",
    "business_model": "Business model",
    "market_opportunity": "Market opportunity",
    "competitive_advantage": "Competitive advantage",
    "key_metrics": {},
    "resource_needs": {},
    "key_risks": [],
    "decision_requests": []
  },
  "product_definition": {
    "vision": "Product vision",
    "target_users": [
      {
        "segment_name": "User group name",
        "description": "Group description",
        "core_needs": ["Core needs"],
        "scenarios": ["Use scenarios"]
      }
    ],
    "core_value_proposition": "Core value proposition",
    "feature_scope": {
      "mvp_features": [
        {"name": "Feature name", "priority": "must|should|could", "description": "Feature description"}
      ],
      "v2_features": ["V2.0 feature planning"]
    }
  },
  "business_analysis": {
    "market_analysis": {
      "tam": "Total Addressable Market",
      "sam": "Serviceable Available Market",
      "som": "Serviceable Obtainable Market",
      "growth_trend": "Growth trend"
    },
    "business_model": {
      "revenue_model": "Revenue model",
      "pricing_strategy": "Pricing strategy overview",
      "cost_structure": ["Major cost items"],
      "unit_economics": "Unit economics"
    },
    "competitive_analysis": {
      "key_competitors": ["Key competitors"],
      "differentiation": "Differentiated advantage",
      "competitive_moat": "Competitive moat"
    }
  },
  "execution_plan": {
    "okr": {
      "objective": "Annual objective",
      "key_results": [
        {"kr": "Key Result", "metric": "Measurement metric", "target": "Target value"}
      ]
    },
    "roadmap": {
      "now": ["Current phase"],
      "next": ["Next phase"],
      "later": ["Long-term planning"]
    },
    "resource_needs": {
      "team": "Team configuration",
      "budget": "Budget requirements",
      "timeline": "Time planning"
    },
    "dependencies": ["Key dependencies"]
  },
  "risk_assessment": {
    "risks": [
      {
        "category": "market|technology|resource|execution",
        "description": "Risk description",
        "severity": "high|medium|low",
        "probability": "high|medium|low",
        "mitigation": "Mitigation measure"
      }
    ],
    "risk_matrix_summary": "Risk matrix overview"
  },
  "decision_requests": []
}
```
