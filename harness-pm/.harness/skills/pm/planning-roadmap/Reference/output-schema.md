### Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| roadmap.strategic_themes | array | Yes | 3-5 strategic themes |
| roadmap.strategic_themes[].theme | string | Yes | Theme name |
| roadmap.strategic_themes[].okr_reference | string | Yes | Linked OKR |
| roadmap.strategic_themes[].priority | number | No | Theme priority order |
| roadmap.quarterly_epics | array | Yes | Quarterly Epic list |
| roadmap.quarterly_epics[].quarter | string | Yes | Quarter identifier |
| roadmap.quarterly_epics[].epics | array | Yes | Epic list |
| roadmap.quarterly_epics[].epics[].name | string | Yes | Epic name, cannot be empty |
| roadmap.quarterly_epics[].epics[].success_metric | string | No | Success metric |
| roadmap.quarterly_epics[].epics[].rice_score | number | Yes | RICE score |
| roadmap.quarterly_epics[].epics[].effort | number | Yes | Effort (person-months) |
| roadmap.quarterly_epics[].epics[].dependencies | array | No | Dependency list |
| roadmap.quarterly_epics[].epics[].risks | array | Yes | Risk list |
| roadmap.quarterly_epics[].epics[].risks[].risk | string | Yes | Risk description |
| roadmap.quarterly_epics[].epics[].risks[].likelihood | string | Yes | Likelihood, enum: high/medium/low |
| roadmap.quarterly_epics[].epics[].risks[].mitigation | string | No | Mitigation measure |
| roadmap.now_next_later | object | Yes | Three-tier layering |
| roadmap.now_next_later.now | array | Yes | Current quarter Epics |
| roadmap.now_next_later.now[].epic | string | Yes | Epic name |
| roadmap.now_next_later.now[].quarter | string | No | Quarter identifier |
| roadmap.now_next_later.now[].rationale | string | No | Tiering rationale |
| roadmap.now_next_later.next | array | Yes | Next quarter Epics |
| roadmap.now_next_later.next[].epic | string | Yes | Epic name |
| roadmap.now_next_later.next[].quarter | string | No | Quarter identifier |
| roadmap.now_next_later.next[].rationale | string | No | Tiering rationale |
| roadmap.now_next_later.later | array | Yes | Long-term Epics |
| roadmap.now_next_later.later[].epic | string | Yes | Epic name |
| roadmap.now_next_later.later[].quarter | string | No | Quarter identifier |
| roadmap.now_next_later.later[].rationale | string | No | Tiering rationale |

```yaml
roadmap:
  strategic_themes:
    - theme: "User Growth"
      okr_reference: "O1: Increase user engagement"
      priority: 1
    - theme: "Monetization"
      okr_reference: "O2: Optimize unit economics"
      priority: 2
  quarterly_epics:
    - quarter: "Q1 2024"
      epics:
        - epic: "Onboarding optimization"
          success_metric: "New user activation rate increased by 30%"
          rice_score: 85
          effort: 3
          dependencies: ["Design resources"]
          risks:
            - risk: "Technical implementation complexity"
              likelihood: "medium"
              mitigation: "Reserve time for technical research"
          key_assumptions:
            - "Data analysis supports optimization direction"
    - quarter: "Q2 2024"
      epics:
        - epic: "Social feature development"
          success_metric: "User interaction rate increased by 50%"
          rice_score: 72
          effort: 5
          dependencies: ["Backend API support"]
          risks:
            - risk: "User privacy compliance"
              likelihood: "high"
              mitigation: "Legal team involved early"
          key_assumptions:
            - "High user acceptance after feature launch"
  now_next_later:
    now:
      - epic: "Onboarding optimization"
        quarter: "Q1"
        rationale: "High RICE score, directly supports OKR"
    next:
      - epic: "Social feature development"
        quarter: "Q2"
        rationale: "Depends on Q1 data validation, needs further research"
    later:
      - epic: "International expansion"
        quarter: "Q3+"
        rationale: "Long-term strategic direction, needs market validation"
```
