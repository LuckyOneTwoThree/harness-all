# Interview Script (interview-script.json) - Schema and Example

> Extracted from SKILL.md. Output schema, validation rules, and JSON example for interview-script.json.

## Output Schema

```json
{
  "type": "object",
  "required": ["script_id", "research_objectives", "core_modules"],
  "properties": {
    "script_id": {"type": "string", "description": "Unique interview script identifier"},
    "research_objectives": {"type": "array", "description": "Research objective list"},
    "target_personas": {"type": "array", "description": "Target Persona type list"},
    "opening": {"type": "object", "description": "Opening module, includes icebreaker questions and context setting"},
    "core_modules": {"type": "array", "description": "Core question module list"},
    "closing": {"type": "object", "description": "Closing module"},
    "recommended_participants": {"type": "array", "description": "Recommended interview subject list"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| script_id | string | Yes | Unique script identifier |
| research_objectives | string[] | Yes | Research objective list, cannot be empty |
| target_personas | string[] | No | Target Persona type list |
| opening.icebreaker_questions | string[] | Yes | Icebreaker question list |
| opening.context_setting | string | Yes | Context setting description |
| core_modules | array | Yes | Core question module list, cannot be empty |
| core_modules[].module_name | string | Yes | Module name |
| core_modules[].objective | string | Yes | Module objective |
| core_modules[].hypothesis_to_validate | string | Yes | Hypothesis to validate |
| core_modules[].priority | string | Yes | Priority enum: must_validate/should_validate/optional |
| core_modules[].questions | array | Yes | Question list, each core question ≥2 follow-up directions |
| core_modules[].questions[].main_question | string | Yes | Main question (open-ended) |
| core_modules[].questions[].follow_up_strategies | string[] | Yes | Follow-up strategies, ≥2 directions |
| core_modules[].questions[].probes | string[] | Yes | Probe hints |
| closing.open_ended_question | string | Yes | Closing open-ended question |
| recommended_participants | array | No | Recommended interview subject list |
| recommended_participants[].persona_type | string | Yes | Persona type |
| recommended_participants[].priority | string | Yes | Priority enum: high/medium/low |

## JSON Example

```json
{
  "script_id": "string",
  "research_objectives": ["string"],
  "target_personas": ["string"],
  "opening": {
    "icebreaker_questions": ["string"],
    "context_setting": "string"
  },
  "core_modules": [
    {
      "module_name": "string",
      "objective": "string",
      "hypothesis_to_validate": "string",
      "priority": "must_validate|should_validate|optional",
      "questions": [
        {
          "id": "string",
          "main_question": "string",
          "follow_up_strategies": ["string"],
          "probes": ["string"],
          "target_objective": "string"
        }
      ]
    }
  ],
  "closing": {
    "open_ended_question": "string",
    "wrap_up": "string"
  },
  "recommended_participants": [
    {
      "persona_type": "string",
      "key_characteristics": ["string"],
      "priority": "high|medium|low",
      "reason": "string"
    }
  ]
}
```
