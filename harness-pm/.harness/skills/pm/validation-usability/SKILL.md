---
name: validation-usability
description: Used when assistance is needed for usability testing. Usability testing assistance tool that provides AI-supported help across pre-test, during-test, and post-test phases: generates task scripts and recruitment surveys before testing, and organizes data and generates insight reports after testing. Note: Actual test execution must be led by a human researcher. Keywords: usability testing, task scripts, recruitment screening, problem clustering, insight extraction, user experience testing, test tasks. This Skill consumes the method selection from validation-experiment (when method=usability test), generating specific test task scripts, recruitment surveys, and test reports.
---
# Usability Testing Assistance

## When to use
- How to conduct usability testing
- Help me design test tasks
- How to run user experience testing

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/product/PRD.md
- docs/metrics/experiment-report.md
- docs/handoff/design-to-solo.md

## Outputs
- docs/product/PRD.md
- docs/handoff/pm-to-design.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **User behavior is more truthful than user opinions** — Observe what users do, not what they say
2. **5 users find 85% of problems** — Usability testing doesn't need large samples; 5-8 people can uncover major issues
3. **Severity determines fix priority** — Critical issues must be fixed; minor issues can be scheduled
4. **Test reports must be actionable** — Every finding must map to an improvement suggestion; non-actionable findings are noise

### Basic Information

| Attribute | Value |
|------|-----|
| Pipeline ID | 13 |
| Name | Usability Testing Assistance |
| Execution Mode | 👤→🤖 Human executes, AI assists |
| Input | Assumption map + MVP features + Test goals |

## Interaction Mode

👤→🤖 Human executes, AI assists

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Usability test plan | object | Yes | docs/product/PRD.md ("Assumption Map" section) | Test goals, assumption map, MVP features |
| Test participants | object | Yes | User-provided | Target user personas, recruitment screening criteria |
| Test task scenarios | object | Yes | User-provided or harness-design output | Usability hypotheses to validate and task scripts (if harness-design has produced prototypes, read prototype paths referenced in docs/handoff/design-to-solo.md) |
| Experiment method selection | object | ○ | docs/metrics/experiment-report.md ("Experiment Design" section) | When method=usability test, consumes the method selection and experiment framework from validation-experiment |

## Execution Steps

### ⚠️ Important Note

Usability testing is the only phase that must be **led by a human researcher**. AI provides assistance in this workflow:

| Phase | Executor | AI Assistance Content |
|------|--------|------------|
| Pre-test | 👤 Preparation | Generate task scripts, recruitment surveys, observation record templates |
| During test | 👤 Execution | Human researcher leads the test |
| Post-test | 👤+🤖 | AI organizes and analyzes, human reviews and confirms |

### Pre-test AI Assistance

#### Step 1: Determine Test Goals

Define usability test goals based on the assumption map:

```json
{
  "test_goals": [
    {
      "goal_id": "TG001",
      "related_assumption": "A001",
      "goal_description": "Validate whether users can smoothly browse recommended content"
    }
  ]
}
```

#### Step 2: Generate Task Scripts

**Rule**: Each task maps to a usability hypothesis to be validated

> 🔗 **Upstream Consumption**: When experiment_method input exists and selected_method=usability_test, design specific test task scripts based on experiment_framework (hypotheses, metrics, sample size, duration); otherwise, design independently based on the assumption map and test goals.

```json
{
  "task_script": [
    {
      "task_id": "T001",
      "task_description": "Find an interesting piece of recommended content within 3 seconds",
      "related_assumption": "A002",
      "success_criteria": "Click completed within 3 seconds",
      "hints": ["Hint text (if needed)"]
    }
    // ... same structure extensible
  ]
}
```

#### Step 3: Generate Recruitment Screening Survey

**Screening Criteria**:
- Target user persona match
- Product usage experience requirements
- No conflict of interest

```json
{
  "recruitment_survey": {
    "screening_questions": [
      {
        "question_id": "SQ001",
        "question": "Have you used products with similar recommendation features?",
        "options": ["Frequently", "Occasionally", "Never"],
        "correct_answer": "Frequently|Occasionally"
      }
      // ... same structure extensible
    ],
    "target_sample_size": 8,
    "oversample_ratio": 1.25
  }
}
```

#### Step 4: Generate Observation Record Template

```json
{
  "observation_template": {
    "participant_id": "",
    "test_date": "",
    "tasks": [
      {
        "task_id": "T001",
        "time_on_task": "seconds",
        "success": true/false,
        "errors": ["Error description"],
        "observations": "Observation notes",
        "quotes": ["User verbatim quote"]
      }
    ],
    "overall_notes": "Overall observations"
  }
}
```

### Post-test AI Assistance

#### Step 5: Structured Test Record Organization

Convert raw test records into structured data:

```json
{
  "structured_records": [
    {
      "participant_id": "P001",
      "task_results": [
        {
          "task_id": "T001",
          "time_seconds": 5,
          "completed": true,
          "errors": [],
          "critical_incidents": []
        }
      ]
    }
  ]
}
```

#### Step 6: Automatic Problem Clustering

**Clustering Dimensions**:

| Dimension | Description |
|------|------|
| Severity | Critical / Major / Moderate / Minor |
| Frequency | High / Medium / Low |
| Affected Stage | Navigation / Operation / Feedback / Content |

**Severity Definitions**:

| Level | Definition | Impact |
|------|------|------|
| Critical (P0) | Task cannot be completed | Causes user abandonment |
| Major (P1) | Task requires significant assistance | Severely impacts efficiency |
| Moderate (P2) | Task is difficult but completed | Affects user experience |
| Minor (P3) | Operation is inconvenient but acceptable | Optimization item |

```json
{
  "problem_clusters": [
    {
      "cluster_id": "PC001",
      "severity": "P1",
      "frequency": "3/8 users",
      "affected_element": "Recommendation list",
      "problem_description": "Users have difficulty understanding the relevance of recommended content",
      "evidence": ["Evidence 1", "Evidence 2"]
    }
  ]
}
```

#### Step 7: Insight Extraction

**Three Types of Insights**:

| Type | Description | Example |
|------|------|------|
| Hypothesis validation | Whether hypothesis is validated | A001 hypothesis confirmed/rejected/partially confirmed |
| Design changes | Design points needing adjustment | Recommendation display position adjustment |
| Unexpected findings | New problems/opportunities discovered during testing | Discovered new user scenario |

```json
{
  "insights": [
    {
      "type": "assumption_validation",
      "assumption_id": "A001",
      "result": "confirmed|rejected|partial",
      "evidence": "Supporting/contradicting evidence"
    }
    // ... same structure extensible, type can be design_changes / unexpected_findings
  ]
}
```

#### Step 8: Generate Improvement Suggestions

**Priority Ranking Rules**:

1. P0 issues → Fix immediately
2. P1 issues → High priority
3. P2 issues → Medium priority
4. P3 issues → Low priority

```json
{
  "improvement_suggestions": [
    {
      "suggestion_id": "IS001",
      "suggestion": "Add a \"Why recommended\" explanation next to recommended content",
      "priority": "P1",
      "problem_ref": "PC001",
      "effort_estimate": "Medium",
      "expected_impact": "High"
    }
  ]
}
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Usability issues and improvement suggestions | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full assessment + usability scoring system + priority ranking + improvement roadmap | Full artifact + extended analysis + deep reasoning |

## Output

**Storage Path**: `docs/product/PRD.md ("Usability Testing" section)`
**Output File**: usability_report.json

```json
{
  "usability_report": {
    "test_summary": {
      "test_date": "2024-01-15",
      "participant_count": 8,
      "test_duration_minutes": 60,
      "test_goals": ["Validate whether learners can quickly find suitable courses"]
    },
    "problems": [
      {
        "problem_id": "P001",
        "severity": "P1",
        "frequency": "3/8",
        "affected_element": "Course recommendation list",
        "description": "Learners cannot understand the connection between recommended courses and their learning progress",
        "evidence": ["6/8 learners expressed uncertainty about the recommendation basis"]
      }
      // ... same structure extensible
    ],
    "insights": [
      {
        "type": "assumption_validation",
        "assumption_id": "A001",
        "result": "confirmed",
        "description": "Assumption A001 partially confirmed"
      }
      // ... same structure extensible, type can be design_changes / unexpected_findings
    ],
    "improvement_suggestions": [
      {
        "suggestion": "Add recommendation rationale and learning progress match display to course recommendation cards",
        "priority": "P1",
        "problem_ref": "P001",
        "effort": "Medium",
        "impact": "High"
      }
      // ... same structure extensible
    ]
  }
}
```

**Output Validation Rules**: See the Output Validation Rules section below

## Decision Rules

| Situation | Handling |
|------|----------|
| P0 issue (task cannot be completed) | Fix immediately, block release |
| Same issue encountered by 3/8+ users | Mark as high-frequency issue, prioritize |
| Hypothesis overturned | Update assumption map, adjust design direction |
| Fewer than 5 test participants | Results are for reference only; recommend additional testing |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Problem severity grading (P0/P1/P2/P3 grading is reasonable)
- [ ] Insight hypothesis linkage (insights correspond to the assumption map)

### P1 Checks (must pass for standard/deep)

- [ ] Improvement suggestions actionable (suggestions are clear and actionable)
- [ ] Data completeness (test data is complete with no omissions)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| Prototype data missing | User provides design description, generate test scripts | Lacks prototype data, test tasks may be less precise | Ask user to provide design description and page screenshots or upload prototype file |
| Assumption map missing | User provides design description, generate test scripts | Lacks assumption map data, test goals may be less focused | Ask user to provide key hypothesis list or upload assumption-map file |
| Both prototype and assumption map missing | User provides design description, generate test scripts | Overall confidence reduced, test scripts may be incomplete | Ask user to provide design description and key hypotheses |
| All upstream files missing | Prompt user to run preceding stages first, or generate test scripts based on user description | Output is only a basic test framework | Ask user to provide design description, core features, and test goals |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| usability_report | object | Yes | Usability test report |
| usability_report.test_summary | object | Yes | Test summary |
| usability_report.test_summary.participant_count | integer | Yes | Number of participants |
| usability_report.test_summary.test_goals | array | Yes | Test goals list |
| usability_report.problems | array | Yes | Problems list |
| usability_report.problems[].problem_id | string | Yes | Problem unique identifier |
| usability_report.problems[].severity | string | Yes | Severity (P0/P1/P2/P3) |
| usability_report.problems[].frequency | string | Yes | Occurrence frequency |
| usability_report.problems[].affected_element | string | Yes | Affected element |
| usability_report.problems[].description | string | Yes | Problem description |
| usability_report.insights | array | Yes | Insights list |
| usability_report.insights[].type | string | Yes | Insight type |
| usability_report.improvement_suggestions | array | Yes | Improvement suggestions list |
| usability_report.improvement_suggestions[].suggestion | string | Yes | Suggestion content |
| usability_report.improvement_suggestions[].priority | string | Yes | Priority |
| usability_report.improvement_suggestions[].problem_ref | string | Yes | Linked problem ID |

## Upstream Change Response

### Upstream Change Impact

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Prototype change (page/interaction modification) | Test tasks, test scripts | Mark affected test tasks; recommend human confirm whether to update test scripts |
| Assumption map change (hypothesis add/remove or score change) | Test goals, hypothesis validation items | Mark affected test goals; recommend human confirm whether to adjust test focus |
| MVP scope change | Test scope | Mark affected test scope; recommend human confirm whether to adjust test coverage |

### Downstream Notification Mechanism

| Usability Test Report Change Type | Notification Scope | Notification Method |
|----------------------|----------|----------|
| Problem finding add/remove | harness-design (via docs/handoff/pm-to-design.md feedback) | Mark problem change, trigger harness-design prototype and interaction spec update |
| Hypothesis validation result change | validation-assumption-map, validation-mvp | Mark validation result change, trigger assumption map and MVP scope update |
| Improvement suggestion change | harness-design (via docs/handoff/pm-to-design.md feedback) | Mark suggestion change, trigger harness-design prototype update |

---

## Usage Example

**Test Execution**: Human researcher leads, 8 users participate

**AI-Assisted Output**: Same structure as the output JSON above, where `problems`/`insights`/`improvement_suggestions` arrays are populated based on actual test results, with field meanings consistent with the output validation rules.

### Complete Example: Course Recommendation Feature Usability Test Report

Scenario: Conducting an 8-person usability test on the "Course Recommendation Feature" to validate whether learners can quickly find suitable courses and understand the recommendation rationale. Below is the complete `usability_report.json` produced by AI post-test organization.

```json
{
  "usability_report": {
    "test_summary": {
      "test_date": "2025-06-18",
      "participant_count": 8,
      "test_duration_minutes": 75,
      "test_goals": [
        "Validate whether learners can quickly find courses of interest on the recommendation homepage",
        "Validate whether learners can understand the connection between recommended courses and their learning progress",
        "Validate whether learners can smoothly navigate from the recommendation homepage to the course detail page"
      ]
    },
    "problems": [
      {
        "problem_id": "P001",
        "severity": "P1",
        "frequency": "5/8",
        "affected_element": "Course recommendation list",
        "affected_users": 5,
        "task_id": "T001",
        "description": "Learners cannot understand the connection between recommended courses and their learning progress; the recommendation rationale display is unclear, leading to low trust in recommended content",
        "evidence": [
          "5/8 learners stated in interviews that they were 'not sure why this course was recommended'",
          "3/8 learners lingered on the recommendation list for over 15 seconds without clicking",
          "Learner P003 verbatim: 'These courses don't seem related to what I'm studying'"
        ]
      },
      {
        "problem_id": "P002",
        "severity": "P2",
        "frequency": "3/8",
        "affected_element": "Recommendation homepage \"Not interested\" feedback entry",
        "affected_users": 3,
        "task_id": "T002",
        "description": "The \"Not interested\" feedback button is hidden, making it hard for learners to discover, resulting in low usage of the feedback feature",
        "evidence": [
          "3/8 learners only noticed the feedback button after completing the task",
          "2/8 learners said 'I thought that icon was for favoriting'",
          "Eye-tracking data shows feedback button gaze rate of only 25%"
        ]
      }
    ],
    "insights": [
      {
        "type": "assumption_validation",
        "assumption_id": "A001",
        "result": "partial",
        "description": "Assumption A001 'Learners can quickly find suitable courses' is partially confirmed: learners can find courses, but unclear recommendation rationale leads to overly long decision time",
        "insight_text": "The explainability of recommendation rationale affects click decisions more than recommendation accuracy; learners need to clearly know 'why it was recommended' to build trust",
        "evidence": "5/8 learners showed a 40% increase in click-through rate after seeing the recommendation rationale, but the default rationale was too generic (e.g., 'Based on your learning history')",
        "confidence": 0.85
      },
      {
        "type": "design_changes",
        "assumption_id": "A002",
        "result": "confirmed",
        "description": "Assumption A002 'Learners want to see learning path recommendations' is confirmed; learners have a clear need for structured learning paths",
        "insight_text": "Learners prefer learning paths organized by career goals over scattered individual course recommendations; path recommendations should be the core module of the recommendation homepage",
        "evidence": "6/8 learners proactively asked 'Are there learning paths by direction?', and 2/8 learners expressed willingness to pay for path recommendations",
        "confidence": 0.9
      }
    ],
    "improvement_suggestions": [
      {
        "suggestion_id": "IS001",
        "suggestion": "Add specific recommendation rationale in a prominent position on course recommendation cards (e.g., 'Because you completed JS Basics, we recommend the advanced course React in Practice'), replacing the generic 'Based on learning history'",
        "priority": "P1",
        "problem_ref": "P001",
        "effort": "Medium",
        "estimated_effort": "3 person-days",
        "impact": "High"
      },
      {
        "suggestion_id": "IS002",
        "suggestion": "Move the \"Not interested\" feedback button from the bottom-right corner to the top-right corner of the card, and add a text label and hover tooltip to improve discoverability",
        "priority": "P2",
        "problem_ref": "P002",
        "effort": "Low",
        "estimated_effort": "1 person-day",
        "impact": "Medium"
      },
      {
        "suggestion_id": "IS003",
        "suggestion": "Add a standalone \"Learning Paths\" module at the top of the recommendation homepage, displaying structured paths organized by learner career goals, with stage progress shown for each path",
        "priority": "P1",
        "problem_ref": "P001",
        "effort": "High",
        "estimated_effort": "8 person-days",
        "impact": "High"
      }
    ]
  }
}
```

### Example Notes

| Field Category | Example Count | Key Fields |
|----------|----------|----------|
| problems | 2 | severity (P1/P2), description, affected_users, task_id, evidence |
| insights | 2 | insight_text, evidence, confidence (0.85/0.9), type (assumption_validation/design_changes) |
| improvement_suggestions | 3 | suggestion, priority (P1/P2), estimated_effort (person-days), problem_ref |

**Priority Handling**: P1 issue (P001) maps to 2 improvement suggestions (IS001, IS003), where IS003 is a high-effort high-impact item recommended for the next iteration; P2 issue (P002) maps to a low-effort suggestion (IS002) that can be quickly fixed.
