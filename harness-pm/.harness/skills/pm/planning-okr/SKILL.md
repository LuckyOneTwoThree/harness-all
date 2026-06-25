---
name: planning-okr
description: Use when you need to set quarterly/annual OKRs, decompose objectives, or define performance assessment criteria. OKR auto-generation. Generate Objectives and Key Results from strategic direction, including Objective generation, Key Results design, feasibility assessment, and OKR alignment check. Keywords: OKR, objective management, Key Results, objective decomposition, OKR alignment, setting objectives, breaking down objectives.
---
# OKR Auto-Generation

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/strategy/OKR.md
- okr.json

## Core Principles

1. **Objectives come from strategy** — Objectives must originate from SWOT strategic directions, not be set in a vacuum detached from strategy
2. **KRs must be quantifiable** — Each KR has a clear numerical target and verification method; vague statements are rejected
3. **Feasibility hard check** — If probability of achievement < 0.3, escalate to adjust the target; if > 0.9, escalate to increase the challenge
4. **Alignment closed loop** — O and KR are logically consistent, KRs support each other, and are linked to the North Star Metric

## Interaction Mode
🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| SWOT strategic direction | JSON | Yes | docs/strategy/PRODUCT_STRATEGY.md ("Strategic Analysis" section) | SO/ST/WO/WT strategic directions |
| North Star Metric | JSON | Yes | docs/strategy/PRODUCT_STRATEGY.md ("North Star" section) | North Star Metric and breakdown metrics |
| BMC business model canvas | JSON | ○ | docs/strategy/business-strategy.md ("Business Model Canvas" section) | Value proposition, revenue streams |
| Business status data | JSON | ○ | Provided by user | Current business metric baseline |

## Execution Steps

### Step 1: Objective Generation [Core]

Generate 2-3 Objective candidates

Quality check criteria:
- **Directional sense**: Expresses clear direction and intent
- **Strategic alignment**: Consistent with SWOT strategic direction
- **Inspirational**: Can motivate the team
- **Time-bound**: Has a clear time period

Objective template:
```
O: [Verb] + [What] + [Achieve what]
```

### Step 2: Key Results Generation [Core]

Generate 3-5 Key Results for each Objective

Quality check criteria:
- **Quantifiable**: Measured with numbers
- **Verifiable**: Has a clear verification method
- **Multi-dimensional**: Covers different dimensions (quantity/quality/time/cost)
- **Challenging**: Requires effort to achieve

KR template:
```
KR: [Time] [Quantity/Percentage] [Do what] reach [Target value]
```

**KR Achievement Probability Estimation Rules**:

| Scenario | Estimation Method | Confidence |
|------|----------|--------|
| With historical data | Extrapolate based on historical trends; compare target/baseline ratio with historical growth rate | High (≥0.7) |
| With industry benchmarks | Reference KR achievement rates of companies at the same stage in the same industry | Medium (0.4-0.7) |
| No reference data | Based on Delphi method — AI provides 3 probability tiers (optimistic 0.8/neutral 0.5/conservative 0.2), human selects | Low (<0.4) |

KRs with achievement probability < 0.3 are tagged needs_human_validation: true; recommend adjusting the target or splitting into multiple progressive KRs.

**North Star Metric consumption**: Extract the core metric and breakdown metrics from the input North Star Metric, ensure at least 1 KR's metric is directly linked to the North Star Metric, and tag north_star_alignment: true.

### Step 3: KR Feasibility Assessment [Core]

Conduct a feasibility assessment for each KR:

```yaml
kr_assessment:
  baseline: Current value
  target: Target value
  growth_needed: Required growth rate
  achievability: Probability of achievement (0-1)
  dimension: Dimension classification
  confidence_level: Confidence
```

**achievability calculation method**:

```
achievability_score = w1 × resource_fit + w2 × historical_trend + w3 × dependency_risk

- resource_fit: Team's current resources / estimated required resources (0-1), dynamically calibrated based on team size:
  - 1-3 people: 0.3 (resource constrained)
  - 4-6 people: 0.5 (moderate resources)
  - 7-10 people: 0.7 (ample resources)
  - >10 people: 0.8 (abundant resources)
  - If team size is unknown, default 0.4 (conservative)
- historical_trend: Achievement probability when based on historical data, 0.5 when no historical data
- dependency_risk: 1 - (number of external dependencies × 0.15), minimum 0.1
- w1=0.4, w2=0.35, w3=0.25

achievability_score < 0.4 is tagged as high-risk KR, needs_human_validation: true
```

### Step 4: Driving Feature Mapping [Core]

Define 1-3 feature candidates that can directly contribute to achieving each KR:

- Each feature must be tagged with priority and expected lift
- Features must be further refined based on the drives_features of the North Star Metric
- Feature descriptions are placeholders, awaiting design-prd to generate specific feature_id

### Step 5: OKR Alignment Check [Core]

Check the alignment between OKRs:
- Aligned with company strategy
- O and KR are logically consistent
- KRs support each other
- Timeline is reasonable

**Alignment check execution rules**:

| Check Dimension | Check Method | Pass Condition | Fail Handling |
|----------|----------|----------|-----------|
| O-KR consistency | Each KR must directly contribute to the corresponding O's achievement | All KRs have a direct causal relationship with O | Tag inconsistent KRs, recommend redefinition |
| KR independence | KRs should not have inclusion or causal relationships between them | No logical dependency between any two KRs | Merge dependent KRs or split into independent KRs |
| North Star alignment | At least 1 KR's metric is directly linked to the North Star Metric | At least 1 KR with north_star_alignment=true | Tag missing North Star alignment, recommend adding a linked KR |
| Quantifiable & verifiable | Each KR contains a numerical target value and deadline | All KRs contain metric+target+deadline | Tag non-verifiable KRs, recommend adding quantitative metrics |
| Resource feasibility | achievability_score ≥ 0.4 | All KRs have achievability ≥ 0.4 | Tag high-risk KRs, recommend adjusting target or adding resources |

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | OKR and Key Results | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Complete artifact, including all Step outputs |
| deep | Full OKR + alignment validation + progress tracking mechanism + quarterly retrospective template | Full artifact + extended analysis + deep reasoning |

## Output

**Storage path**: `docs/strategy/OKR.md`

**Output file**: okr.json

### Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| okr_candidates | array | Yes | At least 2 Objective candidates |
| okr_candidates[].objective | string | Yes | Objective description |
| okr_candidates[].key_results | array | Yes | At least 3 KRs per O |
| okr_candidates[].key_results[].kr | string | Yes | KR description |
| okr_candidates[].key_results[].baseline | string | Yes | Current baseline value |
| okr_candidates[].key_results[].target | string | Yes | Target value |
| okr_candidates[].key_results[].growth_needed | string | Yes | Required growth rate |
| okr_candidates[].key_results[].achievability | number | Yes | Probability of achievement 0-1 |
| okr_candidates[].key_results[].confidence_level | number | Yes | Confidence 0-1 |
| okr_candidates[].key_results[].deadline | string | Yes | KR deadline (ISO8601 format) |
| okr_candidates[].key_results[].drives_features | array | Yes | List of features driven by this KR |
| okr_candidates[].key_results[].drives_features[].feature_priority | string | Yes | Feature priority (P0/P1/P2) |
| okr_candidates[].key_results[].drives_features[].feature_description | string | Yes | Feature description (placeholder) |
| okr_candidates[].alignment_check.strategic_alignment | boolean | Yes | Strategic alignment check |
| okr_candidates[].alignment_check.kr_coherence | boolean | Yes | KR consistency check |
| okr_candidates[].alignment_check.timeline_feasibility | boolean | Yes | Timeline feasibility |

```yaml
okr_candidates:
  - objective: "O1: Increase user engagement"
    key_results:
      - kr: "KR1: DAU reaches 1 million"
        baseline: 600k
        target: 1 million
        growth_needed: 67%
        achievability: 0.65
        dimension: "Quantity"
        confidence_level: 0.85
        deadline: "2026-06-30"
        north_star_alignment: true
        drives_features:
          - feature_priority: "P0"
            feature_description: "Personalized recommendation homepage"
            expected_lift: "15% DAU lift"
          - feature_priority: "P0"
            feature_description: "Daily check-in system"
            expected_lift: "8% DAU lift"
      - kr: "KR2: D1 retention rate reaches 45%"
        baseline: 35%
        target: 45%
        growth_needed: 29%
        achievability: 0.70
        dimension: "Quality"
        confidence_level: 0.80
        deadline: "2026-06-30"
        drives_features:
          - feature_priority: "P0"
            feature_description: "Onboarding optimization"
            expected_lift: "10% D1 retention lift"
          - feature_priority: "P1"
            feature_description: "First-time experience optimization"
            expected_lift: "5% D1 retention lift"
      - kr: "KR3: Core feature usage rate reaches 60%"
        baseline: 40%
        target: 60%
        growth_needed: 50%
        achievability: 0.55
        dimension: "Quality"
        confidence_level: 0.75
        deadline: "2026-06-30"
        drives_features:
          - feature_priority: "P1"
            feature_description: "Feature discovery guidance"
            expected_lift: "8% usage rate lift"
    alignment_check:
      strategic_alignment: true
      kr_coherence: true
      timeline_feasibility: true
      notes: "Alignment check notes"
  - objective: "O2: Optimize unit economics"
    key_results:
      - kr: "KR1: Reduce CAC by 20%"
        baseline: 150 yuan
        target: 120 yuan
        growth_needed: -20%
        achievability: 0.60
        dimension: "Cost"
        confidence_level: 0.75
        deadline: "2026-06-30"
        drives_features:
          - feature_priority: "P1"
            feature_description: "Precise ad targeting optimization"
            expected_lift: "12% CAC reduction"
    alignment_check:
      strategic_alignment: true
      kr_coherence: true
      timeline_feasibility: true
      notes: "Alignment check notes"
```

## Decision Rules

1. **Achievement probability escalation**:
   - Achievement probability < 0.3: Escalate to adjust target
   - Achievement probability > 0.9: Escalate to increase challenge
2. **OKR final confirmation**: Must be a human decision
3. **Resource matching**: Check whether KR resource requirements can be met

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Each O contains a 1-sentence description and ≤30 characters
- [ ] Each KR contains ≥1 numerical target value (metric+target)

### P1 Checks (must pass for standard/deep)

- [ ] Each KR contains a deadline field (ISO8601 format)
- [ ] At least 1 KR with north_star_alignment=true, O-KR consistency check 100% passed
- [ ] All KRs have achievability_score calculated and KRs with ≥0.4 account for ≥60%
- [ ] Strategic alignment verified
- [ ] Each KR's drives_features[] is non-empty and contains at least 1 P0 feature
- [ ] drives_features have logical correlation with the North Star Metric's features

### P2 Checks (only required for deep)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision record complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files are missing, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| strategic-analysis.json | User provides business objectives → directly generate OKR candidates | Lacking strategic analysis data support, O's alignment with strategic direction may be insufficient | Ask user to provide strategic direction and key challenge descriptions or upload strategic-analysis.json file |
| north-star.json | User provides business objectives → directly generate OKR candidates | Lacking North Star Metric alignment, KRs may be disconnected from core metrics | Ask user to provide North Star Metric and current metric values or upload north-star.json file |
| bmc.json | User provides business objectives → directly generate OKR candidates | Lacking BMC data, OKR's correlation with business model may be weak | Ask user to provide key business model elements or upload bmc.json file |
| strategic-analysis.json + north-star.json + bmc.json | User provides business objectives → directly generate OKR candidates | Overall confidence reduced, OKR lacks strategic and metric anchoring | Ask user to provide strategic direction, North Star Metric, and business model description |
| All upstream files missing | Prompt user to execute prior phases first, or directly generate OKR candidates based on user-provided business objectives | Overall confidence significantly reduced, OKR is only a general objective reference | Ask user to provide business objectives, key challenges, and core metrics |
| Business status data (user-provided) | If user does not provide business status data, prompt user to provide or skip steps related to this input | Lacking baseline data, KR target values lack reference | Ask user to provide current core metric values (e.g., DAU, revenue, conversion rate, etc.) |

## Data Acquisition Instructions

This Skill requires strategic analysis, North Star Metric, and BMC data. Please provide via one of the following methods:
  1. Directly describe business objectives and expected Key Results
  2. Upload strategic-analysis.json / north-star.json / bmc.json files
  3. Provide the data file path
- AI is not responsible for external data collection, only for analysis

---

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| strategic-analysis.json strategic direction adjustment | Objective generation needs re-alignment | Re-execute Step 1, update O candidates |
| north-star.json North Star change | KRs need re-alignment with North Star | Re-execute Step 2, update KRs and linkages |
| bmc.json business model change | OKR's correlation with business model | Re-evaluate OKR's alignment with revenue/cost structure |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Objective adjustment | planning-roadmap, business-strategy-report, design-prd | Output file version number + change summary |
| KR target value change | planning-roadmap, design-prd | Output file version number + change summary |
| drives_features change | design-prd | Output file version number + change summary |
| Alignment check result change | planning-roadmap | Output file version number + change summary |

## Alignment with prd.json Data Contract

| This Skill's Output Field | Corresponding prd.json Field | Alignment Rule |
|----------------|-----------------|---------|
| okr_candidates[].objective | prd.json.goals[].description | O description is consistent with PRD goal description |
| okr_candidates[].key_results[].kr | prd.json.goals[].success_metrics[].metric_name | KR description contains PRD success metric name |
| okr_candidates[].key_results[].target | prd.json.goals[].success_metrics[].target_value | KR target value is consistent with PRD metric target value |
| okr_candidates[].key_results[].baseline | prd.json.goals[].success_metrics[].current_value | KR baseline is consistent with PRD metric current value |
