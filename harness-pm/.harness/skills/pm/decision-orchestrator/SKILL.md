---
name: decision-orchestrator
description: Use when you need to transform data analysis results into decision actions. Data-driven decision commander, orchestrating decision-dace (DACE decision cycle + insight transformation) and decision-culture (data culture building), achieving a closed loop from data to decisions. Keywords: data decision, DACE cycle, data insights, decision framework, data culture, decision-dace, decision-culture, data-driven, decision support.
metadata:
  module: "Product Metrics & Operations"
  sub-module: "Decision Loop"
  type: "orchestrator"
  version: "7.0"
  domain_tags: ["General"]
  triggers:
    - "Make decisions based on data"
    - "Build a data-driven decision mechanism"
    - "Transform analysis results into actions"
    - "Drive data culture building"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/metrics/decision-report.md
writes:
  - output/phase-reports/decision-orchestrator.json
  - memory/progress.md
  - memory/knowledge-base.md
---

# Data-driven Decision Commander

## Core Principles

**Data-driven decisions, but decision authority belongs to humans**

The role of data is to illuminate blind spots in decision-making, not to replace decision-makers. In the DACE cycle, Define and Analyze are data-driven, Conclude is human-decided, and Execute is system-tracked — this is the optimal division of labor between data and humans.

## Orchestration Philosophy

1. **DACE cycle is the main line, insights are embedded, culture is the support**: The DACE cycle drives the decision loop, the Analyze phase has integrated insight transformation capabilities, and culture building ensures decision implementation
2. **The Conclude phase must have human participation**: No matter how clear the data is, decisions involving business strategy must be confirmed by humans
3. **Decision boundary tiered transmission**: data_decision auto-executes, data_reference pushes for confirmation, human_decision waits for approval

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: decision-orchestrator
version: 7.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/decision-orchestrator.json

stages:
  - id: phase-1
    name: "DACE Decision Cycle"
    depends_on: []
    skills: [decision-dace]
    gate:
      condition: "Goals defined, data analyzed, insights generated, decision options provided"
      fail_action: "Supplement data or redefine goals"

  - id: phase-2
    name: "Data Culture Building"
    depends_on: [phase-1]
    skills: [decision-culture]
    gate:
      condition: "Reporting system operating normally (daily/weekly/monthly/quarterly)"
      fail_action: "Check upstream data sources or adjust report templates"
```

## Phase Execution Plan

#### Call decision-dace

```
Skill: decision-dace
Input:
  okr_data: User-provided
  kr_progress: analysis-anomaly → anomaly_report.json
  experiment_result: experiment-execution → experiment_result.json
  analysis_result: analysis-anomaly → anomaly_report.json
  business_context: User-provided (optional)
  insight_library: decision-dace → insight_library.json (optional)
Output: docs/metrics/decision-report.md ("DACE Decisions" section)
Validation: Define phase goals quantifiable with baselines; Analyze phase covers all data sources; Conclude phase provides at least 2 decision options; Execute phase sets monitoring and rollback mechanisms; Insight narrative uses business language rather than data terminology; Each insight provides at least 2 decision options; Decision boundary annotation correct (auto/reference/human); Recommended actions have clear next steps and owners
Mode: 🤖→👤
```

#### Call decision-culture

```
Skill: decision-culture
Input:
  okr_data: decision-dace → dace_status.json
  decision_records: decision-dace → decision_insight.json
  team_feedback: User-provided (optional)
Output: docs/metrics/decision-report.md ("Data Culture" section)
Validation: Daily summary produces no noisy alerts when no anomalies exist; Weekly report includes OKR progress and experiment summary; Monthly report includes complete metric trends and deviation analysis; All data references in reports are traceable to data sources
Mode: 🤖→👤
```

### Phase Summary (post_pipeline)

After all sub-skills have executed, a phase summary document must be generated and written to `output/phase-reports/decision-orchestrator.json`, containing the following 6 structures (none can be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automatic decisions and rationale
4. **Output List**: All output file paths and content summaries, output quality assessment (whether validation passed)
5. **Risks & Todos**: Items that failed validation, items executed in degraded mode, recommended follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/metrics/ |
| Summary output path | output/phase-reports/decision-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: prd-orchestrator (Decision complete, transform decision conclusions into PRD changes)
  alternatives:
    - target: experiment-orchestrator
      reason: Decision needs A/B test to validate effectiveness
      condition: When decision conclusions require quantitative validation
    - target: iteration-orchestrator
      reason: Decision involves iteration priority adjustment
      condition: When decision conclusions affect the iteration plan
  special_cases:
    - target: decision-dace
      reason: Only need DACE decision cycle, no need for full decision orchestration
      condition: When analysis conclusions already exist and only a quick decision loop is needed

## Phase Gates

| Gate | Condition | Failure Handling |
|------|------|------------|
| DACE cycle Define/Analyze complete | decision-dace output file generated and non-empty | Supplement data or redefine goals |
| Decision options provided | decision-dace output file generated and non-empty | Mark as pending, continue tracking |
| Data culture reporting system running | decision-culture output file generated and non-empty | Check upstream data sources or adjust report templates |
| Phase summary generated | output/phase-reports/decision-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structure items |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Conclude phase decision | DACE cycle enters Conclude phase | Review analysis conclusions, make final decision |

## Decision Boundary Management

| Decision Type | Description | Execution Method |
|---------|------|---------|
| data_decision | Data clearly supports, can auto-execute | AI auto-executes + post-hoc report |
| data_reference | Data for reference, human decision | Push insights, wait for decision |
| human_decision | Complex decision, human-led | Provide analysis, human decides |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| DACE cycle Conclude phase human not responding | Pause Execute phase, retain Conclude state, support resuming after human returns |
| Insight confidence too low (<0.5) | Mark as human_decision, do not auto-transmit to culture report, wait for human confirmation |
| OKR data missing | Degrade to user-provided metric data for DACE execution, annotate "OKR data to be supplemented" |
| Decision boundary annotation conflict | Mark conflicting items, pause auto-execution, submit for human arbitration |
| Culture reporting system data source interruption | Skip affected reports, annotate "data source interrupted", other reports generated normally |
| Phase summary generation failed | Generate partial summary based on completed sub-skill outputs, mark missing items as "data missing", do not block orchestration completion |
