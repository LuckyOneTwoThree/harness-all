---
name: product-proposal
description: Use when you need to write a product project initiation proposal. Product project initiation proposal auto-generation, integrating all prior analysis results to generate a structured product project initiation document.
---
# Product Project Initiation Proposal Auto-Generation

## When to use
- Help me write a product project initiation document
- How to write a product proposal
- Keywords: project initiation, product proposal, initiation document, business plan, product planning document, project application, project proposal

## Outputs
- docs/strategy/PRODUCT_STRATEGY.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Evidence chain closed loop** — Every conclusion in the proposal must be traceable to prior analysis data; unsupported assertions are rejected
2. **Decision points explicit** — All key nodes requiring human decision must be annotated; AI cannot decide on behalf of humans
3. **Risks up front** — Technical/market/resource/compliance risks must be explicitly presented in the proposal
4. **One-pager first** — The executive summary must explain the core logic on one page, with detailed content as support

## Interaction Mode
🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| User research data | JSON | ○ | user-research-user-modeling | User personas, pain points, needs |
| Business model canvas | JSON | ○ | docs/strategy/business-strategy.md ("Business Model Canvas" section) | Business model 9-grid canvas |
| SWOT analysis | JSON | ○ | docs/strategy/PRODUCT_STRATEGY.md ("Strategic Analysis" section) | Strategic posture |
| OKR | JSON | ○ | docs/strategy/OKR.md | Objectives and Key Results |
| Roadmap | JSON | ○ | docs/strategy/roadmap.md | Product roadmap |
| Pricing strategy | JSON | ○ | docs/strategy/business-strategy.md ("Pricing Strategy" section) | Pricing plan |
| Positioning strategy | JSON | ○ | docs/strategy/positioning.md | Product positioning |
| Stakeholders | JSON | ○ | docs/strategy/stakeholder-analysis.md | Stakeholders |
| Product/business information | string | Yes | Provided by user | Product name, business description |

## Execution Steps

### Step 1: Executive Summary Generation [Core]

Generate a one-page executive summary, including:

| Element | Content |
|------|------|
| Product name | Product name and one-sentence description |
| Target users | Core user groups |
| Core value | One-sentence value proposition |
| Business model | Revenue model overview |
| Market opportunity | Market size and growth |
| Competitive advantage | Differentiated advantages |
| Key metrics | North Star Metric + core OKR |
| Resource requirements | Team, budget, time |
| Key risks | Top 3 risks |
| Decision requests | Items requiring approval |

### Step 2: Product Definition [Core]

Integrate user research and positioning data:

**Product Overview**:
- Product vision
- Target user personas
- Core use scenarios
- Value proposition

**Feature Scope**:
- MVP feature list
- V2.0 feature planning
- Feature priorities

### Step 3: Business Analysis [Core]

Integrate BMC, pricing, and SWOT data:

**Market Analysis**:
- Market size (TAM/SAM/SOM)
- Market growth trends
- Target market positioning

**Business Model**:
- Revenue model
- Pricing strategy
- Cost structure
- Unit economics

**Competitive Analysis**:
- Competitor comparison
- Differentiated advantages
- Competitive moat

### Step 4: Execution Plan [Core]

Integrate OKR and roadmap data:

**Goal System**:
- Annual OKR
- Quarterly milestones
- Key metrics

**Roadmap**:
- Now/Next/Later
- Resource requirements
- Dependencies

### Step 5: Risk Assessment [Core]

Identify and assess key risks:

| Risk Category | Assessment Dimension |
|----------|----------|
| Market risk | Demand changes, competitor actions, market contraction |
| Technical risk | Technical feasibility, performance bottlenecks, security compliance |
| Resource risk | Talent shortage, budget shortfall, time pressure |
| Execution risk | Team capability, collaboration efficiency, external dependencies |

### Step 6: Document Assembly [Core]

**Proposal Structure**:

```
# {Product Name} Product Project Initiation Proposal

## Executive Summary (one page)

## 1. Product Definition
### 1.1 Product Vision
### 1.2 Target Users
### 1.3 Core Value
### 1.4 Feature Scope

## 2. Business Analysis
### 2.1 Market Opportunity
### 2.2 Business Model
### 2.3 Competitive Analysis

## 3. Execution Plan
### 3.1 Goal System
### 3.2 Product Roadmap
### 3.3 Resource Requirements

## 4. Risk Assessment
### 4.1 Risk Matrix
### 4.2 Mitigation Measures

## 5. Decision Requests
### 5.1 Items Requiring Approval
### 5.2 Suggested Next Steps

## Appendix
- Data sources
- Assumption list
- Detailed analysis
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Product proposal and core arguments | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Complete artifact, including all Step outputs |
| deep | Full proposal + business feasibility analysis + technical feasibility assessment + risk and mitigation plan | Full artifact + extended analysis + deep reasoning |

## Output

**Storage path**: `docs/strategy/PRODUCT_STRATEGY.md ("Product Proposal" section)`

**Output files**:

| File | Format | Description |
|------|------|------|
| product-proposal.md | Markdown | Complete product project initiation proposal |
| product-proposal.json | JSON | Structured data |

**Output Schema validation rules** and a complete product-proposal.json example:

> See [Reference/output-schema.md](./Reference/output-schema.md) for the full field validation rules table (proposal_metadata, executive_summary, product_definition, business_analysis, execution_plan, risk_assessment, decision_requests) and a complete product-proposal.json example.

## Decision Rules

| Condition | Decision |
|------|------|
| All upstream data complete | Generate full proposal |
| Some upstream data missing | Annotate missing parts, generate based on existing data |
| Key data missing (user/market) | Prompt to supplement data, lower confidence |
| Overall confidence < 0.5 | Annotate "Recommend supplementing data before approval" |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] executive_summary field ≤ 500 characters
- [ ] product_definition contains ≥ 1 target_user and feature_scope.mvp_features ≥ 3

### P1 Checks (must pass for standard/deep)

- [ ] business_analysis.market_analysis contains TAM/SAM/SOM and business_model.revenue_model is non-empty
- [ ] execution_plan.okr contains ≥ 2 key_results and roadmap.now is non-empty
- [ ] risk_assessment.risks covers ≥ 3 categories
- [ ] decision_requests contains ≥ 1 specific approval item
- [ ] proposal_metadata.data_sources contains ≥ 1 source

### P2 Checks (only required for deep)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision record complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files are missing, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| User research data | Derive user personas based on product description | User definition lacks empirical data, personas may be subjective | Ask user to provide target user characteristics and core pain point descriptions or upload persona.json file |
| bmc.json | Derive business model based on product description | Business model lacks 9-grid canvas structured support | Ask user to provide revenue model, cost structure, and value proposition descriptions or upload bmc.json file |
| strategic-analysis.json | Derive strategic posture based on product description | Strategic analysis lacks structured basis | Ask user to provide product strengths and challenges descriptions or upload strategic-analysis.json file |
| okr.json | Derive objectives based on product description | OKR lacks strategic alignment, quantifiability may be insufficient | Ask user to provide business objectives and Key Results or upload okr.json file |
| roadmap.json | Derive roadmap based on product description | Roadmap lacks RICE prioritization basis | Ask user to provide feature priorities and time planning or upload roadmap.json file |
| Pricing/positioning/stakeholder data | Derive based on product description | Corresponding sections lack data anchoring | Ask user to provide pricing plan, product positioning, and organizational structure information |
| All upstream files missing | Generate full proposal based on user-provided product description | Overall confidence significantly reduced, proposal lacks data support | Ask user to provide product name, core features, target users, and business objectives |

---

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| User research data update | Product definition, target users | Update product definition section |
| bmc.json business model change | Business analysis section | Update business model and unit economics |
| strategic-analysis.json strategic analysis update | Business analysis competitive analysis | Update competitive analysis and risk assessment |
| okr.json OKR adjustment | Execution plan section | Update goal system and roadmap |
| roadmap.json roadmap change | Execution plan section | Update roadmap and resource requirements |
| Pricing strategy change | Business analysis section | Update pricing strategy and unit economics |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Proposal content change | stakeholder-analysis | Output file version number + change summary |
| Risk assessment change | stakeholder-analysis | Output file version number + change summary |
| Decision request change | stakeholder-analysis | Output file version number + change summary |
