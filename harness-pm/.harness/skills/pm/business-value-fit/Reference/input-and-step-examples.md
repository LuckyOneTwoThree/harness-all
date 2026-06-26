# Input and Step Output Examples

> Extracted from SKILL.md. Input JSON examples and step output JSON examples for value proposition fit assessment.

## Required Inputs - Value Propositions in BMC (from Pipeline 1)

```json
{
  "value_propositions": [
    {
      "proposition_id": "vp-1",
      "headline": "Value Proposition Headline",
      "description": "Value Proposition Detailed Description",
      "target_segment": "segment-1",
      "pain_relievers": ["Pain relieved 1", "Pain relieved 2"],
      "gain_creators": ["Gain created 1", "Gain created 2"]
    }
  ]
}
```

## Required Inputs - Discovery-phase User Research Data

```json
{
  "persona_summary": {
    "demographics": "Demographic characteristics",
    "behaviors": "User behavioral characteristics",
    "goals": "User goals"
  },
  "problem_statement": {
    "pains": [
      {
        "pain_id": "pain-1",
        "description": "Pain description",
        "frequency": "Occurrence frequency",
        "severity": "Severity level",
        "urgency": "Urgency level"
      }
    ],
    "gains": [
      {
        "gain_id": "gain-1",
        "description": "Expected gain description",
        "importance": "Importance",
        "current_satisfaction": "Current satisfaction"
      }
    ]
  },
  "opportunity_definition": {
    "opportunity_description": "Enterprise training digitalization penetration rate is only 28%, AI personalized learning demand growing 45% annually",
    "evidence": ["iResearch 2024 Enterprise Training Market Report", "State Council Vocational Education Reform Implementation Plan"]
  }
}
```

## Step 1: Pain Alignment Assessment - Output Format

```json
{
  "pain_alignment": {
    "covered_pains": [
      {
        "pain_id": "pain-1",
        "pain_description": "Training effectiveness is hard to quantify and track",
        "matched_by": ["vp-1"],
        "coverage_score": 5,
        "coverage_quality": "full/partial/edge/none",
        "notes": "AI learning report feature fully covers this pain"
      }
    ],
    "uncovered_pains": [
      {
        "pain_id": "pain-5",
        "pain_description": "Learner learning paths lack personalization",
        "frequency": "high",
        "severity": "high",
        "impact": "High-frequency, high-severity pain 'course content disconnected from job requirements' not covered",
        "recommendation": "Recommend adding job skill graph matching feature"
      }
    ],
    "pain_coverage_summary": {
      "total_pains": 10,
      "fully_covered": 4,
      "partially_covered": 3,
      "uncovered": 3,
      "weighted_average_score": 3.2,
      "high_frequency_coverage_rate": "80%"
    }
  }
}
```

## Step 2: Gain Creation Validation - Output Format

```json
{
  "gain_validation": {
    "covered_gains": [
      {
        "gain_id": "gain-1",
        "gain_description": "Training ROI can be quantified",
        "created_by": ["vp-1"],
        "coverage_status": "covered/partial/not_covered",
        "realizability": "high/medium/low",
        "notes": "AI learning report + ROI dashboard can achieve this, technology maturity is high"
      }
    ],
    "uncovered_gains": [
      {
        "gain_id": "gain-3",
        "gain_description": "Learner autonomous learning willingness improved",
        "importance": "high",
        "gap_analysis": "Users expect a socialized learning experience but current value proposition does not address it",
        "recommendation": "Recommend including learning community features in V2.0 planning"
      }
    ],
    "gain_summary": {
      "total_gains": 8,
      "covered": 5,
      "partial": 2,
      "uncovered": 1,
      "alignment_rate": "75%"
    }
  }
}
```

## Step 3: Overall Fit Assessment - Output Format

```json
{
  "overall_fit_score": 3.4,
  "score_interpretation": "Good fit",
  "score_breakdown": {
    "pain_alignment_score": 3.5,
    "pain_weight": 0.6,
    "pain_contribution": 2.1,
    "gain_validation_score": 3.25,
    "gain_weight": 0.4,
    "gain_contribution": 1.3
  },
  "coverage_rate": {
    "pain_coverage": "80%",
    "gain_coverage": "75%",
    "high_priority_coverage": "85%"
  }
}
```
