# PRD Generator Example Data

> This document provides a complete prd.json example for the design-prd Skill, for reference by downstream Backend/UI Skills for programmatic consumption. The example scenario is a PRD-S level complete artifact for the "Course Recommendation Feature".

## Complete prd.json Example

Scenario: An online learning platform's "Course Recommendation Feature" PRD-S level document, containing real data for all 7 top-level arrays (features, pages, entities, user_flows, non_functional_requirements, tracking_plan, traceability).

```json
{
  "prd_id": "PRDS-2025-06-001",
  "version": "v1.0",
  "level": "S",
  "status": "approved",
  "meta": {
    "title": "Course Recommendation Feature PRD",
    "owner": "Zhang San (Product Manager)",
    "created_at": "2025-06-01T09:00:00+08:00",
    "updated_at": "2025-06-15T16:30:00+08:00"
  },
  "goals": [
    {
      "goal_id": "G001",
      "description": "Improve learner course discovery efficiency and learning engagement",
      "okr_alignment": "O2-Improve user learning engagement",
      "success_metrics": [
        {
          "metric_name": "Recommended course click-through rate",
          "target_value": "25",
          "current_value": "12",
          "unit": "%"
        },
        {
          "metric_name": "Recommended course completion rate",
          "target_value": "60",
          "current_value": "45",
          "unit": "%"
        }
      ]
    }
  ],
  "features": [
    {
      "feature_id": "F001",
      "name": "Personalized Recommendation",
      "description": "Based on learner learning history, interest tags, and behavior data, display a personalized course list on the recommendation homepage, supporting refresh and feedback",
      "priority": "must",
      "status": "planned",
      "goal_id": "G001",
      "driven_by": {
        "north_star_metric": "Learner weekly active learning duration",
        "okr_objective": "O2-Improve user learning engagement",
        "kr_id": "KR2.1",
        "expected_lift": "Recommendation click-through rate increased from 12% to 25%"
      },
      "acceptance_criteria": [
        {
          "ac_id": "AC-001",
          "given": "Learner is logged in and has learning history",
          "when": "Learner enters the recommendation homepage",
          "then": "Display no fewer than 10 personalized recommended courses within 3 seconds, with each course including a recommendation reason"
        },
        {
          "criterion_id": "AC002",
          "given": "Learner clicks \"Not Interested\" on the recommendation homepage",
          "when": "Learner provides \"Not Interested\" feedback on a recommended course",
          "then": "The course is immediately removed from the list and will not be recommended again within 30 days"
        }
      ],
      "dependencies": [],
      "related_pages": ["P001", "P002"],
      "related_entities": ["E001", "E002"]
    },
    {
      "feature_id": "F002",
      "name": "Learning Path Recommendation",
      "description": "Based on the learner's selected career direction and current level, generate structured learning paths and recommend course combinations by stage",
      "priority": "should",
      "status": "planned",
      "goal_id": "G001",
      "driven_by": {
        "north_star_metric": "Learner weekly active learning duration",
        "okr_objective": "O2-Improve user learning engagement",
        "kr_id": "KR2.2",
        "expected_lift": "Completion rate increased from 45% to 60%"
      },
      "acceptance_criteria": [
        {
          "ac_id": "AC-003",
          "given": "Learner has selected the career direction \"Frontend Engineer\"",
          "when": "Learner views learning path recommendations",
          "then": "Display course paths arranged in three stages: Foundation-Advanced-Practical, with 3-5 courses per stage"
        }
      ],
      "dependencies": ["F001"],
      "related_pages": ["P001"],
      "related_entities": ["E001"]
    }
  ],
  "pages": [
    {
      "page_id": "P001",
      "name": "Recommendation Homepage",
      "route": "/recommend",
      "description": "Display personalized recommended courses and learning path entries, supporting refresh, feedback, and category filtering",
      "data_requirements": [
        {
          "data_name": "Personalized recommended course list",
          "source": "api",
          "data_operations": ["read"],
          "related_entity": "E001",
          "fields": ["course_id", "title", "cover_url", "duration", "level", "match_score", "recommend_reason"],
          "description": "Get personalized course list from recommendation service, sorted by match score in descending order"
        },
        {
          "data_name": "Learning path list",
          "source": "api",
          "data_operations": ["read"],
          "related_entity": "E001",
          "fields": ["path_id", "path_name", "stage_count", "course_count", "progress"],
          "description": "Get the list of learning paths the learner has subscribed to and recommended paths"
        },
        {
          "data_name": "Learner preference tags",
          "source": "cache",
          "data_operations": ["read"],
          "related_entity": "E002",
          "fields": ["user_id", "interest_tags", "career_goal", "current_level"],
          "description": "Read learner preferences from local cache for recommendation explanation display"
        }
      ],
      "functional_areas": ["Recommended course waterfall", "Learning path entry", "Category filter", "Feedback action"],
      "user_flows": ["UF001"],
      "states": [
        {
          "state_name": "Loading",
          "description": "Display skeleton screen on first entry or refresh",
          "triggers": ["Page entry", "Pull-to-refresh"]
        },
        {
          "state_name": "Empty recommendations",
          "description": "Display guidance content when learner has no learning history",
          "triggers": ["Recommendation results are empty"]
        },
        {
          "state_name": "Normal display",
          "description": "Display recommended course list and learning paths",
          "triggers": ["Recommendation data loading complete"]
        }
      ]
    },
    {
      "page_id": "P002",
      "name": "Course Detail Page",
      "route": "/courses/:courseId",
      "description": "Display complete course information, chapter directory, instructor introduction, supporting immediate learning and joining path",
      "data_requirements": [
        {
          "data_name": "Course details",
          "source": "api",
          "data_operations": ["read"],
          "related_entity": "E001",
          "fields": ["course_id", "title", "description", "cover_url", "duration", "level", "price", "instructor", "chapters", "rating", "enrolled_count"],
          "description": "Get complete course information, including chapter directory and instructor information"
        },
        {
          "data_name": "Learner learning progress",
          "source": "api",
          "data_operations": ["read", "update"],
          "related_entity": "E002",
          "fields": ["user_id", "course_id", "progress", "last_lesson_id", "completed_lessons"],
          "description": "Get the learner's progress in this course, supporting updates"
        }
      ],
      "functional_areas": ["Course information display", "Chapter directory", "Instructor introduction", "Learning action", "Related recommendations"],
      "user_flows": ["UF001"],
      "states": [
        {
          "state_name": "Not started learning",
          "description": "Display \"Start Learning\" button",
          "triggers": ["Learner has not studied this course"]
        },
        {
          "state_name": "Learning in progress",
          "description": "Display \"Continue Learning\" button and last learning position",
          "triggers": ["Learner has started but not completed"]
        },
        {
          "state_name": "Completed",
          "description": "Display \"Review\" button and completion certificate entry",
          "triggers": ["Learner has completed all chapters"]
        }
      ]
    }
  ],
  "entities": [
    {
      "entity_id": "E001",
      "name": "Course",
      "description": "Course entity, including basic course information, chapters, difficulty, and recommendation metadata",
      "fields": [
        {
          "field_name": "course_id",
          "type": "string",
          "required": true,
          "description": "Course unique identifier",
          "constraints": "UUID format"
        },
        {
          "field_name": "title",
          "type": "string",
          "required": true,
          "description": "Course title",
          "constraints": "Maximum length 100 characters"
        },
        {
          "field_name": "description",
          "type": "text",
          "required": true,
          "description": "Course description",
          "constraints": "Maximum length 2000 characters"
        },
        {
          "field_name": "cover_url",
          "type": "string",
          "required": true,
          "description": "Course cover image URL",
          "constraints": "HTTPS link"
        },
        {
          "field_name": "duration",
          "type": "integer",
          "required": true,
          "description": "Total course duration (minutes)",
          "constraints": "Greater than 0"
        },
        {
          "field_name": "level",
          "type": "enum",
          "required": true,
          "description": "Course difficulty",
          "constraints": "Enum values: beginner/intermediate/advanced"
        },
        {
          "field_name": "status",
          "type": "enum",
          "required": true,
          "description": "Course status",
          "constraints": "Enum values: draft/published/offline"
        },
        {
          "field_name": "instructor_id",
          "type": "string",
          "required": true,
          "description": "Instructor ID",
          "constraints": "Associated with instructor table"
        },
        {
          "field_name": "tags",
          "type": "array",
          "required": false,
          "description": "Course tags",
          "constraints": "String array, up to 10 items"
        },
        {
          "field_name": "match_score",
          "type": "number",
          "required": false,
          "description": "Recommendation match score",
          "constraints": "0-1.0, calculated by recommendation service"
        }
      ],
      "relationships": [
        {
          "target_entity_id": "E002",
          "type": "many_to_many",
          "description": "A course can be studied by multiple learners, and a learner can study multiple courses"
        }
      ],
      "api_endpoints": [
        {
          "method": "GET",
          "path": "/api/v1/courses/:courseId",
          "description": "Get course details"
        },
        {
          "method": "GET",
          "path": "/api/v1/recommend/courses",
          "description": "Get personalized recommended course list"
        },
        {
          "method": "POST",
          "path": "/api/v1/recommend/feedback",
          "description": "Submit recommendation feedback (not interested, etc.)"
        }
      ]
    },
    {
      "entity_id": "E002",
      "name": "User",
      "description": "Learner entity, including basic learner information, learning preferences, and learning progress",
      "fields": [
        {
          "field_name": "user_id",
          "type": "string",
          "required": true,
          "description": "Learner unique identifier",
          "constraints": "UUID format"
        },
        {
          "field_name": "nickname",
          "type": "string",
          "required": true,
          "description": "Learner nickname",
          "constraints": "Maximum length 30 characters"
        },
        {
          "field_name": "career_goal",
          "type": "string",
          "required": false,
          "description": "Career direction",
          "constraints": "e.g., Frontend Engineer/Product Manager"
        },
        {
          "field_name": "current_level",
          "type": "enum",
          "required": false,
          "description": "Current learning level",
          "constraints": "Enum values: beginner/intermediate/advanced"
        },
        {
          "field_name": "interest_tags",
          "type": "array",
          "required": false,
          "description": "Interest tags",
          "constraints": "String array, up to 20 items"
        },
        {
          "field_name": "status",
          "type": "enum",
          "required": true,
          "description": "Learner status",
          "constraints": "Enum values: active/inactive/banned"
        },
        {
          "field_name": "registered_at",
          "type": "datetime",
          "required": true,
          "description": "Registration time",
          "constraints": "ISO8601 format"
        },
        {
          "field_name": "last_active_at",
          "type": "datetime",
          "required": true,
          "description": "Last active time",
          "constraints": "ISO8601 format"
        }
      ],
      "relationships": [
        {
          "target_entity_id": "E001",
          "type": "many_to_many",
          "description": "A learner can study multiple courses, and a course can be studied by multiple learners"
        }
      ],
      "api_endpoints": [
        {
          "method": "GET",
          "path": "/api/v1/users/:userId/profile",
          "description": "Get learner profile information"
        },
        {
          "method": "PATCH",
          "path": "/api/v1/users/:userId/preferences",
          "description": "Update learner preferences (career direction, interest tags)"
        }
      ]
    }
  ],
  "user_flows": [
    {
      "flow_id": "UF001",
      "name": "View Recommended Courses",
      "description": "Learner browses personalized recommended courses from the recommendation homepage, enters the course detail page to view complete information and starts learning",
      "entry_page": "P001",
      "steps": [
        {
          "step_id": "S001",
          "action": "Enter recommendation homepage",
          "page_id": "P001",
          "expected_outcome": "Display personalized recommended course list and learning path entries",
          "error_handling": "On network exception, display cached data and prompt \"Network exception, displaying historical data\""
        },
        {
          "step_id": "S002",
          "action": "Browse recommended courses and click on a card of interest",
          "page_id": "P001",
          "expected_outcome": "Navigate to course detail page",
          "error_handling": null
        },
        {
          "step_id": "S003",
          "action": "View course details and chapter directory",
          "page_id": "P002",
          "expected_outcome": "Display complete course information and chapter list",
          "error_handling": "When course is offline, display \"Course is offline\" prompt and return to recommendation homepage"
        },
        {
          "step_id": "S004",
          "action": "Click \"Start Learning\" or \"Continue Learning\"",
          "page_id": "P002",
          "expected_outcome": "Enter course learning page to start or continue learning",
          "error_handling": "When not logged in, redirect to login page and return to original page after login"
        }
      ],
      "alternative_paths": [
        {
          "condition": "Learner is not interested in recommended courses",
          "steps": ["S002"]
        },
        {
          "condition": "Learner chooses a learning path instead of a single course",
          "steps": ["S001"]
        }
      ]
    }
  ],
  "non_functional_requirements": {
    "performance": [
      {
        "requirement": "Recommendation list API response time",
        "metric": "P95 response time",
        "target": "≤500ms"
      },
      {
        "requirement": "Recommendation homepage first screen render time",
        "metric": "First Contentful Paint (FCP)",
        "target": "≤1.5s"
      }
    ],
    "availability": [
      {
        "requirement": "Recommendation service availability",
        "metric": "Service availability rate",
        "target": "≥99.9%",
        "measurement": "Monthly statistics, monitoring API success rate"
      },
      {
        "requirement": "Recommendation service degradation capability",
        "metric": "Degradation trigger time",
        "target": "Degrade to popular courses within 3 seconds when recommendation service is abnormal",
        "measurement": "Fault drill verification"
      }
    ],
    "security": [
      {
        "category": "authorization",
        "requirement": "Learners can only view their own learning progress and recommendations",
        "implementation": "JWT-based authentication, API layer validates user_id and token consistency"
      },
      {
        "category": "compliance",
        "requirement": "Recommendation algorithm must comply with Personal Information Protection Law",
        "implementation": "Do not collect unnecessary personal information, provide an entry to turn off recommendation preferences"
      }
    ],
    "observability": [
      {
        "dimension": "metrics",
        "indicator": "Recommendation click-through rate, recommendation conversion rate, recommendation service error rate",
        "alert_threshold": "Error rate >1% for 5 minutes triggers alert"
      },
      {
        "dimension": "logs",
        "indicator": "Recommendation request and response logs",
        "alert_threshold": "Abnormal responses (non-200) >50/minute triggers alert"
      }
    ]
  },
  "tracking_plan": {
    "events": [
      {
        "event_id": "EV001",
        "event_name": "recommend_click",
        "trigger": "Learner clicks a course card on the recommendation homepage",
        "properties": [
          {
            "property_name": "course_id",
            "type": "string",
            "required": true
          },
          {
            "property_name": "recommend_reason",
            "type": "string",
            "required": true
          },
          {
            "property_name": "match_score",
            "type": "number",
            "required": true
          },
          {
            "property_name": "position",
            "type": "integer",
            "required": true
          }
        ],
        "related_metric": "Recommended course click-through rate"
      },
      {
        "event_id": "EV002",
        "event_name": "course_view",
        "trigger": "Learner enters course detail page",
        "properties": [
          {
            "property_name": "course_id",
            "type": "string",
            "required": true
          },
          {
            "property_name": "source",
            "type": "string",
            "required": true
          },
          {
            "property_name": "view_duration",
            "type": "integer",
            "required": false
          }
        ],
        "related_metric": "Course detail page views"
      },
      {
        "event_id": "EV003",
        "event_name": "recommend_feedback",
        "trigger": "Learner submits \"Not Interested\" feedback on a recommended course",
        "properties": [
          {
            "property_name": "course_id",
            "type": "string",
            "required": true
          },
          {
            "property_name": "feedback_type",
            "type": "string",
            "required": true
          }
        ],
        "related_metric": "Recommendation satisfaction"
      }
    ],
    "validation": {
      "coverage_target": 0.95,
      "data_delay_threshold": "T+1 day"
    }
  },
  "traceability": [
    {
      "feature_id": "F001",
      "goal_id": "G001",
      "upstream_source": "opportunity_definition",
      "upstream_artifact_id": "OPP-2025-05-003"
    },
    {
      "feature_id": "F002",
      "goal_id": "G001",
      "upstream_source": "insight_analysis",
      "upstream_artifact_id": "INS-2025-05-007"
    },
    {
      "feature_id": "F001",
      "goal_id": "G001",
      "upstream_source": "okr_candidates",
      "upstream_artifact_id": "KR2.1"
    }
  ]
}
```

## Example Notes

### 7 Top-level Arrays Coverage

| Top-level Array | Example Count | Description |
|----------|----------|------|
| features | 2 | Personalized Recommendation (must), Learning Path Recommendation (should) |
| pages | 2 | Recommendation Homepage, Course Detail Page |
| entities | 2 | Course, User, both include complete fields and relationships |
| user_flows | 1 | View Recommended Courses (with 4 steps and 2 alternative paths) |
| non_functional_requirements | 4 dimensions | performance (2), availability (2), security (2), observability (2) |
| tracking_plan | 3 events | recommend_click, course_view, recommend_feedback |
| traceability | 3 trace relationships | Feature→Goal, Feature→Opportunity Definition, Feature→OKR |

### Reference Consistency Self-check

- `P001`, `P002` in `features[0].related_pages` exist in `pages[]` ✓
- `E001`, `E002` in `features[0].related_entities` exist in `entities[]` ✓
- `UF001` in `pages[0].user_flows` exists in `user_flows[]` ✓
- `user_flows[0].entry_page` is `P001`, exists in `pages[]` ✓
- `user_flows[0].steps[].page_id` are `P001`, `P002`, both exist in `pages[]` ✓
- `traceability[].feature_id` are `F001`, `F002`, both exist in `features[]` ✓
- `traceability[].goal_id` is `G001`, exists in `goals[]` ✓
