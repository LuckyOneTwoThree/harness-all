---
name: insight-analysis
description: Used when requirement insight analysis, requirement layering, root cause analysis, or requirement priority assessment is needed. Integrates JTBD, requirement layering, 5 Whys root cause, KANO classification, and priority scoring.
---
# Insight Analysis — Requirement Insight Analysis

## When to use
- Help me analyze user requirements
- Too many requirements, help me prioritize
- Analyze requirements using the KANO model
- Uncover users' deeper needs
- What task are users really trying to accomplish
- Why do users always complain about this feature
- Which features are must-haves
- Too many requirements, which one to do first
- Keywords: requirement insight, JTBD, 5 Whys, KANO, priority scoring, requirement analysis

## Outputs
- docs/discovery/insight.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Requirements ≠ problems** — Users describe solutions, not the problem itself; decompose first (requirement-layers), then analyze (jtbd/5whys) to avoid staying at surface-level requirements
2. **Jobs, not solutions** — What users express as "want feature XX" is a solution, not a job; JTBD digs into "what the user wants to accomplish with this feature"
3. **Phenomenon-driven, not assumption-driven** — 5 Whys starts from observable problem phenomena; each follow-up question must anchor to the previous answer; no jumping inferences
4. **Classification based on user reactions, not product attributes** — KANO classification is based on "user reactions to the presence/absence of a feature", not "the technical complexity of the feature itself"
5. **Multi-dimensional independent contributions** — Pain intensity, frequency, and solvability each independently contribute to the score; use weighted sum rather than multiplication to avoid extreme values
6. **KANO is a bonus, not a multiplier** — KANO classification adjusts the base score as a bonus coefficient; it does not make other dimensions' contributions completely disappear
7. **Unconfirmed dimensions explicitly annotated** — Solvability default value is 3 (medium); requirements without technical confirmation have their overall score confidence forced to low

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| User feedback data | JSON | Yes | docs/discovery/user-research.md (append "User Voice Analysis" section) | User voice and sentiment analysis data |
| Behavior analysis data | JSON | Yes | docs/discovery/user-research.md (append "User Behavior Analysis" section) | Behavior patterns and pain point data |
| Raw requirement list | JSON | ○ | User-provided | Raw requirements from user voice, business stakeholders, data anomalies, etc. |

## Execution Steps

### Step 1: Parallel Insights (JTBD + Requirement Layers) [Core]

Execute JTBD analysis and requirement three-layer model decomposition in parallel.

#### 1a: JTBD Analysis

Extract functional, emotional, and social three-layer Jobs from user feedback and behavior data.

**Step 1a-1: Functional Job Extraction**

- Scan user verbatims, match task intent patterns
- Extract high-frequency behavior goals from behavior data, infer tasks users are trying to accomplish
- Intent pattern library:

| Pattern category | Matching patterns | Inference direction |
|----------|----------|----------|
| Direct expression | "I want...", "Can you...", "Need...", "Help me...", "Hope..." | Directly extract as Functional Job |
| Pain point reverse inference | "Too slow", "Too cumbersome", "Inconvenient", "Hard to use" | Reverse infer user wants to accomplish something efficiently/conveniently |
| Behavior goal | High-frequency operation paths, repeated behavior patterns | Infer behavior goals the user is trying to achieve |
| Competitor comparison | "Product XX can...", "Why can't you..." | Extract functional capabilities users expect |
| Scenario description | "Every time I do XX...", "In XX scenario..." | Extract scenario-based functional requirements |

- Annotate frequency and sentiment intensity for each Functional Job

**Step 1a-2: Emotional Job Inference**

- Infer emotional needs from negative feedback
- Emotional mapping rule library: See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Step 1a-2: Emotional Mapping Rule Library"
- Confidence adjustment: single evidence ×0.7, 2-3 pieces ×0.85, 4+ pieces ×1.0

**Step 1a-3: Social Job Inference**

- Extract expressions involving others' evaluation, social relationships, group belonging
- Social mapping rule library: See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Step 1a-3: Social Mapping Rule Library"
- Confidence adjustment rules same as Emotional Job

#### 1b: Requirement Three-Layer Model Decomposition

Decompose raw requirements into surface, behavioral, and essential three layers.

**Step 1b-1: Surface Requirement Extraction**

- Read raw requirements one by one, preserve original wording
- Confidence = 1.0 (direct quote)

**Step 1b-2: Behavioral Requirement Inference**

> See [Reference/examples.md](./Reference/examples.md) → "Step 1b-2: Behavioral Requirement Inference Patterns" for the full inference pattern library. Confidence range: 0.7-0.9

**Step 1b-3: Essential Requirement Inference**

> See [Reference/examples.md](./Reference/examples.md) → "Step 1b-3: Essential Requirement Inference Patterns" for the full inference pattern library. Confidence range: 0.4-0.7
> Validation flag: Essential requirement confidence <0.5 → `validation_needed: true`, behavioral requirement confidence <0.7 → `validation_needed: true`

### Step 2: Root Cause Deep Dive (5 Whys) [Conditional]

Deep dive into root causes for key pain points or problem phenomena.

**Round 1**: Based on the problem phenomenon, generate a Top 3 list of cause hypotheses, sorted by likelihood, each cause annotated with data support and confidence

**Round 2-N**: Ask why about the Top 1 cause from the previous round, generate a Top 3 list of sub-causes

**Multi-path branching**: When the confidence gap between Top 1 and Top 2 from the previous round is < 0.15, track both causal chains simultaneously

**Termination conditions** (stop when any is met):

| Condition | Description |
|---|---|
| Reached 5th level | 5 rounds of questioning completed; deeper inferences lack sufficient credibility |
| Cause reached indivisible root cause | Such as "system architecture limitation", "organizational process issue" and other causes that cannot be further refined |
| 2 consecutive levels with confidence < 0.3 | Inference chain lacks credibility; human intervention needed |
| Actionable improvement point found | Root cause is clear and can be converted into concrete action |

### Step 3: Requirement Classification (KANO) [Conditional]

Classify functional requirements using the KANO model.

**Step 3-1: Feature-Feedback Association**

- Matching rules: Exact feature name match, feature description keyword match (match degree > 0.7), feature alias match in user feedback
- Calculate metrics: Positive mention rate, negative mention rate, mention frequency, average sentiment intensity, usage depth correlation

**Step 3-2: Classification Rules**

| Category | Condition | Meaning |
|---|---|---|
| Must-be | Negative mention rate > 60% and mention frequency > 5% | Strong dissatisfaction when absent; taken for granted when present |
| One-dimensional | Negative mention rate 30%-60% and positively correlated with usage depth (correlation > 0.3) | The better it is, the more satisfied users are |
| Attractive | Positive mention rate > 60% and mention frequency < 5% | Exceeds expectations and brings delight; absence causes no dissatisfaction |
| Indifferent | Mention frequency < 1% and average sentiment intensity < 2 | Users don't care about presence/absence |

**Industry threshold adaptation rules**: See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Step 3-2: Industry Threshold Adaptation Rules"

**Step 3-3: Boundary Case Handling**

- Classification confidence < 0.7: Mark "pending human judgment"
- Different classifications across groups: Annotate classification results by user group
- Reverse: Positive mention rate < 10% and negative mention rate > 70%, mark as "Reverse"
- No feedback data: Mark "insufficient data"

### Step 4: Priority Scoring [Conditional]

Perform weighted priority scoring and ranking on the requirement list.

**Scoring function**:

- Base score = 0.35 × pain intensity (1-5) + 0.30 × frequency weight (1-5) + 0.35 × solvability (1-5)
- KANO bonus = base score × (KANO coefficient - 1)
- Priority score = base score + KANO bonus

**KANO coefficient mapping**:

| KANO category | Coefficient | Bonus effect |
|---|---|---|
| Must-be | 1.5 | Base score +50% |
| One-dimensional | 1.0 | No bonus |
| Attractive | 0.8 | Base score -20% |
| Indifferent | 0.2 | Base score -80% |
| Reverse | 0.0 | Base score zeroed |

**Per-dimension scoring rules**:

Pain intensity (1-5 points):

| Score | Condition |
|---|---|
| 5 | Sentiment intensity ≥4 and 5 Whys root cause confirmed |
| 4 | Sentiment intensity ≥3 or 5 Whys root cause confirmed |
| 3 | Sentiment intensity = 2-3 with negative feedback |
| 2 | Sentiment intensity = 1-2 with little feedback |
| 1 | No negative feedback or sentiment intensity <1 |

Frequency weight (1-5 points):

| Score | Condition |
|---|---|
| 5 | Affected user ratio > 30% or mention frequency > 10% |
| 4 | Affected user ratio 20-30% or mention frequency 5-10% |
| 3 | Affected user ratio 10-20% or mention frequency 2-5% |
| 2 | Affected user ratio 5-10% or mention frequency 1-2% |
| 1 | Affected user ratio < 5% or mention frequency < 1% |

Solvability (1-5 points):

| Score | Condition |
|---|---|
| 5 | Technical solution mature, deliverable in 1 iteration |
| 4 | Technical solution feasible, deliverable in 2-3 iterations |
| 3 | Technical solution needs research, 3-5 iterations |
| 2 | Technical solution challenging, requires cross-team collaboration |
| 1 | Technical solution uncertain or depends on external conditions |

> **Note**: Solvability requires technical team input; default value is 3 (medium), marked as "pending tech confirmation"; this requirement's overall score confidence is downgraded to low

## Output

Output path: `docs/discovery/insight.md`

Output files: insight-analysis.json + insight-analysis.md

> See [Reference/schema.md](./Reference/schema.md) for output JSON schema and all module field validation rules (jtbd/requirement_layers/5whys/kano/priority_scoring).
> See [Reference/examples.md](./Reference/examples.md) → "Output JSON Example" for the complete output JSON example.

## Decision Rules

1. **Emotional/Social Job low-confidence escalation**: Confidence < 0.5 marks need for human validation, listed in needs_human_validation
2. **Functional Job missing**: When no Functional Job is extracted, terminate analysis and return error prompt to supplement data
3. **5 Whys consecutive low-confidence termination**: 2 consecutive levels with confidence < 0.3 terminates questioning, mark needs_human_validation=true
4. **5 Whys multi-path branching**: When the confidence gap between Top 1 and Top 2 causes is < 0.15, branch into two causal chains for parallel analysis
5. **KANO low-confidence escalation**: Classification confidence < 0.7 marks needs_human_judgment=true, escalate to human judgment
6. **KANO Reverse marking**: Positive mention rate < 10% and negative mention rate > 70% marks as "reverse" type
7. **Priority scoring weights require human confirmation**: On first execution or after weight adjustment, pause scoring output and wait for human confirmation
8. **Solvability requires tech input**: When not confirmed by tech team, use default value 3, mark confirmed=false, score_confidence forced to low
9. **Reverse feature**: When KANO classification is Reverse, total score is zeroed, annotated "not recommended for implementation"
10. **Essential requirement low-confidence forced validation**: Confidence < 0.5 must mark validation_needed=true, escalate to human validation

## Quality Checks

| Check item | Pass condition |
|--------|----------|
| JTBD three-layer Jobs all extracted (P0) | functional/emotional/social Jobs all present |
| Each Job has data support (P0) | evidence field non-empty |
| Low-confidence Jobs marked for validation (P1) | Jobs with confidence <0.5 are in needs_human_validation |
| Requirement three layers all decomposed (P0) | surface/behavioral/essential all have content |
| Inference basis non-empty (P0) | inference_basis field non-empty |
| Essential requirement marked with validation status (P1) | validation_needed field complete |
| Causal chain complete (P1) | Logically coherent from phenomenon to root cause |
| Root cause has data support (P1) | At least 1 evidence |
| Actionable recommendation provided (P1) | actionable_fix non-empty, contains effort/impact/suggested_metrics |
| All functional requirements classified (P1) | kano_classification complete |
| Boundary cases marked (P2) | Those with confidence <0.7 are in boundary_cases |
| Classification summary complete (P2) | Sum of each type count in summary equals kano_classification array length |
| All requirements scored (P1) | priority_list complete |
| Scoring results sorted by priority descending (P1) | rank field correct |
| Scoring confidence level annotated (P2) | score_confidence field complete |
| base_score and kano_bonus calculated separately (P2) | Auditable |

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently.

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Degradation Strategy" for the full degradation table (missing input scenarios, impact, and data acquisition instructions).

## Data Acquisition Instructions

This Skill requires user feedback and behavior analysis data. Please provide via one of the following methods:
  1. Directly paste user feedback text and requirement list
  2. Upload voice-analysis.json / behavior-analysis.json files
  3. Provide data file paths
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Upstream Change Impact Table" and "Downstream Notification Mechanism Table" for change impact and notification details.
