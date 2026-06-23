---
name: monitoring-orchestrator
description: Used when establishing a product monitoring system or handling anomaly alerts. Monitoring & alerting orchestrator that dispatches monitoring-alert-detection, monitoring-attribution, and user-feedback-loop-report sub-skills. Keywords: monitoring & alerting, anomaly detection, alert triage, monitoring system, health monitoring, monitoring dashboard, alert escalation, feedback loop, production alerts, system monitoring, anomaly attribution, root cause analysis.
metadata:
  module: "Product Monitoring & Iteration"
  sub-module: "Monitoring & Alerting"
  type: "orchestrator"
  version: "9.0"
  domain_tags: ["General"]
  trigger_examples:
    - "Establish a product monitoring system"
    - "Production anomaly alert"
    - "Configure monitoring dashboards"
    - "Handle production issues"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/monitoring/monitoring-config.md
  - docs/monitoring/feedback-loop.md
writes:
  - output/phase-reports/monitoring-orchestrator.json
  - memory/progress.md
  - memory/knowledge-base.md
---

# Monitoring & Alerting Orchestrator

## Core Principle

**Solve problems before users discover them**

The highest state of monitoring is not rapid response, but proactive prevention. By the time users perceive a problem, damage has already occurred. The value of a monitoring system lies in moving problem detection earlier, ahead of user perception.

## Orchestration Philosophy

1. **System first, alerts follow, escalation as backstop**: First build the monitoring system to establish baselines, then respond precisely based on alert attribution, and finally use escalation mechanisms as a safety net
2. **Data flows progressively across system → attribution → escalation**: The monitoring system defines alert rules, alert attribution provides root causes, and the escalation mechanism notifies precisely based on root causes

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: monitoring-orchestrator
version: 9.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/monitoring-orchestrator.json

stages:
  - id: phase-1
    name: "Monitoring Alert Detection"
    depends_on: []
    skills: [monitoring-alert-detection]
    gate:
      condition: "Monitoring alert detection complete (core path coverage ≥ 95%, alert noise rate < 15%)"
      fail_action: "Supplement monitoring config for missing paths, optimize alert rules"

  - id: phase-2
    name: "Anomaly Attribution Analysis"
    depends_on: [phase-1]
    skills: [monitoring-attribution]
    trigger: Anomaly alert triggered
    gate:
      condition: "Attribution analysis complete (each alert event has root cause conclusion and impact assessment)"
      fail_action: "Supplement evidence data or manually investigate candidate root causes"

  - id: phase-3
    name: "User Feedback Loop"
    depends_on: [phase-2]
    skills: [user-feedback-loop-report]
    trigger: User feedback loop requirement
    gate:
      condition: "Feedback loop report confirmed by human review"
      fail_action: "Supplement analysis or revise improvement suggestions"
```

## Stage Execution Plan

#### Call monitoring-alert-detection

```
Skill: monitoring-alert-detection
Input:
  product_architecture: User-provided
  metrics_system: metrics-system → metric_system.json
  sla_requirements: User-provided
  release_info: release-gradual → release_record.json (optional)
  user_roles: User-provided
  oncall_schedule: On-call management system → schedule
Output: docs/monitoring/monitoring-config.md ("Alert Rules" section)
Validation: Core path coverage ≥ 95%; each core path has at least 4 golden signals; alert noise rate < 15%; alert classification accuracy ≥ 85%; all roles have corresponding dashboards; alert severity accuracy ≥ 90%; escalation trigger timeliness 100%
Mode: 🤖
```

#### Call monitoring-attribution

```
Skill: monitoring-attribution
Input:
  alert_events: monitoring-alert-detection → monitoring-alert-detection.json
  classification: monitoring-alert-detection → alert classification
  correlation: monitoring-alert-detection → correlation analysis
  release_info: release-gradual → release_record.json (optional)
  root_cause_kb: User-provided (optional)
  product_architecture: User-provided (optional)
Output: docs/monitoring/monitoring-config.md ("Attribution Model" section)
Validation: Each alert event has root cause conclusion and evidence; impact scope quantified; remediation suggestions actionable with rollback plans; root cause confidence labeled
Mode: 🤖
```

#### Call user-feedback-loop-report

```
Skill: user-feedback-loop-report
Input:
  voice_analysis: user-research-voice-analysis (optional)
  anomaly_attribution: monitoring-attribution (optional)
  feedback_data: User-provided
Output: docs/monitoring/feedback-loop.md
Validation: Closure rate calculable; unresolved P0 issues listed; improvement suggestions actionable
Mode: 🤖→👤
```

### Stage Summary (post_pipeline)

After all sub-skills complete execution, a stage summary document must be generated and written to `output/phase-reports/monitoring-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-skill (1-3 items), cross-sub-skill cross-cutting insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Deliverables List**: All output file paths and content summaries, deliverable quality assessment (whether validation passed)
5. **Risks & Follow-ups**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/monitoring/ |
| Summary output path | output/phase-reports/monitoring-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: diagnosis-orchestrator (monitoring & alerting established; if anomalies are found, proceed to diagnosis to locate root causes)
  alternatives:
    - target: release-orchestrator
      reason: Monitoring detects need for a release fix
      condition: When monitoring & alerting triggers P0/P1 level anomalies requiring emergency fixes
    - target: iteration-orchestrator
      reason: Monitoring data indicates need to adjust iteration priorities
      condition: When monitoring metric trends continuously deteriorate and iteration direction needs adjustment
  special_cases:
    - target: monitoring-alert-detection
      reason: Only need to set up monitoring, no need for full monitoring orchestration
      condition: When a feedback loop mechanism already exists and only monitoring & alerting configuration is needed

## Stage Gates

| Gate | Condition | Handling if Not Passed |
|------|------|------------|
| Monitoring alert detection complete | monitoring-alert-detection output file generated and non-empty, core path coverage ≥ 95% | Supplement monitoring config for missing paths, optimize alert rules, supplement visualization config or escalation rules |
| Anomaly attribution analysis complete | monitoring-attribution output file generated and non-empty, each alert event has root cause conclusion | Supplement evidence data or manually investigate candidate root causes |
| Feedback loop report reviewed | Feedback loop report confirmed by human review | Supplement analysis or revise improvement suggestions |
| Stage summary generated | output/phase-reports/monitoring-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Alert threshold adjustment | Alert noise rate too high or miss rate too high | Confirm alert threshold adjustment plan |
| Dashboard layout confirmation | Dashboard build complete | Confirm core metric display and layout |
| Escalation strategy confirmation | Escalation rules generated | Confirm escalation paths and notification channel config |
| Root cause confirmation | Candidate root causes ≥ 3 or confidence < 0.6 | Confirm final root cause or specify manual investigation direction |
| Feedback loop report confirmation | Feedback loop report generation complete | Confirm closure rate and improvement suggestions |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Monitoring system core path coverage insufficient (< 80%) | Pause subsequent stages, require user to supplement product architecture info to complete core paths |
| Alert noise rate too high (> 30%) | Pause alert analysis, fall back to monitoring system to optimize alert rules before continuing |
| Root cause uncertain (candidate causes ≥ 3) | Output Top 3 candidate causes and confidence, mark for manual investigation, do not block attribution report generation |
| On-Call schedule missing | Use default escalation rules, mark "schedule pending configuration", P0 alerts notify product owner directly |
| Sub-skill output validation failed | Fall back to current stage and re-execute, max 1 retry; if still fails, mark exception and escalate to human |
| Upstream/downstream data format incompatible | Map fields and fill defaults per downstream sub-skill input schema, record mapping relationships |
| Stage summary generation failed | Generate partial summary based on completed sub-skill outputs, mark missing items as "data missing", do not block orchestration completion |
| Release requirement | Hand off to release-orchestrator |
