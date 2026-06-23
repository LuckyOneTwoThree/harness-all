---
name: market-tam-som
description: Used when evaluating the TAM/SAM/SOM size of the target market. Market size auto-estimation, supports top-down and bottom-up dual-path cross-validation, marks and escalates to human judgment when divergence > 20%, outputs range estimates and confidence assessment. Keywords: market size, TAM, SAM, SOM, market capacity, range estimate, dual-path cross-validation, how big is the market, ceiling, growth potential.
metadata:
  module: "Product Discovery"
  sub-module: "Market & Competition"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["Internet", "Finance", "General"]
  trigger_examples:
    - "How big is this market"
    - "Help me estimate the market size"
    - "Where is our ceiling"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output market size estimation"
  deep_description: "Full estimation + segment market breakdown + growth rate forecast + market entry prioritization"
reads:
  - rules/security.md
  - loops/LOOP.md
writes:
  - docs/discovery/market-analysis.md
  - memory/progress.md
---

# Market Size Auto-Estimation

## Core Principles

1. **Dual-path cross-validation** — Top-down and bottom-up paths are estimated independently; when divergence > 20%, must be marked and escalated to human judgment. Single-path conclusions are unreliable.
2. **Range over point estimate** — All size numbers output range estimates (optimistic/neutral/conservative), not a single deterministic value, because certainty in market size is an illusion.
3. **Explicit assumptions** — Assumptions for each estimation step must be explicitly listed (assumption/basis/impact_direction); assumptions whose change affects results by > 30% are marked as highly sensitive.
4. **Tiered confidence** — TAM confidence is highest (supported by industry data), SAM next (with filter coefficients applied), SOM lowest (with competition and resource constraints applied). Decreasing layer by layer is normal.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| category_keywords | string | Yes | User-provided | Category keywords, e.g., "online education", "SaaS CRM" |
| geographic_scope | string | Yes | User-provided | Target market geographic scope, e.g., "Mainland China", "Southeast Asia" |
| time_range | string | Yes | User-provided | Estimation time range, e.g., "2025-2027" |

## Execution Steps

### Step 1: TAM Estimation [Core]

Adopts dual-path cross-validation:

**Top-down path:**
- Obtain industry total size data (statistics bureau/industry association/third-party research reports)
- Determine the target category's share of the industry
- Calculate: TAM = Industry total size × Target category share

**Bottom-up path:**
- Estimate total target users (population base × target audience penetration rate)
- Obtain ARPU (average revenue per user per year) reference value
- Calculate: TAM = Target user count × ARPU

**Output requirements:**
- Range estimate: optimistic / neutral / conservative
- Each estimate annotates data source
- When divergence between the two paths > 20%, mark as needing human judgment

### Step 2: SAM Estimation [Core]

Filter layer by layer on top of TAM:

| Filter Dimension | Description |
|---------|------|
| Geographic scope limit | Trim to target region market size based on geographic_scope |
| Target audience filter | Exclude non-target audiences, apply audience profile filter coefficient |
| Service capability boundary | Deduct portions that own channels/technology/compliance cannot cover |

**Calculation logic:** SAM = TAM × Geographic coefficient × Audience coefficient × Service capability coefficient

**Output requirements:**
- Each filter coefficient and its basis
- SAM range estimate (optimistic/neutral/conservative)

### Step 3: SOM Estimation [Core]

Apply competition and resource constraints on top of SAM:

| Constraint Dimension | Description |
|---------|------|
| Competitive landscape | Existing competitor share + competitor barrier strength |
| Own resource constraints | Team size / funding / technology reserves / channel resources |
| Acquisition capability estimate | Expected acquisition channel efficiency + conversion rate + retention rate |

**Calculation logic:** SOM = SAM × (1 - Competition constraint%) × (1 - Resource constraint%) × (1 - Acquisition constraint%)

> SOM uses SAM as the base, deducting competition, resource, and acquisition constraints layer by layer to obtain the obtainable market share.

**Output requirements:**
- SOM range estimate (optimistic/neutral/conservative)
- Achievable timeline (6-month/12-month/24-month milestones)

### Step 4: Confidence Assessment [Core]

Assess the credibility of the overall estimation results:

| Assessment Dimension | Method |
|---------|------|
| Data source reliability | Evaluate reliability score (0-1) for each data source; sources include official statistics, industry associations, third-party research reports, expert interviews, etc. |
| Assumption sensitivity analysis | Apply ±20% variation to key assumptions and observe impact magnitude on final results |
| Key assumption annotation | List all core assumptions, annotate assumption content, basis, and impact direction on results |

**Output requirements:**
- Overall confidence score (0-1)
- Key assumption list and sensitivity analysis results
- Low-confidence data points annotated

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Market size estimation | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full estimation + segment market breakdown + growth rate forecast + market entry prioritization | Full artifact + extended analysis + deep projection |

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

## Decision Rules

| Rule | Trigger Condition | Action |
|------|---------|------|
| Low data source reliability | Data source reliability score < 0.5 | Mark as needing human validation, suspend use of that data point |
| High assumption sensitivity | Key assumption change impact on result > 30% | Mark as highly sensitive assumption, recommend human confirmation |
| Large dual-path divergence | Top-down and bottom-up result divergence > 20% | Mark as needing human judgment, provide divergence analysis |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] TAM/SAM/SOM three-tier estimation complete
- [ ] Each tier includes range estimates (optimistic/neutral/conservative)

### P1 Checks (standard/deep must pass)

- [ ] Key assumptions annotated
- [ ] Data sources listed
- [ ] Confidence score completed
- [ ] Low-reliability data sources annotated as needing human validation
- [ ] Highly sensitive assumptions annotated

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep projection and roadmap generated)
- [ ] Decision record complete (key decisions have basis and alternatives)

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| No strong dependencies | This Skill can run independently; user provides category keywords and target market to execute | No impact, output complete | Require user to provide category keywords and target market |
| All upstream files missing | User provides category keywords and target market → estimate TAM/SAM/SOM based on public data in AI knowledge base | Data source reliability score lowered, confidence.overall_score may be < 0.5, marked as "based on AI knowledge base inference" | Require user to provide category keywords (e.g., "online education") and target market (e.g., "Mainland China") |
| If user does not provide category_keywords | Prompt user to provide category keywords, otherwise market size estimation cannot be executed | Cannot generate output, flow blocked | Require user to provide category keywords (e.g., "online education", "SaaS CRM") |
| If user does not provide geographic_scope | Prompt user to provide target market geographic scope, otherwise default to "Global" | sam.geo_coefficient defaults to 1.0 (no geographic filter), SAM = TAM, confidence lowered | Require user to provide target market geographic scope (e.g., "Mainland China", "North America") |
| If user does not provide time_range | Prompt user to provide estimation time range, otherwise default to 3 years from current year | time_range field is an inferred value, marked as "default value", trend forecast accuracy lowered | Require user to provide estimation time range (e.g., "2024-2026") |

## Data Acquisition Notes

This Skill requires category keywords and target market information. Please provide via one of the following:
  1. Directly input category keywords (e.g., "online education", "SaaS CRM") and target market (e.g., "Mainland China")
  2. Upload market research data files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream File | Change Type | Impact Scope | Impact Description |
|---------|---------|---------|---------|
| pest.json | Political/regulatory change | SAM geographic coefficient, SAM audience coefficient | New policies may expand or shrink the serviceable market scope; need to re-evaluate geo_coefficient and audience_coefficient |
| pest.json | Economic indicator change | TAM industry total size | GDP/consumer spending and other indicator changes directly affect top_down path's industry_total |
| pest.json | Technology dynamics change | SAM service capability coefficient | New technology breakthroughs may improve service_coefficient, expanding serviceable boundaries |
| competitor-analysis.json | Competitive landscape change | SOM competition constraint coefficient | New competitor entry or competitor share changes directly affect competition_constraint |
| competitor-analysis.json | Competitor pricing strategy change | SOM acquisition constraint coefficient | Competitor price wars may increase acquisition costs, affecting acquisition_constraint |

### Downstream Notification Mechanism Table

| Trigger Event | Notify Target | Notification Content | Priority |
|---------|---------|---------|--------|
| TAM neutral value change > 20% | market-competitor-analysis | TAM size significantly changed, recommend re-evaluating market attractiveness and competitive strategy | High |
| SAM filter coefficient adjustment > 0.1 | market-competitor-analysis | Serviceable market scope changed, recommend updating competitor coverage analysis | Medium |
| SOM obtainable share change > 30% | opportunity-definition | Obtainable market size significantly changed, recommend re-evaluating opportunity score | High |
| Key assumption added or changed | All downstream Skills | New/changed key assumption may affect analysis conclusions that depend on this Skill's output | Medium |
| confidence.overall_score drops to < 0.5 | All downstream Skills | Overall confidence below threshold; downstream usage of this output should attach uncertainty notes | High |
