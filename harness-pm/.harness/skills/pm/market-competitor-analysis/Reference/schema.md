# market-competitor-analysis Schema

> This document is split from the market-competitor-analysis SKILL.md and contains the output JSON schema and output validation rules.

## competitor-analysis.json Output Schema

```json
{
  "type": "object",
  "required": ["scan_timestamp", "competitors", "quadrants", "executive_summary", "competitor_profiles", "differentiation_strategies"],
  "properties": {
    "scan_timestamp": {"type": "string", "description": "Scan timestamp"},
    "competitors": {"type": "array", "description": "Competitor intelligence list, including Feature Matrix, reputation, pricing, and strategic signals"},
    "reputation_comparison": {"type": "object", "description": "Competitor reputation cross-comparison"},
    "alerts": {"type": "array", "description": "Competitor change alert list"},
    "category_keywords": {"type": "string", "description": "Category keywords"},
    "quadrants": {"type": "object", "description": "Four-quadrant competitor classification, including direct/indirect/substitute/potential competitors"},
    "quadrant_summary": {"type": "object", "description": "Four-quadrant classification statistics summary"},
    "report_metadata": {"type": "object", "description": "Report metadata, including category, timestamp, and confidence"},
    "executive_summary": {"type": "object", "description": "Executive summary, including competitive landscape summary and core findings"},
    "market_overview": {"type": "object", "description": "Market overview, including TAM/SAM/SOM and growth trends"},
    "competitive_landscape": {"type": "object", "description": "Competitive landscape, including four-quadrant summary and market share estimation"},
    "competitor_profiles": {"type": "array", "description": "Competitor deep profile list, including SWOT and moat assessment"},
    "feature_matrix_summary": {"type": "object", "description": "Feature matrix comparison summary"},
    "perceptual_map": {"type": "object", "description": "Competitive perceptual map data"},
    "differentiation_strategies": {"type": "array", "description": "Differentiation strategy recommendation list"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|---------|------|------|------|
| scan_timestamp | string | Yes | ISO 8601 format timestamp, cannot be empty or future time |
| competitors | array | Yes | At least 1 competitor entry, each must contain name and category |
| competitors[].feature_matrix | object | Yes | Must include features array and last_updated timestamp |
| competitors[].feature_matrix.features | array | Yes | Each item must contain feature_name, status, impact_degree, source |
| competitors[].feature_matrix.features[].impact_degree | integer | Yes | Value 1-5, must be integer |
| competitors[].feature_matrix.features[].source | string | Yes | Data source cannot be empty; key findings must annotate ≥ 2 independent sources |
| competitors[].reputation | object | Yes | Must include sentiment_distribution, top_pain_points, data_sources |
| competitors[].reputation.sentiment_distribution | object | Yes | Sum of positive+neutral+negative must be 1.0 (±0.01 tolerance) |
| competitors[].reputation.data_sources | array | Yes | At least 1 reputation data source annotated |
| competitors[].pricing | object | Yes | Must include price_range, plan_structure, value_score |
| competitors[].pricing.value_score | number | Yes | Value 0.0-1.0, two decimal places |
| competitors[].strategic_signals | object | Yes | Must include direction, confidence, evidence, needs_human_validation |
| competitors[].strategic_signals.confidence | number | Yes | Value 0.0-1.0; when < 0.5, needs_human_validation must be true |
| competitors[].strategic_signals.evidence | array | Yes | At least 1 piece of evidence, each must annotate source type and confidence |
| competitors[].strategic_signals.needs_human_validation | boolean | Yes | Must be true when confidence < 0.5 or only single-source inference |
| reputation_comparison | object | No | Required when competitors count ≥ 2; must include common_pain_points, differentiation_opportunities |
| reputation_comparison.common_pain_points | array | No | Each item must contain pain point description and involved competitor list |
| reputation_comparison.differentiation_opportunities | array | No | Each item must contain opportunity description and associated common competitor pain points |
| reputation_comparison.competitive_disadvantages | array | No | Each item must contain disadvantage description and comparison competitor name |
| alerts | array | No | Changes with impact degree ≥ 4 must generate an alert entry |
| alerts[].impact_degree | integer | Yes | Value 1-5; ≥ 4 must trigger notification mechanism |
| alerts[].recommendation | string | Yes | Response recommendation cannot be empty; must be a specific actionable recommendation |
| alerts[].timestamp | string | Yes | ISO 8601 format timestamp, cannot be empty |
| category_keywords | string | Yes | Category keywords, cannot be an empty string |
| quadrants | object | Yes | Four-quadrant container, must include all four sub-quadrants |
| quadrants.direct_competitors | object | Yes | Direct competitor quadrant, definition cannot be empty |
| quadrants.direct_competitors.items | array | Yes | Direct competitor list, can be empty array but must annotate as needing supplementation |
| quadrants.direct_competitors.items[].name | string | Yes | Competitor name, cannot be empty |
| quadrants.direct_competitors.items[].confidence | number | Yes | Confidence, range 0-1 |
| quadrants.direct_competitors.items[].data_source | string | Yes | Data source, cannot be empty |
| quadrants.direct_competitors.items[].needs_human_validation | boolean | Yes | Whether human validation is needed; must be true when confidence < 0.5 |
| quadrants.indirect_competitors | object | Yes | Indirect competitor quadrant, definition cannot be empty |
| quadrants.indirect_competitors.items | array | Yes | Indirect competitor list, can be empty array but must annotate as needing supplementation |
| quadrants.indirect_competitors.items[].name | string | Yes | Competitor name, cannot be empty |
| quadrants.indirect_competitors.items[].confidence | number | Yes | Confidence, range 0-1 |
| quadrants.indirect_competitors.items[].data_source | string | Yes | Data source, cannot be empty |
| quadrants.indirect_competitors.items[].needs_human_validation | boolean | Yes | Whether human validation is needed; must be true when confidence < 0.5 |
| quadrants.substitutes | object | Yes | Substitute quadrant, definition cannot be empty |
| quadrants.substitutes.items | array | Yes | Substitute list, can be empty array but must annotate as needing supplementation |
| quadrants.substitutes.items[].name | string | Yes | Substitute name, cannot be empty |
| quadrants.substitutes.items[].confidence | number | Yes | Confidence, range 0-1 |
| quadrants.substitutes.items[].data_source | string | Yes | Data source, cannot be empty |
| quadrants.substitutes.items[].needs_human_validation | boolean | Yes | Whether human validation is needed; must be true when confidence < 0.5 |
| quadrants.potential_competitors | object | Yes | Potential competitor quadrant, definition cannot be empty |
| quadrants.potential_competitors.items | array | Yes | Potential competitor list, can be empty array but must annotate as needing supplementation |
| quadrants.potential_competitors.items[].name | string | Yes | Competitor name, cannot be empty |
| quadrants.potential_competitors.items[].confidence | number | Yes | Confidence, range 0-1 |
| quadrants.potential_competitors.items[].data_source | string | Yes | Data source, cannot be empty |
| quadrants.potential_competitors.items[].needs_human_validation | boolean | Yes | Whether human validation is needed; **defaults to true** |
| quadrant_summary | object | Yes | Classification statistics summary |
| quadrant_summary.total_items | number | Yes | Total competitor count, should equal sum of four-quadrant items |
| quadrant_summary.by_confidence | object | Yes | Statistics by confidence tier |
| quadrant_summary.by_confidence.high | number | Yes | High-confidence item count (≥ 0.8) |
| quadrant_summary.by_confidence.medium | number | Yes | Medium-confidence item count (0.5-0.8) |
| quadrant_summary.by_confidence.low | number | Yes | Low-confidence item count (< 0.5) |
| quadrant_summary.needs_validation_count | number | Yes | Count of items needing human validation |
| report_metadata | object | Yes | Report metadata, must include category, generated_at, competitors_analyzed, data_sources, overall_confidence |
| report_metadata.category | string | Yes | Category keywords, cannot be empty |
| report_metadata.generated_at | string | Yes | ISO 8601 timestamp |
| report_metadata.competitors_analyzed | integer | Yes | Number of competitors analyzed, ≥ 3 |
| report_metadata.data_sources | array | Yes | Data source list, cannot be empty array |
| report_metadata.overall_confidence | number | Yes | Overall confidence, range 0.0-1.0 |
| executive_summary | object | Yes | Executive summary |
| executive_summary.competition_landscape | string | Yes | One-paragraph summary of competitive landscape, ≥ 50 characters |
| executive_summary.key_findings | array | Yes | Core findings list, length = 3 |
| executive_summary.top_strategy | string | Yes | Top 1 strategy recommendation, cannot be empty |
| market_overview | object | No | Market overview; when missing, annotate as "lacking market size data" |
| market_overview.tam | number | Conditional | Required when market_overview exists, > 0 |
| market_overview.sam | number | Conditional | Required when market_overview exists, > 0 and ≤ tam |
| market_overview.som | number | Conditional | Required when market_overview exists, > 0 and ≤ sam |
| market_overview.growth_rate | string | Conditional | Required when market_overview exists, format like "12.5%" |
| market_overview.key_drivers | array | Conditional | Required when market_overview exists, ≥ 1 item |
| market_overview.pest_highlights | array | No | PEST key factors; can be empty array when missing |
| competitive_landscape | object | No | Competitive landscape |
| competitive_landscape.quadrant_summary | object | Conditional | Required when competitive_landscape exists |
| competitive_landscape.market_share_estimate | array | Conditional | Required when competitive_landscape exists, ≥ 1 item |
| competitive_landscape.hhi_index | number | Conditional | Required when competitive_landscape exists, range 0-10000 |
| competitive_landscape.concentration_level | string | Conditional | Required when competitive_landscape exists, enum: fragmented/moderately concentrated/highly concentrated |
| competitor_profiles | array | Yes | Competitor deep profile list, length 3-5 |
| competitor_profiles[].name | string | Yes | Competitor name, cannot be empty |
| competitor_profiles[].positioning | string | Yes | One-sentence positioning, cannot be empty |
| competitor_profiles[].swot | object | Yes | SWOT analysis, must include strengths/weaknesses/opportunities/threats arrays, each array ≥ 1 item |
| competitor_profiles[].swot.strengths | array | Yes | Strengths list, ≥ 1 item |
| competitor_profiles[].swot.weaknesses | array | Yes | Weaknesses list, ≥ 1 item |
| competitor_profiles[].swot.opportunities | array | Yes | Opportunities list, ≥ 1 item |
| competitor_profiles[].swot.threats | array | Yes | Threats list, ≥ 1 item |
| competitor_profiles[].moat_score | object | Yes | Moat assessment |
| competitor_profiles[].moat_score.network_effects | number | Yes | Network effects score, 0-5 |
| competitor_profiles[].moat_score.switching_cost | number | Yes | Switching cost score, 0-5 |
| competitor_profiles[].moat_score.scale_economy | number | Yes | Scale economy score, 0-5 |
| competitor_profiles[].moat_score.brand | number | Yes | Brand barrier score, 0-5 |
| competitor_profiles[].moat_score.technology | number | Yes | Technology Barrier score, 0-5 |
| competitor_profiles[].moat_score.data | number | Yes | Data barrier score, 0-5 |
| competitor_profiles[].moat_score.ecosystem | number | Yes | Ecosystem barrier score, 0-5 |
| competitor_profiles[].moat_score.total | number | Yes | Moat total score, = sum of 7 items, 0-35 |
| competitor_profiles[].moat_score.level | string | Yes | Moat depth, enum: deep/medium/shallow |
| feature_matrix_summary | object | No | Feature matrix comparison summary |
| feature_matrix_summary.total_features_compared | integer | Conditional | Required when feature_matrix_summary exists, > 0 |
| feature_matrix_summary.differentiation_features | array | Conditional | Required when feature_matrix_summary exists, ≥ 1 item |
| feature_matrix_summary.coverage_scores | object | Conditional | Required when feature_matrix_summary exists, coverage score for each competitor |
| perceptual_map | object | No | Competitive perceptual map data |
| perceptual_map.x_axis | string | Conditional | Required when perceptual_map exists, X axis dimension name |
| perceptual_map.y_axis | string | Conditional | Required when perceptual_map exists, Y axis dimension name |
| perceptual_map.positions | array | Conditional | Required when perceptual_map exists, ≥ 2 competitor coordinate points |
| perceptual_map.positions[].name | string | Yes | Competitor name |
| perceptual_map.positions[].x | number | Yes | X axis coordinate, 0.0-1.0 |
| perceptual_map.positions[].y | number | Yes | Y axis coordinate, 0.0-1.0 |
| perceptual_map.white_space | string | Conditional | Required when perceptual_map exists, blank area description |
| differentiation_strategies | array | Yes | Differentiation strategy recommendation list, ≥ 3 items |
| differentiation_strategies[].name | string | Yes | Strategy name, cannot be empty |
| differentiation_strategies[].description | string | Yes | One-sentence description, cannot be empty |
| differentiation_strategies[].evidence | string | Yes | Strategy basis, must cite specific analysis data |
| differentiation_strategies[].expected_impact | string | Yes | Expected effect, cannot be empty |
| differentiation_strategies[].risks | string | Yes | Risks and prerequisites, cannot be empty |
| differentiation_strategies[].priority | string | Yes | Priority, enum: P0/P1/P2 |
