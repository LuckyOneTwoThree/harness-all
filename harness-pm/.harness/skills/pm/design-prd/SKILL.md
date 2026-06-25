---
name: design-prd
description: Use when you need to generate a standardized PRD document. PRD auto-generation and management, generating standardized PRD documents based on requirements and creative solutions, providing input for subsequent IA, flow, and prototype design. Covers PRD-L/S/X three-tier layering, 9-section complete structure, and 4 quality gates. Keywords: PRD generation, product requirements document, requirements document auto-generation, PRD management, writing requirements documents, product documentation.
---
# PRD Generator

## When to use
- Help me write a PRD document
- Generate a product requirements document
- How to write a requirements document

## Outputs
- docs/product/PRD.md
- memory/progress.md
- memory/knowledge-base.md

This Skill is responsible for automatically converting upstream phase outputs (user insights, opportunity definition, ideation) into PRD documents that meet quality standards, providing structured input for subsequent product design (IA, flow, prototype). Requirements collection, understanding, and prioritization are built into design-prd's Step 1-3, eliminating the need for a separate requirements management phase. Supports PRD-L/S/X three-tier layering, automatically performs 4 quality gate checks to ensure document completeness, consistency, ambiguity elimination, and traceability.

## Core Principles
1. Quality gates cannot be bypassed — The 4 gates are the bottom line of PRD quality, never skipped under any circumstances
2. Tiering matches complexity — PRD-L/S/X correspond to different complexities, avoiding over- or under-engineering
3. Traceability chain must be connected — Each feature point can be traced back to upstream outputs and business objectives
4. Human decision authority takes precedence — When AI judgment confidence < 0.7, human confirmation is mandatory; PM can override AI tiering

## Execution Steps

1. [Core] Determine PRD tier level (L/S/X) — Automatically tier based on Effort estimation and team count; PM can override
2. [Core] Generate PRD document according to the corresponding tier structure — PRD-L uses a simplified template, PRD-S uses the complete 9-section structure, PRD-X uses the enhanced 9-section structure
3. [Core] Execute 4 quality gate checks — Completeness/Consistency/Ambiguity elimination/Traceability; auto-correct if failed
4. [Conditional] Version lifecycle management — Create→Review→Finalize→Change; record change log for each change
5. [Conditional] Upstream/downstream handoff — Ensure PRD is traceable to upstream requirements, downstream design can directly consume PRD output

**Key Output Requirements**:
- **entities[].fields must be complete**: Each entity must contain at least an identifier field (id), a name field, a status field, and business core fields. Field granularity should be at the "backend can directly use for ER model design" level; cannot only provide entity names without fields
- **pages[].data_requirements must be complete**: Each page must explicitly specify what data is needed, data operation types (read/create/update/delete), which entity it relates to, and which fields are needed. This is the direct input for UI page generation and API design
- **entities[].api_endpoints is advisory**: What PRD defines is business operation requirements (e.g., "users need to view the course list"); specific API paths are designed by api-design-spec

See detailed descriptions in each section below.

## 1. PRD Tiering System

### 1.1 Tier Definition

| Tier | Trigger Condition | Document Size | Review Process | Decision Authority |
|------|----------|----------|----------|--------|
| **PRD-L (Light)** | Effort < 2 person-days | 200-500 words | PM self-review | PM unilateral decision |
| **PRD-S (Standard)** | 2 person-days ≤ Effort ≤ 20 person-days | 1500-3000 words | Requirements Review meeting | Product committee decision |
| **PRD-X (eXtensive)** | Effort > 20 person-days OR cross 3+ teams | 3000-8000 words | Multi-round review | Cross-department review + management approval |

### 1.2 Automatic Tiering Rules

```
Tiering decision algorithm:
1. Extract Effort estimation from upstream output (unit: person-days)
2. Count the number of teams involved (development, design, testing, operations, etc.)
3. Apply the tiering decision tree:
   IF Effort < 2 AND team count ≤ 1 THEN PRD-L
   ELSE IF Effort <= 20 AND team count ≤ 3 THEN PRD-S
   ELSE PRD-X
```

### 1.3 Human Can Override AI Judgment

- PM can manually specify the tier level without following the automatic judgment
- When overriding, the override reason must be recorded in the document metadata
- When automatic judgment confidence < 0.7, human confirmation is mandatory

## 2. PRD-S Complete 9-Section Structure

The following is the standard structure for PRD-S (Standard); PRD-L and PRD-X are adjusted proportionally on this basis.

**Complete structure definition**: See [Reference/prd-structure.md](Reference/prd-structure.md)

### Structure Overview

| Section | Name | Core Content |
|---------|------|----------|
| Section 1 | Meta Information | Document ID, version, status, related documents |
| Section 2 | Background & Objectives (Why) | Problem Statement, objectives and success definition, target users and scenarios |
| Section 3 | Solution Design (What & How) | Solution overview, feature specs (MoSCoW), user stories (Given-When-Then), interaction logic, state design, data model, interface definition |
| Section 4 | Boundaries & Constraints | Explicitly out of scope, technical constraints, known limitations |
| Section 5 | Non-Functional Requirements (NFR) | Performance, availability, security, observability |
| Section 6 | Tracking Plan | Event list, tracking validation plan |
| Section 7 | Acceptance Criteria | Functional acceptance, performance acceptance, security acceptance |
| Section 8 | Release & Operations | Gradual rollout plan, Feature Flag, rollback plan, operations readiness |
| Section 9 | Appendix | Glossary, change log, open issues, related document index |

## 3. Quality Gates

### Gate 1: Completeness Check

**Checklist**:
- [ ] All 9 sections exist
- [ ] All required fields are filled
- [ ] MoSCoW prioritization annotated
- [ ] Given-When-Then acceptance criteria cover the main flow
- [ ] State design covers 5 special states
- [ ] Non-functional requirements include 4 dimensions

**Failure Handling**:
- Block the generation process
- Output missing items list
- Provide guidance for supplementation

### Gate 2: Consistency Check

**Check Rules**:
- OKR objectives → success metrics consistency
- Metrics → functional requirements consistency
- Functional requirements → acceptance criteria consistency
- Whether upstream/downstream references exist

**Traceability Chain**:
```
Strategic objectives → OKR → Key Results → Primary metrics → Functional requirements → Acceptance criteria
```

**Failure Handling**:
- Identify inconsistent locations
- Provide correction suggestions
- Record as items pending confirmation

### Gate 3: Ambiguity Check

**Automatic Check Items**:
- Fuzzy quantifier detection ("fast", "large amount", "occasionally", etc.)
- Dangling reference detection (references to non-existent charts, fields, interfaces)
- Logical contradiction detection: Annotate suspected contradictions (e.g., preconditions contradicting results, circular feature dependencies), output suspected_contradictions list, tag needs_human_review: true, do not auto-correct
- UI instruction overreach detection: Detect whether AC contains specific UI form instructions (e.g., "left sidebar", "red button"). If found, tag needs_human_review: true to force changing it to a business intent description (e.g., "provide a high-priority entry"), never auto-correct UI forms

**Human Review Items**:
- Business rule reasonableness
- User scenario authenticity
- Technical solution feasibility
- Suspected contradiction items in suspected_contradictions

**Failure Handling**:
- Auto-correct identifiable ambiguities (fuzzy quantifiers, dangling references)
- Logical contradiction issues are not auto-corrected; output suspected_contradictions list and tag needs_human_review: true
- Mark items requiring human confirmation
- Generate ambiguity clarification question list

### Gate 4: Traceability Check

**Traceability Requirements**:
- Each feature point can be traced to upstream output
- Each acceptance criterion can be traced to a specific metric
- Each metric can be traced to a business objective

**Upstream Artifact Specific File Paths**:
- insight_analysis: `docs/discovery/insight.md`
- opportunity_definition: `docs/discovery/opportunity.md`
- north_star_metric: `docs/strategy/PRODUCT_STRATEGY.md` ("North Star" section)
- okr_candidates: `docs/strategy/OKR.md`

**Failure Handling**:
- Generate traceability chain breakpoint report
- Prompt missing traceability paths
- Require supplementing upstream evidence

## 4. Version Lifecycle [Conditional]

### 4.1 Version State Machine

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   v0.1 AI draft  →  v0.2 PM refinement  →  v0.3 Review revision │
│       ↓                ↓               ↓                    │
│   Auto-generated    Manual revision    Review feedback       │
│                                                             │
│   v1.0 Finalized  →  v1.x Dev change  →  v2.0 Release update │
│       ↓               ↓               ↓                    │
│   Review passed    Adjusted during dev  Post-release retrospective │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Version Definition

| Version | Trigger Condition | Change Authority | Review Requirement |
|------|----------|----------|----------|
| v0.1 | AI auto-generated | AI | None |
| v0.2 | PM first revision | PM | None |
| v0.3 | Post-review revision | PM + reviewer | None |
| v1.0 | Review passed and finalized | Change committee | Full review |
| v1.x | Change during development | Dev + PM | Change review |
| v2.0 | Major version update after release | PM | Retrospective review |

### 4.3 State Transitions

| Current State | Transition Action | Next State | Trigger Condition |
|----------|----------|----------|----------|
| Draft | Submit for review | In Review | All 4 gates passed |
| In Review | Review passed | Finalized | Review committee approved |
| In Review | Review not passed | Review Revision | Blocking items exist |
| Finalized | Trigger change | Dev Change | Adjustment needed during development phase |
| Released | Publish update | Archived | New version released |

## 5. Execution Decision Logic [Conditional]

### 5.1 Generation Order Dependency Graph

**Topological Sort Rules**:
```
Generation priority (high to low):
1. Meta information (Section 1) - no dependencies
2. Background & objectives (Section 2) - depends on upstream exploration output
3. Solution design (Section 3) - depends on Section 2 and design output
4. Boundaries & constraints (Section 4) - depends on Section 3
5. Non-functional requirements (Section 5) - depends on Section 3
6. Tracking plan (Section 6) - depends on Section 3
7. Acceptance criteria (Section 7) - depends on Section 2, 3
8. Release & operations (Section 8) - depends on Section 7
9. Appendix (Section 9) - depends on all other Sections
```

### 5.2 Upstream Conflict Decision Rules

**Conflict Types and Handling Strategies**:

| Conflict Type | Decision Rule | Handling Strategy | Escalation Condition |
|----------|----------|----------|----------|
| **Objective conflict** | Two OKRs in opposite directions | Priority arbitration | KPI impact > 10% |
| **Solution conflict** | Multiple solutions point to different implementations | Solution comparison scoring | Major architecture adjustment |
| **Metric conflict** | Metric optimization directions contradict | Guardrail metric constraints | Guardrail metric breached |
| **Priority conflict** | Feature priority ranking contradicts | MoSCoW re-prioritization | MVP scope change > 30% |

**Escalation Decision Matrix**:
```
Escalation thresholds:
- Number of sources ≥ 2 and conclusions inconsistent
- MVP scope change > 30%
- Involves security compliance issues
- Involves major technical debt

Escalation path:
1. Record conflict details
2. Convene stakeholder meeting
3. Produce decision minutes
4. Update PRD
```

### 5.3 Upstream Data Incomplete Handling

**Missing Level Definition**:

| Level | Definition | Handling Method |
|------|------|----------|
| **L0** | Fields complete, but content is empty | AI supplements description, annotates low confidence |
| **L1** | Some fields missing | Fill with template, mark as pending confirmation |
| **L2** | Core fields completely missing | Interrupt process, force supplementation |

**Missing Handling Flow**:
```
Detect missing → Determine level → Apply strategy → Output result

L0 handling:
1. Annotate "AI supplemented, pending confirmation"
2. Provide confidence score
3. Generate confirmation question list

L1 handling:
1. Annotate "Pending supplementation"
2. Fill with default values or template
3. Block related downstream generation
4. Generate supplementation list

L2 handling:
1. Annotate "Missing core input"
2. Output interruption report
3. Specify missing fields
4. Require re-input
```

### 5.4 Self-Correction Loop

**Trigger Conditions**:
- Gate check failure
- Human feedback correction
- Upstream data update

**Loop Limits**:
- Maximum self-correction rounds: 2
- Per-round timeout: 3 minutes
- Logical contradiction issues do not enter the self-correction loop; directly tag for manual review
- After exceeding limits, output problem report, human intervention

**Self-Correction Flow**:
```
Round N correction:
1. Analyze failure cause
2. Generate correction plan
3. Apply correction
4. Re-execute gate check
5. If passed, end; otherwise enter round N+1
```

## 6. Upstream/Downstream Handoff [Conditional]

### 6.1 Upstream Consumption

| Phase | Output Artifact | Consumption Method |
|------|--------|----------|
| **Insight Analysis (insight-analysis)** | User insights, pain points, behavior patterns | Replaces the original requirements-collection input, extracts user research data and requirements collection |
| **Opportunity Definition (opportunity-definition)** | Opportunity list, priority ranking, problem statement | Replaces the original requirements-understanding/prioritization input, provides requirements understanding and priority ranking |
| **Discovery** | User insights, problem statement, backlog | Extract Problem Statement, target user definition |
| **Strategy** | OKR, roadmap, value proposition | Align business objectives, priority judgment |
| **Ideation** | Solutions, feature list | Reference solution design, acceptance criteria source |
| **Design** | Prototypes, flow diagrams, information architecture | Reference interaction logic, page specs |
| **Metrics** | Metric system, tracking plan | Direct reference or supplement |

### 6.2 Downstream Driving

| Downstream Party | Driving Content | Deliverable | Consumption Source |
|--------|----------|--------|----------|
| **UI/Frontend** | Interaction logic, state design, page specs, data model | Component intent description + page data requirements | prd.json.pages[] + prd.json.user_flows[] |
| **Backend Architecture** | Feature specs, interface definition, data entities, boundary conditions | API contract input + data model input | prd.json.features[] + prd.json.entities[] |
| **Development** | Feature specs, interface definition, boundary conditions | Technical design document | prd.md + prd.json |
| **Design** | Interaction logic, state design, page specs | Design specification document | prd.md + prd.json.pages[] |
| **Testing** | Acceptance criteria, test cases, environment requirements | Test plan | prd.json.features[].acceptance_criteria[] |
| **Operations** | Release strategy, operations readiness, effectiveness evaluation | Operations plan | prd.md |
| **Monitoring** | Observability requirements, tracking plan | Monitoring dashboard | prd.json.non_functional_requirements |

### 6.3 Data Flow Diagram

```
[Insight Analysis output] → [Opportunity Definition output] → [Ideation output]
        ↓              ↓                ↓
        └──────────────┴────────────────┘
                      ↓
          PRD Generator (requirements collection, understanding, prioritization built into Step 1-3)
                      ↓
        ┌─────────┼─────────┐
        ↓         ↓         ↓
[IA Design]  [Flow Design]  [Prototype Design]
```

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| metadata | JSON/object | Yes | System-generated | Request metadata |
| insight_analysis | Markdown | ○ | docs/discovery/insight.md | User insight analysis output, replaces the original requirements-collection input, provides user research data and requirements collection |
| opportunity_definition | Markdown | ○ | docs/discovery/opportunity.md | Opportunity definition output, replaces the original requirements-understanding/prioritization input, provides requirements understanding and priority ranking |
| exploration_outputs | Markdown | ○ | Upstream discovery phase docs/discovery/ | User insights, problem statement |
| strategy_outputs | Markdown | ○ | Upstream strategy phase docs/strategy/ | OKR, roadmap |
| north_star_metric | Markdown | ○ | docs/strategy/PRODUCT_STRATEGY.md ("North Star" section) | North Star Metric and driving features |
| okr_candidates | Markdown | ○ | docs/strategy/OKR.md | OKR candidates and driving features |
| ideation_outputs | Markdown | ○ | docs/product/PRD.md ("Creative Solutions" section) | Solutions, feature list |
| design_outputs | JSON/object | ○ | Upstream design phase | Prototypes, user flows |
| metrics_outputs | JSON/object | ○ | Upstream metrics phase | Metric system, tracking plan |
| requirement | JSON/object | Yes | Provided by user | Requirements context and manual override config |

**Complete input data structure and validation rules**: See [Reference/input-schema.md](Reference/input-schema.md)

## Output

| Output Item | Format | Path | Description |
|--------|------|------|------|
| PRD document | Markdown | `docs/product/PRD.md` | Overwrites the file, including complete PRD content, quality gate results, and items requiring human confirmation |

**Complete output data structure and template**: See [Reference/output-schema.md](Reference/output-schema.md)

### prd.json Structure

prd.json is the machine-consumable version of the PRD, for programmatic consumption by Backend/UI downstream Skills.

Complete prd.json Schema see [Reference/output-schema.md](Reference/output-schema.md)

> Complete example see [Reference/examples.md](Reference/examples.md)

prd.json contains 7 top-level arrays: features, pages, entities, user_flows, non_functional_requirements, tracking_plan, traceability.

### Relationship between prd.json and prd.md

| Dimension | prd.md | prd.json |
|------|--------|----------|
| Consumer | Humans (PM, designers, developers) | Machines (Backend Skill, UI Skill) |
| Content | Complete 9-section narrative + tables + charts | Structured core data (features/pages/entities/flows) |
| Generation order | Generate prd.md first | Extract structured data from prd.md to generate prd.json |
| Consistency | prd.json must be consistent with prd.md content; in case of conflict, prd.md prevails | |

### Output Validation Rules

- [ ] 9-section structure complete: PRD-S complete 9-section structure all exist
- [ ] Traceability chain connected: Traceability chain from OKR to acceptance criteria is complete
- [ ] Gates passed: All 4 quality gates passed
- [ ] No residual ambiguity: No fuzzy quantifiers and dangling references
- [ ] prd.json completeness: features/pages/entities/user_flows four arrays are all non-empty
- [ ] prd.json entities field completeness: Each entity's fields array is non-empty and contains at least core fields (id/name/status, etc.), relationships array is non-empty
- [ ] prd.json pages data requirements completeness: Each page's data_requirements array is non-empty, clearly annotates data source (api/local/cache) and required fields
- [ ] prd.json reference consistency: page_id in feature.related_pages exists in pages[], entity_id in feature.related_entities exists in entities[]
- [ ] prd.json traceability chain complete: Each feature has a corresponding traceability entry
- [ ] prd.json and prd.md consistency: Feature point names, priorities, and acceptance criteria in prd.json are consistent with prd.md
- [ ] prd.json tracking_plan completeness: tracking_plan.events is non-empty, each event's properties is non-empty
- [ ] prd.json NFR completeness: All 4 dimension arrays of non_functional_requirements are non-empty
- [ ] prd.json feature driving information completeness: Each P0/P1 feature's driven_by field is non-empty, clearly linked to North Star Metric or OKR
- [ ] prd.json feature priority and metric correlation consistency: feature.priority is positively correlated with driven_by.expected_lift

## Decision Rules (Detailed)

### 9.1 Gate Pass Rules

**Hard Conditions**:
- All 4 gates must pass
- Failure of any gate blocks entry into the development phase

**Gate Status Mapping**:
| Gate Status | Enter Development | Finalize | Release |
|----------|----------|------|------|
| All passed | ✓ | ✓ | ✓ |
| Gate 1 failed | ✗ | ✗ | ✗ |
| Gate 2 failed | ✗ | ✗ | ✗ |
| Gate 3 failed | Human confirmation required | Human confirmation required | ✗ |
| Gate 4 failed | Supplementation required | Supplementation required | ✗ |

### 9.2 Conflict Escalation Rules

**Situations Requiring Escalation**:
1. **Source conflict**: Requirements involve ≥ 2 upstream sources, and conclusions are inconsistent
2. **Scope change**: MVP scope change > 30%
3. **Security compliance**: Involves user privacy, security compliance, financial regulation, and other sensitive areas
4. **Resource overrun**: Requirement resource consumption exceeds 50% of the original plan
5. **Technical risk**: Solution involves major technical architecture adjustment

**Escalation Process**:
```
1. Identify escalation trigger conditions
2. Generate escalation report (conflict details + stakeholder positions + impact analysis)
3. Determine escalation level (PM/Product committee/Management)
4. Convene decision meeting
5. Produce decision minutes
6. Update PRD
```

### 9.3 Open Issue Management [Deep]

**Open Issue Status**:
- **Open**: Unresolved
- **In Progress**: Being handled
- **Resolved**: Resolved
- **Won't Fix**: Explicitly not doing

**Finalization Rules**:
- All Open issues must be Resolved or converted to Won't Fix
- Output issue closure report at finalization

## Quality Checks (Detailed)

### 10.1 Completeness Standards (P0)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Structure completeness | All 9 sections exist | Section existence scan |
| Field completeness | Required fields 100% filled | Field non-empty check |
| Acceptance coverage | Main flow + boundary + exception fully covered | Given-When-Then coverage rate |
| State coverage | All 5 states defined | State type enum matching |

### 10.2 Consistency Standards (P1)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Objective traceability chain | OKR→metric→feature→acceptance connected | Traceability chain completeness check |
| Priority consistency | MoSCoW consistent across all references | Priority cross-validation |
| Version consistency | Version number matches change log | Version number consistency check |

### 10.3 Ambiguity Elimination Standards (P1)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Quantifier quantification | No fuzzy quantifiers (fast→<2s) | Quantifier regex matching + replacement |
| Dangling references | All references point to existing targets | Reference resolution + existence validation |
| Logical contradictions | No precondition-result contradictions | Logic rule engine check |
| UI instruction overreach | AC only describes business rules, does not include specific UI/color/control forms | UI form terminology detection, violations tagged with needs_human_review |

### 10.4 Executability Standards (P2)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Acceptance format | Given-When-Then format correct | Format regex matching |
| Judgment clarity | Then result can be objectively judged | Judgment condition testability check |
| Coverage completeness | Happy Path + boundary + exception | Coverage rate statistical analysis |

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| insight_analysis missing | Supplement user insights based on user description and opportunity_definition, annotate "Insight data pending supplementation" | Section 2 user requirements section simplified, requirements collection may not be complete enough | Ask user to provide user insight descriptions or upload insight-analysis.json file |
| opportunity_definition missing | Infer opportunities and priorities based on user description and insight_analysis, annotate "Priority pending confirmation" | Requirements understanding and priority ranking may not be precise enough | Ask user to provide opportunity definition and priority descriptions or upload opportunity-definition.json file |
| Both insight_analysis and opportunity_definition missing | Execute built-in requirements collection, understanding, and prioritization based on user verbal description (Step 1-3), annotate "Requirements management data is AI-inferred" | Requirements management full process relies on AI inference, confidence reduced | Ask user to provide core requirements, target users, and priority ranking |
| exploration_outputs missing | Background and objectives section annotated "Pending supplementation", generate simplified version based on user description | Section 2 content simplified | Ask user to provide product background and objective descriptions or upload discovery phase output files |
| strategy_outputs missing | OKR alignment and priority judgment section annotated "Pending supplementation" | Section 2.2 objective definition simplified | Ask user to provide strategic objectives and OKR or upload strategy phase output files |
| ideation_outputs missing | Solution design section annotated "Pending supplementation", generate feature list based on user description | Section 3 feature specs simplified | Ask user to provide feature solution descriptions or upload ideation phase output files |
| design_outputs missing | Interaction logic and state design annotated "Pending supplementation" | Section 3.2 interaction logic simplified | Ask user to provide interaction design descriptions or upload design phase output files |
| metrics_outputs missing | Tracking plan annotated "Pending supplementation" | Section 6 content simplified | Ask user to provide core metrics and tracking requirements or upload metrics phase output files |
| All upstream missing | Generate simplified PRD-L (200-500 words) based on user verbal description, with built-in requirements collection, understanding, and prioritization | Output PRD-L level document | Ask user to provide product requirements description, core features, and target users |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Product requirements description**: What are the core requirements, what problem to solve
- **Target users**: Who are the product's target user groups
- **Core feature list**: The main feature points that need to be implemented

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| User insight added/changed | User requirements section in PRD | Annotate affected requirement items, recommend human confirmation on whether to update PRD |
| Business model change | Business model section in PRD | Annotate affected business logic, recommend human confirmation on whether to update PRD |
| OKR adjustment | Objectives and metrics section in PRD | Annotate affected metric definitions, recommend human confirmation on whether to update PRD |

When the PRD itself changes, the notification mechanism for downstream:

| PRD Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Feature point addition/removal | change-impact-analysis | Mark change impact scope, trigger change impact analysis |
| Priority adjustment | change-impact-analysis | Mark priority change, trigger impact assessment |
| Objective metric change | metrics-system, tracking-plan | Mark metric change, trigger measurement system update |
| Business logic change | business-model-canvas, business-strategy-report | Mark business logic change, trigger strategy document update |
