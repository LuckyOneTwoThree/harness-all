---
name: release-orchestrator
description: Used when executing the product release delivery process. Release Delivery Commander that orchestrates the complete release flow of quality acceptance, release checklist, canary release, and release notes. Keywords: product release, launch, canary, release checklist, release notes, delivery, acceptance release.
metadata:
  module: "Product Monitoring & Iteration"
  sub-module: "Release Delivery"
  type: "orchestrator"
  version: "9.0"
  domain_tags: ["General"]
  triggers:
    - "Release product"
    - "Canary launch"
    - "Execute release process"
    - "Release after acceptance"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/monitoring/release-notes.md
writes:
  - output/phase-reports/release-orchestrator.json
  - memory/progress.md
  - memory/knowledge-base.md
---

# Release Delivery Commander

## Core Principles

1. **Quality is the prerequisite for release**—P0 issues = 0 before entering the release process
2. **Progressive delivery**—canary → small traffic → full rollout, with monitoring at every step
3. **Rollback capability is the baseline**—every release step must have a corresponding rollback plan

## Orchestration Philosophy

1. **Quality gate first, progressive delivery follows**: First pass quality acceptance to ensure release prerequisites, then gradually increase traffic per canary strategy
2. **Checklist as safety net, rollback plan as backup**: Release checklist ensures no omissions; every canary step has rollback capability

## Orchestration Protocol

Follows the [orchestrator-protocol.md](../../../templates/orchestrator-protocol.md) orchestration protocol.

## Pipeline

```yaml
pipeline: release-orchestrator
version: 9.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/release-orchestrator.json

stages:
  - id: phase-1
    name: "Quality Acceptance"
    depends_on: []
    skills: [quality-acceptance]
    gate:
      condition: "P0 issues=0, P1 issues≤3"
      fail_action: "Fix P0 issues and re-accept"

  - id: phase-2
    name: "Release Checklist"
    depends_on: [phase-1]
    skills: [release-auto-checklist]
    gate:
      condition: "Release checklist all passed"
      fail_action: "Supplement missing items and re-check"

  - id: phase-3
    name: "Canary Release"
    depends_on: [phase-2]
    skills: [release-gradual]
    gate:
      condition: "Canary release monitoring metrics normal"
      fail_action: "Rollback and troubleshoot"

  - id: phase-4
    name: "Release Notes"
    depends_on: [phase-3]
    skills: [release-notes]
    gate:
      condition: "Release notes confirmed by human"
      fail_action: "Supplement release notes content"
```

## Stage Execution Plan

#### Call quality-acceptance

```
Skill: quality-acceptance
Inputs:
  acceptance_criteria: User-provided (acceptance criteria)
  test_report: Test platform (test report)
  launch_checklist: User-provided (launch checklist, optional)
Output: docs/monitoring/release-notes.md ("Acceptance Report" section)
Validation: Acceptance criteria verified item by item; risks listed; release recommendation executable
Mode: 🤖→👤
```

#### Call release-auto-checklist

```
Skill: release-auto-checklist
Inputs:
  release_content: User-provided (release content)
  env_config: User-provided (environment configuration)
  dependency_list: User-provided (dependency list, optional)
Output: docs/monitoring/release-notes.md ("Release Checklist" section)
Validation: All check items covered; all blocking items resolved
Mode: 🤖
```

#### Call release-gradual

```
Skill: release-gradual
Inputs:
  release_plan: User-provided (release plan)
  gradual_strategy: User-provided (canary strategy, optional)
  monitoring_config: monitoring-alert-detection → monitoring configuration (optional)
Output: docs/monitoring/release-notes.md ("Canary Plan" section)
Validation: Canary stage configuration complete; traffic rules clear; rollback conditions executable
Mode: 🤖→👤
```

#### Call release-notes

```
Skill: release-notes
Inputs:
  release_content: User-provided (release content)
  change_log: User-provided (change log)
  user_impact: User-provided (user impact, optional)
Output: docs/monitoring/release-notes.md ("Release Notes" section, overwrite)
Validation: User, ops, and internal release notes all generated
Mode: 🤖
```

### Stage Summary (post_pipeline)

After all sub-skills complete, a stage summary document must be generated and written to `output/phase-reports/release-orchestrator.json`, containing the following 6 structures (none may be empty):

1. **Execution Overview**: Orchestrator name and version, execution time, sub-skill execution status (success/failure/degraded)
2. **Key Findings**: Core output summary for each sub-skill (1-3 items), cross-sub-skill insights
3. **Decision Records**: Human decision points and decision results, AI automated decisions and rationale
4. **Deliverables List**: All output file paths and content summaries, deliverable quality assessment (whether validation passed)
5. **Risks & TODOs**: Items that failed validation, items executed in degraded mode, suggested follow-up items
6. **Downstream Handoff**: Which downstream orchestrators can consume this orchestrator's outputs, recommended next orchestrator

| Parameter | Value |
|------|-----|
| Sub-skill output path | docs/monitoring/ |
| Summary output path | output/phase-reports/release-orchestrator.json |
| Approval record path | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

Downstream handoff:
  primary: monitoring-orchestrator (release complete, track post-release metric changes)
  alternatives:
    - target: iteration-orchestrator
      reason: Need to enter next Sprint after release
      condition: When release is complete and iteration needs to continue
    - target: growth-orchestrator
      reason: Start growth strategy after release
      condition: When release involves growth-related features and needs to drive user growth
  special_cases: []

## Stage Gates

| Gate | Condition | Handling on Failure |
|------|------|------------|
| Quality acceptance passed | quality-acceptance output file generated and non-empty | Fix P0 issues and re-accept |
| Release checklist passed | release-auto-checklist output file generated and non-empty | Supplement missing items and re-check |
| Canary release monitoring normal | release-gradual output file generated and non-empty | Rollback and troubleshoot |
| Release notes confirmed | release-notes output file generated and human-confirmed | Supplement release notes content |
| Stage summary generated | output/phase-reports/release-orchestrator.json generated and all 6 structures non-empty | Regenerate after supplementing missing structures |

## Human Decision Points

| Decision Point | Trigger Condition | Decision Content |
|--------|----------|----------|
| Quality acceptance release decision | Quality acceptance report generated | Confirm acceptance results, decide whether to release or release with conditions |
| Canary release strategy confirmation | Canary release plan generated | Confirm canary stages, traffic rules, and rollback conditions |
| Canary monitoring metric confirmation | Canary release monitoring metrics fluctuate during execution | Confirm whether to continue traffic increase or rollback |
| Release notes confirmation | Release notes document generated | Confirm release notes content is accurate and complete |

## Exception Handling

| Exception Type | Handling Strategy |
|----------|----------|
| Quality acceptance P0 issues not cleared | Block release process, require fixing P0 issues and re-acceptance |
| Release checklist blocking items cannot be resolved | Block release process, escalate to human to decide whether to degrade release or postpone |
| Canary release monitoring metrics abnormal | Immediately rollback to last stable version, troubleshoot and re-formulate canary plan |
| Canary rollback failure | Activate emergency rollback plan, notify On-Call personnel, escalate to human for emergency handling |
| Sub-skill output validation failed | Roll back to current stage and retry, max 1 retry; if still fails, mark exception and escalate to human |
| Upstream/downstream data format incompatible | Map fields and fill defaults per downstream sub-skill input Schema, record mapping relationships |
| Stage summary generation failure | Generate partial summary based on completed sub-skill outputs, mark missing items as "data missing", do not block orchestration completion |
| Monitoring alert needed | Hand off to monitoring-orchestrator for handling |
