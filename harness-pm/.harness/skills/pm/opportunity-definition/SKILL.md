---
name: opportunity-definition
description: Used when opportunity identification, opportunity assessment, or product opportunity definition is needed. Integrates opportunity scoring, problem statement, HMW divergence, and opportunity brief. Keywords: opportunity identification, opportunity assessment, HMW, Problem Statement, opportunity brief, product opportunity.
metadata:
  module: "Product Discovery"
  sub-module: "Opportunity Identification"
  type: "pipeline"
  version: "3.0"
  domain_tags: ["General"]
  triggers:
    - "Help me evaluate this product opportunity"
    - "Identify what product opportunities exist"
    - "Define the problem we need to solve"
    - "Generate an opportunity brief"
    - "Is this opportunity worth pursuing"
    - "Help me think about the problem from a different angle"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Execute opportunity scoring and Problem Statement generation, output opportunity priority list and problem statement"
  deep_description: "Additionally includes HMW four-dimension divergence, full opportunity brief assembly, key assumption risk analysis, human decision items list"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/discovery/user-research.md
  - docs/discovery/market-analysis.md
  - docs/discovery/insight.md
writes:
  - docs/discovery/opportunity.md
  - memory/progress.md
  - memory/knowledge-base.md
---

# Opportunity Definition — Opportunity Identification & Definition

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

**Template**: "How might we eliminate/reduce [user's XX barrier in XX scenario]?"

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

### Output Schema

```json
{
  "type": "object",
  "required": ["scoring", "problem_statement", "hmw", "brief", "metadata"],
  "properties": {
    "scoring": {
      "type": "object",
      "required": ["opportunities", "metadata"],
      "properties": {
        "opportunities": {"type": "array", "description": "Opportunity scoring list, see output validation rules → scoring validation"},
        "metadata": {"type": "object", "description": "Scoring metadata, including awaiting_human_input"}
      }
    },
    "problem_statement": {
      "type": "object",
      "required": ["problem_statement", "data_support", "template_elements", "quality_check"],
      "properties": {
        "problem_statement": {"type": "string", "description": "Complete Problem Statement text"},
        "data_support": {"type": "object", "description": "Data support, see output validation rules → problem_statement validation"},
        "template_elements": {"type": "object", "description": "Template 6 elements"},
        "quality_check": {"type": "object", "description": "5 quality check results"}
      }
    },
    "hmw": {
      "type": "object",
      "required": ["hmw_statements", "dimension_coverage"],
      "properties": {
        "hmw_statements": {"type": "array", "description": "HMW statement list, see output validation rules → hmw validation"},
        "dimension_coverage": {"type": "object", "description": "4-dimension coverage statistics"}
      }
    },
    "brief": {
      "type": "object",
      "required": ["title", "problem_statement", "evidence_summary", "opportunity_score", "hmw_statements", "key_assumptions", "recommended_next_step", "human_decisions_needed"],
      "properties": {
        "title": {"type": "string"},
        "evidence_summary": {"type": "object", "description": "3 types of evidence summary, see output validation rules → brief validation"},
        "key_assumptions": {"type": "array", "description": "Key assumption list, see output validation rules → brief validation"},
        "human_decisions_needed": {"type": "array", "description": "Human decision items list"}
      }
    },
    "metadata": {"type": "object", "description": "Metadata, including version, timestamp, and source files"}
  }
}
```

### Output Validation Rules

#### scoring validation

| Field path | Type | Required | Description |
|----------|------|------|------|
| `scoring.opportunities` | array | Yes | Opportunity scoring list, cannot be an empty array |
| `scoring.opportunities[].name` | string | Yes | Opportunity name, cannot be an empty string |
| `scoring.opportunities[].scores.{dimension}.score` | number\|null | Yes | Dimension score 1-5, must be null when pending human judgment |
| `scoring.opportunities[].scores.{dimension}.weight` | number | Yes | Dimension weight, the sum of 5 dimension weights must equal 1.00 |
| `scoring.opportunities[].scores.{dimension}.evidence` | string | Yes | Scoring basis, cannot be an empty string |
| `scoring.opportunities[].scores.{dimension}.needs_human` | boolean | Yes | Whether human judgment is needed, strategic_fit dimension must be true |
| `scoring.opportunities[].weighted_total` | number\|null | Yes | Weighted total score, must be null when any dimension score is null |
| `scoring.metadata.awaiting_human_input` | boolean | Yes | Whether there is pending human input, must be true when strategic_fit is not scored |

#### problem_statement validation

| Field path | Type | Required | Description |
|----------|------|------|------|
| `problem_statement.problem_statement` | string | Yes | Complete Problem Statement text, cannot be empty and cannot contain specific solutions |
| `problem_statement.data_support.pain_point_frequency` | string | Yes | Pain point mention rate, cannot be empty |
| `problem_statement.data_support.behavioral_evidence` | string | Yes | Behavior data corroboration, cannot be empty |
| `problem_statement.data_support.confidence` | number | Yes | Confidence 0-1, escalate to human review when below 0.5 |
| `problem_statement.template_elements.target_user` | string | Yes | Target user group, cannot use generic terms |
| `problem_statement.template_elements.scenario` | string | Yes | Specific scenario, cannot be a vague description |
| `problem_statement.template_elements.task` | string | Yes | Task the user needs to complete, cannot be empty |
| `problem_statement.template_elements.core_pain` | string | Yes | Core pain point, cannot be empty |
| `problem_statement.template_elements.current_gap` | string | Yes | Shortcomings of existing solutions, must point out 1 or more specific shortcomings |
| `problem_statement.template_elements.expected_benefit` | string | Yes | Expected benefit, must be quantifiable or verifiable |
| `problem_statement.quality_check.all_passed` | boolean | Yes | Whether all 5 quality checks passed |
| `problem_statement.quality_check.retry_count` | number | Yes | Retry count, max value is 3 |

#### hmw validation

| Field path | Type | Required | Description |
|----------|------|------|------|
| `hmw.hmw_statements` | array | Yes | HMW statement list, count must be in the 8-12 range |
| `hmw.hmw_statements[].id` | string | Yes | HMW unique identifier, format hmw-NNN |
| `hmw.hmw_statements[].statement` | string | Yes | HMW statement text, cannot be empty and cannot contain specific solutions |
| `hmw.hmw_statements[].dimension` | string | Yes | Associated dimension, must be one of eliminate_barriers/enhance_experience/create_value/redefine |
| `hmw.hmw_statements[].problem_ref` | string | Yes | Linked Problem Statement field reference, cannot be empty |
| `hmw.hmw_statements[].data_source` | string | Yes | Data source reference, cannot be empty |
| `hmw.hmw_statements[].innovation_space` | number | Yes | Innovation space score 1-5, ≥4 requires key human review |
| `hmw.hmw_statements[].confidence` | number | Yes | Confidence 0-1 |
| `hmw.dimension_coverage` | object | Yes | All 4 dimensions must appear with value ≥1 |
| `hmw.dimension_coverage.eliminate_barriers` | number | Yes | Eliminate barriers dimension HMW count, ≥2 |
| `hmw.dimension_coverage.enhance_experience` | number | Yes | Enhance experience dimension HMW count, ≥2 |
| `hmw.dimension_coverage.create_value` | number | Yes | Create new value dimension HMW count, ≥2 |
| `hmw.dimension_coverage.redefine` | number | Yes | Redefine dimension HMW count, ≥2 |

#### brief validation

| Field path | Type | Required | Description |
|----------|------|------|------|
| `brief.title` | string | Yes | Opportunity brief title, format [Target user group]-[Core pain point summary] |
| `brief.problem_statement` | string | Yes | Structured problem statement, cannot be empty |
| `brief.evidence_summary.user_research` | object | Yes | User research evidence, must include pain point frequency and behavior corroboration |
| `brief.evidence_summary.market_analysis` | object | Yes | Market analysis evidence, must include SOM estimate |
| `brief.evidence_summary.competitive_landscape` | object | Yes | Competitive landscape evidence, must include market gap analysis |
| `brief.opportunity_score.weighted_total` | number | Yes | Weighted total score, cannot be null (requires human to have completed strategic fit scoring) |
| `brief.hmw_statements` | array | Yes | HMW statement list, cannot be an empty array |
| `brief.key_assumptions` | array | Yes | Key assumption list, cannot be an empty array |
| `brief.key_assumptions[].assumption` | string | Yes | Assumption description, cannot be empty |
| `brief.key_assumptions[].type` | string | Yes | Assumption type, must be one of desirability/viability/feasibility/usability |
| `brief.key_assumptions[].testability` | string | Yes | Testability description, cannot be empty |
| `brief.key_assumptions[].risk_if_wrong` | string | Yes | Risk level, must be one of high/medium/low |
| `brief.recommended_next_step` | string | Yes | Recommended next step, must be based on scoring and assumption risk analysis |
| `brief.human_decisions_needed` | array | Yes | Human decision items list, high-risk assumptions must have a corresponding decision item |
| `brief.human_decisions_needed[].item` | string | Yes | Decision item, cannot be empty |
| `brief.human_decisions_needed[].context` | string | Yes | Decision context, cannot be empty |
| `brief.human_decisions_needed[].urgency` | string | Yes | Urgency, must be one of high/medium/low |

### Output JSON Example

```json
{
  "scoring": {
    "opportunities": [
      {
        "name": "Multi-channel data reconciliation automation",
        "scores": {
          "problem_validity": { "score": 4, "weight": 0.30, "evidence": "Pain point mention rate 12%, behavior data shows users repeatedly trying to solve", "needs_human": false },
          "market_size": { "score": 3, "weight": 0.25, "evidence": "SOM estimate about 30 million", "needs_human": false },
          "feasibility": { "score": 4, "weight": 0.20, "evidence": "Existing tech stack needs minor extension", "needs_human": false },
          "strategic_fit": { "score": null, "weight": 0.15, "evidence": "AI analysis: This opportunity is highly relevant to core strategic direction, recommend score 4-5", "needs_human": true },
          "competitive_moat": { "score": 3, "weight": 0.10, "evidence": "Competitors have partial capability but poor experience", "needs_human": false }
        },
        "weighted_total": null,
        "provisional_rank": null
      }
    ],
    "metadata": {
      "scoring_version": "1.0",
      "awaiting_human_input": true,
      "pending_dimensions": ["strategic_fit"]
    }
  },
  "problem_statement": {
    "problem_statement": "SaaS product operations staff with over 1000 MAU, during the month-end settlement peak, need to quickly verify multi-channel data consistency, but currently face the core pain point of manual comparison being time-consuming and error-prone, because existing tools only support single-channel data export and lack automatic verification capability. If this problem is solved, they will reduce data reconciliation time from an average of 4 hours to under 30 minutes.",
    "data_support": {
      "pain_point_frequency": "12.3%",
      "behavioral_evidence": "78% of users repeatedly export data and manually compare at month-end",
      "confidence": 0.88
    },
    "template_elements": {
      "target_user": "SaaS product operations staff with over 1000 MAU",
      "scenario": "Month-end settlement peak",
      "task": "Quickly verify multi-channel data consistency",
      "core_pain": "Manual comparison is time-consuming and error-prone",
      "current_gap": "Existing tools only support single-channel data export and lack automatic verification capability",
      "expected_benefit": "Data reconciliation time reduced from an average of 4 hours to under 30 minutes"
    },
    "quality_check": {
      "specific_user_group": { "passed": true, "detail": "Specified 'SaaS product operations staff with over 1000 MAU'" },
      "specific_scenario": { "passed": true, "detail": "Specified 'Month-end settlement peak'" },
      "current_solution_gap": { "passed": true, "detail": "Described 'only support single-channel data export and lack automatic verification capability'" },
      "verifiable": { "passed": true, "detail": "Expected benefit is quantifiable: 4 hours → 30 minutes" },
      "no_solution_preset": { "passed": true, "detail": "Problem description does not contain specific solutions" },
      "all_passed": true,
      "retry_count": 0
    }
  },
  "hmw": {
    "hmw_statements": [
      {
        "id": "hmw-001",
        "statement": "How might we eliminate the cognitive burden barrier for new users in the first-time configuration scenario?",
        "dimension": "eliminate_barriers",
        "problem_ref": "problem_statement.core_pain",
        "data_source": "voice-analysis.json::pain_point_frequency=12%",
        "innovation_space": 4,
        "confidence": 0.85
      },
      {
        "id": "hmw-002",
        "statement": "How might we make the report generation experience faster?",
        "dimension": "enhance_experience",
        "problem_ref": "problem_statement.current_gap",
        "data_source": "behavior-analysis.json::avg_report_time=10min",
        "innovation_space": 3,
        "confidence": 0.90
      }
    ],
    "dimension_coverage": {
      "eliminate_barriers": 3,
      "enhance_experience": 3,
      "create_value": 3,
      "redefine": 2
    },
    "metadata": {
      "total_count": 11,
      "high_innovation_count": 4
    }
  },
  "brief": {
    "title": "SaaS Operations Staff - Multi-channel data reconciliation time-consuming and error-prone",
    "problem_statement": "SaaS product operations staff with over 1000 MAU, during the month-end settlement peak, need to quickly verify multi-channel data consistency, but currently face the core pain point of manual comparison being time-consuming and error-prone, because existing tools only support single-channel data export and lack automatic verification capability. If this problem is solved, they will reduce data reconciliation time from an average of 4 hours to under 30 minutes.",
    "evidence_summary": {
      "user_research": {
        "pain_point_frequency": "12.3% of users mentioned this pain point",
        "behavioral_evidence": "78% of target users repeatedly manually export and compare at month-end",
        "persona_summary": "Mainly affected group is operations staff of mid-sized SaaS products",
        "core_jobs": "Data reconciliation, report generation, anomaly investigation",
        "need_type": "Basic need (Kano model), strong dissatisfaction when absent"
      },
      "market_analysis": {
        "tam": "5 billion",
        "sam": "1.5 billion",
        "som": "120 million",
        "growth_rate": "Annual growth rate about 25%"
      },
      "competitive_landscape": {
        "competitor_capabilities": "Mainstream competitors only support single-channel data management",
        "market_gap": "Multi-channel data automatic reconciliation capability missing",
        "barrier_analysis": "Data integration capability constitutes a certain barrier"
      }
    },
    "opportunity_score": {
      "weighted_total": 3.85,
      "dimensions": {
        "problem_validity": { "score": 4, "weight": 0.30 },
        "market_size": { "score": 4, "weight": 0.25 },
        "feasibility": { "score": 4, "weight": 0.20 },
        "strategic_fit": { "score": 4, "weight": 0.15 },
        "competitive_moat": { "score": 3, "weight": 0.10 }
      }
    },
    "hmw_statements": [
      { "id": "hmw-001", "statement": "How might we eliminate the cognitive burden barrier for new users in the first-time configuration scenario?", "innovation_space": 4 },
      { "id": "hmw-002", "statement": "How might we make the report generation experience faster?", "innovation_space": 3 }
    ],
    "key_assumptions": [
      { "assumption": "Target users are willing to pay for the automatic reconciliation feature", "type": "viability", "testability": "Validate through willingness-to-pay research or MVP pricing test", "risk_if_wrong": "high" },
      { "assumption": "Multi-channel data interfaces can be unified and standardized", "type": "feasibility", "testability": "Validate through technical pre-research on 3-5 mainstream channel data interfaces", "risk_if_wrong": "high" }
    ],
    "recommended_next_step": "Recommend entering the solution exploration phase, prioritizing validation of high-risk assumptions (willingness to pay and data interface standardization), which can be advanced in parallel through smoke testing and technical pre-research.",
    "human_decisions_needed": [
      { "item": "Confirm strategic fit score", "context": "AI recommends score 4, need human to confirm whether it aligns with company strategic direction", "urgency": "high" },
      { "item": "Confirm validation priority for high-risk assumptions", "context": "2 high-risk assumptions need to decide validation order and resource allocation", "urgency": "high" }
    ]
  },
  "metadata": {
    "version": "3.0",
    "generated_at": "2026-05-14T21:00:00Z",
    "source_files": [
      "docs/discovery/user-research.md (append \"User Voice Analysis\" section)
      "docs/discovery/user-research.md (append \"User Behavior Analysis\" section)
      "docs/discovery/market-analysis.md (\"Market Size\" section)
      "docs/discovery/market-analysis.md (\"Competitive Analysis\" section)
    ]
  }
}
```

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

When upstream files do not exist, this Skill can still execute independently:

| Missing upstream input | Degradation plan | Output impact | Data acquisition instructions |
|---------------|---------|----------|------------|
| User research data (voice-analysis / behavior-analysis) | User describes opportunity → score and generate Problem Statement based on description | `problem_validity.score` defaults to 2, `data_support.pain_point_frequency` is a user estimate, `confidence` <0.5 | Ask user to provide user feedback text and behavior data, or upload voice-analysis.json/behavior-analysis.json files |
| Market analysis data (tam-som) | User describes opportunity → market size dimension scored based on user estimate | `market_size.score` based on user estimate, `evidence` annotated "lacks market data" | Ask user to provide market size estimate data or upload tam-som.json file |
| Competitor analysis data (competitor-analysis) | User describes opportunity → competitive moat dimension scored based on user description | `competitive_moat.score` based on user description, `evidence` annotated "lacks competitor data" | Ask user to provide competitor information or upload competitor-analysis.json file |
| Requirement insight data (persona / insight-analysis) | Generate directly based on user description | `template_elements.target_user` may use generic terms, `quality_check.specific_user_group` may not pass | Ask user to provide target user persona description or upload persona.json/insight-analysis.json file |
| Technical team assessment data missing | Skip technical feasibility dimension scoring, annotate "pending tech assessment" | `technical_feasibility.score` uses default value, feasibility judgment lacks technical basis | Ask user to provide technical team capability assessment and tech stack information |
| All upstream files missing | Prompt user to execute preceding stages first, or execute directly based on user's verbally described opportunity | Multiple dimensions use default values, `weighted_total` credibility is very low, `quality_check` multiple items may not pass, Brief decision value significantly reduced | Ask user to provide opportunity description, target users, market estimate, and competitor information |

## Data Acquisition Instructions

This Skill requires user research, market analysis, and competitor analysis data. Please provide via one of the following methods:
  1. Directly describe the opportunity, target users, and core pain points
  2. Upload voice-analysis.json / tam-som.json / competitor-analysis.json and other files
  3. Provide data file paths
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream data source | Change type | Impact dimension | Impact description | Response strategy |
|-----------|----------|----------|----------|----------|
| voice-analysis.json | Pain point mention rate update | scoring.problem_validity / problem_statement.data_support | Pain point frequency changes affect scoring and Problem Statement | Recalculate problem_validity score, update data_support and core_pain |
| behavior-analysis.json | Behavior pattern data update | scoring.problem_validity / hmw.enhance_experience | Behavior data changes affect scoring and HMW | Re-evaluate behavior corroboration, update affected HMW's data_source and confidence |
| tam-som.json | SOM estimate adjustment | scoring.market_size / brief.evidence_summary.market_analysis | SOM value changes affect scoring and Brief | Recalculate market_size score, update Brief market analysis evidence |
| competitor-analysis.json | Competitor capability change | scoring.competitive_moat / brief.evidence_summary.competitive_landscape | Competitor changes affect scoring and Brief | Recalculate competitive_moat score, update Brief competitive landscape evidence |
| persona.json | User persona adjustment | problem_statement.template_elements.target_user | User group definition changes | Update target_user, re-execute specific_user_group check |
| insight-analysis.json | Insight analysis change | problem_statement.template_elements.task | User task definition changes | Update task element, re-execute quality checks |

### Downstream Notification Mechanism Table

| Downstream consumer | Notification field | Notification timing | Notification content |
|-----------|----------|----------|----------|
| Decision makers / stakeholders | `brief.title` / `scoring.opportunities[].weighted_total` | After Brief core conclusions change | Notify opportunity brief title and scoring changes, prompt need for re-review |
| Subsequent phases (solution exploration) | `brief.recommended_next_step` / `brief.key_assumptions` | After recommended action or assumption changes | Notify next-step action adjustments and assumption changes to be validated |
