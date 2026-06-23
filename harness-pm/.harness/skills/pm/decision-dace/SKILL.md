---
name: decision-dace
description: Use when you need to execute a data-driven decision loop or transform data into actionable insights. DACE cycle automation, where Define/Analyze is automatically executed by AI, Conclude is AI-assisted human decision-making, and Execute is tracked by AI for execution effectiveness. The Analyze phase integrates insight transformation capabilities, transforming analysis results into narrative insights, decision recommendations, and decision boundary annotations. Keywords: DACE cycle, data decision, decision loop, data-driven, decision framework, decision cycle, data analysis loop, making decisions with data, decision process, how to use data to drive action, data insights, insight transformation, decision recommendations, narrative analysis, data story, can't understand data, turn data into human language, what the data says.
metadata:
  module: "Product Metrics & Operations"
  sub-module: "Decision Loop"
  type: "pipeline"
  version: "2.0"
  domain_tags: ["General"]
  trigger_examples:
    - "Help me make a data decision using the DACE method"
    - "How to do a complete loop from data to action"
    - "Data was analyzed but no one executes, what to do"
    - "What does this data say, help me interpret it"
    - "Turn analysis results into a tellable story"
    - "The data is too dry, help me transform it into actionable recommendations"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Only output decision recommendations and key rationale"
  deep_description: "Complete analysis + decision tree + sensitivity analysis + counterfactual reasoning"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/strategy/OKR.md
  - docs/metrics/experiment-report.md
  - docs/metrics/data-analysis-report.md
  - docs/metrics/decision-report.md
writes:
  - docs/metrics/decision-report.md
  - memory/progress.md
  - memory/knowledge-base.md
---

# DACE Cycle Automation (with Insight Transformation)

## Core Principles

1. **Define is direction, Analyze is evidence**: Analysis without clear goals and decisions without evidence support are equally dangerous
2. **Conclude authority belongs to humans, Execute tracking belongs to the system**: AI provides options and boundaries, humans make final decisions, the system tracks execution effectiveness
3. **A loop is complete**: DACE is indispensable; Conclude without Execute is empty talk, Conclude without Analyze is gambling
4. **Data is the starting point, insight is the endpoint, action is the purpose**: Insights without action direction are just data display
5. **Narrative over terminology**: Translate "p=0.001" into "99.9% confidence", so decision-makers can understand and act
6. **Boundary annotation is more important than recommendation**: Clearly marking what can be auto-executed and what requires human confirmation is more valuable than simple recommendations

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| OKR Data | object | Yes | User-provided | Objectives and Key Results, baseline values and target values |
| KR Progress | object | Yes | docs/strategy/OKR.md | Current progress and deviation analysis for each KR |
| Experiment Results | object | Yes | docs/metrics/experiment-report.md ("Experiment Results" section) | A/B test results, anomaly detection data |
| Analysis Results - Anomaly | object | Yes | docs/metrics/data-analysis-report.md ("Anomaly Analysis" section) | Anomaly report |
| Analysis Results - Funnel | object | Yes | docs/metrics/data-analysis-report.md ("Funnel Analysis" section) | Funnel report |
| Analysis Results - Retention | object | Yes | docs/metrics/data-analysis-report.md ("Retention Analysis" section) | Retention report |
| Business Context | object | ○ | User-provided | Product stage, team goals |
| Historical Insight Library | object[] | ○ | docs/metrics/decision-report.md ("DACE Decisions" section) | Avoid duplication |

## Execution Steps

### DACE Four Phases

```
┌────────────────────────────────────────────────────────┐
│                     DACE Cycle                          │
├────────────────────────────────────────────────────────┤
│                                                        │
│   ┌─────────┐                                          │
│   │  Define │  Define goals and success metrics        │
│   └────┬────┘                                          │
│        │                                                │
│        ▼                                                │
│   ┌─────────┐                                          │
│   │ Analyze │  Insight generation: data→story→decision │
│   └────┬────┘                                          │
│        │                                                │
│        ▼                                                │
│   ┌─────────┐                                          │
│   │Conclude │  Draw conclusions and decision recommendations  ◀──┐  │
│   └────┬────┘                                          │  │
│        │                                               │  │
│        ▼                                               │  │
│   ┌─────────┐                                          │  │
│   │ Execute │  Execute strategy and track effectiveness ─┘  │
│   └─────────┘       │                                    │  │
│        │            │                                    │  │
│        ▼            │                                    │  │
│   Return to Analyze ◀─────┘                              │  │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### Step 1: Define 🤖 [Core]

Automatically establish the OKR tracking system, define goals and success metrics (primary/supporting/guardrail).

> 📋 See [Reference/step-define-conclude-execute.md](./Reference/step-define-conclude-execute.md) for details

### Step 2: Analyze (Insight Generation) 🤖 [Core]

Narrative insight transformation, decision recommendations, decision boundaries, confidence assessment. Integrates the insight transformation capability of the original decision-insight, transforming analysis results into narrative insights.

#### 2.1 Data Collection and Analysis [Core]

Automatically collect and analyze data (metrics/experiments/events), perform anomaly detection, experiment summarization, and funnel analysis.

> 📋 See [Reference/step-analyze.md](./Reference/step-analyze.md) for details

#### 2.2 From Numbers to Stories [Core]

Transform data analysis into business narrative, using business language rather than data terminology.

> 📋 See [Reference/step-analyze.md](./Reference/step-analyze.md) (includes data language → business language mapping table and narrative templates)

#### 2.3 Decision Recommendation Generation [Conditional]

Generate multiple actionable decision options (including expected effects, risks, confidence, resource requirements, timeline, prerequisites).

> 📋 See [Reference/step-analyze.md](./Reference/step-analyze.md) for details

#### 2.4 Decision Boundary Annotation [Deep]

Distinguish data_decision / data_reference / human_decision, annotate auto-execution eligibility and human oversight requirements.

> 📋 See [Reference/step-analyze.md](./Reference/step-analyze.md) for details

#### 2.5 Insight Summary [Conditional]

Summarize generated insights and their confidence and sources.

> 📋 See [Reference/step-analyze.md](./Reference/step-analyze.md) for details

### Step 3: Conclude (Decision Options) 🤖→👤 [Core]

AI-assisted human decision-making: AI generates decision recommendations (including priority, rationale, expected results, risk level), humans make the final decision.

> 📋 See [Reference/step-define-conclude-execute.md](./Reference/step-define-conclude-execute.md) for details

### Step 4: Execute (Execution Tracking) 🤖 [Conditional]

Track execution effectiveness, monitor core metrics and guardrail metrics, set monitoring alert thresholds.

> 📋 See [Reference/step-define-conclude-execute.md](./Reference/step-define-conclude-execute.md) for details

## DACE Status Tracking

Track current phase, phase history, insight statistics, action statistics, result statistics.

> 📋 See [Reference/status-and-config.md](./Reference/status-and-config.md) for details

## Auto-trigger Mechanism

> 📋 See [Reference/status-and-config.md](./Reference/status-and-config.md) (includes trigger condition → DACE response mapping table)

## OKR Tracking Configuration

> 📋 See [Reference/status-and-config.md](./Reference/status-and-config.md) (includes update frequency and alert rules)

## Insight Type Handling

Generate corresponding narratives and decision options for different insight types such as anomaly insights and funnel insights.

> 📋 See [Reference/insight-types.md](./Reference/insight-types.md) for details

## Output

**Storage path**: `docs/metrics/decision-report.md ("DACE Decisions" section)`

### Output Depth Tiering

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Decision recommendations + key rationale | Core conclusions + minimum viable output, only outputs Define conclusions and Conclude recommended options |
| standard | Complete decision analysis (current default) | Complete output, including all four DACE phases |
| deep | Complete analysis + extended analysis | Complete output + decision tree + sensitivity analysis + counterfactual reasoning + decision records + risk assessment |

**Output files**: dace_status.json, okr_tracking.json, action_log.json, dace_cycle_report.md, decision_insight.json, insight_library.json

> 📋 For output schema, insight output examples, output file structure, and output validation rules, see [Reference/output-schemas.md](./Reference/output-schemas.md)

## Output Validation Rules

> 📋 See [Reference/output-schemas.md](./Reference/output-schemas.md) (includes field path, type, required, description validation table)

## Upstream Change Response

When upstream inputs change, adjust the corresponding phase according to the response strategy; when DACE status/insights themselves change, notify downstream decision-culture according to the notification mechanism.

> 📋 See [Reference/upstream-response.md](./Reference/upstream-response.md) (includes upstream change response strategy table and downstream notification mechanism table)

---

## Decision Rules

| Situation | Handling |
|------|----------|
| KR progress behind >20% | Trigger Conclude, generate decision recommendations |
| KR cannot be completed | Escalation + OKR adjustment recommendations |
| Experiment results statistically significant | Automatically enter Conclude phase |
| Guardrail metrics breached | Pause Execute, revert to Analyze |
| Insight confidence ≥0.8 + no decline in guardrail metrics | Mark auto_execute_eligible, notify execution |
| Insight confidence ≥0.8 + uncertainty in guardrail metrics | Mark data_reference, requires human confirmation |
| Insight confidence 0.5-0.8 | Mark data_reference, requires human confirmation |
| Insight confidence <0.5 | Mark human_decision, human-led |
| Insight involves strategic considerations (impact ≥3 OKRs) | Mark human_decision, human-led |
| ≥3 independent insights point to the same conclusion | Merge insights, confidence +0.15 |
| 2 insights point to the same conclusion | Merge insights, confidence +0.1 |
| Insight involves revenue impact ≥10% | Force mark human_decision |

## Quality Check

### P0 Check (quick/standard/deep must all pass)

- [ ] Define phase goals are quantifiable, with baselines
- [ ] Analyze phase covers all data sources
- [ ] Conclude phase provides at least 2 decision options

### P1 Check (standard/deep must pass)

- [ ] Execute phase sets monitoring and rollback mechanisms
- [ ] Insight narrative uses business language rather than data terminology
- [ ] Each insight provides at least 2 decision options
- [ ] Recommended actions have clear next steps and owners

### P2 Check (only deep must pass)

- [ ] Decision boundary annotation is correct (auto/reference/human)
- [ ] Decision tree generated (each option branch and probability assessment)
- [ ] Sensitivity analysis completed (impact of key variables on decision conclusions)
- [ ] Counterfactual reasoning completed (expected outcome inference if other options were chosen)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| OKR tracking missing | User provides current metric data → Execute DACE analysis | Define phase goal definition based on user description |
| Anomaly detection missing | Skip anomaly triggers in Analyze phase, execute based on user-provided metric data | Analysis dimensions limited, may miss unattended anomalies |
| Both OKR tracking and anomaly detection missing | User provides current metric data → Execute DACE analysis | Output based on user data DACE analysis, Define and Analyze annotated "to be supplemented" |
| Analysis results missing | User provides data findings → Transform into insights | Insights based on user description, may lack in-depth attribution |
| Experiment results missing | Skip experiment-related insight transformation | Experiment insight dimension missing |
| Both analysis results and experiment results missing | User provides data findings → Transform into insights | Output based on user description insights, attribution and decision boundaries annotated "to be supplemented" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Current metric data**: Current values, baseline values, and target values for key metrics
- **Business goals** (optional): Business priorities and decision needs for the current stage
- **Known issues** (optional): Anomalies already discovered or issues pending decision
- **Data findings** (optional): Observed data changes, trends, or anomalies
- **Expected decision direction** (optional): Types of decisions that insights should support

## Execution Frequency

| Phase | Execution Frequency | Trigger Method |
|-------|---------|---------|
| Define | Quarterly/OKR change | Automatic |
| Analyze | Continuous | Scheduled + event |
| Conclude | On demand | Analysis complete |
| Execute | Continuous | Decision approved |
