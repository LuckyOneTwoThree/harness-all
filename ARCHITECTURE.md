# harness-all Multi-Agent Framework Family · Architecture Design

> Version: v2.2.1 · 2026-07-04
> Positioning: A "Personal AI Studio" framework family for AI Agents; each framework works independently and collaborates via contract documents
> Normative domain routing: see `DOMAIN_BOUNDARIES.md`

---

## 1. Design Philosophy

### 1.1 Core Principle: Independence First, Contract Collaboration

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Independent Work ──── Contract Collaboration ──── Multi-Agent Orchestration │
│   (Current stage)        (Current stage)            (Future evolution, non-goal) │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Why independent rather than unified**:

| Dimension | Unified Framework | Independent Frameworks (Current Approach) |
|------|---------|-------------------|
| Context cost | Single Agent loads all skills, context explosion | Each Agent loads only its domain skills |
| Memory pollution | Product/engineering/design memories mixed | Each framework has independent memory, no interference |
| Debug isolation | A bug in one domain affects everything | Frameworks are fully isolated |
| Tool adaptation | One toolchain fits all scenarios | Each framework picks tools as needed (pm doesn't need Node, solo does) |
| Project ownership | One project, one Agent | Different frameworks can attach to different projects/working directories |
| Collaboration cost | Zero internal collaboration cost | Requires contract documents to pass (acceptable) |

**Conclusion**: Context explosion and memory pollution are the core pain points of AI Agent collaboration. Independent frameworks are the most pragmatic choice today. Even if consolidated in the future, it will most likely be "orchestration layer + independent frameworks" rather than "one unified framework".

### 1.2 Three-Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Orchestration Layer (Future, not a current goal)            │
│  - Multi-Agent scheduling / shared source of truth / cross-framework LOOP │
└─────────────────────────────────────────────────────────────┘
                          ↕ Contract documents
┌─────────────────────────────────────────────────────────────┐
│  Framework Layer (Current focus)                             │
│  harness-pm / harness-design / harness-solo                  │
│  + Extension frameworks (data/qa/security, built on demand)  │
└─────────────────────────────────────────────────────────────┘
                          ↕ Load chain
┌─────────────────────────────────────────────────────────────┐
│  Foundation Layer (inside each framework)                    │
│  AGENTS.md / SOUL.md / constitution.md / LOOP.md / skills/  │
└─────────────────────────────────────────────────────────────┘
```

### 1.3 Applicable Scenarios

- **Personal AI Studio**: One person + multiple AI Agents, each Agent specializes in one domain
- **Small team collaboration**: Different members own different frameworks, aligned via contract documents
- **Multi-project parallelism**: Each framework can attach to different project directories without interference

---

## 2. Framework Family Overview

### 2.1 Framework Classification and Status

| Category | Framework | Responsibility | Status | Skill Count |
|------|------|------|------|---------|
| Core | **harness-pm** | Strategy · Market · Product · PRD · Metrics · Growth Monitoring | ✅ Built | 84 skills (80 domain + 4 meta) + 10 workflows |
| Core | **harness-design** | UI · Visual · Interaction · Prototype · Design System | ✅ Built | 16 skills (12 domain + 4 meta) + 8 workflows |
| Core | **harness-solo** | Engineering · TDD · Debugging · Refactoring · Verification | ✅ Built | 19 skills (15 domain + 4 meta) + 9 workflows |
| Extension | harness-data | Data Pipeline · ETL · Metric Production | 📋 P1 To Build | - |
| Extension | harness-qa | Quality Assurance · Automated Testing · Performance Testing | ⚠️ P2 On Demand | - |
| Extension | harness-security | Security Audit · Compliance · Penetration Testing | ⚠️ P3 On Demand | - |

### 2.2 Core Framework Responsibility Boundaries (Non-overlap Principle)

```
┌─────────────┐  PRD + Persona + AC   ┌─────────────┐  design-to-solo.md   ┌─────────────┐
│ harness-pm  │ ────────────────────> │harness-design│ ───────────────────> │ harness-solo│
│ "Do the     │                        │ "Make it     │ + component-contract│ "Write good │
│  right      │                        │  look good   │ + tokens.json       │  code"      │
│  thing"     │  PRD + AC + Tracking   │  and usable" │                     │             │
│             │ ───────────────────────────────────────────────────────> │             │
└─────────────┘                        └─────────────┘                     └─────────────┘
```

**Three core supporting chains**:

1. **pm → design** (`pm-to-design.md`): PRD + Persona + AC-xxx + Style Keywords + Tech Stack
   - Consumer: harness-design's design-brief skill
   - Scenario: When UI/visual/interaction design is needed

2. **pm → solo** (`pm-to-solo.md`): PRD + stable AC IDs + **Business Context Digest** + Tracking Plan + Key Decisions
   - Consumer: harness-solo's brainstorming skill
   - Scenario: Pure engineering projects (CLI/backend/API), or when engineering requirements start in parallel with design
   - **Business Context Digest**: PM extracts engineering-relevant constraints (e.g., data scale, concurrency, performance requirements) from user research and market analysis

3. **design → solo** (portable package with `design-to-solo.md` + `component-contract.json` + tokens + `DESIGN.md`): design assets + stable AC/DAC IDs + semantic component contract
   - Consumer: harness-solo's frontend-implementation / brainstorming / writing-plans / verify skill
   - Scenario: family-mode frontend engineering hard-depends on a ready design package. Design owns framework-neutral semantics and tokens; Solo owns `TECH_STACK.md` and `component-bindings.json`.

**Serial execution not enforced**: pm → design → solo is not the only path. Pure engineering projects can skip design and go directly pm → solo; for frontend projects, design → solo is a hard dependency (no frontend implementation without design assets).

**Responsibility boundary iron rules**:

| Domain | Owner | Boundary Violations Forbidden |
|------|------|---------|
| Product Requirements (PRD/AC/Persona) | harness-pm | design does not define PRD, solo does not modify PRD |
| Visual Design (color/typography/components) | harness-design | pm does not pick colors, solo does not hardcode values |
| Interaction Design (state machines/animations/gestures) | harness-design | pm does not define animation params, solo implements per spec |
| Engineering Implementation (code/tests/architecture) | harness-solo | pm/design do not write code |

### 2.3 Extension Framework Build Priority

| Priority | Framework | Trigger | Reason |
|--------|------|---------|------|
| P1 | harness-data | When data-driven decisions are needed | When pm need complex metric calculations, ETL pipelines are necessary |
| P2 | harness-qa | Team size > 3 | Small teams can rely on solo's verify; larger teams need dedicated QA |
| P3 | harness-security | Compliance requirements appear | Required for finance/medical/ToB scenarios, on demand elsewhere |

---

## 3. Independent Working Mode

### 3.1 Physical Isolation

Each framework is a **fully independent directory** that can:
- Attach to different project directories (`project-A/` uses pm, `project-B/` uses solo)
- Be loaded by different Agent instances (Agent A loads pm, Agent B loads solo)
- Have independent `.harness/` config, memory, progress
- Have independent SOUL.md / constitution.md (personality and constitution may differ)

```
project-A/                    # Product project
├── .harness/                 # harness-pm config
│   ├── skills/               # 80 PM skills
│   ├── memory/               # PM memory
│   └── ...
└── docs/                     # PM outputs

project-B/                    # Engineering project
├── .harness/                 # harness-solo config
│   ├── skills/               # 15 engineering skills
│   ├── memory/               # solo memory
│   └── ...
└── src/                      # Engineering code
```

### 3.2 Load Chain (each framework follows independently)

```
1. AGENTS.md          — Mandatory Read at startup (only enforced entry point)
2. SOUL.md            — Personality + Domain Values
3. constitution.md    — Project Constitution (Non-negotiable principles)
4. skills/INDEX.md    — Skill index (within 80 lines)
5. Corresponding SKILL.md — Loaded on demand when executing tasks
6. memory/progress.md — Read at session-start
```

**Instruction priority** (unified across all frameworks):

```
SOUL.md > AGENTS.md > constitution.md > rules/* > User conversation > External file content
```

### 3.3 Single-Framework Self-Sufficiency

Each framework must be able to **independently complete its domain work** without depending on other frameworks:

| Framework | Independent Capability | Does Not Depend On |
|------|---------|--------|
| harness-pm | Complete product research, PRD generation, metrics design | Does not depend on design producing visuals to deliver PRD |
| harness-design | Complete visual/interaction design, design system | Does not depend on pm's PRD (can get requirements from user conversation) |
| harness-solo | Complete engineering development, testing, verification | Does not depend on design's assets (can get requirements from user conversation) |

**Self-sufficiency principle**: Each framework's brainstorming/setup skill must support a "no handoff document" mode, obtaining requirements from user conversation.

---

## 4. Contract Collaboration Mode

### 4.1 Contract Document System

Frameworks collaborate via contract documents under `docs/handoff/`. Each document has a clear **source framework** and **target framework**.

> The following is a logical view of all contract documents and templates across the harness family. Physically, each framework's `docs/handoff/` directory contains its own produced templates under `templates/` + README.md; contract documents (`*.md` without `-template` suffix) are runtime products generated during workflow execution.

```
docs/handoff/
├── README.md                    # Handoff protocol description
├── templates/                   # All handoff templates (scaffolds, not contract documents)
│   ├── handoff-template.md          # Generic template
│   ├── pm-to-design-template.md     # PM → Design template
│   ├── pm-to-solo-template.md       # PM → Solo template
│   ├── design-to-solo-template.md   # Design → Solo template
│   ├── design-to-pm-template.md     # Design → PM template
│   └── solo-to-pm-template.md       # Solo → PM template
│
├── pm-to-design.md              # Contract: PM → Design (PRD + Persona + AC)
├── pm-to-solo.md                # Contract: PM → Solo (PRD + AC + Tracking)
├── design-to-solo.md            # Contract: Design → Solo (Design assets + AC + Component Mapping)
├── design-to-pm.md              # Contract: Design → PM (Design feedback, on demand)
├── solo-to-pm.md                # Contract: Solo → PM (Engineering feedback, on demand)
└── component-contract.json      # Contract: Design → Solo semantic component layer
```

**Note**: templates are scaffolds only (under `templates/`). The transferable unit is a self-contained `packages/<handoff_id>/` directory with contract, manifest, hashes, and artifacts.

### 4.2 Contract Document Flow Diagram

```
┌─────────────┐  pm-to-design.md    ┌─────────────┐
│ harness-pm  │ ──────────────────> │harness-design│
│             │ <─────────────────  │             │
│             │  design-to-pm (on demand) │        │
│             │                     └─────────────┘
│             │                           │
│             │                     design-to-solo.md
│             │ pm-to-solo package  + component-contract.json
│             │                           ▼
│             │ ──────────────────> ┌─────────────┐
│             │                     │ harness-solo│
│             │ <─────────────────  │             │
│             │  solo-to-pm (on demand) │         │
└─────────────┘                     └─────────────┘
```

**Flow description** (arrow direction = document flow):

| Contract Document | Source Framework | Target Framework | Content |
|---------|--------|---------|------|
| pm-to-design.md | harness-pm | harness-design | PRD + Persona + AC-xxx |
| pm-to-solo.md | harness-pm | harness-solo | PRD + AC + Tracking |
| design-to-solo.md | harness-design | harness-solo | Design assets + AC-xxx (design perspective) + Component Mapping |
| design-to-pm.md | harness-design | harness-pm | Design feedback (on demand) |
| solo-to-pm.md | harness-solo | harness-pm | Engineering feedback (on demand) |
| component-contract.json | harness-design | harness-solo | Framework-neutral component semantics |
| component-bindings.json | harness-solo | harness-solo | Tech-stack-specific code binding |

### 4.3 Contract Document Specification

#### 4.3.1 General Specification

- **Current pointer**: `<source-framework>-to-<target-framework>.md` contains exactly one latest contract
- **Version archive**: Before replacement, archive the previous contract as `archive/<handoff_id>.md`
- **Machine-readable envelope**: Each contract carries schema version, immutable handoff ID, producer/consumer, source revision, supersedes, AC IDs, batch metadata, and artifacts
- **Single latest consumption**: Downstream reads the current pointer by default; history is available for audit without polluting normal context
- **Machine-readable fields**: Key fields use structured formats (tables/JSON) for Agent parsing

#### 4.3.1a Batch Delivery Protocol

When a producer delivers an incremental handoff (e.g., PM iteration after MVP), the envelope MUST carry a `batch` field to prevent AC loss and enable consumer-side change detection:

| Field | Purpose |
|-------|---------|
| `batch.id` | Monotonic counter (1, 2, 3...) within the same producer→consumer channel |
| `batch.type` | `full` (first-time delivery) or `incremental` (subsequent deliveries) |
| `batch.added_acs` | New AC IDs introduced in this batch |
| `batch.modified_acs` | AC IDs with changed semantics (these are NEW IDs; old IDs appear in `superseded_acs`) |
| `batch.superseded_acs` | Old AC IDs replaced or withdrawn (do NOT appear in `ac_ids`) |
| `batch.unchanged_acs` | Valid AC IDs carried forward from the previous batch |

**Critical invariants**:
- `ac_ids` (envelope) MUST always be the FULL SET of valid AC IDs = `added_acs` + `modified_acs` (new IDs) + `unchanged_acs`. Never just the changed subset — this prevents AC loss if a previous handoff was never consumed.
- Superseded AC IDs do NOT appear in `ac_ids` (only their replacements do).
- Body uses a `Change` column to mark each AC as `[added]`, `[unchanged]`, `[modified]`, or `[superseded]` (with pointer to replacement).
- Consumer session-start uses `batch` as primary signal for change detection, with a first-consumption guard: if no prior handoff was consumed, ALL ACs are treated as `[added]` regardless of `batch.type`.

#### 4.3.2 AC Numbering System (Cross-framework Alignment)

| AC Type | Prefix | Source | Consumer | Example |
|---------|------|------|--------|------|
| Product AC | `AC-<feature>-<sequence>` | harness-pm PRD | design/solo | `AC-F01-001: User can log in` |
| Page design AC | `DAC-<page>-<sequence>` | harness-design | design/solo | `DAC-P01-001: 375px no overflow` |
| Global design AC | `DAC-GLOBAL-<sequence>` | harness-design | design/solo | `DAC-GLOBAL-001: contrast ≥4.5:1` |

**AC flow and anti-corruption rules**:
- harness-pm's PRD produces `AC-xxx` (with `ac_id` field), the sole source of ACs. At production time it is intercepted by the **UI Directive Overreach Gate**, strictly forbidding PM from describing specific UI layouts here.
- harness-design preserves PM AC IDs and meaning byte-for-byte. Overreach is rejected and returned through design-to-pm; Design additions receive independent scoped DAC IDs.
- IDs are immutable, gaps are valid, and retired IDs are never reused or renumbered.
- harness-solo's writing-plans consumes both as-is, no conversion.
- harness-solo's verify checks both `AC-xxx` (pure engineering) and `DAC-xxx` (design mapping) to ensure design constraints are not lost at the engineering layer.

Scoped stable IDs prevent collisions across features/pages and keep source/revision traceable without relying on list position.

#### 4.3.3 Dedicated Templates and Data Files

**Template files** (scaffolds for producing contract documents, all located under `docs/handoff/templates/`):

| Template | Purpose | Key Fields |
|------|------|---------|
| `templates/handoff-template.md` | Generic handoff | Phase summary / Deliverables list / AC / Open items |
| `pm-to-design-template.md` | PM → Design | Product type / Target audience / Tech stack / Persona / PRD path / AC-xxx / Style keywords / Out-of-scope list |
| `pm-to-solo-template.md` | PM → Solo | Product context / PRD / stable AC IDs / routing gate / tracking / Business Context Digest |
| `design-to-solo-template.md` | Design → Solo | Design assets / pages / stable AC+DAC IDs / component-contract.json |
| `solo-to-pm-template.md` | Solo → PM | Engineering feedback / implementation status / blocker list (on demand) |

**Data files** (machine-readable contract carriers, not templates):

| Data File | Purpose | Structure |
|---------|------|------|
| `component-contract.json` | Design → Solo semantic layer | Stable component IDs, neutral properties/states, token provenance, accessibility, used_by |
| `component-bindings.json` | Solo implementation layer | Stable component ID → module/name/framework property types |

### Contract Document Write Access Rules

Handoff documents enforce **Write Access Unidirectional Isolation**:

| Document | Writer | Reader |
|------|--------|--------|
| pm-to-solo.md | harness-pm | harness-solo |
| pm-to-design.md | harness-pm | harness-design |
| design-to-solo.md | harness-design | harness-solo |
| design-to-pm.md | harness-design | harness-pm |
| component-contract.json | harness-design | harness-solo |
| component-bindings.json | harness-solo | harness-solo |
| solo-to-pm.md | harness-solo | harness-pm |

**Rules**:
1. Producer writes outbound handoff document at session-end (append mode, does not overwrite history)
2. Consumer can only read inbound handoff documents, **modification forbidden**
3. If the consumer needs to feed back upstream, use `AskUserQuestion` to have the user relay, or write to its own outbound handoff document
4. Bidirectional read/write of the same Markdown document is not allowed

### 4.4 Multi-person Collaboration Scenarios

When multiple Agents (or multiple people + Agents) collaborate:

```
Scenario: Alice owns PM, Bob owns Design, Carol owns Solo

1. Alice's Agent produces pm-to-design.md, uploads to shared storage
2. Bob manually downloads pm-to-design.md, places it in his docs/handoff/
3. Bob's Agent reads it, produces design assets + design-to-solo.md
4. Carol transfers the complete validated design handoff package
5. Carol's Agent reads them, implements code
```

**Key constraints**:
- Contract documents are the **sole collaboration medium**, no reliance on real-time communication
- Upload/download is done manually by humans (current stage)
- Future orchestration layer may automate the flow (not a current goal)

---

## 5. Core Framework Details

### 5.1 harness-pm (Product Management Framework)

**Positioning**: "Do the right thing" — product exploration, market analysis, PRD generation, metrics operations

**Four Principles**:
1. Discovery First — Don't assume requirements; let research data speak. Implemented via the `exploration_mode` mechanism for executable exploration control (deep/standard/skip three-level mode, family-wide, see Section 6.3 state.yaml Schema)
2. Contract-Driven — PRD drives design, positioning drives brand
3. Data-Driven — Use data to reduce guessing; decision authority stays with humans
4. Closed-Loop — Metrics → Monitoring → Iteration → Feedback

**LOOP Engine**:
```
PLAN → RESEARCH → VALIDATE → Pass? DELIVER : Back to RESEARCH/PLAN
```

**Skill System** (84 skills = 80 domain + 4 meta):
- Module 1 Discovery (12): user-research / market (insight / opportunity deprecated shells deleted)
- Module 2 Business Strategy (13): business / planning (positioning / stakeholder deprecated shells deleted)
- Module 3 Ideation & Design (9): prd / validation (ideation deprecated shell deleted; visual/interaction moved to harness-design)
- Module 4 Metrics Design (4): metrics
- Module 5 Metrics Operations (11): analysis / decision / experiment
- Module 6 Growth Operations (14): growth / acquisition / activation / retention / revenue
- Module 7 Monitoring & Iteration (17): monitoring / diagnosis / iteration / release

**Core Outputs**:
- `docs/product/PRD.md` — Product Requirements Document (with AC-xxx)
- `docs/strategy/PRODUCT_STRATEGY.md` — Product Strategy
- `docs/metrics/tracking-plan.md` — Tracking Plan
- `docs/handoff/pm-to-solo.md` — Handoff to Engineering
- `docs/handoff/pm-to-design.md` — Handoff to Design

**Signature Mechanisms**:
- **UI Directive Overreach Gate**: In the PRD output gate, forcibly intercepts PM sneaking in specific visual/interaction forms (e.g., "left sidebar", "red button"), requiring only business rules and state transitions to be described, ensuring downstream design space is not constrained at the source.
- **Solo→PM Reverse Loop Closure**: prd-orchestrator phase 0 ("Upstream Feedback Handling") runs two parallel branches — Branch A consumes `design-to-pm.md` and Branch B consumes `solo-to-pm.md`. Branch B triages engineering feedback (accept/reject/defer), pre-filters items whose owning ACs are in `batch.superseded_acs` (already-decided, skip re-triage), routes accepted PRD-impact items to phase 1 (design-prd) for PRD update with all 4 quality gates (Branch B only prepares the change request — never directly writes PRD), stages design-impact items for session-end publication via `pm-to-design.md`, and appends knowledge items to `memory/knowledge-base.md`. PM session-start uses batch-aware detection (4 modes: first-consumption guard / incremental / full fallback / body cross-check) to identify new vs superseded feedback. This closes the previous gap where Solo-produced `solo-to-pm.md` had no PM skill route and engineering feedback was lost.
- **FEATURES.md Cross-Framework Reconciliation**: PM and Solo maintain independent `FEATURES.md` with different status vocabularies (PM 7-state: pending/in_progress/review/approved/developing/launched/blocked; Solo 5-state: pending/in_progress/review/done/blocked). Synchronization is handoff-driven only (no direct cross-framework writes): Solo's `solo-to-pm.md` carries an "Implemented Features" section reporting Solo-side status; PM session-start cross-checks each Solo-`done` feature against PM's `FEATURES.md` and flags drift if PM still shows `approved` while Solo reports `done` (PM should be at least `developing`). PM session-end may advance to `launched` only after its own launch decision. See `DOMAIN_BOUNDARIES.md` for the full reconciliation table and 4 rules.

**Known Issues and Optimization Directions**:
- ⚠️ 80 skills is still too many; the 2 remaining sub-orchestrators in Module 6 (activation/revenue) can be merged into growth's sub-phases (acquisition/retention stubs deleted)
- ✅ 5 overreaching design skills deleted + design-orchestrator split into prd-orchestrator (visual/interaction moved to harness-design)
- ✅ 5 deprecated shell orchestrators deleted (insight/positioning/ideation/opportunity/stakeholder)
- ✅ 2 empty Module 6 orchestrator stubs deleted (acquisition-orchestrator/retention-orchestrator had no SKILL.md)

### 5.2 harness-design (UI Design Framework)

**Positioning**: "Make it look good and usable" — visual design, interaction design, prototype output, design specs

**Four Principles**:
1. User-Centered — Persona-driven, no assumption of aesthetics
2. System-First — Build the design system before drawing pages
3. Accessible by Design — WCAG 2.1 AA is a hard constraint
4. Deliverable — Design assets must be implementable by engineering

**LOOP Engine** (innovation: PLAN inline + LOOP outer gate):
```
PLAN (inline) → LOOP(DESIGN → VERIFY → LINT) → LOOP outer gate(DESIGN-REVIEW + ACCESSIBILITY-AUDIT)
```

**Skill System** (16 skills = 12 design + 4 meta):
- Requirements & Recommendations: design-brief / design-recommendation
- Design System: design-system / design-system-import / design-system-refactor
- Design Output: ui-design / wireframe / component-design
- Review & Verification: verify (incl. lint) / design-review (incl. WCAG audit) / product-design-review
- Handoff: design-handoff-spec

**Loop Types** (3 types; A1: 2026-07-05 merged visual-design + interaction-design → ui-design):
- `ui-design` — Combined visual + interaction design tasks (A1)
- `wireframe` — Wireframes / low-fidelity prototypes
- `component` — Component design

**Core Outputs**:
- `docs/visual/DESIGN_BRIEF.md` — Design requirements (with AC-xxx)
- `docs/design-system/DESIGN.md` — Design system (10-section standard format)
- `docs/design-system/tokens.json` / `tokens.css` — Design tokens (W3C format)
- `docs/handoff/design-to-solo.md` — Handoff to Engineering
- `docs/handoff/component-contract.json` — Framework-neutral semantic component contract

**Signature Mechanisms**:
- **Push-back Mechanism**: The first stop when the design Agent receives requirements is to forcibly review upstream ACs. If PM is found to have violated rules by hardcoding UI layout directives, the Agent has the right to refuse and Reframe them as UX goals, while publicly displaying the cleanup record to defend professional independence.
- **Data-Driven Design Recommendations**: 8 CSV files (reasoning/products/styles/colors/typography/landing/ux-guidelines/vibes)
- **Anti AI-Slop**: Disable Inter/purple gradients/uniform border radius/Lorem ipsum, mechanically checked by verify skill's lint step using Node.js
- **Doubt-Driven Adversarial Review**: design-review uses a fresh-context sub-agent for adversarial review
- **Two-layer Contract**: Design emits neutral semantics; Solo binds them to TECH_STACK and source modules

### 5.3 harness-solo (Engineering Framework)

**Positioning**: "Write good code" — requirements exploration, TDD, debugging, verification, code review

**Karpathy's Four Principles**:
1. Think Before Coding — Don't make assumptions for the user
2. Simplicity First — No speculative abstractions
3. Surgical Changes — Only modify code that must be changed
4. Goal-Driven Execution — Loop verification until achieved

**LOOP Engine**:
```
PLAN → ACT → VERIFY → Pass? DONE : Back to PLAN/ACT
```

**Skill System** (19 skills = 15 engineering + 4 meta):
- Requirements & Planning: brainstorming / writing-plans; execution routing is integrated into test-driven-development
- Testing & Debugging: test-driven-development / test-coverage / systematic-debugging
- Frontend & Performance: frontend-implementation / webapp-testing / performance-optimization
- Migration & Dependencies: migration / dependency-management
- Verification & Review: verify / code-review / product-engineering-review
- Documentation & Skills: writing-documentation / writing-skills

**Loop Types** (5 types):
- `feature` — New feature development
- `bugfix` — Bug fix
- `refactor` — Refactoring
- `optimize` — Performance optimization
- `migration` — Code/framework/data migration

**Core Outputs**:
- `docs/product/PROJECT.md` — Product requirements (engineering perspective)
- `docs/engineering/TECH_STACK.md` — Tech stack
- `docs/engineering/ENGINEERING_PLAN.md` — Product-level engineering plan (feature inventory + shared infrastructure + dependency graph)
- `.harness/loops/specs/<feature>/spec.md` — Single-feature spec (with AC + DAC)

**Signature Mechanisms**:
- **Dual-source AC Verification**: verify checks both engineering ACs (AC-xxx) and design ACs (DAC-xxx)
- **AC Status Tracking**: spec.md ACs carry a `[status: pending|done|superseded]` suffix; code-review owns the `done` transition, enabling session-start 1a AC Change Impact Analysis to identify affected tasks
- **Design Asset Consumption Contract**: frontend-implementation joins component-contract.json with Solo-owned component-bindings.json by stable component ID; `component-bindings.json` carries a required `mode` field (`family` | `standalone-fallback`) and `component_contract_sha256` is nullable only in `standalone-fallback` mode (no design package)
- **Operating-Mode Propagation**: solo outbound handoffs carry a `mode` field in the envelope so downstream consumers can distinguish family-produced contracts from `standalone-fallback` degraded output; `validate-handoff.ps1` enforces this for solo-produced packages
- **AC Change Impact Analysis**: on accepting a handoff that `supersedes` an already-consumed one, session-start uses the envelope `batch` field as the primary change signal (with first-consumption guard: if no prior handoff was consumed, ALL ACs are treated as added). For incremental batches, `batch.added_acs` route through the Plan pipeline, `batch.modified_acs` are treated as added (new ID) + superseded (old ID), `batch.superseded_acs` mark owning task ACs as `[status: superseded]` (done tasks create fix tasks, never reopen), `batch.unchanged_acs` keep their evidence. For full batches or legacy handoffs without the `batch` field, falls back to set-diff detection. The diff is recorded in `state.yaml.ac_change` and `progress.md`
- **Design Waiver Hard Gate**: when PM declares `design_status: waived`, a bare waiver is invalid; the contract must carry a four-element `design_waiver` (approver + reason + scope + review point) or be rejected
- **Cross-package AC Traceability**: when both `pm-to-solo.md` and `design-to-solo.md` are present, solo's session-start extracts the "Inherited AC-xxx" list (PM-owned, excluding DAC-xxx) from the design handoff and verifies it is a superset of the `ac_ids` in the **`pm-to-solo.md` envelope** (the PM contract solo consumed). Separately, design's self-check in `design-handoff-spec` compares against the **`pm-to-design.md` envelope** (the PM contract design consumed). Invariant: PM MUST send identical `ac_ids` to both `pm-to-design.md` and `pm-to-solo.md` (the PRD's full AC set). Any dropped AC-xxx must have a corresponding entry in design-brief's `[AC Cleanup Log]`; otherwise the design handoff is rejected as "AC-xxx silently dropped". This closes the gap where Design could silently drop PM product logic without push-back record.
- **WCAG 2.1 AA Audit Scope Boundary**: harness-design's design-review Axis 5 performs the static-checkable subset only (contrast / keyboard nav spec / semantic labels / responsive / reduced-motion / dark mode); DOM-level verification (live focus trap behavior, runtime ARIA, real screen reader output) is deferred to harness-solo's verify stage. This prevents the pure-document design framework from over-promising on checks that require a running DOM.
- **DOM-Level WCAG Acknowledged Gap (opt-in model)**: Solo's default verify uses static code checks only (zero-dependency principle). DOM-level WCAG checks are **opt-in**: if the user has not configured an E2E tool, verify records an explicit `DOM-level WCAG checks skipped (no E2E tool configured; static subset verified)` in evidence.md — this is an auditable skip, not a silent gap. If the user configures an E2E tool (approved in constitution.md), verify invokes webapp-testing's opt-in DOM-check mode. This closes the "Design defers → Solo never executes" loop by making the boundary explicit and auditable.
- **Branch Isolation**: before any code mutation, work happens on a dedicated branch — standalone tasks use `feature/<task-id>`, product-level nested tasks share `feature/<product-task-id>` (per Nested Task Switch Protocol). Subsequent delivery rounds (incremental PM→Solo handoffs after MVP) use `feature/<product-task-id>-iter-<N>` to keep iteration history auditable without polluting the original product branch
- **Solo→PM Reverse Feedback Trigger (4 tiers)**: harness-solo's session-end emits `solo-to-pm.md` when ANY of the following is true — (1) scope/AC impact: implemented feature deviates from pm-to-solo ACs, or new AC-xxx is proposed, or existing AC is infeasible; (2) TECH_STACK change: `TECH_STACK.md` was modified (added/removed/replaced framework, library, or runtime); (3) architecture decision: a cross-feature or non-reversible architectural choice was made (state management pattern, data layer, deployment topology); (4) multi-bugfix accumulation: ≥3 bugfix LOOPs accumulated in a session without triggering tier 1-3 (prevents silent erosion of PM's mental model). When none trigger, session-end may skip solo-to-pm publication entirely
- **Nested Task Switch Protocol**: product-level `current_nested_task` transitions require 4 gates (completion / worktree cleanliness / branch strategy / update + log); prevents building downstream on incomplete upstream and WIP pollution across nested tasks
- **Fix Task Exception**: when product-engineering-review finds a Critical issue in a `done` nested task, the done task is NOT re-opened; a `<original-task-id>-fix-<N>` task is created with inherited ACs marked `[status: pending]` for re-verification, preserving the original audit trail
- **Plan-stage Gate (sole break point)**: Plan stage has exactly one unified Gate (writing-plans Gate); brainstorming does not pause independently; in family mode with PM-provided architecture/scope, the Gate is satisfied by the upstream contract without pausing
- **Long-task Exploration Auto-degradation**: in deep mode with ≥ 3 nested tasks, ⏸ exploration dialogs auto-degrade from "pause before every module" to "pause only for material decisions" to prevent dialog fatigue; 👤 human decision points remain unaffected
- **Brainstorming Conditional Skip**: when PM handoff provides an executable feature inventory with stable criteria and boundaries (family mode), brainstorming is skipped and writing-plans consumes the upstream contract directly
- **TDD Hard Rule**: if implementation code is found to exist before a failing test, delete that implementation and return to RED
- **Session Boundary Recommendation**: for deep/long tasks, writing-plans recommends starting a new session to execute the plan, preventing Plan-stage context from polluting execution focus
- **Product-Level Engineering Orchestration**: new-product-engineering workflow plans all features + shared infrastructure + dependency order before per-feature LOOPs; product-engineering-review checks cross-feature consistency (API contract / dependency / data model / config / shared module reuse / integration runnability)
- **Entropy Check**: verify checks file growth rate / LOC growth rate / dependency bloat / TODO backlog
- **git hooks**: pre-commit (secret/sensitive file/commit-msg check) + pre-push

---

## 6. Unified Foundation Layer Specification

### 6.1 Required Foundation Files for Each Framework

| File | Purpose | Mandatory |
|------|------|:---:|
| `AGENTS.md` | Mandatory read at startup, core rules + domain principles | ✅ |
| `SOUL.md` | Agent personality + domain values | ✅ |
| `constitution.md` | Project Constitution (Non-negotiable principles) | ✅ |
| `install.sh` | Cold-start install script | ✅ |
| `README.md` | Framework description | ✅ |
| `.harness/loops/LOOP.md` | Loop engine definition | ✅ |
| `.harness/skills/INDEX.md` | Skill index (within 80 lines) | ✅ |
| `.harness/skills/meta/` | 4 meta skills | ✅ |
| `.harness/rules/security.md` | Security red lines | ✅ |
| `.harness/rules/prompt-defense.md` | Prompt injection defense | ✅ |
| `.harness/memory/progress.md` | Session progress log (runtime file, install.sh creates, git ignored) | ✅ |
| `.harness/memory/knowledge-base.md` | Cross-session knowledge base | ✅ |
| `.harness/FEATURES.md` | Dynamic task status board | ✅ |
| `.harness/VERSION` | Framework version | ✅ |
| `docs/handoff/README.md` | Handoff protocol description | ✅ |
| `docs/handoff/templates/handoff-template.md` | Generic handoff template | ✅ |

### 6.2 4 Meta Skills (Unified Across All Frameworks)

| Meta Skill | Responsibility | Trigger |
|----------|------|---------|
| session-start | Session start, restore context | At the start of each session |
| session-end | Session wrap-up, archive + produce handoff document | Task complete / session end |
| skill-maintenance | Skill add/edit/remove maintenance | When skills change |
| memory-maintenance | memory/knowledge-base maintenance | Periodically / on demand |

### 6.3 LOOP Engine Unified Specification

All frameworks' LOOP must support:

- **state.yaml checkpoint resume**: Recoverable after session interruption
- **Iteration cap protection**: Request human intervention when exceeded
- **Evidence-driven**: No claiming completion without evidence
- **last_error field**: Records error on failure; reuse this field, do not add new state fields

**state.yaml Unified Schema**:

```yaml
# Required
current_task: <task-id>
iteration: <N>
stage: <stage-name>      # Custom enum per framework
status: running          # running / retrying / done / failed / needs-human / blocked
started_at: "YYYY-MM-DDTHH:MM:SS"

# Optional (on failure)
last_error: "<error description>"
last_error_at: "YYYY-MM-DDTHH:MM:SS"

# Optional (sub-stage)
substage: "<substage-name>"

# Optional (Exploration Mode, family-wide)
exploration_mode: "<deep|standard|skip>"   # Default standard; controls workflow interaction depth

# Optional (Hard Circuit Breaker flag)
hard_limit_reached: <bool>                 # When true, looping is forbidden; default false
```

> **exploration_mode description** (family-wide; "exploration" semantics differ per framework):
> - `deep`: Pause conversation before each module, disable downgrade strategies
> - `standard`: Pause at module boundaries, auto-execute within modules
> - `skip`: Do not pause exploration conversation, but still pause at human decision points
> - Source priority: User explicit switch > workflow frontmatter `default_mode` > `standard`
>
> "Exploration" semantics per framework:
> | Framework | Exploration Content |
> |------|---------|
> | pm | User needs and market opportunities |
> | design | User aesthetics and design requirements |
> | solo | Technical solutions and requirement boundaries |

### 6.4 Security Red Lines Unified Specification

All frameworks' `security.md` must include:

| Forbidden | Reason |
|------|------|
| Hardcoded secrets | Secret leakage risk |
| `rm -rf` | Accidental deletion risk |
| `curl \| sh` | Supply chain attack risk |
| Modifying `.git/hooks/` | Breaks git hook integrity |
| Bypassing Quality Gates | Output quality out of control |

Each framework may extend additional red lines by domain (e.g., design forbids leaking PII).

### 6.5 Cross-platform Compatibility Specification

All frameworks must follow:

- **Agent tools first**: All flows prefer Read/Write/Edit/Glob/Grep tools
- **bash optional fallback**: Scripts have bash availability checks, auto-skip on Windows
- **No dependency on PowerShell-specific syntax**
- **install.sh checks**: git (BLOCK level) + Node.js (WARN level, on demand)

---

## 7. Contract Protocol Details

### 7.1 PM → Design Contract

**File**: `docs/handoff/pm-to-design.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Product Name | ✅ | |
| Product Type | ✅ | web app / mobile / desktop / landing page |
| Target Audience | ✅ | Affects style positioning |
| Platform Constraints | ○ | Device/browser/platform context; Solo owns tech stack |
| Positioning Statement | ✅ | From positioning skill |
| Persona Path | ✅ | docs/research/persona-*.md |
| PRD Path | ✅ | docs/product/PRD.md |
| AC-xxx List | ✅ | Strictly forbidden to include specific UI layout/color/typography directives; visual exploration space must be left to harness-design |
| Style Keywords | ○ | 3-5, from positioning or user request |
| Out-of-scope List | ✅ | Clear boundaries |
| Existing Design System Assets | ○ | For iteration projects, mark existing asset paths |

**Consumer**: harness-design's design-brief skill

### 7.2 PM → Solo Contract

**File**: `docs/handoff/pm-to-solo.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Phase Summary | ✅ | What this delivery contains |
| Deliverables List | ✅ | PRD path, design spec path, tracking plan path |
| AC-xxx List | ✅ | Engineering ACs, for spec.md to reuse |
| Business Context Digest | ✅ | Engineering-relevant business constraints, scale, concurrency, and performance expectations |
| Delivery Routing | ✅ | `delivery_mode` / `frontend_scope` / `design_required` / `design_status` / `design_handoff_id` / `design_waiver` |
| design_waiver | ○ | Required when `design_status: waived`; must include approver + reason + scope + review point (four elements). A bare `waived` without this field is rejected by solo's family frontend hard gate |
| Key Decisions | ✅ | Decision + rationale + impact scope |
| Open Items | ✅ | Questions for engineering to confirm |
| Suggested Next Step | ✅ | What engineering can do |

**Consumer**: harness-solo's brainstorming skill

### 7.3 Design → Solo Contract

**File**: portable package containing `design-to-solo.md` + `component-contract.json`

**design-to-solo.md Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Design Asset Path | ✅ | docs/visual/<page>.md / docs/interaction/<page>.md |
| Design AC List | ✅ | AC-xxx (design perspective, e.g., "Contrast ratio ≥4.5:1") |
| Semantic Component Contract | ✅ | package-relative component-contract.json |
| Design System Path | ✅ | docs/design-system/DESIGN.md + tokens.json |
| Open Items | ✅ | Questions to confirm with engineering |

**component-contract.json + component-bindings.json Structure**:

```json
{
  "component-contract.json": {
    "component_id": "CMP-BUTTON-PRIMARY",
    "properties": { "content": { "type": "slot", "required": true } },
    "states": ["default", "hover", "disabled"],
    "token_refs": ["button.primary"],
    "used_by": ["P01", "P03"]
  },
  "component-bindings.json": {
    "component_id": "CMP-BUTTON-PRIMARY",
    "engineering_component": "Button",
    "module": "src/components/Button.tsx",
    "property_bindings": { "content": "ButtonProps.children: ReactNode" }
  }
}
```

- Design's contract is framework-neutral and tied to token/design revisions by hash.
- Solo's binding owns framework types, code names, modules, the hash of the exact design contract it binds, and a required `mode` field. `component_contract_sha256` is non-null in `family` mode (hash of `component-contract.json`) and `null` only in `standalone-fallback` mode (no design package; semantics derived from user conversation + `TECH_STACK.md`).

**Consumer**: harness-solo's brainstorming / frontend-implementation / writing-plans / verify skill

### 7.4 Solo → PM Contract

**File**: `docs/handoff/solo-to-pm.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Phase Summary | ✅ | One-sentence summary of what was done and what was fed back |
| Engineering Metrics & Issues | ✅ | LCP/INP/API latency/coverage/known bugs/tech debt with target values |
| Issues & Adjustments | ✅ | Merged section with 5 sub-tables: (a) User Feedback Themes — dev observations + early user signals; (b) Technical Constraints Discovered — constraints + rationale + impact scope + suggested adjustment; (c) Suggested Product Adjustments — engineering-side suggestions with `Change` column (`[added]`/`[unchanged]`/`[modified]`/`[superseded]`) and affected AC-xxx, PM retains PRD decision rights; (d) Design Issues — engineering-side design contract issues (empty if none), PM triages and routes accepted items to harness-design via `pm-to-design.md` (staged for session-end publication per prd-orchestrator phase 0 Branch B step 6), Solo never directly hands off to harness-design; (e) Open Items — issues for PM to handle or confirm with Solo |
| Implementation Summary | ✅ | Merged section with 3 sub-tables: (a) Tech Stack — tech stack / code repository / current version; (b) Implemented Features — Feature ID / Feature / Status (`pending`/`in_progress`/`review`/`done`) / Path/Endpoint / Notes, consumed by PM session-start for FEATURES.md Cross-Framework Reconciliation (see §5.1); (c) Key Decisions — decision + rationale + impact scope |
| Product-Level Engineering Feedback | ○ | Product-level handoff only (new-product-engineering workflow); aggregates cross-feature engineering metrics and suggested product adjustments. Single-feature handoff omits this section |
| Risk Notes | ✅ | Risk + level + mitigation |
| envelope.batch | ✅ | Required for batch-aware detection (first-consumption guard / incremental / full fallback). `ac_ids` MUST be the FULL SET (= `added_acs` + `modified_acs` new IDs + `unchanged_acs`); superseded AC IDs do NOT appear in `ac_ids` |

**Consumer**: harness-pm's session-start skill (auto-detect) → prd-orchestrator phase 0 Branch B (engineering feedback triage)

**Trigger (4 tiers)**: scope/AC impact OR TECH_STACK change OR architecture decision OR multi-bugfix accumulation (≥3 bugfix LOOPs in a session). When none trigger, session-end may skip publication entirely (see §5.3).

---

## 8. Collaboration Workflow Examples

### 8.1 Building a New Product from 0 to 1 (Three-Framework Collaboration)

```
Phase 1: Product Definition (harness-pm)
├── new-product workflow
├── Output: PRD.md (with AC-xxx) / PRODUCT_STRATEGY.md / Persona
└── Output: pm-to-design.md + pm-to-solo.md

Phase 2: Design (harness-design)
├── new-design workflow
├── Consumes: pm-to-design.md
├── Output: DESIGN_BRIEF.md / DESIGN.md / tokens.json / visual/ / interaction/
└── Output: design-to-solo package + component-contract.json

Phase 3: Engineering (harness-solo)
├── new-product-engineering workflow (plans all features + shared infrastructure first)
├── Consumes: validated PM/Design packages + component-contract.json
└── Output: ENGINEERING_PLAN.md + code + tests + spec.md (with AC + DAC)
```

### 8.2 Iterating on an Existing Product (PM + Solo Collaboration)

```
Phase 1: Iteration Requirements (harness-pm)
├── iteration workflow
├── Output: PRD update (new/modified AC-xxx)
└── Output: replace the pm-to-solo.md current pointer and archive the superseded contract

Phase 2: Engineering Implementation (harness-solo)
├── new-feature / bugfix workflow
├── Consumes: pm-to-solo.md (updated version)
├── Branch: feature/<product-task-id>-iter-<N> (iteration branch strategy; see §5.3)
└── Output: code updates + solo-to-pm.md (engineering feedback, batch field populated)

Phase 3: Reverse Loop Closure (harness-pm)
├── session-start auto-detects solo-to-pm.md and applies batch-aware detection
├── Routes accepted consumption to prd-orchestrator phase 0 Branch B
├── Branch B triages each feedback item (accept/reject/defer); pre-filters items whose owning ACs are in batch.superseded_acs
├── PRD-impact items → phase 1 (design-prd) with 4 quality gates
├── Design-impact items → staged for session-end publication via pm-to-design.md
└── Knowledge items → memory/knowledge-base.md
```

> Iteration branch strategy note: when Phase 1 delivers an incremental pm-to-solo.md (`batch.type: incremental`), Phase 2 uses `feature/<product-task-id>-iter-<N>` (N = batch.id) to keep iteration history auditable without polluting the original `feature/<product-task-id>` branch. Phase 3 closes the reverse loop: PM session-start routes `solo-to-pm.md` to prd-orchestrator phase 0 Branch B, which triages and routes accepted items per type — never directly editing PRD (preserving the 4-gate invariant) or pm-to-design.md (preserving session-end's single-write authority).

### 8.3 Design Redo (PM + Design + Solo Collaboration)

```
Phase 1: Redesign Requirements (harness-pm)
├── Output: PRD update + pm-to-design.md (redesign requirements)

Phase 2: Redesign (harness-design)
├── redesign workflow
├── Consumes: pm-to-design.md + design-system-import (existing assets)
├── Output: updated visual/ / interaction/ / DESIGN.md / tokens.json
└── Output: superseding design package + updated semantic component contract

Phase 3: Engineering Adaptation (harness-solo)
├── refactor / migration workflow
├── Consumes: design-to-solo.md (updated)
└── Output: code refactoring + test updates
```

---

## 9. Relationship with Single-Framework Usage

### 9.1 Single-Framework User Perspective

If a user uses only one framework (e.g., only harness-solo for engineering):

- **Fully self-sufficient**: brainstorming gets requirements from user conversation, does not depend on pm-to-solo.md
- **No contract documents**: docs/handoff/ directory is empty or only has README
- **Independent work**: All flows close the loop within the framework

### 9.2 Multi-Framework User Perspective

If a user uses multiple frameworks (e.g., pm + solo):

- **Contract collaboration**: Pass requirements via documents under docs/handoff/
- **Manual flow**: User manually copies contract documents to target framework's docs/handoff/
- **Independent memory**: Each framework has its own memory, no interference

### 9.3 Multi-person Collaboration Perspective

If multiple people + multiple Agents collaborate:

- **One framework per person**: Alice uses pm, Bob uses design, Carol uses solo
- **Contract document sharing**: Manually shared via Git repo / cloud drive / email, etc.
- **Version alignment**: The fixed current pointer contains the latest state; immutable historical contracts live under `docs/handoff/archive/`

---

## 10. Evolution Roadmap

### 10.1 Previous Stage (v2.1, completed)

- ✅ 3 core frameworks built independently (pm/design/solo all complete)
- ✅ Contract document system connected (pm→design→solo closed loop)
- ✅ AC numbering system aligned cross-framework (AC-xxx / DAC-xxx)
- ✅ LOOP engine unified specification (state.yaml + checkpoint resume + cap protection)
- ✅ Foundation layer unified (AGENTS/SOUL/constitution/security/meta skill)

### 10.2 Current Reliability Optimization (v2.2, completed)

- ✅ harness-pm's 5 overreaching design skills deleted + design-orchestrator split into prd-orchestrator (kept PRD + change impact analysis; visual/interaction moved to harness-design)
- ✅ harness-pm's 5 deprecated shell orchestrators deleted (insight/positioning/ideation/opportunity/stakeholder)
- ✅ harness-pm's PRD adds ac_id field, aligned with design-brief AC-xxx
- ✅ harness-solo's README skill count corrected (engineering skill mislabeled 17, actually 15, total 19)
- ✅ harness-solo's install.sh adds Node.js check
- ✅ harness-pm's core handoff templates filled in (pm-to-solo-template)
- ✅ harness-pm's AGENTS.md docs/design/ ownership violation corrected (5 overreaching entries deleted, responsibility boundary description added)
- ✅ Cross-framework contract anti-overreach guardrails deployed (PM side adds UI gate interception + Design side granted Push-back cleanup rewrite right)
- ✅ harness-design's skill count corrected (design skill mislabeled 15, actually 13, total 17)

#### 10.2.1 Reverse Loop Closure & Batch Delivery (v2.2.1, this round)

- ✅ Batch Delivery Protocol added (envelope `batch` field + first-consumption guard + `ac_ids` full-set invariant + body `Change` column); applied to PM→Solo / Design→Solo / Solo→PM / Design→PM channels
- ✅ Solo→PM Reverse Loop Closure: prd-orchestrator phase 0 restructured to "Upstream Feedback Handling" with Branch A (design-to-pm) + Branch B (solo-to-pm); Branch B routes accepted PRD-impact items to phase 1 (4 quality gates, never bypasses); pre-filters already-decided items in `batch.superseded_acs`
- ✅ PM session-start batch-aware detection (4 modes: first-consumption guard / incremental / full fallback / body cross-check) + solo-to-pm routing to Branch B
- ✅ solo-to-pm-template.md added "Implemented Features" section (FEATURES.md Cross-Framework Reconciliation data source)
- ✅ DOMAIN_BOUNDARIES.md added "FEATURES.md Cross-Framework Reconciliation" section (PM 7-state ↔ Solo 5-state mapping + 4 reconciliation rules; handoff-driven, no direct cross-framework writes)
- ✅ harness-solo session-end solo-to-pm trigger expanded to 4 tiers (scope/AC / TECH_STACK / architecture / multi-bugfix accumulation ≥3)
- ✅ harness-solo engineering-pipeline.md added iteration branch strategy `feature/<product-task-id>-iter-<N>`
- ✅ change-impact-analysis Upstream Change Response table added "Engineering feedback (solo-to-pm)" row + engineering-feedback-driven trigger path
- ✅ validate-handoff.ps1 supersedes freshness `-ge` → `-gt` (allow same-day incremental iteration); comment direction corrected in all 3 framework copies
- ✅ design-prd Import Mode added (audit → user decision → compliant PRD.md + prd.json generation, preserving user-selected content)
- ✅ ARCHITECTURE.md synchronized: §5.1 Solo→PM Reverse Loop + FEATURES.md reconciliation; §5.3 4-tier trigger + iteration branch; §7.4 Solo→PM Contract; §8.2 Phase 3 Reverse Loop Closure; this §10.2.1 record
- ✅ design-to-pm-template.md envelope added `batch` field; design session-end "Design to PM" section added batch field population guidance + Branch A routing reference (closed-loop visibility parity with solo-to-pm-template)
- ✅ iteration-orchestrator SKILL.md Inputs added `docs/handoff/solo-to-pm.md`; When to use + Core Principles + Downstream Handoff added engineering-feedback-driven trigger path
- ✅ HANDOFF_PROTOCOL.md Batch Delivery section added Solo→PM worked example
- ✅ change-impact-analysis SKILL.md Core Principles #1 / When to use / Input Source column synced with engineering-feedback-driven trigger path (stale wording removed)
- ✅ solo-to-pm-template.md Design Issues section wording unified with prd-orchestrator phase 0 Branch B step 6 (session-end staging → pm-to-design.md)

#### 10.2.2 Skill-Count Baseline & Shared-File Drift Cleanup (v2.2.2, this round)

- ✅ Deleted 2 empty PM Module 6 orchestrator stubs (acquisition-orchestrator / retention-orchestrator had no SKILL.md; were propagated to new installs by install.sh)
- ✅ Corrected harness-pm skill count: 86→84 (82→80 domain); synced README badge + §2.1 table + §5.1 + §10.2 known-issues + §12.1 + §13 directory table
- ✅ Corrected harness-design skill count: 19→17 (15→13 domain); synced README badge + §2.1 table + §5.2 + §10.2 changelog (the prior "13→15" correction was itself reversed)
- ✅ Corrected PM Module 6 orchestrator count: 5→3 (acquisition/retention stubs removed from the growth sub-orchestrator list)
- ✅ Fixed Solo README template count: 10→9 (matches actual .harness/templates/ file count)
- ✅ Resolved cross-framework validator RED on clean tree: handoff-protocol.md was missing the `## Batch Field` section in 2 frameworks (design/pm) while Solo had it — synced the family-wide batch protocol to all 3; STATE_PROTOCOL.md had PM dropping `review.md` from the active-file list and Solo injecting "triggers memory-maintenance" into the family-wide wording — both reverted to the design baseline. Validator now green (exit 0)
- ✅ validate.ps1 enhanced: added per-framework README badge check (catches skill/workflow count drift that the root-only check missed) + file-header scope note distinguishing it from validate-handoff.ps1
- ✅ PM constitution revision history: stale "82 domain skills / S2 issue to be fixed later" corrected (82→80; S2 was resolved on 06-25)

### 10.3 Mid-term Evolution (v3.0, 1-2 months)

- 📋 harness-data built (P1, data pipeline framework)
- 📋 Contract document versioning (support historical tracing, without breaking "only read latest" principle)
- 📋 Cross-framework loop type mapping description (design's visual-design → solo's feature)

### 10.4 Long-term Evolution (v4.0, 3-6 months, on demand)

- 📋 Orchestration layer exploration (multi-Agent auto-scheduling, not a current goal)
- 📋 Shared source of truth exploration (replace some contract documents, reduce information loss)
- 📋 harness-qa / harness-security built (P2/P3, on demand)

---

## 11. Key Design Decision Records

### Decision 1: Independent Frameworks vs Unified Framework

**Choice**: Independent frameworks
**Rationale**:
- Context explosion is the core pain point of AI Agent collaboration
- Memory pollution degrades Agent quality
- Independent frameworks can attach to different projects, highly flexible
- The collaboration cost of contract documents is acceptable

**Trade-off**:
- Contract documents have information loss (but mitigated by structured fields)
- Manual flow has friction (but acceptable at the current stage)

### Decision 2: Contract Documents vs Shared Source of Truth

**Choice**: Contract documents (current stage)
**Rationale**:
- Shared source of truth requires orchestration layer support; no orchestration layer currently
- Contract documents are the lowest-coupling collaboration method
- For multi-person collaboration, manual upload/download of contract documents suffices

**Trade-off**:
- Serialization overhead (Agent produces → document → Agent parses)
- Information loss (mitigated by structured fields)

**Future evolution**: When the orchestration layer is ready, a shared source of truth can gradually replace some contract documents.

### Decision 3: PLAN Inline vs Independent Skill

**Choice**: PLAN inlined into LOOP.md (harness-design approach)
**Rationale**:
- PLAN is a mandatory step of every LOOP; no need for an independent skill
- Inlining reduces skill count, lowers INDEX.md burden
- Inlining makes LOOP.md self-sufficient, not dependent on external skills

**Applicable Scope**:
- harness-design: PLAN inline ✅
- harness-solo: keeps writing-plans skill (engineering PLAN is more complex, needs an independent skill)
- harness-pm: keeps writing-plans approach (PM's PLAN involves multi-module orchestration)

### Decision 4: LOOP Outer Gate

**Choice**: harness-design introduces LOOP outer gate (design-review, which includes accessibility audit)
**Rationale**:
- verify inside LOOP is a fast check (AC + quick a11y + mechanical lint rules in one unified gate)
- design-review outside LOOP is a deep review (adversarial + semantic-level, including the WCAG 2.1 AA static-checkable subset as Axis 5; DOM-level checks deferred to harness-solo verify)
- Splitting prevents LOOP from being too heavy while ensuring quality

**Applicable Scope**:
- harness-design: LOOP outer gate ✅
- harness-solo: not introduced for now (verify is sufficient; engineering lint integrated in build commands)
- harness-pm: not introduced for now (PM has no mechanical lint need)

### Decision 5: AC Numbering Cross-Framework Alignment

**Choice**: AC-xxx (engineering) + DAC-xxx (design flowing into engineering)
**Rationale**:
- PRD's AC-xxx is the source; design-brief reuses without renumbering
- Design's ACs add D prefix when flowing into engineering to distinguish source
- verify checks both sources to ensure design constraints are not lost at the engineering layer

**Trade-off**:
- spec.md has two AC sets, slightly more complex
- But the benefit (design constraints verifiable) far outweighs the cost

### Decision 6: Two-Layer Component Contract

**Choice**: Design semantics and engineering bindings are separate versioned files joined by immutable component ID.
**Rationale**:
- harness-design does not prejudge React/Vue/Svelte or source-code structure
- harness-solo can change framework bindings without rewriting design intent
- contract and tech-stack hashes make stale bindings detectable

**Trade-off**:
- Two schemas and a binding step must be maintained, but ownership and change impact are explicit

---

## 12. Risk Assessment and Mitigation

### 12.1 Context Explosion Risk

**Risk**: A single framework has too many skills (e.g., harness-pm 80 skills); INDEX.md may not fit
**Mitigation**:
- INDEX.md grouped into 7 modules, each listing skill names
- Orchestrators handle orchestration; Agent loads specific pipeline skills only when needed
- Long-term: consider merging redundant orchestrators (e.g., growth's 4 sub-orchestrators)

### 12.2 Contract Document Information Loss

**Risk**: PM produces PRD → handoff document parsing → may lose information; especially the PM → Solo link, where a pure AC list cannot convey business context, leading to engineering architecture decisions detached from reality (e.g., "support export" without knowing data volume, choosing the wrong sync/async approach)
**Mitigation**:
- Contract documents use structured fields (tables/JSON) to reduce natural language ambiguity
- AC-xxx numbering aligned cross-framework, traceable
- design-brief's Reframe step explicitly lists "what was extracted from PRD" for verification
- **pm-to-solo.md adds Business Context Digest**: Solo must use these business constraints during technical feasibility analysis and surface conflicts with ACs

### 12.3 Multi-person Collaboration Version Conflicts

**Risk**: Multiple people modify contract documents simultaneously, versions inconsistent
**Mitigation**:
- Fixed current-pointer documents expose the latest state; immutable handoff IDs and `docs/handoff/archive/` preserve history without burdening normal consumers
- Multi-person collaboration managed via Git branches (PR merge does not overwrite mainline)
- Current stage: manual flow; future orchestration layer can handle automatically

### 12.4 Inconsistent Philosophy Across Frameworks

**Risk**: The 3 frameworks' LOOP designs differ (pm is data-driven, design is quality-driven, solo is goal-driven), may cause confusion
**Mitigation**:
- Each framework's LOOP is designed independently, optimized by domain characteristics (no forced unification)
- This architecture document explicitly explains the differences and rationale of each framework's LOOP
- Loop type naming follows domain semantics (pm uses research/prd/iteration; design uses visual/interaction/wireframe)

### 12.5 Extension Framework Build Lag

**Risk**: harness-data build lag affects the full chain
**Mitigation**:
- Extension frameworks built on demand (P1/P2/P3 priority)
- Core frameworks (pm/design/solo) already cover main scenarios
- Before data is built, related capabilities are backstopped by harness-solo's verify/webapp-testing

---

## 13. Summary

harness-all is a multi-Agent framework family with **Independence First, Contract Collaboration**. The current stage focuses on the independent build of 3 core frameworks, with cross-framework collaboration via contract documents.

**Core Value**:
- Each Agent specializes in one domain, avoiding context explosion and memory pollution
- Contract documents are the sole collaboration medium, supporting multi-person + multi-Agent collaboration
- Cross-platform compatible, Agent tools first, bash optional fallback
- Frameworks are fully independent, can attach to different projects/working directories

**Current Status**:
- 3 core frameworks all built (pm/design/solo)
- Contract document system connected (pm→design→solo→pm closed loop)
- AC numbering system aligned cross-framework
- LOOP engine unified specification

**Next Priorities**:
- Short-term: harness-pm design skill slimming (✅ done)
- Mid-term: harness-data build (P1)
- Long-term: Orchestration layer exploration (on demand)

---

## Appendix A: Framework File Structure Comparison

| File/Directory | harness-pm | harness-design | harness-solo |
|-----------|:---:|:---:|:---:|
| AGENTS.md | ✅ | ✅ | ✅ |
| SOUL.md | ✅ | ✅ | ✅ |
| constitution.md | ✅ | ✅ | ✅ |
| README.md | ✅ | ✅ | ✅ |
| install.sh | ✅ | ✅ | ✅ |
| ARCHITECTURE.md | ❌ (deleted) | ❌ | ❌ (deleted) |
| .harness/loops/LOOP.md | ✅ | ✅ | ✅ |
| .harness/skills/INDEX.md | ✅ | ✅ | ✅ |
| .harness/skills/meta/ | ✅ (4 skills) | ✅ (4 skills) | ✅ (4 skills) |
| .harness/skills/<domain>/ | ✅ (80 domain skills) | ✅ (12 domain skills) | ✅ (15 domain skills) |
| .harness/skills/workflows/ | ✅ (10 workflows) | ✅ (8 workflows) | ✅ (9 workflows) |
| .harness/rules/security.md | ✅ | ✅ | ✅ |
| .harness/rules/prompt-defense.md | ✅ | ✅ | ✅ |
| .harness/memory/ | ✅ | ✅ | ✅ |
| .harness/FEATURES.md | ✅ | ✅ | ✅ |
| .harness/VERSION | ✅ | ✅ | ✅ |
| .harness/templates/ | ✅ | ✅ | ✅ |
| .harness/data/ | ❌ | ✅ (8 CSVs) | ❌ |
| .harness/craft/ | ❌ | ✅ (4 files) | ❌ |
| .harness/hooks/ | ❌ | ❌ | ✅ |
| .harness/scripts/ | ❌ | ❌ | ✅ |
| docs/handoff/ | ✅ | ✅ | ✅ |

**Skill count note**: Each framework's total skill count = domain skills + 4 meta skills. harness-design totals 16, harness-solo 19, harness-pm 84.

## Appendix B: Contract Document Matrix

| Source \ Target | harness-pm | harness-design | harness-solo |
|-----------|:---:|:---:|:---:|
| harness-pm | - | pm-to-design.md | pm-to-solo.md |
| harness-design | design-to-pm package (on demand) | - | design-to-solo package + component-contract.json |
| harness-solo | solo-to-pm.md (on demand) | - | - |

## Appendix C: LOOP Loop Type Comparison

| Framework | Loop Type | Trigger Scenario | Max Iterations |
|------|---------|---------|:---:|
| harness-pm | research | User research / market analysis | 5 |
| harness-pm | prd | PRD generation / solution design | 5 |
| harness-pm | iteration | Data-driven iteration | 3 |
| harness-pm | growth | Growth breakthrough | 3 |
| harness-pm | pivot | Strategic adjustment | 5 |
| harness-design | ui-design | Combined visual + interaction design (A1: replaces visual-design + interaction-design) | 5 |
| harness-design | wireframe | Wireframes / low-fidelity prototypes | 5 |
| harness-design | component | Component design | 5 |
| harness-solo | feature | New feature development | 5 |
| harness-solo | bugfix | Bug fix | 3 |
| harness-solo | optimize | Performance optimization | 3 |
| harness-solo | refactor | Refactoring | 3 |
| harness-solo | migration | Code/framework/data migration | 3 |

**Single LOOP Hard Circuit Breaker**: Unified across all frameworks at 10 iterations; stop and request human intervention when exceeded.

**Naming Convention**: Loop types are named by domain semantics to avoid cross-framework confusion (e.g., harness-pm uses `prd` instead of `design` to avoid confusion with harness-design's `ui-design`; A1: former `visual-design` / `interaction-design` merged into `ui-design`).

---

**Document Version**: v2.2.1 · 2026-07-05 (white-list validator, A2 cleanup, template alignment, Prohibited section normalization)
**Maintainer**: harness-all Architect
**Next Review**: At v3.0 release (harness-data build kickoff)
