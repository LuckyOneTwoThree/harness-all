# Output Validation Rules and Complete Assessment Report

> Extracted from SKILL.md. Field validation rules and complete assessment report JSON example for value proposition fit assessment.

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| evaluation_report.evaluation_metadata.evaluated_at | string | Yes | Assessment timestamp |
| evaluation_report.evaluation_metadata.value_propositions_evaluated | number | Yes | Number of value propositions evaluated |
| evaluation_report.evaluation_metadata.pains_analyzed | number | Yes | Number of pains analyzed |
| evaluation_report.evaluation_metadata.gains_analyzed | number | Yes | Number of gains analyzed |
| evaluation_report.evaluation_metadata.confidence | string | Yes | high/medium/low |
| evaluation_report.pain_alignment.covered_pains | array | Yes | Covered pains list |
| evaluation_report.pain_alignment.covered_pains[].pain_id | string | Yes | Pain ID, cannot be empty |
| evaluation_report.pain_alignment.covered_pains[].coverage_score | number | Yes | Coverage score, 0-5 |
| evaluation_report.pain_alignment.covered_pains[].coverage_quality | string | Yes | Coverage quality, enum: full/partial/edge/none |
| evaluation_report.pain_alignment.uncovered_pains | array | Yes | Uncovered pains list, each item includes recommendation |
| evaluation_report.pain_alignment.uncovered_pains[].pain_id | string | Yes | Pain ID, cannot be empty |
| evaluation_report.pain_alignment.uncovered_pains[].frequency | string | Yes | Occurrence frequency, enum: high/medium/low |
| evaluation_report.pain_alignment.uncovered_pains[].severity | string | Yes | Severity, enum: high/medium/low |
| evaluation_report.pain_alignment.uncovered_pains[].recommendation | string | Yes | Improvement recommendation, cannot be empty |
| evaluation_report.pain_alignment.pain_coverage_summary | object | Yes | Coverage rate statistics |
| evaluation_report.pain_alignment.pain_coverage_summary.total_pains | number | Yes | Total pains |
| evaluation_report.pain_alignment.pain_coverage_summary.fully_covered | number | Yes | Fully covered count |
| evaluation_report.pain_alignment.pain_coverage_summary.uncovered | number | Yes | Uncovered count |
| evaluation_report.gain_validation.covered_gains | array | Yes | Covered gains list |
| evaluation_report.gain_validation.covered_gains[].gain_id | string | Yes | Gain ID, cannot be empty |
| evaluation_report.gain_validation.covered_gains[].coverage_status | string | Yes | Coverage status, enum: covered/partial/not_covered |
| evaluation_report.gain_validation.covered_gains[].realizability | string | Yes | Feasibility, enum: high/medium/low |
| evaluation_report.gain_validation.uncovered_gains | array | Yes | Uncovered gains list, each item includes recommendation |
| evaluation_report.gain_validation.uncovered_gains[].gain_id | string | Yes | Gain ID, cannot be empty |
| evaluation_report.gain_validation.uncovered_gains[].importance | string | Yes | Importance, enum: high/medium/low |
| evaluation_report.gain_validation.uncovered_gains[].recommendation | string | Yes | Improvement recommendation, cannot be empty |
| evaluation_report.overall_fit_score | number | Yes | Overall fit score 0-5 |
| evaluation_report.coverage_rate | object | Yes | Coverage rate metrics |
| evaluation_report.improvement_suggestions | array | Yes | Improvement suggestions list |
| evaluation_report.improvement_suggestions[].priority | string | Yes | Priority, enum: high/medium/low |
| evaluation_report.improvement_suggestions[].category | string | Yes | Suggestion category, enum: add_pain_coverage/enhance_gain/clarify_message/reposition |
| evaluation_report.improvement_suggestions[].description | string | Yes | Suggestion description, cannot be empty |
| evaluation_report.warnings | array | Yes | Warnings list |
| evaluation_report.warnings[].warning_type | string | Yes | Warning type, e.g. high_frequency_uncovered |
| evaluation_report.warnings[].description | string | Yes | Warning description, cannot be empty |
| evaluation_report.warnings[].severity | string | Yes | Severity, enum: high/medium/low |

## Complete Assessment Report

```json
{
  "evaluation_report": {
    "evaluation_metadata": {
      "evaluated_at": "2024-06-15T14:20:00Z",
      "value_propositions_evaluated": 3,
      "pains_analyzed": 10,
      "gains_analyzed": 8,
      "confidence": "high/medium/low"
    },
    "pain_alignment": {...},
    "gain_validation": {...},
    "overall_fit_score": {...},
    "coverage_rate": {...},
    "improvement_suggestions": [
      {
        "suggestion_id": "sug-1",
        "priority": "high/medium/low",
        "category": "add_pain_coverage/enhance_gain/clarify_message/reposition",
        "description": "Add AI learning path effectiveness visualization feature to cover learner progress tracking pain",
        "expected_impact": "Pain coverage rate increased by 15%, fit score increased by 0.5 points",
        "implementation_effort": "Medium, requires 2 Sprint development cycles"
      }
    ],
    "warnings": [
      {
        "warning_type": "high_frequency_uncovered",
        "description": "High-frequency pain 'training effectiveness hard to quantify' not covered by value proposition",
        "affected_pains": ["pain-3", "pain-7"],
        "severity": "high"
      }
    ]
  }
}
```
