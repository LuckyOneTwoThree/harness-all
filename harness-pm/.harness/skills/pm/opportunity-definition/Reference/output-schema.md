# Opportunity Definition - Schema 定义

本文档收录 Opportunity Definition Skill 的输出 JSON Schema 与各模块字段验证规则。

## Output Schema

```json
{
  "type": "object",
  "required": ["scoring", "problem_statement", "hmw", "brief", "metadata"],
  "properties": {
    "scoring": {
      "type": "object",
      "required": ["opportunities", "metadata"],
      "properties": {
        "opportunities": {"type": "array", "description": "Opportunity scoring list, see output validation rules → scoring validation"},
        "metadata": {"type": "object", "description": "Scoring metadata, including awaiting_human_input"}
      }
    },
    "problem_statement": {
      "type": "object",
      "required": ["problem_statement", "data_support", "template_elements", "quality_check"],
      "properties": {
        "problem_statement": {"type": "string", "description": "Complete Problem Statement text"},
        "data_support": {"type": "object", "description": "Data support, see output validation rules → problem_statement validation"},
        "template_elements": {"type": "object", "description": "Template 6 elements"},
        "quality_check": {"type": "object", "description": "5 quality check results"}
      }
    },
    "hmw": {
      "type": "object",
      "required": ["hmw_statements", "dimension_coverage"],
      "properties": {
        "hmw_statements": {"type": "array", "description": "HMW statement list, see output validation rules → hmw validation"},
        "dimension_coverage": {"type": "object", "description": "4-dimension coverage statistics"}
      }
    },
    "brief": {
      "type": "object",
      "required": ["title", "problem_statement", "evidence_summary", "opportunity_score", "hmw_statements", "key_assumptions", "recommended_next_step", "human_decisions_needed"],
      "properties": {
        "title": {"type": "string"},
        "evidence_summary": {"type": "object", "description": "3 types of evidence summary, see output validation rules → brief validation"},
        "key_assumptions": {"type": "array", "description": "Key assumption list, see output validation rules → brief validation"},
        "human_decisions_needed": {"type": "array", "description": "Human decision items list"}
      }
    },
    "metadata": {"type": "object", "description": "Metadata, including version, timestamp, and source files"}
  }
}
```

## Output Validation Rules

### scoring validation

| Field path | Type | Required | Description |
|----------|------|------|------|
| `scoring.opportunities` | array | Yes | Opportunity scoring list, cannot be an empty array |
| `scoring.opportunities[].name` | string | Yes | Opportunity name, cannot be an empty string |
| `scoring.opportunities[].scores.{dimension}.score` | number\|null | Yes | Dimension score 1-5, must be null when pending human judgment |
| `scoring.opportunities[].scores.{dimension}.weight` | number | Yes | Dimension weight, the sum of 5 dimension weights must equal 1.00 |
| `scoring.opportunities[].scores.{dimension}.evidence` | string | Yes | Scoring basis, cannot be an empty string |
| `scoring.opportunities[].scores.{dimension}.needs_human` | boolean | Yes | Whether human judgment is needed, strategic_fit dimension must be true |
| `scoring.opportunities[].weighted_total` | number\|null | Yes | Weighted total score, must be null when any dimension score is null |
| `scoring.metadata.awaiting_human_input` | boolean | Yes | Whether there is pending human input, must be true when strategic_fit is not scored |

### problem_statement validation

| Field path | Type | Required | Description |
|----------|------|------|------|
| `problem_statement.problem_statement` | string | Yes | Complete Problem Statement text, cannot be empty and cannot contain specific solutions |
| `problem_statement.data_support.pain_point_frequency` | string | Yes | Pain point mention rate, cannot be empty |
| `problem_statement.data_support.behavioral_evidence` | string | Yes | Behavior data corroboration, cannot be empty |
| `problem_statement.data_support.confidence` | number | Yes | Confidence 0-1, escalate to human review when below 0.5 |
| `problem_statement.template_elements.target_user` | string | Yes | Target user group, cannot use generic terms |
| `problem_statement.template_elements.scenario` | string | Yes | Specific scenario, cannot be a vague description |
| `problem_statement.template_elements.task` | string | Yes | Task the user needs to complete, cannot be empty |
| `problem_statement.template_elements.core_pain` | string | Yes | Core pain point, cannot be empty |
| `problem_statement.template_elements.current_gap` | string | Yes | Shortcomings of existing solutions, must point out 1 or more specific shortcomings |
| `problem_statement.template_elements.expected_benefit` | string | Yes | Expected benefit, must be quantifiable or verifiable |
| `problem_statement.quality_check.all_passed` | boolean | Yes | Whether all 5 quality checks passed |
| `problem_statement.quality_check.retry_count` | number | Yes | Retry count, max value is 3 |

### hmw validation

| Field path | Type | Required | Description |
|----------|------|------|------|
| `hmw.hmw_statements` | array | Yes | HMW statement list, count must be in the 8-12 range |
| `hmw.hmw_statements[].id` | string | Yes | HMW unique identifier, format hmw-NNN |
| `hmw.hmw_statements[].statement` | string | Yes | HMW statement text, cannot be empty and cannot contain specific solutions |
| `hmw.hmw_statements[].dimension` | string | Yes | Associated dimension, must be one of eliminate_barriers/enhance_experience/create_value/redefine |
| `hmw.hmw_statements[].problem_ref` | string | Yes | Linked Problem Statement field reference, cannot be empty |
| `hmw.hmw_statements[].data_source` | string | Yes | Data source reference, cannot be empty |
| `hmw.hmw_statements[].innovation_space` | number | Yes | Innovation space score 1-5, ≥4 requires key human review |
| `hmw.hmw_statements[].confidence` | number | Yes | Confidence 0-1 |
| `hmw.dimension_coverage` | object | Yes | All 4 dimensions must appear with value ≥1 |
| `hmw.dimension_coverage.eliminate_barriers` | number | Yes | Eliminate barriers dimension HMW count, ≥2 |
| `hmw.dimension_coverage.enhance_experience` | number | Yes | Enhance experience dimension HMW count, ≥2 |
| `hmw.dimension_coverage.create_value` | number | Yes | Create new value dimension HMW count, ≥2 |
| `hmw.dimension_coverage.redefine` | number | Yes | Redefine dimension HMW count, ≥2 |

### brief validation

| Field path | Type | Required | Description |
|----------|------|------|------|
| `brief.title` | string | Yes | Opportunity brief title, format [Target user group]-[Core pain point summary] |
| `brief.problem_statement` | string | Yes | Structured problem statement, cannot be empty |
| `brief.evidence_summary.user_research` | object | Yes | User research evidence, must include pain point frequency and behavior corroboration |
| `brief.evidence_summary.market_analysis` | object | Yes | Market analysis evidence, must include SOM estimate |
| `brief.evidence_summary.competitive_landscape` | object | Yes | Competitive landscape evidence, must include market gap analysis |
| `brief.opportunity_score.weighted_total` | number | Yes | Weighted total score, cannot be null (requires human to have completed strategic fit scoring) |
| `brief.hmw_statements` | array | Yes | HMW statement list, cannot be an empty array |
| `brief.key_assumptions` | array | Yes | Key assumption list, cannot be an empty array |
| `brief.key_assumptions[].assumption` | string | Yes | Assumption description, cannot be empty |
| `brief.key_assumptions[].type` | string | Yes | Assumption type, must be one of desirability/viability/feasibility/usability |
| `brief.key_assumptions[].testability` | string | Yes | Testability description, cannot be empty |
| `brief.key_assumptions[].risk_if_wrong` | string | Yes | Risk level, must be one of high/medium/low |
| `brief.recommended_next_step` | string | Yes | Recommended next step, must be based on scoring and assumption risk analysis |
| `brief.human_decisions_needed` | array | Yes | Human decision items list, high-risk assumptions must have a corresponding decision item |
| `brief.human_decisions_needed[].item` | string | Yes | Decision item, cannot be empty |
| `brief.human_decisions_needed[].context` | string | Yes | Decision context, cannot be empty |
| `brief.human_decisions_needed[].urgency` | string | Yes | Urgency, must be one of high/medium/low |
