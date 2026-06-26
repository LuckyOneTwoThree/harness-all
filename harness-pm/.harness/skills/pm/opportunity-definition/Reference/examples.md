# Opportunity Definition - 示例集

本文档收录 Opportunity Definition Skill 的完整输出 JSON 示例。

## Output JSON Example

```json
{
  "scoring": {
    "opportunities": [
      {
        "name": "Multi-channel data reconciliation automation",
        "scores": {
          "problem_validity": { "score": 4, "weight": 0.30, "evidence": "Pain point mention rate 12%, behavior data shows users repeatedly trying to solve", "needs_human": false },
          "market_size": { "score": 3, "weight": 0.25, "evidence": "SOM estimate about 30 million", "needs_human": false },
          "feasibility": { "score": 4, "weight": 0.20, "evidence": "Existing tech stack needs minor extension", "needs_human": false },
          "strategic_fit": { "score": null, "weight": 0.15, "evidence": "AI analysis: This opportunity is highly relevant to core strategic direction, recommend score 4-5", "needs_human": true },
          "competitive_moat": { "score": 3, "weight": 0.10, "evidence": "Competitors have partial capability but poor experience", "needs_human": false }
        },
        "weighted_total": null,
        "provisional_rank": null
      }
    ],
    "metadata": {
      "scoring_version": "1.0",
      "awaiting_human_input": true,
      "pending_dimensions": ["strategic_fit"]
    }
  },
  "problem_statement": {
    "problem_statement": "SaaS product operations staff with over 1000 MAU, during the month-end settlement peak, need to quickly verify multi-channel data consistency, but currently face the core pain point of manual comparison being time-consuming and error-prone, because existing tools only support single-channel data export and lack automatic verification capability. If this problem is solved, they will reduce data reconciliation time from an average of 4 hours to under 30 minutes.",
    "data_support": {
      "pain_point_frequency": "12.3%",
      "behavioral_evidence": "78% of users repeatedly export data and manually compare at month-end",
      "confidence": 0.88
    },
    "template_elements": {
      "target_user": "SaaS product operations staff with over 1000 MAU",
      "scenario": "Month-end settlement peak",
      "task": "Quickly verify multi-channel data consistency",
      "core_pain": "Manual comparison is time-consuming and error-prone",
      "current_gap": "Existing tools only support single-channel data export and lack automatic verification capability",
      "expected_benefit": "Data reconciliation time reduced from an average of 4 hours to under 30 minutes"
    },
    "quality_check": {
      "specific_user_group": { "passed": true, "detail": "Specified 'SaaS product operations staff with over 1000 MAU'" },
      "specific_scenario": { "passed": true, "detail": "Specified 'Month-end settlement peak'" },
      "current_solution_gap": { "passed": true, "detail": "Described 'only support single-channel data export and lack automatic verification capability'" },
      "verifiable": { "passed": true, "detail": "Expected benefit is quantifiable: 4 hours → 30 minutes" },
      "no_solution_preset": { "passed": true, "detail": "Problem description does not contain specific solutions" },
      "all_passed": true,
      "retry_count": 0
    }
  },
  "hmw": {
    "hmw_statements": [
      {
        "id": "hmw-001",
        "statement": "How might we eliminate the cognitive burden barrier for new users in the first-time configuration scenario?",
        "dimension": "eliminate_barriers",
        "problem_ref": "problem_statement.core_pain",
        "data_source": "voice-analysis.json::pain_point_frequency=12%",
        "innovation_space": 4,
        "confidence": 0.85
      },
      {
        "id": "hmw-002",
        "statement": "How might we make the report generation experience faster?",
        "dimension": "enhance_experience",
        "problem_ref": "problem_statement.current_gap",
        "data_source": "behavior-analysis.json::avg_report_time=10min",
        "innovation_space": 3,
        "confidence": 0.90
      }
    ],
    "dimension_coverage": {
      "eliminate_barriers": 3,
      "enhance_experience": 3,
      "create_value": 3,
      "redefine": 2
    },
    "metadata": {
      "total_count": 11,
      "high_innovation_count": 4
    }
  },
  "brief": {
    "title": "SaaS Operations Staff - Multi-channel data reconciliation time-consuming and error-prone",
    "problem_statement": "SaaS product operations staff with over 1000 MAU, during the month-end settlement peak, need to quickly verify multi-channel data consistency, but currently face the core pain point of manual comparison being time-consuming and error-prone, because existing tools only support single-channel data export and lack automatic verification capability. If this problem is solved, they will reduce data reconciliation time from an average of 4 hours to under 30 minutes.",
    "evidence_summary": {
      "user_research": {
        "pain_point_frequency": "12.3% of users mentioned this pain point",
        "behavioral_evidence": "78% of target users repeatedly manually export and compare at month-end",
        "persona_summary": "Mainly affected group is operations staff of mid-sized SaaS products",
        "core_jobs": "Data reconciliation, report generation, anomaly investigation",
        "need_type": "Basic need (Kano model), strong dissatisfaction when absent"
      },
      "market_analysis": {
        "tam": "5 billion",
        "sam": "1.5 billion",
        "som": "120 million",
        "growth_rate": "Annual growth rate about 25%"
      },
      "competitive_landscape": {
        "competitor_capabilities": "Mainstream competitors only support single-channel data management",
        "market_gap": "Multi-channel data automatic reconciliation capability missing",
        "barrier_analysis": "Data integration capability constitutes a certain barrier"
      }
    },
    "opportunity_score": {
      "weighted_total": 3.85,
      "dimensions": {
        "problem_validity": { "score": 4, "weight": 0.30 },
        "market_size": { "score": 4, "weight": 0.25 },
        "feasibility": { "score": 4, "weight": 0.20 },
        "strategic_fit": { "score": 4, "weight": 0.15 },
        "competitive_moat": { "score": 3, "weight": 0.10 }
      }
    },
    "hmw_statements": [
      { "id": "hmw-001", "statement": "How might we eliminate the cognitive burden barrier for new users in the first-time configuration scenario?", "innovation_space": 4 },
      { "id": "hmw-002", "statement": "How might we make the report generation experience faster?", "innovation_space": 3 }
    ],
    "key_assumptions": [
      { "assumption": "Target users are willing to pay for the automatic reconciliation feature", "type": "viability", "testability": "Validate through willingness-to-pay research or MVP pricing test", "risk_if_wrong": "high" },
      { "assumption": "Multi-channel data interfaces can be unified and standardized", "type": "feasibility", "testability": "Validate through technical pre-research on 3-5 mainstream channel data interfaces", "risk_if_wrong": "high" }
    ],
    "recommended_next_step": "Recommend entering the solution exploration phase, prioritizing validation of high-risk assumptions (willingness to pay and data interface standardization), which can be advanced in parallel through smoke testing and technical pre-research.",
    "human_decisions_needed": [
      { "item": "Confirm strategic fit score", "context": "AI recommends score 4, need human to confirm whether it aligns with company strategic direction", "urgency": "high" },
      { "item": "Confirm validation priority for high-risk assumptions", "context": "2 high-risk assumptions need to decide validation order and resource allocation", "urgency": "high" }
    ]
  },
  "metadata": {
    "version": "3.0",
    "generated_at": "2026-05-14T21:00:00Z",
    "source_files": [
      "docs/discovery/user-research.md (append \"User Voice Analysis\" section)
      "docs/discovery/user-research.md (append \"User Behavior Analysis\" section)
      "docs/discovery/market-analysis.md (\"Market Size\" section)
      "docs/discovery/market-analysis.md (\"Competitive Analysis\" section)
    ]
  }
}
```
