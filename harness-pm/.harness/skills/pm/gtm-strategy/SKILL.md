---
name: gtm-strategy
description: Used when developing a product go-to-market strategy. Auto-generates a Go-to-Market strategy document, including target market definition, launch path selection, pricing & packaging strategy, channel & promotion plan, launch milestones and success metrics.
---
# Go-to-Market Strategy Document Generation

## When to use
- New product is about to launch, how to promote it
- Help me make a launch plan
- How to do product release strategy
- Keywords: Go-to-Market, GTM strategy, launch strategy, product launch, market entry, release strategy, product rollout, how to go to market, launch plan

## Inputs
- rules/security.md
- loops/LOOP.md

## Outputs
- docs/growth/gtm.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

**GTM is the first formal date between product and market**

The core of a Go-to-Market strategy is not "how to push the product out", but "how to let the right users discover product value in the right scenario". A good GTM strategy is a precise match between product value proposition and market demand.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Product Positioning | markdown | Yes | positioning-strategy | Positioning statement, differentiation advantages |
| Differentiation Strategy | markdown | No | positioning-strategy | Competitive differentiation positioning |
| Business Model | markdown | No | business-model-canvas | Value proposition, customer segments, revenue streams |
| Pricing Plan | markdown | No | business-pricing | Pricing model, price tiers |
| Growth Model | markdown | No | growth-model | Growth model diagnosis, acquisition strategy |
| Product Information | text | Yes | User input | Product features, target users, launch timeline |

## Execution Steps

### Step 1: Target Market Definition [Core]

Precisely define the launch target market:

1. **Ideal Customer Profile (ICP)**: Industry, size, role, pain points, purchasing power
2. **Market entry sequence**: Lighthouse customers → early adopters → early majority entry path
3. **TAM/SAM/SOM**: Market size estimation, focus on reachable SOM
4. **Market timing**: Why now? Market trends, policy windows, competitive gaps

### Step 2: Launch Path Selection [Core]

Select launch path based on product type and target market:

1. **Launch mode assessment**:
   - 🚀 Big Bang launch (suitable for B2C consumer products)
   - 🎯 Invite-only (suitable for B2B enterprise products)
   - 🔄 Progressive release (suitable for platform products)
   - 🏖️ Soft launch (suitable for products needing market validation)
2. **Path recommendation**: Recommend optimal path based on product characteristics with rationale
3. **Phase division**: Pre-launch → Launch → Growth phase goals

### Step 3: Pricing & Packaging Strategy [Conditional]

Determine how the product is packaged and priced:

1. **Product packaging**: Free / Pro / Enterprise tier feature boundaries
2. **Pricing model**: Subscription / Usage-based / One-time purchase / Hybrid model
3. **Launch pricing**: Launch price, early bird price, annual discount and other promotional strategies
4. **Value anchoring**: Compare with competitor pricing, highlight cost-effectiveness advantages

### Step 4: Channel & Promotion Plan [Conditional]

Design a full-funnel channel strategy from reach to conversion:

1. **Owned channels**: Official website, blog, community, email, in-product guidance
2. **Paid channels**: Search ads, social ads, content marketing, KOL partnerships
3. **Ecosystem channels**: Partners, app marketplaces, integration platforms, distributors
4. **Channel budget allocation**: Budget ratio and expected ROI for each channel
5. **Content calendar**: Content publishing plan for 4 weeks before and after launch

### Step 5: Launch Milestones & Success Metrics [Core]

Define metrics for launch success:

1. **Launch milestones**: Key time nodes and deliverables
2. **Success metrics**:
   - Launch week 1: Registrations, activation rate, NPS
   - Launch month 1: Retention rate, paid conversion rate, CAC
   - Launch quarter 1: LTV, LTV/CAC, market share
3. **Warning metrics**: Adjustment mechanisms triggered when below expectations
4. **Go/No-Go checklist**: Final checks before launch

### Step 6: Report Assembly [Core]

Assemble the above content into a complete GTM strategy document.

### Output Depth Classification

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Target market definition and launch path | Core conclusions + minimum viable artifact |
| standard | Complete artifact (current default) | Complete artifact, including all Step outputs |
| deep | Complete GTM strategy + channel ROI simulation + launch risk contingency + competitor response strategy | Complete artifact + extended analysis + deep simulation |

## Output

### Output Files

| File | Path | Description |
|------|------|------|
| GTM Strategy Document | `docs/growth/gtm.md` | Human-readable complete strategy document |
| Structured Data | `output/metrics/gtm-strategy.json` | Machine-consumable structured data |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["product_name", "target_market", "launch_path", "success_metrics"],
  "properties": {
    "product_name": {"type": "string", "description": "Product name"},
    "report_date": {"type": "string", "description": "Report date"},
    "target_market": {"type": "object", "description": "Target market definition, including ICP, entry sequence, and market size"},
    "launch_path": {"type": "object", "description": "Launch path, including mode, rationale, and phases"},
    "pricing_packaging": {"type": "object", "description": "Pricing & packaging strategy, including tiers, model, and promotions"},
    "channels": {"type": "object", "description": "Channel & promotion plan, including owned/paid/ecosystem channels"},
    "success_metrics": {"type": "object", "description": "Success metrics & milestones, including week 1/month 1/quarter 1 metrics"},
    "risks": {"type": "array", "description": "Risk list"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| product_name | string | Yes | Product name, cannot be empty |
| target_market | object | Yes | Target market, must include icp/market_size |
| target_market.icp | object | Yes | ICP profile, must include at least 3 dimensions: industry/size/role |
| target_market.icp.industry | string | Yes | Target industry, cannot be empty |
| target_market.icp.company_size | string | Yes | Company size, cannot be empty |
| target_market.icp.target_role | string | Yes | Target role, cannot be empty |
| target_market.icp.pain_points | string[] | No | ICP core pain points |
| target_market.market_size | object | Yes | Market size |
| target_market.market_size.tam | string | No | Total Addressable Market |
| target_market.market_size.sam | string | No | Serviceable Available Market |
| target_market.market_size.som | string | No | Serviceable Obtainable Market |
| launch_path | object | Yes | Launch path, must include mode/rationale/phases |
| launch_path.mode | string | Yes | Launch mode, only allows big_bang/invite_only/progressive/soft_launch |
| launch_path.rationale | string | Yes | Mode selection rationale, cannot be empty |
| launch_path.phases | array | Yes | Launch phase list, at least 1 phase |
| launch_path.phases[].phase_name | string | Yes | Phase name, cannot be empty |
| launch_path.phases[].timeline | string | No | Phase timeline |
| launch_path.phases[].key_activities | string[] | No | Key activities list |
| success_metrics | object | Yes | Success metrics, must include week_1/month_1/quarter_1 |
| success_metrics.week_1 | object | Yes | Week 1 metrics |
| success_metrics.week_1.target_users | number | No | Target user count |
| success_metrics.week_1.activation_rate | number | No | Activation rate |
| success_metrics.month_1 | object | Yes | Month 1 metrics |
| success_metrics.month_1.retention_rate | number | No | Retention rate |
| success_metrics.month_1.revenue | number | No | Revenue target |
| success_metrics.quarter_1 | object | Yes | Quarter 1 metrics |
| success_metrics.quarter_1.market_share | string | No | Market share target |
| success_metrics.quarter_1.nps | number | No | NPS target |
| channels | object | No | Channel plan, must include owned/paid/ecosystem |
| channels.owned | array | No | Owned channels list |
| channels.owned[].channel_name | string | Yes | Channel name |
| channels.owned[].budget_ratio | number | No | Budget ratio |
| channels.paid | array | No | Paid channels list |
| channels.paid[].channel_name | string | Yes | Channel name |
| channels.paid[].budget_ratio | number | No | Budget ratio |
| channels.paid[].expected_roi | number | No | Expected ROI |
| channels.ecosystem | array | No | Ecosystem channels list |
| channels.ecosystem[].channel_name | string | Yes | Channel name |
| channels.ecosystem[].partner_type | string | No | Partner type |
| risks | array | No | Risk list |
| risks[].risk | string | Yes | Risk description |
| risks[].probability | string | No | Probability, enum: high/medium/low |
| risks[].impact | string | No | Impact level, enum: high/medium/low |
| risks[].mitigation | string | No | Mitigation measures |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] ICP profile is specific (includes at least 3 dimensions: industry, size, role)
- [ ] Launch path is evidence-based (path selection based on product type and target market characteristics)

### P1 Checks (must pass for standard/deep)

- [ ] Channel budget is executable (each channel has budget ratio and expected ROI)
- [ ] Success metrics are quantifiable (week 1/month 1/quarter 1 metrics all have specific values)

### P2 Checks (must pass for deep only)

- [ ] Extended analysis complete (deep simulation and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Decision Rules

- When product is B2B enterprise, default to invite-only launch path
- When product is B2C consumer, default to Big Bang launch or progressive release
- When pricing plan is not determined, generate framework for pricing section in GTM strategy, mark specific prices as "pending pricing analysis"
- Decision points requiring human confirmation: launch path selection, pricing tier division, channel budget allocation, Go/No-Go decision

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|----------|----------|----------|------------|
| No product positioning | Infer positioning based on user-provided product info, mark "positioning pending confirmation" | Product positioning is an inferred conclusion, needs subsequent validation | Request user to provide product positioning description or upload positioning-strategy output file |
| No business model | Focus on acquisition and channel strategy, mark business model section as "to be supplemented" | Pricing & packaging strategy lacks business model support | Request user to provide business model description or upload bmc.json file |
| No pricing plan | Generate pricing strategy framework, mark specific prices as "pending pricing analysis" | Pricing recommendations are framework-level, no specific prices | Request user to provide pricing plan or upload business-pricing output file |
| No growth model | Default to PLG model, mark "growth model pending diagnosis" | Launch path and channel strategy based on PLG assumption | Request user to provide growth model description or upload growth-model output file |
| Product information missing | Prompt user to provide product info, otherwise cannot determine launch strategy | Launch strategy lacks product foundation | Request user to provide product name, core features, and target user description |

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| positioning-strategy | Positioning change | Target market definition and differentiation strategy | Redefine ICP and market entry sequence |
| business-pricing | Pricing change | Pricing & packaging strategy | Update pricing tiers and promotional strategy |
| growth-model | Growth model change | Channel strategy and launch path | Adjust channel budget allocation and launch mode |
| User-provided - Product info | Launch timeline change | Launch milestones and content calendar | Adjust phase division and timeline |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| growth-orchestrator | GTM strategy generation complete | Output file update | GTM strategy completion status and key conclusions |
| product-operations-manual | GTM strategy change | Write to output file | Launch milestones and channel plan |
