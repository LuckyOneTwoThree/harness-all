# user-research-behavior-analysis — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

Output file: `docs/discovery/user-research.md (append "User Behavior Analysis" section)`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["funnel_health", "aha_moment_candidates", "feature_usage", "metadata"],
  "properties": {
    "funnel_health": {"type": "object", "description": "Funnel health diagnosis, including conversion rate per step and health score"},
    "aha_moment_candidates": {"type": "array", "description": "Aha Moment candidate list"},
    "feature_usage": {"type": "array", "description": "Feature usage depth analysis list"},
    "behavior_paths": {"type": "object", "description": "Behavior path analysis, including high-frequency paths, detours, and lost patterns"},
    "anomalies": {"type": "array", "description": "Anomaly event detection list"},
    "metadata": {"type": "object", "description": "Analysis metadata, including timestamp and confidence"}
  }
}
```

**Output validation rules**:

| Field path | Type | Required | Description |
|----------|------|------|------|
| funnel_health.overall_score | number | Yes | Overall funnel health score, 0-100 |
| funnel_health.steps | array | Yes | Funnel step data, each item must contain step_name, conversion_rate, drop_off_rate, confidence |
| funnel_health.steps[].step_name | string | Yes | Step name, cannot be empty |
| funnel_health.steps[].conversion_rate | number | Yes | Conversion rate, 0-1 |
| funnel_health.steps[].drop_off_rate | number | Yes | Drop-off rate, 0-1 |
| funnel_health.steps[].is_anomaly | boolean | Yes | Whether this step is anomalous |
| funnel_health.steps[].confidence | number | Yes | Step confidence, 0-1 |
| funnel_health.trend | string | Yes | Trend enum: improving/stable/declining |
| aha_moment_candidates | array | Yes | Aha Moment candidate list, each item must contain behavior_pattern, correlation_with_retention, predictive_power, confidence |
| aha_moment_candidates[].behavior_pattern | string | Yes | Behavior pattern description, cannot be empty |
| aha_moment_candidates[].correlation_with_retention | number | Yes | Correlation with retention, <0.3 marked as "insufficient predictive power" |
| aha_moment_candidates[].predictive_power | number | Yes | Predictive power score, 0-1 |
| aha_moment_candidates[].confidence | number | Yes | Candidate confidence, 0-1 |
| feature_usage | array | Yes | Feature usage list, each item must contain feature_name, adoption_rate, value_score, usage_vs_value_quadrant, confidence |
| feature_usage[].feature_name | string | Yes | Feature name, cannot be empty |
| feature_usage[].adoption_rate | number | Yes | Adoption rate, 0-1 |
| feature_usage[].value_score | number | Yes | Value score, 0-1 |
| feature_usage[].usage_vs_value_quadrant | string | Yes | Quadrant enum: high_value_high_use/high_value_low_use/low_value_high_use/low_value_low_use |
| feature_usage[].confidence | number | Yes | Feature confidence, 0-1 |
| behavior_paths.top_paths | array | No | High-frequency path list |
| behavior_paths.top_paths[].path | string[] | Yes | Path step sequence |
| behavior_paths.top_paths[].user_count | number | Yes | Number of users on this path |
| behavior_paths.top_paths[].avg_completion_time | number | Yes | Average completion time (seconds) |
| behavior_paths.detour_patterns | array | No | Detour pattern list |
| behavior_paths.detour_patterns[].description | string | Yes | Detour description, cannot be empty |
| behavior_paths.detour_patterns[].affected_user_ratio | number | Yes | Affected user ratio, 0-1 |
| behavior_paths.detour_patterns[].possible_cause | string | Yes | Possible cause |
| behavior_paths.lost_patterns | array | No | Lost pattern list |
| behavior_paths.lost_patterns[].description | string | Yes | Lost description, cannot be empty |
| behavior_paths.lost_patterns[].affected_user_ratio | number | Yes | Affected user ratio, 0-1 |
| behavior_paths.lost_patterns[].loop_pages | string[] | Yes | Looping page list |
| anomalies | array | No | Anomaly event list, each item must contain metric, anomaly_type, detected_date, magnitude, possible_causes, confidence |
| anomalies[].metric | string | Yes | Anomaly metric name, cannot be empty |
| anomalies[].anomaly_type | string | Yes | Anomaly type enum: spike/gradual/cyclical |
| anomalies[].detected_date | string | Yes | Detection date, ISO 8601 format |
| anomalies[].magnitude | number | Yes | Change magnitude |
| anomalies[].possible_causes | string[] | Yes | Possible cause list |
| anomalies[].impact_scope | string | No | Impact scope |
| anomalies[].confidence | number | Yes | Anomaly confidence, 0-1 |
| metadata.analysis_timestamp | string | Yes | Analysis timestamp |
| metadata.data_quality_flags | string[] | Yes | Data quality flags |
| metadata.confidence_overall | number | Yes | Overall confidence, 0-1 |

```json
{
  "funnel_health": {
    "overall_score": "number",
    "steps": [
      {
        "step_name": "string",
        "conversion_rate": "number",
        "drop_off_rate": "number",
        "is_anomaly": "boolean",
        "anomaly_description": "string",
        "lost_user_profile": {
          "last_action": "string",
          "avg_time_spent": "number",
          "device_distribution": {}
        },
        "confidence": "number"
      }
    ],
    "trend": "improving|stable|declining"
  },
  "aha_moment_candidates": [
    {
      "behavior_pattern": "string",
      "correlation_with_retention": "number",
      "user_segment": "string",
      "threshold": "string",
      "predictive_power": "number",
      "confidence": "number"
    }
  ],
  "feature_usage": [
    {
      "feature_name": "string",
      "discovery_rate": "number",
      "adoption_rate": "number",
      "depth_distribution": {
        "discover_only": "number",
        "try_once": "number",
        "regular_use": "number",
        "power_use": "number"
      },
      "value_score": "number",
      "usage_vs_value_quadrant": "high_value_high_use|high_value_low_use|low_value_high_use|low_value_low_use",
      "confidence": "number"
    }
  ],
  "behavior_paths": {
    "top_paths": [
      {
        "path": ["string"],
        "user_count": "number",
        "avg_completion_time": "number"
      }
    ],
    "detour_patterns": [
      {
        "description": "string",
        "affected_user_ratio": "number",
        "possible_cause": "string"
      }
    ],
    "lost_patterns": [
      {
        "description": "string",
        "affected_user_ratio": "number",
        "loop_pages": ["string"]
      }
    ]
  },
  "anomalies": [
    {
      "metric": "string",
      "anomaly_type": "spike|gradual|cyclical",
      "detected_date": "string",
      "magnitude": "number",
      "possible_causes": ["string"],
      "impact_scope": "string",
      "confidence": "number"
    }
  ],
  "metadata": {
    "analysis_timestamp": "string",
    "data_quality_flags": ["string"],
    "confidence_overall": "number"
  }
}
```

---
