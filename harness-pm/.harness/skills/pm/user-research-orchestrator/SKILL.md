---
name: user-research-orchestrator
description: Used when executing a complete user research process. User Research Orchestrator, dispatching voice-analysis/behavior-analysis/user-modeling/interview-assist/report. Keywords: user research, VOC analysis, behavior analysis, Persona, interview assist, user research, user persona, user feedback, user interview.
metadata:
  module: "Product Discovery"
  sub-module: "User Research"
  type: "orchestrator"
  version: "8.2"
  domain_tags: ["General"]
  triggers:
    - "Help me do user research"
    - "Analyze user feedback"
    - "Design a user interview"
    - "Generate user personas"
    - "Understand user behavior"
reads:
  - rules/security.md
  - loops/LOOP.md
  - templates/orchestrator-protocol.md
  - docs/discovery/user-research.md
writes:
  - output/phase-reports/user-research-orchestrator.json
  - memory/progress.md
---

# User Research Orchestrator

## Core Principles

1. **What users say and do differ** — VOC (what users say) and behavior data (what users do) must be collected in parallel and cross-validated; conclusions from a single source are not credible
2. **Modeling is hypothesis, not fact** — Persona/Empathy Map/Journey Map are all assumption models based on data; they must be approved by humans before being used in subsequent processes
3. **Interviews are for validation, not exploration** — The purpose of interviews is to validate existing hypotheses (from VOC and behavior data), not aimless exploration; scripts must anchor on hypotheses to be validated
4. **Reports are both endpoint and starting point** — The user research report is the endpoint of the research phase, but also the starting point for product decisions; reports must include actionable recommendations

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline Definition

```yaml
pipeline: user-research-orchestrator
version: 8.2

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/user-research-orchestrator.json

stages:
  - id: phase-1
    name: "Parallel Collection"
    skills:
      - user-research-voice-analysis
      - user-research-behavior-analysis
    gate:
      condition: "voice-analysis.json + behavior-analysis.json both generated and validation passed"
      fail_action: "Supplement user feedback data or behavior data"

  - id: phase-2
    name: "User Modeling"
    depends_on: [phase-1]
    skills:
      - user-research-user-modeling
    gate:
      condition: "persona.json generated"
      fail_action: "Supplement data or check sub-Skill execution results"

  - id: phase-2b
    name: "Interview Assist"
    depends_on: [phase-2]
    skills:
      - user-research-interview-assist
    gate:
      condition: "interview-script.json generated"
      fail_action: "Supplement data or check sub-Skill execution results"

  - id: phase-3
    name: "Research Report"
    depends_on: [phase-1, phase-2b]
    skills: [user-research-report]
    gate:
      condition: "Executive summary includes 3 core findings + Top 1 recommendation"
      fail_action: "Supplement upstream data and regenerate report"
```

## Stage Execution Plan

### Phase 1: Parallel Collection

#### Call user-research-voice-analysis

```
Skill: user-research-voice-analysis
Inputs:
  app_reviews: user provided (app store reviews)
  support_tickets: user provided (customer support ticket data)
  social_mentions: user provided (optional, social media mentions)
  community_posts: user provided (optional, community posts)
  analysis_config: user provided (optional, analysis config)
Output: docs/discovery/user-research.md (append "User Voice Analysis" section)
Validation: sentiment_distribution non-empty, top_themes at least 3 themes, top_pain_points extracted, confidence annotated
Mode: 🤖
```

#### Call user-research-behavior-analysis

```
Skill: user-research-behavior-analysis
Inputs:
  event_logs: user provided (behavior event logs)
  funnel_data: user provided (funnel data)
  heatmap_data: user provided (optional, heatmap data)
  analysis_config: user provided (optional, analysis config)
Output: docs/discovery/user-research.md (append "User Behavior Analysis" section)
Validation: funnel_health non-empty, aha_moment_candidates extracted, feature_usage analysis complete, confidence annotated
Mode: 🤖
```

⏸ **Stage Gate**: voice-analysis.json + behavior-analysis.json both generated and validation passed → Not passed: Supplement user feedback data or behavior data

### Phase 2: User Modeling

#### Call user-research-user-modeling

```
Skill: user-research-user-modeling
Inputs:
  voice_analysis: docs/discovery/user-research.md (append "User Voice Analysis" section)
  behavior_analysis: docs/discovery/user-research.md (append "User Behavior Analysis" section)
  survey_data: user provided (optional, survey data)
  modeling_config: user provided (optional, modeling config)
Output: docs/discovery/user-research.md (append "User Persona" section) + empathy-map.json + journey-map.json
Validation: personas array non-empty, at least 1 Persona confidence ≥0.7, Empathy Map four quadrants complete, Journey Map stages complete
Mode: 🤖→👤
```

⏸ **Stage Gate**: personas array non-empty, at least 1 Persona confidence ≥0.7 → Not passed: Flag modeling insufficient, recommend supplementing data or conducting interviews

### Phase 2b: Interview Assist

#### Call user-research-interview-assist

```
Skill: user-research-interview-assist
Inputs:
  persona: docs/discovery/user-research.md (append "User Persona" section)
  research_objectives: user provided (research objectives)
  interview_config: user provided (interview config)
  voice_analysis: docs/discovery/user-research.md (append "User Voice Analysis" section)
  behavior_analysis: docs/discovery/user-research.md (append "User Behavior Analysis" section)
Output: docs/discovery/user-research.md (append "Interview Script Record" section) + interview-insights.json
Validation: interview-script.json core_modules non-empty, each core question has follow-up strategies; interview-insights.json validated_hypotheses or new_discoveries non-empty
Mode: 👤→🤖
```

⏸ **Stage Gate**: interview-script.json generated, interview-insights.json generated after interview execution → Not passed: Check whether research objectives and interview config are complete

### Phase 3: Research Report

#### Call user-research-report

```
Skill: user-research-report
Inputs:
  voice_analysis: docs/discovery/user-research.md (append "User Voice Analysis" section)
  behavior_analysis: docs/discovery/user-research.md (append "User Behavior Analysis" section)
  persona: docs/discovery/user-research.md (append "User Persona" section)
  interview_script: docs/discovery/user-research.md (append "Interview Script Record" section)
  research_objectives: user provided (research objectives)
  product_info: user provided (optional, product/category info)
Output: docs/discovery/user-research.md (as summary section or overwrite) + user-research-report.json
Validation: Executive summary includes 3 core findings + Top 1 recommendation, each Persona has representative user quotes, at least 3 action recommendations with priority
Mode: 🤖→👤
```

⏸ **Stage Gate**: Executive summary includes 3 core findings + Top 1 recommendation → Not passed: Supplement upstream data and regenerate report

### Stage Summary (post_pipeline)

After all sub-Skills have executed, a stage summary document must be generated and written to `output/phase-reports/user-research-orchestrator.json`, containing the following 6 structural items (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-Skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-Skill (1-3 items), cross-sub-Skill cross-cutting insights
3. **Decision Records**: Human decision points and decision results, AI automatic decisions and rationale
4. **Deliverables List**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks and TODOs**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-Skill output path | docs/discovery/ |
| Summary output path | output/phase-reports/user-research-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream Handoff:
  primary: insight-analysis (user research complete, distill insights from research data)
  alternatives:
    - target: opportunity-definition
      reason: Research conclusions are clear enough, proceed directly to opportunity definition
      condition: When user research has produced clear pains and needs
    - target: prd-orchestrator
      reason: Research conclusions can directly support PRD generation
      condition: When user research has produced complete user personas and scenarios, and the business model is determined
  special_cases:
    - target: user-research-report
      reason: Only need to generate a research report, no follow-up insight analysis needed
      condition: When the research is a standalone project deliverable and no further analysis is needed

## Stage Gates

| Gate | Condition | Fail Handling |
|------|------|------------|
| phase-1 complete | voice-analysis.json + behavior-analysis.json both generated and non-empty | Supplement user feedback data or behavior data |
| phase-2 complete | persona.json generated and human approval passed | Supplement data or adjust modeling parameters and re-execute |
| phase-2b complete | interview-script.json generated and non-empty | Check whether research objectives and interview config are complete |
| Interview insights extracted | interview-insights.json generated and non-empty | Wait for human to complete interview execution then extract insights |
| phase-3 complete | user-research-report.md + user-research-report.json both generated and non-empty | Check whether upstream data is complete |
| Stage summary generated | output/phase-reports/user-research-orchestrator.json generated and all 6 structural items non-empty | Regenerate after supplementing missing structural items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Persona final confirmation | user-research-user-modeling complete | Confirm whether Persona profile is accurate, correct inferred features |
| Emotional/Social Job inference validation | Persona Emotional/Social Job confidence <0.5 | Confirm whether emotional and social need inferences are reasonable |
| Interview result calibration | user-research-interview-assist complete | Calibrate consistency between interview findings and existing data, arbitrate contradictions |
| User research report conclusions and action recommendations approval | user-research-report complete | Approve final conclusions and action recommendations of the user research report |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| A sub-Skill in phase 1 fails (voice-analysis or behavior-analysis) | Does not block the other sub-Skill; failed sub-Skill uses degradation plan to continue, flagged "degraded execution" |
| voice-analysis data volume insufficient (<500 entries) | Flag "insufficient data", output downgraded to exploratory conclusions, confidence uniformly downgraded, report flags VOC conclusions as exploratory |
| behavior-analysis funnel data incomplete | Complete analyzable parts based on existing data, missing stages flagged "data missing", aha_moment_candidates flagged with low confidence |
| user-modeling all Persona confidence <0.7 | Flag "modeling insufficient", output highest confidence Persona for human approval, recommend supplementing data or conducting interviews before modeling |
| interview-assist interview not executed (human did not complete interview) | interview-insights.json flagged "interview not executed", report generated based on VOC + behavior data + modeling data, flagged "lacks interview validation" |
| All upstream data missing | Downgrade to lightweight process: user describes user persona → generate hypothetical Persona based on description → generate exploratory report |
| Stage summary generation fails | Generate partial summary based on completed sub-Skill outputs, missing items flagged "data missing", does not block orchestration completion |
