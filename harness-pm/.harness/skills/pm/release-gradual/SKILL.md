---
name: release-gradual
description: Used when executing canary release. Canary release auto-execution, performs progressive canary release from 1% to 10% to 50% to 100%, automatically monitors metrics at each stage and determines whether to proceed to the next stage, supports auto-rollback when P0 metrics deteriorate. 🤖 AI auto-executes. Keywords: canary release, progressive release, Feature Flag, auto-rollback, release strategy, canary deployment, small traffic, gradual traffic increase.
---
# Canary Release Auto-Execution

## Outputs
- docs/monitoring/release-notes.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Trigger-driven**: Canary release auto-triggered by quality gate pass event, metric deterioration auto-triggers rollback
2. **Automated acceptance**: Per-stage metrics auto-monitored, stage transitions auto-determined, rollback auto-executed
3. **Continuous deployment**: Canary strategy combined with Feature Flag for progressive deployment and instant rollback
4. **Real-time retrospective**: Per-stage metrics aggregated in real-time, retrospective input generated immediately after release completion

## Interaction Mode

🤖 **AI auto-executes**

Trigger conditions:
- Quality gate passed
- Manual trigger (release lead confirmation)

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Release content | JSON | Yes | Release management system | Version and change content to be released |
| Feature Flag configuration | JSON | Yes | Feature Flag system | Canary switch configuration |
| Monitoring metric definitions | JSON | Yes | Monitoring system | Per-stage monitoring metrics |
| Canary strategy configuration | JSON | Yes | Release strategy library | Per-stage traffic ratio and duration |

### Release Content Structure Example

```json
{
  "release_id": "release_2024_0125_001",
  "version": "v2.1.0",
  "build_ref": "abc123def",
  "change_summary": "Add WeChat login feature, optimize login flow",
  "affected_services": ["auth-service", "user-service"],
  "rollback_version": "v2.0.9",
  "rollback_strategy": "feature_flag_offline"
}
```

## Canary Stage Configuration

### Standard Canary Stages

| Stage | Traffic Ratio | Duration | Min Duration | Pass Condition |
|------|----------|----------|--------------|----------|
| Stage 0 | 0% (verification) | - | 10 minutes | Build verification passed |
| Stage 1 | 1% | 30 minutes | 30 minutes | Core metrics no anomaly |
| Stage 2 | 10% | 2 hours | 1 hour | P0 metrics stable |
| Stage 3 | 50% | 4 hours | 2 hours | No new anomalies |
| Stage 4 | 100% | - | - | All conditions passed |

### Guardrail Metrics Configuration

```json
{
  "guardrail_metrics": {
    "p0_metrics": [
      {
        "name": "error_rate",
        "description": "5xx error rate",
        "unit": "percentage",
        "warning_threshold": 0.01,
        "rollback_threshold": 0.03,
        "comparison": "vs_baseline"
      },
      {
        "name": "latency_p99",
        "description": "P99 response time",
        "unit": "milliseconds",
        "warning_threshold": 500,
        "rollback_threshold": 1000,
        "comparison": "vs_baseline"
      },
      {
        "name": "availability",
        "description": "Service availability",
        "unit": "percentage",
        "warning_threshold": 99.9,
        "rollback_threshold": 99.0,
        "comparison": "absolute"
      }
    ],
    "p1_metrics": [
      {
        "name": "api_success_rate",
        "description": "API success rate",
        "unit": "percentage",
        "warning_threshold": 99,
        "rollback_threshold": 97
      },
      {
        "name": "error_count",
        "description": "Error count",
        "unit": "count",
        "warning_threshold": 100,
        "rollback_threshold": 500
      }
    ],
    "p2_metrics": [
      {
        "name": "conversion_rate",
        "description": "Business conversion rate",
        "unit": "percentage",
        "warning_threshold": -10,
        "rollback_threshold": -30,
        "comparison": "vs_previous_phase"
      }
    ]
  }
}
```

## Execution Steps

### Step 1: Canary Plan Generation [Core]

#### 1.1 Pre-Release Verification

**Verification Checklist**:

| Verification Item | Check Content | Failure Handling |
|--------|----------|----------|
| Build artifact | Verify build artifact integrity | Block release |
| Rollback version | Confirm rollback version available | Block release |
| Feature Flag | Verify Flag configuration correct | Block release |
| Monitoring alerts | Verify alert rules configured | Block release |
| On-call personnel | Confirm on-call personnel online | Warning |

**Verification Output**:

```json
{
  "pre_release_verification": {
    "build_artifact": {"verified": true, "sha256": "abc123..."},
    "rollback_version": {"available": true, "version": "v2.0.9"},
    "feature_flag": {"configured": true, "flag_key": "feature_wechat_login"},
    "monitoring": {"alerts_configured": true, "channel": "pagerduty"},
    "on_call": {"confirmed": true, "engineer": "dev_zhang"},
    "ready_to_release": true
  }
}
```

#### 1.2 Canary Plan Generation

**Plan Structure**:

```json
{
  "canary_plan": {
    "plan_id": "canary_2024_0125_001",
    "release_id": "release_2024_0125_001",
    "phases": [
      {
        "phase_id": "phase_1",
        "traffic_percentage": 1,
        "duration_minutes": 30,
        "min_duration_minutes": 30,
        "target_users": {
          "strategy": "random",
          "percentage": 1
        },
        "success_criteria": {
          "p0_metrics": "all_normal",
          "p1_metrics": "all_normal",
          "manual_approval": false
        }
      },
      {
        "phase_id": "phase_2",
        "traffic_percentage": 10,
        "duration_minutes": 120,
        "min_duration_minutes": 60,
        "target_users": {
          "strategy": "random",
          "percentage": 10
        },
        "success_criteria": {
          "p0_metrics": "stable",
          "p1_metrics": "all_normal",
          "manual_approval": true
        }
      },
      {
        "phase_id": "phase_3",
        "traffic_percentage": 50,
        "duration_minutes": 240,
        "min_duration_minutes": 120,
        "target_users": {
          "strategy": "random",
          "percentage": 50
        },
        "success_criteria": {
          "p0_metrics": "stable",
          "p1_metrics": "stable",
          "manual_approval": true
        }
      },
      {
        "phase_id": "phase_4",
        "traffic_percentage": 100,
        "duration_minutes": null,
        "target_users": {
          "strategy": "all"
        },
        "success_criteria": {
          "p0_metrics": "all_normal",
          "p1_metrics": "all_normal",
          "manual_approval": true
        }
      }
    ]
  }
}
```

### Step 2: Feature Flag Auto-Configuration [Core]

#### 2.1 Flag Configuration Generation

**Configuration Rules**:

```json
{
  "feature_flag_config": {
    "flag_key": "feature_wechat_login",
    "flag_type": "boolean",
    "default_value": false,
    "serving_config": {
      "phase_1": {
        "percentage": 1,
        "rules": [
          {
            "name": "random_1_percent",
            "percentage": 1,
            "variation": true
          }
        ]
      },
      "phase_2": {
        "percentage": 10,
        "rules": [
          {
            "name": "random_10_percent",
            "percentage": 10,
            "variation": true
          }
        ]
      },
      "phase_3": {
        "percentage": 50,
        "rules": [
          {
            "name": "random_50_percent",
            "percentage": 50,
            "variation": true
          }
        ]
      },
      "phase_4": {
        "percentage": 100,
        "rules": [
          {
            "name": "all_users",
            "percentage": 100,
            "variation": true
          }
        ]
      }
    }
  }
}
```

#### 2.2 Flag Status Tracking

**Status Record**:

```json
{
  "flag_status_tracking": {
    "flag_key": "feature_wechat_login",
    "current_phase": "phase_2",
    "current_traffic_percentage": 10,
    "last_updated": "ISO8601",
    "updated_by": "release-gradual-pipeline",
    "history": [
      {"timestamp": "ISO8601", "phase": "phase_1", "percentage": 1, "action": "enabled"},
      {"timestamp": "ISO8601", "phase": "phase_2", "percentage": 10, "action": "increased"},
      {"timestamp": "ISO8601", "phase": "phase_2", "percentage": 0, "action": "rollback"}
    ]
  }
}
```

### Step 3: Per-Stage Auto-Monitoring [Conditional]

#### 3.1 Metric Collection

**Collection Configuration**:

```json
{
  "metrics_collection": {
    "interval_seconds": 30,
    "metrics": [
      {"name": "error_rate", "source": "prometheus", "query": "rate(http_requests_total{status=~'5..'}[5m])"},
      {"name": "latency_p99", "source": "prometheus", "query": "histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))"},
      {"name": "availability", "source": "synthetic_monitoring", "frequency": "1m"}
    ]
  }
}
```

#### 3.2 Stage Status Assessment

**Assessment Rules**:

| Metric Type | Assessment Condition | Assessment Result |
|----------|----------|----------|
| All P0 normal | No metric exceeds warning threshold | **Can proceed to next stage** |
| Any P0 warning | Any metric exceeds warning but not rollback | **Continue observation** |
| P0 deterioration | Any metric exceeds rollback threshold | **Immediately rollback** |
| P1 alert | P1 metric exceeds threshold | **Delay + alert** |

**Stage Assessment Output**:

```json
{
  "phase_assessment": {
    "phase_id": "phase_2",
    "assessed_at": "ISO8601",
    "duration_minutes": 90,
    "metrics_summary": {
      "p0_metrics": {
        "error_rate": {"current": 0.002, "baseline": 0.001, "status": "normal"},
        "latency_p99": {"current": 150, "baseline": 140, "status": "normal"},
        "availability": {"current": 99.99, "baseline": 99.99, "status": "normal"}
      },
      "p1_metrics": {
        "api_success_rate": {"current": 99.5, "baseline": 99.8, "status": "normal"}
      },
      "p2_metrics": {
        "conversion_rate": {"current": -2, "baseline": 0, "status": "normal"}
      }
    },
    "overall_status": "healthy",
    "recommendation": "can_proceed",
    "confidence": 0.95
  }
}
```

#### 3.3 Stage Transition Decision

**Decision Flow**:

```
┌─────────────────┐
│ Stage time met? │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
   Yes       No
    │         │
    ▼         ▼
┌────────┐ ┌─────────────────┐
│Metric  │ │Continue         │
│eval    │ │monitoring       │
└───┬────┘ └─────────────────┘
    │
    ▼
┌─────────────────┐
│ All P0 metrics  │
│ normal?         │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
   Yes       No
    │         │
    ▼         ▼
┌────────┐ ┌─────────────────┐
│Proceed │ │ Alert/Observe/  │
│to next │ │ Rollback        │
│stage   │ └─────────────────┘
└────────┘
```

**Transition Output**:

```json
{
  "phase_transition_decision": {
    "current_phase": "phase_2",
    "decision": "proceed_to_next_phase",
    "next_phase": "phase_3",
    "reason": "Stage duration met, all P0 metrics normal",
    "metrics_verified": true,
    "approved_by": "release-gradual-pipeline",
    "scheduled_at": "ISO8601"
  }
}
```

### Step 4: Auto-Rollback Trigger [Deep]

#### 4.1 Rollback Trigger Conditions

**Trigger Rules**:

| Condition | Trigger Action | Delay |
|------|----------|------|
| P0 metric exceeds rollback threshold | **Immediate auto-rollback** | 0 seconds |
| Service unavailable | **Immediate auto-rollback** | 0 seconds |
| P1 metric exceeds rollback threshold | Delayed observation | 5 minutes |
| Human-confirmed anomaly | Manual trigger | 0 seconds |

#### 4.2 Rollback Execution

**Rollback Flow**:

```
Trigger rollback
    │
    ▼
┌─────────────────┐
│ Notify relevant │
│ personnel       │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
  Automated  Manual
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────────┐
│Turn off │ │Confirm and      │
│Flag     │ │execute          │
│Switch   │ └─────────────────┘
│traffic  │
└────┬────┘
     │
     ▼
┌─────────────────┐
│ Verify rollback │
│ result          │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
  Success   Failure
    │         │
    ▼         ▼
┌─────────┐ ┌─────────────────┐
│Record   │ │Alert escalation │
│complete │ │human intervention│
└─────────┘ └─────────────────┘
```

**Rollback Execution Output**:

```json
{
  "rollback_execution": {
    "rollback_id": "rollback_2024_0125_002",
    "trigger": {
      "reason": "P0 metric deterioration",
      "metric": "error_rate",
      "current_value": 0.035,
      "threshold": 0.03
    },
    "action": {
      "step_1": "Turn off Feature Flag",
      "step_2": "Wait for traffic to fully switch",
      "step_3": "Verify old version health"
    },
    "status": "completed",
    "completed_at": "ISO8601",
    "duration_seconds": 45,
    "verification": {
      "traffic_restored": true,
      "old_version_healthy": true,
      "error_rate_recovered": true
    }
  }
}
```

#### 4.3 Post-Rollback Processing

**Processing Checklist**:

```json
{
  "post_rollback_actions": [
    {
      "action": "Notify release team",
      "type": "notification",
      "recipients": ["release_lead", "dev_lead", "product_manager"]
    },
    {
      "action": "Record rollback event",
      "type": "documentation",
      "content": "Rollback reason, duration, impact scope"
    },
    {
      "action": "Create incident follow-up ticket",
      "type": "ticket",
      "template": "post_incident_review"
    },
    {
      "action": "Analyze root cause",
      "type": "analysis",
      "deadline": "Within 24 hours"
    }
  ]
}
```

## Output

**Storage path**: `docs/monitoring/release-notes.md ("Canary Plan" section)`

**Output file**: `release_status.json`

## Output Schema

For complete Schema and validation rules, see [Reference/schema.md](./Reference/schema.md)

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Release checklist change | Canary strategy and gate | Re-evaluate canary gate conditions, mark for human confirmation |
| Acceptance report change | Canary start conditions | Update canary start conditions, re-evaluate whether canary can begin |
| Monitoring metric change | Monitoring configuration and alert rules | Update monitoring metrics and alert thresholds, mark for human confirmation |
| PRD requirement change | Canary scope and feature verification | Re-evaluate canary scope, mark for human confirmation |

When the canary release itself changes, the notification mechanism for downstream:

| Canary Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Canary stage advancement | release-notes | Mark stage advancement, trigger release notes update |
| Canary rollback | All downstream | Mark rollback event, trigger troubleshooting and fix |
| Canary complete | release-notes | Mark canary complete, trigger full release decision |

---

## Decision Rules

### Auto-Rollback Rules

| Trigger Condition | Execution Action | Priority |
|----------|----------|--------|
| P0 metric exceeds rollback threshold | Immediate auto-rollback | Highest |
| Service completely unavailable | Immediate auto-rollback | Highest |
| P1 metric exceeds rollback threshold | Rollback after 5-minute delay | High |
| P2 metric exceeds rollback threshold | Alert, wait for human confirmation | Medium |

### Stage Pass Rules

| Condition | Decision |
|------|------|
| All P0 metrics normal | Can proceed to next stage |
| Stage duration met | Evaluate whether to proceed to next stage |
| P0 alert exists (not exceeding threshold) | Extend observation time |
| P1 alert exists | Warning, proceed to next stage |

## Quality Checks

### Quality Gates

| Check Item | Standard | Handling on Failure |
|--------|------|------------|
| Pre-release verification (P0) | All verification items passed | Block release |
| P0 metric stability (P0) | No metric deterioration trend | Stop canary |
| Rollback mechanism ready (P0) | Feature Flag available | Block release |
| Alert configuration correct (P1) | All metrics have alerts configured | Block release |

### Quality Checklist

- [ ] Pre-release verification all passed (P0)
- [ ] Feature Flag configuration correct (P0)
- [ ] Monitoring alerts configured (P1)
- [ ] Rollback mechanism ready (P0)
- [ ] On-call personnel confirmed (P1)
- [ ] Stage transition records complete (P2)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Release content missing | User provides release feature list → generate canary plan template | Release content details need manual supplementation |
| Feature Flag configuration missing | Generate canary plan but exclude Flag auto-configuration steps | Feature Flag needs manual configuration |
| Monitoring metrics missing | Use default P0/P1/P2 metric template, mark "to be confirmed" | Alert thresholds based on generic template |
| Release content + Feature Flag + monitoring metrics all missing | User provides release feature list → generate canary plan template | Output canary plan template, each configuration item marked "to be confirmed" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Release feature list**: Features and changes included in this release
- **Rollback version** (optional): Previous version number that can be rolled back to
- **Key monitoring metrics** (optional): Business and technical metrics requiring special attention

## Execution Log

```json
{
  "execution_id": "exec_p6_xxx",
  "pipeline": "release-gradual",
  "release_id": "release_2024_0125_001",
  "trigger": "quality_gate_passed",
  "started_at": "ISO8601",
  "completed_at": "ISO8601",
  "phases": [
    {"phase_id": "phase_1", "status": "completed", "duration_minutes": 32, "outcome": "promoted"},
    {"phase_id": "phase_2", "status": "completed", "duration_minutes": 125, "outcome": "promoted"},
    {"phase_id": "phase_3", "status": "in_progress", "duration_minutes": 45}
  ],
  "rollbacks": [],
  "final_status": {
    "outcome": "in_progress",
    "current_traffic": 50,
    "metrics_healthy": true
  }
}
```
