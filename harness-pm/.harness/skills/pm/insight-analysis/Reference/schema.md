# Insight Analysis - Schema 定义

本文档收录 Insight Analysis Skill 的输出 JSON Schema 与各模块字段验证规则。

## Output Schema

```json
{
  "type": "object",
  "required": ["jtbd", "requirement_layers", "5whys", "kano", "priority_scoring", "metadata"],
  "properties": {
    "jtbd": {
      "type": "object",
      "required": ["jobs", "summary"],
      "properties": {
        "jobs": {"type": "array", "description": "Job list, see output validation rules → jtbd validation"},
        "summary": {"type": "object", "description": "Statistical summary, including total_jobs and by_type"}
      }
    },
    "requirement_layers": {
      "type": "object",
      "required": ["requirement_layers"],
      "properties": {
        "requirement_layers": {"type": "array", "description": "Requirement three-layer decomposition list, see output validation rules → requirement_layers validation"}
      }
    },
    "5whys": {
      "type": "object",
      "required": ["chains", "root_cause", "actionable_fix"],
      "properties": {
        "chains": {"type": "array", "description": "Causal chain list, see output validation rules → 5whys validation"},
        "root_cause": {"type": "string"},
        "actionable_fix": {"type": "object", "description": "Actionable improvement recommendation, including description/effort/impact/suggested_metrics"}
      }
    },
    "kano": {
      "type": "object",
      "required": ["kano_classification", "boundary_cases", "summary"],
      "properties": {
        "kano_classification": {"type": "array", "description": "KANO classification list, see output validation rules → kano validation"},
        "boundary_cases": {"type": "array"},
        "summary": {"type": "object"}
      }
    },
    "priority_scoring": {
      "type": "object",
      "required": ["priority_list", "scoring_summary", "priority_thresholds"],
      "properties": {
        "priority_list": {"type": "array", "description": "Priority list, see output validation rules → priority_scoring validation"},
        "scoring_summary": {"type": "object"},
        "priority_thresholds": {"type": "object"}
      }
    },
    "metadata": {"type": "object", "description": "Metadata, including version, timestamp, and source files"}
  }
}
```

## Output Validation Rules

> Type information is in the Output Schema above; the table below lists only required flags and constraints ("—" means no additional constraint).

### jtbd validation

| Field path | Required | Constraint |
|----------|------|----------|
| `jtbd.jobs` | Yes | Cannot be empty |
| `jtbd.jobs[].type` | Yes | enum: functional, emotional, social |
| `jtbd.jobs[].job` | Yes | Cannot be empty |
| `jtbd.jobs[].frequency` | Yes | — |
| `jtbd.jobs[].evidence` | Yes | Cannot be empty |
| `jtbd.jobs[].confidence` | Yes | Range 0-1.0 |
| `jtbd.jobs[].pain_with_current` | No | — |
| `jtbd.jobs[].pain_level` | No | enum: high, medium, low |
| `jtbd.summary.total_jobs` | Yes | — |
| `jtbd.summary.by_type` | Yes | — |

### requirement_layers validation

| Field path | Required | Constraint |
|----------|------|----------|
| `requirement_layers.requirement_layers` | Yes | Cannot be empty |
| `requirement_layers.requirement_layers[].id` | Yes | Unique |
| `requirement_layers.requirement_layers[].surface.content` | Yes | Preserve original wording |
| `requirement_layers.requirement_layers[].surface.confidence` | Yes | Must equal 1.0 |
| `requirement_layers.requirement_layers[].behavioral.content` | Yes | Contains scenario + behavior description |
| `requirement_layers.requirement_layers[].behavioral.confidence` | Yes | Range 0.7-0.9 |
| `requirement_layers.requirement_layers[].behavioral.inference_basis` | Yes | Cannot be empty |
| `requirement_layers.requirement_layers[].essential.content` | Yes | Describes underlying motivation |
| `requirement_layers.requirement_layers[].essential.confidence` | Yes | Range 0.4-0.7 |
| `requirement_layers.requirement_layers[].essential.inference_basis` | Yes | Cannot be empty |
| `requirement_layers.requirement_layers[].validation_needed` | Yes | Must be true when essential confidence <0.5 or behavioral confidence <0.7 |
| `requirement_layers.summary.total` | Yes | — |

### 5whys validation

| Field path | Required | Constraint |
|----------|------|----------|
| `5whys.chains` | Yes | Length ≥1 |
| `5whys.chains[].path_id` | Yes | — |
| `5whys.chains[].round` | Yes | — |
| `5whys.chains[].question` | Yes | — |
| `5whys.chains[].answer` | Yes | — |
| `5whys.chains[].evidence` | Yes | — |
| `5whys.chains[].confidence` | Yes | Range 0-1.0 |
| `5whys.chains[].data_support` | Yes | enum: high, medium, low |
| `5whys.root_cause` | Yes | Non-empty |
| `5whys.actionable_fix.description` | Yes | — |
| `5whys.actionable_fix.effort` | Yes | enum: low, medium, high |
| `5whys.actionable_fix.impact` | Yes | enum: low, medium, high |
| `5whys.actionable_fix.suggested_metrics` | Yes | — |

### kano validation

| Field path | Required | Constraint |
|----------|------|----------|
| `kano.kano_classification` | Yes | Cannot be empty |
| `kano.kano_classification[].feature_id` | Yes | — |
| `kano.kano_classification[].category` | Yes | Must be one of must-be/one-dimensional/attractive/indifferent/reverse/insufficient_data |
| `kano.kano_classification[].confidence` | Yes | Range 0-1 |
| `kano.kano_classification[].evidence` | Yes | Contains 5 metrics |
| `kano.kano_classification[].review_period` | Yes | — |
| `kano.boundary_cases` | Yes | Those with confidence <0.7 must be included |
| `kano.summary` | Yes | — |

### priority_scoring validation

| Field path | Required | Constraint |
|----------|------|----------|
| `priority_scoring.priority_list` | Yes | Cannot be empty |
| `priority_scoring.priority_list[].rank` | Yes | — |
| `priority_scoring.priority_list[].requirement_id` | Yes | — |
| `priority_scoring.priority_list[].requirement_name` | Yes | — |
| `priority_scoring.priority_list[].scores.pain_intensity.score` | Yes | Range 1-5 |
| `priority_scoring.priority_list[].scores.frequency_weight.score` | Yes | Range 1-5 |
| `priority_scoring.priority_list[].scores.solvability.score` | Yes | Range 1-5 |
| `priority_scoring.priority_list[].scores.solvability.confirmed` | Yes | — |
| `priority_scoring.priority_list[].scores.kano_coefficient.coefficient` | Yes | — |
| `priority_scoring.priority_list[].scores.kano_coefficient.category` | Yes | — |
| `priority_scoring.priority_list[].base_score` | Yes | — |
| `priority_scoring.priority_list[].kano_bonus` | Yes | — |
| `priority_scoring.priority_list[].total_score` | Yes | — |
| `priority_scoring.priority_list[].score_confidence` | Yes | enum: high, medium, low |
| `priority_scoring.scoring_summary` | Yes | — |
| `priority_scoring.priority_thresholds` | Yes | — |
