# Usability Testing - Output Validation Rules

Field-level schema and validation rules for the `usability_report.json` output of the `validation-usability` skill.

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| usability_report | object | Yes | Usability test report |
| usability_report.test_summary | object | Yes | Test summary |
| usability_report.test_summary.participant_count | integer | Yes | Number of participants |
| usability_report.test_summary.test_goals | array | Yes | Test goals list |
| usability_report.problems | array | Yes | Problems list |
| usability_report.problems[].problem_id | string | Yes | Problem unique identifier |
| usability_report.problems[].severity | string | Yes | Severity (P0/P1/P2/P3) |
| usability_report.problems[].frequency | string | Yes | Occurrence frequency |
| usability_report.problems[].affected_element | string | Yes | Affected element |
| usability_report.problems[].description | string | Yes | Problem description |
| usability_report.insights | array | Yes | Insights list |
| usability_report.insights[].type | string | Yes | Insight type |
| usability_report.improvement_suggestions | array | Yes | Improvement suggestions list |
| usability_report.improvement_suggestions[].suggestion | string | Yes | Suggestion content |
| usability_report.improvement_suggestions[].priority | string | Yes | Priority |
| usability_report.improvement_suggestions[].problem_ref | string | Yes | Linked problem ID |
