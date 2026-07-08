---
name: positioning-strategy
description: Used when developing product positioning, differentiation strategy, or positioning statements. Integrates positioning statement, value curve, differentiation assessment, and exclusion strategy.
---
# Product Positioning Strategy Development

## When to use
- Help me define product positioning
- Write a positioning statement
- Analyze our differentiation advantages
- Where do we differ from competitors
- Is our differentiation sustainable
- Which users are not our target
- Keywords: product positioning, positioning strategy, differentiation, value curve, positioning statement

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/strategy/business-strategy.md
- docs/discovery/market-analysis.md
- docs/discovery/user-research.md

## Outputs
- docs/strategy/positioning.md
- memory/progress.md

## Core Principles

1. **Formulaic generation** — Use [target user]+[product name]+[core value]+[differentiation point] positioning formula
2. **3-5 candidate comparison** — Generate 3-5 differentiated positioning statements, with different differentiation sources/user granularity/competitor references
3. **Five-item quality gate** — All five checks (specific/differentiated/exclusive/verifiable/concise) must pass before output
4. **Retry on failure** — Auto-retry up to 3 times if quality check fails; if still fails, escalate to human
5. **User-driven competitive factors** — Competitive factors extracted from user research, not subjectively set by AI
6. **Blue ocean four actions framework** — All four actions (Eliminate/Reduce/Raise/Create) must be identified
7. **Differentiation strength quantification** — Calculate differentiation strength 0-1 score via area method, <0.5 triggers warning
8. **Multi-party score comparison** — Compare our scores with each major competitor on the same factors, visualize differences
9. **Five-dimension full coverage** — All 5 dimensions (feature/experience/scenario/business/ecosystem) are indispensable
10. **Catch-up difficulty quantification** — Scoring criteria anchored to competitor catch-up time (3 months/6 months/12 months+), reject vague judgments
11. **Weighted composite score** — Weighted calculation of composite differentiation strength across dimensions; weights are adjustable but must be explicit
12. **Most sustainable recommendation** — Not only assess current differentiation, but also recommend the most sustainable differentiation source
13. **Exclusion is a strategic choice** — Exclusion is not lack of capability but focus; each exclusion must have a strategic rationale
14. **Overlap hard check** — Reject exclusion recommendation when excluded users overlap with core users ≥30%
15. **Market reduction warning** — Mandatory human approval when potential market reduction ≥50% after exclusion
16. **Alternative must be provided** — Provide alternative recommendations for excluded user groups; cannot exclude without guidance

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Value Proposition Match Result | JSON | Yes | docs/strategy/business-strategy.md ("Value Match" section) | Value proposition match score |
| Competitor Analysis Data | JSON | Yes | docs/discovery/market-analysis.md ("Competitor Analysis" section) | Competitor positioning, differentiation factors |
| User Insights | JSON | Yes | user-research-user-modeling | User personas, core needs |
| Value Proposition | JSON | Optional | docs/strategy/business-strategy.md ("Business Model Canvas" section) | Value proposition, Pain Relievers, Gain Creators |
| Self-Capability Assessment | JSON | Optional | User-provided | Technical barriers, resource advantages |

## Execution Steps

### Step 1: Positioning Statement [Core]

#### Positioning Element Extraction
Extract positioning elements from input data:

1. **Target User**: Extract core user group from user personas
2. **Core Value**: Extract high-match value from value proposition matching
3. **Differentiation Point**: Extract differentiation factors from competitor analysis
4. **Category Definition**: Define the product's category

#### Positioning Statement Generation
Use positioning formula to generate 3-5 positioning statements.

> See [Reference/assessment-rubrics.md](./Reference/assessment-rubrics.md#positioning-formula) for the positioning formula template.

**Generation Strategy**:
1. **Differentiation source variation**: Feature differentiation/experience differentiation/scenario differentiation
2. **User granularity variation**: Broad user group/precise user group
3. **Competitor reference variation**: Direct competitor/indirect competitor/traditional solution

#### Quality Gate Check
Perform 5 quality checks on each positioning statement:

| Check Item | Standard | Pass Condition |
|--------|------|----------|
| Specific | Target user and value are clear | User group is identifiable, value is perceivable |
| Differentiated | Clear difference from competitors | Differentiation point is verifiable |
| Exclusive | Not all competitors can claim this | At least 1 competitor cannot claim this |
| Verifiable | Can be verified by facts | Has quantifiable supporting evidence |
| Concise | Clear in one sentence | ≤30 words core expression |

#### Recommendation and Ranking
Based on quality gate check results, recommend and rank positioning statements:
- Statements passing all checks rank first
- Statements partially passing are annotated with improvement suggestions
- Statements not passing are annotated with elimination reasons

### Step 2: Value Curve Analysis [Core]

#### Competitive Factor Extraction
Extract 5-8 competitive factors from user research data:

**Extraction Logic**:
1. Extract high-frequency keywords from user-focused factors
2. Extract core value dimensions from value proposition
3. Extract competitor competitive dimensions from competitor analysis
4. Merge and deduplicate to form 5-8 competitive factors

**Factor Naming Convention**:
- Use user language (not technical terms)
- Each factor can be scored independently
- Factors do not overlap

#### Competitor Scoring
Score each competitor 1-5 on competitive factors.

> See [Reference/assessment-rubrics.md](./Reference/assessment-rubrics.md#competitor-scoring-standard-1-5) for the 1-5 scoring standard.

**Scoring Basis**:
- Feature completeness
- User reviews
- Pricing competitiveness
- Market share

#### Our Scoring
Score our product 1-5 on competitive factors:

**Scoring Principles**:
- Score objectively based on existing capabilities
- No exaggeration, no underestimation
- Annotate scoring basis

#### Blue Ocean Four Actions Identification
Based on value curve analysis, identify the 4 actions of blue ocean strategy:

**Eliminate**: Which competitive factors can be completely eliminated?
- Factors scored ≤2
- Factors users don't care about
- High-cost but low-value factors

**Reduce**: Which competitive factors can have lowered standards?
- Factors scored 3-4 but not core
- Over-invested factors
- Factors with medium user attention

**Raise**: Which competitive factors need to be raised?
- Core differentiation factors
- Factors users highly care about but scored low
- Factors where competitors are generally weak

**Create**: Which new competitive factors can be created?
- Unmet user needs
- Value not yet provided by competitors
- Innovative features or experiences

#### Differentiation Strength Calculation
Calculate differentiation strength via area method.

> See [Reference/assessment-rubrics.md](./Reference/assessment-rubrics.md#differentiation-strength-calculation) for the differentiation strength calculation formula and threshold interpretations (≥0.7 strong / 0.5-0.7 medium / <0.5 weak).

### Step 3: Differentiation Assessment [Core]

Assess differentiation across 5 dimensions (feature / experience / scenario / business / ecosystem).

> See [Reference/assessment-rubrics.md](./Reference/assessment-rubrics.md#five-dimension-differentiation-assessment-rubrics) for the detailed 5-dimension assessment rubrics (score tables for feature / experience / scenario / business / ecosystem differentiation with catch-up time anchors and assessment dimensions).

#### Composite Differentiation Strength Calculation

> See [Reference/assessment-rubrics.md](./Reference/assessment-rubrics.md#composite-differentiation-strength-calculation) for the weighted composite differentiation strength formula (Feature×0.25 + Experience×0.20 + Scenario×0.25 + Business×0.15 + Ecosystem×0.15).

#### Most Sustainable Differentiation Source Recommendation
Based on 5-dimension scores, recommend the most sustainable differentiation source:
1. Identify the highest-scoring dimension
2. Analyze sustainability rationale
3. Provide specific action recommendations

### Step 4: Exclusion Strategy [Core]

#### AI Analysis - Competitor Coverage Scan
AI scans competitor analysis data to identify:
- User groups mainly covered by each competitor
- User groups weakly covered/abandoned by competitors
- Potential differentiation opportunity points

#### AI Suggestion - Exclusion Candidate Generation
Based on positioning statements, AI generates 3-5 exclusion candidates:

**Exclusion Dimension Suggestions**:
1. **User characteristic dimension**: Exclude by demographic attributes
2. **Usage scenario dimension**: Exclude by usage scenario
3. **Need intensity dimension**: Exclude by need depth
4. **Payment ability dimension**: Exclude by willingness to pay

#### Human Decision - Final Exclusion Statement
Product owner decides based on AI analysis suggestions:

**Must clearly answer**:
1. Which user groups do we explicitly not serve?
2. Why not serve these users? (Strategic reasons)
3. What negative impacts would serving these users have?

**Decision Principles**:
- Exclusion is for focus, not simple abandonment
- Each exclusion should have a clear strategic rationale
- Exclusion decisions need to be consistent with long-term product vision

### Output Depth Classification

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Positioning statement and differentiation strategy | Core conclusions + minimum viable artifact |
| standard | Complete artifact (current default) | Complete artifact, including all Step outputs |
| deep | Complete strategy + positioning validation plan + differentiation quantitative assessment + positioning evolution roadmap | Complete artifact + extended analysis + deep simulation |

## Output

**Storage Path**: `docs/strategy/positioning.md`

**Output Files**:

| File | Format | Description |
|------|------|------|
| positioning-strategy.json | JSON | Structured data (including statement + value_curve + differentiation + exclusion) |
| positioning-strategy.md | Markdown | Complete positioning strategy report |

**positioning-strategy.json Output Schema**: See [Reference/output-schema.md](./Reference/output-schema.md#positioning-strategyjson-output-schema) for the JSON output schema.

### Output Validation Rules

> See [Reference/output-schema.md](./Reference/output-schema.md#output-validation-rules) for the field-level output validation rules table (positioning_statements / value_curve / differentiation_scores / exclusion field paths).

## Decision Rules

> See [Reference/decision-tables.md](./Reference/decision-tables.md#decision-rules) for the full decision rules table (quality gate, differentiation strength, blue ocean actions, exclusion overlap, market reduction, etc.).

## Quality Checks

> See [Reference/decision-tables.md](./Reference/decision-tables.md#quality-checks) for the detailed P0 / P1 / P2 quality check items.

---

## Degradation Strategy

> See [Reference/decision-tables.md](./Reference/decision-tables.md#degradation-strategy) for the upstream file missing degradation plan and data acquisition notes.

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md#upstream-change-response) for the upstream change impact table and downstream notification mechanism table.
