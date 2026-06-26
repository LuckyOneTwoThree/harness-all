---
name: change-impact-analysis
description: Used when analyzing the impact scope of PRD changes, design changes, or requirement changes. Automated change impact analysis, analyzing the impact of requirement changes on functionality, IA, user flows, prototypes, interaction specifications, and other dimensions, generating a change impact report and re-review recommendations. Keywords: change impact, requirement change, impact analysis, change review, PRD change.
---
# Requirement Change Impact Analysis Automation

## When to use
- Requirements changed, check the impact scope
- Analyze which modules this change will affect
- Requirements changed, help me evaluate the impact

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/product/PRD.md

## Outputs
- docs/product/PRD.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **PRD change driven**: Triggered by prd-orchestrator on PRD changes, not manually initiated
2. **Automated validation**: Change classification, impact propagation analysis, re-review judgment fully automated
3. **Result synchronization**: Analysis results synchronized to downstream design Skills (IA/user flow/prototype/interaction specification), maintaining release rhythm
4. **Real-time retrospective**: Version linkage recommendations generated immediately after change impact analysis completes

## Interaction Mode

🤖→👤 **AI suggests, human approves**

Trigger condition: prd-orchestrator triggers on PRD changes.

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Change request | JSON | Yes | User-provided (PRD change content) | Change content to be analyzed |
| Current PRD | JSON | Yes | docs/product/PRD.md | Currently effective PRD version |

> Note: Previously also assessed impact on design outputs such as IA/userflow/prototype/interaction-spec.
> These outputs have been migrated to harness-design. This skill now only assesses impact on the PRD itself and downstream handoff contracts.
> Impact assessment on design outputs is handled by harness-design, notified via docs/handoff/pm-to-design.md.
> If design impact assessment is needed, notify harness-design via docs/handoff/pm-to-design.md.

> See [Reference/examples.md](./Reference/examples.md) → "Change Request Structure" for the change request JSON example.

## Execution Steps

### Step 1: Change Classification (L1-L4) [Core]

#### Classification Dimensions

| Level | Change Type | Impact Scope | Decision Level |
|------|----------|----------|----------|
| L1 Minor | Text corrections, style adjustments, copy optimization | Single small feature | Developer self-decision |
| L2 General | Feature detail adjustments, interaction optimization, non-core logic changes | Single feature module | Product manager approval |
| L3 Major | Core feature changes, IA structure changes, user flow restructuring | Multiple feature modules | Multi-role review |
| L4 Strategic | Architecture changes, business model changes, cross-system impact | Global or cross-system | Strategic-level review |

#### Classification Decision Tree

```
Change request
    │
    ├─ Does it affect core business flow? ──Yes──→ L3
    │
    ├─ Does it change IA structure? ──Yes──→ L3
    │
    ├─ Does it affect user flow? ──Yes──→ L3
    │
    ├─ Does it affect multiple feature modules? ──Yes──→ L2
    │
    └─ Other ──→ L1
```

> See [Reference/examples.md](./Reference/examples.md) → "Step 1: Classification Output" for the classification output JSON example.

### Step 2: Impact Propagation Analysis [Core]

#### 2.1 Functional Impact Analysis

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Directly affected features | PRD feature points directly affected by the change |
| Indirectly affected features | Related features affected by directly affected features |
| Features dependent on this feature | Whether upstream features are affected |

> See [Reference/examples.md](./Reference/examples.md) → "Step 2.1: Functional Impact Matrix" for the functional impact matrix JSON example.

#### 2.2 IA Impact Analysis [Conditional]

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Directly affected IA nodes | IA nodes directly affected by the change |
| IA structure changes | IA nodes that need to be added/modified/deleted |
| Navigation path impact | Affected navigation paths |

> See [Reference/examples.md](./Reference/examples.md) → "Step 2.2: IA Impact Matrix" for the IA impact matrix JSON example.

#### 2.3 User Flow Impact Analysis [Conditional]

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Directly affected flows | User flows directly affected by the change |
| Flow node changes | Flow nodes that need to be added/modified/deleted |
| Dead-end risks | Whether the change introduces new dead-ends |

> See [Reference/examples.md](./Reference/examples.md) → "Step 2.3: User Flow Impact Matrix" for the user flow impact matrix JSON example.

#### 2.4 Prototype Impact Analysis [Deep]

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Affected pages | Prototype pages that need modification |
| Component changes | Components that need to be added/modified |
| Design specification consistency | Impact of changes on design specification consistency |

> See [Reference/examples.md](./Reference/examples.md) → "Step 2.4: Prototype Impact Matrix" for the prototype impact matrix JSON example.

#### 2.5 Interaction Specification Impact Analysis [Deep]

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Affected interaction states | Interaction state machines that need modification |
| Animation changes | Animations that need to be added/modified |
| Gesture specification changes | Gesture specifications that need to be added/modified |

> See [Reference/examples.md](./Reference/examples.md) → "Step 2.5: Interaction Specification Impact Matrix" for the interaction specification impact matrix JSON example.

### Step 3: Re-review Necessity Judgment [Core]

#### Review Trigger Rules

**Decision matrix**:

| Change Level | Involves Role Change | Hypothesis Change | Re-review Necessity |
|----------|--------------|----------|--------------|
| L4 | Any | Any | **Must re-review** |
| L3 | Any | Yes | **Must re-review** |
| L3 | Yes | No | **Must re-review** |
| L3 | No | No | Suggested review |
| L2 | Yes | Yes | Suggested review |
| L2 | Other | - | Optional review |
| L1 | - | - | No review needed |

#### Review Role Identification

| Role | Trigger Condition |
|------|----------|
| Product manager | Requirement change involves product features |
| Designer | UI/UX related changes |
| IA designer | IA structure changes |
| Interaction designer | Interaction specification changes |
| Test lead | Any change |
| Operations | Operations related changes |

> See [Reference/examples.md](./Reference/examples.md) → "Step 3: Re-review Necessity Output" for the re-review necessity output JSON example.

### Step 4: Version Linkage Analysis [Deep]

#### 4.1 PRD Version Update

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| PRD sections to update | PRD sections involved in the change |
| Change type | Add/modify/delete |
| Update recommendations | Specific update content suggestions |

> See [Reference/examples.md](./Reference/examples.md) → "Step 4.1: PRD Version Update" for the PRD version update JSON example.

#### 4.2 IA Version Update

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| IA nodes to update | IA nodes involved in the change |
| Change type | Add/modify/delete |
| Update recommendations | Specific IA structure adjustment suggestions |

> See [Reference/examples.md](./Reference/examples.md) → "Step 4.2: IA Version Update" for the IA version update JSON example.

#### 4.3 User Flow Version Update

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Flows to add | For new features |
| Flows to modify | For changed content |
| Flows to delete | Deprecated features |

> See [Reference/examples.md](./Reference/examples.md) → "Step 4.3: User Flow Version Update" for the user flow version update JSON example.

## Output

**Storage path**: `docs/product/PRD.md ("Change Impact Analysis" section)`

**Output file**: `change_impact_report.json`

> See [Reference/schema.md](./Reference/schema.md) for output JSON schema, final output structure, output field descriptions, and output validation rules.
> See [Reference/examples.md](./Reference/examples.md) → "Execution Log" for the execution log JSON example.

## Decision Rules

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Decision Rules" for mandatory re-review rules and special handling rules.

## Quality Checks

### Quality Check

| Check Item | Standard | Non-compliance Handling |
|--------|------|------------|
| Impact scope enumeration (P0) | Functional/IA/user flow/prototype/interaction specification multi-dimensional full coverage | Return for supplementation |
| Re-review judgment basis (P0) | Each judgment has corresponding evidence | Return for supplementation |
| Version linkage completeness (P1) | PRD/IA/user flow version sync | Alert + manual confirmation |

### Impact Scope Enumeration Checklist

- [ ] Functional impact: direct/indirect/dependent features identified (P0)
- [ ] IA impact: IA nodes/structure/navigation paths identified (P1)
- [ ] User flow impact: flows/nodes/dead-ends identified (P1)
- [ ] Prototype impact: pages/components/design consistency identified (P2)
- [ ] Interaction specification impact: states/animations/gestures identified (P2)

## Degradation Strategy

When upstream files are missing, this Skill can execute independently through user-provided data.

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Degradation Strategy - Upstream File Missing" and "Data Acquisition Notes" for the full degradation table and data acquisition methods.

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Upstream Change Response" for upstream/downstream change impact and notification mechanism tables.
