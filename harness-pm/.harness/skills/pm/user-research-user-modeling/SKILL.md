---
name: user-research-user-modeling
description: Used when generating Persona, Empathy Map, and Journey Map from user voice analysis and behavior analysis results. User modeling auto-generation pipeline. Keywords: user modeling, Persona generation, empathy map, user journey map, user persona, typical user, user role, what users look like.
metadata:
  module: "Product Discovery"
  sub-module: "User Research"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["General"]
  trigger_examples:
    - "Help me create user personas"
    - "How to map the user journey"
    - "What kind of users are they"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output user models and behavioral traits"
  deep_description: "Full modeling + behavior sequence analysis + model validation plan + user evolution tracking"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/discovery/user-research.md
writes:
  - docs/discovery/user-research.md
  - memory/progress.md
---

# User Modeling Auto-Generation

## Core Principles

1. **Persona is hypothesis, not fact** — Persona is an inferred model based on data; it requires continuous validation rather than being fixed. Low-confidence fields must be annotated
2. **Voice + behavior cross-validation** — What users say (VOC) and what they do (behavior) must cross-validate; contradictions are marked as hypotheses pending validation
3. **Inferences must be sourced** — Each trait field is annotated with data_source (voice/behavior/survey/inferred); inferred content must not be disguised as fact
4. **Low confidence means hypothesis pending validation** — Fields with confidence < 0.5 are escalated for human validation and do not automatically proceed to subsequent flows

## Interaction Mode

🤖→👤 **AI suggests, human approves** — AI generates model drafts; human approval is required before they can be used in subsequent flows

---

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| voice-analysis.json | JSON | Yes | docs/discovery/user-research.md (append "User Voice Analysis" section) | User voice insights, pain points, themes, segments |
| behavior-analysis.json | JSON | Yes | docs/discovery/user-research.md (append "User Behavior Analysis" section) | Behavior insights, funnel, paths, Aha Moment |
| survey_data | JSON | ○ | User-provided | Survey data, supplementing demographic and attitudinal data |
| modeling_config | object | ○ | User-provided | Modeling configuration (max Persona count, confidence threshold, journey stages, etc.) |

### Input Format

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

---

## Execution Steps

### Step 1: User Clustering [Core]

- Integrate user segments from voice-analysis with behavior segments from behavior-analysis
- Use cross-validation to determine the optimal number of clusters (2-6 Personas)
- Clustering dimensions: behavioral traits × voice traits × demographics (if available)
- Evaluate cohesion and distinctiveness of each cluster
- Output: Clustering results, with core trait descriptions for each cluster

### Step 2: Feature Persona Extraction [Core]

- Extract key traits for each cluster:
  - **Behavioral traits**: Core usage scenarios, usage frequency, feature preferences, Aha Moment
  - **Voice traits**: Main needs, core pain points, sentiment tendency, representative quotes
  - **Demographics**: Age range, occupational tendency, tech proficiency (if data available)
  - **Jobs to be Done**: Functional Job / Emotional Job / Social Job
- Annotate confidence for each trait
- Annotate data source (voice / behavior / survey / inferred)
- Output: Feature persona for each cluster

### Step 3: Persona Document Generation [Core]

- Generate a Persona document for each cluster, including:
  - **Name**: A memorable alias (e.g., "Efficiency Pioneer", "Experience Explorer")
  - **Core goals**: What this Persona most wants to achieve (2-3)
  - **Key behaviors**: Typical usage behavior patterns (3-5)
  - **Core pain points**: Most troubling issues (2-4, referencing voice-analysis data)
  - **Representative quotes**: Quotes from real user feedback (3-5)
  - **Size ratio**: This Persona's proportion of the user base
  - **Confidence**: Overall confidence score (0-1)
- Annotate inferred content (traits without direct data support)
- Output: persona.json

### Step 4: Empathy Map Generation [Core]

- Generate an Empathy Map for each Persona, including four quadrants:
  - **Says**: What the user says (quotes from voice-analysis)
  - **Thinks**: What the user might be thinking (inferred, with confidence annotated)
  - **Does**: What the user does (behavior data from behavior-analysis)
  - **Feels**: The user's emotional state (from sentiment analysis + inference, with confidence annotated)
- Annotate data source and confidence for each quadrant entry
- Output: empathy-map.json

### Step 5: Journey Map Generation [Core]

- Generate a Journey Map for each Persona, including:
  - **Stages**: Awareness → Consideration → Usage → Deep Use → Churn/Retention
  - **Each stage**:
    - User behaviors (from behavior-analysis)
    - Touchpoints (internal and external to the product)
    - Emotion curve (high/low points annotated)
    - Pain points (from voice-analysis)
    - Opportunities (pain points × unmet needs)
- Annotate confidence of the emotion curve (behavior data support vs. inference)
- Output: journey-map.json

### Step 6: Confidence Assessment [Core]

- Assess overall confidence for each Persona
- Assess confidence for each output field
- Identify low-confidence fields (< 0.5) and mark them for human validation
- Generate a confidence report: which conclusions have strong data support and which need supplementary validation
- Output: Confidence assessment report

---

### Output Depth Tiers

| Depth level | Output scope | Description |
|----------|----------|------|
| quick | User models and behavioral traits | Core conclusions + minimum viable deliverable |
| standard | Full deliverable (current default) | Complete deliverable, including all Step outputs |
| deep | Full modeling + behavior sequence analysis + model validation plan + user evolution tracking | Full deliverable + extended analysis + deep inference |

## Output

### persona.json

Output file: `docs/discovery/user-research.md (append "User Persona" section)`

**Output Schema**:

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

**Output validation rules**:

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

### empathy-map.json

Output file: `docs/discovery/user-research.md (append "User Persona" section)`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["empathy_maps"],
  "properties": {
    "empathy_maps": {"type": "array", "description": "Empathy map list, including Says/Thinks/Does/Feels four quadrants"}
  }
}
```

**Output validation rules**:

| Field path | Type | Required | Description |
|----------|------|------|------|
| empathy_maps | array | Yes | Empathy map list, cannot be empty |
| empathy_maps[].persona_id | string | Yes | Linked Persona ID |
| empathy_maps[].persona_name | string | Yes | Linked Persona name |
| empathy_maps[].says | array | Yes | Says quadrant, each item must contain content, source, confidence, ≥2 items |
| empathy_maps[].thinks | array | Yes | Thinks quadrant, each item must contain content, inference_basis, confidence, ≥2 items |
| empathy_maps[].does | array | Yes | Does quadrant, each item must contain content, source, confidence, ≥2 items |
| empathy_maps[].feels | array | Yes | Feels quadrant, each item must contain emotion, intensity, inference_basis, confidence, ≥2 items |

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

### journey-map.json

Output file: `docs/discovery/user-research.md (append "User Persona" section)`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["journey_maps"],
  "properties": {
    "journey_maps": {"type": "array", "description": "User journey map list, including stages, emotion curve, and opportunities"}
  }
}
```

**Output validation rules**:

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

---

## Decision Rules

| Condition | Action |
|------|------|
| Persona overall confidence < 0.5 | Escalate to human validation, mark "needs manual confirmation", do not automatically proceed to subsequent flows |
| Emotional Job inference confidence < 0.5 | Escalate to human validation, mark "emotional need inference pending confirmation" |
| Social Job inference confidence < 0.5 | Escalate to human validation, mark "social need inference pending confirmation" |
| Two Personas have insufficient distinctiveness (trait overlap > 70%) | Merge into 1 Persona or mark "needs manual judgment on whether to split" |
| Clustering quality score < 0.4 | Mark "poor clustering quality", recommend adjusting clustering parameters or supplementing data |

---

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] At least 1 Persona with confidence ≥ 0.7 (satisfied)
- [ ] Each Persona has data support (each field annotated with data source)

### P1 Checks (must pass for standard/deep)

- [ ] Distinctiveness between Personas (trait overlap < 70%)
- [ ] Representative quotes (each Persona ≥ 3 quotes)
- [ ] Empathy Map four quadrants complete (each quadrant ≥ 2 items)
- [ ] Journey Map stages complete (covers core stages)
- [ ] All outputs annotated with confidence (100%)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing upstream input | Degradation plan | Output impact | Data acquisition instructions |
|---------------|---------|---------|------------|
| voice-analysis.json | Infer Persona based on user-described target user traits, annotate "lacks voice data support" | Persona voice traits and pain points based on inference, representative_quotes missing, core_pain_points confidence reduced | Ask user to provide user feedback text or upload voice-analysis.json file |
| behavior-analysis.json | Infer Persona based on user-described user behavior, annotate "lacks behavior data support" | Persona behavior traits and Aha Moment based on inference, key_behaviors confidence reduced, Journey Map behavior data missing | Ask user to provide behavior event logs or upload behavior-analysis.json file |
| voice-analysis.json + behavior-analysis.json | User provides target user description → infer Persona based on description, overall confidence reduced | personas overall confidence reduced, data_source mostly inferred, low_confidence_fields increased | Ask user to provide user feedback text and behavior event logs |
| All upstream files missing | Prompt user to execute preceding stages first, or execute lightweight Persona inference based on user's verbal description | Output is purely inferred Persona, confidence_overall capped at 0.3, all fields annotated as inferred | Ask user to provide target user trait description, behavior patterns, and core pain points |
| If user does not provide survey_data | Skip steps related to this input, Persona demographic information based on inference, annotate "lacks survey data" | Demographic field data_source is inferred, confidence reduced | Ask user to provide user survey data (including demographics, usage habits, etc.) |
| If user does not provide modeling_config | Skip steps related to this input, use default modeling configuration (max Persona count: 4, confidence threshold: 0.5) | Using default configuration, Persona count and threshold may be suboptimal | Ask user to provide modeling parameters such as max Persona count and confidence threshold |

## Data Acquisition Instructions

This Skill requires user voice analysis and behavior analysis data. Please provide via one of the following methods:
  1. Directly paste user description text (target user traits, behavior patterns, etc.)
  2. Upload voice-analysis.json / behavior-analysis.json files
  3. Provide data file paths
- AI is not responsible for external data collection, only for analysis

---

## Upstream Change Response

### Upstream Change Impact

| Upstream Skill | Change type | Impact scope | Response action |
|-----------|---------|---------|---------|
| user-research-voice-analysis | voice-analysis.json structure change | User segments, pain points, theme data format changes | Check input field mapping, adapt to new structure, mark "upstream data format anomaly" if incompatible |
| user-research-voice-analysis | voice-analysis.json content update | Pain point severity, sentiment distribution, segment results change | Re-execute clustering and Persona generation, annotate "rebuilt based on updated data" |
| user-research-behavior-analysis | behavior-analysis.json structure change | Behavior segments, Aha Moment, feature usage data format changes | Check input field mapping, adapt to new structure, mark "upstream data format anomaly" if incompatible |
| user-research-behavior-analysis | behavior-analysis.json content update | Funnel, paths, anomaly detection results change | Re-execute clustering and Persona generation, annotate "rebuilt based on updated data" |

### Downstream Notification Mechanism

| Downstream Skill | Notification trigger condition | Notification method | Notification content |
|-----------|------------|---------|---------|
| user-research-interview-assist | persona.json update complete | Write to output file | Notify that Persona data is ready and can be used for interview script design |
| user-research-report | persona.json / empathy-map.json / journey-map.json update complete | Write to output file | Notify that user modeling data is ready and can be used for report generation |
