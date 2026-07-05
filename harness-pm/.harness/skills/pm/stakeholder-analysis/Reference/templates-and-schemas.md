# Stakeholder Analysis - Templates & Schemas

This file collects JSON schemas, output validation rules, document structure templates, and brief templates referenced by `SKILL.md` for the `stakeholder-analysis` skill.

## Influence-Interest Assessment

Assess each stakeholder on two dimensions:

**Influence Score (1-5)**:
```
5: Has final decision authority
4: Has significant influence
3: Has moderate influence
2: Has minor influence
1: Almost no influence
```

**Interest Score (1-5)**:
```
5: Extremely concerned, actively involved
4: Highly concerned, follows up regularly
3: Moderately concerned, occasionally checks in
2: Low concern, passively informed
1: Almost no concern
```

## Four-Quadrant Classification

Classify based on the influence-interest matrix:

```
          │ High Interest    │ Low Interest
──────────┼─────────────────┼──────────────
High Influence │ Manage Closely   │ Keep Satisfied
          │ (Key Player)    │ (Keep Satisfied)
──────────┼─────────────────┼──────────────
Low Influence  │ Keep Informed    │ Minimal Effort
          │ (Keep Informed) │ (Minimal Effort)
```

## Document Structure Template

```
# {Product Name} Stakeholder Strategy Document

## 1. Background & Current State
### 1.1 Strategic Context
### 1.2 Stakeholder Panorama
### 1.3 Key Stakeholders

## 2. Opportunities & Challenges
### 2.1 Strategic Ally Identification
### 2.2 Potential Obstacle Analysis
### 2.3 Interest Conflict Map

## 3. Strategy Selection
### 3.1 Manage Closely Strategy
### 3.2 Keep Satisfied Strategy
### 3.3 Keep Informed Strategy
### 3.4 Minimal Effort Strategy

## 4. Success Criteria
### 4.1 Key Metrics
### 4.2 Measurement Methods
### 4.3 Evaluation Cycle

## 5. Risks & Contingencies
### 5.1 Risk Matrix
### 5.2 Mitigation Measures
### 5.3 Contingency Plans

## 6. Resources & Actions
### 6.1 Resource Requirements
### 6.2 Action Plan
### 6.3 Timeline

## Appendix
- Detailed stakeholder profiles
- Communication record template
- Data sources
```

## Brief Templates

### Executive Brief Template

```
# {Product Name} Strategic Brief

## Strategic Direction
- [Direction 1]: [One-sentence description + expected ROI]
- [Direction 2]: [One-sentence description + expected ROI]

## Key Metrics
- North Star Metric: [Metric Name]=[Current Value]→[Target Value]
- Core OKRs: [O1] / [O2]

## Core Risks
1. [Risk 1]: [Probability]×[Impact]=[Risk Level]
2. [Risk 2]: [Probability]×[Impact]=[Risk Level]
3. [Risk 3]: [Probability]×[Impact]=[Risk Level]

## Decision Requests
- [ ] [Decision Item 1]
- [ ] [Decision Item 2]

## Next Actions
1. [Action 1] - Owner - Due Date
2. [Action 2] - Owner - Due Date
```

### Team Brief Template

```
# {Product Name} Strategic Alignment Brief

## Our Direction
- Strategic Goals: [O1] / [O2]
- This Quarter's Focus: [Focus 1] / [Focus 2]

## Our Goals
- KR1: [Target Value] (Current: [Baseline Value])
- KR2: [Target Value] (Current: [Baseline Value])

## Collaboration Points
- [Team A] responsible for [Item]
- [Team B] responsible for [Item]
- Dependencies: [Description]

## Milestones
- [Date]: [Milestone 1]
- [Date]: [Milestone 2]
```

### External Brief Template

```
# {Product Name} Partnership Brief

## Product Value
- [Value Proposition 1]
- [Value Proposition 2]

## Partnership Opportunities
- [Partnership Direction 1]
- [Partnership Direction 2]

## Contact
- [Contact Person]
```

## stakeholder-analysis.json Output Schema

```json
{
  "type": "object",
  "required": ["stakeholder_map", "strategy_doc", "brief"],
  "properties": {
    "stakeholder_map": {"type": "object", "description": "Stakeholder map, including four-quadrant classification and communication strategy"},
    "strategy_doc": {"type": "object", "description": "Stakeholder strategy document, including six-section closed loop"},
    "brief": {"type": "object", "description": "Strategic brief, including audience-adapted content"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| stakeholder_map.stakeholders | array | Yes | Stakeholder list |
| stakeholder_map.stakeholders[].name | string | Yes | Name/Role |
| stakeholder_map.stakeholders[].category | string | Yes | decision_maker/resource_controller/affected/external |
| stakeholder_map.stakeholders[].influence | number | Yes | Influence 1-5 |
| stakeholder_map.stakeholders[].interest | number | Yes | Interest 1-5 |
| stakeholder_map.stakeholders[].quadrant | string | Yes | key_player/keep_satisfied/keep_informed/minimal_effort |
| stakeholder_map.stakeholders[].communication_strategy | object | Yes | Communication strategy |
| stakeholder_map.stakeholders[].communication_strategy.frequency | string | Yes | Communication frequency |
| stakeholder_map.stakeholders[].communication_strategy.method | string | Yes | Communication method |
| stakeholder_map.stakeholders[].communication_strategy.concerns | array | Yes | Concerns list |
| stakeholder_map.stakeholders[].communication_strategy.suggested_topics | array | Yes | Suggested topics list |
| stakeholder_map.stakeholders[].communication_strategy.risk | string | Yes | Risk of not communicating |
| stakeholder_map.quadrant_summary | object | Yes | Four-quadrant summary |
| stakeholder_map.key_decision_makers_identified | boolean | Yes | Whether key decision makers are identified |
| strategy_doc.doc_metadata.product_name | string | Yes | Product name |
| strategy_doc.doc_metadata.generated_at | string | Yes | Generation timestamp |
| strategy_doc.doc_metadata.data_sources | array | Yes | Data sources list |
| strategy_doc.doc_metadata.quality_score | number | Yes | Document quality score 0-100 |
| strategy_doc.background.strategic_context | string | Yes | Strategic context |
| strategy_doc.background.stakeholder_overview | array | Yes | Stakeholder panorama |
| strategy_doc.background.key_stakeholders | array | Yes | Key stakeholders |
| strategy_doc.opportunities_and_challenges.opportunities | array | Yes | Opportunities list |
| strategy_doc.opportunities_and_challenges.challenges | array | Yes | Challenges list |
| strategy_doc.strategies | array | Yes | Strategy list, each item includes stakeholder/current_attitude/target_attitude/strategy/key_actions |
| strategy_doc.success_criteria | array | Yes | Success criteria list |
| strategy_doc.risks_and_contingencies | array | Yes | Risks and contingencies list |
| strategy_doc.resources_and_actions | object | Yes | Resources and action plan |
| brief.brief_metadata.audience_type | string | Yes | executive/team/external |
| brief.brief_metadata.generated_at | string | Yes | Generation timestamp |
| brief.brief_content.strategic_goals | array | Yes | 1-3 strategic goals |
| brief.brief_content.key_risks | array | Yes | Top 3 risks |
| brief.brief_content.action_items | array | Yes | 3-5 action items |
| brief.brief_content.decision_requests | array | Optional | Decision requests (required for executive brief) |
| brief.brief_content.milestones | array | Optional | Milestones (required for team brief) |
| brief.brief_content.value_propositions | array | Optional | Value propositions (required for external brief) |
| brief.brief_content.desensitized | boolean | Yes | Whether desensitized (must be true for external brief) |
