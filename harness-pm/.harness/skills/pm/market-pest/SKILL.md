---
name: market-pest
description: Used when scanning the target market's policies and regulations, economic indicators, social trends, and technology dynamics. PEST auto-scan, outputs four-dimension trend summaries and impact assessments, tiered signal alerts, real-time alerts for major changes. Keywords: PEST analysis, policies and regulations, economic indicators, social trends, technology dynamics, environmental scanning, tiered signal alerts, external environment, policy impact, market trends.
---
# PEST Auto-Scan

## Outputs
- docs/discovery/market-analysis.md
- memory/progress.md

## Core Principles

1. **All four dimensions required** — All four PEST dimensions must be scanned; analysis missing any dimension is incomplete. When data is insufficient, fill with industry benchmark values and mark as "inferred value".
2. **Tiered signals, not flat listing** — Not all trends are equally important. Signals with impact degree ≥ 4 trigger alerts; signals < 3 are routed to routine monitoring. Resources focus on high-impact signals.
3. **Timeliness annotation** — Each signal is annotated as "occurred / occurring / expected to occur". Signals of different timeliness require completely different response strategies: occurred signals need immediate response, expected signals need advance preparation.
4. **Impact path traceability** — Each trend must be linked to a category impact path (e.g., "rising compliance costs → higher entry barriers for SMBs"). Trends not linked to an impact path are noise.

## Interaction Mode

🤖 AI auto-execution

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| category_keywords | string | Yes | User-provided | Category keywords, e.g., "online education", "SaaS CRM" |
| target_market | string | Yes | User-provided | Target market, e.g., "Mainland China", "Southeast Asia" |

## Execution Steps

### Step 1: Scheduled Scan [Core]

Collect information and monitor across four dimensions:

| Dimension | Scan Scope | Data Sources |
|------|---------|--------|
| Political | Industry regulatory policies, entry licenses, compliance requirements, data privacy laws, tax policies, subsidy policies | Government websites, regulatory databases, industry association announcements, policy interpretation media |
| Economic | GDP growth, industry growth rate, consumer spending, financing environment, exchange rate fluctuations, inflation rate | Statistics bureau data, central bank reports, third-party economic databases |
| Social | Demographic changes, consumption habit shifts, cultural trends, user preference evolution, lifestyle changes | Social media trends, user research reports, census data, lifestyle research |
| Technological | New technology maturity, technology adoption curves, infrastructure evolution, technology standard changes, patent trends | Tech media, patent databases, Gartner/IDC technology reports, open source community dynamics |

### Step 2: Trend Summary [Core]

Produce a structured summary of information collected for each dimension:

- Extract core trends (3-5 per dimension)
- Annotate trend direction (rising / declining / stable / emerging)
- Annotate trend strength (strong / medium / weak)
- Link to category impact path

### Step 3: Key Change Signals [Core]

Identify key change signals from the trend summary:

- Signal type: new policy release / indicator mutation / trend inflection / technology breakthrough
- Signal timeliness: occurred / occurring / expected to occur
- Signal source and verifiability

### Step 4: Impact Assessment [Core]

Assess the impact of each key change signal:

| Assessment Dimension | Description |
|---------|------|
| Impact direction | Positive (opportunity) / Negative (threat) / Neutral |
| Impact degree | 1-5 scale (1 = minimal impact, 5 = disruptive impact) |
| Impact time window | Short-term (<6 months) / Medium-term (6-18 months) / Long-term (>18 months) |
| Impact scope | Category only / Whole industry / Cross-industry |
| Response recommendation | Leverage strategy / Avoidance strategy / Monitoring strategy |

### Step 5: Major Change Alerts [Core]

Trigger alerts for high-impact signals:

- Filter signals with impact degree ≥ 4
- Generate alert summary: signal description + impact assessment + response recommendation
- Push to human PM in real time

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | PEST analysis conclusions | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full analysis + policy impact projection + trend forecasting + strategic response recommendations | Full artifact + extended analysis + deep projection |

## Output

Output file: `docs/discovery/market-analysis.md ("PEST Analysis" section)`

**Output Schema**:

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

**Output Validation Rules**:

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

## Decision Rules

| Rule | Trigger Condition | Action |
|------|---------|------|
| Real-time alert | Impact degree ≥ 4 | Real-time alert to human PM, push signal description + impact assessment + response recommendation |
| Routine monitoring | Impact degree < 3 | Route to routine monitoring list, no alert triggered |
| Signal escalation | Signal source unverifiable or contradictory | Mark as needing human confirmation, lower confidence |
| Data source reliability < 0.5 | Mark as "unreliable data source", suggest human verification or alternative data source |
| PEST dimension data missing | Mark as "dimension data incomplete", fill with industry benchmark values and mark as "inferred value" |

## Quality Checks

- [ ] Political dimension scanned
- [ ] Economic dimension scanned
- [ ] Social dimension scanned
- [ ] Technological dimension scanned
- [ ] At least 3 trend summaries per dimension
- [ ] Key change signals identified
- [ ] Impact assessment completed (direction + degree + time window)
- [ ] Major changes (impact degree ≥ 4) alerted
- [ ] Data source annotated | Each PEST dimension annotates data source and reliability | Dimensions without source annotation marked as "unknown source"

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| No strong dependencies | This Skill can run independently; user provides category and target market to execute | Output complete, no impact | Require user to provide category keywords and target market |
| All upstream files missing | User provides category keywords and target market → scan PEST four-dimension trends based on AI knowledge base | Trend data inferred from AI knowledge base, confidence marked as "inferred value", timeliness may lag | Require user to provide category keywords (e.g., "online education") and target market (e.g., "Mainland China") |
| If user does not provide category_keywords | Prompt user to provide category keywords, otherwise scan scope cannot be determined | Cannot generate output, flow interrupted | Require user to provide category keywords (e.g., "online education", "SaaS CRM") |
| If user does not provide target_market | Prompt user to provide target market, otherwise default to "Mainland China" | Target market defaults to "Mainland China", trends for other markets may be missed | Require user to provide target market name (e.g., "North America", "Southeast Asia") |

## Data Acquisition Notes

This Skill requires category keywords and target market information. Please provide via one of the following:
  1. Directly input category keywords (e.g., "online education", "SaaS CRM") and target market (e.g., "Mainland China")
  2. Upload industry analysis data files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream File | Change Type | Affected PEST Dimension | Impact Description |
|---------|---------|-------------|---------|
| tam-som.json | Market size data change | Economic | TAM/SAM/SOM size adjustments directly affect industry growth rate and market capacity trend judgments in economic indicators |
| competitor-analysis.json | Competitor technology dynamics change | Technological | Competitor new technology adoption, patent portfolio and other dynamics affect technology maturity and adoption curve judgments in the technology dimension |
| competitor-analysis.json | Competitor compliance strategy change | Political | Competitor regulatory response strategy changes can reverse-infer policy enforcement intensity and trend direction |
| tam-som.json | Regional market data change | Social | Regional market user size and penetration rate changes affect consumption habits and user preference judgments in social trends |

### Downstream Notification Mechanism Table

| PEST Change Type | Trigger Condition | Notify Downstream | Notification Content |
|-------------|---------|---------|---------|
| Major political change | Political dimension signal with impact degree ≥ 4 | market-competitor-analysis | Policy change summary, impact assessment, competitor response recommendations |
| Major political change | Political dimension signal with impact degree ≥ 4 | market-tam-som | Policy change impact assessment on market access and size, recommend re-estimating TAM/SAM/SOM |
| Major economic change | Economic dimension signal with impact degree ≥ 4 | market-tam-som | Economic indicator change summary, recommend re-evaluating market size and growth rate |
| Major technological change | Technological dimension signal with impact degree ≥ 4 | market-competitor-analysis | Technology breakthrough summary, impact assessment, recommend updating technology dimension in competitor Feature Matrix |
| Major social change | Social dimension signal with impact degree ≥ 4 | market-tam-som | Social trend change summary, recommend re-evaluating target user size and penetration rate |
