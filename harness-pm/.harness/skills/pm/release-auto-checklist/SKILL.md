---
name: release-auto-checklist
description: Used when generating a release checklist. Launch Checklist auto-generation and tracking, automatically generates T-7/T-1/during release/T+24h/T+72h release Checklists, performs item-by-item auto-checks and manual confirmation, supports incomplete item alerts and status tracking. 🤖 AI auto-executes.
---
# Launch Checklist Auto-Generation & Tracking

## When to use
- Help me list a checklist before launch
- Generate a release Checklist
- Organize what to check for launch
- Keywords: release Checklist, launch check, release process, release tracking, launch preparation, release list, launch list, release verification

## Outputs
- docs/monitoring/release-notes.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Trigger-driven**: Auto-triggered by release plan creation events, scheduled checks auto-execute
2. **Automated acceptance**: Check items auto-execute, incomplete items auto-alert, status auto-tracked
3. **Continuous deployment**: Checklist linked with release process, P0 items not completed auto-block release
4. **Real-time retrospective**: Checklist completion status aggregated in real-time, risk items exposed immediately

## Interaction Mode

🤖 **AI auto-executes**

Trigger conditions:
- Release plan created (starts at T-7)
- Scheduled check (hourly)
- Manual trigger (release lead request)

## Release Phase Definitions

| Phase | Time Point | Purpose |
|------|--------|------|
| T-7 | 7 days before release | Prepare checklist, identify risks |
| T-1 | 1 day before release | Final confirmation, ready to go |
| T-0 | During release | Execute release, real-time monitoring |
| T+24h | 24 hours after release | Stability confirmation |
| T+72h | 72 hours after release | Effectiveness evaluation |

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Release content | JSON | Yes | Release management system | Release version and change content |
| Checklist template | JSON | Yes | Release strategy library | Check templates for each phase |
| Release plan | JSON | Yes | Project management | Release time and owners |
| Release history | JSON | Yes | Release history library | Used to generate personalized check items |

> See [Reference/examples.md](./Reference/examples.md) for input structure examples (Release Content, Checklist Template).

## Execution Steps

### Step 1: Checklist Template Generation [Core]

#### 1.1 Template Loading

**Template Sources**:

| Source | Description |
|------|------|
| Standard template | Generic template from release strategy library |
| Project template | Customized template for specific projects |
| Release type template | feature_release/hotfix/config_change |
| Historical template | Auto-generated based on historical releases |

#### 1.2 Personalization Adjustment

**Adjustment Rules**:

| Adjustment Dimension | Adjustment Basis |
|----------|----------|
| Service scope | affected_services determines which services need checking |
| Change type | change_type determines special check items |
| Release history | Historical issues determine items needing extra attention |
| Team configuration | Owners determine notification chain |

> See [Reference/examples.md](./Reference/examples.md) for the Personalized Output JSON example.

### Step 2: Phase-Specific Checklist Generation [Core]

For each phase (T-7, T-1, T-0, T+24h, T+72h), generate a checklist with items containing `item_id`, `category`, `title`, `description`, `type` (manual/auto), `owner`, `priority`, and `auto_check_config`.

> See [Reference/examples.md](./Reference/examples.md) for the full JSON examples of all five phase checklists (T-7 / T-1 / T-0 / T+24h / T+72h).

### Step 3: Item-by-Item Auto-Check [Conditional]

#### 3.1 Check Execution

Auto-checks execute sequentially (with parallel execution option), with configurable timeout (default 60s) and retry policy (max 2 retries, 10s delay). Check results include `item_id`, `check_type`, `status`, `checked_at`, `details`, and `evidence`.

> See [Reference/examples.md](./Reference/examples.md) for the Check Execution Configuration and Check Result Output JSON examples.

### Step 4: Incomplete Item Alerts [Conditional]

#### 4.1 Alert Rules

**Alert Levels**:

| Level | Condition | Notification Method |
|------|------|----------|
| Blocking | P0 item incomplete and approaching release time | Immediate notification + block release |
| High | P0 item incomplete | Notify owner |
| Medium | P1 item incomplete | Notify owner |
| Low | P2 item incomplete | Summary notification |

**Alert Trigger Times**:

| Check Item Type | Alert Trigger Time |
|------------|--------------|
| T-7 check items | Alert if incomplete at T-3 |
| T-1 check items | Alert if incomplete at T-1 12:00 |
| T-0 check items | Alert if incomplete 2 hours before release |
| T+24h check items | Continue tracking if incomplete at T+24h |

#### 4.2 Alert Output

> See [Reference/examples.md](./Reference/examples.md) for the Alert Output JSON example.

### Step 5: Status Tracking [Deep]

#### 5.1 Status Aggregation

Status reports aggregate `summary` (total/completed/pending/blocked/completion_rate), `by_priority`, and `by_category` breakdowns.

> See [Reference/examples.md](./Reference/examples.md) for the Status Report JSON example.

#### 5.2 Progress Visualization

> See [Reference/examples.md](./Reference/examples.md) for the Progress Visualization JSON example.

## Output

**Storage path**: `docs/monitoring/release-notes.md ("Release Checklist" section)`

**Output file**: `release_checklist.json`

## Output Schema

For complete Schema and validation rules, see [Reference/schema.md](./Reference/schema.md)

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Acceptance report change | Check item status | Update acceptance-related check item status, re-evaluate gate result |
| Test report change | Test check items | Update test-related check item status, mark for human confirmation |
| Security assessment change | Security check items | Update security-related check item status, re-evaluate blocking items |
| Canary strategy change | Infrastructure check items | Update infrastructure check items, mark for human confirmation |

When the checklist itself changes, the notification mechanism for downstream:

| Checklist Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Gate result change | release-gradual | Mark gate change, trigger canary release decision |
| New blocking item | change-impact-analysis | Mark blocking item, trigger impact assessment |
| Check item status change | release-notes | Mark status change, trigger release notes update |

---

## Decision Rules

### Release Blocking Rules

| Condition | Decision |
|------|------|
| P0 blocking items exist at T-0 | **Immediately block release** |
| P0 incomplete items exist at T-0 | **Delay release** |
| P0 metrics not met at T+24h | **Trigger retrospective** |

### Pass Conditions

| Condition | Requirement |
|------|------|
| P0 item completion rate | 100% |
| P1 item completion rate | ≥ 80% |
| Pre-release alerts handled | 100% |

## Quality Checks

### Quality Gates

| Check Item | Standard | Handling on Failure |
|--------|------|------------|
| P0 item completion rate (P0) | 100% | Block release |
| Alert handling rate (P0) | 100% | Delay release |
| Manual confirmation completeness (P1) | All manual items confirmed | Alert |

### Quality Checklist

- [ ] All P0 check items completed (P0)
- [ ] All alerts handled (P0)
- [ ] Owners confirmed (P1)
- [ ] Documentation updated (P2)
- [ ] Communication notified (P2)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Release content missing | User provides release scope → generate standard Checklist | Checklist without personalization, uses generic template |
| Monitoring configuration missing | Skip monitoring-related auto-check items, mark as "manual confirmation required" | T+24h/T+72h monitoring check items require manual execution |
| Release content + monitoring configuration both missing | User provides release scope → generate standard Checklist | Output standard Checklist template, auto-check items marked "to be configured" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Release scope**: Services, modules, and change types involved in this release
- **Release time** (optional): Planned release time window
- **Owner information** (optional): List of owners for each role

## Execution Log

> See [Reference/examples.md](./Reference/examples.md) for the Execution Log JSON example.
