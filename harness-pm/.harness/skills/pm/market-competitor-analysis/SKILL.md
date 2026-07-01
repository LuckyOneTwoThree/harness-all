---
name: market-competitor-analysis
description: Used when comprehensive competitive analysis, competitive research, or competitive positioning judgment is needed. Integrates competitor intelligence collection, four-quadrant positioning, and competitor reports. Keywords: competitive analysis, competitive research, competitor intelligence, four-quadrant, competitors.
---
# Comprehensive Competitive Analysis

## When to use
- Help me do competitive analysis
- How to do competitive research
- Help me map the competitive landscape
- Produce a competitive analysis report
- What new moves have competitors made recently
- Which are direct competitors, which are indirect

## Outputs
- docs/discovery/market-analysis.md
- memory/progress.md

## Core Principles

1. **Multi-source cross-validation** — Each key finding must be cross-validated by at least 2 independent sources. Strategy inference confidence is highest when hiring, financing, and feature update signals converge.
2. **Change is signal** — Every competitor feature change, pricing adjustment, and hiring change is a strategic signal, not an isolated event.
3. **Tiered alert response** — P0 (impact ≥ 5) urgent notification; P1 (impact = 4) immediate notification + weekly report; P2 (impact < 4) weekly report only.
4. **Strategy inference confidence annotation** — Hiring-inferred confidence 0.5-0.7; financing + hiring dual signal 0.7-0.9; official announcement 0.9+. Low-confidence inferences must be escalated for human validation.
5. **Four-quadrant definition first** — Direct/indirect/substitute/potential have strict definitions. Classification must be based on definitions, not intuition.
6. **Inter-quadrant flow traceable** — Competitors may flow between quadrants. Annotate flow signals and estimated timeline.
7. **Potential competitors default to validation** — Every potential competitor item defaults to needs_human_validation=true.
8. **Empty quadrant is a risk signal** — An empty quadrant is "no competitors identified", not "no competitors". Must annotate as needing supplementation.
9. **Data-driven conclusions first** — Every conclusion must be supported by data or evidence.
10. **Structured output deliverable** — Reports are for decision makers. Readability first.
11. **Insight over data piling** — Every piece of data must answer "so what".
12. **Actionable recommendations** — Strategic recommendations must be specific to "what to do + why + expected effect".

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| competitor_list | array | Yes | User-provided | Competitor list, each item contains name, category, official website URL |
| category_keywords | string | Yes | User-provided | Category keywords, e.g., "online education", "SaaS CRM" |
| monitor_config | object | No | User-provided | Monitoring config, including scan frequency, focus dimensions, alert thresholds |
| Market size data | JSON | ○ | docs/discovery/market-analysis.md ("Market Size" section) | TAM/SAM/SOM and growth rate |
| Macro environment data | JSON | ○ | docs/discovery/market-analysis.md ("PEST Analysis" section) | PEST four-dimension trends |
| Own product info | string/markdown | ○ | User-provided | Own product positioning, core features, target users, current status |

## Execution Steps

### Step 1: Competitor Intelligence Collection [Core]

Multi-source information collection, covering all-around competitor dynamics:

| Collection Source | Collection Content | Collection Frequency |
|--------|---------|---------|
| App version update monitoring | Version number, release notes, feature changes, release time | Each version release |
| Official website/blog updates | Product page changes, new feature announcements, strategy articles, pricing page changes | Daily |
| App review collection | User ratings, review content, sentiment, high-frequency keywords | Weekly |
| Pricing page monitoring | Price changes, plan adjustments, promotional activities, new pricing models | Daily |
| Job posting monitoring | New positions, position count changes, tech stack requirements, geographic distribution | Weekly |
| Industry news/financing info | Funding rounds and amounts, strategic partnerships, M&A, industry rankings | Real-time |

**Job posting strategy inference rules:**
- Mass hiring for a specific tech stack position → infer technology direction investment
- New overseas positions → infer internationalization strategy
- Sharp drop in hiring volume → infer cost contraction or strategic adjustment
- New AI/ML positions → infer intelligence direction

**Sub-steps:** Feature Matrix Auto-Update [Conditional], Competitor User Reputation Comparison [Conditional], Pricing Strategy Comparison [Conditional], Feature Update Interpretation [Deep], Strategic Direction Inference [Deep]. Change types: Added/Upgraded/Removed/Downgraded; impact degree 1-5 scale; real-time alert when impact ≥ 4.

### Step 2: Four-Quadrant Positioning [Core]

#### Direct Competitor Identification
**Definition:** Same category + same target users + same core features. Identification via app store categories, product directories, SEO competitor analysis, industry associations.

#### Indirect Competitor Identification
**Definition:** Same user scenario + different solutions. Identification via user feedback alternatives, search term association, scenario mapping, community discussions.

#### Substitute Identification
**Definition:** Users' current non-productized solutions. Identification via user interview data, surveys, forums/communities, industry reports.

#### Potential Competitor Identification
**Definition:** Companies capable of entering this field. Identification via job posting monitoring, patent analysis, financing info, strategic announcements, value chain analysis.

> See [Reference/examples.md](./Reference/examples.md) for the four-quadrant data source tables (Direct/Indirect/Substitute/Potential).

#### Confidence Assessment and Human Validation Annotation [Conditional]

**Confidence tiers:**
- High (0.8-1.0): Multi-source cross-validation, classification certain
- Medium (0.5-0.8): Data-supported but single source or partially contradictory
- Low (<0.5): Inferential conclusion, needs human validation

#### Inter-Quadrant Flow Annotation [Deep]

> See [Reference/examples.md](./Reference/examples.md) for the Inter-Quadrant Flow Annotation table.

### Step 3: Competitive Analysis Report [Core]

#### Data Integration and Competitor Profile Construction

**Competitor filtering rules:**
- Deep profile count: 3-5 core competitors (direct competitors prioritized)
- When exceeding 5, sort by threat level and take Top 5
- Indirect/substitute competitors: take 1-2 representative cases each

> See [Reference/examples.md](./Reference/examples.md) for the Competitor Profile Construction table.

#### SWOT Analysis (per competitor) [Conditional]

Generate SWOT for each core competitor (Strengths/Weaknesses/Opportunities/Threats).

> See [Reference/examples.md](./Reference/examples.md) for the SWOT Cross-Strategy Matrix.

#### Perceptual Map [Conditional]

Draw a perceptual map based on two core dimensions.

> See [Reference/examples.md](./Reference/examples.md) for the Perceptual Map Dimension Selection table and Mermaid quadrant chart example.

#### Competitive Moat Assessment [Deep]

> See [Reference/examples.md](./Reference/examples.md) for the Moat Assessment table (7 dimensions, 0-5 scale) and depth rating.

#### Market Share Estimation [Deep]

> See [Reference/examples.md](./Reference/examples.md) for the Market Share Estimation Methods table and HHI concentration assessment.

#### Differentiation Strategy Recommendations [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Differentiation Strategy Derivation table. Each strategy includes name, description, evidence, expected impact, risks, and priority (P0/P1/P2).

#### Report Assembly

> See [Reference/examples.md](./Reference/examples.md) for the complete Report Structure template.

## Output

**Storage path**: `docs/discovery/market-analysis.md ("Competitive Analysis" section)` — primary output (human-readable report section).

**Structured data**: `competitor-analysis.json` (intermediate artifact, consumed by downstream skills for quadrant/intel data; not the primary deliverable).

> See [Reference/schema.md](./Reference/schema.md) for the competitor-analysis.json Output Schema and Output Validation Rules.

## Decision Rules

| Rule | Trigger Condition | Action |
|------|---------|------|
| P0 alert (auto-notification + urgent mark) | Feature change impact degree ≥ 5 | Immediate notification to human PM, mark as needing urgent response, do not wait for weekly report cycle |
| P1 alert (auto-notification) | Feature change impact degree 4 | Immediate notification to human PM, include in next weekly report detailed analysis |
| Strategy inference escalation | Competitor strategy inference confidence < 0.5 | Escalate to human judgment, mark as needing validation |
| Pricing change alert | Competitor pricing changes | Notify human PM of pricing change details and impact analysis |
| Reputation anomaly alert | Competitor reputation shows major fluctuation (sentiment distribution change > 15%) | Notify human PM of reputation change analysis |
| Potential competitor needs validation | Any item in potential competitor quadrant | Default needs_human_validation=true; confidence typically low, needs human confirmation |
| Quadrant minimum fill | Any quadrant empty | Annotate quadrant as needing supplementation, suggest user provide leads |
| Low confidence annotation | Confidence < 0.5 | Annotate as needing human validation, explain uncertainty reason |
| Core competitor count < 3 | Competitor deep analysis stage | Annotate as "insufficient competitor coverage", recommend supplementing competitors before generating report |
| Core competitor count > 7 | Competitor deep analysis stage | Sort by threat level, take Top 5 for deep analysis, rest in summary table |
| Insufficient moat assessment data | Moat assessment stage | Annotate confidence for each dimension, provide inference basis for low-confidence dimensions |
| No public market share data | Market share estimation stage | Use relative share estimation, explicitly annotate as "estimated value" and estimation method |
| Own product info missing | Differentiation strategy recommendation stage | Differentiation strategy recommendations annotated as "general recommendations", need adjustment based on own situation |
| PEST data missing | Market overview stage | Skip macro environment section in market overview, annotate as "lacking PEST data" |

## Quality Checks

- [ ] Feature Matrix updated, changes annotated with type and impact degree (P1)
- [ ] Competitor reputation comparison completed (P1)
- [ ] Differentiation opportunities identified (P0)
- [ ] Pricing strategy comparison completed (P1)
- [ ] Strategic direction inference completed, low confidence annotated (P2)
- [ ] Alerts triggered (changes with impact degree ≥ 4) (P0)
- [ ] Data sources annotated (P0)
- [ ] Key findings cross-validated by multiple sources (at least 2 independent sources) (P0)
- [ ] Four quadrants populated (direct/indirect/substitute/potential) (P0)
- [ ] At least 1 item per quadrant (empty quadrants annotated as needing supplementation) (P0)
- [ ] Each item annotated with data source (data_source) (P0)
- [ ] Each item annotated with confidence (confidence) (P1)
- [ ] Potential competitors annotated as needing human validation (needs_human_validation=true) (P1)
- [ ] Low-confidence items annotated (P1)
- [ ] Empty quadrants annotated as needing supplementation (not "no competitors" but "not identified") (P1)
- [ ] Inter-quadrant flow signals annotated (when signals exist) (P2)
- [ ] Executive summary contains 3 core findings + Top 1 strategy (P0)
- [ ] Each core competitor has complete SWOT analysis (P1)
- [ ] Competitive perceptual map generated, including own product positioning (P1)
- [ ] Moat assessment covers 7 dimensions (P2)
- [ ] At least 3 differentiation strategies, each with basis and priority (P1)
- [ ] All inferences annotated with confidence (P1)
- [ ] Data sources listed (P0)
- [ ] Markdown report format complete, directly deliverable (P0)

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| Competitor list | User provides category keywords → AI search identifies competitors, annotate as "competitor list is AI-inferred" | competitors[].name annotated as "AI-inferred", strategic_signals.confidence upper limit lowered to 0.5 | Require user to provide competitor name list or category keywords |
| All upstream files missing | User provides category keywords → search and identify competitors based on AI knowledge base and execute analysis | All inferences annotated as "AI knowledge base inference", needs_human_validation defaults to true, alerts only in weekly report, no immediate notification | Require user to provide category keywords and competitor name list |
| monitor_config | Skip input-related steps, use default monitoring config (scan frequency: daily, focus dimensions: all, alert threshold: impact degree ≥ 4) | Output does not include monitor_config-related customized fields, alert threshold fixed at ≥ 4 | Require user to provide monitoring frequency, focus dimensions, and alert threshold config |
| TAM/SOM data missing | Market overview section annotated as "lacking market size data" | Market overview section incomplete | Require user to provide market size data or upload tam-som.json file |
| PEST data missing | Skip macro environment section | Market overview lacks macro perspective | Require user to provide macro environment data or upload pest.json file |
| Own product info missing | Differentiation strategies annotated as "general recommendations" | Strategies need adjustment based on own situation | Require user to provide own product features, positioning, and core advantages description |
| If user does not provide category_keywords | Prompt user to provide category keywords, otherwise competitive analysis scope cannot be determined | Cannot generate output | Require user to provide category keywords (e.g., "online education", "SaaS CRM") |

## Data Acquisition Notes

This Skill requires a competitor list or category keywords. Please provide via one of the following:
  1. Directly provide competitor name list and category keywords
  2. Upload competitor data files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream File | Change Type | Impact on This Skill | Response Action |
|---------|---------|---------------|---------|
| pest.json | Political/regulatory change | Affects competitor compliance cost assessment, may change compliance cost dimension in pricing strategy comparison | Re-evaluate affected competitors' pricing.value_score, update compliance-related inferences in strategic_signals |
| pest.json | Technology dynamics change | Affects competitor technology direction judgment, may change impact assessment of technology features in Feature Matrix | Re-evaluate impact_degree of related feature changes, update technology direction inferences in strategic_signals |
| tam-som.json | Market size data change | Affects competitive landscape assessment, may change market expansion/contraction judgment in competitor strategy inference | Re-evaluate competitor strategic_signals.direction, adjust confidence value |
| tam-som.json | Segment market data change | Affects competitor target audience migration direction inference | Update audience migration-related inferences in strategic_signals, re-evaluate differentiation opportunities |

### Downstream Notification Mechanism Table

| This Skill Output Change | Notify Downstream Skill | Notification Content | Trigger Condition |
|---------------|-------------|---------|---------|
| Differentiation strategy change | prd-orchestrator | Changed strategy name, adjustment direction, new priority | Strategy added/removed/priority adjusted |
| Major competitive landscape change | release-orchestrator | Landscape change description, impact assessment | HHI index crosses threshold, core competitor added/exited |
| Significant market size change | opportunity-definition | New market size data, change reason | TAM/SAM/SOM change magnitude > 20% |
| Moat assessment change | insight-analysis | Competitor name, old level → new level | Core competitor moat level crosses tier |
| Perceptual map blank area change | prd-orchestrator | Blank area change description | Blank area disappears or new blank appears |
