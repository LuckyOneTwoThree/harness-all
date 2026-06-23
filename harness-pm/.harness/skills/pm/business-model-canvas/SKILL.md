---
name: business-model-canvas
description: Triggered when designing or evaluating a product business model. Business Model Canvas auto-generation, transforms product discovery stage insights into a 9-block business canvas. Keywords: business model canvas, BMC, value proposition, revenue model, cost structure, how to make money, business model mapping.
metadata:
  module: "Product Business & Strategy"
  sub-module: "Business Model Design"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["SaaS", "E-commerce", "General"]
  triggers:
    - "Help me clarify the business model"
    - "How does our business model make money"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Generate 9-block canvas core elements (customer segments, value proposition, revenue streams, cost structure) and basic assumption list"
  deep_description: "Additionally includes unit economics sensitivity analysis, assumption validation roadmap, inter-block linkage consistency check, long-term business model evolution projection"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/discovery/user-research.md
  - docs/discovery/market-analysis.md
writes:
  - docs/strategy/business-strategy.md
  - memory/progress.md
---

# Business Model Canvas Auto-Generation

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

### Required Inputs

**product_context (from discovery stage):**
```json
{
  "persona_summary": "Target user persona summary, including user characteristics, needs, pain points",
  "problem_statement": "User problem statement, clarifying the core problem to solve",
  "opportunity_definition": "Business opportunity definition, including market size, opportunity description"
}
```

**market_data (market data):**
```json
{
  "competitor_business_models": [
    {
      "competitor_name": "Competitor name",
      "business_model_type": "Competitor business model type",
      "key_elements": {
        "value_proposition": "Competitor value proposition",
        "revenue_model": "Competitor revenue model",
        "pricing": "Competitor pricing"
      }
    }
  ],
  "market_size": {
    "tam": "Total Addressable Market",
    "sam": "Serviceable Available Market",
    "som": "Serviceable Obtainable Market"
  },
  "industry_benchmarks": {
    "typical_margin": "Industry typical profit margin",
    "typical_pricing": "Industry typical pricing range",
    "customer_acquisition_cost": "Industry customer acquisition cost benchmark"
  }
}
```

## Execution Steps

### Step 1: Customer Segments Population [Core]

**Task**: Based on user persona and pain point analysis, define target customer segments.

**Execution logic**:
1. Extract key characteristics of user personas from the discovery stage
2. Divide segments by need priority and reachability
3. Define core characteristics for each segment

**Output format**:
```json
{
  "customer_segments": [
    {
      "segment_id": "segment-1",
      "name": "Small and medium training institutions",
      "characteristics": ["Student scale 50-500", "Has online transformation needs"],
      "primary_pains": ["Lack technical capability to build online teaching platforms"],
      "priority": "high/medium/low"
    }
  ]
}
```

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

**Output format**:
```json
{
  "value_propositions": [
    {
      "proposition_id": "vp-1",
      "headline": "AI-driven personalized teaching SaaS platform",
      "description": "Provides out-of-the-box online teaching solutions for training institutions through AI adaptive learning engine",
      "target_segment": "segment-1",
      "pain_relievers": ["Lower technical barriers for training institutions to go online", "Improve student learning efficiency and completion rate"],
      "gain_creators": ["Training institution operating costs reduced by 40%", "Student completion rate increased to 85%"],
      "differentiation": "AI adaptive learning engine dynamically adjusts teaching paths, distinct from static course platforms"
    }
  ]
}
```

**Acceptance criteria**:
- Each customer segment has at least 1 value proposition
- Value propositions directly correspond to high-priority pain points
- Include specific descriptions of Pain Relievers and Gain Creators

### Step 3a: Revenue Streams Population (Decision Tree Matching) [Core]

**Task**: Based on product characteristics and market benchmarks, automatically match potential revenue model types.

**Decision tree logic**:

```
Start
  │
  ├─ Product form = Physical goods?
  │     └─ Yes → Checkpoint: Need subscription service?
  │           ├─ Yes → Revenue model = Subscription + One-time purchase
  │           └─ No → Revenue model = One-time sales
  │
  ├─ Product form = Software/Digital service?
  │     └─ Yes → Checkpoint: User usage frequency?
  │           ├─ High frequency (>1 time/week) → Revenue model = Subscription
  │           ├─ Medium frequency (1 time/month) → Revenue model = Usage-based billing
  │           └─ Low frequency (<1 time/month) → Revenue model = Project-based/One-time
  │
  ├─ Product form = Platform service?
  │     └─ Yes → Revenue model = Platform commission/revenue share
  │
  └─ Multi-sided market?
        ├─ Yes → Revenue model = Subscription + Platform commission
        └─ No → Select based on product form
```

**Step 3b: Multi-option Revenue Model Generation** [Conditional]

**Task**: Based on Step 3a decision tree results, generate at least 2 comparable revenue model options.

**Execution logic**:
1. Determine primary revenue model based on decision tree results
2. Generate at least 1 alternative revenue model (consider hybrid models)
3. Analyze strengths and risks of each model

**Output format**:
```json
{
  "revenue_models": [
    {
      "model_id": "rm-1",
      "type": "SaaS Subscription",
      "description": "Monthly/annual subscription with tiered pricing based on institution student count",
      "pricing_structure": {
        "base_price": "2980",
        "unit": "yuan/institution/month",
        "tiers": ["Basic: 50 or fewer students 2980 yuan/month", "Professional: 200 or fewer students 6980 yuan/month"]
      },
      "pros": ["Predictable revenue, stable cash flow", "Natural revenue growth as customer scale grows"],
      "cons": ["Higher initial acquisition cost", "Requires continuous product iteration investment"],
      "risk_level": "low/medium/high"
    },
    {
      "model_id": "rm-2",
      "type": "Usage-based + Subscription hybrid",
      "description": "Basic subscription + overage billing based on AI call volume",
      "pricing_structure": {...},
      "pros": [...],
      "cons": [...],
      "risk_level": "low/medium/high"
    }
  ]
}
```

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

**Output format**:
```json
{
  "cost_structure": {
    "fixed_costs": [
      {
        "item": "R&D team salaries",
        "estimated_monthly": "800000",
        "category": "Personnel/Infrastructure/Operations"
      }
    ],
    "variable_costs": [
      {
        "item": "AI computing call fees",
        "unit_cost": "0.5 yuan per inference call",
        "driver": "Active student count × per-capita AI interaction count"
      }
    ],
    "unit_economics": {
      "target_cac": "5000 yuan/institution",
      "target_ltv": "80000 yuan",
      "ltv_cac_ratio": "16:1"
    }
  }
}
```

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

**Output format**:
```json
{
  "channels": [
    {
      "channel_id": "ch-1",
      "name": "Education industry exhibitions and community operations",
      "type": "direct/indirect",
      "phase": "awareness/evaluation/purchase/delivery",
      "cost_efficiency": "high/medium/low",
      "priority": 1
    }
  ]
}
```

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

**Output format**:
```json
{
  "key_activities": [
    {
      "activity": "AI learning engine algorithm optimization",
      "type": "creation/delivery/platform",
      "priority": "high/medium/low"
    }
  ],
  "key_resources": [
    {
      "resource": "Adaptive learning algorithm engine",
      "type": "physical/intellectual/human/financial",
      "ownership": "self-built/outsourced/partnership"
    }
  ],
  "key_partners": [
    {
      "partner": "Vocational college content partner",
      "type": "supplier/strategic/joint_venture",
      "purpose": "Obtain authoritative course content licensing",
      "dependency": "Dependency level"
    }
  ]
}
```

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

**Output format**:
```json
{
  "customer_relationships": [
    {
      "segment_id": "segment-1",
      "relationship_type": "personal_assistance/dedicated_assistance/self_service/automated_service/community",
      "description": "Self-service + Customer Success Manager assistance",
      "touchpoints": ["Online help center and knowledge base", "Dedicated Customer Success Manager monthly check-in"]
    }
  ]
}
```

**Acceptance criteria**:
- Each customer segment has a corresponding relationship type
- Relationship type matches product characteristics
- Touchpoints clear

## Output

**Storage path**: `docs/strategy/business-strategy.md ("Business Model Canvas" section)`

**Output files**: bmc.json, assumptions.json

### Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| bmc.customer_segments | array | Yes | Customer segments list, at least 2 |
| bmc.customer_segments[].segment_name | string | Yes | Customer group name, cannot be empty |
| bmc.customer_segments[].characteristics | string[] | Yes | Group characteristics list, cannot be empty |
| bmc.value_propositions | array | Yes | Value propositions list, at least 1 |
| bmc.value_propositions[].proposition | string | Yes | Value proposition description, cannot be empty |
| bmc.value_propositions[].pain_addressed | string | Yes | Pain point addressed, cannot be empty |
| bmc.value_propositions[].gain_created | string | No | Gain created |
| bmc.channels | array | Yes | Covers all stages of customer journey |
| bmc.channels[].channel_name | string | Yes | Channel name, cannot be empty |
| bmc.channels[].type | string | Yes | Channel type, enum: direct/indirect/partner |
| bmc.channels[].phase | string | Yes | Channel phase, enum: awareness/evaluation/purchase/delivery/after_sales |
| bmc.customer_relationships | array | Yes | Each segment has a corresponding relationship type |
| bmc.customer_relationships[].type | string | Yes | Relationship type, enum: personal/automated/community/self_service |
| bmc.customer_relationships[].segment | string | Yes | Corresponding customer group, cannot be empty |
| bmc.revenue_streams | array | Yes | Revenue streams list, at least 1 |
| bmc.revenue_streams[].stream_name | string | Yes | Revenue stream name, cannot be empty |
| bmc.revenue_streams[].pricing_model | string | Yes | Pricing model, enum: subscription/transaction/freemium/advertising/licensing |
| bmc.revenue_streams[].estimated_amount | string | No | Estimated amount range |
| bmc.revenue_streams[].target_segment | string | No | Corresponding customer group |
| bmc.key_resources | array | Yes | Covers physical/intellectual/human/financial |
| bmc.key_resources[].resource | string | Yes | Core resource description, cannot be empty |
| bmc.key_resources[].type | string | Yes | Resource type, enum: physical/intellectual/human/financial |
| bmc.key_activities | array | Yes | Covers full value creation process |
| bmc.key_activities[].activity | string | Yes | Core activity description, cannot be empty |
| bmc.key_activities[].type | string | Yes | Activity type, enum: production/problem_solving/platform/network |
| bmc.key_partnerships | array | Yes | Includes suppliers/strategic alliances/joint venture partners |
| bmc.key_partnerships[].partner | string | Yes | Partner name, cannot be empty |
| bmc.key_partnerships[].type | string | Yes | Partnership type, enum: strategic_alliance/joint_venture/buyer_supplier |
| bmc.key_partnerships[].purpose | string | Yes | Partnership purpose, cannot be empty |
| bmc.cost_structure | array | Yes | Cost structure list, at least 1 |
| bmc.cost_structure[].cost_item | string | Yes | Cost item name, cannot be empty |
| bmc.cost_structure[].type | string | Yes | Cost type, enum: fixed/variable |
| bmc.cost_structure[].estimated_range | string | No | Estimated cost range |
| bmc.cost_structure[].category | string | No | Cost category, enum: infrastructure/marketing/operations/personnel |
| metadata.confidence | number | Yes | Between 0-1, overall confidence |
| metadata.requires_human_review | boolean | Yes | Whether human review is needed |
| assumptions[].assumption_id | string | Yes | Assumption unique identifier |
| assumptions[].description | string | Yes | Assumption description, cannot be empty |
| assumptions[].related_bmc_element | string | Yes | Related canvas element path |
| assumptions[].validation_method | string | No | Validation method |
| assumptions[].priority | string | Yes | critical/high/medium/low |
| assumptions[].confidence | number | Yes | Between 0-1, assumption confidence |

### Complete Business Canvas JSON

```json
{
  "bmc": {
    "customer_segments": [
      {
        "segment_name": "string - Customer group name",
        "description": "string - Group description",
        "characteristics": ["string - Group characteristics"]
      }
    ],
    "value_propositions": [
      {
        "proposition": "string - Value proposition",
        "target_segment": "string - Corresponding customer group",
        "pain_addressed": "string - Pain point addressed",
        "gain_created": "string - Gain created"
      }
    ],
    "channels": [
      {
        "channel_name": "string - Channel name",
        "type": "direct|indirect|partner",
        "phase": "awareness|evaluation|purchase|delivery|after_sales"
      }
    ],
    "customer_relationships": [
      {
        "type": "personal|automated|community|self_service",
        "segment": "string - Corresponding customer group",
        "description": "string - Relationship description"
      }
    ],
    "revenue_streams": [
      {
        "stream_name": "string - Revenue stream name",
        "pricing_model": "subscription|transaction|freemium|advertising|licensing",
        "estimated_amount": "string - Estimated amount range",
        "target_segment": "string - Corresponding customer group"
      }
    ],
    "key_resources": [
      {
        "resource": "string - Core resource",
        "type": "physical|intellectual|human|financial"
      }
    ],
    "key_activities": [
      {
        "activity": "string - Core activity",
        "type": "production|problem_solving|platform|network"
      }
    ],
    "key_partnerships": [
      {
        "partner": "string - Partner",
        "type": "strategic_alliance|joint_venture|buyer_supplier",
        "purpose": "string - Partnership purpose"
      }
    ],
    "cost_structure": [
      {
        "cost_item": "string - Cost item",
        "type": "fixed|variable",
        "estimated_range": "string - Estimated cost range",
        "category": "infrastructure|marketing|operations|personnel"
      }
    ]
  },
  "metadata": {
    "generated_at": "2026-06-15T10:30:00Z",
    "confidence": "0.78",
    "requires_human_review": true
  }
}
```

### Assumption List

```json
{
  "assumptions": [
    {
      "assumption_id": "string - Assumption ID",
      "description": "string - Assumption description",
      "related_bmc_element": "string - Related canvas element (e.g., customer_segments.0)",
      "validation_method": "string - Validation method",
      "priority": "critical|high|medium|low",
      "confidence": 0.0
    }
  ]
}
```

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

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| product_context missing | User provides product description and target users → generate BMC based on description | Customer segments and value propositions lack discovery stage data support, overall confidence drops from 0.8 to 0.5, related canvas blocks confidence ≤ 0.4, annotate needs_human_validation: true | Require user to provide product concept, target user persona, and core pain point description |
| market_data missing | User provides competitor and industry info → infer market size and competitor models based on description | Revenue model and cost structure lack market benchmark data, pricing reference missing, related canvas blocks confidence ≤ 0.4 | Require user to provide competitor business models, industry typical pricing, and market size data |
| product_context + market_data both missing | User provides product description and target users → generate BMC based on description | Each module's overall confidence drops from 0.8 to 0.5, more assumption items, related canvas blocks confidence ≤ 0.3, annotate auto_filled: true | Require user to provide product description, target user persona, competitor info, and industry pricing reference |
| All upstream files missing | Prompt user to execute prior stages first, or generate BMC directly based on user-provided product description and target users | Overall confidence drops from 0.8 to 0.3, most content is assumption inference, related canvas blocks confidence ≤ 0.3, annotate auto_filled: true | Require user to provide product concept, target users, value proposition, or upload persona.json/opportunity-definition.json files |

## Data Acquisition Notes

This Skill requires discovery stage output data (Persona, opportunity brief, etc.). Please provide via one of the following:
  1. Directly describe product concept, target users, and value proposition
  2. Upload persona.json / opportunity-definition.json and other files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

---

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| persona.json user persona update | Customer segments, customer relationships modules need re-population | Re-execute Step 1 and Step 7, annotate change source |
| opportunity-definition update | Value proposition, revenue model may need adjustment | Re-evaluate value proposition priority, check revenue model match |
| competitor-analysis competitor data update | Value proposition differentiation, revenue model pricing reference | Re-execute Step 2 and Step 3, update competitor benchmarking data |
| Market size data change | Revenue expectations and cost structure | Recalculate unit economics indicators, update market size assumptions |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Customer segment adjustment | business-value-fit, business-pricing | Output file version number + change summary |
| Value proposition change | business-value-fit, positioning-strategy | Output file version number + change summary |
| Revenue model change | business-pricing | Output file version number + change summary |
| Cost structure change | business-pricing, business-strategy-report | Output file version number + change summary |

---

## Human Review Checklist

Before submitting for human approval, ensure the following:

- [ ] Customer segments match actual market conditions
- [ ] Value proposition differentiation is clear and achievable
- [ ] Revenue model options each have clear pros/cons
- [ ] Cost structure matches operational plan
- [ ] Key assumptions are verifiable with a validation plan
