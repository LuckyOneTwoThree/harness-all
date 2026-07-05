<!-- Reference material extracted from SKILL.md, consult as needed -->

# DACE Status Tracking / OKR Configuration / Auto-trigger Mechanism

## DACE Status Tracking

```yaml
dace_status:
  cycle_id: "dace_2024_Q1"
  current_phase: "Execute"

  phase_history:
    - phase: "Define"
      started: "2024-01-01"
      completed: "2024-01-05"
      output: "Q1 OKR system"

    - phase: "Analyze"
      started: "2024-01-05"
      completed: "2024-01-15"
      output: "Comprehensive analysis report + narrative insights"

    - phase: "Conclude"
      started: "2024-01-15"
      completed: "2024-01-18"
      output: "Decision recommendations + approval"

    - phase: "Execute"
      started: "2024-01-18"
      status: "in_progress"
      output: "Tracking results"

  insights:
    total_insights: 12
    actionable: 8
    implemented: 3
    pending: 5

  action_taken:
    total_actions: 3
    completed: 1
    in_progress: 1
    pending: 1

  results_tracked:
    active_tracking: 2
    target_achieved: 0
    target_at_risk: 0
    target_on_track: 2
```

## Auto-trigger Mechanism

| Trigger Condition | DACE Response |
|---------|---------|
| OKR update | Re-Define |
| Anomaly detection | Prioritize Analyze, trigger Conclude |
| Experiment completion | Analyze results, trigger Conclude |
| Decision execution | Enter Execute tracking |
| Cycle end | Complete current cycle, prepare for next cycle |

## OKR Tracking Configuration

```yaml
okr_tracking:
  cycle: "quarterly"
  current_cycle: "2024_Q1"

  update_frequency:
    progress: "daily"
    review: "weekly"
    recalibration: "monthly"

  alert_rules:
    - condition: "KR progress behind > 20%"
      severity: "high"
      action: "Trigger Conclude"

    - condition: "KR cannot be completed"
      severity: "critical"
      action: "Escalation + OKR adjustment"
```
