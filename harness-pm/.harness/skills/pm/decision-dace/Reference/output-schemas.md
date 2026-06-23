<!-- Reference material extracted from SKILL.md, consult as needed -->

# Output Schema / Insight Output Examples / Output Validation Rules

## Output Schema

```json
{
  "type": "object",
  "required": ["dace_status", "okr_tracking", "insight_id", "source", "narrative", "action_options"],
  "properties": {
    "dace_status": {"type": "object", "description": "DACE cycle status, including current phase and progress"},
    "okr_tracking": {"type": "object", "description": "OKR tracking data, including objectives, key results, and achievement rate"},
    "action_log": {"type": "array", "description": "Action log, including executed decisions and pending items"},
    "cycle_report": {"type": "object", "description": "Cycle report, including analysis conclusions and execution recommendations"},
    "insight_id": {"type": "string", "description": "Insight unique identifier"},
    "created_at": {"type": "string", "description": "Creation time"},
    "source": {"type": "object", "description": "Insight source, including type and confidence"},
    "narrative": {"type": "string", "description": "Narrative, including background, findings, impact, and recommendations"},
    "action_options": {"type": "array", "description": "Decision options list, including expected effects, risks, and confidence"},
    "decision_boundary": {"type": "object", "description": "Decision boundary, including type and auto-execution eligibility"},
    "decision_maker": {"type": "string", "description": "Decision maker role"},
    "deadline": {"type": "string", "description": "Decision deadline"}
  }
}
```

## Insight Output Example

```yaml
data_insight:
  insight_id: "insight_20240115_001"
  created_at: "2024-01-15T14:30:00Z"

  source:
    type: "experiment_result"
    experiment_id: "exp_20240115_simplified_register"
    confidence: "high"

  narrative: |
    ## Simplified Registration Flow Experiment Insight

    ### Background
    The product team launched the simplified registration flow experiment on January 15, 2024,
    shortening the 5-step registration flow to 3 steps.
    The experiment lasted 14 days with 24,830 users participating.

    ### Findings
    The experimental group (simplified flow) achieved a registration conversion rate of 38.1%,
    an improvement of 8.2 percentage points compared to the control group (standard flow) at 35.2%.
    This conclusion has 99.9% confidence (p=0.001).

    More importantly, this improvement is stable —
    from day 1 to day 14 of the experiment, the effect did not decay,
    indicating this is not a novelty effect for users, but a genuine experience improvement.

    ### Impact
    If we fully release this feature:
    - Estimated new registered users per month **+12%** (about 36,000 users/month)
    - Based on the current conversion funnel, estimated **+8%** DAU growth

    ### Risks
    We checked all guardrail metrics:
    - User 7-day retention: 42.0% → 41.8% (down 0.2%, acceptable)
    - DAU: Stable
    - Crash rate: No change

    All guardrail metrics are within safe ranges.

    ### Recommendation
    **Recommend full release of the simplified registration flow.**
    This is a low-risk, high-reward change, and the data supports immediate execution.

  action_options:
    - option: "Full release of simplified registration flow"
      option_id: "opt_001"
      expected_effect:
        primary: "Registration conversion rate +8.2%"
        secondary: ["DAU +2%", "New users +12%"]
      risk: "low"
      confidence: "high"

    - option: "Platform-specific release (iOS first)"
      option_id: "opt_002"
      expected_effect:
        primary: "iOS conversion +5.2%"
        secondary: ["Android to be verified"]
      risk: "medium"
      confidence: "medium"

    - option: "Continue experiment for 2 weeks"
      option_id: "opt_003"
      expected_effect:
        primary: "More data validation"
        secondary: ["Reduce uncertainty"]
      risk: "low"
      confidence: "low"

  decision_boundary:
    type: "data_decision"
    description: |
      Data clearly supports the "full release" option:
      - Statistically significant (p=0.001)
      - Practically significant (+8.2%)
      - All guardrail metrics safe
      - No novelty effect

    auto_execute_eligible: true

    automation_conditions:
      - condition: "Technical team confirms release readiness"
        required: true
      - condition: "Monitoring alerts configured"
        required: true
      - condition: "Rollback plan prepared"
        required: true

    override_conditions:
      - condition: "Business strategy change"
        action: "Pause auto-execution, wait for manual confirmation"

  recommended_action:
    action: "Full release of simplified registration flow"
    priority: "high"
    reason: "Data support is sufficient, risk is low, benefit is significant"

    next_steps:
      - step: 1
        task: "Technical review"
        owner: "engineering"
        deadline: "2024-01-17"
      - step: 2
        task: "Configure monitoring alerts"
        owner: "data_team"
        deadline: "2024-01-18"
      - step: 3
        task: "Release deployment"
        owner: "engineering"
        deadline: "2024-01-19"
      - step: 4
        task: "Post-release monitoring"
        owner: "data_team"
        duration: "2 weeks"
```

## Output File Structure

```
docs/metrics/decision-report.md ("DACE Decisions" section)
├── dace_status.json
├── okr_tracking.json
├── action_log.json
├── dace_cycle_report.md
├── decision_insight.json
└── insight_library.json
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| dace_status | object | Yes | DACE cycle status |
| dace_status.cycle_id | string | Yes | Cycle ID |
| dace_status.current_phase | string | Yes | Current phase, enum values: Define/Analyze/Conclude/Execute |
| dace_status.phase_history | array | Yes | Phase history |
| okr_tracking | object | Yes | OKR tracking data |
| okr_tracking.objectives | array | Yes | Objectives list |
| okr_tracking.objectives[].id | string | Yes | Objective ID |
| okr_tracking.objectives[].progress | number | Yes | Progress percentage |
| okr_tracking.objectives[].status | string | Yes | Status, enum values: on_track/at_risk/behind |
| action_log | array | Yes | Action log |
| action_log[].action_id | string | Yes | Action ID |
| action_log[].action | string | Yes | Action description |
| action_log[].status | string | Yes | Status, enum values: approved/in_progress/completed |
| data_insight | object | No | Data insight root object (Analyze phase output) |
| data_insight.insight_id | string | Yes | Insight unique identifier |
| data_insight.created_at | string | Yes | Creation time |
| data_insight.source | object | Yes | Insight source |
| data_insight.source.type | string | Yes | Source type, enum values: experiment_result/anomaly/funnel_analysis/retention_analysis |
| data_insight.source.confidence | string | Yes | Source confidence |
| data_insight.narrative | string | Yes | Narrative |
| data_insight.action_options | array | Yes | Decision options list, at least 2 |
| data_insight.action_options[].option_id | string | Yes | Option ID |
| data_insight.action_options[].expected_effect | object | Yes | Expected effect |
| data_insight.action_options[].risk | string | Yes | Risk level |
| data_insight.action_options[].confidence | string | Yes | Confidence |
| data_insight.decision_boundary | object | Yes | Decision boundary |
| data_insight.decision_boundary.type | string | Yes | Boundary type, enum values: data_decision/data_reference/human_decision |
| data_insight.decision_boundary.auto_execute_eligible | boolean | Yes | Whether auto-executable |
| data_insight.recommended_action | object | Yes | Recommended action |
| data_insight.recommended_action.action | string | Yes | Action description |
| data_insight.recommended_action.priority | string | Yes | Priority |
