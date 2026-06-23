---
name: quality-acceptance
description: Used when generating acceptance execution plans and sign-off reports. Acceptance execution plan generation + sign-off report generation, generates acceptance execution plans based on Given-When-Then format acceptance criteria (P0/P1 failures block release), integrates acceptance execution plan, acceptance criteria, open issues and sign-off confirmation, produces a signable acceptance report. 🤖 AI generates plan + AI suggests human approval. Keywords: acceptance execution plan, acceptance testing, Given-When-Then, quality gate, release check, acceptance report, sign-off report, UAT report, acceptance confirmation.
metadata:
  module: "Product Monitoring & Iteration"
  sub-module: "Quality Assurance"
  type: "pipeline"
  version: "3.1"
  domain_tags: ["Internet", "General"]
  triggers:
    - "Run the acceptance tests automatically"
    - "Help me execute the acceptance checks"
    - "Check if it can pass the quality gate"
    - "Generate the acceptance report"
    - "Version is going to acceptance, help me produce the report"
    - "Organize the acceptance results"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Only output P0 acceptance results"
  deep_description: "Full report + regression test matrix + performance baseline comparison + security audit checklist"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/product/PRD.md
  - docs/handoff/solo-to-pm.md
writes:
  - docs/monitoring/release-notes.md
  - memory/progress.md
  - memory/knowledge-base.md
---

# Acceptance Execution Plan Generation & Sign-off Report Generation

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

### Story Acceptance Criteria Structure Example

```json
{
  "story_id": "story_001",
  "title": "Phone verification code login",
  "build_ref": "build_2024_0125_001",
  "version": "v2.1.0",
  "acceptance_criteria": [
    {
      "id": "AC-001",
      "format": "given_when_then",
      "content": "Given the user is on the login page\nWhen the user enters a valid phone number 13800138000\nAnd clicks the get verification code button\nThen the system sends a 6-digit verification code to that phone number\nAnd the page displays a success message",
      "automatable": true,
      "priority": "P0"
    }
    // ... same structure can be extended
  ]
}
```

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

**Parse output**:

```json
{
  "parsed_criteria": [
    {
      "ac_id": "AC-001",
      "setup": [
        "Open the login page",
        "Confirm the page has finished loading"
      ],
      "actions": [
        "Enter phone number: 13800138000",
        "Click the get verification code button"
      ],
      "assertions": [
        "Verify the SMS sending API is called",
        "Verify a success response is returned",
        "Verify the page displays a success message"
      ],
      "priority": "P0",
      "automatable": true
    }
  ]
}
```

#### 1.2 Test Strategy Selection [Core]

**Strategy types**:

| Strategy | Applicable Scenario | Execution Instruction Generation Method |
|------|----------|------------------|
| E2E automation | Complete user flows | Selenium/Cypress execution instruction generation |
| API automation | Pure backend functionality | RestAssured/Postman execution instruction generation |
| Unit testing | Independent function logic | Jest/JUnit execution instruction generation |
| Integration testing | Inter-module interaction | Hybrid strategy execution instruction generation |

**Strategy selection rules**:

```json
{
  "strategy_selection": {
    "AC-001": {
      "selected_strategy": "api_automation",
      "reason": "Acceptance point is API call and response",
      "test_framework": "rest_assured",
      "script_location": "tests/api/test_login.py::test_send_verification_code"
    },
    "AC-002": {
      "selected_strategy": "e2e_automation",
      "reason": "Includes UI verification such as page navigation",
      "test_framework": "cypress",
      "script_location": "tests/e2e/test_login.py::test_verify_code_login"
    }
  }
}
```

#### 1.3 Test Data Preparation [Conditional]

```json
{
  "test_data_requirements": {
    "AC-001": {
      "phone": "13800138000",
      "type": "valid_phone",
      "source": "test_data/phones/valid.json"
    },
    "AC-002": {
      "phone": "13800138000",
      "verification_code": "123456",
      "type": "valid_code",
      "source": "generated_by_AC-001"
    }
  }
}
```

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

**Environment isolation configuration**:

```json
{
  "isolation_config": {
    "test_db": "test_db_isolation_enabled",
    "test_cache_prefix": "test:",
    "network_isolation": "enabled",
    "clean_strategy": "per_suite"
  }
}
```

**Mock service configuration recommendations**:

```json
{
  "mock_config": {
    "sms_gateway": {
      "enabled": true,
      "behavior": "record_and_playback",
      "record_file": "mocks/recordings/sms_gateway.json"
    },
    "wechat_auth": {
      "enabled": true,
      "behavior": "simulate_success",
      "user_id": "mock_wechat_123"
    }
  }
}
```

#### 1.5 Execution Instruction Generation [Core]

**Execution plan generation**:

```json
{
  "execution_plan": {
    "total_criteria": 12,
    "parallel_groups": [
      {
        "group_id": "group_1",
        "criteria": ["AC-001", "AC-002"],
        "execution_mode": "sequential",
        "reason": "Dependency exists (AC-002 depends on AC-001 data)"
      }
      // ... same structure can be extended
    ],
    "estimated_duration_minutes": 25
  }
}
```

**Execution engine configuration recommendations**:

```json
{
  "execution_config": {
    "runner": "pytest",
    "browsers": ["chrome", "firefox"],
    "retry_config": {
      "enabled": true,
      "max_retries": 2,
      "retry_on_failure": ["timeout", "network_error"]
    },
    "timeout_config": {
      "test_case_timeout": 120,
      "api_call_timeout": 30,
      "page_load_timeout": 60
    },
    "reporting": {
      "generate_html_report": true,
      "generate_json_report": true,
      "screenshots_on_failure": true,
      "video_recording": "on_failure"
    }
  }
}
```

#### 1.6 Decision Rule Generation [Core]

**Result aggregation**:

```json
{
  "result_aggregation": {
    "summary": {
      "total_criteria": 12,
      "passed": 10,
      "failed": 2,
      "skipped": 0,
      "pass_rate": 0.83
    },
    "by_priority": {
      "P0": {"total": 4, "passed": 3, "failed": 1},
      "P1": {"total": 5, "passed": 5, "failed": 0},
      "P2": {"total": 3, "passed": 2, "failed": 1}
    },
    "execution_duration_seconds": 1200,
    "automated_execution_rate": 0.92
  }
}
```

**Gate decision**:

| Condition | Decision Result | Handling |
|------|----------|----------|
| P0 has failures | **Block** | Block release, send alert |
| P1 failures > 2 | **Block** | Block release, require fix |
| Automation rate < 90% | **Block** | Block release, increase automation |
| P2 failures > 5 | **Warning** | Allow release, commitment to fix required |

**Gate output**:

```json
{
  "gate_decision": {
    "passed": false,
    "blocked_by": "P0_FAILURE",
    "blocking_items": [
      {
        "ac_id": "AC-002",
        "priority": "P0",
        "failure_reason": "Did not navigate to home page after successful login"
      }
    ],
    "release_allowed": false,
    "next_actions": [
      "Fix the defect corresponding to AC-002",
      "Re-run acceptance"
    ]
  }
}
```

#### 1.7 Failure Analysis Rule Generation [Deep]

**Failure classification**:

| Failure Type | Characteristics | Handling Strategy |
|----------|------|----------|
| Code defect | Functionality not working as expected | Submit bug, require fix |
| Environment issue | Environment configuration or data issue | Fix environment, re-execute |
| Test issue | Test script itself has defects | Fix test script |
| Data issue | Test data is inaccurate | Update test data |
| Requirement change | Requirements and implementation out of sync | Confirm whether to update requirements |

**Classification output**:

```json
{
  "failure_analysis": [
    {
      "ac_id": "AC-002",
      "failure_type": "code_defect",
      "evidence": {
        "expected": "Page navigates to home page",
        "actual": "Page stays on login page",
        "error_message": "Navigation timeout after 30000ms",
        "screenshots": ["screenshots/ac002_failure_1.png"],
        "logs": ["logs/browser_console.log"]
      },
      "root_cause_hypothesis": "Frontend routing logic not executed correctly after successful login",
      "likely_location": "frontend/router/index.ts",
      "confidence": 0.85
    }
  ]
}
```

**Fix suggestion generation**:

```json
{
  "fix_suggestions": [
    {
      "ac_id": "AC-002",
      "fix_type": "code_fix",
      "location": "frontend/pages/login.vue",
      "line_range": "45-60",
      "suggestion": "Add router.push('/home') call in the login success callback",
      "verification_plan": "Re-run AC-002 acceptance test"
    }
  ]
}
```

**Regression risk assessment**:

```json
{
  "regression_risk": {
    "scope": "limited",
    "affected_stories": ["story_002", "story_003"],
    "risk_level": "medium",
    "reason": "Login module changes may affect user registration flow",
    "recommendations": [
      "Recommend running regression tests for story_002 and story_003",
      "Recommend running login-related E2E test suite"
    ]
  }
}
```

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

**Overall statistics**:

| Metric | Value |
|------|------|
| Total test case count | |
| Passed count | |
| Failed count | |
| Blocked count | |
| Skipped count | |
| Overall pass rate | |
| Must requirement pass rate | |

#### 2.3 Defect Analysis [Conditional]

Perform defect analysis on failed and blocked test cases:

**Defect list**:

| Defect ID | Related Acceptance Criterion | Severity | Description | Reproduction Steps | Status | Owner |
|----------|------------|---------|------|---------|------|--------|
| BUG-001 | AC-002 | Critical | First screen load timeout | 1.Open home page 2.Wait | Pending fix | |

**Severity definition**:

| Level | Definition | Acceptance Impact |
|------|------|---------|
| Fatal | System crash/data loss | Blocks acceptance |
| Critical | Core functionality unavailable | Blocks acceptance |
| General | Functionality limited but workaround available | Can accept with known issues |
| Minor | Experience issue | Can accept with known issues |
| Suggestion | Optimization suggestion | Does not affect acceptance |

#### 2.4 Open Issue Assessment [Conditional]

**Open issue list**:

| ID | Description | Severity | Impact Scope | Handling Plan | Estimated Fix Time | Risk Assessment |
|------|------|---------|---------|---------|------------|---------|
| | | | | Fix/Mitigate/Accept | | |

**Open issue acceptance impact judgment**:

| Condition | Acceptance Recommendation |
|------|---------|
| Unfixed fatal/critical defects exist | ❌ Not recommended to pass acceptance |
| Only general/minor defects | ✅ Recommend conditional pass, open issues listed for next version |
| No open issues | ✅ Recommend pass acceptance |

#### 2.5 Acceptance Conclusion [Core]

**Acceptance conclusion template**:

```
Acceptance Conclusion: ✅ Pass / ⚠️ Conditional Pass / ❌ Fail

Acceptance Scope: {version number} {functional scope}
Acceptance Date: {date}
Acceptance Party: {acceptance party}

Passed Items: {N} items ({X}%)
Failed Items: {N} items ({X}%)
Must Requirement Pass Rate: {X}%

Open Issues: {N}
- Fatal/Critical: {N}
- General/Minor: {N}

Acceptance Recommendation:
{specific recommendation}
```

**Sign-off confirmation**:

| Role | Name | Sign-off Opinion | Signature | Date |
|------|------|---------|------|------|
| Product Owner | | Approve/Reject/Conditional Approve | | |
| Tech Lead | | Approve/Reject/Conditional Approve | | |
| QA Lead | | Approve/Reject/Conditional Approve | | |
| Business Representative | | Approve/Reject/Conditional Approve | | |

#### 2.6 Document Assembly [Conditional]

**Report structure**:

```
# {Product Name} v{Version} Acceptance Test Report

## 1. Acceptance Overview
### 1.1 Acceptance Scope
### 1.2 Acceptance Criteria
### 1.3 Acceptance Environment

## 2. Acceptance Execution Plan
### 2.1 Acceptance Criteria Parsing
### 2.2 Test Environment Configuration Recommendations
### 2.3 Execution Instructions and Decision Rules
### 2.4 Gate Decision

## 3. Test Result Summary
### 3.1 Overall Statistics
### 3.2 Acceptance Criteria Item-by-Item Results
### 3.3 Test Coverage

## 4. Defect Analysis
### 4.1 Defect Statistics
### 4.2 Defect List
### 4.3 Defect Trends

## 5. Open Issues
### 5.1 Open Issue List
### 5.2 Open Issue Risk Assessment
### 5.3 Handling Plan

## 6. Acceptance Conclusion
### 6.1 Conclusion
### 6.2 Open Issue Handling Plan
### 6.3 Sign-off Confirmation

## Appendix
- Test case details
- Test environment configuration
- Complete acceptance criteria list
- Failed case analysis details
```

## Output

**Storage path**: `docs/monitoring/release-notes.md ("Acceptance Report" section)`

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | P0 acceptance results | Core conclusion + minimum viable artifact, only outputs P0 case pass/fail results and gate decision |
| standard | Full acceptance report (current default) | Full artifact, includes all Step 1-2 outputs |
| deep | Full report + extended analysis | Full artifact + regression test matrix + performance baseline comparison + security audit checklist + decision record + risk assessment |

**Output files**:

| File | Format | Description |
|------|------|------|
| acceptance-report.md | Markdown | Complete acceptance test report (includes acceptance execution plan and sign-off confirmation) |
| acceptance-report.json | JSON | Structured data |

## Output Schema

Full schema and validation rules see [Reference/schema.md](./Reference/schema.md)

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Acceptance criteria change | Check items and methods | Regenerate affected check items, retain passed historical records |
| Test case change | Automated acceptance check items | Update related acceptance check items, mark for human confirmation |
| PRD requirement change | Acceptance coverage | Re-assess acceptance coverage, mark for human confirmation |
| Code change | Acceptance execution plan | Regenerate affected acceptance execution plan |
| Security requirement change | Security acceptance items | Update security acceptance items, re-assess security risk |

When acceptance results themselves change, the downstream notification mechanism:

| Acceptance Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Gate result change | release-orchestrator | Mark gate change, trigger release decision update |
| P0/P1 check failure | change-impact-analysis | Mark failed items, trigger impact assessment |
| Manual verification items needed | release-orchestrator | Mark pending verification items, trigger manual acceptance flow |
| P0/P1 failure | release-orchestrator | Mark blocking items, block release flow |
| Sign-off status change | release-orchestrator | Mark sign-off status, trigger release decision |

---

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

### P0 Checks (must pass for quick/standard/deep)

| Check Item | Standard | Non-compliance Handling |
|--------|------|------------|
| P0 case pass rate | 100% | Block |

- [ ] All P0 case execution instructions generated
- [ ] P0 case pass rate 100%

### P1 Checks (must pass for standard/deep)

| Check Item | Standard | Non-compliance Handling |
|--------|------|------------|
| Automation execution rate | ≥ 90% | Block |
| Test environment configuration | All configuration recommendation items output | Block |
| Failure analysis completeness | Includes root cause and recommendations | Alert |

- [ ] Automation execution rate meets standard
- [ ] Failed case analysis rules generated
- [ ] Failed cases have fix suggestions
- [ ] Environment configuration recommendations output
- [ ] Acceptance criteria have item-by-item results
- [ ] Must requirement pass rate calculated
- [ ] Defects classified by severity
- [ ] Open issues have handling plans
- [ ] Acceptance conclusion clear (pass/conditional pass/fail)
- [ ] Sign-off confirmation table included

### P2 Checks (only deep must pass)

- [ ] Regression test matrix generated (affected modules, regression case coverage, risk level annotation)
- [ ] Performance baseline comparison completed (key metrics compared with previous version baseline, performance degradation detection)
- [ ] Security audit checklist output (security acceptance items, vulnerability scan results, compliance check)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Acceptance criteria missing | User provides Given-When-Then acceptance criteria → generate acceptance checklist | Acceptance criteria need manual writing |
| Test environment missing | Generate acceptance checklist and execution instructions, environment configuration marked as to-be-filled | Only outputs checklist and execution instructions, environment configuration marked as to-be-filled |
| Acceptance criteria + test environment both missing | User provides Given-When-Then acceptance criteria → generate acceptance checklist | Outputs acceptance checklist, environment configuration marked as "to be configured" |
| Test results missing | Generate to-be-filled report template based on acceptance criteria | Cannot auto-determine pass/fail |
| SRS missing (already covered by design-prd) | Acceptance criteria provided by user | Need to manually define acceptance criteria |
| Acceptance party missing | If user does not provide acceptance party, prompt user to provide or skip related steps | Sign-off confirmation table marked as "acceptance party to be designated" |
| Backend review report missing | Accept based only on functional acceptance criteria | May miss backend architecture quality issues |
| API coverage report missing | Accept based only on PRD acceptance criteria | May miss incomplete API coverage issues |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degradation generation:
- **Given-When-Then acceptance criteria**: Given/When/Then description for each acceptance condition
- **Test environment information** (optional): Test environment address, accounts and other configuration
- **Build version** (optional): Build version number to be accepted

## Execution Log

```json
{
  "execution_id": "exec_p5_xxx",
  "pipeline": "quality-acceptance",
  "story_id": "story_001",
  "trigger": "story_completed",
  "started_at": "ISO8601",
  "completed_at": "ISO8601",
  "steps": [
    {"step": "criteria_parsing", "status": "completed", "duration_ms": 200}
    // ... same structure can be extended
  ],
  "gate_decision": {
    "passed": false,
    "reason": "P0_FAILURE"
  },
  "notifications_sent": ["dev_lead", "product_manager"]
}
```
