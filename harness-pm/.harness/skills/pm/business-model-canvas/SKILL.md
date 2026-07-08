---
name: business-model-canvas
description: Triggered when designing or evaluating a product business model. Business Model Canvas auto-generation, transforms product discovery stage insights into a 9-block business canvas.
---
# Business Model Canvas Auto-Generation

## When to use
- Help me clarify the business model
- How does our business model make money
- Keywords: business model canvas, BMC, value proposition, revenue model, cost structure, how to make money, business model mapping

## Outputs
- docs/strategy/business-strategy.md
- memory/progress.md

## Core Principles

1. **Nine-block linkage** — The 9 building blocks of the canvas must be logically self-consistent. Customer segments → value proposition → channels → revenue form a closed loop.
2. **Options over conclusions** — Generate 2-3 comparable options for key decision points such as revenue model, for human selection.
3. **Explicit assumption annotation** — All inferred content is annotated as assumptions, including risk level and validation method.
4. **Automatic financial inference** — Unit economics and sensitivity analysis are automatically completed by AI; humans only review conclusions.

**Execution cycle**: Triggered after the product discovery stage is complete.

**Core objective**: Transform user insights and market data collected during the product discovery stage into a structured business model canvas, clarifying the system architecture for value creation, delivery, and capture.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| product_context | JSON | Yes | user-research-user-modeling / opportunity-definition | Discovery stage output: user persona, problem statement, opportunity definition |
| market_data | JSON | Yes | market-competitor-analysis | Market data: competitor business models, market size, industry benchmarks |

> See [Reference/examples.md](./Reference/examples.md) for input JSON examples (product_context, market_data).

## Execution Steps

### Step 1: Customer Segments Population [Core]

**Task**: Based on user persona and pain point analysis, define target customer segments.

**Execution logic**:
1. Extract key characteristics of user personas from the discovery stage
2. Divide segments by need priority and reachability
3. Define core characteristics for each segment

> See [Reference/examples.md](./Reference/examples.md) → "Step 1: Customer Segments Output" for output format.

**Acceptance criteria**:
- At least 2 differentiated customer segments identified
- Each segment has clear characteristic description
- Priority ranking supported by data

### Step 2: Value Proposition Population [Core]

**Task**: Based on user pain points and competitive analysis, design differentiated value propositions.

**Execution logic**:
1. Extract core user pain points and high-priority needs
2. Analyze coverage and gaps in competitor value propositions
3. Design value propositions that address key pain points
4. Define Pain Relievers and Gain Creators

> See [Reference/examples.md](./Reference/examples.md) → "Step 2: Value Propositions Output" for output format.

**Acceptance criteria**:
- Each customer segment has at least 1 value proposition
- Value propositions directly correspond to high-priority pain points
- Include specific descriptions of Pain Relievers and Gain Creators

### Step 3a: Revenue Streams Population (Decision Tree Matching) [Core]

**Task**: Based on product characteristics and market benchmarks, automatically match potential revenue model types.

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Revenue Model Decision Tree (Step 3a)" for decision tree logic.

**Step 3b: Multi-option Revenue Model Generation** [Conditional]

**Task**: Based on Step 3a decision tree results, generate at least 2 comparable revenue model options.

**Execution logic**:
1. Determine primary revenue model based on decision tree results
2. Generate at least 1 alternative revenue model (consider hybrid models)
3. Analyze strengths and risks of each model

> See [Reference/examples.md](./Reference/examples.md) → "Step 3b: Revenue Models Output" for output format.

**Acceptance criteria**:
- At least 2 revenue model options generated
- Each model includes clear pricing structure
- Pros/cons analysis and risk level annotated

### Step 4: Cost Structure Population [Conditional]

**Task**: Based on business model requirements, analyze and estimate cost structure.

**Execution logic**:
1. Identify cost drivers based on key activities and resource allocation
2. Distinguish fixed costs and variable costs
3. Estimate the magnitude and proportion of each cost item
4. Compare with industry benchmarks

> See [Reference/examples.md](./Reference/examples.md) → "Step 4: Cost Structure Output" for output format.

**Acceptance criteria**:
- Main cost items identified
- Fixed and variable costs classified
- Unit economics indicators set

### Step 5: Channels Population [Conditional]

**Task**: Define channels for reaching customers and delivering value.

**Execution logic**:
1. Determine reach channel preferences based on customer segments
2. Analyze cost and efficiency of each channel
3. Design online/offline channel mix
4. Plan channel priority

> See [Reference/examples.md](./Reference/examples.md) → "Step 5: Channels Output" for output format.

**Acceptance criteria**:
- Covers all stages of customer journey
- Direct and indirect channel mix
- Reasonable priority ranking

### Step 6: Key Activities/Resources/Partners Population [Conditional]

**Task**: Define key activities, resources, and partners needed to realize the business model.

**Execution logic**:

**Key activities identification:**
1. Value creation activities
2. Platform/network building activities
3. Customer acquisition activities

**Key resources identification:**
1. Physical assets
2. Intellectual property
3. Human resources
4. Financial resources

**Key partners identification:**
1. Suppliers
2. Strategic alliances
3. Joint venture partners

> See [Reference/examples.md](./Reference/examples.md) → "Step 6: Key Activities/Resources/Partners Output" for output format.

**Acceptance criteria**
- Key activities cover the full value creation process
- Resource requirements match capabilities
- Partnership design reasonable

### Step 7: Customer Relationships Population [Conditional]

**Task**: Define relationship types with different customer segments.

**Execution logic**:
1. Analyze relationship needs at each stage of the customer journey
2. Determine the mix of self-service/assisted service/community service
3. Plan customer relationship evolution path

> See [Reference/examples.md](./Reference/examples.md) → "Step 7: Customer Relationships Output" for output format.

**Acceptance criteria**:
- Each customer segment has a corresponding relationship type
- Relationship type matches product characteristics
- Touchpoints clear

## Output

**Storage path**: `docs/strategy/business-strategy.md ("Business Model Canvas" section)`

**Output files**: bmc.json, assumptions.json

> See [Reference/output-schema.md](./Reference/output-schema.md) for output validation rules, complete Business Canvas JSON schema, and assumption list JSON.

## Decision Rules

### Revenue Model Decision Rules

1. **Option generation rule**: Must generate at least 2 revenue model options for selection

2. **Risk assessment rule**:
   - High-risk assumptions must be explicitly annotated in recommendations
   - When high-risk assumption failure affects > 50% of revenue, force escalation to human approval

3. **Explicit assumption rule**:
   - All revenue assumptions must be listed
   - Each assumption must be annotated with risk level (low/medium/high)
   - Assumption sources must be traceable

### Overall Decision Rules

1. **Multi-option presentation**: Generate 2-3 comparable options for each key decision point

2. **Data support annotation**: Each canvas element must annotate data source and inference basis

3. **Uncertainty transparency**: All inferred content must be annotated with confidence

## Quality Checks

### Self-Check List

- [ ] All 9 building blocks of the business model canvas populated (P0)
- [ ] Each element's content has data support or assumption annotation (P0)
- [ ] At least 2 revenue model options generated (P1)
- [ ] Assumption list complete, each assumption includes: (P1)
  - Clear description
  - Risk level annotated
  - Validation status annotated
  - Impact assessment provided
- [ ] Validation method recommended for core assumptions (P1)
- [ ] Unit economics indicators set (P2)

### Output Quality Standards

1. **Completeness (P0)**: Each of the 9 blocks has at least 1 content item, and value_propositions correspond to customer_segments
2. **Traceability (P0)**: Each block annotates data_source (upstream skill/user description/AI inference)
3. **Assumption completeness (P1)**: assumptions list ≥ 3 items, each including assumption+validation_method+priority
4. **Revenue verifiability (P2)**: revenue_streams includes ≥ 1 specific revenue stream and pricing strategy has numeric range

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently.

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Degradation Strategy" for the full degradation table (missing input scenarios, impact, and data acquisition notes).

## Data Acquisition Notes

This Skill requires discovery stage output data (Persona, opportunity brief, etc.). Please provide via one of the following:
  1. Directly describe product concept, target users, and value proposition
  2. Upload persona.json / opportunity-definition.json and other files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

---

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Upstream Change Impact Table" and "Downstream Notification Mechanism Table" for change impact and notification details.

---

## Human Review Checklist

Before submitting for human approval, ensure the following:

- [ ] Customer segments match actual market conditions
- [ ] Value proposition differentiation is clear and achievable
- [ ] Revenue model options each have clear pros/cons
- [ ] Cost structure matches operational plan
- [ ] Key assumptions are verifiable with a validation plan
