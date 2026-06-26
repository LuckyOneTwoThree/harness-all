# Interview Insights (interview-insights.json) - Schema and Example

> Extracted from SKILL.md. Output schema, validation rules, and JSON example for interview-insights.json.

## Output Schema

```json
{
  "type": "object",
  "required": ["interviews_conducted", "validated_hypotheses", "new_discoveries", "metadata"],
  "properties": {
    "interviews_conducted": {"type": "number", "description": "Number of interviews conducted"},
    "validated_hypotheses": {"type": "array", "description": "List of validated hypotheses"},
    "refuted_hypotheses": {"type": "array", "description": "List of refuted hypotheses"},
    "new_discoveries": {"type": "array", "description": "List of new discoveries"},
    "cross_interview_patterns": {"type": "array", "description": "List of cross-interview common patterns"},
    "persona_updates": {"type": "array", "description": "List of Persona updates"},
    "data_cross_validation": {"type": "object", "description": "Cross-validation results with existing data"},
    "metadata": {"type": "object", "description": "Analysis metadata, including timestamp and overall confidence"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| interviews_conducted | number | Yes | Number of interviews conducted, must be ≥1 |
| validated_hypotheses | array | Yes | Validated hypothesis list, each item must include hypothesis, supporting_evidence, supporting_quotes, interview_count, confidence |
| validated_hypotheses[].confidence | number | Yes | Validation confidence, 0-1 |
| refuted_hypotheses | array | Yes | Refuted hypothesis list, each item must include hypothesis, refuting_evidence, refuting_quotes, interview_count, confidence |
| refuted_hypotheses[].confidence | number | Yes | Refutation confidence, 0-1 |
| new_discoveries | array | Yes | New discovery list, each item must include discovery, evidence, quotes, interview_count, confidence, needs_further_validation |
| new_discoveries[].needs_further_validation | boolean | Yes | Whether further validation is needed |
| new_discoveries[].confidence | number | Yes | Discovery confidence, 0-1 |
| cross_interview_patterns | array | No | Cross-interview pattern list, each item must include pattern, frequency, interview_ids, confidence, saturation_level |
| cross_interview_patterns[].saturation_level | string | Yes | Saturation enum: saturated/near_saturated/needs_more |
| persona_updates | array | No | Persona update list, each item must include persona_id, updates |
| persona_updates[].updates[].update_type | string | Yes | Update type enum: interview-validated/interview-revised/interview-discovered |
| data_cross_validation | object | No | Cross-validation results, must include consistent_with_voice_analysis, consistent_with_behavior_analysis, contradictions_found |
| metadata.analysis_timestamp | string | Yes | Analysis timestamp |
| metadata.total_interviews | number | Yes | Total interviews |
| metadata.total_insights | number | Yes | Total insights |
| metadata.confidence_overall | number | Yes | Overall confidence, 0-1 |

## JSON Example

```json
{
  "interviews_conducted": "number",
  "validated_hypotheses": [
    {
      "hypothesis": "string",
      "supporting_evidence": ["string"],
      "supporting_quotes": ["string"],
      "interview_count": "number",
      "confidence": "number"
    }
  ],
  "refuted_hypotheses": [
    {
      "hypothesis": "string",
      "refuting_evidence": ["string"],
      "refuting_quotes": ["string"],
      "interview_count": "number",
      "confidence": "number"
    }
  ],
  "new_discoveries": [
    {
      "discovery": "string",
      "evidence": ["string"],
      "quotes": ["string"],
      "interview_count": "number",
      "confidence": "number",
      "needs_further_validation": "boolean"
    }
  ],
  "cross_interview_patterns": [
    {
      "pattern": "string",
      "frequency": "number",
      "interview_ids": ["string"],
      "confidence": "number",
      "saturation_level": "saturated|near_saturated|needs_more"
    }
  ],
  "persona_updates": [
    {
      "persona_id": "string",
      "updates": [
        {
          "field": "string",
          "previous_value": "string",
          "updated_value": "string",
          "update_type": "interview-validated|interview-revised|interview-discovered",
          "confidence": "number"
        }
      ]
    }
  ],
  "data_cross_validation": {
    "consistent_with_voice_analysis": ["string"],
    "consistent_with_behavior_analysis": ["string"],
    "contradictions_found": [
      {
        "data_source": "string",
        "interview_finding": "string",
        "existing_finding": "string",
        "possible_explanation": "string",
        "resolution": "string"
      }
    ]
  },
  "metadata": {
    "analysis_timestamp": "string",
    "total_interviews": "number",
    "total_insights": "number",
    "confidence_overall": "number"
  }
}
```
