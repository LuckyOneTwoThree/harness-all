# Steps: Quality (Validation & Consistency Logic)

Merged reference material for tracking-plan Steps 4 and 6 (tracking quality check rules, PRD consistency validation). Provenance is preserved per source file below.

---

## Source: step4-quality-checks.md

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

---

## Source: step6-prd-consistency.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 6: PRD Tracking Plan Consistency Validation

> Source: All content from 6.1 to 6.4 in SKILL.md "Step 6: PRD Tracking Plan Consistency Validation"

## 6.1 Bidirectional Validation Mechanism [Conditional]

**Forward validation**: PRD features → Tracking coverage

```
FOR each functional_requirement in PRD:
  1. Identify the tracking corresponding to this feature
  2. IF tracking is missing THEN mark as uncovered
  3. Calculate the forward coverage rate
```

**Backward validation**: Tracking → PRD features

```
FOR each tracking_event:
  1. Identify the feature analysis supported by this tracking
  2. IF the feature is not in the PRD THEN mark as extra tracking
  3. Calculate the backward coverage rate
```

---

## 6.2 PRD Feature Extraction [Conditional]

**Feature types**:

| Feature Type | Identification Keywords | Tracking Requirement |
|---------|-----------|---------|
| Page | page, module, tab | page_view + page properties |
| Button | click, press, trigger | button_click + button properties |
| Form | fill, input, submit | input + form_submit |
| List | list, browse, paginate | list_view + item_click |
| Detail | detail, view, content | detail_view + detail properties |
| Flow | flow, step, complete | flow_start + flow_complete |
| Exception | failure, error, timeout | error + error details |

---

## 6.3 Consistency Scoring [Conditional]

**Scoring rules**:

```python
def calculate_prd_consistency_score():
    forward_coverage = calculate_forward_coverage()  # PRD → tracking
    backward_coverage = calculate_backward_coverage()  # tracking → PRD

    consistency_score = (
        0.6 * forward_coverage +  # Forward weight 60%
        0.4 * backward_coverage   # Backward weight 40%
    )

    return {
        "forward_coverage": forward_coverage,
        "backward_coverage": backward_coverage,
        "consistency_score": consistency_score,
        "status": "pass" if consistency_score >= 0.9 else "fail"
    }
```

---

## 6.4 Continuous Validation Mechanism [Deep]

**Trigger timing**:

| Trigger Type | Trigger Condition | Validation Content |
|---------|---------|---------|
| PRD change trigger | PRD document updated | Whether new features are tracked |
| Tracking change trigger | Tracking plan updated | Whether the change affects PRD coverage |
| Periodic validation | Weekly/Monthly | Full consistency check |
| Pre-release validation | Before release | Targeted validation of changed portions |

**Validation output**:

```json
{
  "prd_consistency": {
    "forward_coverage": 0.92,
    "backward_coverage": 0.88,
    "consistency_score": 0.90,
    "status": "pass",
    "discrepancies": [
      {
        "type": "uncovered_function",
        "description": "Product sharing feature has no tracking configured",
        "prd_reference": "PRD section 3.2",
        "severity": "high",
        "suggested_event": "product_share"
      }
    ]
  }
}
```
