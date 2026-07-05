---
name: growth-strategy-report
description: Use when you need to consolidate growth model diagnosis and stage optimization plans into a complete, deliverable growth strategy report. Growth Strategy Report auto-generation includes growth model evaluation, AARRR funnel diagnosis, leverage strategies, flywheel model, and execution roadmap. This report is a user-facing deliverable strategy document that integrates outputs from each growth sub-Skill to generate a complete growth strategy.
---
# Growth Strategy Report Generation

## When to use
- Help me produce a growth strategy report
- What to do when growth hits a bottleneck
- How to formulate a growth plan
- Keywords: growth strategy report, growth report, AARRR report, growth flywheel, growth roadmap, growth bottleneck, how to grow, growth plan

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/growth/growth-strategy.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/growth/growth-strategy.md

## Core Principles

**The growth strategy report is an action blueprint, not a data dashboard**

The core value of the growth strategy report lies in consolidating scattered growth diagnoses and stage optimization plans into an executable growth blueprint. The report answers not "what the data is" but "where we should invest, how much, and what return to expect".

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Growth model diagnosis | markdown | Yes | docs/growth/growth-strategy.md ("Growth Model" section) | Growth model, flywheel model, bottleneck stage |
| Acquisition plan | markdown | No | docs/growth/growth-strategy.md ("Acquisition Analysis" section) | Channel evaluation, funnel optimization |
| Activation plan | markdown | No | docs/growth/growth-strategy.md ("Onboarding" section) | Aha Moment, Onboarding optimization |
| Retention plan | markdown | No | docs/growth/growth-strategy.md ("Retention Management" section) | Churn prediction, segmented operations |
| Monetization plan | markdown | No | docs/growth/growth-strategy.md ("Revenue Funnel" section) | Payment funnel, NRR, upsell |
| Business goals | text | No | User-provided | North Star metric, growth targets, budget constraints |

## Execution Steps

> **Assembly-only mode**: This skill is an assembly skill. Steps 1-2 perform synthesis from already-produced upstream artifacts (growth-model + acquisition-analysis + activation-* + retention-management + revenue-*), NOT re-diagnosis. The upstream skills own the analysis; this skill synthesizes them into a coherent growth strategy narrative.

### Step 1: Assembly + Growth Model Synthesis [Core]

**Assembly** (read-only, no re-diagnosis):
- Read Growth Model from `docs/growth/growth-strategy.md` ("Growth Model" section)
- Read Acquisition plan from `docs/growth/growth-strategy.md` ("Acquisition Analysis" section)
- Read Activation plan from `docs/growth/growth-strategy.md` ("Aha Moment" + "Onboarding" sections)
- Read Retention plan from `docs/growth/growth-strategy.md` ("Retention Management" section)
- Read Revenue plan from `docs/growth/growth-strategy.md` ("Revenue Funnel" + "NRR Analysis" + "Upsell" sections)

**Synthesis** (new analysis, not re-derivation):
1. **Growth model identification**: Distill from assembled growth-model diagnosis (PLG / SLG / MLG / Hybrid)
2. **Flywheel model construction**: Synthesize from assembled data (nodes, causal relationships, current rotation status)
3. **Bottleneck localization**: Distill from assembled growth-model output
4. **Growth stage assessment**: Cold start / takeoff / scale / mature

### Step 2: AARRR Funnel Synthesis [Core]

**Synthesis** (integrate assembled stage plans, not re-analyze):
1. **Acquisition funnel**: Synthesize from assembled acquisition plan (conversion rates vs. industry benchmarks)
2. **Activation funnel**: Synthesize from assembled activation plan (Aha Moment + time decay)
3. **Retention curve**: Synthesize from assembled retention plan (D1/D7/D30 + shape analysis)
4. **Monetization funnel**: Synthesize from assembled revenue plan (ARPU contribution breakdown)

### Step 3: Leverage Strategy Integration [Core]

Based on bottleneck localization and stage plans, integrate leverage strategies:

1. **High-leverage strategies** (highest ROI): Top 3 strategies + expected impact + required resources
2. **Medium-leverage strategies** (steady growth): Supplementary strategies + expected impact
3. **Defensive strategies** (prevent decline): Risk mitigation + early warning metrics
4. **Strategy priority matrix**: Sorted by impact × feasibility

### Step 4: Execution Roadmap [Core]

Translate strategies into an executable roadmap:

1. **Quick Wins** (0-2 weeks): Low-investment, high-return immediate actions
2. **Core optimization** (2-8 weeks): Systematic optimization of key levers
3. **Long-term investment** (8 weeks+): Infrastructure buildout for flywheel acceleration
4. **Milestones and metrics**: Key milestones and acceptance metrics for each phase

### Step 5: Report Assembly [Core]

Assemble the above content into a complete report.

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Growth strategy and priority actions | Core conclusions + minimum viable artifact |
| standard | Complete artifact (current default) | Complete artifact, including all Step outputs |
| deep | Complete report + growth model inference + channel mix optimization + growth experiment roadmap | Complete artifact + extended analysis + deep inference |

## Output

### Output Files

| File | Path | Description |
|------|------|------|
| Growth strategy report | `docs/growth/growth-strategy.md (aggregate overwrite)` | Human-readable complete report |
| Structured data | `docs/growth/growth-strategy.md (aggregate overwrite)` | Machine-consumable structured data |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["product_name", "growth_model", "leverage_strategies", "roadmap"],
  "properties": {
    "product_name": {"type": "string", "description": "Product name"},
    "report_date": {"type": "string", "description": "Report date"},
    "growth_model": {"type": "object", "description": "Growth model evaluation, including type, flywheel model, and bottleneck"},
    "aarrr_funnel": {"type": "object", "description": "AARRR funnel diagnosis, including acquisition/activation/retention/monetization"},
    "leverage_strategies": {"type": "object", "description": "Leverage strategies, including high/medium/defensive strategies"},
    "roadmap": {"type": "object", "description": "Execution roadmap, including Quick Wins/core optimization/long-term investment"},
    "risks_and_assumptions": {"type": "array", "description": "List of risks and assumptions"}
  }
}
```

### Markdown Report Structure

```markdown
# Growth Strategy Report: {Product Name}

## 1. Executive Summary
- Growth model / current stage / core bottleneck / Top 3 actions

## 2. Growth Model Evaluation
- Growth model identification and rationale
- Flywheel model (nodes + causal relationships)
- Bottleneck localization and quantification

## 3. AARRR Funnel Diagnosis
- Acquisition funnel (conversion rates + industry benchmarks)
- Activation funnel (Aha Moment + time decay)
- Retention curve (D1/D7/D30 + shape analysis)
- Monetization funnel (ARPU contribution breakdown)

## 4. Leverage Strategies
- High-leverage strategies Top 3 (impact × feasibility matrix)
- Medium-leverage strategies
- Defensive strategies
- Strategy priority ranking

## 5. Execution Roadmap
- Quick Wins (0-2 weeks)
- Core optimization (2-8 weeks)
- Long-term investment (8 weeks+)
- Milestones and acceptance metrics

## 6. Risks and Assumptions
- Key assumptions list
- Risk mitigation measures
- Monitoring metrics and alert thresholds
```

### JSON Structure

```json
{
  "product_name": "",
  "report_date": "",
  "growth_model": {
    "type": "PLG|SLG|MLG|hybrid",
    "evidence": "",
    "flywheel": {
      "nodes": [],
      "causal_links": [],
      "current_status": ""
    },
    "bottleneck": "",
    "stage": "cold_start|takeoff|scale|mature"
  },
  "aarrr_funnel": {
    "acquisition": {},
    "activation": {},
    "retention": {},
    "revenue": {}
  },
  "leverage_strategies": {
    "high": [],
    "medium": [],
    "defensive": []
  },
  "roadmap": {
    "quick_wins": [],
    "core_optimization": [],
    "long_term": []
  },
  "risks_and_assumptions": []
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| product_name | string | Yes | Product name, cannot be empty |
| growth_model | object | Yes | Growth model evaluation, must contain type/flywheel/bottleneck |
| growth_model.type | string | Yes | Growth model type, only PLG/SLG/MLG/hybrid allowed |
| growth_model.evidence | string | No | Model determination rationale |
| growth_model.flywheel.nodes | array | Yes | Flywheel nodes, at least 3 |
| growth_model.flywheel.nodes[].node_name | string | Yes | Node name, cannot be empty |
| growth_model.flywheel.edges | array | No | Flywheel causal relationships, at least 2 |
| growth_model.flywheel.edges[].from | string | Yes | Source node |
| growth_model.flywheel.edges[].to | string | Yes | Target node |
| growth_model.flywheel.edges[].description | string | No | Causal relationship description |
| growth_model.bottleneck | string | Yes | Bottleneck description, cannot be empty |
| aarrr_funnel | object | No | AARRR funnel data |
| aarrr_funnel.acquisition | object | No | Acquisition stage |
| aarrr_funnel.acquisition.current_rate | number | No | Current acquisition rate |
| aarrr_funnel.activation | object | No | Activation stage |
| aarrr_funnel.activation.current_rate | number | No | Current activation rate |
| aarrr_funnel.retention | object | No | Retention stage |
| aarrr_funnel.retention.current_rate | number | No | Current retention rate |
| aarrr_funnel.referral | object | No | Referral stage |
| aarrr_funnel.referral.current_rate | number | No | Current referral rate |
| aarrr_funnel.revenue | object | No | Revenue stage |
| aarrr_funnel.revenue.current_rate | number | No | Current paid conversion rate |
| leverage_strategies | object | Yes | Leverage strategies, must contain high/medium/defensive |
| leverage_strategies.high | array | Yes | High-leverage strategies, at least 1 |
| leverage_strategies.high[].strategy | string | Yes | Strategy description, cannot be empty |
| leverage_strategies.high[].expected_impact | string | No | Expected impact |
| leverage_strategies.medium | array | Yes | Medium-leverage strategies, at least 1 |
| leverage_strategies.medium[].strategy | string | Yes | Strategy description, cannot be empty |
| leverage_strategies.defensive | array | No | Defensive strategies |
| leverage_strategies.defensive[].strategy | string | Yes | Strategy description, cannot be empty |
| roadmap | object | Yes | Execution roadmap, must contain quick_wins/core_optimization/long_term |
| roadmap.quick_wins | array | Yes | Quick win items, at least 1 |
| roadmap.quick_wins[].action | string | Yes | Action description |
| roadmap.quick_wins[].timeline | string | No | Timeline |
| roadmap.core_optimization | array | Yes | Core optimization items, at least 1 |
| roadmap.core_optimization[].action | string | Yes | Action description |
| roadmap.core_optimization[].timeline | string | No | Timeline |
| roadmap.long_term | array | No | Long-term investment items |
| roadmap.long_term[].action | string | Yes | Action description |
| roadmap.long_term[].timeline | string | No | Timeline |
| risks_and_assumptions | array | No | List of risks and assumptions |
| risks_and_assumptions[].type | string | Yes | Type, enum: risk/assumption |
| risks_and_assumptions[].description | string | Yes | Description, cannot be empty |
| risks_and_assumptions[].impact | string | No | Impact assessment |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] Flywheel model completeness (at least 3 nodes + 2 causal relationships)
- [ ] Strategy aligned with bottleneck (high-leverage strategies directly target core bottleneck)

### P1 Checks (standard/deep must pass)

- [ ] Roadmap executable (each action has owner, timeline, acceptance metrics)
- [ ] Funnel data complete (at least 3 of AARRR stages have data)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Decision Rules

- When the growth bottleneck is the acquisition stage, prioritize allocating resources to acquisition strategies
- When the flywheel model is not yet validated, mark strategy recommendations as "pending flywheel validation" to avoid over-investment
- When Quick Wins conflict with long-term investment, prioritize Quick Wins but preserve the long-term investment path
- Decision points requiring human confirmation: growth model determination, core bottleneck confirmation, resource allocation ratio, roadmap priority

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| No growth model diagnosis | Reverse-engineer growth model from stage plans, mark "model to be confirmed" | Growth model is an inferred conclusion, needs subsequent validation | Require user to provide growth model description or execute growth-model skill |
| Only partial stage plans | Cover only stages with available data, mark missing stages as "to be supplemented" | Report coverage incomplete, no strategy recommendations for missing stages | Require user to provide strategy summaries for missing stages or execute corresponding prior skills |
| No upstream input at all | Generate growth strategy framework based on user-provided product info, mark "needs data validation" | Report is framework-level, all conclusions need data validation | Require user to provide product info, growth goals, and core metrics |
| Business goals missing | Prompt user to provide business goals, otherwise cannot determine strategy focus direction | Strategy lacks goal orientation | Require user to provide business goals (e.g., increase DAU, improve paid conversion rate) |

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| growth-model | Growth model or bottleneck change | Growth model evaluation and leverage strategies | Re-evaluate model, adjust strategy priorities |
| acquisition-* / activation-* / retention-* / revenue-* | Optimization plan updates | AARRR funnel diagnosis and strategy integration | Update corresponding funnel stage data and strategies |
| User-provided - Business goals | Goal or budget changes | Leverage strategies and execution roadmap | Re-rank strategy priorities, adjust roadmap |

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| growth-orchestrator | Report generation completed | Output file update | Report completion status and key conclusions |
| User-provided | Report generation completed | Output file | Complete growth strategy report |
