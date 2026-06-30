---
name: business-strategy-report
description: Used when a complete business strategy planning document is needed. Auto-generates a business strategy planning report that integrates Business Model Canvas, SWOT, OKR, roadmap, positioning, and stakeholder data, supplements strategic reasoning and execution paths, and outputs a structured Markdown report. Keywords: business strategy report, strategic planning, business planning, strategy document, business analysis report, strategic planning document, business planning report.
---
# Business Strategy Planning Report Auto-Generation

## When to use
- Help me write a business strategy plan
- Produce a strategy report

## Outputs
- docs/strategy/business-strategy.md
- memory/progress.md

## Core Principles

1. **Strategy is the art of saying no** — A good strategy explicitly states what not to do, rather than trying to do everything
2. **Traceable logic chain** — From market insight → strategic choice → execution path, every step of reasoning must be verifiable
3. **Quantitative over qualitative** — Use numbers wherever possible instead of adjectives
4. **Execution-oriented** — Strategy without execution is empty talk; every strategic direction must have corresponding OKRs and a roadmap

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| Business Model Canvas | JSON | ○ | docs/strategy/business-strategy.md ("Business Model Canvas" section) | 9-block business model |
| SWOT Analysis | JSON | ○ | docs/strategy/PRODUCT_STRATEGY.md ("Strategic Analysis" section) | Strengths/Weaknesses/Opportunities/Threats |
| OKR | JSON | ○ | docs/strategy/OKR.md | Objectives and Key Results |
| Roadmap | JSON | ○ | docs/strategy/roadmap.md | Product roadmap |
| Positioning Strategy | JSON | ○ | docs/strategy/positioning.md | Product positioning |
| Value Curve | JSON | ○ | docs/strategy/positioning.md | Competitive value curve |
| Differentiation Assessment | JSON | ○ | docs/strategy/positioning.md | Degree of differentiation |
| Stakeholders | JSON | ○ | docs/strategy/stakeholder-analysis.md | Stakeholder map |
| Pricing Strategy | JSON | ○ | docs/strategy/business-strategy.md ("Pricing Strategy" section) | Pricing options |
| North Star Metric | JSON | ○ | docs/strategy/PRODUCT_STRATEGY.md ("North Star" section) | Core metric definition |
| Product/Business Info | string | Yes | User provided | Product name, business model, current stage |

## Execution Steps

### Step 1: Strategic Posture Assessment [Core]

Integrate SWOT + Porter's Five Forces + Value Curve to assess the current strategic posture:

**External Environment Assessment**:
- Industry attractiveness (Porter's Five Forces conclusion)
- Market opportunity window (SWOT's O)
- External threat level (SWOT's T)
- Competitive positioning (differentiated position in the value curve)

**Internal Capability Assessment**:
- Core strengths (SWOT's S)
- Key weaknesses (SWOT's W)
- Resource endowment (key resources from the Business Model Canvas)
- Capability gaps (capabilities needed to execute the strategy but currently missing)

**Strategic Posture Matrix**:

| | Many Opportunities | Many Threats |
|------|--------|--------|
| **Strong Strengths** | Offensive Strategy | Defensive Strategy |
| **Obvious Weaknesses** | Turnaround Strategy | Survival Strategy |

### Step 2: Strategic Direction Reasoning [Core]

Based on the posture assessment, reason through 2-3 strategic directions:

**Reasoning Logic**:
```
Posture Judgment → Ansoff Matrix Positioning → Strategic Direction Selection → Positioning Validation → OKR Alignment
```

**Each strategic direction includes**:

| Element | Description |
|------|------|
| Direction Name | One-sentence summary |
| Ansoff Positioning | Market Penetration / Market Development / Product Development / Diversification |
| Core Rationale | Why this direction is viable (cite SWOT/Five Forces/Value Curve evidence) |
| Target Market | Which users/scenarios to focus on |
| Differentiation Strategy | How to differentiate from competitors (cite differentiation assessment) |
| Key Assumptions | Preconditions for the strategy to hold |
| Risk Factors | Factors that may cause the strategy to fail |

**Strategic Direction Comparison Table**:

| Dimension | Direction A | Direction B | Direction C |
|------|-------|-------|-------|
| Market Attractiveness | | | |
| Competitive Advantage Fit | | | |
| Resource Requirements | | | |
| Risk Level | | | |
| Expected Return | | | |
| Recommendation Score | | | |

### Step 3: Execution Path Planning [Core]

Develop an execution path for the recommended strategic direction:

**OKR Alignment**:
- Break down the strategic direction into annual Objectives
- Each Objective corresponds to 2-4 Key Results
- Key Results must be quantifiable and trackable
- Mark the linkage to the North Star Metric

**Roadmap Mapping**:
- Q1-Q4 milestones
- Deliverables for each milestone
- Key dependencies
- Resource requirement estimation

**Pricing Strategy Embedding**:
- Fit between current pricing and the strategic direction
- Pricing adjustment recommendations (if any)

### Step 4: Stakeholder Management [Core]

Integrate stakeholder data and develop a communication strategy:

| Stakeholder | Attitude | Influence | Communication Strategy | Communication Frequency |
|-----------|------|--------|---------|---------|
| Decision Makers | | High | Strategy reporting + ROI justification | Monthly |
| Execution Team | | High | Goal alignment + resource assurance | Weekly |
| External Partners | | Medium | Value sharing + risk sharing | As needed |

### Step 5: Risks and Contingencies [Core]

Identify key risks in strategy execution:

| Risk Category | Specific Risk | Probability | Impact | Contingency |
|----------|---------|------|------|------|
| Market Risk | Demand changes / competitor actions | | | |
| Resource Risk | Insufficient personnel / funding | | | |
| Execution Risk | Team capability / collaboration issues | | | |
| Technical Risk | Technical feasibility / data security | | | |

### Step 6: Report Assembly [Core]

**Report Structure**:

```
# {Product Name} Business Strategy Plan

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Decision Rules

| Condition | Decision |
|------|------|
| SWOT data missing | Derive posture assessment from product info and AI knowledge, mark "lacks SWOT data" |
| OKR data missing | Derive OKRs from strategic direction, mark "manual calibration recommended" |
| Roadmap data missing | Derive milestones from OKRs, mark "timeline supplementation recommended" |
| Positioning data missing | Strategic direction lacks positioning validation, mark "positioning analysis supplementation recommended" |
| All upstream data missing | Generate from product info and AI knowledge base, overall confidence reduced |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Executive summary includes posture judgment + recommended direction + core OKR
- [ ] Strategic posture matrix generated

### P1 Checks (must pass for standard/deep)

- [ ] At least 2 strategic directions compared
- [ ] OKRs are quantifiable and trackable
- [ ] Roadmap includes Q1-Q4 milestones
- [ ] Key risks have contingencies
- [ ] All inferences annotated with confidence

### P2 Checks (must pass for deep only)

- [ ] Extended analysis complete (in-depth reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| bmc missing | Derive business model from product info | Business model analysis may be incomplete, lacking 9-block canvas structured support | Require user to provide product features, revenue model, and cost structure description or upload bmc.json file |
| swot missing | Derive posture from product info and AI knowledge | Posture assessment lacks structured basis, strategic direction may be subjective | Require user to provide product strengths, weaknesses, opportunities, and threats description or upload strategic-analysis.json file |
| okr missing | Derive OKRs from strategic direction | OKRs need manual calibration, quantifiability may be insufficient | Require user to provide business objectives and expected key results or upload okr.json file |
| roadmap missing | Derive milestones from OKRs | Timeline needs manual adjustment, milestone dependencies may be inaccurate | Require user to provide feature priorities and time constraints or upload roadmap.json file |
| positioning missing | Strategic direction lacks positioning validation | Differentiation strategy needs supplementary validation, competitive positioning may be vague | Require user to provide product differentiation description or upload positioning-strategy output file |
| Product/Business Info (user provided) | If user does not provide product/business info, prompt user to provide or skip related steps | Report cannot generate core content | Require user to provide product name, core features, target users, and business objectives |

---

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| bmc.json business model change | Strategic posture internal capability assessment, execution path business model | Reassess internal capabilities, update business model section in execution path |
| strategic-analysis.json strategy analysis update | Strategic posture assessment, strategic direction reasoning | Re-execute Step 1 and Step 2, update posture matrix and direction recommendation |
| okr.json OKR adjustment | Execution path OKR alignment | Re-execute Step 3, update OKR system and roadmap mapping |
| roadmap.json roadmap change | Execution path milestones | Re-execute Step 3 roadmap mapping section |
| positioning positioning change | Strategic direction differentiation strategy | Reassess differentiation logic of strategic direction |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Strategic direction adjustment | stakeholder-analysis | Output file version number + change summary |
| OKR change | planning-roadmap | Output file version number + change summary |
| Risk contingency update | stakeholder-analysis | Output file version number + change summary |
| Posture assessment change | strategic-analysis | Output file version number + change summary |
