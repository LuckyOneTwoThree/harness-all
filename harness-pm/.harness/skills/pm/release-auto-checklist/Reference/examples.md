# release-auto-checklist Examples

> This document is split from the release-auto-checklist SKILL.md and contains all JSON examples for inputs, phase checklists, check execution, alerts, status tracking, and execution logs.

## Release Content Structure Example

```json
{
  "release_id": "release_2024_0125_001",
  "version": "v2.1.0",
  "release_time": "2024-01-25T14:00:00Z",
  "affected_services": ["auth-service", "user-service"],
  "change_type": "feature_release",
  "release_lead": "dev_zhang",
  "developers": ["dev_wang", "dev_li"],
  "testers": ["qa_chen"],
  "on_call": "ops_wu"
}
```

## Checklist Template Structure

```json
{
  "templates": {
    "T-7": {
      "template_id": "checklist_T-7",
      "title": "7 days before release - Preparation check",
      "items": [
        {
          "item_id": "C001",
          "category": "documentation",
          "title": "Update change log",
          "description": "Ensure change log includes all changes for this release",
          "type": "manual",
          "owner_role": "developer",
          "priority": "P0"
        }
      ]
    },
    "T-1": {...},
    "T-0": {...},
    "T+24h": {...},
    "T+72h": {...}
  }
}
```

## Personalized Output

```json
{
  "personalized_checklist": {
    "generated_from": "standard_template_v2",
    "customizations": [
      {"item_id": "C015", "added": true, "reason": "Involves auth-service requiring extra security check"},
      {"item_id": "C020", "removed": true, "reason": "This release does not involve database changes"}
    ],
    "release_specific_items": [
      {
        "item_id": "C_RS_001",
        "title": "WeChat login feature specific check",
        "category": "feature_specific",
        "description": "Check the end-to-end flow of WeChat login",
        "priority": "P0"
      }
    ]
  }
}
```

## T-7 Checklist Example

```json
{
  "T-7_checklist": {
    "phase": "T-7",
    "release_date": "2024-01-25",
    "items": [
      {
        "item_id": "T7_C001",
        "category": "documentation",
        "title": "Release change log completed",
        "description": "Record all feature changes, Bug fixes, and breaking changes in CHANGELOG",
        "type": "manual",
        "owner": "dev_wang",
        "priority": "P0",
        "auto_check_config": {
          "enabled": false
        }
      },
      {
        "item_id": "T7_C002",
        "category": "code_quality",
        "title": "Code passed static analysis",
        "description": "Run SonarQube scan, ensure no Blocker/Critical issues",
        "type": "auto",
        "owner": "ci_system",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "sonarqube",
          "pass_condition": "no_blocker_or_critical"
        }
      },
      {
        "item_id": "T7_C003",
        "category": "test",
        "title": "All automated tests passed",
        "description": "All test cases in CI pipeline have passed",
        "type": "auto",
        "owner": "ci_system",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "ci_pipeline",
          "pass_condition": "all_tests_passed"
        }
      }
    ]
  }
}
```

## T-1 Checklist Example

```json
{
  "T-1_checklist": {
    "phase": "T-1",
    "items": [
      {
        "item_id": "T1_C001",
        "category": "release_ready",
        "title": "Rollback version deployed and verified",
        "description": "Confirm rollback version (v2.0.9) running normally in production",
        "type": "manual",
        "owner": "ops_wu",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "health_check",
          "check_endpoint": "/health",
          "pass_condition": "status_200"
        }
      },
      {
        "item_id": "T1_C002",
        "category": "communication",
        "title": "Release notification sent",
        "description": "Send release notification to all relevant teams, including release time and impact",
        "type": "manual",
        "owner": "dev_zhang",
        "priority": "P1",
        "auto_check_config": {
          "enabled": false
        }
      },
      {
        "item_id": "T1_C003",
        "category": "monitoring",
        "title": "Monitoring dashboard ready",
        "description": "Confirm monitoring dashboards for release-related services display normally",
        "type": "manual",
        "owner": "ops_wu",
        "priority": "P1",
        "auto_check_config": {
          "enabled": true,
          "check_type": "dashboard_access",
          "pass_condition": "accessible"
        }
      }
    ]
  }
}
```

## T-0 Checklist (During Release) Example

```json
{
  "T-0_checklist": {
    "phase": "T-0",
    "items": [
      {
        "item_id": "T0_C001",
        "category": "pre_release",
        "title": "Release window normal",
        "description": "Current time is within weekday 10:00-16:00 release window",
        "type": "auto",
        "owner": "system",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "time_window",
          "pass_condition": "within_window"
        }
      },
      {
        "item_id": "T0_C002",
        "category": "release_execution",
        "title": "Build artifact verification passed",
        "description": "Verify SHA256 checksum of build artifacts",
        "type": "auto",
        "owner": "ci_system",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "artifact_verification",
          "pass_condition": "checksum_match"
        }
      },
      {
        "item_id": "T0_C003",
        "category": "release_execution",
        "title": "Feature Flag configured",
        "description": "Canary release Flag configured with initial value (1%)",
        "type": "auto",
        "owner": "release_system",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "feature_flag",
          "pass_condition": "configured"
        }
      },
      {
        "item_id": "T0_C004",
        "category": "post_release",
        "title": "Service health check passed",
        "description": "All affected services passed health check",
        "type": "auto",
        "owner": "monitoring_system",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "service_health",
          "pass_condition": "all_healthy"
        }
      }
    ]
  }
}
```

## T+24h Checklist Example

```json
{
  "T+24h_checklist": {
    "phase": "T+24h",
    "items": [
      {
        "item_id": "T24_C001",
        "category": "stability",
        "title": "Core metrics normal",
        "description": "Error rate, response time, availability and other P0 metrics normal",
        "type": "auto",
        "owner": "monitoring_system",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "metrics_check",
          "metrics": ["error_rate", "latency_p99", "availability"],
          "pass_condition": "all_normal"
        }
      },
      {
        "item_id": "T24_C002",
        "category": "stability",
        "title": "No P0/P1 level alerts",
        "description": "No P0/P1 level alerts in the past 24 hours",
        "type": "auto",
        "owner": "monitoring_system",
        "priority": "P0",
        "auto_check_config": {
          "enabled": true,
          "check_type": "alert_check",
          "pass_condition": "no_p0_p1_alerts"
        }
      },
      {
        "item_id": "T24_C003",
        "category": "user_feedback",
        "title": "User feedback normal",
        "description": "Customer support tickets and user feedback not abnormally increased",
        "type": "manual",
        "owner": "product_manager_zhang",
        "priority": "P1",
        "auto_check_config": {
          "enabled": false
        }
      }
    ]
  }
}
```

## T+72h Checklist Example

```json
{
  "T+72h_checklist": {
    "phase": "T+72h",
    "items": [
      {
        "item_id": "T72_C001",
        "category": "effectiveness",
        "title": "Business metrics achieved",
        "description": "Core business metrics (conversion rate, DAU, etc.) meet expectations",
        "type": "manual",
        "owner": "product_manager_zhang",
        "priority": "P0",
        "auto_check_config": {
          "enabled": false
        }
      },
      {
        "item_id": "T72_C002",
        "category": "technical",
        "title": "No technical debt increase",
        "description": "Code quality metrics not degraded",
        "type": "auto",
        "owner": "ci_system",
        "priority": "P1",
        "auto_check_config": {
          "enabled": true,
          "check_type": "code_quality_trend",
          "pass_condition": "no_degradation"
        }
      }
    ]
  }
}
```

## Check Execution Configuration

```json
{
  "check_execution": {
    "execution_mode": "sequential",
    "parallel_execution": true,
    "timeout_seconds": 60,
    "retry_config": {
      "enabled": true,
      "max_retries": 2,
      "retry_delay_seconds": 10
    }
  }
}
```

## Check Result Output Example

```json
{
  "check_results": [
    {
      "item_id": "T7_C002",
      "check_type": "sonarqube",
      "status": "passed",
      "checked_at": "ISO8601",
      "details": {
        "blocker_issues": 0,
        "critical_issues": 0,
        "major_issues": 5
      },
      "evidence": "sonarqube_scan_2024_0125.json"
    },
    {
      "item_id": "T1_C001",
      "check_type": "health_check",
      "status": "passed",
      "checked_at": "ISO8601",
      "details": {
        "endpoint": "https://api.example.com/health",
        "response_time_ms": 45,
        "status_code": 200
      }
    }
  ]
}
```

## Alert Output Example

```json
{
  "pending_alerts": [
    {
      "alert_id": "alert_001",
      "severity": "high",
      "item_id": "T-1_C002",
      "title": "Release notification not sent",
      "owner": "dev_zhang",
      "deadline": "2024-01-24T12:00:00Z",
      "time_remaining": "3 hours",
      "notification_channels": ["slack", "email"]
    }
  ]
}
```

## Status Report Example

```json
{
  "checklist_status": {
    "phase": "T-1",
    "generated_at": "ISO8601",
    "summary": {
      "total_items": 20,
      "completed": 15,
      "pending": 3,
      "blocked": 2,
      "completion_rate": 0.75
    },
    "by_priority": {
      "P0": {"total": 8, "completed": 7, "pending": 1},
      "P1": {"total": 8, "completed": 6, "pending": 2},
      "P2": {"total": 4, "completed": 2, "pending": 2}
    },
    "by_category": {
      "documentation": {"completed": 2, "pending": 0},
      "test": {"completed": 3, "pending": 1},
      "release_ready": {"completed": 4, "pending": 1}
    }
  }
}
```

## Progress Visualization Example

```json
{
  "progress_visualization": {
    "timeline": [
      {"phase": "T-7", "completion_rate": 1.0, "status": "completed"},
      {"phase": "T-1", "completion_rate": 0.75, "status": "in_progress"},
      {"phase": "T-0", "completion_rate": 0.0, "status": "pending"},
      {"phase": "T+24h", "completion_rate": 0.0, "status": "pending"},
      {"phase": "T+72h", "completion_rate": 0.0, "status": "pending"}
    ],
    "risk_indicators": [
      {"indicator": "P0 blocking items", "count": 1, "severity": "high"}
    ]
  }
}
```

## Execution Log Example

```json
{
  "execution_id": "exec_p7_xxx",
  "pipeline": "release-auto-checklist",
  "release_id": "release_2024_0125_001",
  "trigger": "scheduled",
  "execution_type": "full_check",
  "started_at": "ISO8601",
  "completed_at": "ISO8601",
  "phases_processed": ["T-7", "T-1"],
  "items_checked": 25,
  "items_passed": 23,
  "items_failed": 0,
  "pending_items": 2,
  "alerts_generated": 2
}
```
