---
name: business-strategy-report
description: Used when a complete business strategy planning document is needed. Auto-generates a business strategy planning report that integrates Business Model Canvas, SWOT, OKR, roadmap, positioning, and stakeholder data, supplements strategic reasoning and execution paths, and outputs a structured Markdown report.
---
# Business Strategy Planning Report Auto-Generation

## When to use
- Help me write a business strategy plan
- Produce a strategy report
- Keywords: business strategy report, strategic planning, business planning, strategy document, business analysis report, strategic planning document, business planning report

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

> **Assembly-only mode**: This skill is an assembly skill. Steps 1-2 perform synthesis from already-produced upstream artifacts, NOT re-analysis. The upstream skills (business-model-canvas, business-value-fit, business-pricing, positioning-strategy, stakeholder-analysis, planning-north-star, planning-okr, planning-roadmap, strategic-analysis) own the analysis; this skill synthesizes them into a coherent strategic narrative.

### Step 1: Assembly + Strategic Posture Synthesis [Core]

**Assembly** (read-only, no re-analysis):
- Read Business Model Canvas from `docs/strategy/business-strategy.md` ("Business Model Canvas" section)
- Read Value Fit from `docs/strategy/business-strategy.md` ("Value Fit" section)
- Read Pricing from `docs/strategy/business-strategy.md` ("Pricing Strategy" section)
- Read SWOT from `docs/strategy/PRODUCT_STRATEGY.md` ("Strategic Analysis" section)
- Read OKR from `docs/strategy/OKR.md`
- Read Roadmap from `docs/strategy/roadmap.md`
- Read Positioning from `docs/strategy/positioning.md`
- Read Stakeholders from `docs/strategy/stakeholder-analysis.md`
- Read North Star from `docs/strategy/PRODUCT_STRATEGY.md` ("North Star" section)

**Synthesis** (new analysis, not re-derivation):
- Strategic Posture Matrix: derive from assembled SWOT + Value Curve (synthesize, not re-analyze)
- Strategic posture judgment: Offensive / Defensive / Turnaround / Survival based on assembled data

**Strategic Posture Matrix**:

| | Many Opportunities | Many Threats |
|------|--------|--------|
| **Strong Strengths** | Offensive Strategy | Defensive Strategy |
| **Obvious Weaknesses** | Turnaround Strategy | Survival Strategy |

### Step 2: Strategic Direction Synthesis [Core]

**Synthesis** (based on assembled data, not re-derivation):
- Compare 2-3 strategic directions based on assembled posture assessment + positioning + OKR
- Each direction includes: Ansoff positioning, core rationale (cite upstream evidence), target market, differentiation strategy, key assumptions, risk factors

**Reasoning Logic**:
```
Posture Synthesis → Ansoff Matrix Positioning → Strategic Direction Comparison → Positioning Validation → OKR Alignment
```

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
