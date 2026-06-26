# User Modeling - Output Schemas & Validation Rules

Field-level schemas and validation rules for the `user-research-user-modeling` skill outputs (persona.json, empathy-map.json, journey-map.json).

## persona.json Output Schema

```json
{
  "type": "object",
  "required": ["personas", "metadata"],
  "properties": {
    "personas": {"type": "array", "description": "Persona list, including goals, behaviors, pain points, and JTBD"},
    "metadata": {"type": "object", "description": "Metadata, including timestamp, sources, and clustering quality score"}
  }
}
```

### persona.json Output Validation Rules

| Field path | Type | Required | Description |
|----------|------|------|------|
| personas | array | Yes | Persona list, cannot be empty |
| personas[].id | string | Yes | Persona unique identifier |
| personas[].name | string | Yes | Persona name |
| personas[].core_goals | array | Yes | Core goals list, each item must contain goal, confidence, data_source |
| personas[].core_goals[].data_source | string | Yes | Data source enum: voice/behavior/survey/inferred |
| personas[].core_goals[].confidence | number | Yes | Goal confidence, 0-1 |
| personas[].key_behaviors | array | Yes | Key behaviors list, each item must contain behavior, confidence, data_source |
| personas[].key_behaviors[].data_source | string | Yes | Data source enum: voice/behavior/survey/inferred |
| personas[].core_pain_points | array | Yes | Core pain points list, each item must contain pain_point, severity, confidence, data_source |
| personas[].core_pain_points[].severity | string | Yes | Pain point severity enum: P0/P1/P2/P3 |
| personas[].core_pain_points[].evidence_ref | string | Yes | Evidence reference source |
| personas[].representative_quotes | array | Yes | Representative quotes list, each Persona ≥3 |
| personas[].size_ratio | number | Yes | Size ratio, 0-1 |
| personas[].confidence | number | Yes | Persona overall confidence, 0-1 |
| personas[].jobs_to_be_done.functional_job | object | Yes | Functional Job, must contain description, confidence |
| personas[].jobs_to_be_done.emotional_job | object | Yes | Emotional Job, must contain description, confidence |
| personas[].jobs_to_be_done.social_job | object | Yes | Social Job, must contain description, confidence |
| personas[].low_confidence_fields | string[] | Yes | Low-confidence field list |
| metadata.analysis_timestamp | string | Yes | Analysis timestamp |
| metadata.input_sources | string[] | Yes | Input source list |
| metadata.clustering_quality_score | number | Yes | Clustering quality score, 0-1 |
| metadata.confidence_overall | number | Yes | Overall confidence, 0-1 |

## empathy-map.json Output Schema

```json
{
  "type": "object",
  "required": ["empathy_maps"],
  "properties": {
    "empathy_maps": {"type": "array", "description": "Empathy map list, including Says/Thinks/Does/Feels four quadrants"}
  }
}
```

### empathy-map.json Output Validation Rules

| Field path | Type | Required | Description |
|----------|------|------|------|
| empathy_maps | array | Yes | Empathy map list, cannot be empty |
| empathy_maps[].persona_id | string | Yes | Linked Persona ID |
| empathy_maps[].persona_name | string | Yes | Linked Persona name |
| empathy_maps[].says | array | Yes | Says quadrant, each item must contain content, source, confidence, ≥2 items |
| empathy_maps[].thinks | array | Yes | Thinks quadrant, each item must contain content, inference_basis, confidence, ≥2 items |
| empathy_maps[].does | array | Yes | Does quadrant, each item must contain content, source, confidence, ≥2 items |
| empathy_maps[].feels | array | Yes | Feels quadrant, each item must contain emotion, intensity, inference_basis, confidence, ≥2 items |

## journey-map.json Output Schema

```json
{
  "type": "object",
  "required": ["journey_maps"],
  "properties": {
    "journey_maps": {"type": "array", "description": "User journey map list, including stages, emotion curve, and opportunities"}
  }
}
```

### journey-map.json Output Validation Rules

| Field path | Type | Required | Description |
|----------|------|------|------|
| journey_maps | array | Yes | Journey map list, cannot be empty |
| journey_maps[].persona_id | string | Yes | Linked Persona ID |
| journey_maps[].persona_name | string | Yes | Linked Persona name |
| journey_maps[].stages | array | Yes | Journey stage list, must cover core stages |
| journey_maps[].stages[].stage_name | string | Yes | Stage name |
| journey_maps[].stages[].user_behaviors | string[] | Yes | User behavior list |
| journey_maps[].stages[].touchpoints | string[] | Yes | Touchpoint list |
| journey_maps[].stages[].emotion_score | number | Yes | Emotion score |
| journey_maps[].stages[].emotion_confidence | number | Yes | Emotion confidence, 0-1 |
| journey_maps[].stages[].pain_points | string[] | Yes | Pain point list |
| journey_maps[].stages[].opportunities | string[] | Yes | Opportunity list |
| journey_maps[].emotional_arc | object | Yes | Emotional arc, must contain high_points, low_points, overall_trend |
