---
name: strategic-analysis
description: Used when product strategy analysis, competitive strategy judgment, or strategy framework selection is needed. Automatically selects applicable strategy frameworks (SWOT/Ansoff/Porter's Five Forces) based on product stage and industry characteristics. Keywords: strategic analysis, SWOT, Ansoff Matrix, Porter's Five Forces, strategic planning.
---
# Strategic Analysis

## Outputs
- docs/strategy/PRODUCT_STRATEGY.md
- memory/progress.md

## Core Principles

1. **Framework selection before execution** — Automatically select 1-2 most applicable strategy frameworks based on product stage and industry characteristics. Not all frameworks apply to all scenarios.
2. **Internal-external cross-validation** — SWOT's S/W come from internal capability assessment, O/T come from external data. Sources cannot be confused. Ansoff paths must cross-validate with SWOT strengths/weaknesses.
3. **Mandatory evidence annotation** — Each analysis item must be supported by data or facts, with confidence annotated. Low confidence automatically escalates to human calibration.
4. **Increasing risk principle** — From market penetration to diversification, risk increases and must be explicitly annotated. In Five Forces scoring, the overall industry attractiveness rating must be a human decision.
5. **Dual-path projection** — Ansoff recommends at least 2 growth paths, including risk level and feasibility assessment.
6. **Five Forces full coverage** — New entrants, substitutes, suppliers, buyers, and competitive rivalry — all five forces are indispensable.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Exploration stage output | JSON | Yes | user-research-user-modeling / opportunity-definition | User pain points, requirement insights |
| Competitive analysis data | JSON | Yes | docs/discovery/market-analysis.md ("Competitive Analysis" section) | Competitor positioning, feature comparison |
| BMC business model canvas | JSON | ○ | docs/strategy/business-strategy.md ("Business Model Canvas" section) | Value proposition, key resources |
| Market data | JSON | ○ | docs/discovery/market-analysis.md ("Market Size" section) | Market size, growth rate |
| Industry info | JSON | ○ | docs/discovery/market-analysis.md ("PEST Analysis" section) | Policies/regulations, technology dynamics |
| Internal capability assessment | JSON | ○ | User-provided | Technology/brand/resource/financial capability |
| Current product definition | string | ○ | User-provided | Product core features and value proposition description |
| Current market definition | string | ○ | User-provided | Target market, user group description |
| Growth objectives | string | ○ | docs/strategy/OKR.md | Expected growth direction and objectives |

## Execution Steps

### Step 1: Framework Selection [Core]

Automatically select 1-2 most applicable strategy frameworks based on the input product stage and industry characteristics.

**Framework selection rules:**

| Scenario Characteristic | Recommended Framework | Selection Rationale |
|----------|----------|----------|
| New product/new market entry | SWOT + Porter's Five Forces | Need to assess both internal capability and external industry attractiveness |
| Existing product growth decision | SWOT + Ansoff | Need to assess strengths/weaknesses and determine growth path |
| Industry competitive landscape analysis | Porter's Five Forces | Focus on industry structure and competitive intensity |
| Strategic positioning and direction selection | SWOT | Focus on internal-external cross-analysis to generate strategic direction |
| Market expansion decision | Ansoff + Porter's Five Forces | Need to assess growth path and target market attractiveness |
| Complete strategic planning | SWOT + Ansoff + Porter's Five Forces | Comprehensive strategic analysis |

**Selection logic:**

1. If user provides internal capability assessment → SWOT applies
2. If user provides product/market definition → Ansoff applies
3. If user provides competitor and market data → Porter's Five Forces applies
4. Default recommendation: SWOT (most general)
5. Select at most 2 frameworks (avoid over-analysis); if all 3 apply, prioritize SWOT + Ansoff

### Step 2: Execute Analysis [Core]

Execute strategic analysis according to the selected frameworks.

#### 2a: SWOT Analysis

**Step 2a-1: Internal Strengths Identification**

Analyze internal strengths: core technology and patents, brand awareness and reputation, user base and loyalty, channel and network resources, talent and organizational capability, financial resources and cash flow.

**Step 2a-2: Internal Weaknesses Identification**

Analyze internal weaknesses: technology or product gaps, insufficient brand awareness, resource or capability deficiencies, organizational structure issues, financial constraints.

**Step 2a-3: External Opportunities Identification**

Analyze external market opportunities: market size and growth, policy support, opportunities from technological change, segment market gaps, partnership opportunities, user demand changes.

**Step 2a-4: External Threats Identification**

Analyze external market threats: competitor actions, substitute threats, policy/regulatory risks, technology disruption risks, market shrinkage, economic environment changes.

**Step 2a-5: Strategic Direction Generation**

Generate 4 strategies based on SWOT cross-analysis:

| Strategy Type | Meaning |
|----------|------|
| SO Strategy (Strengths-Opportunities) | Use strengths to seize opportunities |
| ST Strategy (Strengths-Threats) | Use strengths to avoid threats |
| WO Strategy (Weaknesses-Opportunities) | Use opportunities to compensate for weaknesses |
| WT Strategy (Weaknesses-Threats) | Retrench and defend, minimize weaknesses and threats |

#### 2b: Ansoff Matrix Analysis

**Step 2b-1: Current Quadrant Determination**

```
                    │ Existing Products │ New Products
────────────────────┼───────────────┼──────────────
    Existing Market │ Market Penetration │ Product Development
                    │ (Penetration) │ (Development)
────────────────────┼───────────────┼──────────────
    New Market      │ Market Development │ Diversification
                    │ (Development) │ (Diversification)
```

**Step 2b-2: Growth Path Recommendation**

Based on SWOT and growth objectives, recommend 1-2 growth paths. Each path includes:
- Path name and type
- Risk level (High/Medium/Low)
- Resource requirement (High/Medium/Low)
- Expected return (High/Medium/Low)
- Timeline (cycle)
- Feasibility assessment (market attractiveness, capability match, resource availability, risk controllability)

**Step 2b-3: Path Feasibility Assessment**

Assess the feasibility of each path: market attractiveness, capability match, resource availability, risk controllability.

#### 2c: Porter's Five Forces Analysis

**Force 1: Threat of New Entrants**

| Score | Standard |
|------|------|
| 1 | Entry barriers extremely high, almost impossible to enter |
| 2 | Entry barriers relatively high, difficult for new entrants |
| 3 | Medium barriers, some possibility of entry |
| 4 | Entry barriers relatively low, easy to enter |
| 5 | Entry barriers very low, extremely easy to enter |

Assessment factors: entry threshold, brand loyalty, scale economy requirements, switching costs, capital requirements, distribution channel control.

**Force 2: Threat of Substitutes**

| Score | Standard |
|------|------|
| 1 | Almost no substitutes |
| 2 | Few substitutes, high switching costs |
| 3 | Some substitutes exist |
| 4 | Many substitutes, clear price advantages |
| 5 | Abundant substitutes, major threat |

Assessment factors: substitute quantity and quality, switching costs, substitute price advantages, user acceptance of substitutes.

**Force 3: Bargaining Power of Suppliers**

| Score | Standard |
|------|------|
| 1 | Suppliers dispersed, weak bargaining power |
| 2 | Many suppliers, plenty of choices |
| 3 | Supplier power medium |
| 4 | Suppliers concentrated, strong bargaining power |
| 5 | Supplier monopoly, extremely strong bargaining power |

Assessment factors: supplier quantity and concentration, cost of switching suppliers, forward integration possibility, supplier product differentiation, supplier scale.

**Force 4: Bargaining Power of Buyers**

| Score | Standard |
|------|------|
| 1 | Buyers dispersed, weak bargaining power |
| 2 | Many buyers, plenty of choices |
| 3 | Buyer power medium |
| 4 | Buyers concentrated, strong bargaining power |
| 5 | Buyer monopoly, extremely strong bargaining power |

Assessment factors: buyer quantity and concentration, switching costs, price sensitivity, buyer information transparency, purchase volume.

**Force 5: Competitive Rivalry Intensity**

| Score | Standard |
|------|------|
| 1 | Competition mild, market stable |
| 2 | Competition moderate, orderly development |
| 3 | Competition medium, noticeable fluctuation |
| 4 | Competition fierce, price wars common |
| 5 | Competition white-hot, frequent elimination |

Assessment factors: competitor quantity and scale, industry growth rate, product differentiation degree, exit barrier height, competitive strategy diversity.

### Step 3: Strategic Conclusion Integration [Core]

Integrate the analysis conclusions of each framework to generate unified strategic recommendations.

**Integration rules:**

1. SWOT strategic direction + Ansoff growth path cross-validation: Whether SO strategy is consistent with Ansoff recommended path
2. Porter's Five Forces industry attractiveness + Ansoff path feasibility: When industry attractiveness is low, growth path risk needs to be adjusted upward
3. SWOT strengths + Porter's Five Forces competitive barriers: Whether strengths constitute competitive barriers, whether barriers are sustainable
4. Generate integrated strategic recommendation list, sorted by priority

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Strategic analysis conclusions and recommendations | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full analysis + strategic projection + competitive landscape simulation + strategic roadmap | Full artifact + extended analysis + deep projection |

## Output

Output path: `docs/strategy/PRODUCT_STRATEGY.md ("Strategic Analysis" section)`

Output files: strategic-analysis.json + strategic-analysis.md

### Output Schema

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

### Output Validation Rules

#### framework_selection Validation

| Field Path | Type | Required | Description |
|----------|------|------|------|
| `framework_selection.selected_frameworks` | array | Yes | Selected framework list, 1-2, must be one of swot/ansoff/porter |
| `framework_selection.selection_rationale` | string | Yes | Selection rationale, cannot be empty |

#### swot Validation (required when selected)

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

#### ansoff Validation (required when selected)

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

#### porter Validation (required when selected)

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

#### strategic_conclusions Validation

| Field Path | Type | Required | Description |
|----------|------|------|------|
| `strategic_conclusions.integrated_recommendations` | array | Yes | Integrated strategic recommendations list, cannot be empty |
| `strategic_conclusions.integrated_recommendations[].recommendation` | string | Yes | Strategic recommendation |
| `strategic_conclusions.integrated_recommendations[].priority` | string | Yes | Priority: high/medium/low |
| `strategic_conclusions.integrated_recommendations[].supporting_frameworks` | array | Yes | List of frameworks supporting this recommendation |
| `strategic_conclusions.integrated_recommendations[].evidence` | string | Yes | Evidence basis |
| `strategic_conclusions.cross_validation_notes` | array | Yes | Cross-framework validation notes |
| `strategic_conclusions.human_decisions_needed` | array | Yes | List of items needing human decision |

### Output JSON Example

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

## Decision Rules

1. **SWOT confidence escalation**: Items with confidence < 0.6 automatically escalate to human calibration
2. **SWOT strategy selection**: 4 strategic directions must be finally selected by human
3. **Ansoff growth path selection**: Must be finally decided by human
4. **Ansoff risk assessment**: Human judges risk acceptance level
5. **Porter's Five Forces score calibration**: Each force score needs human calibration confirmation
6. **Porter's Five Forces industry attractiveness**: Overall rating must be human judgment
7. **Framework selection override**: AI-selected frameworks can be adjusted by human; when human specifies a framework, execute it first

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] Framework selection reasonable (selected_frameworks non-empty and selection rationale sufficient)
- [ ] Each SWOT analysis item has data support (evidence field non-empty)

### P1 Checks (standard/deep must pass)

- [ ] All 4 SWOT strategic directions generated (strategies include SO/ST/WO/WT)
- [ ] SWOT confidence assessment completed (each item has confidence value)
- [ ] All 4 Ansoff quadrants analyzed (current positioning determined)
- [ ] 1-2 Ansoff growth paths recommended (growth_paths non-empty)
- [ ] Each Ansoff path has risk level annotated (risk_level non-empty)
- [ ] Ansoff feasibility assessment completed (feasibility non-empty)
- [ ] All 5 Porter's Five Forces assessed (all 5 forces have score)
- [ ] Porter's Five Forces scores have data basis (key_factors non-empty)
- [ ] Porter's Five Forces industry attractiveness overall rating completed (industry_attractiveness non-empty)
- [ ] Strategic conclusions integrated (integrated_recommendations non-empty)
- [ ] Cross-framework validation completed (cross_validation_notes non-empty)
- [ ] Human decision items listed (human_decisions_needed non-empty)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep projection and roadmap generated)
- [ ] Decision record complete (key decisions have basis and alternatives)

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|----------|------------|
| exploration_outputs (persona / opportunity-definition, etc.) | User provides product status description → generate analysis based on description | Lacking exploration stage data, O/T may lack user-side empirical evidence | Require user to provide persona and opportunity definition descriptions or upload persona.json/opportunity-definition.json files |
| competitor-analysis.json | User provides product/industry status description → generate analysis based on description | Lacking competitive analysis data, T and some O lack competitor reference, Porter's Five Forces competitive rivalry score may not be precise enough | Require user to provide competitor names, positioning, and differentiation descriptions or upload competitor-analysis.json file |
| bmc.json | User provides product status description → generate analysis based on description | Lacking BMC data, S/W correlation with business model may be weak | Require user to provide key business model elements or upload bmc.json file |
| Market data (tam-som / pest) | User provides industry info → assess based on AI knowledge | Lacking market data, industry attractiveness assessment lacks quantitative basis | Require user to provide market size and industry trend data or upload tam-som.json/pest.json files |
| Internal capability assessment (user-provided) | Prompt user to provide or skip input-related steps | S/W lacks internal data support, may be subjective | Require user to provide internal assessment info such as team capability, tech stack, and resource constraints |
| Current product/market definition | User provides product status → position Ansoff quadrant | Lacking structured product market definition, quadrant positioning may not be precise enough | Require user to provide current product positioning and target market description |
| All upstream files missing | Prompt user to execute prior stages first, or generate analysis directly based on user-provided product status description | Overall confidence significantly lowered, analysis mainly AI inference | Require user to provide product status, industry info, and internal capability assessment |

## Data Acquisition Notes

This Skill requires exploration output, competitive analysis, and BMC data. Please provide via one of the following:
  1. Directly describe product status, strengths, and challenges
  2. Upload competitor-analysis.json / bmc.json and other files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Data Source | Change Type | Affected Dimension | Impact Description | Response Strategy |
|-----------|----------|----------|----------|----------|
| persona/opportunity-definition | User insight update | SWOT's O and T | User insight changes affect opportunity and threat assessment | Re-execute SWOT Steps 3-4, update opportunities and threats |
| competitor-analysis.json | Competitor data update | SWOT's T and some O / Porter's Five Forces Force1 and Force5 | Competitor changes affect threat assessment and competitive analysis | Re-execute SWOT Steps 3-4 and Porter's Five Forces Force1/5 |
| bmc.json | Business model change | SWOT's S and W | Business model changes affect strengths and weaknesses | Re-execute SWOT Steps 1-2 |
| tam-som.json | Market size change | Porter's Five Forces industry attractiveness / Ansoff feasibility | Market data changes affect attractiveness assessment | Recalculate industry attractiveness overall score and Ansoff feasibility |
| pest.json | Policy/technology environment change | Multiple factors in Porter's Five Forces | Environment changes affect multiple force assessments | Re-assess affected forces |
| okr.json | Growth objective adjustment | Ansoff growth path recommendation | Growth objective changes affect path direction | Re-execute Ansoff Step 2 |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Field | Notification Timing | Notification Content |
|-----------|----------|----------|----------|
| planning-okr | `strategic_conclusions.integrated_recommendations` | After strategic conclusions change | Notify strategic direction adjustment and priority changes |
| planning-roadmap | `strategic_conclusions.integrated_recommendations` | After strategic conclusions change | Notify strategic direction adjustment |
| business-strategy-report | `swot.strategies` / `ansoff.growth_paths` / `porter.industry_attractiveness` | After each framework analysis changes | Notify analysis result changes |
