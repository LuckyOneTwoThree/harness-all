# Business Model Canvas - 示例集

本文档收录 Business Model Canvas Skill 各步骤的输入与输出 JSON 示例。

## Inputs 示例

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

## Step 1: Customer Segments Output 示例

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

## Step 2: Value Propositions Output 示例

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

## Step 3b: Revenue Models Output 示例

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

## Step 4: Cost Structure Output 示例

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

## Step 5: Channels Output 示例

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

## Step 6: Key Activities/Resources/Partners Output 示例

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

## Step 7: Customer Relationships Output 示例

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
