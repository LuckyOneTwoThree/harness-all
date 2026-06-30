---
name: tracking-plan
description: Use when you need to generate a tracking plan. Tracking plan auto-generation, including deriving tracking requirements from the metric system, extracting tracking requirements from PRD features, tracking quality checks, and PRD consistency validation. Keywords: tracking plan, event design, property design, tracking specification, Tracking Plan, data collection, add tracking, instrument events.
---
# Tracking Plan Auto-Generation

## When to use
- This feature needs tracking
- Help me produce a tracking plan
- Organize what data needs to be collected

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/metrics/metrics-system.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/metrics/tracking-plan.md
- tracking_plan.json

## Core Principles

1. **Comprehensive analysis**: Systematically analyze all available data without omitting key dimensions
2. **Real-time awareness**: Metric system design supports real-time monitoring and rapid response
3. **Automated attribution**: Automatically attribute anomalies to specific causes, reducing manual investigation
4. **Explicit decision rules**: Every alert and escalation condition has clear quantitative rules

## Interaction Mode

**🤖→👤 AI suggests, human approves**

This pipeline auto-generates the tracking plan, but key decision points require human approval:
- **Must approve**: Tracking business logic correctness
- **Must approve**: Privacy compliance
- **Recommended to approve**: Tracking priority adjustments

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Execution Steps

### Step 1: Derive Tracking Requirements from the Metric System [Core]

**🤖 AI processing**

**Processing logic**:

```
FOR each metric in metric_system:
  1. Analyze the data elements required for metric calculation
  2. Identify the user behaviors that need to be collected
  3. Define the corresponding tracking events
  4. List the required tracking properties
```

> 📋 For the derivation mapping table and output schema, see [Reference/step1-metric-mapping.md](./Reference/step1-metric-mapping.md)

---

### Step 2: Extract Feature Tracking Requirements from the PRD [Core]

**🤖 AI processing**

**Processing logic**:

```
1. Parse the PRD document structure
2. Identify the list of feature modules
3. Extract core user paths
4. Identify key interaction nodes
5. Define feature tracking events
```

> 📋 For the feature module/path/interaction example table, see [Reference/step2-prd-extraction.md](./Reference/step2-prd-extraction.md)

---

### Step 3: Deduplicate Against Existing Tracking [Conditional]

**🤖 AI processing**

**Deduplication logic**:

```
FOR each proposed_event:
  1. Search for similar events in the existing tracking inventory
  2. Calculate the similarity score
  3. IF similarity > 0.8 THEN mark as duplicate
  4. ELSE IF similarity > 0.5 THEN mark as needing manual confirmation
  5. ELSE mark as a new tracking event
```

> 📋 For similarity calculation rules and deduplication output, see [Reference/step3-dedup-rules.md](./Reference/step3-dedup-rules.md)

---

### Step 4: Tracking Quality Check [Core]

**🤖 AI processing**

> 📋 For all quality check rules and outputs from 4.1 to 4.5, see [Reference/step4-quality-checks.md](./Reference/step4-quality-checks.md)

---

### Step 5: Generate Tracking Document [Core]

**🤖 AI processing**

> 📋 For the document structure schema, see [Reference/step5-document-schema.md](./Reference/step5-document-schema.md)

---

### Step 6: PRD Tracking Plan Consistency Validation [Conditional]

**🤖 AI processing**

> 📋 For all consistency validation content from 6.1 to 6.4, see [Reference/step6-prd-consistency.md](./Reference/step6-prd-consistency.md)

---

## Output

**Storage path**: `docs/metrics/tracking-plan.md`

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Core event list + tracking inventory | Core conclusions + minimum viable artifact, only outputs Step 1-2 core events and tracking inventory |
| standard | Complete tracking plan (current default) | Complete artifact, including all Step 1-6 outputs |
| deep | Complete plan + extended analysis | Complete artifact + data governance specification + privacy compliance audit + long-term evolution roadmap + decision records + risk assessment |

**Output file**: `tracking_plan.json`

> 📋 For the overall output schema and tracking_plan schema, see [Reference/output-schemas.md](./Reference/output-schemas.md)

---

## Output Validation Rules

> 📋 For the output field validation rules table, see [Reference/output-validation-rules.md](./Reference/output-validation-rules.md)

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| North Star Metric change | Tracking events linked to the North Star | Update linked_metric references, re-evaluate tracking priority, mark for human confirmation |
| L1/L2 metric addition/removal | Tracking events derived from corresponding metrics | Added metrics trigger new tracking recommendations; removed metrics mark associated tracking as "pending review" |
| Action metric change | Tracking associated with action metrics | Update priority and analysis purpose of tracking associated with action metrics |
| PRD feature change | Feature module tracking and core path tracking | Re-extract PRD feature tracking, perform deduplication and consistency validation, mark changed portions |
| Metric definition modification | Property design of associated tracking | Update tracking properties to match the new calculation logic, mark for human confirmation |

When the tracking plan itself changes, the notification mechanism for downstream:

| Tracking Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Tracking event addition/removal | metrics-dashboard | Mark event addition/removal, trigger Dashboard data source update |
| Tracking property change | metrics-dashboard | Mark property change, trigger Widget configuration update |
| Tracking priority change | Development team | Mark priority change, trigger development scheduling assessment |
| Naming specification change | All downstream | Mark naming change, trigger full naming validation |

---

## Decision Rules

### Rule 1: Tracking Plan Requires Human Review of Business Logic

**Trigger conditions**:
- After all tracking plans are generated
- Any tracking related to business logic

**Review focus**:

#### Business Logic Correctness

```
1. Whether the tracking trigger timing matches business expectations
2. Whether tracking properties accurately reflect business semantics
3. Whether tracking matches the analysis purpose
4. Whether cross-flow tracking logic is consistent
```

#### Special Scenario Confirmation

```
1. Tracking timing for asynchronous operations
2. Tracking for retry/failure scenarios
3. Tracking for boundary conditions
4. A/B test related tracking
```

---

### Rule 2: Privacy Compliance Must Be Human-Confirmed

**Trigger conditions**:
- Tracking involves user personal information
- Tracking involves device information
- Tracking involves behavioral data

**Review checklist**:

| Review Item | Description | Pass Condition |
|-------|------|---------|
| Personal information identifier | Whether tracking collects PII | Desensitized or anonymized |
| Sensitive information | Whether collecting bank cards, passwords, etc. | Explicitly prohibited from collection |
| Data retention | Data retention period | Compliant with regulatory requirements |
| User consent | Whether user consent is obtained | Compliant with privacy policy |

---

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] All event names use lowercase + underscores
- [ ] All property names use lowercase + underscores
- [ ] Core user path coverage ≥ 90%

### P1 Checks (must pass for standard/deep)

- [ ] No camelCase naming
- [ ] No special characters
- [ ] Complete semantic units
- [ ] Key conversion node coverage complete
- [ ] Forward coverage ≥ 90% (PRD → tracking)
- [ ] Backward coverage ≥ 85% (tracking → PRD)
- [ ] Overall consistency ≥ 90%

### P2 Checks (only deep must pass)

- [ ] Exception path coverage ≥ 80%
- [ ] Data governance specification output (data retention policy, data quality rules, data lineage tracking)
- [ ] Privacy compliance audit completed (PII desensitization check, sensitive information collection review, user consent compliance verification)
- [ ] Long-term evolution roadmap generated (tracking version management, deprecated event migration plan, new metric onboarding specification)

---

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| PRD missing | Prompt user to provide feature list, generate basic tracking plan based on feature list | Unable to extract user flows and interaction details, tracking coverage may be incomplete |
| Metric system missing | Skip the metric-derived tracking step, only extract tracking requirements based on PRD features | Tracking-metric association missing, analysis purpose marked as "to be supplemented" |
| Existing tracking inventory missing | Skip deduplication step, mark all tracking as new | May produce redundant tracking, requires subsequent manual deduplication |
| PRD + metric system + existing tracking inventory all missing | User provides feature list → generate basic tracking plan based on features | Output basic tracking plan, marked as "to be supplemented" and "to be confirmed" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Feature list**: Core feature modules and feature points included in the product
- **Core user paths** (optional): Main process steps for users using the product
- **Key interaction nodes** (optional): User interaction behaviors that need to be tracked

---

## Escalation Path

### Escalation Trigger Conditions

When any of the following conditions is met, escalate to manual handling:

1. **PRD parsing failure**
   - PRD document format cannot be parsed
   - PRD content deviates significantly from structured requirements

2. **Tracking conflict cannot be auto-resolved**
   - More than 5 similar tracking events cannot be determined
   - Naming conflicts cannot be auto-resolved

3. **Privacy compliance risk**
   - Tracking involves highly sensitive information
   - Compliance boundary unclear

---

### Escalation Output

> 📋 For the escalation output schema, see [Reference/escalation-schema.md](./Reference/escalation-schema.md)

---
