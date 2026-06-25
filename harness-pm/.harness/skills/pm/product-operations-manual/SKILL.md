---
name: product-operations-manual
description: Used when consolidating operations strategies and processes into a complete, deliverable product operations manual. Auto-generates product operations manuals including daily operations SOP, content operations standards, user operations strategy, activity operations templates, and emergency response procedures. Keywords: operations manual, operations SOP, content operations, user operations, activity operations, emergency response, operations process, daily operations, operations standards.
---
# Product Operations Manual Generation

## When to use
- How to write an operations manual
- How to standardize daily operations processes
- Help me organize operations SOP

## Inputs
- rules/security.md
- loops/LOOP.md

## Outputs
- docs/growth/operations-manual.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principle

**The operations manual is the team's muscle memory, not a document shelved away**

The core value of a product operations manual lies in enabling the team to correctly execute daily operations without guidance. The manual is not a document that ends once written, but a living document that is continuously updated, serving as the minimum consensus for team collaboration.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Growth model | markdown | No | growth-model | Growth model, flywheel model, bottleneck stages |
| Activation strategy | markdown | No | activation-onboarding | Onboarding process, activation strategy |
| Retention strategy | markdown | No | retention-management | Tiered operations, re-engagement strategy |
| Monetization strategy | markdown | No | revenue-funnel | Payment funnel, pricing strategy |
| Product information | text | Yes | User input | Product features, operations goals, team structure |

## Execution Steps

### Step 1: Daily Operations SOP [Core]

Define standard operating procedures for daily product operations:

1. **Daily operations checklist**:
   - Core metrics dashboard check (DAU/Revenue/Conversion rate)
   - Anomaly alert confirmation and handling
   - User feedback channel patrol
   - Content publishing schedule confirmation
2. **Weekly operations rhythm**:
   - Monday: Last week's data retrospective + This week's goal setting
   - Wednesday: Mid-week check + Strategy fine-tuning
   - Friday: Weekly report output + Next week's scheduling
3. **Monthly operations rhythm**:
   - Monthly OKR review and calibration
   - Operations activity effectiveness evaluation
   - Next month's operations plan formulation

### Step 2: Content Operations Standards [Conditional]

Define standards and processes for content operations:

1. **Content type matrix**: Product updates, user stories, industry insights, tutorial guides, activity announcements
2. **Content production process**: Topic selection → Writing → Review → Publishing → Promotion → Retrospective
3. **Content quality standards**: Title conventions, word count range, image requirements, SEO optimization
4. **Content distribution channels**: Official website, official account, community, email, push notifications, social media
5. **Content calendar template**: Weekly/monthly content scheduling template

### Step 3: User Operations Strategy [Core]

Define tiered strategies and execution methods for user operations:

1. **User segmentation model**: User segmentation based on RFM or lifecycle
2. **Tiered operations strategy**:
   - New users: Onboarding guidance + First value experience
   - Active users: Deep usage + Community participation
   - Silent users: Re-engagement strategy + Value rediscovery
   - Churned users: Churn warning + Win-back plan
3. **Outreach strategy**: Push, email, SMS, in-app message outreach frequency and content standards
4. **User feedback handling**: Feedback collection → Classification → Response → Closed-loop SLA

### Step 4: Activity Operations Templates [Conditional]

Define standard templates and processes for activity operations:

1. **Activity types**: User acquisition activities, engagement activities, payment conversion, brand communication
2. **Activity planning template**: Goal → Audience → Mechanics → Budget → Schedule → Risk
3. **Activity execution checklist**: Pre-launch/during/post-launch check items
4. **Activity retrospective template**: Data review → Effectiveness evaluation → Experience consolidation → Improvement suggestions
5. **Activity budget template**: Expense breakdown, ROI estimation, approval process

### Step 5: Emergency Response Procedures [Core]

Define emergency response procedures for operations anomalies:

1. **Severity grading**: P0 (Service unavailable) → P1 (Core functionality impaired) → P2 (Experience degradation) → P3 (Minor impact)
2. **Response SLA**: P0 5-minute response, P1 15-minute response, P2 1-hour response, P3 4-hour response
3. **Escalation path**: Operations → Product → Engineering → Management escalation conditions
4. **Emergency communication templates**: User announcements, internal notifications, post-incident summaries
5. **Common emergency scenarios**: Server failures, data anomalies, negative public opinion, security incidents

### Step 6: Report Assembly [Core]

Assemble the above content into a complete operations manual.

## Output

**Storage path**: `docs/growth/operations-manual.md`

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Operations SOP + Emergency response procedures | Core conclusions + minimum viable artifact, only outputs Step 1 and Step 5 |
| standard | Full operations manual (current default) | Full artifact, including all Step 1-6 outputs |
| deep | Full manual + extended analysis | Full artifact + operations strategy deep analysis + scenario-based SOP + operations metrics system design |

### Output Files

| File | Path | Description |
|------|------|------|
| Product operations manual | `docs/growth/operations-manual.md` | Human-readable complete manual |
| Structured data | `docs/growth/operations-manual.md` | Machine-consumable structured data |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["product_name", "daily_sop", "user_operations", "emergency_response"],
  "properties": {
    "product_name": {"type": "string", "description": "Product name"},
    "report_date": {"type": "string", "description": "Report date"},
    "daily_sop": {"type": "object", "description": "Daily operations SOP, including daily/weekly/monthly checklists"},
    "content_operations": {"type": "object", "description": "Content operations standards, including type matrix, production process, and quality standards"},
    "user_operations": {"type": "object", "description": "User operations strategy, including segmentation model and outreach strategy"},
    "activity_operations": {"type": "object", "description": "Activity operations templates, including planning and retrospective templates"},
    "emergency_response": {"type": "object", "description": "Emergency response procedures, including severity grading and SLA"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| product_name | string | Yes | Product name, cannot be empty |
| daily_sop | object | Yes | Daily operations SOP, must contain daily_checklist/weekly_rhythm/monthly_rhythm |
| daily_sop.daily_checklist | array | Yes | Daily checklist, at least 3 items |
| daily_sop.weekly_rhythm | array | No | Weekly rhythm check items |
| daily_sop.weekly_rhythm[].task | string | Yes | Task description |
| daily_sop.weekly_rhythm[].day | string | No | Execution day |
| daily_sop.monthly_rhythm | array | No | Monthly rhythm check items |
| daily_sop.monthly_rhythm[].task | string | Yes | Task description |
| daily_sop.monthly_rhythm[].deadline | string | No | Deadline |
| user_operations | object | Yes | User operations strategy, must contain segmentation_model/segment_strategies |
| user_operations.segmentation_model | object | Yes | Segmentation model |
| user_operations.segmentation_model.dimensions | string[] | No | Segmentation dimensions |
| user_operations.segmentation_model.method | string | No | Segmentation method |
| user_operations.segment_strategies | array | Yes | Tiered strategies, must cover at least new/active/silent/churned 4 types |
| user_operations.segment_strategies[].segment | string | Yes | Segment name |
| user_operations.segment_strategies[].strategy | string | Yes | Strategy description |
| emergency_response | object | Yes | Emergency response, must contain severity_levels/response_sla |
| emergency_response.severity_levels | array | Yes | Severity grading, must cover at least P0-P3 |
| emergency_response.response_sla | object | Yes | Response SLA |
| emergency_response.response_sla.P0 | string | No | P0 response time |
| emergency_response.response_sla.P1 | string | No | P1 response time |
| emergency_response.response_sla.P2 | string | No | P2 response time |
| emergency_response.response_sla.P3 | string | No | P3 response time |
| content_operations | object | No | Content operations standards |
| activity_operations | object | No | Activity operations templates |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] SOP executable (each SOP item has specific actions and time nodes)
- [ ] Emergency procedures operable (P0-P3 all have response SLA and escalation path)

### P1 Checks (must pass for standard/deep)

- [ ] Tiered strategy complete (must cover at least new/active/silent/churned 4 user types)
- [ ] Templates directly usable (activity templates have placeholders and fill-in instructions)

### P2 Checks (only deep must pass)

- [ ] Operations strategy deep analysis complete (each strategy has ROI evaluation and effectiveness forecast)
- [ ] Scenario-based SOP generated (key scenarios have detailed operation steps and decision trees)
- [ ] Operations metrics system designed (core operations metrics have definitions, collection plans, and alert thresholds)

## Decision Rules

- When growth model is PLG, user operations strategy focuses on self-service activation and viral spread
- When growth model is SLG, operations SOP focuses on sales support and customer success
- When emergency incident is P0 level, automatically trigger escalation path to engineering team
- Decision points requiring human confirmation: operations rhythm setting, user segmentation standards, outreach frequency caps, emergency escalation thresholds

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|----------|----------|----------|------------|
| No growth model | Manual focuses on general operations SOP, growth strategy section labeled "pending growth model diagnosis" | Operations SOP lacks growth model orientation | Require user to provide product growth approach (PLG/SLG/hybrid) and core growth metrics |
| No activation strategy | New user operations strategy uses general Onboarding template, labeled "pending activation strategy customization" | New user guidance SOP is general template, lacks product specificity | Require user to provide new user guidance process and first value experience path |
| No retention strategy | User segmentation uses general RFM model, outreach strategy uses industry default frequency, labeled "pending retention strategy customization" | Tiered operations strategy based on general assumptions, outreach frequency may not match | Require user to provide user segmentation standards and re-engagement strategy |
| No monetization strategy | Payment conversion operations SOP uses general funnel template, labeled "pending monetization strategy customization" | Payment operations process is general template, lacks pricing and funnel data support | Require user to provide payment funnel data and pricing plan |
| No strategy for any stage | Manual provides standard templates and best practices, labeled "pending strategy customization" | Operations strategy is general template, non-customized | Require user to provide core strategy summary for each stage or execute prerequisite skills |
| No product information | Cannot generate, require user to provide basic information | No output | Require user to provide product features, operations goals, and team structure |

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| growth-model | Growth model change | Operations SOP and user operations strategy | Adjust operations rhythm and tiered strategy |
| activation-onboarding | Onboarding process change | New user operations strategy | Update new user guidance SOP |
| retention-management | Tiered strategy change | User operations strategy | Update segmentation model and outreach strategy |
| revenue-funnel | Payment funnel change | Monetization operations strategy | Update payment conversion operations SOP |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| growth-orchestrator | Operations manual generation completed | Output file updated | Manual completion status and key conclusions |
| User provided | Operations manual generation completed | Output file | Complete product operations manual |
