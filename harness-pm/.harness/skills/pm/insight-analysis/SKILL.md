---
name: insight-analysis
description: Used when requirement insight analysis, requirement layering, root cause analysis, or requirement priority assessment is needed. Integrates JTBD, requirement layering, 5 Whys root cause, KANO classification, and priority scoring. Keywords: requirement insight, JTBD, 5 Whys, KANO, priority scoring, requirement analysis.
---
# Insight Analysis — Requirement Insight Analysis

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
- Emotional mapping rule library:

| Negative expression pattern | Emotional need direction | Confidence baseline |
|-------------|-------------|-----------|
| "Too cumbersome" / "Too complex" / "Too many steps" | Desire for ease/effortlessness | 0.8 |
| "Worried" / "Concerned" / "Afraid of errors" | Desire for security/certainty | 0.75 |
| "Anxious" / "Rushed" / "No time" | Desire for control/efficiency | 0.75 |
| "Ignored" / "No one responds to me" / "No response to feedback" | Desire for recognition/attention | 0.7 |
| "Too slow" / "Waited too long" / "Slow response" | Desire for instant feedback/fluency | 0.8 |
| "Can't understand" / "Don't know how to use" | Desire for clarity/simplicity/understandability | 0.75 |

- Confidence adjustment: single evidence ×0.7, 2-3 pieces ×0.85, 4+ pieces ×1.0

**Step 1a-3: Social Job Inference**

- Extract expressions involving others' evaluation, social relationships, group belonging
- Social mapping rule library:

| Social expression pattern | Social need direction | Confidence baseline |
|-------------|-------------|-----------|
| "Colleagues are all using it" / "Others are using it too" | Social approval/belonging | 0.7 |
| "Boss requires it" / "Company policy" | Compliance/obedience to authority | 0.8 |
| "Industry standard" / "Competitors all have it" | Industry recognition/competitiveness | 0.7 |
| "Recommend to friends" / "Share with colleagues" | Social currency/desire to share | 0.7 |

- Confidence adjustment rules same as Emotional Job

#### 1b: Requirement Three-Layer Model Decomposition

Decompose raw requirements into surface, behavioral, and essential three layers.

**Step 1b-1: Surface Requirement Extraction**

- Read raw requirements one by one, preserve original wording
- Confidence = 1.0 (direct quote)

**Step 1b-2: Behavioral Requirement Inference**

- Inference patterns:
  - `"Hope to add XX feature"` → Scenario: Need to accomplish YY in XX scenario → Behavior: Currently substituting via ZZ method
  - `"Need to support XX"` → Scenario: Cannot accomplish YY under XX condition → Behavior: Switch to competitor or handle manually
  - `"XX is too slow/laggy"` → Scenario: Experience hindered during high-frequency operation XX → Behavior: Reduce usage frequency or seek alternatives
  - `"Can't find XX"` → Scenario: Lost due to unclear information architecture → Behavior: Repeated searching or asking others for help
  - `"XX operation is too complex"` → Scenario: Too many steps in task flow → Behavior: Skip non-essential steps or abandon use
  - `"Hope XX can be automatic"` → Scenario: Repetitive operations consume energy → Behavior: Manual execution but generates frustration
  - `"XX data is inaccurate"` → Scenario: Decision relies on data but data is unreliable → Behavior: Cross-verify or delay decision
- Confidence range: 0.7-0.9

**Step 1b-3: Essential Requirement Inference**

- Inference patterns:
  - `"Batch export"` → Reduce repetitive labor → Pursue efficiency and sense of achievement
  - `"Multi-language support"` → Serve overseas customers → Pursue business expansion and competitiveness
  - `"Real-time notifications"` → Don't want to miss information → Pursue control and security
  - `"Simplify operations"` → Reduce cognitive load → Pursue effortless experience and autonomy
  - `"Data accuracy"` → Avoid decision errors → Pursue certainty and trust
  - `"Personalized customization"` → Adapt to own workflow → Pursue autonomy and belonging
  - `"Collaboration features"` → Reduce communication costs → Pursue social connection and team identity
- Confidence range: 0.4-0.7
- Validation flag: Essential requirement confidence <0.5 → `validation_needed: true`, behavioral requirement confidence <0.7 → `validation_needed: true`

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

**Industry threshold adaptation rules**:

| Industry/Stage | Adaptation rule | Adjustment description |
|---|---|---|
| B2B SaaS | Must-be threshold lowered: negative mention rate > 50% qualifies as Must-be | B2B users have lower tolerance for missing basic features |
| B2C Consumer | Attractive threshold raised: positive mention rate > 70% qualifies as Attractive | B2C users are more likely to give positive feedback |
| Early-stage product | Overall threshold relaxed: lower judgment threshold when data volume is insufficient (confidence 0.5 is sufficient for classification) | Early data is limited |
| Mature product | Strict threshold: use standard thresholds when data is sufficient, confidence <0.7 must escalate | Mature products have sufficient data |

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

### Output Schema

```json
{
  "type": "object",
  "required": ["jtbd", "requirement_layers", "5whys", "kano", "priority_scoring", "metadata"],
  "properties": {
    "jtbd": {
      "type": "object",
      "required": ["jobs", "summary"],
      "properties": {
        "jobs": {"type": "array", "description": "Job list, see output validation rules → jtbd validation"},
        "summary": {"type": "object", "description": "Statistical summary, including total_jobs and by_type"}
      }
    },
    "requirement_layers": {
      "type": "object",
      "required": ["requirement_layers"],
      "properties": {
        "requirement_layers": {"type": "array", "description": "Requirement three-layer decomposition list, see output validation rules → requirement_layers validation"}
      }
    },
    "5whys": {
      "type": "object",
      "required": ["chains", "root_cause", "actionable_fix"],
      "properties": {
        "chains": {"type": "array", "description": "Causal chain list, see output validation rules → 5whys validation"},
        "root_cause": {"type": "string"},
        "actionable_fix": {"type": "object", "description": "Actionable improvement recommendation, including description/effort/impact/suggested_metrics"}
      }
    },
    "kano": {
      "type": "object",
      "required": ["kano_classification", "boundary_cases", "summary"],
      "properties": {
        "kano_classification": {"type": "array", "description": "KANO classification list, see output validation rules → kano validation"},
        "boundary_cases": {"type": "array"},
        "summary": {"type": "object"}
      }
    },
    "priority_scoring": {
      "type": "object",
      "required": ["priority_list", "scoring_summary", "priority_thresholds"],
      "properties": {
        "priority_list": {"type": "array", "description": "Priority list, see output validation rules → priority_scoring validation"},
        "scoring_summary": {"type": "object"},
        "priority_thresholds": {"type": "object"}
      }
    },
    "metadata": {"type": "object", "description": "Metadata, including version, timestamp, and source files"}
  }
}
```

### Output Validation Rules

> Type information is in the Output Schema above; the table below lists only required flags and constraints ("—" means no additional constraint).

#### jtbd validation

| Field path | Required | Constraint |
|----------|------|----------|
| `jtbd.jobs` | Yes | Cannot be empty |
| `jtbd.jobs[].type` | Yes | enum: functional, emotional, social |
| `jtbd.jobs[].job` | Yes | Cannot be empty |
| `jtbd.jobs[].frequency` | Yes | — |
| `jtbd.jobs[].evidence` | Yes | Cannot be empty |
| `jtbd.jobs[].confidence` | Yes | Range 0-1.0 |
| `jtbd.jobs[].pain_with_current` | No | — |
| `jtbd.jobs[].pain_level` | No | enum: high, medium, low |
| `jtbd.summary.total_jobs` | Yes | — |
| `jtbd.summary.by_type` | Yes | — |

#### requirement_layers validation

| Field path | Required | Constraint |
|----------|------|----------|
| `requirement_layers.requirement_layers` | Yes | Cannot be empty |
| `requirement_layers.requirement_layers[].id` | Yes | Unique |
| `requirement_layers.requirement_layers[].surface.content` | Yes | Preserve original wording |
| `requirement_layers.requirement_layers[].surface.confidence` | Yes | Must equal 1.0 |
| `requirement_layers.requirement_layers[].behavioral.content` | Yes | Contains scenario + behavior description |
| `requirement_layers.requirement_layers[].behavioral.confidence` | Yes | Range 0.7-0.9 |
| `requirement_layers.requirement_layers[].behavioral.inference_basis` | Yes | Cannot be empty |
| `requirement_layers.requirement_layers[].essential.content` | Yes | Describes underlying motivation |
| `requirement_layers.requirement_layers[].essential.confidence` | Yes | Range 0.4-0.7 |
| `requirement_layers.requirement_layers[].essential.inference_basis` | Yes | Cannot be empty |
| `requirement_layers.requirement_layers[].validation_needed` | Yes | Must be true when essential confidence <0.5 or behavioral confidence <0.7 |
| `requirement_layers.summary.total` | Yes | — |

#### 5whys validation

| Field path | Required | Constraint |
|----------|------|----------|
| `5whys.chains` | Yes | Length ≥1 |
| `5whys.chains[].path_id` | Yes | — |
| `5whys.chains[].round` | Yes | — |
| `5whys.chains[].question` | Yes | — |
| `5whys.chains[].answer` | Yes | — |
| `5whys.chains[].evidence` | Yes | — |
| `5whys.chains[].confidence` | Yes | Range 0-1.0 |
| `5whys.chains[].data_support` | Yes | enum: high, medium, low |
| `5whys.root_cause` | Yes | Non-empty |
| `5whys.actionable_fix.description` | Yes | — |
| `5whys.actionable_fix.effort` | Yes | enum: low, medium, high |
| `5whys.actionable_fix.impact` | Yes | enum: low, medium, high |
| `5whys.actionable_fix.suggested_metrics` | Yes | — |

#### kano validation

| Field path | Required | Constraint |
|----------|------|----------|
| `kano.kano_classification` | Yes | Cannot be empty |
| `kano.kano_classification[].feature_id` | Yes | — |
| `kano.kano_classification[].category` | Yes | Must be one of must-be/one-dimensional/attractive/indifferent/reverse/insufficient_data |
| `kano.kano_classification[].confidence` | Yes | Range 0-1 |
| `kano.kano_classification[].evidence` | Yes | Contains 5 metrics |
| `kano.kano_classification[].review_period` | Yes | — |
| `kano.boundary_cases` | Yes | Those with confidence <0.7 must be included |
| `kano.summary` | Yes | — |

#### priority_scoring validation

| Field path | Required | Constraint |
|----------|------|----------|
| `priority_scoring.priority_list` | Yes | Cannot be empty |
| `priority_scoring.priority_list[].rank` | Yes | — |
| `priority_scoring.priority_list[].requirement_id` | Yes | — |
| `priority_scoring.priority_list[].requirement_name` | Yes | — |
| `priority_scoring.priority_list[].scores.pain_intensity.score` | Yes | Range 1-5 |
| `priority_scoring.priority_list[].scores.frequency_weight.score` | Yes | Range 1-5 |
| `priority_scoring.priority_list[].scores.solvability.score` | Yes | Range 1-5 |
| `priority_scoring.priority_list[].scores.solvability.confirmed` | Yes | — |
| `priority_scoring.priority_list[].scores.kano_coefficient.coefficient` | Yes | — |
| `priority_scoring.priority_list[].scores.kano_coefficient.category` | Yes | — |
| `priority_scoring.priority_list[].base_score` | Yes | — |
| `priority_scoring.priority_list[].kano_bonus` | Yes | — |
| `priority_scoring.priority_list[].total_score` | Yes | — |
| `priority_scoring.priority_list[].score_confidence` | Yes | enum: high, medium, low |
| `priority_scoring.scoring_summary` | Yes | — |
| `priority_scoring.priority_thresholds` | Yes | — |

### Output JSON Example

```json
{
  "jtbd": {
    "analysis_metadata": {
      "source_files": ["voice-analysis.json", "behavior-analysis.json"],
      "total_voice_entries": 0,
      "total_behavior_entries": 0,
      "analysis_timestamp": "ISO8601"
    },
    "jobs": [
      {
        "type": "functional",
        "job": "Quickly complete form filling",
        "frequency": 12,
        "current_solution": "Manual field-by-field filling",
        "pain_with_current": "Repetitive labor, time-consuming and error-prone",
        "confidence": 1.0,
        "evidence": ["User interview #23", "Behavior data - form abandonment rate 35%"],
        "sentiment_intensity": 4
      }
      // ... same structure can be extended
    ],
    "summary": {
      "total_jobs": 3,
      "by_type": { "functional": 1, "emotional": 1, "social": 1 }
    }
  },
  "requirement_layers": {
    "analysis_metadata": {
      "source": "Raw requirement list",
      "total_requirements": 2,
      "analysis_timestamp": "ISO8601"
    },
    "requirement_layers": [
      {
        "id": "REQ-001",
        "source": "User feedback",
        "surface": { "content": "Hope to add batch export feature", "confidence": 1.0 },
        "behavioral": { "content": "Operations staff in monthly report scenario need to export multiple reports at once; currently can only export one by one", "confidence": 0.85, "inference_basis": "User feedback frequency 8 times + behavior data: abnormal average dwell time on report export page" },
        "essential": { "content": "Pursue work efficiency, reduce repetitive labor, gain sense of work achievement", "confidence": 0.6, "inference_basis": "Inferred from behavioral requirement + JTBD emotional Job cross-validation" },
        "validation_needed": true,
        "validation_reason": "Essential requirement confidence 0.6 < 0.7, recommend validation through user interviews"
      }
    ],
    "summary": { "total": 2, "needs_validation": 2, "high_confidence": 0 }
  },
  "5whys": {
    "analysis_metadata": {
      "source_files": ["jtbd.json"],
      "total_paths": 1,
      "analysis_timestamp": "ISO8601"
    },
    "phenomenon": {
      "description": "Users abandon in large numbers at step 3 of the registration flow",
      "source": "jtbd.json",
      "metrics": { "drop_off_rate": 0.35, "affected_users": 1200 }
    },
    "chains": [
      { "path_id": "main", "round": 1, "question": "Why do users abandon in large numbers at step 3 of the registration flow?", "answer": "Step 3 requires filling in too much non-essential information", "evidence": "Form has 12 fields, industry average is 5", "confidence": 0.85, "data_support": "high" }
      // ... same structure can be extended
    ],
    "root_cause": "Lack of a phased data collection strategy; treating the registration flow as the only data collection window",
    "actionable_fix": {
      "description": "Implement progressive data collection strategy; keep only core required fields (3-5) in the registration flow",
      "effort": "medium",
      "impact": "high",
      "suggested_metrics": ["Registration completion rate increase", "Step 3 abandonment rate decrease"]
    }
  },
  "kano": {
    "analysis_metadata": {
      "source_files": ["voice-analysis.json", "requirement-layers.json"],
      "total_features": 3,
      "analysis_timestamp": "ISO8601"
    },
    "kano_classification": [
      { "feature_id": "FEAT-001", "feature_name": "Batch export", "category": "must-be", "confidence": 0.85, "evidence": { "negative_rate": 0.75, "frequency": 0.08, "positive_rate": 0.25, "usage_depth_correlation": 0.6, "avg_sentiment_intensity": 3.5 }, "review_period": "6 months" }
      // ... same structure can be extended
    ],
    "boundary_cases": [
      { "feature_id": "FEAT-002", "reason": "Frequency near attractive/one-dimensional boundary", "suggested_action": "Supplement more user feedback data or conduct dedicated survey validation" }
    ],
    "summary": { "must_be": 1, "one_dimensional": 0, "attractive": 1, "indifferent": 1, "needs_judgment": 1 }
  },
  "priority_scoring": {
    "analysis_metadata": {
      "source_files": ["requirement-layers.json", "kano.json", "jtbd.json", "5whys.json"],
      "scoring_formula": "Base score (0.35×pain + 0.30×frequency + 0.35×solvability) + KANO bonus (base score × (coefficient - 1))",
      "weights_confirmed_by_human": false,
      "analysis_timestamp": "ISO8601"
    },
    "priority_list": [
      {
        "rank": 1,
        "requirement_id": "REQ-001",
        "requirement_name": "Batch export feature",
        "scores": {
          "pain_intensity": { "score": 4, "basis": "Sentiment intensity 4 + 5 Whys root cause confirmed" },
          "frequency_weight": { "score": 4, "basis": "Mention frequency 8%, affected user ratio about 25%" },
          "solvability": { "score": 3, "basis": "Default value, pending tech team confirmation", "confirmed": false },
          "kano_coefficient": { "coefficient": 1.5, "category": "must-be", "confidence": 0.85 }
        },
        "base_score": 3.65,
        "kano_bonus": 1.825,
        "total_score": 5.475,
        "score_confidence": "medium"
      }
    ],
    "scoring_summary": { "total_requirements": 2, "high_priority": 0, "medium_priority": 1, "low_priority": 1, "needs_tech_confirmation": 1 },
    "priority_thresholds": { "high": "total score >= 4.5", "medium": "total score 2.0-4.4", "low": "total score < 2.0" }
  },
  "metadata": {
    "version": "3.0",
    "generated_at": "2026-05-14T21:00:00Z",
    "source_files": [
      "docs/discovery/user-research.md (append \"User Voice Analysis\" section)
      // ... same structure can be extended
    ]
  }
}
```

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

When upstream files do not exist, this Skill can still execute independently:

| Missing upstream input | Degradation plan | Output impact | Data acquisition instructions |
|---------------|---------|----------|------------|
| voice-analysis.json | Extract JTBD and KANO classification based on feedback text directly pasted by user | Emotional/Social Job inference basis reduced, KANO classification confidence lowered | Ask user to provide user feedback text or upload voice-analysis.json file |
| behavior-analysis.json | Infer behavioral intent based on user feedback text | Functional Job lacks behavior data corroboration, frequency statistics imprecise | Ask user to provide behavior event logs or upload behavior-analysis.json file |
| voice-analysis.json + behavior-analysis.json | User provides feedback text → directly extract JTBD | Overall confidence reduced, frequency is an estimated value | Ask user to provide user feedback text and behavior event logs |
| Raw requirement list | User dictates requirements → directly decompose three layers | inference_basis lacks data corroboration, behavioral requirement confidence capped at 0.7 | Ask user to provide requirement list text or product requirements document |
| All upstream files missing | Prompt user to execute preceding stages first, or execute lightweight analysis based on user's verbal description | Output is lightweight version; JTBD contains only Functional Job; KANO all classifications are inferred; priority_scoring uses default values for multiple dimensions | Ask user to provide user feedback text, behavior data, and requirement list |

## Data Acquisition Instructions

This Skill requires user feedback and behavior analysis data. Please provide via one of the following methods:
  1. Directly paste user feedback text and requirement list
  2. Upload voice-analysis.json / behavior-analysis.json files
  3. Provide data file paths
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream data source | Change type | Impact dimension | Impact description | Response strategy |
|-----------|----------|----------|----------|----------|
| voice-analysis.json | New feedback entries added | jtbd.jobs / kano.kano_classification | Job frequency and evidence change, KANO classification metrics change | Annotate affected Jobs and KANO classifications, recommend human confirmation on whether re-extraction is needed |
| voice-analysis.json | Sentiment classification correction | jtbd.emotional_jobs | Emotional Job inference basis changes | Annotate affected Emotional Jobs, recommend re-evaluating confidence |
| behavior-analysis.json | Behavior pattern update | jtbd.functional_jobs / requirement_layers.behavioral | Functional Job frequency and behavior goals change | Annotate affected Functional Jobs, update frequency |
| Raw requirement list | Requirement additions/deletions | requirement_layers / kano / priority_scoring | Requirement decomposition, classification, and scoring all affected | Annotate added/deleted requirements, recalculate ranking |

### Downstream Notification Mechanism Table

| Downstream consumer | Notification field | Notification timing | Notification content |
|-----------|----------|----------|----------|
| opportunity-definition | `jtbd.jobs` / `requirement_layers` | After JTBD or requirement layer changes | Notify Job additions/deletions and requirement decomposition changes |
| prd-orchestrator | `priority_scoring.priority_list` | After priority ranking changes | Notify requirements with ranking changes, recommend re-evaluating development scheduling |
