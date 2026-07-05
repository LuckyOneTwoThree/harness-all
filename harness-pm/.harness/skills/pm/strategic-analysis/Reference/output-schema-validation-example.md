# Output Schema, Validation Rules, and Example

> Extracted from SKILL.md. Output JSON schema, field validation rules, and a complete JSON example for strategic analysis.

## Output Schema

```json
{
  "type": "object",
  "required": ["framework_selection", "swot", "ansoff", "porter", "strategic_conclusions", "metadata"],
  "properties": {
    "framework_selection": {"type": "object", "description": "Framework selection results and rationale"},
    "swot": {"type": "object", "description": "SWOT analysis results, null when not selected"},
    "ansoff": {"type": "object", "description": "Ansoff matrix analysis results, null when not selected"},
    "porter": {"type": "object", "description": "Porter's Five Forces analysis results, null when not selected"},
    "strategic_conclusions": {"type": "object", "description": "Integrated strategic conclusions"},
    "metadata": {"type": "object", "description": "Metadata, including version, timestamp, and source files"}
  }
}
```

## Output Validation Rules

### framework_selection Validation

| Field Path | Type | Required | Description |
|----------|------|------|------|
| `framework_selection.selected_frameworks` | array | Yes | Selected framework list, 1-2, must be one of swot/ansoff/porter |
| `framework_selection.selection_rationale` | string | Yes | Selection rationale, cannot be empty |

### swot Validation (required when selected)

| Field Path | Type | Required | Description |
|----------|------|------|------|
| `swot.strengths` | array | Yes | Strengths list, each item contains item, confidence, evidence |
| `swot.weaknesses` | array | Yes | Weaknesses list, each item contains item, confidence, evidence |
| `swot.opportunities` | array | Yes | Opportunities list, each item contains item, confidence, evidence |
| `swot.threats` | array | Yes | Threats list, each item contains item, confidence, evidence |
| `swot.strategies` | array | Yes | 4 strategic directions |
| `swot.strategies[].type` | string | Yes | SO/ST/WO/WT |
| `swot.strategies[].strategy` | string | Yes | Strategy name |
| `swot.strategies[].key_actions` | array | Yes | Key actions list |
| `swot.strategies[].expected_outcome` | string | Yes | Expected outcome |

### ansoff Validation (required when selected)

| Field Path | Type | Required | Description |
|----------|------|------|------|
| `ansoff.current_position.quadrant` | string | Yes | Current quadrant |
| `ansoff.current_position.description` | string | Yes | Current positioning description |
| `ansoff.current_position.rationale` | array | Yes | Positioning rationale list |
| `ansoff.growth_paths` | array | Yes | At least 2 growth paths |
| `ansoff.growth_paths[].path` | string | Yes | Path name |
| `ansoff.growth_paths[].quadrant` | string | Yes | Target quadrant |
| `ansoff.growth_paths[].risk_level` | string | Yes | high/medium/low |
| `ansoff.growth_paths[].feasibility.overall` | number | Yes | Feasibility overall score 0-1 |
| `ansoff.growth_paths[].key_actions` | array | Yes | Key actions list |
| `ansoff.growth_paths[].risks` | array | Yes | Risk list, including mitigation |
| `ansoff.recommendations.primary` | string | Yes | Recommended primary path |
| `ansoff.recommendations.rationale` | string | Yes | Recommendation rationale |

### porter Validation (required when selected)

| Field Path | Type | Required | Description |
|----------|------|------|------|
| `porter.new_entrant_threat.score` | number | Yes | 1-5 score |
| `porter.new_entrant_threat.key_factors` | array | Yes | Key influencing factors list |
| `porter.substitutes_threat.score` | number | Yes | 1-5 score |
| `porter.substitutes_threat.key_factors` | array | Yes | Key influencing factors list |
| `porter.supplier_power.score` | number | Yes | 1-5 score |
| `porter.supplier_power.key_factors` | array | Yes | Key influencing factors list |
| `porter.buyer_power.score` | number | Yes | 1-5 score |
| `porter.buyer_power.key_factors` | array | Yes | Key influencing factors list |
| `porter.competitive_rivalry.score` | number | Yes | 1-5 score |
| `porter.competitive_rivalry.key_factors` | array | Yes | Key influencing factors list |
| `porter.industry_attractiveness.overall_score` | number | Yes | Overall score |
| `porter.industry_attractiveness.rating` | string | Yes | Attractiveness rating |
| `porter.key_recommendations` | array | Yes | Strategic recommendations list |

### strategic_conclusions Validation

| Field Path | Type | Required | Description |
|----------|------|------|------|
| `strategic_conclusions.integrated_recommendations` | array | Yes | Integrated strategic recommendations list, cannot be empty |
| `strategic_conclusions.integrated_recommendations[].recommendation` | string | Yes | Strategic recommendation |
| `strategic_conclusions.integrated_recommendations[].priority` | string | Yes | Priority: high/medium/low |
| `strategic_conclusions.integrated_recommendations[].supporting_frameworks` | array | Yes | List of frameworks supporting this recommendation |
| `strategic_conclusions.integrated_recommendations[].evidence` | string | Yes | Evidence basis |
| `strategic_conclusions.cross_validation_notes` | array | Yes | Cross-framework validation notes |
| `strategic_conclusions.human_decisions_needed` | array | Yes | List of items needing human decision |

## Output JSON Example

```json
{
  "framework_selection": {
    "selected_frameworks": ["swot", "ansoff"],
    "selection_rationale": "User provided internal capability assessment and product/market definition, suitable for SWOT+Ansoff combined analysis"
  },
  "swot": {
    "strengths": [
      { "item": "Owns self-developed AI adaptive learning engine", "confidence": 0.85, "evidence": "Patent No. ZL2023XXXXXX, A/B testing shows 32% improvement in learning efficiency" }
    ],
    "weaknesses": [
      { "item": "Insufficient K12 subject content resources", "confidence": 0.75, "evidence": "Content SKU comparison: Competitor A covers 12 subjects vs our 3 subjects" }
    ],
    "opportunities": [
      { "item": "Vocational education policy dividend period", "confidence": 0.80, "evidence": "State Council 2024 'Vocational Education Reform Implementation Plan'" }
    ],
    "threats": [
      { "item": "Internet giants entering market with free strategy", "confidence": 0.70, "evidence": "Competitor B launched free basic version in 2024 Q3" }
    ],
    "strategies": [
      { "type": "SO", "strategy": "AI engine + enterprise training market penetration", "key_actions": ["Sign training platform pilot agreements with 50 mid-to-large enterprises"], "expected_outcome": "Enterprise customer count grows 40% within 6 months" }
    ]
  },
  "ansoff": {
    "current_position": {
      "quadrant": "Market Penetration",
      "description": "Currently positioned as existing product in existing market",
      "rationale": ["Product mature and stable"]
    },
    "growth_paths": [
      {
        "path": "Market Development",
        "quadrant": "Market Development",
        "risk_level": "medium",
        "resource_requirement": "medium",
        "expected_return": "medium",
        "timeline": "6-12 months",
        "feasibility": { "overall": 0.70, "market_attractiveness": 0.75, "capability_match": 0.80, "resource_availability": 0.65, "risk_controllability": 0.60 },
        "key_actions": ["Identify target new market segments"],
        "risks": [{ "risk": "Insufficient market awareness", "mitigation": "Brand joint promotion" }]
      }
    ],
    "recommendations": {
      "primary": "Market Development",
      "rationale": "Controllable risk, moderate resource requirements, high match with existing capabilities"
    }
  },
  "porter": null,
  "strategic_conclusions": {
    "integrated_recommendations": [
      { "recommendation": "Prioritize market development strategy, use AI engine advantage to explore enterprise training new market", "priority": "high", "supporting_frameworks": ["swot", "ansoff"], "evidence": "SO strategy consistent with Ansoff market development path, feasibility score 0.70" }
    ],
    "cross_validation_notes": [
      "SWOT SO strategy consistent with Ansoff market development path direction, mutually validated"
    ],
    "human_decisions_needed": [
      { "item": "Strategic direction selection", "context": "SO strategy (market penetration) vs WO strategy (content reinforcement) vs market development path, human decision needed for final direction", "urgency": "high" }
    ]
  },
  "metadata": {
    "version": "3.0",
    "generated_at": "2026-05-14T21:00:00Z",
    "source_files": [
      "docs/discovery/market-analysis.md (\"Competitive Analysis\" section)"
    ]
  }
}
```
