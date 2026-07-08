---
name: opportunity-definition
description: Used when opportunity identification, opportunity assessment, or product opportunity definition is needed. Integrates opportunity scoring, problem statement, HMW divergence, and opportunity brief.
---
# Opportunity Definition — Opportunity Identification & Definition

## When to use
- Help me evaluate this product opportunity
- Identify what product opportunities exist
- Define the problem we need to solve
- Generate an opportunity brief
- Is this opportunity worth pursuing
- Help me think about the problem from a different angle
- Keywords: opportunity identification, opportunity assessment, HMW, Problem Statement, opportunity brief, product opportunity

## Outputs
- docs/discovery/opportunity.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Good opportunities are defined, not discovered** — Opportunities are not objectively existing things waiting to be found; they are progressively defined through scoring validation, Problem Statement definition, and HMW reframing
2. **Scoring before divergence** — First score to determine opportunity priority (scoring), then diverge to explore innovation space (hmw); the order cannot be reversed, otherwise HMW will diverge in low-value directions
3. **Problem Statement is the anchor** — All HMW and Brief anchor to the Problem Statement; if the Problem Statement quality check fails, subsequent outputs are not credible
4. **Scoring is a recommendation, not a decision** — AI output is for decision reference; final priority ranking requires comprehensive human judgment; the strategic fit dimension must be judged by humans
5. **Divergence over convergence** — The HMW generation phase pursues quantity and breadth; filtering is left to human review; all four dimensions are indispensable
6. **Brief is a decision document, not data piling** — Every field must serve decision judgment; assumption risks drive the next step

## Interaction Mode

🤖→👤 AI suggests, human approves (the strategic fit dimension in the opportunity scoring phase 👤 is executed by humans)

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| User research data | JSON | Yes | docs/discovery/user-research.md (append "User Voice Analysis" section) / docs/discovery/user-research.md (append "User Behavior Analysis" section) | User pain points, behavior data, expectation data |
| Market analysis data | JSON | Yes | docs/discovery/market-analysis.md ("Market Size" section) | SOM estimate |
| Competitor analysis data | JSON | Yes | docs/discovery/market-analysis.md ("Competitive Analysis" section) | Competitor capabilities and moat analysis |
| Requirement insight data | JSON | ○ | docs/discovery/user-research.md (append "User Persona" section) / docs/discovery/insight.md | User personas, jobs to be done, requirement classification |
| Technical team assessment | object | ○ | User-provided | Feasibility assessment of existing tech stack |

## Execution Steps

### Step 1: Opportunity Scoring [Core]

Perform multi-dimensional quantitative scoring on product opportunities to determine priority.

**Scoring function**: Total score = Σ(dimension score × dimension weight)

#### Dimension 1: Problem Validity (weight 0.30)

| Score | Criteria |
|------|------|
| 5 | Pain point mention rate > 10% and corroborated by behavior data |
| 4 | Pain point mention rate > 10% but no behavior data corroboration |
| 3 | Pain point mention rate 5%-10% and corroborated by behavior data |
| 2 | Pain point mention rate 5%-10% but no behavior data corroboration |
| 1 | No direct data, pure assumption |

#### Dimension 2: Market Size (weight 0.25)

| Score | Criteria |
|------|------|
| 5 | SOM > 100 million |
| 4 | SOM 50 million - 100 million |
| 3 | SOM 10 million - 50 million |
| 2 | SOM 5 million - 10 million |
| 1 | Cannot be estimated |

#### Dimension 3: Solution Feasibility (weight 0.20)

| Score | Criteria |
|------|------|
| 5 | Directly implementable with existing tech stack |
| 4 | Existing tech stack needs minor extension |
| 3 | Need to introduce new technology but team has the capability |
| 2 | Need to introduce new technology and team needs to learn |
| 1 | Currently technically infeasible |

#### Dimension 4: Strategic Fit (weight 0.15) 👤 Human judgment

| Score | Criteria |
|------|------|
| 5 | Core strategic direction, highly aligned |
| 4 | Important strategic direction, well aligned |
| 3 | Related strategic direction, partially aligned |
| 2 | Marginal strategic direction, weakly aligned |
| 1 | Not within strategic direction |

> **Note**: AI provides strategic fit analysis recommendations, but the final score must be judged by humans. After AI scoring, this dimension is marked as `needs_human: true`.

#### Dimension 5: Competitive Moat (weight 0.10)

| Score | Criteria |
|------|------|
| 5 | Competitors lack this capability and cannot replicate in the short term |
| 4 | Competitors lack this capability but can replicate in the medium term |
| 3 | Competitors have partial capability but poor experience |
| 2 | Competitors have good capability but not dominant |
| 1 | Competitors already leading |

### Step 2: Problem Statement [Core]

Generate a structured Problem Statement based on scoring results and user research data.

**Structured template**:

> [Target user group] in [scenario], needs to [accomplish what task], but currently faces [core pain point], because [shortcomings of existing solutions], if this problem is solved, they will [expected benefit].

**Data support requirements**: Each key element must be accompanied by data evidence.

#### Template Element Breakdown

| Element | Description | Data requirements |
|------|------|----------|
| Target user group | Specific user group description, cannot be a generic "users" | Must link to persona data |
| Scenario | Specific usage scenario the user is in | Must have behavior data or interview data support |
| Accomplish what task | The goal the user needs to achieve | Must link to JTBD data |
| Core pain point | The main difficulty the user faces | Must have pain point mention rate data |
| Shortcomings of existing solutions | Deficiencies of current solutions | Must have competitor analysis or user feedback data |
| Expected benefit | Expected effect after the problem is solved | Must be quantifiable or verifiable |

#### Quality Checks (auto-executed, repair and retry if not passed, max 3 times)

| Check item | Pass condition | Repair strategy |
|--------|----------|----------|
| Whether a specific user group is specified | User group description is specific, not generic | Extract specific user group description from persona data to replace |
| Whether a specific scenario is specified | Scenario description is specific and observable | Extract high-frequency scenarios from behavior data to replace |
| Whether shortcomings of existing solutions are described | Clearly point out 1 or more specific shortcomings | Extract specific shortcomings from competitor analysis and user feedback |
| Whether verifiable | Expected benefit is quantifiable or verifiable through experiments | Replace vague benefits with quantifiable metrics |
| Whether solution preset is avoided | Problem description does not contain any specific solution | Remove solution descriptions, focus on the problem itself |

### Step 3: HMW Divergence [Conditional]

Based on the Problem Statement and user research data, generate HMW statements from 4 dimensions, 2-3 per dimension:

#### Dimension 1: Eliminate Barriers

**Template**: "How might we eliminate/reduce [user's XX barriers in XX scenario]?"

- Focus on specific obstacles users currently face
- Barriers must be supported by user research data
- Avoid jumping directly to solutions

#### Dimension 2: Enhance Experience

**Template**: "How might we make [XX experience] more [simple/fast/delightful]?"

- Focus on existing but poorly experienced stages
- Experience improvement directions must be corroborated by behavior data
- Quantify improvement goals

#### Dimension 3: Create New Value

**Template**: "How might we help [XX users] achieve [their unexpressed XX expectation]?"

- Uncover needs that users have not explicitly expressed but behavior data suggests
- Based on implicit patterns in user research

#### Dimension 4: Redefine

**Template**: "What if we rethink [XX process]?"

- Challenge basic assumptions of existing processes
- Draw inspiration from cross-industry innovation models
- Encourage breakthrough thinking

### Step 4: Opportunity Brief [Conditional]

Assemble all preceding outputs into a complete opportunity brief.

#### Structure Definition

| Field | Source | Description |
|------|------|------|
| title | Auto-generated | Format: [Target user group] - [Core pain point summary] |
| problem_statement | Step 2 output | Directly quote Problem Statement text |
| evidence_summary | Multi-source aggregation | User research evidence, market analysis evidence, competitive landscape evidence |
| opportunity_score | Step 1 output | Weighted total score and per-dimension scores |
| hmw_statements | Step 3 output | HMW statement list, annotated with innovation space score |
| key_assumptions | Inferred | Key assumption list, including type/testability/risk level |
| recommended_next_step | Based on scoring and assumption analysis | Recommended next action |
| human_decisions_needed | Inferred | List of items requiring human decision |

## Output

Output path: `docs/discovery/opportunity.md`

Output files: opportunity-definition.json + opportunity-definition.md

> See [Reference/output-schema.md](./Reference/output-schema.md) for output JSON schema and all module field validation rules (scoring/problem_statement/hmw/brief).
> See [Reference/examples.md](./Reference/examples.md) → "Output JSON Example" for the complete output JSON example.

## Decision Rules

1. **Strategic fit must be judged by humans**: AI only provides analysis recommendations, does not auto-score; weighted total score is calculated after human judgment
2. **Problem Statement quality check failure triggers auto-repair retry**: Targeted repair based on failed check items, max 3 retries; if still not passed after 3 retries, escalate to human
3. **HMW with innovation space ≥ 4 requires key human review**: These statements may bring breakthrough innovation, but may also deviate from the core problem
4. **HMW with innovation space < 3 can be quickly passed**: Leans toward incremental improvement, lower risk
5. **At least 1 HMW retained per dimension**: Ensure comprehensiveness of opportunity exploration
6. **Key assumptions with risk level "high" must be annotated**: Assumptions with `risk_if_wrong` as "high" must have a corresponding decision item listed in `human_decisions_needed`
7. **Recommended next step must be data-driven**: Must be based on scoring results and assumption risk analysis, cannot be baseless recommendations

## Quality Checks

| Check item | Pass condition |
|--------|----------|
| Opportunity scoring complete (P0) | All 5 dimensions have a score value or marked as needs_human, strategic fit marked as needs_human |
| Scoring basis complete (P0) | Each dimension's evidence field is non-empty |
| Weight consistency (P0) | Sum of 5 dimension weights = 1.00 |
| Problem Statement 5 quality checks all passed (P0) | `quality_check.all_passed === true` |
| Data support complete (P0) | pain_point_frequency, behavioral_evidence, confidence are all non-empty |
| HMW 4 dimensions all covered (P1) | All 4 dimensions in `dimension_coverage` are ≥ 1 |
| Each HMW has data support (P1) | Each HMW's `data_source` is non-empty |
| HMW statements avoid solution presets (P1) | Statements do not contain specific product feature or technical solution descriptions |
| HMW total count meets requirement (P1) | `total_count` is in the 8-12 range |
| All evidence summaries filled (P1) | All 3 sub-fields of `evidence_summary` have content |
| Key assumptions list testability (P2) | Each `key_assumptions`'s `testability` is non-empty |
| Human decision items are clear (P2) | `human_decisions_needed` is non-empty and each item contains item/context/urgency |
| High-risk assumptions have corresponding decision items (P2) | Assumptions with `risk_if_wrong` as "high" have a corresponding item in `human_decisions_needed` |

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently.

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Degradation Strategy" for the full degradation table (missing input scenarios, impact, and data acquisition instructions).

## Data Acquisition Instructions

This Skill requires user research, market analysis, and competitor analysis data. Please provide via one of the following methods:
  1. Directly describe the opportunity, target users, and core pain points
  2. Upload voice-analysis.json / tam-som.json / competitor-analysis.json and other files
  3. Provide data file paths
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Upstream Change Impact Table" and "Downstream Notification Mechanism Table" for change impact and notification details.
