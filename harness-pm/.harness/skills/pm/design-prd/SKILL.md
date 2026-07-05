---
name: design-prd
description: Use when you need to generate a standardized PRD document. PRD auto-generation and management, generating standardized PRD documents based on requirements and creative solutions, providing input for subsequent IA, flow, and prototype design. Uses a single unified most-complete 9-section structure and 4 quality gates.
---
# PRD Generator

## When to use
- Help me write a PRD document
- Generate a product requirements document
- How to write a requirements document
- **I already have a complete PRD and need to import it into the framework** (triggers Import Mode; see §Execution Steps → Import Mode)
- Keywords: PRD generation, product requirements document, requirements document auto-generation, PRD management, writing requirements documents, product documentation

## Outputs
- docs/product/PRD.md
- docs/product/prd.json (generated projection; never edited independently)
- memory/progress.md
- memory/knowledge-base.md

This Skill is responsible for automatically converting upstream phase outputs (user insights, opportunity definition, ideation) into PRD documents that meet quality standards, providing structured input for subsequent product design (IA, flow, prototype). Requirements collection, understanding, and prioritization are built into design-prd's Step 1-3, eliminating the need for a separate requirements management phase. Uses a single unified most-complete 9-section structure, automatically performs 4 quality gate checks to ensure document completeness, consistency, ambiguity elimination, and traceability.

## Core Principles
1. Quality gates cannot be bypassed — The 4 gates are the bottom line of PRD quality, never skipped under any circumstances
2. Single unified most-complete structure — One PRD structure for all projects; no tiering/simplification, ensuring downstream consumers (design/engineering) always get full contract data
3. Traceability chain must be connected — Each feature point can be traced back to upstream outputs and business objectives
4. Human decision authority takes precedence — When AI judgment confidence < 0.7, human confirmation is mandatory
5. Import Mode byte-level preservation — When the user chooses "keep as-is" for an audit issue, the original content MUST be preserved byte-for-byte; design-prd MUST NOT "optimize" or "rewrite" it. Only the content the user explicitly approved for modification is changed.

## Execution Steps

### Mode Detection (entry point)

At skill start, detect which mode to enter:

1. Check whether `docs/product/PRD.md` exists AND is non-empty AND is not the setup-skeleton (i.e., contains real PRD content beyond the placeholder header).
2. Check whether the user explicitly requested to import an external PRD (e.g., "I already have a PRD", "import this PRD", or provides a PRD document path).
3. If condition 1 OR 2 is met → enter **Import Mode** (below).
4. Otherwise → enter **Generate Mode** (the original flow: Step 1-4 below).

### Generate Mode (original flow)

1. [Core] Generate PRD document using the unified complete 9-section structure — No tiering; all projects use the same most-complete structure, ensuring downstream consumers always get full contract data
2. [Core] Execute 4 quality gate checks — Completeness/Consistency/Ambiguity elimination/Traceability; auto-correct if failed
3. [Conditional] Version lifecycle management — Create→Review→Finalize→Change; record change log for each change
4. [Conditional] Upstream/downstream handoff — Ensure PRD is traceable to upstream requirements, downstream design can directly consume PRD output

### Import Mode (external PRD normalization)

> **Purpose**: When the user already has a complete PRD (written outside the framework), Import Mode normalizes it into the framework's 9-section structure + prd.json projection, WITHOUT overwriting user content indiscriminately. The user decides which audit issues to fix; design-prd only modifies what the user approved.
>
> **Input/Output locations**:
> - **Input**: User's external PRD can be at ANY path (user-specified); design-prd reads from wherever the user points.
> - **Output**: Normalized PRD.md MUST be written to `docs/product/PRD.md` and prd.json to `docs/product/prd.json` (framework standard locations — all downstream consumers including session-end, handoff, and harness-engineering's design-brief and brainstorming read from these fixed paths).
>
> **Design principle**: Audit focuses on structural/mechanical problems, NOT subjective value judgments. Value signals are surfaced as advisory evidence.

**Flow summary** (detailed steps in [Reference/import-mode-flow.md](Reference/import-mode-flow.md)):

1. **IM-1 Read & parse** external PRD into 9-section structure (tolerant parsing)
2. **IM-2 Audit** — apply 5-dimension checklist from [import-audit-checklist.md](Reference/import-audit-checklist.md); produce issues list (P0-Block / P1-Advise / P2-Advisory)
3. **IM-3 User decision** (👤) — for each issue: Adopt / Keep (P1/P2 only) / Defer; record all decisions in progress.md; **circuit-breaker**: Gates must not re-challenge decided issues
4. **IM-4 Rebuild** — apply only Adopt fixes; preserve Keep content byte-for-byte; assign stable AC-xxx IDs; project prd.json with source_sha256
5. **IM-5 Quality Gates** — run 4 Gates with user-decision awareness (see [quality-checks.md](Reference/quality-checks.md#import-mode-gate-adaptation)); max 2 self-correction rounds for new issues
6. **IM-6 Output** — rebuilt PRD.md + prd.json + progress.md; ready for session-end handoff

**Key constraints**: MUST NOT overwrite "Keep" content; MUST NOT auto-correct UI overreach without approval; MUST NOT re-challenge decided issues; MUST assign stable AC-xxx IDs; MUST compute source_sha256 from final PRD.md.

**Key Output Requirements**:
- **entities describe business semantics**: define identity, lifecycle, business attributes, relationships, retention, volume, and compliance constraints. Harness-engineering owns physical schema, indexes, storage types, and migrations.
- **pages[].data_requirements describe information needs**: state what information and business operations a user needs, not API paths, cache strategy, or database fields.
- **interfaces describe business capabilities**: PM may specify actors, inputs/outputs, invariants, scale, latency expectations, and failure impact. Harness-engineering owns endpoints, protocols, error codes, dependencies, and implementation design.

## 1. PRD Complete 9-Section Structure

The schema is unified; applicability is not. For CLI, static, landing-page, prototype, and similarly narrow products, mark irrelevant domains `not_applicable`. Mark immature but required domains `deferred` with reason, owner, and `required_before`. Never invent pages, entities, flows, APIs, capacity, or DR details merely to make an array non-empty.

All projects use the same unified most-complete 9-section structure. No tiering/simplification — this ensures downstream consumers (harness-engineering's design-brief and brainstorming) always receive full contract data.

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

PRD validation uses 4 Quality Gates mapped to P0/P1/P2 severity. The unified matrix is in [Reference/quality-checks.md](Reference/quality-checks.md).

| Gate | Name | Severity | Coverage |
|------|------|----------|----------|
| Gate 1 | Completeness | P0 | Structure + field + MoSCoW + AC coverage + state coverage + NFR dimensions |
| Gate 2 | Consistency | P1 | OKR→metric→feature→AC traceability chain + priority consistency + version consistency |
| Gate 3 | Ambiguity Elimination | P1 | Quantifier quantification + dangling reference + logical contradiction + UI instruction overreach |
| Gate 4 | Traceability | P2 | Feature→upstream artifact + AC→specific metric + metric→business objective |

**Gate pass rules** (per-mode requirements):

| Gate | quick | standard | deep |
|------|-------|----------|------|
| Gate 1 (Completeness) | ✅ required | ✅ required | ✅ required |
| Gate 2 (Consistency) | ⚠️ best-effort | ✅ required | ✅ required |
| Gate 3 (Ambiguity) | ⚠️ best-effort | ✅ required | ✅ required |
| Gate 4 (Traceability) | ❌ skip | ⚠️ best-effort | ✅ required |

> "best-effort" means: attempt check, record failures, but do not block generation.

**Failure handling**:
- Gate 1 failure: Block generation, output missing items list, provide supplementation guidance
- Gate 2/3 failure: Identify inconsistent locations, output correction suggestions, record as items pending confirmation; auto-correct identifiable ambiguities (fuzzy quantifiers, dangling references); logical contradiction issues are NOT auto-corrected, output suspected_contradictions list with `needs_human_review: true`
- Gate 4 failure: Generate traceability chain breakpoint report, prompt missing traceability paths, require supplementing upstream evidence

**Traceability Chain** (Gate 2/4):
```
Strategic objectives → OKR → Key Results → Primary metrics → Functional requirements → Acceptance criteria
```

**UI instruction overreach detection** (Gate 3): Detect whether AC contains specific UI form instructions (e.g., "left sidebar", "red button"). If found, tag `needs_human_review: true` to force changing it to a business intent description (e.g., "provide a high-priority entry"), never auto-correct UI forms.

**Upstream Artifact Specific File Paths** (Gate 4):
- insight_analysis: `docs/discovery/insight.md`
- opportunity_definition: `docs/discovery/opportunity.md`
- north_star_metric: `docs/strategy/PRODUCT_STRATEGY.md` ("North Star" section)
- okr_candidates: `docs/strategy/OKR.md`

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
| **Engineering (Phase 0 design-intake)** | PRD + design asset paths + API contract | contract.json + tokens.json | prd.md + prd.json + design assets | pm-to-engineering.md → design-intake reads PRD.md + prd.json + design assets directly |
| **Engineering (Phase 1 frontend)** | Interaction logic, state design, page specs, data model | Frontend code (TDD, mock-backed) | contract.json + tokens.json + design assets | (intra-framework; no handoff) |
| **Engineering (Phase 2 backend)** | Feature specs, interface definition, data entities, boundary conditions | API + data layer + migration | contract.json (API contract) | (intra-framework; no handoff) |
| **Engineering (Phase 3 integration)** | Acceptance criteria, test cases, environment requirements | mock→real switch + e2e verification | prd.json.features[].acceptance_criteria[] | engineering-to-pm.md (reverse feedback) |

> **Handoff protocol**: pm-to-engineering.md carries PRD.md + prd.json paths + AC-xxx list + project_mode + exploration_mode + task_type + scope + design asset paths + Business Context Digest. Direct consumers (design-intake, brainstorming) read PRD directly for full context. See [docs/handoff/](docs/handoff/) templates for the consumption contract.

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
| PRD structured data | JSON | `docs/product/prd.json` | Machine-consumable version; 7 top-level arrays (features/pages/entities/user_flows/non_functional_requirements/tracking_plan/traceability); consumed by downstream harness-engineering skills (design-brief, brainstorming) |

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
