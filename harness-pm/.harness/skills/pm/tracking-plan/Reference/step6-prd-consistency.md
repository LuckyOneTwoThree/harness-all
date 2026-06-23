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
