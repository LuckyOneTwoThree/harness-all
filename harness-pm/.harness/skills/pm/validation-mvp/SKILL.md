---
name: validation-mvp
description: Used when defining the MVP feature scope. MVP scope auto-definition tool that intelligently identifies Must Have, MUST NOT, and Nice to Have features based on the assumption map and resource constraints, and evaluates the MVP size ratio.
---
# MVP Scope Auto-Definition

## When to use
- What features should the MVP include
- How to build the minimal product
- Which features can be deferred
- Keywords: MVP scope, Minimum Viable Product, feature priority, resource constraints, minimal product, core features

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/product/PRD.md
- docs/handoff/design-to-solo.md

## Outputs
- docs/product/PRD.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **MVP validates hypotheses, not solutions** — The goal of an MVP is learning, not delivery; acquire maximum confidence at minimum cost
2. **Must Have is the MVP baseline** — Must Have features cannot be cut; Nice to Have features are all cuttable
3. **2 weeks is the MVP time redline** — An MVP exceeding 2 weeks is not an MVP, it is a full product
4. **Validation results have only three outcomes** — Validated / Invalidated / Needs more data; ambiguous conclusions are not allowed

### Basic Information

| Attribute | Value |
|------|-----|
| Pipeline ID | 11 |
| Name | MVP Scope Auto-Definition |
| Execution Mode | 🤖→👤 AI suggests, human approves |
| Input | Solution design + Assumption map + Resource constraints |

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Solution design | JSON | Yes | User-provided or harness-design output | Complete feature list and descriptions |
| Assumption map | JSON | Yes | docs/product/PRD.md ("Assumption Map" section) | Assumption map output from Pipeline 10 |
| Resource constraints | JSON | ○ | User-provided | Time, staffing, and budget constraints |

### Input Format

> See [Reference/examples.md](./Reference/examples.md#input-format) for the input format JSON schema.

## Execution Steps

### Step 1: Core Hypothesis Extraction and Must Have Identification [Core]

**Definition**: Features directly related to the highest-risk assumptions = must include

**Logic**:
1. Find all assumptions where is_max_risk = true
2. Extract the core hypothesis list
3. Identify features linked to these hypotheses
4. Mark as Must Have

> See [Reference/examples.md](./Reference/examples.md#step-1-core-hypothesis-must-have-output-format) for the `core_hypothesis` and `must_have` output format JSON.

### Step 2: Cut Feature Identification [Core]

**Definition**: Features that interfere with core hypothesis validation = exclude

**Exclusion Criteria**:

| Exclusion Type | Description | Example |
|----------|------|------|
| Over-built | Full features beyond MVP validation needs | MVP needs a list, but full search + filter + sort is built |
| Over-polished | High-fidelity design not necessary for MVP | Heavy investment in interaction animations |
| Over-configured | Complex configuration items not necessary for validation | Multi-dimensional custom settings |

> See [Reference/examples.md](./Reference/examples.md#step-2-cut-features-output-format) for the `cut_features` output format JSON.

### Step 3: Nice to Have Classification [Core]

**Definition**: Features that are neither Must Have nor cut features

**Priority Rules**:
1. Features linked to high-risk assumptions but not directly related → P1
2. Features linked to medium-risk assumptions → P2
3. Features linked to low-risk assumptions → P3

> See [Reference/examples.md](./Reference/examples.md#step-3-nice-to-have-output-format) for the `nice_to_have` output format JSON.

### Step 4: MVP Size Assessment [Core]

**Formula**:

```
MVP ratio = Must Have effort / Full solution effort × 100%
```

**Effort Unit**: person-days / person-weeks / story points (per team convention)

**Assessment Criteria**:

| MVP Ratio | Assessment | Recommendation |
|---------|----------|------|
| < 40% | ✅ Ideal | Can start MVP development |
| 40-60% | ⚠️ Acceptable | Review whether Nice to Have can be further trimmed |
| > 60% | 🚨 Needs review | Escalate to human judgment, confirm whether to adjust |

### Step 5: Timeline Planning [Core]

**Definition**: Build a timeline based on MVP feature effort and resource constraints

**Planning Logic**:
1. Sum Must Have feature effort
2. Combine with timeline_weeks and team_size from resource constraints
3. Ensure total weeks ≤ 2 (MVP time redline)
4. Break down milestone checkpoints

> See [Reference/examples.md](./Reference/examples.md#step-5-timeline-output-format) for the `timeline` output format JSON.

### Step 6: Resource Estimation [Core]

**Definition**: Estimate required resources based on MVP feature effort and timeline

**Estimation Logic**:
1. Calculate staffing needs based on Must Have feature effort
2. Derive team configuration from timeline.total_weeks
3. Assess whether external resource support is needed

> See [Reference/examples.md](./Reference/examples.md#step-6-resource-estimate-output-format) for the `resource_estimate` output format JSON.

### Step 7: Success Criteria and Risk Mitigation [Core]

**Definition**: Define success criteria for MVP validation and identify risks with mitigation measures

**Success Criteria Logic**:
1. Convert core hypotheses into quantifiable validation metrics
2. Each core hypothesis maps to at least one success criterion
3. Success criteria must be quantifiable (with specific values or thresholds)

**Risk Mitigation Logic**:
1. Identify key risks during MVP execution
2. Develop mitigation measures for each risk
3. Assess risk impact level

> See [Reference/examples.md](./Reference/examples.md#step-7-success-criteria-risk-mitigation-output-format) for the `success_criteria` and `risk_mitigation` output format JSON.

### Step 8: Go/No-Go Decision Framework [Core]

**Definition**: Build a Go/No-Go decision framework based on success criteria; metrics directly reference the quantitative metrics in success_criteria

**Decision Logic**:
1. Extract key decision metrics from success_criteria (select one primary metric per core hypothesis)
2. Define Go/No-Go thresholds for each metric (based on fluctuation around success_criteria.target_value)
3. Include at least 2 metrics and corresponding thresholds
4. Metrics do not redefine indicators; they reference success_criteria via linked_criterion

> See [Reference/examples.md](./Reference/examples.md#step-8-gono-go-decision-framework-output-format) for the `go_no_go` output format JSON.

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | MVP scope and validation plan | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full solution + MVP scope optimization + validation metrics system + iteration evolution roadmap | Full artifact + extended analysis + deep reasoning |

## Output

**Storage Path**: `docs/product/PRD.md ("MVP Plan" section)`
**Output File**: mvp_definition.json

> See [Reference/examples.md](./Reference/examples.md#output-file-mvp_definitionjson) for the complete `mvp_definition.json` output example.

**Output Validation Rules**: See [Reference/output-schema.md](./Reference/output-schema.md#output-validation-rules) for field-level validation rules.

## Decision Rules

| Rule | Condition | Action |
|------|------|------|
| Human approval triggered | MVP ratio > 60% | Escalate to human judgment |
| Approval triggered | Must Have has no hypothesis linkage | Requires supplementary explanation |
| Approval triggered | cut_features rationale insufficient | Requires supplementary exclusion basis |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Core hypotheses (core_hypothesis is non-empty and linked to must_have)
- [ ] Hypothesis linkage (Must Have features all have hypothesis linkage)

### P1 Checks (must pass for standard/deep)

- [ ] Exclusion rationale (cut_features all have sufficient rationale)
- [ ] Ratio calculation (MVP ratio calculated)
- [ ] Priority completeness (Nice to Have all have priority)
- [ ] Time redline (timeline.total_weeks ≤ 2; when exceeded, human_override must be true)
- [ ] Success criteria quantifiable (success_criteria contains quantitative metrics and target values)
- [ ] Go/No-Go completeness (go_no_go contains at least 2 metrics and corresponding thresholds)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

> See [Reference/output-schema.md](./Reference/output-schema.md#degradation-strategy) for the upstream file missing degradation plan.

## Upstream Change Response

> See [Reference/output-schema.md](./Reference/output-schema.md#upstream-change-response) for the upstream change impact table and downstream notification mechanism table.

---

## Usage Example

> See [Reference/examples.md](./Reference/examples.md#usage-example) for a complete worked example: Intelligent Recommendation Feature MVP definition, including core hypothesis, Must Have/Cut/Nice to Have features, timeline, resource estimate, success criteria, risk mitigation, and Go/No-Go decision.
