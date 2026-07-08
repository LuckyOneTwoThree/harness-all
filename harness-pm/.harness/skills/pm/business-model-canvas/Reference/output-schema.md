# Business Model Canvas - Schema 定义

本文档收录 Business Model Canvas Skill 的输出字段验证规则与完整 JSON Schema 定义。

## Output Validation Rules

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

## Complete Business Canvas JSON

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

## Assumption List JSON

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
