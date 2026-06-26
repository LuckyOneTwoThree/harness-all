---
name: release-gradual
description: Used when executing canary release. Canary release auto-execution, performs progressive canary release from 1% to 10% to 50% to 100%, automatically monitors metrics at each stage and determines whether to proceed to the next stage, supports auto-rollback when P0 metrics deteriorate. 🤖 AI auto-executes. Keywords: canary release, progressive release, Feature Flag, auto-rollback, release strategy, canary deployment, small traffic, gradual traffic increase.
---
# Canary Release Auto-Execution

## When to use
- Do a canary release, start with 1% traffic
- Help me do small traffic validation
- Gradually increase traffic to full

## Outputs
- docs/monitoring/release-notes.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Trigger-driven**: Canary release auto-triggered by quality gate pass event, metric deterioration auto-triggers rollback
2. **Automated acceptance**: Per-stage metrics auto-monitored, stage transitions auto-determined, rollback auto-executed
3. **Continuous deployment**: Canary strategy combined with Feature Flag for progressive deployment and instant rollback
4. **Real-time retrospective**: Per-stage metrics aggregated in real-time, retrospective input generated immediately after release completion

## Interaction Mode

🤖 **AI auto-executes**

Trigger conditions:
- Quality gate passed
- Manual trigger (release lead confirmation)

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Release content | JSON | Yes | Release management system | Version and change content to be released |
| Feature Flag configuration | JSON | Yes | Feature Flag system | Canary switch configuration |
| Monitoring metric definitions | JSON | Yes | Monitoring system | Per-stage monitoring metrics |
| Canary strategy configuration | JSON | Yes | Release strategy library | Per-stage traffic ratio and duration |

> See [Reference/examples.md](./Reference/examples.md) for the Release Content Structure JSON example.

## Canary Stage Configuration

### Standard Canary Stages

| Stage | Traffic Ratio | Duration | Min Duration | Pass Condition |
|------|----------|----------|--------------|----------|
| Stage 0 | 0% (verification) | - | 10 minutes | Build verification passed |
| Stage 1 | 1% | 30 minutes | 30 minutes | Core metrics no anomaly |
| Stage 2 | 10% | 2 hours | 1 hour | P0 metrics stable |
| Stage 3 | 50% | 4 hours | 2 hours | No new anomalies |
| Stage 4 | 100% | - | - | All conditions passed |

### Guardrail Metrics Configuration

> See [Reference/examples.md](./Reference/examples.md) for the Guardrail Metrics Configuration JSON example (P0/P1/P2 metrics with warning and rollback thresholds).

## Execution Steps

### Step 1: Canary Plan Generation [Core]

#### 1.1 Pre-Release Verification

**Verification Checklist**:

| Verification Item | Check Content | Failure Handling |
|--------|----------|----------|
| Build artifact | Verify build artifact integrity | Block release |
| Rollback version | Confirm rollback version available | Block release |
| Feature Flag | Verify Flag configuration correct | Block release |
| Monitoring alerts | Verify alert rules configured | Block release |
| On-call personnel | Confirm on-call personnel online | Warning |

> See [Reference/examples.md](./Reference/examples.md) for the Pre-Release Verification Output JSON example.

#### 1.2 Canary Plan Generation

> See [Reference/examples.md](./Reference/examples.md) for the Canary Plan Generation JSON example (phases 1-4 with traffic percentages, durations, and success criteria).

### Step 2: Feature Flag Auto-Configuration [Core]

#### 2.1 Flag Configuration Generation

> See [Reference/examples.md](./Reference/examples.md) for the Feature Flag Configuration JSON example (per-phase serving rules).

#### 2.2 Flag Status Tracking

> See [Reference/examples.md](./Reference/examples.md) for the Flag Status Tracking JSON example.

### Step 3: Per-Stage Auto-Monitoring [Conditional]

#### 3.1 Metric Collection

> See [Reference/examples.md](./Reference/examples.md) for the Metrics Collection Configuration JSON example.

#### 3.2 Stage Status Assessment

**Assessment Rules**:

| Metric Type | Assessment Condition | Assessment Result |
|----------|----------|----------|
| All P0 normal | No metric exceeds warning threshold | **Can proceed to next stage** |
| Any P0 warning | Any metric exceeds warning but not rollback | **Continue observation** |
| P0 deterioration | Any metric exceeds rollback threshold | **Immediately rollback** |
| P1 alert | P1 metric exceeds threshold | **Delay + alert** |

> See [Reference/examples.md](./Reference/examples.md) for the Stage Assessment Output JSON example.

#### 3.3 Stage Transition Decision

> See [Reference/examples.md](./Reference/examples.md) for the Stage Transition Decision Flow diagram and Phase Transition Output JSON example.

### Step 4: Auto-Rollback Trigger [Deep]

#### 4.1 Rollback Trigger Conditions

**Trigger Rules**:

| Condition | Trigger Action | Delay |
|------|----------|------|
| P0 metric exceeds rollback threshold | **Immediate auto-rollback** | 0 seconds |
| Service unavailable | **Immediate auto-rollback** | 0 seconds |
| P1 metric exceeds rollback threshold | Delayed observation | 5 minutes |
| Human-confirmed anomaly | Manual trigger | 0 seconds |

#### 4.2 Rollback Execution

> See [Reference/examples.md](./Reference/examples.md) for the Rollback Flow diagram and Rollback Execution Output JSON example.

#### 4.3 Post-Rollback Processing

> See [Reference/examples.md](./Reference/examples.md) for the Post-Rollback Processing Checklist JSON example.

## Output

**Storage path**: `docs/monitoring/release-notes.md ("Canary Plan" section)`

**Output file**: `release_status.json`

## Output Schema

For complete Schema and validation rules, see [Reference/schema.md](./Reference/schema.md)

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Release checklist change | Canary strategy and gate | Re-evaluate canary gate conditions, mark for human confirmation |
| Acceptance report change | Canary start conditions | Update canary start conditions, re-evaluate whether canary can begin |
| Monitoring metric change | Monitoring configuration and alert rules | Update monitoring metrics and alert thresholds, mark for human confirmation |
| PRD requirement change | Canary scope and feature verification | Re-evaluate canary scope, mark for human confirmation |

When the canary release itself changes, the notification mechanism for downstream:

| Canary Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Canary stage advancement | release-notes | Mark stage advancement, trigger release notes update |
| Canary rollback | All downstream | Mark rollback event, trigger troubleshooting and fix |
| Canary complete | release-notes | Mark canary complete, trigger full release decision |

---

## Decision Rules

### Auto-Rollback Rules

| Trigger Condition | Execution Action | Priority |
|----------|----------|--------|
| P0 metric exceeds rollback threshold | Immediate auto-rollback | Highest |
| Service completely unavailable | Immediate auto-rollback | Highest |
| P1 metric exceeds rollback threshold | Rollback after 5-minute delay | High |
| P2 metric exceeds rollback threshold | Alert, wait for human confirmation | Medium |

### Stage Pass Rules

| Condition | Decision |
|------|------|
| All P0 metrics normal | Can proceed to next stage |
| Stage duration met | Evaluate whether to proceed to next stage |
| P0 alert exists (not exceeding threshold) | Extend observation time |
| P1 alert exists | Warning, proceed to next stage |

## Quality Checks

### Quality Gates

| Check Item | Standard | Handling on Failure |
|--------|------|------------|
| Pre-release verification (P0) | All verification items passed | Block release |
| P0 metric stability (P0) | No metric deterioration trend | Stop canary |
| Rollback mechanism ready (P0) | Feature Flag available | Block release |
| Alert configuration correct (P1) | All metrics have alerts configured | Block release |

### Quality Checklist

- [ ] Pre-release verification all passed (P0)
- [ ] Feature Flag configuration correct (P0)
- [ ] Monitoring alerts configured (P1)
- [ ] Rollback mechanism ready (P0)
- [ ] On-call personnel confirmed (P1)
- [ ] Stage transition records complete (P2)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Release content missing | User provides release feature list → generate canary plan template | Release content details need manual supplementation |
| Feature Flag configuration missing | Generate canary plan but exclude Flag auto-configuration steps | Feature Flag needs manual configuration |
| Monitoring metrics missing | Use default P0/P1/P2 metric template, mark "to be confirmed" | Alert thresholds based on generic template |
| Release content + Feature Flag + monitoring metrics all missing | User provides release feature list → generate canary plan template | Output canary plan template, each configuration item marked "to be confirmed" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Release feature list**: Features and changes included in this release
- **Rollback version** (optional): Previous version number that can be rolled back to
- **Key monitoring metrics** (optional): Business and technical metrics requiring special attention

## Execution Log

> See [Reference/examples.md](./Reference/examples.md) for the Execution Log JSON example.
