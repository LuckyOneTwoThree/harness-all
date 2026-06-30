---
name: design-prd
description: Use when you need to generate a standardized PRD document. PRD auto-generation and management, generating standardized PRD documents based on requirements and creative solutions, providing input for subsequent IA, flow, and prototype design. Uses a single unified most-complete 9-section structure and 4 quality gates. Keywords: PRD generation, product requirements document, requirements document auto-generation, PRD management, writing requirements documents, product documentation.
---
# PRD Generator

## When to use
- Help me write a PRD document
- Generate a product requirements document
- How to write a requirements document

## Outputs
- docs/product/PRD.md
- docs/product/prd.json (generated projection; never edited independently)
- memory/progress.md
- memory/knowledge-base.md

This Skill is responsible for automatically converting upstream phase outputs (user insights, opportunity definition, ideation) into PRD documents that meet quality standards, providing structured input for subsequent product design (IA, flow, prototype). Requirements collection, understanding, and prioritization are built into design-prd's Step 1-3, eliminating the need for a separate requirements management phase. Uses a single unified most-complete 9-section structure, automatically performs 4 quality gate checks to ensure document completeness, consistency, ambiguity elimination, and traceability.

## Core Principles
1. Quality gates cannot be bypassed — The 4 gates are the bottom line of PRD quality, never skipped under any circumstances
2. Single unified most-complete structure — One PRD structure for all projects; no tiering/simplification, ensuring downstream consumers (design/engineering/growth) always get full contract data
3. Traceability chain must be connected — Each feature point can be traced back to upstream outputs and business objectives
4. Human decision authority takes precedence — When AI judgment confidence < 0.7, human confirmation is mandatory

## Execution Steps

1. [Core] Generate PRD document using the unified complete 9-section structure — No tiering; all projects use the same most-complete structure, ensuring downstream consumers always get full contract data
2. [Core] Execute 4 quality gate checks — Completeness/Consistency/Ambiguity elimination/Traceability; auto-correct if failed
3. [Conditional] Version lifecycle management — Create→Review→Finalize→Change; record change log for each change
4. [Conditional] Upstream/downstream handoff — Ensure PRD is traceable to upstream requirements, downstream design can directly consume PRD output

**Key Output Requirements**:
- **entities describe business semantics**: define identity, lifecycle, business attributes, relationships, retention, volume, and compliance constraints. Harness-solo owns physical schema, indexes, storage types, and migrations.
- **pages[].data_requirements describe information needs**: state what information and business operations a user needs, not API paths, cache strategy, or database fields.
- **interfaces describe business capabilities**: PM may specify actors, inputs/outputs, invariants, scale, latency expectations, and failure impact. Harness-solo owns endpoints, protocols, error codes, dependencies, and implementation design; harness-ops owns concrete SLO/DR/alert implementation.

## 1. PRD Complete 9-Section Structure

The schema is unified; applicability is not. For CLI, static, landing-page, prototype, and similarly narrow products, mark irrelevant domains `not_applicable`. Mark immature but required domains `deferred` with reason, owner, and `required_before`. Never invent pages, entities, flows, APIs, capacity, or DR details merely to make an array non-empty.

All projects use the same unified most-complete 9-section structure. No tiering/simplification — this ensures downstream consumers (design-brief, brainstorming, growth, ops) always receive full contract data.

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

## 2. Quality Gates

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

## 3. Version Lifecycle [Conditional]

> See [Reference/decision-tables.md](Reference/decision-tables.md#version-lifecycle) for the version state machine diagram, version definition table, and state transitions table.

## 4. Execution Decision Logic [Conditional]

> See [Reference/decision-tables.md](Reference/decision-tables.md#execution-decision-logic) for the generation order dependency graph, upstream conflict decision rules, upstream data incomplete handling (L0/L1/L2), and self-correction loop flow.

## 5. Upstream/Downstream Handoff [Conditional]

### 5.1 Upstream Consumption

| Phase | Output Artifact | Consumption Method |
|------|--------|----------|
| **Insight Analysis (insight-analysis)** | User insights, pain points, behavior patterns | Replaces the original requirements-collection input, extracts user research data and requirements collection |
| **Opportunity Definition (opportunity-definition)** | Opportunity list, priority ranking, problem statement | Replaces the original requirements-understanding/prioritization input, provides requirements understanding and priority ranking |
| **Discovery** | User insights, problem statement, backlog | Extract Problem Statement, target user definition |
| **Strategy** | OKR, roadmap, value proposition | Align business objectives, priority judgment |
| **Ideation** | Solutions, feature list | Reference solution design, acceptance criteria source |
| **Design** | Prototypes, flow diagrams, information architecture | Reference interaction logic, page specs |
| **Metrics** | Metric system, tracking plan | Direct reference or supplement |

### 5.2 Downstream Driving

| Downstream Party | Driving Content | Deliverable | Consumption Source | Handoff Path |
|--------|----------|--------|----------|----------|
| **UI/Frontend** | Interaction logic, state design, page specs, data model | Component intent description + page data requirements | prd.json.pages[] + prd.json.user_flows[] | pm-to-design.md → design-brief reads PRD.md + prd.json directly |
| **Backend Architecture** | Feature specs, interface definition, data entities, boundary conditions | API contract input + data model input | prd.json.features[] + prd.json.entities[] | pm-to-solo.md → brainstorming reads PRD.md + prd.json directly |
| **Development** | Feature specs, interface definition, boundary conditions | Technical design document | prd.md + prd.json | pm-to-solo.md → brainstorming → writing-plans |
| **Design** | Interaction logic, state design, page specs | Design specification document | prd.md + prd.json.pages[] | pm-to-design.md → design-brief reads PRD sections 3.2.3-3.2.5 + 5.1 |
| **Testing** | Acceptance criteria, test cases, environment requirements | Test plan | prd.json.features[].acceptance_criteria[] | pm-to-solo.md → writing-plans writes AC-xxx into spec.md |
| **Growth** | Tracking plan, success metrics, experiment hypothesis | Growth strategy + experiment design | prd.json.tracking_plan + prd.json.goals[] | pm-to-solo.md → solo-to-growth.md (growth does NOT read PRD directly) |
| **Operations** | Release strategy, observability, DR targets, capacity forecast | OPS_STRATEGY.md (self-produced by ops) | (ops does NOT read PRD directly; ops consumes solo-to-ops.md + self-produced OPS_STRATEGY.md) | pm-to-solo.md → solo-to-ops.md |

> **Handoff protocol**: handoff documents (pm-to-design.md, pm-to-solo.md) carry PRD.md + prd.json paths + AC-xxx list. Direct consumers (design-brief, brainstorming) read PRD directly for full context. Indirect consumers (growth, ops) consume handoff documents, not PRD itself. See [docs/handoff/](docs/handoff/) templates for the consumption contract.
>
> **Observability boundary note**: PRD Section 5.4 defines observability requirements from the PM perspective (what to measure, alert thresholds). The actual monitoring dashboard implementation, SLO alerting rules, and runbook authoring are ops-domain responsibilities, driven by OPS_STRATEGY.md (self-produced by ops based on solo-to-ops.md handoff + PRD NFR as reference input).

### 5.3 Data Flow Diagram

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
| PRD structured data | JSON | `docs/product/prd.json` | Machine-consumable version; 7 top-level arrays (features/pages/entities/user_flows/non_functional_requirements/tracking_plan/traceability); consumed by downstream design-brief and brainstorming skills |

**Complete output data structure and template**: See [Reference/output-schema.md](Reference/output-schema.md)

### prd.json Structure

prd.json is the machine-consumable version of the PRD, for programmatic consumption by Backend/UI downstream Skills.

Complete prd.json Schema see [Reference/output-schema.md](Reference/output-schema.md)

> Complete example see [Reference/examples.md](Reference/examples.md)

prd.json contains 7 top-level arrays: features, pages, entities, user_flows, non_functional_requirements, tracking_plan, traceability.

### Relationship between prd.json and prd.md

`PRD.md` is the sole authoring authority. Generate `prd.json` from it after every approved change, validate against `.harness/rules/prd.schema.json`, and record `source_revision` plus the exact PRD.md SHA-256. Direct edits to prd.json are prohibited; a mismatch blocks handoff publication.

| Dimension | prd.md | prd.json |
|------|--------|----------|
| Consumer | Humans (PM, designers, developers) | Machines (Backend Skill, UI Skill) |
| Content | Complete 9-section narrative + tables + charts | Structured core data (features/pages/entities/flows) |
| Generation order | Generate prd.md first | Extract structured data from prd.md to generate prd.json |
| Consistency | prd.json must be consistent with prd.md content; in case of conflict, prd.md prevails | |

### Output Validation Rules

**Unified PRD validation** (all projects use the same full 9-section structure):

- [ ] 9-section structure complete: All 9 sections of the unified complete structure exist
- [ ] Traceability chain connected: Traceability chain from OKR to acceptance criteria is complete
- [ ] Gates passed: All 4 quality gates passed
- [ ] No residual ambiguity: No fuzzy quantifiers and dangling references
- [ ] prd.json applicability honesty: relevant arrays are complete; irrelevant/deferred domains have explicit applicability metadata instead of fabricated entries
- [ ] prd.json entities field completeness: Each entity's fields array is non-empty and contains at least core fields (id/name/status, etc.), relationships array is non-empty; migration field present when entity evolves from existing data
- [ ] prd.json pages data requirements completeness: Each page's data_requirements array is non-empty, clearly annotates data source (api/local/cache) and required fields
- [ ] prd.json reference consistency: page_id in feature.related_pages exists in pages[], entity_id in feature.related_entities exists in entities[]
- [ ] prd.json traceability chain complete: Each feature has a corresponding traceability entry
- [ ] prd.json provenance and consistency: schema_version/source_revision/source_sha256 match authoritative PRD.md; generated data and stable IDs are an exact projection
- [ ] prd.json tracking_plan completeness: tracking_plan.events is non-empty, each event's properties is non-empty; experiment_hypothesis_ref present for growth-bound projects
- [ ] prd.json NFR completeness: All 4 dimension arrays of non_functional_requirements are non-empty; slo_targets, capacity_forecast, dr_targets present for production-grade projects
- [ ] prd.json feature driving information completeness: Each P0/P1 feature's driven_by field is non-empty, clearly linked to North Star Metric or OKR
- [ ] prd.json feature priority and metric correlation consistency: feature.priority is positively correlated with driven_by.expected_lift

## Decision Rules (Detailed)

> See [Reference/decision-tables.md](Reference/decision-tables.md#detailed-decision-rules) for gate pass rules, conflict escalation rules, and open issue management.

## Quality Checks (Detailed)

> See [Reference/quality-checks.md](Reference/quality-checks.md) for the detailed completeness (P0), consistency (P1), ambiguity elimination (P1), and executability (P2) standards tables.

## Degradation Strategy

> See [Reference/decision-tables.md](Reference/decision-tables.md#degradation-strategy) for the upstream file missing degradation plan and data acquisition instructions.

## Upstream Change Response

> See [Reference/decision-tables.md](Reference/decision-tables.md#upstream-change-response) for the upstream change impact table and downstream notification mechanism table.
