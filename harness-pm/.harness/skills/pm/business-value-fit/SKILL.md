---
name: business-value-fit
description: Used when assessing the fit between value propositions and user needs. Auto-assesses value proposition fit, executed by AI, evaluating how well the value propositions in the Business Model Canvas match user pains and gains.
---
# Value Proposition Fit Auto-Assessment

## When to use
- Is our value proposition right
- Do users really need this feature
- Keywords: value proposition fit, pain coverage, gain validation, fit score, do users need this, is the value right

## Outputs
- docs/strategy/business-strategy.md
- memory/progress.md

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

> See [Reference/input-and-step-examples.md](./Reference/input-and-step-examples.md) for the BMC value_propositions JSON and user research data JSON (persona_summary, problem_statement with pains/gains, opportunity_definition).

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

> See [Reference/input-and-step-examples.md](./Reference/input-and-step-examples.md) § "Step 1" for the pain_alignment JSON (covered_pains, uncovered_pains, pain_coverage_summary).

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

> See [Reference/input-and-step-examples.md](./Reference/input-and-step-examples.md) § "Step 2" for the gain_validation JSON (covered_gains, uncovered_gains, gain_summary).

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

> See [Reference/input-and-step-examples.md](./Reference/input-and-step-examples.md) § "Step 3" for the overall_fit_score JSON (score_breakdown, coverage_rate).

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Value-market fit assessment | Core conclusions + minimum viable deliverable |
| standard | Complete deliverable (current default) | Complete deliverable, including all Step outputs |
| deep | Complete assessment + value-market fit matrix + gap analysis + optimization roadmap | Complete deliverable + extended analysis + in-depth reasoning |

## Output

**Storage Path**: `docs/strategy/business-strategy.md ("Value Fit" section)`

**Output File**: evaluation_report.json

### Output Validation Rules and Complete Assessment Report

> See [Reference/output-validation-and-example.md](./Reference/output-validation-and-example.md) for the full field validation rules table (evaluation_metadata, pain_alignment, gain_validation, overall_fit_score, improvement_suggestions, warnings) and a complete evaluation_report JSON example.

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
