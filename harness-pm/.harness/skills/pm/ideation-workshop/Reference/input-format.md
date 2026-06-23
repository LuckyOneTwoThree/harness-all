<!-- Reference material extracted from SKILL.md, consult as needed -->

# Input Format

```json
{
  "problem_statement": "Core problem description to be solved",
  "user_research_data": {
    "interviews": [
      {
        "user_id": "User identifier",
        "quotes": ["Direct user quotes"],
        "pain_points": ["Pain point description"],
        "context": "Use scenario"
      }
    ],
    "surveys": [
      {
        "question": "Survey question",
        "responses": ["User responses"],
        "insights": ["Key insights"]
      }
    ],
    "behavior_data": {
      "metrics": "Behavioral data metrics",
      "patterns": ["User behavior patterns"]
    }
  },
  "current_solution": {
    "description": "Detailed description of the current product solution",
    "features": ["Feature 1", "Feature 2"],
    "limitations": ["Limitations of the current solution"]
  },
  "competitor_solutions": [
    {
      "competitor_name": "Competitor name",
      "solution_description": "Competitor solution description",
      "key_features": ["Key feature 1", "Key feature 2"],
      "strengths": ["Strength 1", "Strength 2"],
      "weaknesses": ["Weakness 1", "Weakness 2"]
    }
  ],
  "product_context": {
    "strategic_goals": ["Strategic goal 1", "Strategic goal 2"],
    "resource_constraints": ["Resource constraint 1", "Resource constraint 2"],
    "timeline": "Time constraints",
    "risk_tolerance": "Risk appetite"
  }
}
```
