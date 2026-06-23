# PRD-S Complete 9-Section Structure Reference

> This document is split from design-prd SKILL.md, containing the standard structure definition of PRD-S (Standard). PRD-L and PRD-X are adjusted proportionally on this basis.

The following is the standard structure for PRD-S (Standard); PRD-L and PRD-X are adjusted proportionally on this basis.

### PRD-L (Light) Adjustment Rules

- **Keep**: Section 1 (Meta information), Section 2.1-2.2 (Problem description + Objective definition), Section 3.2.1-3.2.2 (Feature list + User stories, only Must/Should), Section 7.1 (Functional acceptance, only Happy Path)
- **Merge**: Section 4+5 merged into one "Constraints & Requirements" section, Section 8+9 merged into one "Release & Appendix" section
- **Delete**: Section 3.2.5-3.2.6 (Data model/Interface definition), Section 6 (Tracking plan), Section 7.2-7.3 (Performance/Security acceptance)
- **Target size**: 200-500 words, 3-5 core user stories

### PRD-X (eXtensive) Adjustment Rules

- **Keep**: All 9 sections of PRD-S
- **Enhance**: Section 3.2.2 add exception flow user stories for each feature point, Section 3.2.5 data model add ER diagram, Section 3.2.6 interface definition add error code table, Section 5 add disaster recovery plan, Section 8.1 add AB test plan
- **Add**: Section 3.3 Technical solution assessment (multi-solution comparison matrix), Section 5.5 Compliance requirements (GDPR/CCPA, etc.), Section 8.4 Internationalization plan
- **Target size**: 3000-8000 words, 10+ user stories with complete exception flows

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

#### 5.2 Availability Requirements

| Requirement Item | Specific Metric | Test Method |
|--------|----------|----------|
| Success rate | ≥ 99.5% | |
| Fault tolerance | Support automatic retry N times | |
| Degradation strategy | Core features available in degraded mode | |

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
