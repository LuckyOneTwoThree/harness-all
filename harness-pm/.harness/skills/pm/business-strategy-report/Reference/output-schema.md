# business-strategy-report — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Executive Summary
- One-sentence strategic posture judgment
- Recommended strategic direction
- Core OKRs
- Key risks

## 1. Strategic Posture Assessment
### 1.1 External Environment
### 1.2 Internal Capabilities
### 1.3 Strategic Posture Matrix

## 2. Strategic Direction Reasoning
### 2.1 Direction A: {Name}
### 2.2 Direction B: {Name}
### 2.3 Direction Comparison and Recommendation

## 3. Execution Path
### 3.1 OKR System
### 3.2 Roadmap
### 3.3 Pricing Strategy

## 4. Stakeholder Management
### 4.1 Stakeholder Map
### 4.2 Communication Strategy

## 5. Risks and Contingencies

## Appendix
- Data Sources
- Assumption List
- Methodology Notes
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Strategic recommendations and priorities | Core conclusions + minimum viable deliverable |
| standard | Complete deliverable (current default) | Complete deliverable, including all Step outputs |
| deep | Complete report + strategic reasoning + competitive landscape analysis + execution roadmap | Complete deliverable + extended analysis + in-depth reasoning |

## Output

**Storage Path**: `docs/strategy/business-strategy.md (consolidated overwrite)`

**Output Files**:

| File | Format | Description |
|------|------|------|
| business-strategy-report.md | Markdown | Complete business strategy planning report |
| business-strategy-report.json | JSON | Structured data (for downstream Skill reference) |

### Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| report_metadata.product | string | Yes | Product name |
| report_metadata.generated_at | string | Yes | Generation timestamp |
| report_metadata.data_sources | array | Yes | Data source list |
| report_metadata.overall_confidence | number | Yes | Overall confidence 0-1 |
| executive_summary.strategic_posture | string | Yes | Offensive/Defensive/Turnaround/Survival |
| executive_summary.recommended_direction | string | Yes | Recommended strategic direction |
| executive_summary.core_okr | object | Yes | Core OKR |
| executive_summary.key_risks | array | Yes | Key risk list |
| strategic_assessment.external | object | Yes | External environment assessment |
| strategic_assessment.external.industry_attractiveness | string | Yes | Industry attractiveness assessment, cannot be empty |
| strategic_assessment.external.opportunities | array | Yes | External opportunities list, cannot be empty |
| strategic_assessment.external.threats | array | Yes | External threats list, cannot be empty |
| strategic_assessment.external.competitive_position | string | Yes | Competitive positioning description |
| strategic_assessment.internal | object | Yes | Internal capability assessment |
| strategic_assessment.internal.strengths | array | Yes | Core strengths list, cannot be empty |
| strategic_assessment.internal.weaknesses | array | Yes | Key weaknesses list, cannot be empty |
| strategic_assessment.internal.key_resources | array | No | Key resources list |
| strategic_assessment.internal.capability_gaps | array | No | Capability gaps list |
| strategic_assessment.posture_matrix.quadrant | string | Yes | Posture quadrant |
| strategic_directions | array | Yes | At least 2 strategic directions |
| strategic_directions[].name | string | Yes | Direction name, cannot be empty |
| strategic_directions[].rationale | string | Yes | Direction rationale, cannot be empty |
| strategic_directions[].target_market | string | No | Target market |
| strategic_directions[].differentiation | string | No | Differentiation strategy |
| strategic_directions[].key_assumptions | array | No | Key assumptions list |
| strategic_directions[].risk_factors | array | No | Risk factors list |
| execution_path.okr | object | Yes | OKR system |
| execution_path.roadmap | object | Yes | Roadmap |
| stakeholder_management | array | No | Stakeholder management strategies |
| stakeholder_management[].stakeholder | string | Yes | Stakeholder name |
| stakeholder_management[].attitude | string | No | Attitude |
| stakeholder_management[].influence | string | No | Influence level |
| stakeholder_management[].communication_strategy | string | No | Communication strategy |
| risks_and_contingencies | array | Yes | Risks and contingencies |
| risks_and_contingencies[].risk_category | string | Yes | Risk category |
| risks_and_contingencies[].probability | string | No | Probability assessment |
| risks_and_contingencies[].impact | string | No | Impact assessment |
| risks_and_contingencies[].contingency | string | No | Contingency plan |

**business-strategy-report.json Structure**:

```json
{
  "report_metadata": {
    "product": "Product Name",
    "generated_at": "Timestamp",
    "data_sources": [],
    "overall_confidence": 0.0
  },
  "executive_summary": {
    "strategic_posture": "Offensive/Defensive/Turnaround/Survival",
    "recommended_direction": "",
    "core_okr": {},
    "key_risks": []
  },
  "strategic_assessment": {
    "external": {
      "industry_attractiveness": "",
      "opportunities": [],
      "threats": [],
      "competitive_position": ""
    },
    "internal": {
      "strengths": [],
      "weaknesses": [],
      "key_resources": [],
      "capability_gaps": []
    },
    "posture_matrix": {
      "quadrant": "",
      "implication": ""
    }
  },
  "strategic_directions": [
    {
      "name": "Direction Name",
      "strategic_position": "",
      "rationale": "",
      "target_market": "",
      "differentiation": "",
      "key_assumptions": [],
      "risk_factors": [],
      "comparison_scores": {}
    }
  ],
  "execution_path": {
    "okr": {},
    "roadmap": {},
    "pricing_alignment": ""
  },
  "stakeholder_management": [],
  "risks_and_contingencies": []
}
```
