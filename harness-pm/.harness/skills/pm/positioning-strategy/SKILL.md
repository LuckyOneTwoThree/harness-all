---
name: positioning-strategy
description: Used when developing product positioning, differentiation strategy, or positioning statements. Integrates positioning statement, value curve, differentiation assessment, and exclusion strategy. Keywords: product positioning, positioning strategy, differentiation, value curve, positioning statement.
metadata:
  module: "Product Business & Strategy"
  sub-module: "Product Positioning & Differentiation"
  type: "pipeline"
  version: "3.0"
  domain_tags: ["General"]
  trigger_examples:
    - "Help me define product positioning"
    - "Write a positioning statement"
    - "Analyze our differentiation advantages"
    - "Where do we differ from competitors"
    - "Is our differentiation sustainable"
    - "Which users are not our target"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output positioning statement and differentiation strategy"
  deep_description: "Complete strategy + positioning validation plan + differentiation quantitative assessment + positioning evolution roadmap"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/strategy/business-strategy.md
  - docs/discovery/market-analysis.md
  - docs/discovery/user-research.md
writes:
  - docs/strategy/positioning.md
  - memory/progress.md
---

# Product Positioning Strategy Development

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

## Input

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
Use positioning formula to generate 3-5 positioning statements:

**Positioning Formula**:
```
For [target user], [product name] is a [category definition],
it [core value], unlike [competitor reference], [differentiation point]
```

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
Score each competitor 1-5 on competitive factors:

**Scoring Standard**:
```
5: Industry leading, significantly better than competitors
4: Excellent, better than most competitors
3: Industry average
2: Below industry average
1: Clearly insufficient
```

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
Calculate differentiation strength via area method:

```
Differentiation Strength = Area difference between our curve and competitor average curve / Maximum possible area difference
```

- Strength ≥ 0.7: Strong differentiation
- Strength 0.5-0.7: Medium differentiation
- Strength < 0.5: Weak differentiation (triggers warning)

### Step 3: Differentiation Assessment [Core]

#### Feature Differentiation Assessment
Assess the differentiation degree of product features:

| Score | Meaning | Description |
|------|------|------|
| 5 | Hard to replicate | Competitors need 12+ months to catch up |
| 3 | Medium difficulty | Competitors need 3-6 months to catch up |
| 1 | Easy to replicate | Competitors can replicate within 3 months |

Assessment Dimensions:
- Core feature uniqueness
- Technical complexity
- Data accumulation advantage

#### Experience Differentiation Assessment
Assess differentiation at the user experience level:

| Score | Meaning | Description |
|------|------|------|
| 5 | Hard to catch up | User habits formed, high switching cost |
| 3 | Medium difficulty | Requires continuous investment to maintain |
| 1 | Easy to catch up | Experience factors can be quickly replicated |

Assessment Dimensions:
- User habit cultivation degree
- Interface/interaction uniqueness
- Usage flow efficiency

#### Scenario Differentiation Assessment
Assess the depth of vertical scenario cultivation:

| Score | Meaning | Description |
|------|------|------|
| 5 | Deep scenario | Deep understanding of industry know-how |
| 3 | Medium scenario | Covers mainstream scenarios |
| 1 | Shallow scenario | Only general features |

Assessment Dimensions:
- Scenario coverage depth
- Industry professional knowledge
- Scenario solution completeness

#### Business Differentiation Assessment
Assess business model uniqueness:

| Score | Meaning | Description |
|------|------|------|
| 5 | Unique model | Business model is hard to replicate |
| 3 | Replicable model | Model can be learned but has barriers |
| 1 | Homogeneous model | Same as industry common model |

Assessment Dimensions:
- Revenue structure uniqueness
- Cost structure advantage
- Business model moat

#### Ecosystem Differentiation Assessment
Assess ecosystem differentiation strength:

| Score | Meaning | Description |
|------|------|------|
| 5 | Strong ecosystem | Multi-party participation, strong network effects |
| 3 | Medium ecosystem | Has some partners |
| 1 | Weak ecosystem | Single product |

Assessment Dimensions:
- Number of partners
- Network effect strength
- Ecosystem lock-in ability

#### Composite Differentiation Strength Calculation
Weighted calculation of composite differentiation strength:
```
Composite Differentiation Strength = (Feature differentiation×0.25 + Experience differentiation×0.20 + Scenario differentiation×0.25 + Business differentiation×0.15 + Ecosystem differentiation×0.15) / 5
```

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

**positioning-strategy.json Output Schema**:

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

### Output Validation Rules

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

## Decision Rules

| Condition | Decision |
|------|------|
| Quality gate all 5 pass | Positioning statement can be output |
| Quality gate not passed | Auto-retry up to 3 times; if still fails, escalate to human |
| Differentiation strength <0.5 | Trigger warning, recommend strategy adjustment |
| Blue ocean actions | Requires human approval |
| Competitive factors | Requires human calibration |
| Each dimension score | Requires human calibration of subjective dimensions |
| Composite recommendation | Requires human final judgment |
| Disputed points | Escalate to human decision |
| Excluded user group overlap with core users ≥30% | Reject exclusion recommendation, mark "Exclusion scope conflicts with core users" |
| Excluded user group overlap with core users <30% | Generate exclusion recommendation, mark as "AI suggestion, requires human approval" |
| Potential market reduction ≥50% after exclusion | Mark high risk, mandatory human approval |
| Potential market reduction <50% after exclusion | Normal process, human approval |
| Competitor already covers this excluded user group | Mark "Competitor already covers, exclusion needs differentiation rationale" |
| Exclusion rationale lacks data support (0 data points) | Return for data supplementation, cannot submit for approval |
| Exclusion rationale has ≥2 data points | Can submit for human approval |
| Disputed decision (2+ stakeholders object) | Escalate to multi-party review |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] 3-5 positioning statements generated
- [ ] Each statement uses positioning formula

### P1 Checks (must pass for standard/deep)

- [ ] 5 quality checks completed
- [ ] Recommendation ranking is reasonable
- [ ] Differentiation sources are diverse
- [ ] 5-8 competitive factors extracted
- [ ] Our and competitor scoring completed
- [ ] Blue ocean four actions identified
- [ ] Differentiation strength calculated
- [ ] Scoring basis annotated
- [ ] All 5 dimensions assessed, no omissions
- [ ] Scores have data support, avoid subjective bias
- [ ] Recommendation rationale consistent with scoring logic
- [ ] Action recommendations can be converted to product strategy
- [ ] Exclusion decisions consistent with product vision
- [ ] Clear exclusion rationale
- [ ] Exclusion statement can be clearly communicated to team
- [ ] Alternative recommendations provided for excluded users

### P2 Checks (must pass for deep only)

- [ ] Extended analysis complete (deep simulation and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files are missing, this skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| evaluation_report.json (value proposition match) | User provides product value description → generate positioning statement | Lacks value match data, core value may not be precise enough | Request user to provide product core value description or upload evaluation_report.json file |
| competitor-analysis.json (competitor analysis) | User provides product value description → generate positioning statement | Lacks competitor data, differentiation point and competitor reference lack basis | Request user to provide competitor name, positioning, and differentiation description or upload competitor-analysis.json file |
| evaluation_report.json + competitor-analysis.json | User provides product value description → generate positioning statement | Overall confidence reduced, positioning statement lacks data anchoring | Request user to provide product value description and competitor differentiation info |
| All upstream files missing | Prompt user to execute prior phases first, or generate positioning statement based on user-provided product value description | Overall confidence significantly reduced, positioning statement is only hypothetical inference | Request user to provide product value, target user, and competitor difference description |
| User insights data | If user insights data is missing, prompt user to provide or skip steps related to this input | Target user definition may not be precise enough | Request user to provide target user persona and core need description |
| bmc.json | User provides competitor info → draw value curve | Lacks BMC data, our score lacks value proposition anchoring | Request user to provide business model and value proposition description or upload bmc.json file |
| Self-capability assessment (user-provided) | If user does not provide self-capability assessment, prompt user to provide or skip steps related to this input | Feature and scenario differentiation assessment lacks internal data support | Request user to provide product feature completeness and technical capability self-assessment |

## Data Acquisition Notes

This skill requires value proposition match and competitor analysis data. Please provide via one of the following methods:
  1. Directly describe product value, target user, and competitor differences
  2. Upload evaluation_report.json / competitor-analysis.json files
  3. Provide data file path
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| evaluation_report value proposition match change | Core value extraction | Re-execute Step 1, update positioning statement |
| competitor-analysis competitor analysis update | Differentiation point and competitor reference | Re-execute Step 1-2, update differentiation factors |
| persona user persona update | Target user definition | Re-execute Step 1, update target user |
| competitor-analysis competitor data update | Competitor scores and blue ocean actions | Re-execute Step 2, update competitor scores |
| persona/voice-analysis user insights update | Competitive factor extraction | Re-execute Step 2, update competitive factors |
| bmc.json value proposition change | Our scores and blue ocean actions | Re-execute Step 2, update our scores |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Positioning statement change | business-strategy-report, planning-roadmap | Output file version number + change summary |
| Differentiation score change | business-strategy-report | Output file version number + change summary |
| Exclusion decision change | business-strategy-report, business-pricing | Output file version number + change summary |
| Market reduction assessment change | business-pricing | Output file version number + change summary |
