# release-gradual Examples

> This document is split from the release-gradual SKILL.md and contains all JSON examples and flow diagrams for canary release execution.

## Release Content Structure Example

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

## Guardrail Metrics Configuration

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

## Pre-Release Verification Output

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

## Canary Plan Generation

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

## Feature Flag Configuration

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

## Flag Status Tracking

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

## Metrics Collection Configuration

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

## Stage Assessment Output

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

## Stage Transition Decision Flow

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

## Phase Transition Output

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

## Rollback Flow

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

## Rollback Execution Output

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

## Post-Rollback Processing Checklist

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

## Execution Log Example

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
