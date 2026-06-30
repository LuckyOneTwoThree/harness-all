---
name: quality-acceptance
description: Used when generating acceptance execution plans and sign-off reports. Acceptance execution plan generation + sign-off report generation, generates acceptance execution plans based on Given-When-Then format acceptance criteria (P0/P1 failures block release), integrates acceptance execution plan, acceptance criteria, open issues and sign-off confirmation, produces a signable acceptance report. 🤖 AI generates plan + AI suggests human approval. Keywords: acceptance execution plan, acceptance testing, Given-When-Then, quality gate, release check, acceptance report, sign-off report, UAT report, acceptance confirmation.
---
# Acceptance Execution Plan Generation & Sign-off Report Generation

## When to use
- Run the acceptance tests automatically
- Help me execute the acceptance checks
- Check if it can pass the quality gate
- Generate the acceptance report
- Version is going to acceptance, help me produce the report
- Organize the acceptance results

## Outputs
- docs/monitoring/release-notes.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Trigger-driven**: Acceptance is automatically triggered by Story completion and build success events, rather than waiting for manual initiation
2. **Acceptance plan generation**: Acceptance criteria auto-parsing, test environment configuration recommendations generated, execution instructions and decision rules auto-generated
3. **Continuous deployment**: Passing acceptance means ready for release, P0/P1 failures block immediately
4. **Real-time retrospective**: Acceptance results generated in real time, failed cases analyzed for root cause immediately
5. **Standards first**: Acceptance criteria must be defined before testing, not after testing is complete
6. **Data speaks**: Pass/fail is decided by data, not by people
7. **Traceable open issues**: Failed items must have a handling plan and tracking number
8. **Auditable sign-off**: Sign-off records are traceable, responsibility is clearly defined

## Interaction Mode

🤖 **AI generates plan** (Step 1) → 👤 **AI suggests human approval** (Step 2)

Trigger conditions:
- Story development completion event
- Code merged to main branch event
- Build success event
- Manual trigger (acceptance owner request)

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Story acceptance criteria | JSON | Yes | PRD | Given-When-Then format |
| Test cases | JSON array | Yes | PRD | Test cases derived from PRD acceptance criteria |
| Test environment config | JSON | Yes | Test system | Environment parameters and Mock configuration recommendations |
| Build artifact | File/Reference | Yes | CI/CD | Build version to be accepted |
| Test results | JSON | ○ | CI/CD | Automated test execution results |
| SRS document | Markdown | ○ | docs/product/PRD.md | Requirement specification (contains acceptance criteria, already covered by design-prd) |
| Version number | string | Yes | User-provided | Version number for acceptance |
| Acceptance scope | string | Yes | User-provided | Functional scope of this acceptance |
| Acceptance party | string | ○ | User-provided | Acceptance owner/team |
| Backend review report | JSON | ○ | docs/handoff/solo-to-pm.md (from harness-solo) | Backend architecture review results |
| API coverage report | JSON | ○ | docs/handoff/solo-to-pm.md (from harness-solo) | PRD/frontend alignment coverage report |

> See [Reference/examples.md](./Reference/examples.md) for the Story Acceptance Criteria Structure JSON example.

## Execution Steps

### Step 1: Acceptance Execution Plan Generation [Core]

#### 1.1 Acceptance Criteria Parsing [Core]

**GWT format standardization**:

| GWT Component | Parse Result | Usage |
|---------|----------|------|
| Given | Precondition array | Setup steps |
| When | Action steps array | Execution steps |
| And | Append to previous When | Continuous actions |
| Then | Expected result array | Assertion verification |

> See [Reference/examples.md](./Reference/examples.md) for the Acceptance Criteria Parse Output JSON example.

#### 1.2 Test Strategy Selection [Core]

**Strategy types**:

| Strategy | Applicable Scenario | Execution Instruction Generation Method |
|------|----------|------------------|
| E2E automation | Complete user flows | Selenium/Cypress execution instruction generation |
| API automation | Pure backend functionality | RestAssured/Postman execution instruction generation |
| Unit testing | Independent function logic | Jest/JUnit execution instruction generation |
| Integration testing | Inter-module interaction | Hybrid strategy execution instruction generation |

> See [Reference/examples.md](./Reference/examples.md) for the Strategy Selection Rules JSON example.

#### 1.3 Test Data Preparation [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Test Data Preparation JSON example.

#### 1.4 Test Environment Configuration Recommendations [Conditional]

**Environment readiness check**:

| Check Item | Check Content | Timeout |
|--------|----------|----------|
| Application service | Service started and health check passed | 60s |
| Database | Database connection normal, data ready | 30s |
| Cache service | Redis connection normal | 15s |
| Message queue | MQ connection normal | 15s |
| Third-party Mock | Mock service available | 30s |
| Test account | Test data preparation complete | 20s |

> See [Reference/examples.md](./Reference/examples.md) for the Environment Isolation Configuration and Mock Service Configuration JSON examples.

#### 1.5 Execution Instruction Generation [Core]

> See [Reference/examples.md](./Reference/examples.md) for the Execution Plan Generation and Execution Engine Configuration JSON examples.

#### 1.6 Decision Rule Generation [Core]

**Gate decision**:

| Condition | Decision Result | Handling |
|------|----------|----------|
| P0 has failures | **Block** | Block release, send alert |
| P1 failures > 2 | **Block** | Block release, require fix |
| Automation rate < 90% | **Block** | Block release, increase automation |
| P2 failures > 5 | **Warning** | Allow release, commitment to fix required |

> See [Reference/examples.md](./Reference/examples.md) for the Result Aggregation and Gate Output JSON examples.

#### 1.7 Failure Analysis Rule Generation [Deep]

**Failure classification**:

| Failure Type | Characteristics | Handling Strategy |
|----------|------|----------|
| Code defect | Functionality not working as expected | Submit bug, require fix |
| Environment issue | Environment configuration or data issue | Fix environment, re-execute |
| Test issue | Test script itself has defects | Fix test script |
| Data issue | Test data is inaccurate | Update test data |
| Requirement change | Requirements and implementation out of sync | Confirm whether to update requirements |

> See [Reference/examples.md](./Reference/examples.md) for the Failure Classification Output, Fix Suggestion Generation, and Regression Risk Assessment JSON examples.

### Step 2: Sign-off Report Generation [Core]

#### 2.1 Acceptance Criteria Extraction [Core]

Extract acceptance criteria from PRD and acceptance criteria data:

**Acceptance criteria classification**:

| Category | Description | Pass Condition |
|------|------|---------|
| Functional acceptance | Whether core functionality is implemented per requirements | All Must requirements pass |
| Performance acceptance | Whether performance metrics meet targets | Key metric pass rate 100% |
| Security acceptance | Whether security requirements are met | No high/critical vulnerabilities |
| Compatibility acceptance | Whether target platforms are compatible | All target platforms pass |
| User experience acceptance | Whether core flows are smooth | No P0-level experience issues |

**Each acceptance criterion**:

| ID | Standard Description | Source (PRD ID) | Priority | Verification Method |
|------|---------|---------------|--------|---------|
| AC-001 | User can complete registration in 3 steps | FR-AUTH-001 | Must | Functional testing |
| AC-002 | Page first screen load < 2s | NFR-PERF-001 | Must | Performance testing |

#### 2.2 Test Result Integration [Core]

Integrate test results, map to acceptance criteria:

**Test result summary**:

| Acceptance Criterion | Test Case Count | Passed | Failed | Blocked | Pass Rate | Status |
|----------|-----------|------|------|------|--------|------|
| AC-001 | 5 | 5 | 0 | 0 | 100% | ✅ |
| AC-002 | 3 | 2 | 1 | 0 | 67% | ❌ |

**Overall statistics**: total test case count, passed/failed/blocked/skipped counts, overall pass rate, Must requirement pass rate.

#### 2.3 Defect Analysis [Conditional]

Perform defect analysis on failed and blocked test cases:

**Defect list**: Defect ID, Related Acceptance Criterion, Severity, Description, Reproduction Steps, Status, Owner.

**Severity definition**:

| Level | Definition | Acceptance Impact |
|------|------|---------|
| Fatal | System crash/data loss | Blocks acceptance |
| Critical | Core functionality unavailable | Blocks acceptance |
| General | Functionality limited but workaround available | Can accept with known issues |
| Minor | Experience issue | Can accept with known issues |
| Suggestion | Optimization suggestion | Does not affect acceptance |

#### 2.4 Open Issue Assessment [Conditional]

**Open issue list**: ID, Description, Severity, Impact Scope, Handling Plan (Fix/Mitigate/Accept), Estimated Fix Time, Risk Assessment.

**Open issue acceptance impact judgment**:

| Condition | Acceptance Recommendation |
|------|---------|
| Unfixed fatal/critical defects exist | ❌ Not recommended to pass acceptance |
| Only general/minor defects | ✅ Recommend conditional pass, open issues listed for next version |
| No open issues | ✅ Recommend pass acceptance |

#### 2.5 Acceptance Conclusion [Core]

> See [Reference/examples.md](./Reference/examples.md) for the Acceptance Conclusion Template and Sign-off Confirmation table.

**Sign-off confirmation**:

| Role | Name | Sign-off Opinion | Signature | Date |
|------|------|---------|------|------|
| Product Owner | | Approve/Reject/Conditional Approve | | |
| Tech Lead | | Approve/Reject/Conditional Approve | | |
| QA Lead | | Approve/Reject/Conditional Approve | | |
| Business Representative | | Approve/Reject/Conditional Approve | | |

#### 2.6 Document Assembly [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Report Structure template.

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Decision Rules

### Release Blocking Rules

| Condition | Decision |
|------|------|
| P0 failure exists | **Block immediately**, send urgent alert |
| P1 failures > 2 | **Block immediately**, require fix |
| Automation execution rate < 90% | **Block**, require increased automation rate |
| Environment configuration recommendation missing | **Block**, investigate environment configuration |
| Must requirement pass rate < 100% | Acceptance conclusion is "Fail" |
| Unfixed fatal/critical defects exist | Acceptance conclusion is "Fail" |
| General defects > 5 | Recommend re-acceptance after fix |

### Pass Conditions

| Condition | Requirement |
|------|------|
| P0 cases | 100% pass |
| P1 cases | ≤ 2 failures |
| P2 cases | ≤ 5 failures |
| Automation rate | ≥ 90% |

## Quality Checks

Quality gates follow P0/P1/P2 tiering: P0 case pass rate must be 100%; P1 requires automation rate ≥ 90%, full environment config, and failure analysis; P2 (deep only) requires regression matrix, performance baseline comparison, and security audit checklist.

> See [Reference/quality-and-degradation.md](./Reference/quality-and-degradation.md) for the full P0/P1/P2 check items and checklists.

## Degradation Strategy

> See [Reference/quality-and-degradation.md](./Reference/quality-and-degradation.md) for the Upstream File Missing Degradation Plan table and Data Acquisition Instructions.

## Execution Log

> See [Reference/examples.md](./Reference/examples.md) for the Execution Log JSON example.
