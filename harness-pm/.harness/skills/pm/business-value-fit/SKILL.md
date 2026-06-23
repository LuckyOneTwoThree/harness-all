---
name: business-value-fit
description: Used when assessing the fit between value propositions and user needs. Auto-assesses value proposition fit, executed by AI, evaluating how well the value propositions in the Business Model Canvas match user pains and gains. Keywords: value proposition fit, pain coverage, gain validation, fit score, do users need this, is the value right.
metadata:
  module: "Product Business & Strategy"
  sub-module: "Business Model Design"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["SaaS", "General"]
  trigger_examples:
    - "Is our value proposition right"
    - "Do users really need this feature"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output value-market fit assessment"
  deep_description: "Complete assessment + value-market fit matrix + gap analysis + optimization roadmap"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/strategy/business-strategy.md
  - docs/discovery/user-research.md
writes:
  - docs/strategy/business-strategy.md
  - memory/progress.md
---

# Value Proposition Fit Auto-Assessment

## Core Principles

1. **Pain coverage first** — High-frequency, high-severity pains must be covered by value propositions; omissions trigger warnings
2. **531 scoring scale** — Fit assessment uses a 5/3/1/0 four-level scoring, with uniform standards and no ambiguity
3. **Transparent weighted calculation** — Pain weight = frequency × severity, gain weight = importance × satisfaction gap
4. **Gaps mean action** — Uncovered pains and gains must come with improvement recommendations; flagging without action is not allowed

**Execution Cycle**: Auto-triggered after Pipeline 1 (Business Model Canvas) is complete

**Core Objective**: Systematically assess the fit between value propositions and users' real pains and expected gains, identifying coverage blind spots and improvement opportunities.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| BMC Value Propositions | JSON | Yes | docs/strategy/business-strategy.md ("Business Model Canvas" section) | Value proposition list, including Pain Relievers and Gain Creators |
| User Research Data | JSON | Yes | user-research-user-modeling / user-research-voice-analysis | User personas, pains, expected gains, opportunity brief |

### Required Inputs

**Value Propositions in BMC (from Pipeline 1):**
```json
{
  "value_propositions": [
    {
      "proposition_id": "vp-1",
      "headline": "Value Proposition Headline",
      "description": "Value Proposition Detailed Description",
      "target_segment": "segment-1",
      "pain_relievers": ["Pain relieved 1", "Pain relieved 2"],
      "gain_creators": ["Gain created 1", "Gain created 2"]
    }
  ]
}
```

**Discovery-phase User Research Data:**
```json
{
  "persona_summary": {
    "demographics": "Demographic characteristics",
    "behaviors": "User behavioral characteristics",
    "goals": "User goals"
  },
  "problem_statement": {
    "pains": [
      {
        "pain_id": "pain-1",
        "description": "Pain description",
        "frequency": "Occurrence frequency",
        "severity": "Severity level",
        "urgency": "Urgency level"
      }
    ],
    "gains": [
      {
        "gain_id": "gain-1",
        "description": "Expected gain description",
        "importance": "Importance",
        "current_satisfaction": "Current satisfaction"
      }
    ]
  },
  "opportunity_definition": {
    "opportunity_description": "Enterprise training digitalization penetration rate is only 28%, AI personalized learning demand growing 45% annually",
    "evidence": ["iResearch 2024 Enterprise Training Market Report", "State Council Vocational Education Reform Implementation Plan"]
  }
}
```

## Execution Steps

### Step 1: Pain Alignment Assessment [Core]

**Task**: Systematically assess how each Pain Reliever covers user pains.

**Scoring Criteria (5/3/1 scoring):**

| Score | Meaning | Judgment Criteria |
|------|------|----------|
| 5 | Full coverage | Value proposition fully resolves the core of the pain, user can noticeably perceive it |
| 3 | Partial coverage | Value proposition addresses the pain but not the core dimension, or only to a limited extent |
| 1 | Edge coverage | Value proposition has a weak connection to the pain, only indirectly affects it |
| 0 | Not covered | Value proposition does not address this pain |

**Execution Logic**:
1. Iterate through each Pain Reliever
2. Match against each pain in the problem statement
3. Determine the match score based on scoring criteria
4. Calculate weighted average score (weight: frequency × severity)

**Output Format:**
```json
{
  "pain_alignment": {
    "covered_pains": [
      {
        "pain_id": "pain-1",
        "pain_description": "Training effectiveness is hard to quantify and track",
        "matched_by": ["vp-1"],
        "coverage_score": 5,
        "coverage_quality": "full/partial/edge/none",
        "notes": "AI learning report feature fully covers this pain"
      }
    ],
    "uncovered_pains": [
      {
        "pain_id": "pain-5",
        "pain_description": "Learner learning paths lack personalization",
        "frequency": "high",
        "severity": "high",
        "impact": "High-frequency, high-severity pain 'course content disconnected from job requirements' not covered",
        "recommendation": "Recommend adding job skill graph matching feature"
      }
    ],
    "pain_coverage_summary": {
      "total_pains": 10,
      "fully_covered": 4,
      "partially_covered": 3,
      "uncovered": 3,
      "weighted_average_score": 3.2,
      "high_frequency_coverage_rate": "80%"
    }
  }
}
```

**Acceptance Criteria**:
- All Pain Relievers matched with pains
- Each pain has a clear coverage status
- Omitted pains include improvement recommendations

### Step 2: Gain Creation Validation [Core]

**Task**: Assess how Gain Creators match users' expected gains.

**Execution Logic**:
1. Iterate through each Gain Creator
2. Match against expected gains in the problem statement
3. Assess the authenticity and feasibility of gain creation
4. Identify gains expected by users but not promised

**Output Format:**
```json
{
  "gain_validation": {
    "covered_gains": [
      {
        "gain_id": "gain-1",
        "gain_description": "Training ROI can be quantified",
        "created_by": ["vp-1"],
        "coverage_status": "covered/partial/not_covered",
        "realizability": "high/medium/low",
        "notes": "AI learning report + ROI dashboard can achieve this, technology maturity is high"
      }
    ],
    "uncovered_gains": [
      {
        "gain_id": "gain-3",
        "gain_description": "Learner autonomous learning willingness improved",
        "importance": "high",
        "gap_analysis": "Users expect a socialized learning experience but current value proposition does not address it",
        "recommendation": "Recommend including learning community features in V2.0 planning"
      }
    ],
    "gain_summary": {
      "total_gains": 8,
      "covered": 5,
      "partial": 2,
      "uncovered": 1,
      "alignment_rate": "75%"
    }
  }
}
```

**Acceptance Criteria**:
- All Gain Creators validated
- Uncovered gains identified and importance assessed
- Feasibility assessment is reasonable

### Step 3: Overall Fit Assessment [Core]

**Task**: Synthesize pain coverage and gain creation to calculate the overall fit score.

**Weighted Average Calculation**:
```
Overall Fit Score = (Pain Alignment Score × 0.6) + (Gain Validation Score × 0.4)
```

**Score Interpretation:**
| Score Range | Meaning | Action Recommendation |
|----------|------|----------|
| 4.0-5.0 | Excellent fit | Value proposition design is sound, can proceed to next stage |
| 3.0-3.9 | Good fit | Room for improvement, recommend optimizing before proceeding |
| 2.0-2.9 | Fair fit | Notable gaps exist, value proposition needs adjustment |
| 1.0-1.9 | Poor fit | Significant misalignment between value proposition and user needs |
| 0-0.9 | Severe misalignment | Value proposition needs to be redesigned |

**Output Format:**
```json
{
  "overall_fit_score": 3.4,
  "score_interpretation": "Good fit",
  "score_breakdown": {
    "pain_alignment_score": 3.5,
    "pain_weight": 0.6,
    "pain_contribution": 2.1,
    "gain_validation_score": 3.25,
    "gain_weight": 0.4,
    "gain_contribution": 1.3
  },
  "coverage_rate": {
    "pain_coverage": "80%",
    "gain_coverage": "75%",
    "high_priority_coverage": "85%"
  }
}
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Value-market fit assessment | Core conclusions + minimum viable deliverable |
| standard | Complete deliverable (current default) | Complete deliverable, including all Step outputs |
| deep | Complete assessment + value-market fit matrix + gap analysis + optimization roadmap | Complete deliverable + extended analysis + in-depth reasoning |

## Output

**Storage Path**: `docs/strategy/business-strategy.md ("Value Fit" section)`

**Output File**: evaluation_report.json

### Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| evaluation_report.evaluation_metadata.evaluated_at | string | Yes | Assessment timestamp |
| evaluation_report.evaluation_metadata.value_propositions_evaluated | number | Yes | Number of value propositions evaluated |
| evaluation_report.evaluation_metadata.pains_analyzed | number | Yes | Number of pains analyzed |
| evaluation_report.evaluation_metadata.gains_analyzed | number | Yes | Number of gains analyzed |
| evaluation_report.evaluation_metadata.confidence | string | Yes | high/medium/low |
| evaluation_report.pain_alignment.covered_pains | array | Yes | Covered pains list |
| evaluation_report.pain_alignment.covered_pains[].pain_id | string | Yes | Pain ID, cannot be empty |
| evaluation_report.pain_alignment.covered_pains[].coverage_score | number | Yes | Coverage score, 0-5 |
| evaluation_report.pain_alignment.covered_pains[].coverage_quality | string | Yes | Coverage quality, enum: full/partial/edge/none |
| evaluation_report.pain_alignment.uncovered_pains | array | Yes | Uncovered pains list, each item includes recommendation |
| evaluation_report.pain_alignment.uncovered_pains[].pain_id | string | Yes | Pain ID, cannot be empty |
| evaluation_report.pain_alignment.uncovered_pains[].frequency | string | Yes | Occurrence frequency, enum: high/medium/low |
| evaluation_report.pain_alignment.uncovered_pains[].severity | string | Yes | Severity, enum: high/medium/low |
| evaluation_report.pain_alignment.uncovered_pains[].recommendation | string | Yes | Improvement recommendation, cannot be empty |
| evaluation_report.pain_alignment.pain_coverage_summary | object | Yes | Coverage rate statistics |
| evaluation_report.pain_alignment.pain_coverage_summary.total_pains | number | Yes | Total pains |
| evaluation_report.pain_alignment.pain_coverage_summary.fully_covered | number | Yes | Fully covered count |
| evaluation_report.pain_alignment.pain_coverage_summary.uncovered | number | Yes | Uncovered count |
| evaluation_report.gain_validation.covered_gains | array | Yes | Covered gains list |
| evaluation_report.gain_validation.covered_gains[].gain_id | string | Yes | Gain ID, cannot be empty |
| evaluation_report.gain_validation.covered_gains[].coverage_status | string | Yes | Coverage status, enum: covered/partial/not_covered |
| evaluation_report.gain_validation.covered_gains[].realizability | string | Yes | Feasibility, enum: high/medium/low |
| evaluation_report.gain_validation.uncovered_gains | array | Yes | Uncovered gains list, each item includes recommendation |
| evaluation_report.gain_validation.uncovered_gains[].gain_id | string | Yes | Gain ID, cannot be empty |
| evaluation_report.gain_validation.uncovered_gains[].importance | string | Yes | Importance, enum: high/medium/low |
| evaluation_report.gain_validation.uncovered_gains[].recommendation | string | Yes | Improvement recommendation, cannot be empty |
| evaluation_report.overall_fit_score | number | Yes | Overall fit score 0-5 |
| evaluation_report.coverage_rate | object | Yes | Coverage rate metrics |
| evaluation_report.improvement_suggestions | array | Yes | Improvement suggestions list |
| evaluation_report.improvement_suggestions[].priority | string | Yes | Priority, enum: high/medium/low |
| evaluation_report.improvement_suggestions[].category | string | Yes | Suggestion category, enum: add_pain_coverage/enhance_gain/clarify_message/reposition |
| evaluation_report.improvement_suggestions[].description | string | Yes | Suggestion description, cannot be empty |
| evaluation_report.warnings | array | Yes | Warnings list |
| evaluation_report.warnings[].warning_type | string | Yes | Warning type, e.g. high_frequency_uncovered |
| evaluation_report.warnings[].description | string | Yes | Warning description, cannot be empty |
| evaluation_report.warnings[].severity | string | Yes | Severity, enum: high/medium/low |

### Complete Assessment Report

```json
{
  "evaluation_report": {
    "evaluation_metadata": {
      "evaluated_at": "2024-06-15T14:20:00Z",
      "value_propositions_evaluated": 3,
      "pains_analyzed": 10,
      "gains_analyzed": 8,
      "confidence": "high/medium/low"
    },
    "pain_alignment": {...},
    "gain_validation": {...},
    "overall_fit_score": {...},
    "coverage_rate": {...},
    "improvement_suggestions": [
      {
        "suggestion_id": "sug-1",
        "priority": "high/medium/low",
        "category": "add_pain_coverage/enhance_gain/clarify_message/reposition",
        "description": "Add AI learning path effectiveness visualization feature to cover learner progress tracking pain",
        "expected_impact": "Pain coverage rate increased by 15%, fit score increased by 0.5 points",
        "implementation_effort": "Medium, requires 2 Sprint development cycles"
      }
    ],
    "warnings": [
      {
        "warning_type": "high_frequency_uncovered",
        "description": "High-frequency pain 'training effectiveness hard to quantify' not covered by value proposition",
        "affected_pains": ["pain-3", "pain-7"],
        "severity": "high"
      }
    ]
  }
}
```

## Decision Rules

### Warning Trigger Rules

1. **High-frequency pain omission warning**:
   - Trigger condition: Pains with frequency ≥20% not covered
   - Action: Generate warning, explicitly flag affected pains
   - Severity: High

2. **High-severity pain omission warning**:
   - Trigger condition: Coverage rate of pains with severity=high < 70%
   - Action: Generate warning, recommend priority improvement

3. **Gain expectation gap warning**:
   - Trigger condition: Gains with importance=high not promised
   - Action: Generate warning, assess whether adjustment is needed

### Escalation Rules

1. **Fit score < 3.0 escalation**:
   - Trigger condition: Overall Fit Score < 3.0
   - Action: Flag as requiring human attention, does not block but recommends adjustment
   - Output escalation flag for human decision-maker reference

2. **Coverage rate < 60% escalation**:
   - Trigger condition: High-frequency pain coverage rate < 60%
   - Action: Force escalation to human approval

3. **High-risk assumption identification**:
   - Trigger condition: Fit depends on high-risk assumptions
   - Action: Flag assumption risk, recommend validation plan

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] All Pain Relievers assessed
- [ ] All Gain Creators validated

### P1 Checks (must pass for standard/deep)

- [ ] Omission list complete with no omissions
- [ ] Scoring logic consistent
- [ ] Weights set reasonably
- [ ] Warning rules triggered correctly

### P2 Checks (must pass for deep only)

- [ ] Extended analysis complete (in-depth reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| bmc.json | User provides value propositions and user pains → directly assess fit | Lacks BMC structured data, value propositions may be incomplete | Require user to provide product value proposition description or upload bmc.json file |
| User research data (voice-analysis / persona) | User provides value propositions and user pains → directly assess fit | Lacks user research data, pain frequency and severity lack empirical evidence | Require user to provide user pain descriptions or upload persona.json/voice-analysis.json files |
| bmc.json + User research data | User provides value proposition and user pain descriptions → directly assess fit | Overall confidence reduced, scoring lacks data anchoring | Require user to provide value proposition description and user pain info |
| All upstream files missing | Prompt user to execute prior stages first, or directly assess fit based on user-provided value propositions and user pains | Overall confidence significantly reduced, assessment is only hypothetical inference | Require user to provide product value proposition, target user pains, and core feature descriptions |

## Data Acquisition Instructions

This Skill requires BMC and user research data. Please provide via one of the following methods:
  1. Directly describe value propositions and user pains
  2. Upload bmc.json / persona.json / voice-analysis.json files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

---

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| bmc.json value proposition change | Pain alignment and gain creation validation need reassessment | Re-execute Step 1-3, update fit score |
| bmc.json customer segment adjustment | Correspondence between value propositions and segment groups | Re-match value propositions with target users |
| persona/voice-analysis user pain update | Pain coverage rate and omission analysis | Re-execute Step 1, update uncovered pains list |
| problem-statement problem statement change | Priority weights of pains and gains | Recalculate weighted scores, update overall fit assessment |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Fit score change | business-pricing, positioning-strategy | Output file version number + change summary |
| Pain coverage rate change | business-model-canvas | Output file version number + change summary |
| Improvement suggestions added | business-model-canvas | Output file version number + change summary |
| Warning triggered/resolved | business-pricing | Output file version number + change summary |

---

## Integration

### Integration with Pipeline 1

Pipeline 2 output will be passed to Pipeline 3 (Pricing Strategy). Key handoff content includes:
- Value Proposition Fit Score
- Coverage rate and omission analysis
- Improvement suggestions (may affect pricing options)

### Integration with Human Decision-Making

Assessment results and warnings will be presented to human decision-makers for the following decisions:
- Whether the value proposition needs adjustment
- Whether to accept the current fit and proceed to the next stage
- Priority improvement directions
