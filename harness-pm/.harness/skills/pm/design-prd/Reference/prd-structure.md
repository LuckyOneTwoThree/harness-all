# PRD Complete 9-Section Structure Reference

> This document is split from design-prd SKILL.md, containing the standard structure definition of the unified PRD. All projects use this same most-complete structure — no tiering/simplification, ensuring downstream consumers (design/engineering) always receive full contract data.

The following is the unified complete 9-section structure for all PRDs. The structure incorporates all fields previously distributed across PRD-L/S/X tiers into a single most-complete version: data-model migration, SLO targets, capacity forecast, disaster-recovery targets, dependencies to introduce, environment diffs, error code table, and experiment hypothesis reference are all first-class fields.

### Section 1: Meta Information (Meta)

Auto-generate the following fields:

| Field | Description | Generation Method |
|------|------|----------|
| Title | Requirement name | Extract from upstream or AI-generated |
| Document ID | Globally unique identifier | PRDS-{YYYYMM}-{sequence} |
| Version | Current version number | Automatically follows lifecycle |
| Author | Document creator | Extract from context |
| Status | Draft/In Review/Finalized/Released | State machine transition |
| Created At | ISO 8601 format | System time |
| Related Documents | Upstream output reference list | Auto-associated |

### Section 2: Background & Objectives (Why)

#### 2.1 Why (Problem Statement)

- **Problem description**: Clearly define the business problem or user pain point to be solved
- **Data support**: Reference insight data from upstream discovery phase
- **Problem source**: User feedback/Data analysis/Competitor analysis/Strategic planning
- **Impact scope**: Number of affected users, business amount, conversion rate loss

Data reference format:
```
[Data source: {upstream output ID}]
- Metric name: {specific value}
- Data period: {time range}
- Confidence: {high/medium/low}
```

#### 2.2 Objectives and Success Definition

**Primary Metric**
- Metric name:
- Current baseline:
- Target lift:
- Statistical period:

**Guardrail Metrics**
| Metric | Baseline | Lower Limit | Monitoring Frequency |
|------|------|------|----------|
| | | | |

**Supporting Metrics**
| Metric | Relationship to Primary Metric | Data Source |
|------|--------------|----------|
| | | |

**OKR Alignment** (aligned with prd.json goals[] structure)
```
Goal #{goal_id}:
  Description: {goal_description}
  OKR alignment: {okr_alignment}
  Success metrics:
    - {metric_name}: target {target_value}, current {current_value}, unit {unit}
    - ...
```

#### 2.3 Target Users and Scenarios

**User Persona**
- User type:
- User scale:
- Core needs:
- Use scenarios:

**Use Scenario Matrix**
| Scenario | User | Touchpoint | Frequency |
|------|------|------|------|
| | | | |

### Section 3: Solution Design (What & How)

#### 3.1 Solution Overview

- **Solution type**: New feature/Feature optimization/Architecture refactoring/Experience improvement
- **Core value proposition**:
- **Solution highlights**:
- **Relationship with existing system**:

#### 3.2 Feature Specifications

##### 3.2.1 Feature List (MoSCoW annotated)

| Feature Point | Priority | Type | Dependencies |
|--------|--------|------|----------|
| Must | | | |
| Should | | | |
| Could | | | |
| Won't | | | |

**Priority Definitions**:
- **Must (Must have)**: MVP core, requirement fails if not implemented
- **Should (Should have)**: Important but does not affect MVP completion
- **Could (Could have)**: Enhancement requirements, implemented when resources permit
- **Won't (Won't do this time)**: Explicitly excluded, record the reason

##### 3.2.2 User Stories (Given-When-Then format)

**Standard Format**:
```
User Story #{ID}
Title: {concise description}
Role: {Who}
Feature: {What}
Value: {Why}

Acceptance Criteria:
  Given {precondition}
  When {trigger action}
  Then {expected result}
```

**Flow Classification**:
- **Main flow (Happy Path)**: The optimal path for users to achieve their goals
- **Branch flow**: Optional operation paths
- **Exception flow**: Error handling, boundary conditions
- **Postconditions**: System state changes after operation completion

**Example**:
```
User Story #PRDS-001
Title: User successfully completes order payment
Role: User who has placed an order
Feature: Pay for order
Value: Complete the transaction loop

Acceptance Criteria:
  Given The user has selected products and submitted an order, the order amount is 100 yuan, and the account balance is 200 yuan
  When The user selects WeChat Pay and confirms payment
  Then The system deducts 100 yuan, the order status is updated to "Paid", and the user receives a payment success notification
```

##### 3.2.3 Interaction Logic

**Page Flow Diagram**
```
[Page A] → [Action 1] → [Page B]
            ↓
      [Action 2 failed] → [Error prompt]
```

**Feedback Requirements**
| Action | In-action Feedback Intent | Action Result Feedback Intent | Timeout Handling Intent |
|------|----------|----------|----------|
| | | | |

##### 3.2.4 State Design (5 special states)

| State Type | Trigger Condition | Design Intent | Interaction Handling |
|----------|----------|----------|----------|
| **Empty State** | When no data | Need to guide users to next action | Provide initial operation entry |
| **Loading State** | While fetching data | Need to let users feel the system is processing | Show progress, disable duplicate operations |
| **Error State** | Request failed | Need to clearly inform error reason and provide recovery path | Provide retry/contact support entry |
| **Partial State** | Incomplete data | Need to distinguish from complete state | Annotate missing content |
| **Permission State** | No access permission | Need to explain permission restrictions and provide application path | Provide permission application entry |

##### 3.2.5 Data Model

**Core Entities**
| Entity Name | Field | Type | Constraint | Description |
|--------|------|------|------|------|
| | | | | |

**Relationship Diagram**
```
Entity A (1:N) → Entity B
     ↓
Entity C (N:1) → Entity D
```

**Entity Migration Plan** (required when an entity evolves from existing data — greenfield entities may mark "N/A")

> Rationale: downstream engineering (solo brainstorming) and ops (migration runbook) both need to know how to move from the current schema to the target schema. Without this field, migration becomes an ad-hoc engineering decision, risking data loss.

| Entity | from_version | to_version | strategy | rollback |
|--------|----------|----------|----------|----------|
| | | | expand-and-contract / dual-write / big-bang | rollback steps |

- **strategy** options: `expand-and-contract` (preferred, zero-downtime) / `dual-write` (migration window) / `big-bang` (downtime required, must justify)
- **rollback**: must include a concrete rollback procedure (e.g., "drop new column, restore from snapshot taken at step N")

##### 3.2.6 Interface Definition

**API Interface List**
| Interface Name | Request Method | Path | Description |
|----------|----------|------|------|
| | | | |

**Interface Detail Template**
```
Interface: {interface name}
Method: GET/POST/PUT/DELETE
Path: /api/v1/{resource}
Description:

Request Parameters:
| Parameter Name | Type | Required | Description |
|--------|------|------|------|

Response Example:
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

**Error Code Table** (required for all user-facing APIs)

> Rationale: downstream engineering (solo) needs the error code contract to implement error handling; frontend needs it to render user-friendly error messages; growth needs it to attribute funnel drop-offs. Without a defined error code table, each layer invents its own codes, breaking cross-layer consistency.

| HTTP Status | error_code | error_message (user-facing) | Trigger condition | Recovery guidance |
|----------|------------|--------------------------|----------|----------|
| 400 | INVALID_PARAM | "Parameter format is incorrect" | Request param validation failed | Prompt user to re-enter |
| 401 | UNAUTHORIZED | "Please log in first" | Token expired or missing | Redirect to login |
| 403 | FORBIDDEN | "No permission to perform this operation" | Authorization check failed | Show permission application entry |
| 404 | NOT_FOUND | "Resource does not exist" | Resource deleted or never existed | Return to list page |
| 409 | CONFLICT | "Resource already exists" | Uniqueness constraint violated | Prompt user to deduplicate |
| 429 | RATE_LIMITED | "Too many operations, please try later" | Rate limit hit | Show retry countdown |
| 500 | INTERNAL_ERROR | "Service exception, please retry" | Unhandled server error | Auto-retry + report to ops |

> Project-specific error codes (e.g., BUSINESS_RULE_VIOLATION, INSUFFICIENT_BALANCE) should be appended below the standard set.

### Section 4: Boundaries & Constraints

#### 4.1 Explicitly Not Doing

| Excluded Item | Original Scope | Exclusion Reason | Follow-up Plan |
|--------|----------|----------|----------|
| | | | |

#### 4.2 Technical Constraints

| Constraint Type | Specific Requirement | Impact Description |
|----------|----------|----------|
| **Performance constraint** | | |
| **Security constraint** | | |
| **Compatibility constraint** | | |
| **Technical debt** | | |

**Dependencies to Introduce** (new third-party packages/services this PRD requires — must be declared here, not silently added by engineering)

> Rationale: every new dependency increases supply-chain risk, maintenance burden, and bundle size. Declaring them in the PRD forces an explicit cost-benefit decision before engineering starts, and gives ops a heads-up for license/vulnerability scanning.

| Dependency | Version | License | Purpose | Justification (why not existing/internal?) | Maintainer health |
|----------|------|--------|---------|---------------------|----------|
| | | MIT/Apache-2.0/BSD/... | | | active/archived/... |

**Environment Differences** (config/values that differ between dev/staging/prod — must be explicit so engineering and ops don't guess)

> Rationale: "works on my machine" failures are almost always caused by undeclared environment diffs. Making them a first-class PRD field forces PM + engineering to enumerate them up front.

| Config key | dev | staging | prod | Notes |
|----------|----------|----------|----------|----------|
| | | | | e.g., feature flag default, rate limit, log level |

#### 4.3 Known Limitations

| Limitation Item | Severity | Temporary Workaround | Root Cause Fix Plan |
|--------|----------|--------------|----------|
| | | | |

### Section 5: Non-Functional Requirements (NFR)

#### 5.1 Performance Requirements

| Metric | Target Value | Measurement Method | Monitoring Threshold |
|------|--------|----------|----------|
| Page load time | < 2s | | |
| API response time | < 500ms | | |
| Concurrent users | Support N users online simultaneously | | |
| Error rate | < 0.1% | | |

**Capacity Forecast** (required for production-grade projects — predicts resource growth so ops can provision ahead of demand)

> Rationale: without a capacity forecast, ops provisions reactively (after incidents), leading to either over-provisioning (wasted cost) or under-provisioning (incidents). PM owns this because the forecast depends on business growth assumptions only PM can make.

| Time horizon | Expected DAU/MAU | Peak QPS (read/write) | Storage growth | Bandwidth | Resource action |
|----------|----------|----------|----------|----------|----------|
| Launch (T0) | | | | | initial provision |
| +3 months | | | | | scale-up trigger |
| +6 months | | | | | capacity review |
| +12 months | | | | | architecture review |

#### 5.2 Availability Requirements

| Requirement Item | Specific Metric | Test Method |
|--------|----------|----------|
| Success rate | ≥ 99.5% | |
| Fault tolerance | Support automatic retry N times | |
| Degradation strategy | Core features available in degraded mode | |

**SLO Targets** (Service Level Objectives — the measurable availability promise to users; distinct from the loose "success rate" above)

> Rationale: SLO is the contract between the product and its users (e.g., "API will be available 99.9% of the time, measured monthly"). Without explicit SLO targets, ops has no objective threshold for paging, and incident severity becomes subjective. PM owns SLO because it's a product promise with cost tradeoffs (higher SLO = more redundancy cost).

| SLO | Target | Measurement window | Error budget consumption policy | Owner |
|----------|--------|----------|----------|----------|
| Availability | 99.9% | rolling 30 days | burn rate > 2x → freeze deploys | PM + Ops |
| Latency (p99) | < 500ms | rolling 7 days | burn rate > 2x → page on-call | Ops |
| Error rate | < 0.1% | rolling 1 hour | threshold breach → auto-rollback | Ops |

**Disaster Recovery Targets** (required for production-grade projects — defines RPO/RTO so ops can design the DR architecture)

> Rationale: RPO (Recovery Point Objective) and RTO (Recovery Time Objective) drive the entire DR architecture (backup frequency, multi-region, failover automation). Without them, ops either over-engineers (wasted cost) or under-engineers (data loss / prolonged outage). PM owns RPO/RTO because they are business-risk decisions, not technical ones.

| Scenario | RPO (max data loss) | RTO (max downtime) | Backup strategy | Failover mechanism | DR drill frequency |
|----------|----------|----------|----------|----------|----------|
| Single-AZ failure | 0 | < 5min | synchronous replication | auto-failover | quarterly |
| Region failure | < 15min | < 30min | async snapshot every 15min | manual DNS switchback | semi-annual |
| Data corruption | < 1h | < 2h | PITR backup | restore from backup | annual |

#### 5.3 Security Requirements

| Category | Requirement | Implementation Method |
|------|------|----------|
| Authentication | | |
| Authorization | | |
| Data encryption | | |
| Audit log | | |

#### 5.4 Observability Requirements

| Dimension | Metric | Alert Threshold |
|------|------|----------|
| **Metrics** | | |
| **Logs** | | |
| **Traces** | | |

> **Consumption boundary**: This section defines observability requirements from the **PM perspective** (what to measure, what alert thresholds matter to the product). The actual implementation — dashboard layout, alerting rule syntax, runbook authoring, log aggregation pipeline, trace sampling rate — is handled by the engineering/ops team. PM must NOT prescribe specific monitoring tooling (e.g., "use Prometheus" / "use Datadog") here; that is an engineering architecture decision.

### Section 6: Tracking Plan

#### 6.1 Event List

| Event Name | Trigger Timing | Properties | Associated Metric |
|--------|----------|------|----------|
| | | | |

**Event Property Standard**
```json
{
  "event_name": "xxx",
  "user_id": "string",
  "timestamp": "ISO8601",
  "properties": {
    "page_name": "string",
    "action_type": "string"
  }
}
```

#### 6.2 Tracking Validation Plan

- **Validation method**: QA testing + data callback validation
- **Validation timing**: Completed synchronously during the feature acceptance phase
- **Data quality monitoring**: Tracking coverage > 95%, data delay < 5min

#### 6.3 Experiment Hypothesis Reference (required for projects handed off to growth)

> Rationale: growth's `experiment-design` skill cannot design an A/B test without a hypothesis linking the feature change to an expected metric lift. If the PRD doesn't capture the hypothesis, growth has to reverse-engineer it from the feature list, which is unreliable. PM owns the hypothesis because it encodes the product's causal belief ("if we ship X, metric Y will lift by Z%").

| Feature ID | Hypothesis | Primary metric (expected lift) | Guardrail metric (must not degrade) | Min sample size | Min run duration |
|----------|----------|----------|----------|----------|----------|
| F-001 | "Adding one-click checkout will reduce checkout friction" | checkout completion rate +5% | cart abandonment rate ≤ baseline | 10k users per arm | 14 days |

> If this project will NOT be handed off to growth (e.g., pure infrastructure / internal tooling), mark "N/A — not growth-bound".

### Section 7: Acceptance Criteria

#### 7.1 Functional Acceptance (Given-When-Then)

**Happy Path Coverage**
```
Given {normal preconditions}
When {user performs core operation}
Then {all expected normal results}
```

**Boundary Condition Coverage**
```
Given {boundary preconditions}
When {boundary value triggered}
Then {expected boundary behavior}
```

**Exception Handling Coverage**
```
Given {exception preconditions}
When {exception triggered}
Then {graceful error handling}
```

**Compatibility Coverage**
```
Given {specific environment/version preconditions}
When {operation executed}
Then {runs normally within constraints}
```

#### 7.2 Performance Acceptance

| Test Scenario | Expected Metric | Pass Standard |
|----------|----------|----------|
| Stress test | | |
| Capacity test | | |
| Stability test | | |

#### 7.3 Security Acceptance

| Security Test Item | Test Method | Pass Standard |
|------------|----------|----------|
| Identity authentication test | | |
| Permission control test | | |
| Data encryption test | | |

### Section 8: Release & Operations

> **Section positioning**: This section describes release and operations readiness from the **PM perspective** — the rollout plan, feature-flag defaults, rollback triggers, and operational handoff items that PM owns as part of the product launch contract. The actual operations architecture — deployment pipeline, canary automation, runbook authoring, on-call rotation, incident response — is handled by the engineering/ops team. PM must NOT prescribe specific deployment tooling (e.g., "use ArgoCD" / "use Spinnaker") or ops staffing decisions here.

#### 8.1 Release Strategy

**Gradual Rollout Plan**
| Stage | Scope | Time | Observation Metrics |
|------|------|------|----------|
| Internal test | Internal users | | |
| Small traffic | 5% users | | |
| Full rollout | 100% users | | |

**Feature Flag Configuration**
- Feature toggle key:
- Default state:
- Gradual rollout percentage:

**Rollback Plan**
- Rollback trigger conditions:
- Rollback operation process:
- Rollback impact assessment:

#### 8.2 Operations Readiness

| Preparation Item | Owner | Completion Time | Acceptance Criteria |
|--------|--------|----------|----------|
| Help documentation | | | |
| Customer service scripts | | | |
| Operations materials | | | |
| Training materials | | | |

#### 8.3 Effectiveness Evaluation Plan

| Metric | Evaluation Period | Evaluation Method | Decision Threshold |
|------|----------|----------|----------|
| | | | |

### Section 9: Appendix

#### 9.1 Glossary

| Term | Definition | First Occurrence Location |
|------|------|--------------|
| | | |

#### 9.2 Change Log

| Version | Date | Change Content | Changed By |
|------|------|----------|--------|
| | | | |

#### 9.3 Open Issues

| Problem Description | Impact Assessment | Owner | Planned Resolution Time |
|----------|----------|--------|--------------|
| | | | |

#### 9.4 Related Document Index

| Document Type | Document Name | Document ID/Path | Version |
|----------|----------|-------------|------|
| Strategy document | | | |
| Design document | | | |
| Technical document | | | |
| Test plan | | | |
