---
name: market-tam-som
description: Used when evaluating the TAM/SAM/SOM size of the target market. Market size auto-estimation, supports top-down and bottom-up dual-path cross-validation, marks and escalates to human judgment when divergence > 20%, outputs range estimates and confidence assessment.
---
# Market Size Auto-Estimation

## When to use
- How big is this market
- Help me estimate the market size
- Where is our ceiling
- Keywords: market size, TAM, SAM, SOM, market capacity, range estimate, dual-path cross-validation, how big is the market, ceiling, growth potential

## Outputs
- docs/discovery/market-analysis.md
- memory/progress.md

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

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


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
