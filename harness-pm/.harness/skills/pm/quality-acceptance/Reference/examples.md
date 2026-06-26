# quality-acceptance Examples

> This document is split from the quality-acceptance SKILL.md and contains all JSON examples, templates, and report structures for acceptance execution plans and sign-off reports.

## Story Acceptance Criteria Structure Example

```json
{
  "story_id": "story_001",
  "title": "Phone verification code login",
  "build_ref": "build_2024_0125_001",
  "version": "v2.1.0",
  "acceptance_criteria": [
    {
      "id": "AC-001",
      "format": "given_when_then",
      "content": "Given the user is on the login page\nWhen the user enters a valid phone number 13800138000\nAnd clicks the get verification code button\nThen the system sends a 6-digit verification code to that phone number\nAnd the page displays a success message",
      "automatable": true,
      "priority": "P0"
    }
    // ... same structure can be extended
  ]
}
```

## Acceptance Criteria Parse Output

```json
{
  "parsed_criteria": [
    {
      "ac_id": "AC-001",
      "setup": [
        "Open the login page",
        "Confirm the page has finished loading"
      ],
      "actions": [
        "Enter phone number: 13800138000",
        "Click the get verification code button"
      ],
      "assertions": [
        "Verify the SMS sending API is called",
        "Verify a success response is returned",
        "Verify the page displays a success message"
      ],
      "priority": "P0",
      "automatable": true
    }
  ]
}
```

## Strategy Selection Rules

```json
{
  "strategy_selection": {
    "AC-001": {
      "selected_strategy": "api_automation",
      "reason": "Acceptance point is API call and response",
      "test_framework": "rest_assured",
      "script_location": "tests/api/test_login.py::test_send_verification_code"
    },
    "AC-002": {
      "selected_strategy": "e2e_automation",
      "reason": "Includes UI verification such as page navigation",
      "test_framework": "cypress",
      "script_location": "tests/e2e/test_login.py::test_verify_code_login"
    }
  }
}
```

## Test Data Preparation

```json
{
  "test_data_requirements": {
    "AC-001": {
      "phone": "13800138000",
      "type": "valid_phone",
      "source": "test_data/phones/valid.json"
    },
    "AC-002": {
      "phone": "13800138000",
      "verification_code": "123456",
      "type": "valid_code",
      "source": "generated_by_AC-001"
    }
  }
}
```

## Environment Isolation Configuration

```json
{
  "isolation_config": {
    "test_db": "test_db_isolation_enabled",
    "test_cache_prefix": "test:",
    "network_isolation": "enabled",
    "clean_strategy": "per_suite"
  }
}
```

## Mock Service Configuration Recommendations

```json
{
  "mock_config": {
    "sms_gateway": {
      "enabled": true,
      "behavior": "record_and_playback",
      "record_file": "mocks/recordings/sms_gateway.json"
    },
    "wechat_auth": {
      "enabled": true,
      "behavior": "simulate_success",
      "user_id": "mock_wechat_123"
    }
  }
}
```

## Execution Plan Generation

```json
{
  "execution_plan": {
    "total_criteria": 12,
    "parallel_groups": [
      {
        "group_id": "group_1",
        "criteria": ["AC-001", "AC-002"],
        "execution_mode": "sequential",
        "reason": "Dependency exists (AC-002 depends on AC-001 data)"
      }
      // ... same structure can be extended
    ],
    "estimated_duration_minutes": 25
  }
}
```

## Execution Engine Configuration Recommendations

```json
{
  "execution_config": {
    "runner": "pytest",
    "browsers": ["chrome", "firefox"],
    "retry_config": {
      "enabled": true,
      "max_retries": 2,
      "retry_on_failure": ["timeout", "network_error"]
    },
    "timeout_config": {
      "test_case_timeout": 120,
      "api_call_timeout": 30,
      "page_load_timeout": 60
    },
    "reporting": {
      "generate_html_report": true,
      "generate_json_report": true,
      "screenshots_on_failure": true,
      "video_recording": "on_failure"
    }
  }
}
```

## Result Aggregation

```json
{
  "result_aggregation": {
    "summary": {
      "total_criteria": 12,
      "passed": 10,
      "failed": 2,
      "skipped": 0,
      "pass_rate": 0.83
    },
    "by_priority": {
      "P0": {"total": 4, "passed": 3, "failed": 1},
      "P1": {"total": 5, "passed": 5, "failed": 0},
      "P2": {"total": 3, "passed": 2, "failed": 1}
    },
    "execution_duration_seconds": 1200,
    "automated_execution_rate": 0.92
  }
}
```

## Gate Output

```json
{
  "gate_decision": {
    "passed": false,
    "blocked_by": "P0_FAILURE",
    "blocking_items": [
      {
        "ac_id": "AC-002",
        "priority": "P0",
        "failure_reason": "Did not navigate to home page after successful login"
      }
    ],
    "release_allowed": false,
    "next_actions": [
      "Fix the defect corresponding to AC-002",
      "Re-run acceptance"
    ]
  }
}
```

## Failure Classification Output

```json
{
  "failure_analysis": [
    {
      "ac_id": "AC-002",
      "failure_type": "code_defect",
      "evidence": {
        "expected": "Page navigates to home page",
        "actual": "Page stays on login page",
        "error_message": "Navigation timeout after 30000ms",
        "screenshots": ["screenshots/ac002_failure_1.png"],
        "logs": ["logs/browser_console.log"]
      },
      "root_cause_hypothesis": "Frontend routing logic not executed correctly after successful login",
      "likely_location": "frontend/router/index.ts",
      "confidence": 0.85
    }
  ]
}
```

## Fix Suggestion Generation

```json
{
  "fix_suggestions": [
    {
      "ac_id": "AC-002",
      "fix_type": "code_fix",
      "location": "frontend/pages/login.vue",
      "line_range": "45-60",
      "suggestion": "Add router.push('/home') call in the login success callback",
      "verification_plan": "Re-run AC-002 acceptance test"
    }
  ]
}
```

## Regression Risk Assessment

```json
{
  "regression_risk": {
    "scope": "limited",
    "affected_stories": ["story_002", "story_003"],
    "risk_level": "medium",
    "reason": "Login module changes may affect user registration flow",
    "recommendations": [
      "Recommend running regression tests for story_002 and story_003",
      "Recommend running login-related E2E test suite"
    ]
  }
}
```

## Acceptance Conclusion Template

```
Acceptance Conclusion: ✅ Pass / ⚠️ Conditional Pass / ❌ Fail

Acceptance Scope: {version number} {functional scope}
Acceptance Date: {date}
Acceptance Party: {acceptance party}

Passed Items: {N} items ({X}%)
Failed Items: {N} items ({X}%)
Must Requirement Pass Rate: {X}%

Open Issues: {N}
- Fatal/Critical: {N}
- General/Minor: {N}

Acceptance Recommendation:
{specific recommendation}
```

## Report Structure

```
# {Product Name} v{Version} Acceptance Test Report

## 1. Acceptance Overview
### 1.1 Acceptance Scope
### 1.2 Acceptance Criteria
### 1.3 Acceptance Environment

## 2. Acceptance Execution Plan
### 2.1 Acceptance Criteria Parsing
### 2.2 Test Environment Configuration Recommendations
### 2.3 Execution Instructions and Decision Rules
### 2.4 Gate Decision

## 3. Test Result Summary
### 3.1 Overall Statistics
### 3.2 Acceptance Criteria Item-by-Item Results
### 3.3 Test Coverage

## 4. Defect Analysis
### 4.1 Defect Statistics
### 4.2 Defect List
### 4.3 Defect Trends

## 5. Open Issues
### 5.1 Open Issue List
### 5.2 Open Issue Risk Assessment
### 5.3 Handling Plan

## 6. Acceptance Conclusion
### 6.1 Conclusion
### 6.2 Open Issue Handling Plan
### 6.3 Sign-off Confirmation

## Appendix
- Test case details
- Test environment configuration
- Complete acceptance criteria list
- Failed case analysis details
```

## Execution Log Example

```json
{
  "execution_id": "exec_p5_xxx",
  "pipeline": "quality-acceptance",
  "story_id": "story_001",
  "trigger": "story_completed",
  "started_at": "ISO8601",
  "completed_at": "ISO8601",
  "steps": [
    {"step": "criteria_parsing", "status": "completed", "duration_ms": 200}
    // ... same structure can be extended
  ],
  "gate_decision": {
    "passed": false,
    "reason": "P0_FAILURE"
  },
  "notifications_sent": ["dev_lead", "product_manager"]
}
```
