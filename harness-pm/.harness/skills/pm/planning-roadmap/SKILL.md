---
name: planning-roadmap
description: Use when you need to create a product roadmap, quarterly plan, release plan, or allocate resources. Roadmap auto-planning. Based on OKRs and strategic direction, plan Epic-level product roadmaps, perform Now/Next/Later tiering and RICE scoring for prioritization.
---
# Roadmap Auto-Planning

## When to use
- Help me plan the product roadmap
- What should the next release include
- Keywords: product roadmap, release planning, RICE scoring, quarterly planning, Epic planning, what features to build, schedule planning

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/strategy/roadmap.md
- roadmap.json

## Core Principles

1. **Strategic theme driven** — Epics must be decomposed from OKRs and SWOT strategic themes, not planned in a vacuum
2. **RICE quantitative prioritization** — All Epics use the RICE formula for quantitative scoring, prioritization is evidence-based
3. **Now/Next/Later tiering** — Plan in three tiers by priority and time dimension, avoid flat listing
4. **Explicit dependencies and risks** — Each Epic annotates dependencies and risks, including mitigation measures

## Interaction Mode
🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| OKR objectives and Key Results | JSON | Yes | docs/strategy/OKR.md | Objectives and Key Results |
| SWOT strategic direction | JSON | Yes | docs/strategy/PRODUCT_STRATEGY.md ("Strategic Analysis" section) | SO/ST/WO/WT strategic directions |
| Requirement priority score | JSON | ○ | Overridden by design-prd | RICE scoring results |
| Resource constraints | JSON | ○ | Provided by user | Team capacity, budget, time constraints |

## Execution Steps

### Step 1: Strategic Theme Extraction [Core]

Extract 3-5 strategic themes from OKRs and SWOT:

```
Theme = Strategic direction + Business objective + Value proposition
```

Each strategic theme includes:
- Theme name
- Supported OKRs
- Strategic significance

### Step 2: Epic-Level Planning [Core]

Decompose strategic themes into quarterly Epics:

```yaml
epic:
  name: "Epic name"
  quarter: "Q1 2024"
  description: "Epic description"
  success_metric: "Success metric"
  rice_score: 75
  effort: "Person-months"
  dependencies:
    - "Dependency 1"
    - "Dependency 2"
  risks:
    - risk: "Risk description"
      likelihood: "high/medium/low"
      mitigation: "Mitigation measure"
  key_assumptions:
    - "Key assumption 1"
    - "Key assumption 2"
```

### Step 3: Now/Next/Later Tiering [Core]

Tier based on RICE score and time dimension:

**Now (current quarter)**
- Confirmed high-priority Epics
- Must-complete dependencies
- High-confidence items

**Next (next quarter)**
- Planned but adjustable Epics
- Depend on Now phase results
- Medium-priority items

**Later (long-term)**
- Directional planning
- Assumptions requiring further validation
- Low-priority or exploratory items

### Step 4: RICE Score Calculation [Core]

RICE formula:
```
RICE Score = (Reach × Impact × Confidence) ÷ Effort
```

Scoring criteria:
- **Reach**: Number of users/customers affected
- **Impact**: Degree of positive impact on the objective (0.25-3)
- **Confidence**: Confidence in data and assumptions (0.5-1)
- **Effort**: Person-months required to complete

### Step 5: Risk Annotation [Core]

Identify and annotate risks:
- Technical risks
- Resource risks
- Dependency risks
- Market risks

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Roadmap and milestones | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Complete artifact, including all Step outputs |
| deep | Full roadmap + dependency analysis + risk buffer design + multi-scenario roadmap | Full artifact + extended analysis + deep reasoning |

## Output

**Storage path**: `docs/strategy/roadmap.md`

**Output file**: roadmap.json

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

## Decision Rules

1. **RICE calculation**: AI completes the calculation automatically
2. **Priority decision**: Human decides the final priority
3. **Resource allocation**: Human decides quarterly resource allocation
4. **Tiering adjustment**: Human can adjust Now/Next/Later tiering

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Epic has a clear success metric
- [ ] All Epics have dependency annotations

### P1 Checks (must pass for standard/deep)

- [ ] Now/Next/Later tiering completed
- [ ] RICE score calculated
- [ ] Risks identified with mitigation measures
- [ ] Resource estimation is reasonable

### P2 Checks (only required for deep)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision record complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files are missing, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| okr.json | User provides objective list → directly plan roadmap | Lacking OKR structured data, strategic themes' alignment with OKR is insufficient | Ask user to provide business objectives and Key Results or upload okr.json file |
| strategic-analysis.json | User provides objective list → directly plan roadmap | Lacking strategic analysis data, strategic themes may deviate from strategic direction | Ask user to provide strategic direction and priority description or upload strategic-analysis.json file |
| Requirement priority data (insight-analysis / design-prd) | User provides objective list → directly plan roadmap | Lacking requirement priority data, RICE scoring lacks input basis | Ask user to provide feature requirement list and priority ranking or upload insight-analysis.json file |
| okr.json + strategic-analysis.json + requirement priority | User provides objective list → directly plan roadmap | Overall confidence reduced, Epic prioritization lacks data anchoring | Ask user to provide business objectives, strategic direction, and feature priorities |
| All upstream files missing | Prompt user to execute prior phases first, or directly plan roadmap based on user-provided objective list | Overall confidence significantly reduced, roadmap is only a general planning reference | Ask user to provide business objectives, feature requirements, and priority ranking |
| Resource constraints (user-provided) | If user does not provide resource constraints, prompt user to provide or skip steps related to this input | Lacking resource constraints, Epic effort estimation may be unrealistic | Ask user to provide resource constraint information such as team size, tech stack, and available timeline |

## Data Acquisition Instructions

This Skill requires OKR, strategic analysis, and requirement priority data. Please provide via one of the following methods:
  1. Directly describe business objectives and feature priorities
  2. Upload okr.json / strategic-analysis.json / insight-analysis.json files
  3. Provide the data file path
- AI is not responsible for external data collection, only for analysis

---

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| okr.json OKR adjustment | Strategic themes and Epic planning | Re-execute Step 1-2, update strategic themes and Epics |
| strategic-analysis.json strategic analysis update | Strategic theme direction | Re-execute Step 1, update strategic themes |
| Requirement priority data change | RICE scoring and ranking | Re-execute Step 4, update RICE scores and tiering |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Strategic theme adjustment | business-strategy-report, stakeholder-analysis | Output file version number + change summary |
| Epic priority change | business-strategy-report | Output file version number + change summary |
| Now/Next/Later tiering change | stakeholder-analysis | Output file version number + change summary |
