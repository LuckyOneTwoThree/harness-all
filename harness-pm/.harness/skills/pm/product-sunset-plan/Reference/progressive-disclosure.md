# product-sunset-plan — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

### Output Files

| File | Path | Description |
|------|------|------|
| Product sunset plan | `docs/monitoring/product-sunset-plan.md` | Human-readable complete plan |
| Structured data | `docs/monitoring/product-sunset-plan.md` | Machine-consumable structured data |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["product_name", "sunset_date", "decision_assessment", "migration_plan"],
  "properties": {
    "product_name": {"type": "string", "description": "Product name"},
    "sunset_date": {"type": "string", "description": "Sunset date"},
    "report_date": {"type": "string", "description": "Report date"},
    "decision_assessment": {"type": "object", "description": "Sunset decision assessment, including reasons, alternatives, and impact"},
    "migration_plan": {"type": "object", "description": "User migration plan, including alternatives, paths, and incentives"},
    "data_disposal": {"type": "object", "description": "Data disposal strategy, including classification, methods, and retention periods"},
    "timeline": {"type": "object", "description": "Sunset timeline, including announcement/transition/read-only/sunset/cleanup"},
    "communication_plan": {"type": "object", "description": "Communication plan, including user/internal/external communication"},
    "risks": {"type": "array", "description": "Risk list"}
  }
}
```

### Markdown Report Structure

```markdown
# Product Sunset Plan: Legacy Data Analytics Module

## 1. Sunset Decision Assessment
- Sunset reasons and validation
- Alternative solution assessment
- Impact scope assessment

## 2. User Migration Plan
- Alternative solutions
- Migration paths and tools
- Migration incentives
- Special user handling

## 3. Data Disposal Strategy
- Data classification
- Disposal methods
- Retention periods
- Deletion timeline

## 4. Sunset Timeline
- Announcement period (T-90)
- Transition period (T-60)
- Read-only period (T-30)
- Sunset day (T-0)
- Cleanup period (T+30)

## 5. Communication Plan
- User communication (announcement/FAQ/tutorial)
- Internal communication (team/customer service/sales)
- External communication (partners/media/community)

## 6. Risks and Contingency
- Migration failure contingency
- Legal compliance risks
- Brand reputation risks
```

### JSON Structure

```json
{
  "product_name": "",
  "sunset_date": "",
  "report_date": "",
  "decision_assessment": {
    "reasons": [],
    "alternatives_evaluated": [],
    "impact": {
      "affected_users": 0,
      "affected_revenue": 0,
      "brand_impact": ""
    }
  },
  "migration_plan": {
    "alternatives": [],
    "migration_paths": [],
    "incentives": [],
    "special_handling": []
  },
  "data_disposal": {
    "categories": [],
    "disposal_methods": [],
    "retention_periods": [],
    "deletion_timeline": ""
  },
  "timeline": {
    "announcement": "",
    "transition": "",
    "read_only": "",
    "sunset": "",
    "cleanup": ""
  },
  "communication_plan": {
    "user_communication": [],
    "internal_communication": [],
    "external_communication": []
  },
  "risks": []
}
```
