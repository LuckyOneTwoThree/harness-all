# Usability Testing - JSON Examples

This file collects all JSON code blocks referenced by `SKILL.md` for the `validation-usability` skill. Each section corresponds to a step or output in the main skill flow.

## Step 1: Determine Test Goals

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

## Step 2: Generate Task Scripts

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

## Step 3: Generate Recruitment Screening Survey

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

## Step 4: Generate Observation Record Template

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

## Step 5: Structured Test Record Organization

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

## Step 6: Automatic Problem Clustering

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

## Step 7: Insight Extraction

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

## Step 8: Generate Improvement Suggestions

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

## Output File: usability_report.json

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

## Complete Example: Course Recommendation Feature Usability Test Report

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
