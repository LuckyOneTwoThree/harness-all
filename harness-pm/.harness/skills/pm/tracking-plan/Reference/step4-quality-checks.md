<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 4: Tracking Quality Check Rules and Output

> Source: All quality check rules and outputs from 4.1 to 4.5 in SKILL.md "Step 4: Tracking Quality Check"

## 4.1 Naming Specification Check [Core]

**Naming rules**:

```
Event naming: All lowercase + underscore separated
  Example: user_login_success, product_add_to_cart

Property naming: All lowercase + underscore separated
  Example: user_id, product_price, page_name
```

**Check items**:

| Check Item | Rule | Pass Condition |
|-------|------|---------|
| Letter specification | Only a-z, 0-9, underscores allowed | No uppercase letters, no special characters |
| Separator specification | Use underscores to separate semantic units | Not camelCase, not hyphenated |
| Completeness | Contains subject_action_object | At least 3 semantic units |
| No abbreviations | Avoid non-standard abbreviations | Common abbreviations must be defined in the specification |

**Check output**:

```json
{
  "naming_check": {
    "total_events": 100,
    "passed": 95,
    "failed": 5,
    "issues": [
      {
        "event_name": "UserLoginSuccess",
        "issue": "Contains uppercase letters",
        "suggestion": "user_login_success"
      }
    ]
  }
}
```

---

## 4.2 Property Completeness Check [Core]

**Core property definitions**:

| Property Type | Property Name | Required | Description |
|---------|-------|------|------|
| Common property | user_id | Yes | User unique identifier |
| Common property | session_id | Yes | Session unique identifier |
| Common property | timestamp | Yes | Event occurrence time |
| Common property | platform | Yes | Platform type |
| Common property | app_version | Yes | App version number |
| Page property | page_name | Yes | Page name |
| Page property | page_url | Yes | Page URL |
| Device property | device_type | Yes | Device type |
| Device property | os_version | Yes | Operating system version |

**Check rules**:

```
FOR each event:
  1. Verify that core common properties are complete
  2. Verify required properties for specific event types
  3. Calculate the property completeness rate
  4. IF completeness rate < 80% THEN mark as failed
```

**Check output**:

```json
{
  "completeness_check": {
    "total_events": 100,
    "core_attributes_coverage": 0.95,
    "events_with_full_attributes": 92,
    "events_needing_review": [
      {
        "event_name": "product_view",
        "missing_attributes": ["product_category", "source_page"],
        "completeness_rate": 0.70
      }
    ]
  }
}
```

---

## 4.3 Core Path Coverage Check [Conditional]

**Core path definition**:

```
Based on the metric system and PRD, define the core user paths that must be covered
```

**Coverage requirement**:

```
Core path coverage rate ≥ 90%
```

**Check logic**:

```python
def check_core_path_coverage():
    core_paths = get_core_paths_from_prd()
    covered_paths = get_covered_paths_from_tracking()

    coverage_rate = len(covered_paths & core_paths) / len(core_paths)

    return {
        "total_core_paths": len(core_paths),
        "covered_paths": len(covered_paths & core_paths),
        "uncovered_paths": core_paths - covered_paths,
        "coverage_rate": coverage_rate,
        "pass": coverage_rate >= 0.9
    }
```

**Check output**:

```json
{
  "core_path_coverage": {
    "total_paths": 10,
    "covered": 9,
    "uncovered": ["path_to_checkout"],
    "coverage_rate": 0.90,
    "status": "pass"
  }
}
```

---

## 4.4 Exception State Coverage Check [Deep]

**Exception state definitions**:

| Exception Type | Exception Scenario | Tracking Requirement |
|---------|---------|---------|
| Loading exception | Page/API loading failure | error_view, api_error |
| Form exception | Form validation failure, submission failure | form_error, submit_failed |
| Payment exception | Payment failure, cancelled payment | payment_failed, payment_cancelled |
| Permission exception | No permission to access | permission_denied |
| Network exception | Disconnected, timeout | network_error, timeout |

**Check rules**:

```
FOR each core_flow:
  1. Identify exception branches in the flow
  2. Check whether corresponding exception tracking exists
  3. IF exception scenario has no tracking THEN add a warning
```

**Check output**:

```json
{
  "anomaly_coverage": {
    "total_anomaly_scenarios": 15,
    "covered_scenarios": 14,
    "missing_scenarios": [
      {
        "scenario": "Empty search results",
        "flow": "search",
        "suggested_event": "search_no_result"
      }
    ],
    "coverage_rate": 0.93
  }
}
```

---

## 4.5 Redundancy Detection [Deep]

**Redundancy rules**:

```
IF any of the following conditions exists THEN mark as redundant tracking:
  - Two events collect exactly the same data
  - Parent-child event data overlaps (parent event already includes child event data)
  - Events with identical statistical definitions are duplicated
```

**Detection output**:

```json
{
  "redundancy_check": {
    "duplicates": [
      {
        "event_a": "page_view",
        "event_b": "screen_show",
        "reason": "Both collect the same data (page exposure)",
        "recommendation": "Keep page_view, remove screen_show"
      }
    ],
    "total_redundant": 1
  }
}
```
