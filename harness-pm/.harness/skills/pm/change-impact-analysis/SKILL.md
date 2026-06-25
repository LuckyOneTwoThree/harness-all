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

### Change Request Structure Example

```json
{
  "change_id": "CR_2024_001",
  "title": "Add WeChat login to login flow",
  "requester": "product_manager_zhang",
  "created_at": "ISO8601",
  "change_type": "functional",
  "description": "Add WeChat authorization login method on top of existing phone number login",
  "affected_scope": ["Login module", "User center"],
  "proposed_solution": "Introduce WeChat OpenID authorization mechanism",
  "priority": "high",
  "expected_completion": "2024-02-01"
}
```

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

#### Classification Output

```json
{
  "classification": {
    "level": "L3",
    "level_description": "Major change",
    "reasons": [
      "Core login flow underwent major change",
      "Need to add WeChat authorization service dependency"
    ],
    "confidence": 0.92
  }
}
```

### Step 2: Impact Propagation Analysis [Core]

#### 2.1 Functional Impact Analysis

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Directly affected features | PRD feature points directly affected by the change |
| Indirectly affected features | Related features affected by directly affected features |
| Features dependent on this feature | Whether upstream features are affected |

**Functional impact matrix**:

```json
{
  "functional_impact": {
    "directly_affected": [
      {"feature_id": "F001", "feature_name": "Phone login", "impact_type": "modified"}
    ],
    "indirectly_affected": [
      {"feature_id": "F002", "feature_name": "User registration", "impact_type": "needs_regression"},
      {"feature_id": "F003", "feature_name": "Third-party binding", "impact_type": "needs_regression"}
    ],
    "dependent_features": [
      {"feature_id": "F004", "feature_name": "Order creation", "reason": "Depends on user login state"}
    ]
  }
}
```

#### 2.2 IA Impact Analysis [Conditional]

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Directly affected IA nodes | IA nodes directly affected by the change |
| IA structure changes | IA nodes that need to be added/modified/deleted |
| Navigation path impact | Affected navigation paths |

**IA impact matrix**:

```json
{
  "ia_impact": {
    "directly_affected_nodes": [
      {"node_id": "IA001", "node_name": "User center", "impact_type": "modified"}
    ],
    "structure_changes": [
      {"node_id": "IA002", "node_name": "Login method", "change_type": "add", "parent": "User center"}
    ],
    "navigation_path_impact": [
      {"path": "Home→Login→WeChat authorization", "change_type": "new"}
    ]
  }
}
```

#### 2.3 User Flow Impact Analysis [Conditional]

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Directly affected flows | User flows directly affected by the change |
| Flow node changes | Flow nodes that need to be added/modified/deleted |
| Dead-end risks | Whether the change introduces new dead-ends |

**User flow impact matrix**:

```json
{
  "userflow_impact": {
    "directly_affected_flows": [
      {"flow_id": "UF001", "flow_name": "Login flow", "impact_type": "modified"}
    ],
    "node_changes": [
      {"node_id": "UF001_N3", "node_name": "WeChat authorization", "change_type": "add"}
    ],
    "dead_end_risks": [
      {"risk": "No exit path for users without WeChat binding", "severity": "high"}
    ]
  }
}
```

#### 2.4 Prototype Impact Analysis [Deep]

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Affected pages | Prototype pages that need modification |
| Component changes | Components that need to be added/modified |
| Design specification consistency | Impact of changes on design specification consistency |

**Prototype impact matrix**:

```json
{
  "prototype_impact": {
    "affected_pages": [
      {"page_id": "P001", "page_name": "Login page", "change_type": "modify"}
    ],
    "component_changes": [
      {"component": "WechatLoginButton", "change_type": "new"}
    ],
    "design_consistency": {
      "consistency_score_before": 0.92,
      "consistency_score_after": 0.85,
      "violations": ["New button does not follow design token specification"]
    }
  }
}
```

#### 2.5 Interaction Specification Impact Analysis [Deep]

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Affected interaction states | Interaction state machines that need modification |
| Animation changes | Animations that need to be added/modified |
| Gesture specification changes | Gesture specifications that need to be added/modified |

**Interaction specification impact matrix**:

```json
{
  "interaction_spec_impact": {
    "affected_states": [
      {"state": "loading", "scenario": "WeChat authorization in progress", "change_type": "add"}
    ],
    "animation_changes": [
      {"animation": "wechat_auth_loading", "change_type": "new"}
    ],
    "gesture_changes": []
  }
}
```

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

#### Re-review Necessity Output

```json
{
  "review_decision": {
    "required": true,
    "level": "L3_mandatory_review",
    "review_scope": [
      {"role": "Product manager", "reason": "Core feature change"},
      {"role": "Test lead", "reason": "Test scope expansion"}
    ],
    "review_content": [
      "WeChat login technical solution",
      "Compatibility with existing login flow",
      "Regression test plan"
    ],
    "review_deadline": "ISO8601"
  }
}
```

### Step 4: Version Linkage Analysis [Deep]

#### 4.1 PRD Version Update

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| PRD sections to update | PRD sections involved in the change |
| Change type | Add/modify/delete |
| Update recommendations | Specific update content suggestions |

**PRD version update**:

```json
{
  "prd_version_update": {
    "current_version": "1.2.0",
    "new_version": "1.3.0",
    "update_type": "minor_version",
    "sections_to_update": [
      {"chapter": "3. Login feature", "change_type": "modify", "suggestion": "Add WeChat login section"}
    ],
    "update_proposal": "See attached PRD update recommendations"
  }
}
```

#### 4.2 IA Version Update

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| IA nodes to update | IA nodes involved in the change |
| Change type | Add/modify/delete |
| Update recommendations | Specific IA structure adjustment suggestions |

**IA version update**:

```json
{
  "ia_version_update": {
    "current_version": "1.2.0",
    "new_version": "1.3.0",
    "nodes_to_update": [
      {"node_id": "IA001", "node_name": "User center", "change_type": "modify", "suggestion": "Add WeChat login sub-node"}
    ],
    "update_proposal": "See attached IA update recommendations"
  }
}
```

#### 4.3 User Flow Version Update

**Analysis content**:

| Analysis Item | Output |
|--------|------|
| Flows to add | For new features |
| Flows to modify | For changed content |
| Flows to delete | Deprecated features |

**User flow version update**:

```json
{
  "userflow_version_update": {
    "flows_to_add": [
      {"flow_id": "NEW_001", "flow_name": "WeChat login flow", "priority": "P0"}
    ],
    "flows_to_modify": [
      {"flow_id": "UF_001", "flow_name": "Login flow", "change": "Add WeChat login branch"}
    ],
    "flows_to_delete": [],
    "estimated_redesign_effort_hours": 16
  }
}
```

## Output

**Storage path**: `docs/product/PRD.md ("Change Impact Analysis" section)`

**Output file**: `change_impact_report.json`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["output_id", "change_id", "classification", "impact_analysis", "review_needed"],
  "properties": {
    "output_id": {"type": "string", "description": "Output unique identifier"},
    "change_id": {"type": "string", "description": "Change request ID"},
    "generated_at": {"type": "string", "description": "Generation time"},
    "classification": {"type": "object", "description": "Change classification, including level and reasons"},
    "impact_analysis": {"type": "object", "description": "Impact analysis, including functional/IA/user flow/prototype/interaction specification multi-dimensions"},
    "review_needed": {"type": "boolean", "description": "Whether re-review is needed"},
    "review_decision": {"type": "object", "description": "Review decision, including review scope and content"},
    "version_updates": {"type": "object", "description": "Version linkage update recommendations"},
    "summary": {"type": "object", "description": "Change impact summary, including impact scope and risk level"}
  }
}
```

### Final Output Structure

```json
{
  "output_id": "change_impact_report_xxx",
  "change_id": "CR_2024_001",
  "generated_at": "ISO8601",
  "classification": {
    "level": "L3",
    "level_description": "Major change",
    "reasons": [...]
  },
  "impact_analysis": {
    "functional": {...},
    "ia": {...},
    "userflow": {...},
    "prototype": {...},
    "interaction_spec": {...}
  },
  "review_needed": true,
  "review_decision": {...},
  "version_updates": {
    "prd": {...},
    "ia": {...},
    "userflow": {...}
  },
  "summary": {
    "impact_scope": "Multiple feature modules",
    "estimated_effort_days": 10,
    "risk_level": "medium"
  }
}
```

### Output Field Descriptions

| Field | Type | Description |
|------|------|------|
| classification | JSON | Change level and reasons |
| impact_analysis | JSON | Multi-dimensional impact analysis details |
| review_needed | boolean | Whether re-review is needed |
| review_decision | JSON | Review scope and content |
| version_updates | JSON | Version linkage update recommendations |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| output_id | string | Yes | Output unique identifier |
| change_id | string | Yes | Change request ID, must match input change_id |
| generated_at | string | Yes | Generation time, ISO 8601 format |
| classification | object | Yes | Change classification |
| classification.level | string | Yes | Change level, enum: L1/L2/L3/L4 |
| classification.level_description | string | Yes | Level description |
| classification.reasons | array | Yes | Classification reasons list, cannot be empty |
| classification.confidence | number | Yes | Classification confidence, range 0.0-1.0 |
| impact_analysis | object | Yes | Impact analysis |
| impact_analysis.functional | object | Yes | Functional impact analysis, contains directly_affected/indirectly_affected/dependent_features |
| impact_analysis.functional.directly_affected | array | Yes | Directly affected features list, each item contains feature_id/feature_name/impact_type |
| impact_analysis.ia | object | Yes | IA impact analysis, contains directly_affected_nodes/structure_changes/navigation_path_impact |
| impact_analysis.userflow | object | Yes | User flow impact analysis, contains directly_affected_flows/node_changes/dead_end_risks |
| impact_analysis.prototype | object | No | Prototype impact analysis, contains affected_pages/component_changes/design_consistency |
| impact_analysis.interaction_spec | object | No | Interaction specification impact analysis, contains affected_states/animation_changes/gesture_changes |
| review_needed | boolean | Yes | Whether re-review is needed |
| review_decision | object | No | Review decision (required when review_needed is true), contains level/review_scope/review_content/review_deadline |
| review_decision.level | string | No | Review level, enum: L1_optional/L2_suggested/L3_mandatory/L4_strategic |
| review_decision.review_scope | array | No | Review role list, each item contains role/reason |
| version_updates | object | No | Version linkage update recommendations, contains prd/ia/userflow |
| version_updates.prd | object | No | PRD version update recommendations, contains current_version/new_version/sections_to_update |
| version_updates.ia | object | No | IA version update recommendations, contains current_version/new_version/nodes_to_update |
| version_updates.userflow | object | No | User flow version update recommendations, contains flows_to_add/flows_to_modify/flows_to_delete |
| summary | object | Yes | Change impact summary |
| summary.impact_scope | string | Yes | Impact scope description |
| summary.estimated_effort_days | number | Yes | Estimated impact person-days, must be ≥0 |
| summary.risk_level | string | Yes | Risk level, enum: low/medium/high/critical |

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| PRD requirement change | Functional impact analysis, version linkage | Update functional impact matrix, re-evaluate change level and re-review necessity |
| IA solution change | IA impact analysis | Update IA impact matrix, re-evaluate IA structure change scope |
| User flow change | User flow impact analysis | Update user flow impact matrix, re-evaluate dead-end risks |
| Prototype change | Prototype impact analysis | Update prototype impact matrix, re-evaluate design specification consistency |
| Interaction specification change | Interaction specification impact analysis | Update interaction specification impact matrix, re-evaluate state machine coverage |

When the change impact analysis results themselves change, the downstream notification mechanism:

| Change Impact Analysis Change Type | Notification Scope | Notification Method |
|---------------------|----------|----------|
| Change level upgrade | iteration-retrospective | Mark change level change, trigger retrospective assessment |
| Impact scope expansion | design-prd | Mark impact scope change, trigger PRD update assessment |
| Re-review necessity change | quality-acceptance | Mark review need change, trigger acceptance criteria update |
| Version planning adjustment | iteration-orchestrator | Mark version planning change, trigger iteration plan adjustment |

---

## Decision Rules

### Mandatory Re-review Rules

| Condition | Decision |
|------|------|
| L3 level change | **Must trigger re-review** |
| L4 level change | **Must trigger strategic-level review** |
| Involves hypothesis change | Must re-review |
| Impact scope > 3 feature modules | Suggest upgrading review level |

### Special Handling Rules

| Condition | Handling Method |
|------|----------|
| Change involves IA structure restructuring | Must include IA rollback plan |
| Change involves design system/token changes | Must include design specification degradation plan |
| Change affects P0 features | Must have product owner sign-off |

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

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact | Data Acquisition Notes |
|----------|----------|----------|------------|
| Change request missing | Cannot execute, need user to describe change content | - | Require user to provide change content description (what changed, which feature modules involved) |
| Current PRD missing | User describes change content → directly analyze impact, no PRD baseline comparison | Cannot precisely locate affected sections, impact scope based on inference | Require user to provide current PRD document or feature requirement description |
| Current IA missing | Skip IA impact analysis | IA impact analysis incomplete | Require user to provide IA solution or information architecture description |
| Current user flow missing | Skip user flow impact analysis | User flow impact analysis incomplete | Require user to provide user flow diagrams or flow descriptions |
| Current prototype missing | Skip prototype impact analysis | Prototype impact analysis incomplete | Require user to provide prototype design or page descriptions |
| Current interaction specification missing | Skip interaction specification impact analysis | Interaction specification impact analysis incomplete | Require user to provide interaction specifications or interaction descriptions |
| Change request + current PRD + current IA all missing | User describes change content → directly analyze impact | Output simplified impact analysis, each dimension labeled "pending supplementation" | Require user to provide change description, current PRD and IA solution |

### Data Acquisition Notes

When upstream files are missing, the following information is needed from the user to support degraded generation:
- **Change content description**: What changed, which feature modules are involved
- **Change reason** (optional): Why the change is needed
- **Expected impact scope** (optional): Modules or systems that may be affected by the change

## Execution Log

```json
{
  "execution_id": "exec_p2_xxx",
  "pipeline": "change-impact-analysis",
  "change_id": "CR_2024_001",
  "started_at": "ISO8601",
  "completed_at": "ISO8601",
  "steps": [
    {"step": "step_1_classification", "status": "completed", "duration_ms": 500},
    {"step": "step_2_impact_analysis", "status": "completed", "duration_ms": 2000},
    {"step": "step_3_review_decision", "status": "completed", "duration_ms": 800},
    {"step": "step_4_version_updates", "status": "completed", "duration_ms": 600}
  ],
  "output_ref": "output_ref_xxx",
  "quality_checks_passed": true
}
```
