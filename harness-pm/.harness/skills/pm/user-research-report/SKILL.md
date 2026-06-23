---
name: user-research-report
description: Used when a complete user research report is needed. Auto-generates a user research report by integrating user voice analysis, behavior analysis, user modeling, and interview data, supplemented with research methodology notes and actionable recommendations, and outputs a structured Markdown report. Keywords: user research report, user study report, user insight report, research report, user analysis report, study report, user analysis, generate report.
metadata:
  module: "Product Discovery"
  sub-module: "User Research"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["General"]
  triggers:
    - "Help me generate a user research report"
    - "How to organize the user research findings"
    - "Produce a user analysis report"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output research conclusions and recommendations"
  deep_description: "Full report + research methodology reflection + in-depth insight analysis + action recommendation roadmap"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/discovery/user-research.md
writes:
  - docs/discovery/user-research.md
  - memory/progress.md
---

# User Research Report Auto-Generation

## Core Principles

1. **Insights over data** — Data is evidence, insights are conclusions; every piece of data must answer "what does this mean for the product"
2. **User voice first** — Directly quote user verbatims; they are more persuasive than AI summaries
3. **Action-oriented** — Research is not the goal; driving product improvement is
4. **Methodology transparency** — The credibility of research conclusions depends on the transparency of the methodology

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| User voice analysis | JSON | ○ | docs/discovery/user-research.md (append "User Voice Analysis" section) | Sentiment distribution, theme clustering, pain point extraction |
| Behavior analysis | JSON | ○ | docs/discovery/user-research.md (append "User Behavior Analysis" section) | Funnel health, Aha Moment, feature usage depth |
| User modeling | JSON | ○ | docs/discovery/user-research.md (append "User Persona" section) | Persona, Empathy Map, Journey Map |
| Interview data | JSON | ○ | docs/discovery/user-research.md (append "Interview Script Records" section) | Interview scripts, interview records, insight extraction |
| Research objectives | string | Yes | User-provided | Core questions this research aims to answer |
| Product/category info | string | ○ | User-provided | Product name, category, target market |

## Execution Steps

### Step 1: Research Background & Objectives [Core]

Based on the research objectives and product information provided by the user, clarify:

- Research background: Why this research is being conducted
- Core research questions: 3-5 key questions to answer
- Research scope: Target user group, product scope, time range
- Research methodology overview: Which methods were used (VOC analysis / behavior analysis / interviews / surveys)

### Step 2: User Persona Integration [Core]

Integrate persona.json data to generate a readable user persona section:

| Persona element | Data source | Report presentation |
|----------|---------|---------|
| Demographics | persona → demographics | Demographic description |
| Behavioral traits | docs/discovery/user-research.md (append "User Behavior Analysis" section) | Usage habit description |
| Goals & motivations | persona → goals | Quote + summary |
| Pain points & frustrations | docs/discovery/user-research.md (append "User Voice Analysis" section) | Quote + frequency annotation |
| Empathy map | persona → empathy_map | Mind map description |

**Persona quantity rules**:
- 2-4 core Personas
- Each Persona annotated with representative user quotes (at least 2)

### Step 3: User Journey Integration [Core]

Integrate Journey Map and behavior data:

**Journey stage division**:
```
Awareness → Evaluation → First Use → Deep Use → Churn/Renewal
```

Each stage includes:

| Dimension | Content |
|------|------|
| User behavior | What users actually do (supported by behavior data) |
| Touchpoints | Interaction points with the product |
| Emotion curve | Peaks / valleys / key moments |
| Pain points | Core obstacles at this stage |
| Opportunities | Room for improvement |

**Key metric embedding**:
- Funnel conversion rate (from behavior-analysis)
- Aha Moment trigger conditions
- Churn warning signals

### Step 4: Insight Extraction [Core]

Extract core insights from all upstream data:

**Insight extraction rules**:
- Each insight = Observation + Evidence + Product implication
- Evidence must be annotated with source (VOC / behavior / interview)
- Insights sorted by impact scope: Global > Local

**Insight categories**:

| Category | Description | Example |
|------|------|------|
| Need insight | What users really want | "Users don't want a faster horse; they want a shorter commute" |
| Pain point insight | The essence of core obstacles | "It's not that features are missing; it's that features can't be found" |
| Behavior insight | Actual user behavior vs. expected | "Users who don't complete the first action within 3 days of registration have an 87% churn rate" |
| Opportunity insight | Unmet need space | "40% of users abandon after search; there's an opportunity in intent understanding" |

### Step 5: Action Recommendations [Core]

Generate executable product improvement recommendations based on insights:

| Recommendation element | Requirement |
|----------|------|
| Recommendation description | Specific enough to be actionable |
| Linked insight | Reference the supporting insight ID |
| Expected impact | Impact assessment on core metrics |
| Priority | P0 (must do) / P1 (should do) / P2 (could do) |
| Validation method | How to validate the improvement effect |

**Priority derivation rules**:
- Pain points affecting the core funnel → P0
- Obstacles affecting retention/engagement → P1
- Experience optimization recommendations → P2

### Step 6: Report Assembly [Core]

Integrate all sections into a complete Markdown report:

**Report structure**:

```
# {Product Name} User Research Report

## Executive Summary
- Research overview (one paragraph)
- 3 core findings
- Top 1 action recommendation

## 1. Research Background & Methodology
- Research objectives
- Research questions
- Research methods & sample
- Data sources & limitations

## 2. User Personas
### 2.1 Core User Group A: {Name}
- Demographics
- Goals & motivations
- Core pain points
- Representative quotes
### 2.2 Core User Group B: {Name}
- ...

## 3. User Journey
- Journey overview
- Stage-by-stage analysis
- Key moments (Aha Moment / churn points)
- Emotion curve

## 4. Core Insights
### 4.1 Need insights
### 4.2 Pain point insights
### 4.3 Behavior insights
### 4.4 Opportunity insights

## 5. Action Recommendations
| Priority | Recommendation | Linked insight | Expected impact | Validation method |
|--------|------|---------|---------|---------|

## Appendix
- Data source list
- Detailed research methodology
- Sample description & limitations
```

### Output Depth Tiers

| Depth level | Output scope | Description |
|----------|----------|------|
| quick | Research conclusions and recommendations | Core conclusions + minimum viable deliverable |
| standard | Full deliverable (current default) | Complete deliverable, including all Step outputs |
| deep | Full report + research methodology reflection + in-depth insight analysis + action recommendation roadmap | Full deliverable + extended analysis + deep inference |

## Output

**Storage path**: `docs/discovery/user-research.md (as summary section or overwrite)`

**Output files**:

| File | Format | Description |
|------|------|------|
| user-research-report.md | Markdown | Complete user research report |
| user-research-report.json | JSON | Structured data (for downstream Skill reference) |

**user-research-report.json structure**:

**Output Schema**:

```json
{
  "type": "object",
  "required": ["report_metadata", "executive_summary", "personas", "insights", "recommendations"],
  "properties": {
    "report_metadata": {"type": "object", "description": "Report metadata, including product name, research objectives, and confidence"},
    "executive_summary": {"type": "object", "description": "Executive summary, including overview, key findings, and top recommendation"},
    "personas": {"type": "array", "description": "User persona list"},
    "journey": {"type": "object", "description": "User journey, including stages, emotion curve, and key moments"},
    "insights": {"type": "array", "description": "Core insight list"},
    "recommendations": {"type": "array", "description": "Action recommendation list"}
  }
}
```

**Output validation rules**:

| Field path | Type | Required | Description |
|----------|------|------|------|
| report_metadata | object | Yes | Report metadata |
| report_metadata.product | string | Yes | Product name |
| report_metadata.research_goals | string[] | Yes | Research objectives list, cannot be empty |
| report_metadata.generated_at | string | Yes | Generation timestamp |
| report_metadata.data_sources | string[] | Yes | Data source list |
| report_metadata.overall_confidence | number | Yes | Overall confidence, 0-1 |
| executive_summary | object | Yes | Executive summary |
| executive_summary.overview | string | Yes | Research overview, one paragraph |
| executive_summary.key_findings | string[] | Yes | Key findings, must be ≥3 |
| executive_summary.top_recommendation | string | Yes | Top 1 action recommendation |
| personas | array | Yes | User persona list, 2-4 personas |
| personas[].name | string | Yes | User group name |
| personas[].demographics | object | No | Demographic information |
| personas[].goals | string[] | No | Goals & motivations list |
| personas[].pain_points | string[] | No | Core pain points list |
| personas[].quotes | string[] | Yes | Representative quotes, each Persona ≥2 |
| journey | object | No | User journey |
| journey.stages | array | No | Journey stage list |
| journey.stages[].name | string | Yes | Stage name |
| journey.stages[].behaviors | string[] | Yes | User behaviors |
| journey.stages[].touchpoints | string[] | No | Touchpoint list |
| journey.stages[].emotion_peak | string | No | Emotion peak description |
| journey.stages[].emotion_valley | string | No | Emotion valley description |
| journey.stages[].pain_points | string[] | Yes | Pain points |
| journey.stages[].opportunities | string[] | Yes | Opportunities |
| journey.stages[].metrics | object | No | Key metrics (conversion rate, retention rate, etc.) |
| journey.aha_moment | string | No | Aha Moment description |
| journey.churn_signals | string[] | No | Churn signal list |
| insights | array | Yes | Core insight list, ≤15 items |
| insights[].id | string | Yes | Insight ID, format INS-XXX |
| insights[].category | string | Yes | Insight category enum: need/pain_point/behavior/opportunity |
| insights[].observation | string | Yes | Observation description |
| insights[].evidence | string | Yes | Evidence and source |
| insights[].implication | string | Yes | Product implication |
| insights[].scope | string | Yes | Impact scope enum: global/local |
| recommendations | array | Yes | Action recommendation list, ≥3 items |
| recommendations[].id | string | Yes | Recommendation ID, format REC-XXX |
| recommendations[].description | string | Yes | Recommendation description |
| recommendations[].linked_insights | string[] | Yes | Linked insight ID list |
| recommendations[].expected_impact | string | Yes | Expected impact |
| recommendations[].priority | string | Yes | Priority enum: P0/P1/P2 |
| recommendations[].validation_method | string | Yes | Validation method |

```json
{
  "report_metadata": {
    "product": "Product Name",
    "research_goals": [],
    "generated_at": "Timestamp",
    "data_sources": [],
    "overall_confidence": 0.0
  },
  "executive_summary": {
    "overview": "One paragraph",
    "key_findings": [],
    "top_recommendation": ""
  },
  "personas": [
    {
      "name": "User group name",
      "demographics": {},
      "goals": [],
      "pain_points": [],
      "quotes": []
    }
  ],
  "journey": {
    "stages": [
      {
        "name": "Stage name",
        "behaviors": [],
        "touchpoints": [],
        "emotion_peak": "",
        "emotion_valley": "",
        "pain_points": [],
        "opportunities": [],
        "metrics": {}
      }
    ],
    "aha_moment": "",
    "churn_signals": []
  },
  "insights": [
    {
      "id": "INS-001",
      "category": "need/pain_point/behavior/opportunity",
      "observation": "Observation description",
      "evidence": "Evidence and source",
      "implication": "Product implication",
      "scope": "global/local"
    }
  ],
  "recommendations": [
    {
      "id": "REC-001",
      "description": "Recommendation description",
      "linked_insights": ["INS-001"],
      "expected_impact": "Expected impact",
      "priority": "P0/P1/P2",
      "validation_method": "Validation method"
    }
  ]
}
```

## Decision Rules

| Condition | Decision |
|------|------|
| All upstream data missing | Generate report based on research objectives and AI knowledge base, annotate "lacks empirical data, recommend supplementary research" |
| Only VOC data available | Focus on sentiment and pain point insights, annotate behavior insights with "lacks behavior data" |
| Only behavior data available | Focus on funnel and usage depth, annotate need insights with "lacks user voice data" |
| Persona count > 6 | Sort by user volume, take Top 4 |
| Insight count > 15 | Sort by impact scope and priority, take Top 10 |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Executive summary includes 3 key findings + Top 1 recommendation
- [ ] Each Persona has representative user quotes

### P1 Checks (must pass for standard/deep)

- [ ] User journey includes emotion curve and key moments
- [ ] Each insight has the three elements: observation + evidence + implication
- [ ] At least 3 action recommendations, each with priority and validation method
- [ ] Data sources and limitations are explained

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

| Missing upstream input | Degradation plan | Output impact | Data acquisition instructions |
|---------------|---------|---------|------------|
| voice-analysis missing | User personas and pain points based on behavior data and AI inference | Pain point insights lack user quote support | Ask user to provide user feedback text or upload voice-analysis.json file |
| behavior-analysis missing | Journey and behavior insights based on VOC and interview data | Behavior insights lack quantitative data | Ask user to provide behavior event logs or upload behavior-analysis.json file |
| persona missing | Derive user personas from VOC and behavior data | Personas may be less refined | Ask user to provide target user persona description or upload persona.json file |
| interview data missing | Insights based on VOC and behavior data | Lacks in-depth qualitative insights | Ask user to provide interview record text or upload interview data file |
| All upstream data missing | Generate based on research objectives and AI knowledge base, overall confidence reduced | Report requires substantial human supplementation and validation | Ask user to provide research objectives, target user description, and product information |
| If user does not provide research objectives | Prompt user to provide research objectives, otherwise the report focus cannot be determined | Cannot generate a targeted report | Ask user to provide research objectives (e.g., "understand user payment decision factors") |
| If user does not provide product/category info | Skip steps related to this input, product-related descriptions in the report are based on inference | Product background description may be inaccurate | Ask user to provide product name, category, and core feature description |

---

## Upstream Change Response

### Upstream Change Impact

| Upstream Skill | Change type | Impact scope | Response action |
|-----------|---------|---------|---------|
| user-research-voice-analysis | voice-analysis.json structure change | Sentiment distribution, pain points, theme data format changes | Check input field mapping, adapt to new structure, mark "upstream data format anomaly" if incompatible |
| user-research-voice-analysis | voice-analysis.json content update | Pain point severity, sentiment distribution, segment results change | Re-integrate user personas and pain point insights, annotate "rebuilt based on updated data" |
| user-research-behavior-analysis | behavior-analysis.json structure change | Funnel, Aha Moment, feature usage data format changes | Check input field mapping, adapt to new structure, mark "upstream data format anomaly" if incompatible |
| user-research-behavior-analysis | behavior-analysis.json content update | Funnel health, behavior paths, anomaly detection results change | Re-integrate user journey and behavior insights, annotate "rebuilt based on updated data" |
| user-research-user-modeling | persona.json structure change | Persona field mapping changes | Check input field mapping, adapt to new structure, mark "upstream data format anomaly" if incompatible |
| user-research-user-modeling | persona.json content update | Persona traits, pain points, JTBD change | Re-integrate user persona section, annotate "rebuilt based on updated Persona" |
| user-research-interview-assist | interview-insights.json structure change | Interview insights, cross-interview pattern data format changes | Check input field mapping, adapt to new structure, mark "upstream data format anomaly" if incompatible |
| user-research-interview-assist | interview-insights.json content update | Validated/disproved hypotheses, new findings, Persona updates change | Re-integrate insights and action recommendations, annotate "rebuilt based on updated interview data" |

### Downstream Notification Mechanism

This Skill is a terminal Skill with no downstream dependencies and does not involve downstream notifications.
