# Output Schema, Validation Rules, and Example

> Extracted from SKILL.md. Output JSON schema, field validation rules, and a complete JSON example for PEST analysis.

## Output Schema

```json
{
  "type": "object",
  "required": ["category_keywords", "target_market", "scan_timestamp", "political", "economic", "social", "technological"],
  "properties": {
    "category_keywords": {"type": "string", "description": "Category keywords"},
    "target_market": {"type": "string", "description": "Target market"},
    "scan_timestamp": {"type": "string", "description": "Scan timestamp"},
    "political": {"type": "object", "description": "Political dimension trends and signals"},
    "economic": {"type": "object", "description": "Economic dimension trends and signals"},
    "social": {"type": "object", "description": "Social dimension trends and signals"},
    "technological": {"type": "object", "description": "Technological dimension trends and signals"},
    "alerts": {"type": "array", "description": "Major change alert list"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|---------|------|------|------|
| category_keywords | string | Yes | Category keywords, cannot be an empty string |
| target_market | string | Yes | Target market, cannot be an empty string |
| scan_timestamp | string | Yes | ISO 8601 format scan timestamp |
| political | object | Yes | Political dimension, cannot be missing |
| political.trends | array | Yes | At least 1 trend, each must contain trend, direction, strength, impact_path |
| political.trends[].trend | string | Yes | Trend description, cannot be empty |
| political.trends[].direction | string | Yes | Trend direction, enum: rising/declining/stable/emerging |
| political.trends[].strength | string | Yes | Trend strength, enum: strong/medium/weak |
| political.trends[].impact_path | string | Yes | Category impact path, cannot be empty |
| political.key_signals | array | Yes | Signal list, each must contain signal, type, timing, source, impact |
| political.key_signals[].signal | string | Yes | Signal description, cannot be empty |
| political.key_signals[].type | string | Yes | Signal type, enum: new policy release/indicator mutation/trend inflection/technology breakthrough |
| political.key_signals[].timing | string | Yes | Signal timeliness, enum: occurred/occurring/expected to occur |
| political.key_signals[].source | string | Yes | Signal source, cannot be empty |
| political.key_signals[].impact | object | Yes | Impact assessment, must contain direction, degree, time_window, scope, recommendation |
| political.key_signals[].impact.direction | string | Yes | Impact direction, enum: positive/negative/neutral |
| political.key_signals[].impact.degree | integer | Yes | Impact degree, 1-5 |
| political.key_signals[].impact.time_window | string | Yes | Impact time window, enum: short-term/medium-term/long-term |
| political.key_signals[].impact.scope | string | Yes | Impact scope |
| political.key_signals[].impact.recommendation | string | Yes | Response recommendation |
| economic | object | Yes | Economic dimension, cannot be missing; when data is insufficient, fill with industry benchmark values and mark as "inferred value" |
| economic.trends | array | Yes | At least 1 trend, each must contain trend, direction, strength, impact_path |
| economic.trends[].trend | string | Yes | Trend description, cannot be empty |
| economic.trends[].direction | string | Yes | Trend direction, enum: rising/declining/stable/emerging |
| economic.trends[].strength | string | Yes | Trend strength, enum: strong/medium/weak |
| economic.trends[].impact_path | string | Yes | Category impact path, cannot be empty |
| economic.key_signals | array | Yes | Signal list, each must contain signal, type, timing, source, impact |
| economic.key_signals[].signal | string | Yes | Signal description, cannot be empty |
| economic.key_signals[].type | string | Yes | Signal type, enum: new policy release/indicator mutation/trend inflection/technology breakthrough |
| economic.key_signals[].timing | string | Yes | Signal timeliness, enum: occurred/occurring/expected to occur |
| economic.key_signals[].source | string | Yes | Signal source, cannot be empty |
| economic.key_signals[].impact | object | Yes | Impact assessment, must contain direction, degree, time_window, scope, recommendation |
| economic.key_signals[].impact.direction | string | Yes | Impact direction, enum: positive/negative/neutral |
| economic.key_signals[].impact.degree | integer | Yes | Impact degree, 1-5 |
| economic.key_signals[].impact.time_window | string | Yes | Impact time window, enum: short-term/medium-term/long-term |
| economic.key_signals[].impact.scope | string | Yes | Impact scope |
| economic.key_signals[].impact.recommendation | string | Yes | Response recommendation |
| social | object | Yes | Social dimension, cannot be missing; when data is insufficient, fill with industry benchmark values and mark as "inferred value" |
| social.trends | array | Yes | At least 1 trend, each must contain trend, direction, strength, impact_path |
| social.trends[].trend | string | Yes | Trend description, cannot be empty |
| social.trends[].direction | string | Yes | Trend direction, enum: rising/declining/stable/emerging |
| social.trends[].strength | string | Yes | Trend strength, enum: strong/medium/weak |
| social.trends[].impact_path | string | Yes | Category impact path, cannot be empty |
| social.key_signals | array | Yes | Signal list, each must contain signal, type, timing, source, impact |
| social.key_signals[].signal | string | Yes | Signal description, cannot be empty |
| social.key_signals[].type | string | Yes | Signal type, enum: new policy release/indicator mutation/trend inflection/technology breakthrough |
| social.key_signals[].timing | string | Yes | Signal timeliness, enum: occurred/occurring/expected to occur |
| social.key_signals[].source | string | Yes | Signal source, cannot be empty |
| social.key_signals[].impact | object | Yes | Impact assessment, must contain direction, degree, time_window, scope, recommendation |
| social.key_signals[].impact.direction | string | Yes | Impact direction, enum: positive/negative/neutral |
| social.key_signals[].impact.degree | integer | Yes | Impact degree, 1-5 |
| social.key_signals[].impact.time_window | string | Yes | Impact time window, enum: short-term/medium-term/long-term |
| social.key_signals[].impact.scope | string | Yes | Impact scope |
| social.key_signals[].impact.recommendation | string | Yes | Response recommendation |
| technological | object | Yes | Technological dimension, cannot be missing; when data is insufficient, fill with industry benchmark values and mark as "inferred value" |
| technological.trends | array | Yes | At least 1 trend, each must contain trend, direction, strength, impact_path |
| technological.trends[].trend | string | Yes | Trend description, cannot be empty |
| technological.trends[].direction | string | Yes | Trend direction, enum: rising/declining/stable/emerging |
| technological.trends[].strength | string | Yes | Trend strength, enum: strong/medium/weak |
| technological.trends[].impact_path | string | Yes | Category impact path, cannot be empty |
| technological.key_signals | array | Yes | Signal list, each must contain signal, type, timing, source, impact |
| technological.key_signals[].signal | string | Yes | Signal description, cannot be empty |
| technological.key_signals[].type | string | Yes | Signal type, enum: new policy release/indicator mutation/trend inflection/technology breakthrough |
| technological.key_signals[].timing | string | Yes | Signal timeliness, enum: occurred/occurring/expected to occur |
| technological.key_signals[].source | string | Yes | Signal source, cannot be empty |
| technological.key_signals[].impact | object | Yes | Impact assessment, must contain direction, degree, time_window, scope, recommendation |
| technological.key_signals[].impact.direction | string | Yes | Impact direction, enum: positive/negative/neutral |
| technological.key_signals[].impact.degree | integer | Yes | Impact degree, 1-5 |
| technological.key_signals[].impact.time_window | string | Yes | Impact time window, enum: short-term/medium-term/long-term |
| technological.key_signals[].impact.scope | string | Yes | Impact scope |
| technological.key_signals[].impact.recommendation | string | Yes | Response recommendation |
| alerts | array | Yes | Alert list with impact degree ≥ 4; empty array when no high-impact signals |
| alerts[].signal | string | Yes (when alerts non-empty) | Alert signal description |
| alerts[].dimension | string | Yes (when alerts non-empty) | PEST dimension |
| alerts[].impact_degree | integer | Yes (when alerts non-empty) | Impact degree, ≥ 4 |
| alerts[].impact_direction | string | Yes (when alerts non-empty) | Impact direction |
| alerts[].recommendation | string | Yes (when alerts non-empty) | Response recommendation |
| alerts[].timestamp | string | Yes (when alerts non-empty) | Alert timestamp |

## Output JSON Example

```json
{
  "category_keywords": "Online Education",
  "target_market": "Mainland China",
  "scan_timestamp": "2026-05-10T08:00:00Z",
  "political": {
    "trends": [
      {
        "trend": "Data privacy laws tightening, personal data protection strengthening",
        "direction": "rising",
        "strength": "strong",
        "impact_path": "Rising compliance costs → higher entry barriers for SMBs"
      }
    ],
    "key_signals": [
      {
        "signal": "Implementation rules of the Personal Information Protection Law released",
        "type": "new policy release",
        "timing": "occurred",
        "source": "State Council official website",
        "impact": {
          "direction": "negative",
          "degree": 5,
          "time_window": "medium-term",
          "scope": "industry",
          "recommendation": "Accelerate compliance system building, establish data privacy protection mechanisms"
        },
        "alert": false
      }
    ]
  },
  "economic": {
    "trends": [
      {
        "trend": "GDP growth slowing, pressure on residents' disposable income growth",
        "direction": "declining",
        "strength": "medium",
        "impact_path": "Declining willingness for education spending → lower conversion rates for paid online education"
      }
    ],
    "key_signals": [
      {
        "signal": "Q1 2026 GDP growth dropped to 4.5%",
        "type": "indicator mutation",
        "timing": "occurred",
        "source": "National Bureau of Statistics quarterly bulletin",
        "impact": {
          "direction": "negative",
          "degree": 3,
          "time_window": "medium-term",
          "scope": "industry",
          "recommendation": "Optimize pricing strategy, launch lightweight affordable products to cope with consumption downgrade"
        },
        "alert": false
      }
    ]
  },
  "social": {
    "trends": [
      {
        "trend": "Gen Z consumption habits changing, fragmented learning preference strengthening",
        "direction": "rising",
        "strength": "strong",
        "impact_path": "Fragmented learning scenarios → course product design must adapt to short, high-frequency patterns"
      }
    ],
    "key_signals": [
      {
        "signal": "Short-video learning apps MAU grew 45% YoY",
        "type": "trend inflection",
        "timing": "occurring",
        "source": "QuestMobile annual report",
        "impact": {
          "direction": "positive",
          "degree": 4,
          "time_window": "short-term",
          "scope": "industry",
          "recommendation": "Develop short-video micro-course product format, capture fragmented learning scenarios"
        },
        "alert": true
      }
    ]
  },
  "technological": {
    "trends": [
      {
        "trend": "AI technology spreading, large model education application costs dropping rapidly",
        "direction": "rising",
        "strength": "strong",
        "impact_path": "Declining AI tutoring costs → personalized teaching products can scale"
      }
    ],
    "key_signals": [
      {
        "signal": "Education large model API call costs dropped 60% YoY",
        "type": "technology breakthrough",
        "timing": "occurring",
        "source": "Gartner technology maturity report",
        "impact": {
          "direction": "positive",
          "degree": 4,
          "time_window": "medium-term",
          "scope": "cross-industry",
          "recommendation": "Increase R&D investment in AI personalized tutoring products, build data flywheel"
        },
        "alert": true
      }
    ]
  },
  "alerts": [
    {
      "signal": "Implementation rules of the Personal Information Protection Law released",
      "dimension": "Political",
      "impact_degree": 5,
      "impact_direction": "negative",
      "recommendation": "Accelerate compliance system building, establish data privacy protection mechanisms",
      "timestamp": "2026-05-10T08:00:00Z"
    },
    {
      "signal": "Short-video learning apps MAU grew 45% YoY",
      "dimension": "Social",
      "impact_degree": 4,
      "impact_direction": "positive",
      "recommendation": "Develop short-video micro-course product format, capture fragmented learning scenarios",
      "timestamp": "2026-05-10T08:00:00Z"
    },
    {
      "signal": "Education large model API call costs dropped 60% YoY",
      "dimension": "Technological",
      "impact_degree": 4,
      "impact_direction": "positive",
      "recommendation": "Increase R&D investment in AI personalized tutoring products, build data flywheel",
      "timestamp": "2026-05-10T08:00:00Z"
    }
  ]
}
```
