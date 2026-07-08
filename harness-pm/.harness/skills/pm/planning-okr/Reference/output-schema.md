# planning-okr — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

**Storage path**: `docs/strategy/OKR.md`

**Output file**: okr.json

### Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| okr_candidates | array | Yes | At least 2 Objective candidates |
| okr_candidates[].objective | string | Yes | Objective description |
| okr_candidates[].key_results | array | Yes | At least 3 KRs per O |
| okr_candidates[].key_results[].kr | string | Yes | KR description |
| okr_candidates[].key_results[].baseline | string | Yes | Current baseline value |
| okr_candidates[].key_results[].target | string | Yes | Target value |
| okr_candidates[].key_results[].growth_needed | string | Yes | Required growth rate |
| okr_candidates[].key_results[].achievability | number | Yes | Probability of achievement 0-1 |
| okr_candidates[].key_results[].confidence_level | number | Yes | Confidence 0-1 |
| okr_candidates[].key_results[].deadline | string | Yes | KR deadline (ISO8601 format) |
| okr_candidates[].key_results[].drives_features | array | Yes | List of features driven by this KR |
| okr_candidates[].key_results[].drives_features[].feature_priority | string | Yes | Feature priority (P0/P1/P2) |
| okr_candidates[].key_results[].drives_features[].feature_description | string | Yes | Feature description (placeholder) |
| okr_candidates[].alignment_check.strategic_alignment | boolean | Yes | Strategic alignment check |
| okr_candidates[].alignment_check.kr_coherence | boolean | Yes | KR consistency check |
| okr_candidates[].alignment_check.timeline_feasibility | boolean | Yes | Timeline feasibility |

```yaml
okr_candidates:
  - objective: "O1: Increase user engagement"
    key_results:
      - kr: "KR1: DAU reaches 1 million"
        baseline: 600k
        target: 1 million
        growth_needed: 67%
        achievability: 0.65
        dimension: "Quantity"
        confidence_level: 0.85
        deadline: "2026-06-30"
        north_star_alignment: true
        drives_features:
          - feature_priority: "P0"
            feature_description: "Personalized recommendation homepage"
            expected_lift: "15% DAU lift"
          - feature_priority: "P0"
            feature_description: "Daily check-in system"
            expected_lift: "8% DAU lift"
      - kr: "KR2: D1 retention rate reaches 45%"
        baseline: 35%
        target: 45%
        growth_needed: 29%
        achievability: 0.70
        dimension: "Quality"
        confidence_level: 0.80
        deadline: "2026-06-30"
        drives_features:
          - feature_priority: "P0"
            feature_description: "Onboarding optimization"
            expected_lift: "10% D1 retention lift"
          - feature_priority: "P1"
            feature_description: "First-time experience optimization"
            expected_lift: "5% D1 retention lift"
      - kr: "KR3: Core feature usage rate reaches 60%"
        baseline: 40%
        target: 60%
        growth_needed: 50%
        achievability: 0.55
        dimension: "Quality"
        confidence_level: 0.75
        deadline: "2026-06-30"
        drives_features:
          - feature_priority: "P1"
            feature_description: "Feature discovery guidance"
            expected_lift: "8% usage rate lift"
    alignment_check:
      strategic_alignment: true
      kr_coherence: true
      timeline_feasibility: true
      notes: "Alignment check notes"
  - objective: "O2: Optimize unit economics"
    key_results:
      - kr: "KR1: Reduce CAC by 20%"
        baseline: 150 yuan
        target: 120 yuan
        growth_needed: -20%
        achievability: 0.60
        dimension: "Cost"
        confidence_level: 0.75
        deadline: "2026-06-30"
        drives_features:
          - feature_priority: "P1"
            feature_description: "Precise ad targeting optimization"
            expected_lift: "12% CAC reduction"
    alignment_check:
      strategic_alignment: true
      kr_coherence: true
      timeline_feasibility: true
      notes: "Alignment check notes"
```
