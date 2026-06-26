# User Modeling - JSON Examples

This file collects JSON examples referenced by `SKILL.md` for the `user-research-user-modeling` skill.

## Input Format

```json
{
  "voice_analysis_path": "docs/discovery/user-research.md (append \"User Voice Analysis\" section)
  "behavior_analysis_path": "docs/discovery/user-research.md (append \"User Behavior Analysis\" section)
  "survey_data": {
    "available": "boolean",
    "location": "string",
    "sample_size": "number"
  },
  "modeling_config": {
    "max_personas": "number",
    "min_confidence_threshold": "number",
    "journey_stages": ["string"],
    "include_emotional_arc": "boolean"
  }
}
```

**Input dependencies**:
- `voice-analysis.json`: Provides user voice insights, pain points, themes, segments
- `behavior-analysis.json`: Provides behavior insights, funnel, paths, Aha Moment
- Survey data (optional): Supplements demographic and attitudinal data

## persona.json Example

```json
{
  "personas": [
    {
      "id": "string",
      "name": "string",
      "core_goals": [
        {
          "goal": "string",
          "confidence": "number",
          "data_source": "voice|behavior|survey|inferred"
        }
      ],
      "key_behaviors": [
        {
          "behavior": "string",
          "confidence": "number",
          "data_source": "voice|behavior|survey|inferred"
        }
      ],
      "core_pain_points": [
        {
          "pain_point": "string",
          "severity": "P0|P1|P2|P3",
          "confidence": "number",
          "data_source": "voice|behavior|survey|inferred",
          "evidence_ref": "string"
        }
      ],
      "representative_quotes": [
        {
          "quote": "string",
          "source": "string",
          "sentiment": "string"
        }
      ],
      "size_ratio": "number",
      "confidence": "number",
      "jobs_to_be_done": {
        "functional_job": {
          "description": "string",
          "confidence": "number"
        },
        "emotional_job": {
          "description": "string",
          "confidence": "number"
        },
        "social_job": {
          "description": "string",
          "confidence": "number"
        }
      },
      "low_confidence_fields": ["string"]
    }
  ],
  "metadata": {
    "analysis_timestamp": "string",
    "input_sources": ["string"],
    "clustering_quality_score": "number",
    "confidence_overall": "number"
  }
}
```

## empathy-map.json Example

```json
{
  "empathy_maps": [
    {
      "persona_id": "string",
      "persona_name": "string",
      "says": [
        {
          "content": "string",
          "source": "string",
          "confidence": "number"
        }
      ],
      "thinks": [
        {
          "content": "string",
          "inference_basis": "string",
          "confidence": "number"
        }
      ],
      "does": [
        {
          "content": "string",
          "source": "string",
          "confidence": "number"
        }
      ],
      "feels": [
        {
          "emotion": "string",
          "intensity": "number",
          "inference_basis": "string",
          "confidence": "number"
        }
      ]
    }
  ]
}
```

## journey-map.json Example

```json
{
  "journey_maps": [
    {
      "persona_id": "string",
      "persona_name": "string",
      "stages": [
        {
          "stage_name": "string",
          "user_behaviors": ["string"],
          "touchpoints": ["string"],
          "emotion_score": "number",
          "emotion_confidence": "number",
          "pain_points": ["string"],
          "opportunities": ["string"]
        }
      ],
      "emotional_arc": {
        "high_points": ["string"],
        "low_points": ["string"],
        "overall_trend": "string"
      }
    }
  ]
}
```
