---
name: user-research-user-modeling
description: Used when generating Persona, Empathy Map, and Journey Map from user voice analysis and behavior analysis results. User modeling auto-generation pipeline. Keywords: user modeling, Persona generation, empathy map, user journey map, user persona, typical user, user role, what users look like.
---
# User Modeling Auto-Generation

## When to use
- Help me create user personas
- How to map the user journey
- What kind of users are they

## Outputs
- docs/discovery/user-research.md
- memory/progress.md

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

> See [Reference/examples.md](./Reference/examples.md#input-format) for the input format JSON schema and input dependencies.

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

**Output Schema & Validation Rules**: See [Reference/output-schema.md](./Reference/output-schema.md#personajson-output-schema) for the persona.json JSON schema and field-level validation rules.

**Output Example**: See [Reference/examples.md](./Reference/examples.md#personajson-example) for a populated persona.json example.

### empathy-map.json

Output file: `docs/discovery/user-research.md (append "User Persona" section)`

**Output Schema & Validation Rules**: See [Reference/output-schema.md](./Reference/output-schema.md#empathy-mapjson-output-schema) for the empathy-map.json JSON schema and field-level validation rules.

**Output Example**: See [Reference/examples.md](./Reference/examples.md#empathy-mapjson-example) for a populated empathy-map.json example.

### journey-map.json

Output file: `docs/discovery/user-research.md (append "User Persona" section)`

**Output Schema & Validation Rules**: See [Reference/output-schema.md](./Reference/output-schema.md#journey-mapjson-output-schema) for the journey-map.json JSON schema and field-level validation rules.

**Output Example**: See [Reference/examples.md](./Reference/examples.md#journey-mapjson-example) for a populated journey-map.json example.

---

## Decision Rules

> See [Reference/decision-tables.md](./Reference/decision-tables.md#decision-rules) for the decision rules table (Persona confidence thresholds, distinctiveness checks, clustering quality).

## Quality Checks

> See [Reference/decision-tables.md](./Reference/decision-tables.md#quality-checks) for the detailed P0 / P1 / P2 quality check items.

---

## Degradation Strategy

> See [Reference/decision-tables.md](./Reference/decision-tables.md#degradation-strategy) for the upstream file missing degradation plan and data acquisition instructions.

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md#upstream-change-response) for the upstream change impact table and downstream notification mechanism table.
