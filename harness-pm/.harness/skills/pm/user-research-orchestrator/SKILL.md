---
name: user-research-orchestrator
description: Used when executing a complete user research process. User Research Orchestrator, dispatching voice-analysis/behavior-analysis/user-modeling/interview-assist/report.
---
# User Research Orchestrator

## When to use
- Help me do user research
- Analyze user feedback
- Design a user interview
- Generate user personas
- Understand user behavior
- Keywords: user research, VOC analysis, behavior analysis, Persona, interview assist, user research, user persona, user feedback, user interview

## Inputs
- rules/security.md
- loops/LOOP.md
- templates/orchestrator-protocol.md
- docs/discovery/user-research.md

## Outputs
- output/phase-reports/user-research-orchestrator.json
- memory/progress.md

## Core Principles

1. **What users say and do differ** — VOC (what users say) and behavior data (what users do) must be collected in parallel and cross-validated; conclusions from a single source are not credible
2. **Modeling is hypothesis, not fact** — Persona/Empathy Map/Journey Map are all assumption models based on data; they must be approved by humans before being used in subsequent processes
3. **Interviews are for validation, not exploration** — The purpose of interviews is to validate existing hypotheses (from VOC and behavior data), not aimless exploration; scripts must anchor on hypotheses to be validated
4. **Reports are both endpoint and starting point** — The user research report is the endpoint of the research phase, but also the starting point for product decisions; reports must include actionable recommendations

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

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

  - id: phase-3
    name: "Interview Assist"
    depends_on: [phase-2]
    skills:
      - user-research-interview-assist
    gate:
      condition: "interview-script.json generated"
      fail_action: "Supplement data or check sub-Skill execution results"

  - id: phase-4
    name: "Research Report"
    depends_on: [phase-1, phase-3]
    skills: [user-research-report]
    gate:
      condition: "Executive summary includes 3 core findings + Top 1 recommendation"
      fail_action: "Supplement upstream data and regenerate report"
```

## Phase Execution Plan

> Compact routing table. Sub-skill Inputs/Outputs/Validation live in each sub-skill's SKILL.md — do not duplicate here. "Key upstream" notes only when the input source is non-obvious.

| Phase | Skill | Mode | Gate condition | Fail action |
|-------|-------|------|----------------|-------------|
| phase-1a | user-research-voice-analysis | 🤖 | voice-analysis.json + behavior-analysis.json both generated and validation passed | Supplement user feedback data or behavior data |
| phase-1b | user-research-behavior-analysis | 🤖 | voice-analysis.json + behavior-analysis.json both generated and validation passed | Supplement user feedback data or behavior data |
| phase-2 | user-research-user-modeling | 🤖→👤 | persona.json generated | Supplement data or check sub-Skill execution results |
| phase-3 | user-research-interview-assist | 👤→🤖 | interview-script.json generated | Supplement data or check sub-Skill execution results |
| phase-4 | user-research-report | 🤖→👤 | Executive summary includes 3 core findings + Top 1 recommendation | Supplement upstream data and regenerate report |

### Phase Summary (post_pipeline)

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

## Phase Gates

| Gate | Condition | Fail Handling |
|------|------|------------|
| phase-1 complete | voice-analysis.json + behavior-analysis.json both generated and non-empty | Supplement user feedback data or behavior data |
| phase-2 complete | persona.json generated and human approval passed | Supplement data or adjust modeling parameters and re-execute |
| phase-3 complete | interview-script.json generated and non-empty | Check whether research objectives and interview config are complete |
| Interview insights extracted | interview-insights.json generated and non-empty | Wait for human to complete interview execution then extract insights |
| phase-4 complete | user-research-report.md + user-research-report.json both generated and non-empty | Check whether upstream data is complete |
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
