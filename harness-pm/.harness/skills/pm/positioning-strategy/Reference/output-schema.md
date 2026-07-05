# Positioning Strategy - Output Schema & Validation Rules

Field-level schema and validation rules for the `positioning-strategy` skill outputs.

## positioning-strategy.json Output Schema

```json
{
  "type": "object",
  "required": ["positioning_statements", "value_curve", "differentiation_scores", "exclusion"],
  "properties": {
    "positioning_statements": {"type": "array", "description": "3-5 positioning statement candidates"},
    "recommended_index": {"type": "number", "description": "Recommended index"},
    "value_curve": {"type": "object", "description": "Value curve data, including competitive factor scores and blue ocean actions"},
    "differentiation_scores": {"type": "object", "description": "Five-dimension differentiation scores"},
    "overall_differentiation_strength": {"type": "number", "description": "Composite differentiation strength 0-1"},
    "recommended_differentiation_source": {"type": "object", "description": "Recommended most sustainable differentiation source"},
    "exclusion": {"type": "object", "description": "Exclusion decision data"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| positioning_statements | array | Yes | 3-5 positioning statement candidates |
| positioning_statements[].statement | string | Yes | Full positioning statement |
| positioning_statements[].target_user | string | Yes | Target user |
| positioning_statements[].category | string | Yes | Category definition |
| positioning_statements[].core_value | string | Yes | Core value |
| positioning_statements[].differentiation | string | Yes | Differentiation point |
| positioning_statements[].competitor_reference | string | Yes | Competitor reference |
| positioning_statements[].quality_check.specific | boolean | Yes | Specific check |
| positioning_statements[].quality_check.differentiated | boolean | Yes | Differentiated check |
| positioning_statements[].quality_check.exclusive | boolean | Yes | Exclusive check |
| positioning_statements[].quality_check.verifiable | boolean | Yes | Verifiable check |
| positioning_statements[].quality_check.concise | boolean | Yes | Concise check |
| positioning_statements[].quality_check.all_passed | boolean | Yes | All passed flag |
| positioning_statements[].rank | number | Yes | Recommendation rank |
| recommended_index | number | Yes | Recommended index |
| value_curve.competitive_factors | array | Yes | 5-8 competitive factors |
| value_curve.competitive_factors[].factor | string | Yes | Factor name |
| value_curve.competitive_factors[].our_score | number | Yes | Our score 1-5 |
| value_curve.competitive_factors[].competitor_scores | object | Yes | Each competitor's scores |
| value_curve.blue_ocean_actions.eliminate | array | Yes | Eliminate action list |
| value_curve.blue_ocean_actions.reduce | array | Yes | Reduce action list |
| value_curve.blue_ocean_actions.raise | array | Yes | Raise action list |
| value_curve.blue_ocean_actions.create | array | Yes | Create action list |
| value_curve.differentiation_strength | number | Yes | Differentiation strength 0-1 |
| value_curve.differentiation_warning | boolean | Yes | True when differentiation strength <0.5 |
| differentiation_scores.feature | object | Yes | Feature differentiation score, including score/description/sustainability |
| differentiation_scores.experience | object | Yes | Experience differentiation score |
| differentiation_scores.scenario | object | Yes | Scenario differentiation score |
| differentiation_scores.business | object | Yes | Business differentiation score |
| differentiation_scores.ecosystem | object | Yes | Ecosystem differentiation score |
| overall_differentiation_strength | number | Yes | Composite differentiation strength 0-1 |
| recommended_differentiation_source.dimension | string | Yes | Recommended dimension |
| recommended_differentiation_source.reason | string | Yes | Recommendation reason |
| recommended_differentiation_source.action | string | Yes | Action recommendation |
| exclusion.exclusion_statement | string | Yes | Exclusion statement |
| exclusion.rationale | array | Yes | Exclusion rationale list |
| exclusion.rationale[].excluded_audience | string | Yes | Excluded user group |
| exclusion.rationale[].reason | string | Yes | Strategic rationale |
| exclusion.rationale[].alternative | string | Yes | Alternative recommendation |
| exclusion.implications.revenue_impact | string | Yes | Revenue impact |
| exclusion.implications.resource_optimization | string | Yes | Resource optimization description |
| exclusion.implications.brand_positioning | string | Yes | Brand positioning impact |
| exclusion.implications.risks | array | Yes | Potential risks list |
| exclusion.human_decision.decided_by | string | Yes | Decision maker |
| exclusion.human_decision.decided_at | string | Yes | Decision time |
