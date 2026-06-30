# user-research-voice-analysis — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

Output file: `docs/discovery/user-research.md (append "User Voice Analysis" section)`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["summary", "metadata"],
  "properties": {
    "summary": {"type": "object", "description": "Analysis summary, including total feedback, sentiment distribution, themes, pain points, and user segments"},
    "metadata": {"type": "object", "description": "Metadata, including timestamp, data quality flags, and overall confidence"}
  }
}
```

**Output validation rules**:

| Field path | Type | Required | Description |
|----------|------|------|------|
| summary.total_feedback_analyzed | number | Yes | Total feedback analyzed, must be >0 |
| summary.data_sources_used | string[] | Yes | List of data sources actually used, cannot be empty |
| summary.time_range | string | Yes | Data time range |
| summary.sentiment_distribution.positive | number | Yes | Positive sentiment ratio, 0-1 |
| summary.sentiment_distribution.negative | number | Yes | Negative sentiment ratio, 0-1 |
| summary.sentiment_distribution.neutral | number | Yes | Neutral sentiment ratio, 0-1 |
| summary.sentiment_distribution.mixed | number | Yes | Mixed sentiment ratio, 0-1 |
| summary.top_themes | array | Yes | Theme list, each item must contain theme, feedback_count, representative_quotes, confidence |
| summary.top_themes[].theme | string | Yes | Theme name, cannot be empty |
| summary.top_themes[].feedback_count | number | Yes | Feedback count for this theme |
| summary.top_themes[].representative_quotes | string[] | Yes | Each theme ≥2 representative verbatims |
| summary.top_themes[].confidence | number | Yes | Theme confidence, 0-1 |
| summary.top_pain_points | array | Yes | Pain point list, each item must contain pain_point, severity, impact_score, representative_quotes, confidence |
| summary.top_pain_points[].pain_point | string | Yes | Pain point description, cannot be empty |
| summary.top_pain_points[].severity | string | Yes | Pain point severity enum: P0/P1/P2/P3 |
| summary.top_pain_points[].impact_score | number | Yes | Pain point impact score |
| summary.top_pain_points[].representative_quotes | string[] | Yes | Each pain point ≥2 representative verbatims |
| summary.top_pain_points[].confidence | number | Yes | Pain point confidence, 0-1 |
| summary.emerging_themes | array | No | Emerging theme list |
| summary.emerging_themes[].confidence | number | Yes | Emerging theme confidence, 0-1 |
| summary.user_segments | array | Yes | User segment list, each item must contain segment_name, size_ratio, confidence |
| summary.user_segments[].segment_name | string | Yes | Segment name, cannot be empty |
| summary.user_segments[].size_ratio | number | Yes | Size ratio, 0-1 |
| summary.user_segments[].confidence | number | Yes | Segment confidence, 0-1 |
| metadata.analysis_timestamp | string | Yes | Analysis timestamp |
| metadata.data_quality_flags | string[] | Yes | Data quality flags |
| metadata.confidence_overall | number | Yes | Overall confidence, 0-1 |

```json
{
  "summary": {
    "total_feedback_analyzed": "number",
    "data_sources_used": ["string"],
    "time_range": "string",
    "sentiment_distribution": {
      "positive": "number",
      "negative": "number",
      "neutral": "number",
      "mixed": "number"
    },
    "top_themes": [
      {
        "theme": "string",
        "feedback_count": "number",
        "sentiment_breakdown": {},
        "trend": "rising|stable|declining",
        "representative_quotes": ["string"],
        "confidence": "number"
      }
    ],
    "top_pain_points": [
      {
        "pain_point": "string",
        "severity": "P0|P1|P2|P3",
        "impact_score": "number",
        "affected_user_ratio": "number",
        "emotion_intensity_avg": "number",
        "frequency": "number",
        "related_theme": "string",
        "representative_quotes": ["string"],
        "confidence": "number"
      }
    ],
    "emerging_themes": [
      {
        "theme": "string",
        "frequency_change": "string",
        "current_volume": "number",
        "confidence": "number"
      }
    ],
    "user_segments": [
      {
        "segment_name": "string",
        "core_characteristics": ["string"],
        "primary_needs": ["string"],
        "sentiment_tendency": "string",
        "size_ratio": "number",
        "confidence": "number"
      }
    ]
  },
  "metadata": {
    "analysis_timestamp": "string",
    "data_quality_flags": ["string"],
    "confidence_overall": "number"
  }
}
```

---
