---
name: strategic-analysis
description: Used when product strategy analysis, competitive strategy judgment, or strategy framework selection is needed. Automatically selects applicable strategy frameworks (SWOT/Ansoff/Porter's Five Forces) based on product stage and industry characteristics.
---
# Strategic Analysis

## When to use
- Help me analyze strengths and weaknesses
- What are our opportunities and threats
- How should we expand the market
- Where is the next growth direction
- Is this industry worth entering
- Analyze the industry competitive landscape
- Do a strategic analysis
- Keywords: strategic analysis, SWOT, Ansoff Matrix, Porter's Five Forces, strategic planning

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

> See [Reference/porter-five-forces-scoring.md](./Reference/porter-five-forces-scoring.md) for the 1-5 scoring standards and assessment factors for all five forces (new entrants, substitutes, supplier power, buyer power, competitive rivalry).

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

### Output Schema, Validation Rules, and JSON Example

> See [Reference/output-schema.md](./Reference/output-schema.md) for the output JSON schema (framework_selection, swot, ansoff, porter, strategic_conclusions, metadata), per-framework field validation rules, and a complete strategic-analysis JSON example.

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
