---
name: growth-model
description: Use when you need to diagnose the product growth model. Growth Model Auto-Diagnosis Pipeline analyzes product features, user data, and business model to automatically match the optimal growth model (PLG/SLG/MLG/Hybrid), outputting a growth flywheel model, key constraints, and bottleneck analysis.
---
# Growth Model Auto-Diagnosis

## When to use
- Diagnose the product's growth model
- Are we PLG or SLG
- How to build the growth flywheel
- Where is the growth bottleneck
- Keywords: growth model, PLG, SLG, growth flywheel, growth diagnosis

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/metrics/data-analysis-report.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/growth/growth-strategy.md
- growth_model.json

## Core Principles

1. **Model matches product essence**: PLG/SLG/MLG is not a choice but the inevitable result of product features and business model
2. **Flywheel must form a closed loop**: The growth flywheel must form a reinforcing loop; an open loop is a chain, not a flywheel
3. **Bottleneck determines leverage**: The current biggest bottleneck determines the highest-leverage investment direction; resources always go to the bottleneck

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Product features | object | Yes | User-provided | Product type, core features, value proposition |
| User data | object | Yes | docs/metrics/data-analysis-report.md ("Retention Analysis" section) | User behavior, conversion funnel, retention curve |
| Business model | object | Yes | User-provided | Pricing strategy, target customers, market positioning |

## Execution Steps

### Step 1: Growth Model Matching Decision Tree [Core]

Analyze the following dimensions to determine the optimal growth model:

#### PLG (Product-Led Growth) Characteristics
- Product can independently deliver user value
- Users can self-register and self-serve
- Network effects exist or value increases with usage
- Word-of-mouth is an important acquisition channel

#### SLG (Sales-Led Growth) Characteristics
- High average deal size (complex B2B decisions)
- Requires manual demos and customized services
- Sales team is the core acquisition engine
- Customer success is key to retention

#### MLG (Marketing-Led Growth) Characteristics
- Brand awareness is a prerequisite for purchase
- Content marketing and SEO are important channels
- Requires sustained marketing investment to maintain growth
- Product is relatively standardized

#### Hybrid Model Determination
- Different user segments adopt different growth models
- Different product lines adopt different growth models
- Different market stages adopt different growth models

### Step 2: Flywheel Auto-Modeling [Core]

Based on the identified growth model, construct the growth flywheel model:

1. **Identify core value loop**: Find the core causal chain of product value creation
2. **Identify flywheel nodes**: Key user behaviors and business metrics
3. **Identify reinforcing loops**: Which nodes positively reinforce other nodes
4. **Identify friction points**: Sources of friction when the flywheel rotates

### Step 3: Cold-Start Threshold Identification [Core]

Analyze the cold-start conditions of the growth flywheel:

- How many initial users/revenue are needed to trigger flywheel self-rotation?
- What external resources are needed during the cold-start phase?
- How to validate the flywheel hypothesis?

### Step 4: Key Leverage Identification [Core]

Based on the flywheel model, identify the highest-leverage growth actions for the current stage:

- Which node, if strengthened first, would bring the greatest flywheel acceleration?
- Which bottleneck, if removed, would unlock the greatest growth potential?
- Which stage should resources be prioritized for?

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Growth model diagnosis and bottleneck localization | Core conclusions + minimum viable artifact |
| standard | Complete artifact (current default) | Complete artifact, including all Step outputs |
| deep | Complete diagnosis + flywheel modeling + cold-start simulation + growth stage evolution roadmap | Complete artifact + extended analysis + deep inference |

## Output

**Storage path**: `docs/growth/growth-strategy.md ("Growth Model" section)`

**Output file**: growth_model.json

**Output Schema**:

```json
{
  "type": "object",
  "required": ["model", "flywheel", "bottleneck"],
  "properties": {
    "model": {"type": "string", "description": "Growth model: PLG/SLG/MLG/Hybrid"},
    "flywheel": {"type": "object", "description": "Growth flywheel model, including nodes and edges"},
    "key_constraints": {"type": "array", "description": "List of key constraints"},
    "bottleneck": {"type": "string", "description": "Description of current biggest bottleneck"},
    "confidence": {"type": "number", "description": "Diagnosis confidence"}
  }
}
```

`growth_diagnosis`
```json
{
  "model": "PLG|SLG|MLG|Hybrid",
  "flywheel": {
    "nodes": ["Teacher registers and uses", "Creates and publishes courses", "Students join and learn", "Learning data feedback", "Word-of-mouth referral"],
    "edges": [{"from": "Students join and learn", "to": "Word-of-mouth referral", "description": "The better the student learning outcomes, the more willing teachers are to recommend to peers"}]
  },
  "key_constraints": ["Free version limits courses to 3, affecting teacher depth of usage"],
  "bottleneck": "Teacher activation rate only 35%, course creation threshold too high",
  "confidence": 0.95
}
```

### Diagnosis Output Example

```
Growth Model: Hybrid (PLG + SLG)

Growth Flywheel:
├── PLG flywheel: User registration → Product usage → Value discovery → Word-of-mouth referral → New user registration
├── SLG flywheel: Marketing campaigns → Lead generation → Sales follow-up → Enterprise purchase → Customer success → Upsell

Key Constraints:
1. PLG side: Free-to-paid conversion rate only 2.3%, payment funnel needs optimization
2. SLG side: Average sales cycle 45 days, lead conversion rate 12%

Current Biggest Bottleneck: PLG user activation rate low (35%), leading to insufficient word-of-mouth referrals

Recommended Priority Actions:
1. Optimize Onboarding flow, target activation rate increase to 50%
2. Identify common behavioral characteristics of high-activation-rate users
3. Design activation intervention strategies for low-activation users
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| model | string | Yes | Growth model, only PLG/SLG/MLG/Hybrid allowed |
| flywheel | object | Yes | Flywheel model, must contain nodes and edges |
| flywheel.nodes | array | Yes | Flywheel node list, at least 4 nodes |
| flywheel.nodes[].node_name | string | Yes | Node name, cannot be empty |
| flywheel.edges | array | Yes | Flywheel edge list, at least 2 edges, must contain from/to/description |
| flywheel.edges[].from | string | Yes | Source node, cannot be empty |
| flywheel.edges[].to | string | Yes | Target node, cannot be empty |
| flywheel.edges[].description | string | Yes | Causal relationship description, cannot be empty |
| key_constraints | array | Yes | Key constraints list, max 5 |
| key_constraints[].constraint | string | Yes | Constraint description, cannot be empty |
| key_constraints[].impact | string | No | Impact assessment |
| key_constraints[].suggested_action | string | No | Suggested action |
| bottleneck | string | Yes | Bottleneck description, cannot be empty |
| confidence | number | Yes | Diagnosis confidence, range 0-1 |

## Decision Rules

| Condition | Decision |
|------|------|
| Product self-service completion rate ≥60% + viral coefficient K>1 | Recommend PLG model |
| Average deal size ≥50,000 + sales cycle ≥30 days | Recommend SLG model |
| Content-driven acquisition share ≥40% | Recommend MLG model |
| None of the above conditions clearly met | Recommend Hybrid model, mark as needing validation |
| Growth flywheel self-driving score ≥7/10 | Mark "can auto-execute" |
| Growth flywheel self-driving score <7/10 | Mark "needs human intervention", human confirms final growth model |
| Bottleneck constraints ≥3 | Prioritize solving the 1 with highest constraint, others on watchlist |
| North Star metric mismatched with current growth model | Recommend re-evaluating growth model |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] North Star metric directly linked to ≥1 OKR Objective
- [ ] Growth model contains ≥3 quantifiable variables with clear causal relationships

### P1 Checks (standard/deep must pass)

- [ ] Input variables 100% trackable (have data source or collection plan)
- [ ] Each diagnostic recommendation cites at least 1 data point
- [ ] Growth flywheel contains ≥4 nodes and forms a closed loop
- [ ] Bottleneck constraints identified ≤5, each with quantified impact assessment

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| Product features missing | User describes product → diagnose growth model based on description | Product features based on user description, diagnosis accuracy limited | Require user to provide product description (what the product is, what problem it solves, core value proposition) |
| User data missing | Skip data-driven growth stage assessment, infer based on user description | Growth stage assessment based on qualitative description | Require user to provide current growth stage and core growth metrics (e.g., DAU, GMV, MRR) |
| Business model missing | Use generic business model template, mark "to be confirmed" | Business model fit may be low | Require user to provide business model type (subscription/transaction/advertising/platform) and revenue sources |
| Product features + user data + business model all missing | User describes product → diagnose growth model based on description | Output growth diagnosis based on description, key parameters marked "to be confirmed" | Require user to provide product description, growth stage, and business model info |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Product Description**: What the product is, what problem it solves, core value proposition
- **Current Growth Stage** (optional): Product is in exploration/growth/mature/decline phase
- **Core Growth Metrics** (optional): Current most-watched growth metrics (e.g., DAU, GMV, MRR)

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| analysis-retention | Retention curve shape change | Growth model assessment and flywheel modeling | Re-evaluate growth model, adjust flywheel nodes |
| User-provided - Product features | Major product feature changes | PLG/SLG/MLG model matching | Re-run decision tree, update model assessment |
| User-provided - Business model | Pricing or target customer changes | Growth model matching and bottleneck localization | Re-evaluate business model fit |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| growth-strategy-report | Growth model or bottleneck change | Write to output file | New growth model, flywheel model, and bottleneck localization |
| acquisition-analysis | Growth model change | Output file update | Model diagnosis completion status and key conclusions |
| activation-orchestrator | Growth model change | Output file update | Model diagnosis completion status and key conclusions |
| retention-management | Growth model change | Output file update | Model diagnosis completion status and key conclusions |
| revenue-orchestrator | Growth model change | Output file update | Model diagnosis completion status and key conclusions |
