---
name: validation-assumption-map
description: Used when extracting and evaluating product hypotheses. Assumption map auto-generation tool, based on solution design and PRD, automatically extracts value hypotheses, feasibility hypotheses, usability hypotheses, growth hypotheses, and performs risk assessment and validation method recommendation. Keywords: hypothesis extraction, risk assessment, assumption map, validation method, hypothesis mapping, risk hypothesis.
metadata:
  module: "Product Ideation & Design"
  sub-module: "Solution Validation"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["Internet", "Software", "General"]
  trigger_examples:
    - "What hypotheses does the product have that are unvalidated"
    - "Help me map out hypotheses and risks"
    - "Which hypotheses might not hold"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output core hypotheses and validation priority"
  deep_description: "Full assumption map + validation experiment design + risk quantitative assessment + hypothesis evolution tracking"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/product/PRD.md
  - docs/handoff/design-to-solo.md
writes:
  - docs/product/PRD.md
  - memory/progress.md
  - memory/knowledge-base.md
---

# Assumption Map Auto-Generation

## Core Principles

1. **Behind every feature point is a hypothesis**—an unvalidated feature point is a bet; the assumption map is the bet list
2. **Risk = Impact × Uncertainty**—high impact + high uncertainty hypotheses are the biggest risk and must be validated first
3. **Validation method must match hypothesis type**—value hypotheses use landing page tests, usability hypotheses use prototype tests; they cannot be mismatched
4. **Maximum risk hypotheses must have a validation plan**—identifying risks without planning validation is like knowing there's a mine but not clearing it

### Basic Information

| Attribute | Value |
|------|-----|
| Pipeline ID | 10 |
| Name | Assumption Map Auto-Generation |
| Execution Mode | 🤖→👤 AI suggests, human approves |
| Inputs | Solution design output + PRD |

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Solution design output | JSON | Yes | User-provided or harness-design output | Feature list, user journey, interaction design description (if harness-design has produced output, read from prototype/user flow paths referenced in docs/handoff/design-to-solo.md) |
| PRD | markdown | Yes | docs/product/PRD.md | Problem statement, target users, core value proposition |
| PRD structured data | JSON | ○ | docs/product/PRD.md | Machine-consumable PRD version, contains features[], for hypothesis extraction alignment |

### Input Format
```json
{
  "solution_design": {
    "features": ["Feature 1", "Feature 2", ...],
    "user_journey": "User journey description",
    "interaction_design": "Interaction design description"
  },
  "prd": {
    "problem_statement": "Problem statement",
    "target_users": "Target users",
    "core_value": "Core value proposition"
  }
}
```

## Execution Steps

### Step 1: Hypothesis Extraction [Core]

For each feature point, extract the following four types of hypotheses:

| Hypothesis Type | Definition | Example |
|----------|------|------|
| Value hypothesis | Whether users recognize the feature's value | Users are willing to pay for feature XX |
| Feasibility hypothesis | Whether technology/resources support implementation | We can implement feature XX |
| Usability hypothesis | Whether users can use it smoothly | Users can understand how to operate XX |
| Growth hypothesis | Whether the feature can drive growth | Feature XX can bring user retention improvement |

**Rule**: Each feature point → at least 1 hypothesis

### Step 2: Hypothesis Risk Assessment [Core]

Perform risk assessment for each hypothesis:

| Dimension | Score | Description |
|------|------|------|
| Impact | 1-5 | Degree of impact on the product if the hypothesis does not hold |
| Uncertainty | 1-5 | Degree of uncertainty about the probability of the hypothesis holding |

**Risk score calculation**: `risk_score = impact × uncertainty`

| Risk Level | Score Range | Marker |
|----------|----------|------|
| High risk | 15-25 | is_max_risk = true |
| Medium risk | 8-14 | is_max_risk = false |
| Low risk | 1-7 | is_max_risk = false |

### Step 3: Validation Method Recommendation [Core]

Based on hypothesis type, recommend validation methods:

| Hypothesis Type | Recommended Validation Methods |
|----------|--------------|
| Value hypothesis | Landing page test, pre-sale MVP, user interviews, willingness-to-pay research |
| Feasibility hypothesis | Technical prototype, cost estimation, expert review |
| Usability hypothesis | Prototype testing, usability testing, task completion rate analysis |
| Growth hypothesis | A/B testing, data analysis, user behavior tracking |

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Core hypotheses and validation priority | Core conclusion + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, includes all Step outputs |
| deep | Full assumption map + validation experiment design + risk quantitative assessment + hypothesis evolution tracking | Full artifact + extended analysis + deep inference |

## Output

**Storage path**: `docs/product/PRD.md ("Assumption Map" section)`
**Output file**: assumption_map.json

```json
{
  "assumption_map": [
    {
      "id": "A001",
      "feature_id": "F001",
      "type": "value|feasibility|usability|growth",
      "assumption": "Hypothesis content description",
      "impact": 4,
      "uncertainty": 4,
      "risk_score": 16,
      "is_max_risk": false,
      "validation_method": "Recommended validation method",
      "validation_metric": "Validation metric"
    }
  ],
  "summary": {
    "total_assumptions": 12,
    "max_risk_assumptions": ["A005", "A008"],
    "assumption_coverage": "100%"
  }
}
```

### Output Field Description

| Field | Type | Description |
|------|------|------|
| id | string | Hypothesis unique identifier |
| feature_id | string | Associated feature point ID |
| type | enum | Hypothesis type |
| assumption | string | Hypothesis content |
| impact | number | Impact score (1-5) |
| uncertainty | number | Uncertainty score (1-5) |
| risk_score | number | Risk score (1-25) |
| is_max_risk | boolean | Whether it is a maximum risk hypothesis |
| validation_method | string | Recommended validation method |
| validation_metric | string | Validation metric |

**Output validation rules**: See the output validation rules section below

## Decision Rules

1. **Maximum risk hypothesis identification**
   - Must identify the hypothesis with the highest risk score
   - Maximum risk hypotheses must have a clear validation plan

2. **Hypothesis validation methods**
   - Each hypothesis must have a corresponding validation method
   - Validation methods must match the hypothesis type

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Feature point coverage (all feature points have at least 1 hypothesis)
- [ ] Hypothesis risk assessment (each hypothesis has impact and uncertainty scores)

### P1 Checks (must pass for standard/deep)

- [ ] Validation method matching (validation methods correspond to hypothesis types)
- [ ] Maximum risk identification (identify the hypothesis with the highest risk score)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision record complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| Solution design data missing | User provides solution description, extract hypotheses | Lacks structured solution data, hypothesis coverage may be incomplete | Require user to provide solution description, or obtain design solution from harness-design handoff document (docs/handoff/design-to-solo.md) |
| PRD document missing | User provides solution description, extract hypotheses | Lacks PRD data, hypotheses may be disconnected from requirements | Require user to provide feature requirement description or upload prd.json file |
| Solution design + PRD both missing | User provides solution description, extract hypotheses | Overall confidence reduced, hypotheses may not be complete enough | Require user to provide core hypotheses and feature requirement description |
| All upstream files missing | Prompt user to execute prior stages first, or extract hypotheses based on user solution description | Output is only a basic hypothesis list | Require user to provide core hypotheses, user pain points, and feature requirements |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| assumption_map | array | Yes | Hypothesis list |
| assumption_map[].id | string | Yes | Hypothesis unique identifier |
| assumption_map[].feature_id | string | Yes | Associated feature point ID |
| assumption_map[].type | string | Yes | Hypothesis type (value/feasibility/usability/growth) |
| assumption_map[].assumption | string | Yes | Hypothesis content |
| assumption_map[].impact | number | Yes | Impact score (1-5) |
| assumption_map[].uncertainty | number | Yes | Uncertainty score (1-5) |
| assumption_map[].risk_score | number | Yes | Risk score (1-25) |
| assumption_map[].is_max_risk | boolean | Yes | Whether it is a maximum risk hypothesis |
| assumption_map[].validation_method | string | Yes | Recommended validation method |
| assumption_map[].validation_metric | string | Yes | Validation metric |
| summary | object | Yes | Statistical summary |
| summary.total_assumptions | integer | Yes | Total hypothesis count |
| summary.max_risk_assumptions | array | Yes | Maximum risk hypothesis ID list |

## Upstream Change Response

### Upstream Change Impact

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Solution design feature add/remove | Hypothesis extraction, risk assessment | Flag affected feature points, suggest human confirm whether to re-extract hypotheses |
| PRD core value change | Value hypotheses | Flag affected value hypotheses, suggest human confirm whether to re-assess |
| Prototype interaction change | Usability hypotheses | Flag affected usability hypotheses, suggest human confirm whether to re-assess |

### Downstream Notification Mechanism

| Assumption Map Change Type | Notification Scope | Notification Method |
|-----------------|----------|----------|
| Hypothesis add/remove | validation-mvp, validation-experiment | Mark hypothesis change, trigger MVP scope and experiment design update |
| Risk score change | validation-mvp, validation-experiment | Mark score change, trigger MVP Must Have and experiment priority update |
| Validation method change | validation-experiment | Mark method change, trigger experiment plan update |

---

## Usage Example

**Input**:
```
Feature point: Smart recommendations
PRD core value: Help users quickly discover content they are interested in
```

**Output**:
```json
{
  "assumption_map": [
    {
      "id": "A001",
      "feature_id": "F001",
      "type": "value",
      "assumption": "Users believe smart recommendations can help them discover content they are interested in",
      "impact": 4,
      "uncertainty": 4,
      "risk_score": 16,
      "is_max_risk": true,
      "validation_method": "User interviews",
      "validation_metric": "Recommended content click-through rate > 15%"
    },
    {
      "id": "A002",
      "feature_id": "F001",
      "type": "usability",
      "assumption": "Users can understand the source and meaning of recommended results",
      "impact": 3,
      "uncertainty": 3,
      "risk_score": 9,
      "is_max_risk": false,
      "validation_method": "Prototype testing",
      "validation_metric": "Task completion rate > 80%"
    }
  ]
}
```
