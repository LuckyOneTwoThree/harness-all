---
name: stakeholder-analysis
description: Used when stakeholder analysis, stakeholder alignment, or communication strategy design is needed. Integrates stakeholder map, communication strategy, and strategic briefs.
---
# Stakeholder Analysis

## When to use
- Help me map out the stakeholders
- Who will influence this project
- Help me develop a stakeholder management strategy
- How to communicate with each party
- Help me write a strategic brief for my boss
- One-page strategy report
- Keywords: stakeholder, Stakeholder, stakeholder map, communication strategy

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/strategy/business-strategy.md

## Outputs
- docs/strategy/stakeholder-analysis.md
- memory/progress.md

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

## Inputs

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

Assess each stakeholder on two dimensions (Influence 1-5, Interest 1-5).

> See [Reference/templates-and-schemas.md](./Reference/templates-and-schemas.md#influence-interest-assessment) for the Influence and Interest scoring rubrics (1-5 scale definitions).

#### Four-Quadrant Classification

Classify based on the influence-interest matrix (Manage Closely / Keep Satisfied / Keep Informed / Minimal Effort).

> See [Reference/templates-and-schemas.md](./Reference/templates-and-schemas.md#four-quadrant-classification) for the four-quadrant classification matrix diagram.

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

> See [Reference/templates-and-schemas.md](./Reference/templates-and-schemas.md#document-structure-template) for the complete document structure template (6 sections + appendix).

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

Generate briefs by audience type.

> See [Reference/templates-and-schemas.md](./Reference/templates-and-schemas.md#brief-templates) for the Executive Brief, Team Brief, and External Brief templates.

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

**stakeholder-analysis.json Output Schema**: See [Reference/templates-and-schemas.md](./Reference/templates-and-schemas.md#stakeholder-analysisjson-output-schema) for the JSON output schema.

### Output Validation Rules

> See [Reference/templates-and-schemas.md](./Reference/templates-and-schemas.md#output-validation-rules) for the field-level output validation rules table (stakeholder_map / strategy_doc / brief field paths).

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

> See [Reference/quality-checks.md](./Reference/quality-checks.md) for the detailed P0 / P1 / P2 quality check items.

---

## Degradation Strategy

> See [Reference/decision-tables.md](./Reference/decision-tables.md#degradation-strategy) for the upstream file missing degradation plan and data acquisition notes.

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md#upstream-change-response) for the upstream change impact table and downstream notification mechanism table.
