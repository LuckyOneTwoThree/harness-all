# Output Examples

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

