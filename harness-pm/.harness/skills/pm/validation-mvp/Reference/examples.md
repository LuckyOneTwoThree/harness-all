# MVP Scope - JSON Examples & Templates

This file collects all JSON code blocks referenced by `SKILL.md` for the `validation-mvp` skill.

## Input Format

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

## Step 1: Core Hypothesis & Must Have Output Format

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

## Step 2: Cut Features Output Format

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

## Step 3: Nice to Have Output Format

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

## Step 5: Timeline Output Format

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

## Step 6: Resource Estimate Output Format

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

## Step 7: Success Criteria & Risk Mitigation Output Format

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

## Step 8: Go/No-Go Decision Framework Output Format

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

## Output File: mvp_definition.json

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
