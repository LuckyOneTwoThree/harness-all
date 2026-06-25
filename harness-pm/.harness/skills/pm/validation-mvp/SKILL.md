---
name: validation-mvp
description: Used when defining the MVP feature scope. MVP scope auto-definition tool that intelligently identifies Must Have, MUST NOT, and Nice to Have features based on the assumption map and resource constraints, and evaluates the MVP size ratio. Keywords: MVP scope, Minimum Viable Product, feature priority, resource constraints, minimal product, core features.
---
# MVP Scope Auto-Definition

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/product/PRD.md
- docs/handoff/design-to-solo.md

## Outputs
- docs/product/PRD.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **MVP validates hypotheses, not solutions** — The goal of an MVP is learning, not delivery; acquire maximum confidence at minimum cost
2. **Must Have is the MVP baseline** — Must Have features cannot be cut; Nice to Have features are all cuttable
3. **2 weeks is the MVP time redline** — An MVP exceeding 2 weeks is not an MVP, it is a full product
4. **Validation results have only three outcomes** — Validated / Invalidated / Needs more data; ambiguous conclusions are not allowed

### Basic Information

| Attribute | Value |
|------|-----|
| Pipeline ID | 11 |
| Name | MVP Scope Auto-Definition |
| Execution Mode | 🤖→👤 AI suggests, human approves |
| Input | Solution design + Assumption map + Resource constraints |

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Solution design | JSON | Yes | User-provided or harness-design output | Complete feature list and descriptions |
| Assumption map | JSON | Yes | docs/product/PRD.md ("Assumption Map" section) | Assumption map output from Pipeline 10 |
| Resource constraints | JSON | ○ | User-provided | Time, staffing, and budget constraints |

### Input Format
```json
{
  "solution_design": {
    "features": [
      {
        "id": "F001",
        "name": "Feature name",
        "description": "Feature description",
        "effort_estimate": "Effort estimate"
      }
    ]
  },
  "assumption_map": [...],
  "resource_constraints": {
    "timeline_weeks": 8,
    "team_size": 4,
    "budget": "Budget limit"
  }
}
```

## Execution Steps

### Step 1: Core Hypothesis Extraction and Must Have Identification [Core]

**Definition**: Features directly related to the highest-risk assumptions = must include

**Logic**:
1. Find all assumptions where is_max_risk = true
2. Extract the core hypothesis list
3. Identify features linked to these hypotheses
4. Mark as Must Have

**Output Format**:
```json
{
  "core_hypothesis": [
    {
      "id": "A001",
      "description": "Hypothesis description",
      "risk_score": 20
    }
  ],
  "must_have": [
    {
      "feature": "Feature name",
      "linked_assumption": "Linked highest-risk assumption",
      "effort_estimate": "Effort estimate",
      "rationale": "Reason for must-include"
    }
  ]
}
```

### Step 2: Cut Feature Identification [Core]

**Definition**: Features that interfere with core hypothesis validation = exclude

**Exclusion Criteria**:

| Exclusion Type | Description | Example |
|----------|------|------|
| Over-built | Full features beyond MVP validation needs | MVP needs a list, but full search + filter + sort is built |
| Over-polished | High-fidelity design not necessary for MVP | Heavy investment in interaction animations |
| Over-configured | Complex configuration items not necessary for validation | Multi-dimensional custom settings |

**Output Format**:
```json
{
  "cut_features": [
    {
      "feature": "Feature name",
      "rationale": "Reason for exclusion (interferes with core hypothesis validation)"
    }
  ]
}
```

### Step 3: Nice to Have Classification [Core]

**Definition**: Features that are neither Must Have nor cut features

**Priority Rules**:
1. Features linked to high-risk assumptions but not directly related → P1
2. Features linked to medium-risk assumptions → P2
3. Features linked to low-risk assumptions → P3

**Output Format**:
```json
{
  "nice_to_have": [
    {
      "feature": "Feature name",
      "priority": "P1/P2/P3",
      "target_version": "v2.0/v3.0"
    }
  ]
}
```

### Step 4: MVP Size Assessment [Core]

**Formula**:

```
MVP ratio = Must Have effort / Full solution effort × 100%
```

**Effort Unit**: person-days / person-weeks / story points (per team convention)

**Assessment Criteria**:

| MVP Ratio | Assessment | Recommendation |
|---------|----------|------|
| < 40% | ✅ Ideal | Can start MVP development |
| 40-60% | ⚠️ Acceptable | Review whether Nice to Have can be further trimmed |
| > 60% | 🚨 Needs review | Escalate to human judgment, confirm whether to adjust |

### Step 5: Timeline Planning [Core]

**Definition**: Build a timeline based on MVP feature effort and resource constraints

**Planning Logic**:
1. Sum Must Have feature effort
2. Combine with timeline_weeks and team_size from resource constraints
3. Ensure total weeks ≤ 2 (MVP time redline)
4. Break down milestone checkpoints

**Output Format**:
```json
{
  "timeline": {
    "total_weeks": 2,
    "milestones": [
      {
        "name": "Milestone name",
        "week": 1,
        "deliverables": ["Deliverable 1", "Deliverable 2"]
      }
    ]
  }
}
```

### Step 6: Resource Estimation [Core]

**Definition**: Estimate required resources based on MVP feature effort and timeline

**Estimation Logic**:
1. Calculate staffing needs based on Must Have feature effort
2. Derive team configuration from timeline.total_weeks
3. Assess whether external resource support is needed

**Output Format**:
```json
{
  "resource_estimate": {
    "team_size": 3,
    "roles": [
      {
        "role": "Role name",
        "count": 1,
        "rationale": "Configuration rationale"
      }
    ],
    "external_dependencies": []
  }
}
```

### Step 7: Success Criteria and Risk Mitigation [Core]

**Definition**: Define success criteria for MVP validation and identify risks with mitigation measures

**Success Criteria Logic**:
1. Convert core hypotheses into quantifiable validation metrics
2. Each core hypothesis maps to at least one success criterion
3. Success criteria must be quantifiable (with specific values or thresholds)

**Risk Mitigation Logic**:
1. Identify key risks during MVP execution
2. Develop mitigation measures for each risk
3. Assess risk impact level

**Output Format**:
```json
{
  "success_criteria": [
    {
      "criterion": "Success criterion description",
      "metric": "Quantitative metric",
      "target_value": "Target value",
      "linked_hypothesis": "Linked hypothesis ID"
    }
  ],
  "risk_mitigation": [
    {
      "risk": "Risk description",
      "impact": "high/medium/low",
      "mitigation": "Mitigation measure"
    }
  ]
}
```

### Step 8: Go/No-Go Decision Framework [Core]

**Definition**: Build a Go/No-Go decision framework based on success criteria; metrics directly reference the quantitative metrics in success_criteria

**Decision Logic**:
1. Extract key decision metrics from success_criteria (select one primary metric per core hypothesis)
2. Define Go/No-Go thresholds for each metric (based on fluctuation around success_criteria.target_value)
3. Include at least 2 metrics and corresponding thresholds
4. Metrics do not redefine indicators; they reference success_criteria via linked_criterion

**Output Format**:
```json
{
  "go_no_go": {
    "metrics": [
      {
        "name": "Metric name",
        "linked_criterion": "Linked success_criteria index",
        "description": "Metric description"
      }
    ],
    "thresholds": {
      "go": "Go condition description",
      "no_go": "No-Go condition description",
      "needs_more_data": "Needs more data condition description"
    }
  }
}
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | MVP scope and validation plan | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full solution + MVP scope optimization + validation metrics system + iteration evolution roadmap | Full artifact + extended analysis + deep reasoning |

## Output

**Storage Path**: `docs/product/PRD.md ("MVP Plan" section)`
**Output File**: mvp_definition.json

```json
{
  "mvp_scope": {
    "core_hypothesis": [
      { "id": "A001", "description": "Hypothesis description", "risk_score": 20 }
      // ... same structure extensible
    ],
    "must_have": [
      { "feature": "Feature name", "linked_assumption": "Linked hypothesis ID", "effort_estimate": 8, "rationale": "Reason for must-include" }
      // ... same structure extensible
    ],
    "nice_to_have": [
      { "feature": "Feature name", "priority": "P1", "target_version": "v2.0" }
      // ... same structure extensible
    ],
    "cut_features": [
      { "feature": "Feature name", "rationale": "Exclusion reason" }
      // ... same structure extensible
    ],
    "timeline": { "total_weeks": 2, "milestones": [{ /* same as Step 5 structure */ }] },
    "resource_estimate": { "team_size": 3, "roles": [{ /* same as Step 6 structure */ }], "external_dependencies": [] },
    "success_criteria": [{ /* same as Step 7 structure */ }],
    "risk_mitigation": [{ /* same as Step 7 structure */ }],
    "effort_summary": { "mvp_total": 24, "full_solution_total": 60, "mvp_ratio": "40%" },
    "go_no_go": { "metrics": [{ /* same as Step 8 structure */ }], "thresholds": { "go": "...", "no_go": "...", "needs_more_data": "..." } }
  },
  "approval_status": "pending|approved|needs_discussion",
  "recommendation": "AI recommendation notes"
}
```

**Output Validation Rules**: See the Output Validation Rules section below

## Decision Rules

| Rule | Condition | Action |
|------|------|------|
| Human approval triggered | MVP ratio > 60% | Escalate to human judgment |
| Approval triggered | Must Have has no hypothesis linkage | Requires supplementary explanation |
| Approval triggered | cut_features rationale insufficient | Requires supplementary exclusion basis |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Core hypotheses (core_hypothesis is non-empty and linked to must_have)
- [ ] Hypothesis linkage (Must Have features all have hypothesis linkage)

### P1 Checks (must pass for standard/deep)

- [ ] Exclusion rationale (cut_features all have sufficient rationale)
- [ ] Ratio calculation (MVP ratio calculated)
- [ ] Priority completeness (Nice to Have all have priority)
- [ ] Time redline (timeline.total_weeks ≤ 2; when exceeded, human_override must be true)
- [ ] Success criteria quantifiable (success_criteria contains quantitative metrics and target values)
- [ ] Go/No-Go completeness (go_no_go contains at least 2 metrics and corresponding thresholds)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| Assumption map missing | User describes key hypotheses, define MVP | Lacks structured hypothesis data, MVP scope may be less precise | Ask user to provide key hypothesis list and validation priority or upload assumption map file |
| Solution design data missing | User describes solution, define MVP | Lacks solution data, feature cuts may be less reasonable | Ask user to provide feature solution description and core feature list or upload ideation output file |
| Resource constraint data missing | User describes resource constraints, define MVP | Lacks resource constraint data, timeline may be less reasonable | Ask user to provide team size, available timeline, and tech stack resource constraints |
| Assumption map + solution design + resource constraints all missing | User describes hypotheses and solution, define MVP | Overall confidence reduced, MVP scope may be incomplete | Ask user to provide key hypotheses, feature solution, and resource constraint descriptions |
| All upstream files missing | Prompt user to run preceding stages first, or define MVP based on user description | Output is only a basic MVP framework | Ask user to provide core hypotheses, minimum feature set, and resource constraints |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| mvp_scope | object | Yes | MVP scope definition |
| mvp_scope.core_hypothesis | array | Yes | Core hypothesis list |
| mvp_scope.must_have | array | Yes | Must Have feature list |
| mvp_scope.nice_to_have | array | Yes | Nice to Have feature list |
| mvp_scope.cut_features | array | Yes | Cut feature list |
| mvp_scope.timeline | object | Yes | Timeline |
| mvp_scope.timeline.total_weeks | number | Yes | Total weeks (≤2; when exceeded, human_override: true required) |
| mvp_scope.timeline.milestones | array | Yes | Milestone list |
| mvp_scope.resource_estimate | object | Yes | Resource estimate |
| mvp_scope.effort_summary | object | Yes | Effort summary |
| mvp_scope.effort_summary.mvp_total | number | Yes | MVP total effort |
| mvp_scope.effort_summary.full_solution_total | number | Yes | Full solution total effort |
| mvp_scope.effort_summary.mvp_ratio | string | Yes | MVP ratio |
| mvp_scope.success_criteria | array | Yes | Success criteria |
| mvp_scope.risk_mitigation | array | Yes | Risk mitigation measures |
| mvp_scope.go_no_go | object | Yes | Go/No-Go decision framework |
| mvp_scope.go_no_go.metrics | array | Yes | Decision metrics |
| mvp_scope.go_no_go.thresholds | object | Yes | Threshold definitions |
| human_override | boolean | Yes | Human override flag (default false; must be true when total_weeks > 2) |

## Upstream Change Response

### Upstream Change Impact

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Assumption map change (hypothesis add/remove or risk score change) | Core hypotheses, Must Have features | Mark affected hypotheses and features; recommend human confirm whether to redefine MVP |
| Solution design change | Feature list, cut decisions | Mark affected features; recommend human confirm whether to adjust MVP scope |
| Resource constraint change | Timeline, resource estimate | Mark affected timeline; recommend human confirm whether to adjust MVP scope |
| Experiment result update | Core hypothesis validation status | Mark affected hypotheses; recommend human confirm whether to adjust MVP strategy |

### Downstream Notification Mechanism

| MVP Scope Change Type | Notification Scope | Notification Method |
|----------------|----------|----------|
| Must Have feature add/remove | validation-experiment, validation-usability | Mark feature change, trigger experiment design and usability test update |
| Timeline change | validation-experiment | Mark timeline change, trigger experiment cycle adjustment |
| Success criteria change | validation-experiment | Mark criteria change, trigger experiment metric update |
| Go/No-Go decision change | All downstream Skills | Mark decision change, trigger full-flow update |

---

## Usage Example

**Highest-risk hypothesis in the assumption map**:
- A001: Users feel recommended content matches their interests (risk score: 20)

**Features in the solution design**:
- F001: Intelligent recommendation algorithm
- F002: Recommendation result display
- F003: Favorites feature
- F004: Share feature
- F005: High-fidelity animations

**AI Analysis**:
```
Core Hypothesis:
- A001: Users feel recommended content matches their interests (risk score: 20)

Must Have:
- F001 Intelligent recommendation algorithm (directly validates A001)
- F002 Recommendation result display (required to validate A001)

Cut Features:
- F005 High-fidelity animations (interferes with core validation, not necessary for MVP)

Nice to Have:
- F003 Favorites feature (P2, v2.0)
- F004 Share feature (P3, v3.0)

Timeline:
- Total 2 weeks; Week 1 complete core algorithm, Week 2 complete display and validation

Resource Estimate:
- 3 people: 1 backend + 1 frontend + 1 data

Success Criteria:
- Recommendation match rate ≥ 60% (linked to A001)

Risk Mitigation:
- Insufficient algorithm accuracy (high) → Degrade to rule-based recommendations

Go/No-Go:
- metrics: recommendation match rate, user click-through rate
- Go: match rate ≥ 60% and click-through rate ≥ 30%
- No-Go: match rate < 40% or click-through rate < 15%

MVP Ratio: 40% ✅ Ideal
```
