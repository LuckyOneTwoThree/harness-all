---
name: stakeholder-analysis
description: Used when stakeholder analysis, stakeholder alignment, or communication strategy design is needed. Integrates stakeholder map, communication strategy, and strategic briefs. Keywords: stakeholder, Stakeholder, stakeholder map, communication strategy.
metadata:
  module: "Product Business & Strategy"
  sub-module: "Stakeholder Management"
  type: "pipeline"
  version: "3.0"
  domain_tags: ["General"]
  triggers:
    - "Help me map out the stakeholders"
    - "Who will influence this project"
    - "Help me develop a stakeholder management strategy"
    - "How to communicate with each party"
    - "Help me write a strategic brief for my boss"
    - "One-page strategy report"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output stakeholder map and influence assessment"
  deep_description: "Complete analysis + influence dynamic simulation + communication strategy design + interest balancing plan"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/strategy/business-strategy.md
writes:
  - docs/strategy/stakeholder-analysis.md
  - memory/progress.md
---

# Stakeholder Analysis

## Core Principles

1. **Full coverage of four categories** — Product decision makers / resource controllers / affected parties / external stakeholders, all four categories are indispensable
2. **Dual-dimension quantification** — Influence and interest scored 1-5, four-quadrant classification is evidence-based
3. **No key decision makers missed** — If key decision makers are not in the map, subsequent flow is blocked
4. **Specific communication strategy** — Each stakeholder's communication strategy must include concerns and suggested topics
5. **Six-section closed loop** — Background → Opportunity → Choice → Success → Risk → Resource forms a complete logical loop
6. **Data source annotation** — Each section annotates data sources, no inference without evidence
7. **Quality score gating** — Document quality <60 auto-revises; if still below standard after revision, human review
8. **Cross-department mandatory approval** — When ≥3 departments' resources are involved, mandatory human approval
9. **One-page principle** — Decision makers have no time for long texts; core arguments must fit on one page
10. **Audience adaptation** — Executives focus on strategic ROI, teams focus on execution collaboration, externals focus on value trust
11. **No key information missing** — Strategic goals / core risks / action items are all indispensable; missing any returns for revision
12. **Sensitive data desensitization** — External briefs auto-desensitized; when action items >3, recommend focusing

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Business Model Canvas | JSON | Yes | docs/strategy/business-strategy.md ("Business Model Canvas" section) | Key partners, customer relationships |
| Product/Business Information | string | Yes | User-provided | Product name, organizational structure, business model |
| Business Strategy Report | JSON | Optional | docs/strategy/business-strategy.md (summary coverage) | Strategic direction, OKRs, roadmap |
| Audience Type | string | Yes | User-provided | executive/team/external |

## Execution Steps

### Step 1: Stakeholder Map [Core]

#### Stakeholder Identification

Identify stakeholders from 4 dimensions:

**1. Product Decision Makers**
- Product Owner
- Business Owner
- Tech Lead
- Executive Leadership

**2. Resource Controllers**
- Budget Approver
- Human Resources
- Technical Resources
- Data Resources

**3. Affected Parties**
- Internal Teams
- Existing Users
- Partners
- Operations Team

**4. External Stakeholders**
- Regulatory Bodies
- Industry Associations
- Media
- Investors

#### Influence-Interest Assessment

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

#### Four-Quadrant Classification

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

#### Communication Strategy Formulation

Develop a communication strategy for each stakeholder:

| Element | Content |
|------|------|
| Frequency | Daily/Weekly/Monthly/As needed |
| Method | Meeting/Email/Brief/1-on-1 |
| Concerns | What this stakeholder cares about most |
| Suggested Topics | What to discuss during communication |
| Risk | Consequences of not communicating |

### Step 2: Communication Strategy [Core]

#### Document Structure Planning

Determine the 6 core sections of the document:

1. **Background & Current State**: Why stakeholder management is needed
2. **Opportunities & Challenges**: Opportunities and challenges brought by stakeholders
3. **Strategy Selection**: Strategies for different stakeholders
4. **Success Criteria**: How to measure strategy success
5. **Risks & Contingencies**: Risks in stakeholder management
6. **Resources & Actions**: Required resources and action plan

#### Background & Current State

Integrate stakeholder map and strategy report:

**Key Content**:
- Product strategic context
- Stakeholder panorama
- Key stakeholder identification
- Current relationship status

#### Opportunities & Challenges

Analyze opportunities and challenges brought by stakeholders:

**Opportunity Analysis**:
- Which stakeholders can become strategic allies
- How to leverage high-influence supporters
- Partnership opportunity identification

**Challenge Analysis**:
- Which stakeholders may become obstacles
- Interest conflict identification
- Potential risk points

#### Strategy Selection

Develop a strategy for each key stakeholder:

| Stakeholder | Current Attitude | Target Attitude | Strategy | Key Actions |
|-----------|---------|---------|------|---------|
| Product VP | Support | Strong Support | Deep Involvement | Weekly strategy alignment meeting |
| Tech Director | Neutral | Support | Interest Alignment | Joint technical solution review |
| Finance Director | Wait-and-see | Support | Data Persuasion | ROI dedicated report |

#### Success Criteria

Define metrics for strategy success:

| Metric | Current Value | Target Value | Measurement Method |
|------|--------|--------|---------|
| Key Decision Maker Support Rate | 60% | 90% | Decision pass rate |
| Resource Acquisition Efficiency | Medium | High | Resource request cycle |
| Stakeholder Satisfaction | 3.5 | 4.5 | Quarterly survey |

#### Risks & Contingencies

Identify risks in stakeholder management:

| Risk | Probability | Impact | Contingency |
|------|------|------|------|
| Key decision maker change | Medium | High | Build relationships with multiple decision makers |
| Interest conflict escalation | Low | High | Early identification + mediation mechanism |
| Poor communication | Medium | Medium | Regular communication + feedback mechanism |

#### Document Assembly

**Document Structure**:

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

### Step 3: Strategic Brief [Core]

#### Audience Analysis

Determine brief strategy based on audience type:

| Audience | Focus | Depth | Expression |
|------|--------|------|----------|
| Executive | Strategic ROI, risks, decisions | High-level overview | Data-driven, conclusion-first |
| Team | Goals, collaboration, execution | Medium detail | Clear action items, timeline |
| External | Value, trust, partnership | Curated information | Value-oriented, desensitized |

#### Core Information Extraction

Extract core information from the strategy report:

**Required Information (all indispensable)**:
1. Strategic goals (1-3)
2. Core risks (Top 3)
3. Action items (3-5)

**Optional Information**:
- Market data
- Competitive landscape
- Resource requirements
- Timeline

#### Brief Generation

Generate briefs by audience type:

**Executive Brief Template**:
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

**Team Brief Template**:
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

**External Brief Template**:
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

#### Desensitization Processing

Desensitize external briefs:
- Remove internal OKR data
- Remove specific financial figures
- Remove competitor comparison details
- Retain value propositions and partnership directions

### Output Depth Classification

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Stakeholder map and influence assessment | Core conclusions + minimum viable artifact |
| standard | Complete artifact (current default) | Complete artifact, including all Step outputs |
| deep | Complete analysis + influence dynamic simulation + communication strategy design + interest balancing plan | Complete artifact + extended analysis + deep simulation |

## Output

**Storage Path**: `docs/strategy/stakeholder-analysis.md`

**Output Files**:

| File | Format | Description |
|------|------|------|
| stakeholder-analysis.json | JSON | Structured data (including map + strategy + brief) |
| stakeholder-analysis.md | Markdown | Complete stakeholder analysis report |

**stakeholder-analysis.json Output Schema**:

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

### Output Validation Rules

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

## Decision Rules

| Condition | Decision |
|------|------|
| Key decision maker check | At least 1 decision maker identified |
| Score calibration | Influence score requires human calibration |
| Communication strategy | Requires human approval |
| Document quality score ≥60 | Pass, can output |
| Document quality score <60 | Auto-revise and re-score |
| Still <60 after revision | Escalate to human review |
| Involves ≥3 departments' resources | Mandatory human approval |
| Key stakeholders not covered | Return for supplementation |
| Strategic goals missing | Return for supplementation, cannot generate brief |
| Core risks missing | Return for supplementation, cannot generate brief |
| Action items missing | Return for supplementation, cannot generate brief |
| Action items >3 | Mark "Recommend focusing on Top 3" |
| External brief contains sensitive data | Auto-desensitize |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] All 4 stakeholder categories identified
- [ ] Each stakeholder has dual-dimension scores

### P1 Checks (must pass for standard/deep)

- [ ] Four-quadrant classification completed
- [ ] Communication strategy is specific and executable
- [ ] Key decision makers identified
- [ ] 6 sections complete
- [ ] Each section has data source annotation
- [ ] Stakeholder coverage complete
- [ ] Strategy is specific and executable
- [ ] Success criteria are measurable
- [ ] Risks have contingencies
- [ ] Document quality score ≥60
- [ ] Can be read on one page
- [ ] Three elements complete (goals/risks/actions)
- [ ] Audience adaptation correct
- [ ] External brief desensitized
- [ ] Action items have owners and due dates

### P2 Checks (must pass for deep only)

- [ ] Extended analysis complete (deep simulation and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files are missing, this skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| bmc.json | User provides organizational structure and business info → identify stakeholders | Lacks BMC data, key partners and customer relationships may be missed | Request user to provide key business model elements or upload bmc.json file |
| Product/Business Information (user-provided) | If user does not provide product/business info, prompt user to provide or skip steps related to this input | Stakeholder identification lacks business context | Request user to provide product name, core features, and business model description |
| bmc.json + Product/Business Information | User provides organizational structure and business info → identify stakeholders | Overall confidence reduced, stakeholder list may be incomplete | Request user to provide organizational structure, business model, and key partner info |
| All upstream files missing | Prompt user to execute prior phases first, or identify stakeholders based on user-provided organizational structure info | Overall confidence significantly reduced, map is only a general reference | Request user to provide organizational structure, product features, and business goals |
| business-strategy-report.json | User provides strategic key points → generate strategy document and brief | Lacks structured strategy data, strategy-strategy alignment may be insufficient | Request user to provide strategic direction and key strategy points or upload business-strategy-report.json file |
| stakeholder-analysis.json (brief section) | If strategic brief is missing, does not affect core document generation | Brief content needs to be re-extracted from strategy report | Request user to provide stakeholder analysis summary or upload stakeholder-analysis.json file |

## Data Acquisition Notes

This skill requires business model canvas and product/business information. Please provide via one of the following methods:
  1. Directly provide organizational structure, product name, and business model
  2. Upload bmc.json file
  3. Provide data file path
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| bmc.json key partner change | External stakeholder identification | Re-execute Step 1, update external stakeholders |
| bmc.json customer relationship change | Affected party identification | Re-execute Step 1, update affected parties |
| Organizational structure change | Decision makers and resource controllers | Re-execute Step 1, update decision makers and resource controllers |
| business-strategy-report strategy adjustment | Background & current state, opportunities & challenges | Re-execute Step 2, update strategic context and opportunity/challenge analysis |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Stakeholder list change | business-strategy-report | Output file version number + change summary |
| Strategy adjustment | business-strategy-report | Output file version number + change summary |
| Risk contingency update | business-strategy-report | Output file version number + change summary |
| Brief content change | No specific downstream | Output file version number + change summary |
