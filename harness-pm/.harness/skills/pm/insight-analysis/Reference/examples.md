# Insight Analysis - 示例集

本文档收录 Insight Analysis Skill 的推断模式库与完整输出 JSON 示例。

## Step 1b-2: Behavioral Requirement Inference Patterns

- `"Hope to add XX feature"` → Scenario: Need to accomplish YY in XX scenario → Behavior: Currently substituting via ZZ method
- `"Need to support XX"` → Scenario: Cannot accomplish YY under XX condition → Behavior: Switch to competitor or handle manually
- `"XX is too slow/laggy"` → Scenario: Experience hindered during high-frequency operation XX → Behavior: Reduce usage frequency or seek alternatives
- `"Can't find XX"` → Scenario: Lost due to unclear information architecture → Behavior: Repeated searching or asking others for help
- `"XX operation is too complex"` → Scenario: Too many steps in task flow → Behavior: Skip non-essential steps or abandon use
- `"Hope XX can be automatic"` → Scenario: Repetitive operations consume energy → Behavior: Manual execution but generates frustration
- `"XX data is inaccurate"` → Scenario: Decision relies on data but data is unreliable → Behavior: Cross-verify or delay decision

Confidence range: 0.7-0.9

## Step 1b-3: Essential Requirement Inference Patterns

- `"Batch export"` → Reduce repetitive labor → Pursue efficiency and sense of achievement
- `"Multi-language support"` → Serve overseas customers → Pursue business expansion and competitiveness
- `"Real-time notifications"` → Don't want to miss information → Pursue control and security
- `"Simplify operations"` → Reduce cognitive load → Pursue effortless experience and autonomy
- `"Data accuracy"` → Avoid decision errors → Pursue certainty and trust
- `"Personalized customization"` → Adapt to own workflow → Pursue autonomy and belonging
- `"Collaboration features"` → Reduce communication costs → Pursue social connection and team identity

Confidence range: 0.4-0.7

Validation flag: Essential requirement confidence <0.5 → `validation_needed: true`, behavioral requirement confidence <0.7 → `validation_needed: true`

## Output JSON Example

```json
{
  "jtbd": {
    "analysis_metadata": {
      "source_files": ["voice-analysis.json", "behavior-analysis.json"],
      "total_voice_entries": 0,
      "total_behavior_entries": 0,
      "analysis_timestamp": "ISO8601"
    },
    "jobs": [
      {
        "type": "functional",
        "job": "Quickly complete form filling",
        "frequency": 12,
        "current_solution": "Manual field-by-field filling",
        "pain_with_current": "Repetitive labor, time-consuming and error-prone",
        "confidence": 1.0,
        "evidence": ["User interview #23", "Behavior data - form abandonment rate 35%"],
        "sentiment_intensity": 4
      }
      // ... same structure can be extended
    ],
    "summary": {
      "total_jobs": 3,
      "by_type": { "functional": 1, "emotional": 1, "social": 1 }
    }
  },
  "requirement_layers": {
    "analysis_metadata": {
      "source": "Raw requirement list",
      "total_requirements": 2,
      "analysis_timestamp": "ISO8601"
    },
    "requirement_layers": [
      {
        "id": "REQ-001",
        "source": "User feedback",
        "surface": { "content": "Hope to add batch export feature", "confidence": 1.0 },
        "behavioral": { "content": "Operations staff in monthly report scenario need to export multiple reports at once; currently can only export one by one", "confidence": 0.85, "inference_basis": "User feedback frequency 8 times + behavior data: abnormal average dwell time on report export page" },
        "essential": { "content": "Pursue work efficiency, reduce repetitive labor, gain sense of work achievement", "confidence": 0.6, "inference_basis": "Inferred from behavioral requirement + JTBD emotional Job cross-validation" },
        "validation_needed": true,
        "validation_reason": "Essential requirement confidence 0.6 < 0.7, recommend validation through user interviews"
      }
    ],
    "summary": { "total": 2, "needs_validation": 2, "high_confidence": 0 }
  },
  "5whys": {
    "analysis_metadata": {
      "source_files": ["jtbd.json"],
      "total_paths": 1,
      "analysis_timestamp": "ISO8601"
    },
    "phenomenon": {
      "description": "Users abandon in large numbers at step 3 of the registration flow",
      "source": "jtbd.json",
      "metrics": { "drop_off_rate": 0.35, "affected_users": 1200 }
    },
    "chains": [
      { "path_id": "main", "round": 1, "question": "Why do users abandon in large numbers at step 3 of the registration flow?", "answer": "Step 3 requires filling in too much non-essential information", "evidence": "Form has 12 fields, industry average is 5", "confidence": 0.85, "data_support": "high" }
      // ... same structure can be extended
    ],
    "root_cause": "Lack of a phased data collection strategy; treating the registration flow as the only data collection window",
    "actionable_fix": {
      "description": "Implement progressive data collection strategy; keep only core required fields (3-5) in the registration flow",
      "effort": "medium",
      "impact": "high",
      "suggested_metrics": ["Registration completion rate increase", "Step 3 abandonment rate decrease"]
    }
  },
  "kano": {
    "analysis_metadata": {
      "source_files": ["voice-analysis.json", "requirement-layers.json"],
      "total_features": 3,
      "analysis_timestamp": "ISO8601"
    },
    "kano_classification": [
      { "feature_id": "FEAT-001", "feature_name": "Batch export", "category": "must-be", "confidence": 0.85, "evidence": { "negative_rate": 0.75, "frequency": 0.08, "positive_rate": 0.25, "usage_depth_correlation": 0.6, "avg_sentiment_intensity": 3.5 }, "review_period": "6 months" }
      // ... same structure can be extended
    ],
    "boundary_cases": [
      { "feature_id": "FEAT-002", "reason": "Frequency near attractive/one-dimensional boundary", "suggested_action": "Supplement more user feedback data or conduct dedicated survey validation" }
    ],
    "summary": { "must_be": 1, "one_dimensional": 0, "attractive": 1, "indifferent": 1, "needs_judgment": 1 }
  },
  "priority_scoring": {
    "analysis_metadata": {
      "source_files": ["requirement-layers.json", "kano.json", "jtbd.json", "5whys.json"],
      "scoring_formula": "Base score (0.35×pain + 0.30×frequency + 0.35×solvability) + KANO bonus (base score × (coefficient - 1))",
      "weights_confirmed_by_human": false,
      "analysis_timestamp": "ISO8601"
    },
    "priority_list": [
      {
        "rank": 1,
        "requirement_id": "REQ-001",
        "requirement_name": "Batch export feature",
        "scores": {
          "pain_intensity": { "score": 4, "basis": "Sentiment intensity 4 + 5 Whys root cause confirmed" },
          "frequency_weight": { "score": 4, "basis": "Mention frequency 8%, affected user ratio about 25%" },
          "solvability": { "score": 3, "basis": "Default value, pending tech team confirmation", "confirmed": false },
          "kano_coefficient": { "coefficient": 1.5, "category": "must-be", "confidence": 0.85 }
        },
        "base_score": 3.65,
        "kano_bonus": 1.825,
        "total_score": 5.475,
        "score_confidence": "medium"
      }
    ],
    "scoring_summary": { "total_requirements": 2, "high_priority": 0, "medium_priority": 1, "low_priority": 1, "needs_tech_confirmation": 1 },
    "priority_thresholds": { "high": "total score >= 4.5", "medium": "total score 2.0-4.4", "low": "total score < 2.0" }
  },
  "metadata": {
    "version": "3.0",
    "generated_at": "2026-05-14T21:00:00Z",
    "source_files": [
      "docs/discovery/user-research.md (append \"User Voice Analysis\" section)
      // ... same structure can be extended
    ]
  }
}
```
