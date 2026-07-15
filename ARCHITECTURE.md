# harness-all Multi-Agent Framework Family · Architecture Design

> Version: v3.0.0 · 2026-07-06
> Positioning: A **framework collection** ("Personal AI Studio") for AI Agents — not a single framework. Each member is an independent, domain-specialized Agent framework. Current members: harness-pm (product) + harness-engineering (software engineering). The family is open-ended — data / qa / security / ML / DevOps frameworks can be added on demand using the same architecture.
> Normative domain routing: see `DOMAIN_BOUNDARIES.md`

---

## 1. Design Philosophy

### 1.0 harness-all Is a Framework Collection

harness-all is **not a single framework** — it is a collection of independent Agent frameworks. Each framework is a self-contained domain specialist (AGENTS.md + SOUL.md + constitution.md + skills/ + workflows/ + memory/ + LOOP). Frameworks collaborate via contract documents, not shared state.

| Member | Type | Domain | Status |
|:------:|------|--------|:------:|
| **harness-pm** | Core | Product · Strategy · Market · PRD · API Contract · Metrics | ✅ Built |
| **harness-engineering** | Core | Software Engineering Delivery (4 phases) | ✅ Built |
| harness-data | Extension | Data Pipeline · ETL · Metric Production | 📋 P1 To Build |
| harness-qa | Extension | Quality Assurance · Automated Testing · Performance Testing | ⚠️ P2 On Demand |
| harness-security | Extension | Security Audit · Compliance · Penetration Testing | ⚠️ P3 On Demand |

> **Open-ended architecture**: Software engineering is just one domain type. The same architecture (AGENTS.md + skills/ + LOOP + contract documents) supports any specialized Agent framework. Adding a new framework only requires: (1) the new framework itself, (2) new handoff document types between it and existing frameworks. No changes to existing frameworks.

### 1.1 Core Principle: Independence First, Contract Collaboration

```
Stage 1: Independent Work        Stage 2: Contract Collaboration    Stage 3: Orchestration (Future, non-goal)
(Current)                        (Current)                          (On demand, not a near-term goal)

┌────────────────────┐           ┌────────────────────┐             ┌────────────────────┐
│ Each framework     │           │ + contract docs    │             │ + orchestration    │
│ works alone        │ ────────► │   bridge frameworks│ ──────────► │   layer            │
│ (degraded mode OK) │           │   (pm↔engineering, │             │   (auto-scheduling)│
│                    │           │    engineering↔qa, │             │                    │
│                    │           │    engineering↔sec)│             │                    │
└────────────────────┘           └────────────────────┘             └────────────────────┘
```

**Why independent rather than unified**:

| Dimension | Unified Framework | Independent Frameworks (Current Approach) |
|------|---------|-------------------|
| Context cost | Single Agent loads all skills, context explosion | Each Agent loads only its domain skills |
| Memory pollution | Product/engineering memories mixed | Each framework has independent memory, no interference |
| Debug isolation | A bug in one domain affects everything | Frameworks are fully isolated |
| Tool adaptation | One toolchain fits all scenarios | Each framework picks tools as needed (pm doesn't need Node, engineering does) |
| Project ownership | One project, one Agent | Different frameworks can attach to different projects/working directories |
| Collaboration cost | Zero internal collaboration cost | Requires contract documents to pass (acceptable) |

**Conclusion**: Context explosion and memory pollution are the core pain points of AI Agent collaboration. Independent frameworks are the most pragmatic choice today. Even if consolidated in the future, it will most likely be "orchestration layer + independent frameworks" rather than "one unified framework".

### 1.2 Three-Layer Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  Orchestration Layer (Future, not a current goal)               │
│  • Multi-Agent scheduling · shared source of truth · cross-LOOP │
└─────────────────────────────────────────────────────────────────┘
                          ↕  contract documents
┌─────────────────────────────────────────────────────────────────┐
│  Framework Layer (Current focus)                                │
│  ┌────────────────────┐   ┌──────────────────────────────────┐  │
│  │  harness-pm        │   │  harness-engineering             │  │
│  │  (84 skills)       │   │  (25 skills, 4 phases)           │  │
│  │  Product · Strategy│   │  design-intake → frontend        │  │
│  │  · PRD · Metrics   │   │  → backend → integration         │  │
│  └────────────────────┘   └──────────────────────────────────┘  │
│  + Extension: harness-data (P1) / harness-qa (P2) / harness-security (P3) │
└─────────────────────────────────────────────────────────────────┘
                          ↕  load chain
┌─────────────────────────────────────────────────────────────────┐
│  Foundation Layer (inside each framework)                       │
│  AGENTS.md · SOUL.md · constitution.md · LOOP.md · skills/      │
└─────────────────────────────────────────────────────────────────┘
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
| Core | **harness-pm** | Strategy · Market · Product · PRD · Metrics · API Contract · Design Asset Path Collection | ✅ Built | 84 skills (80 domain + 4 meta) + 11 workflows |
| Core | **harness-engineering** | 4-Phase Engineering Delivery: design-intake → frontend → backend → integration | ✅ Built | 25 skills (21 domain + 4 meta) + 9 workflows |
| Extension | harness-data | Data Pipeline · ETL · Metric Production | 📋 P1 To Build | - |
| Extension | harness-qa | Quality Assurance · Automated Testing · Performance Testing | ⚠️ P2 On Demand | - |
| Extension | harness-security | Security Audit · Compliance · Penetration Testing | ⚠️ P3 On Demand | - |

> **Open-ended family**: The table above lists all planned members. Software engineering is one domain type; data / qa / security are different domain types, each deserving its own independent framework (rather than being a skill inside engineering). When a new framework joins, it only adds new handoff document types (e.g., `engineering-to-qa.md`, `qa-to-engineering.md`) — no changes to existing frameworks.
>
> **v3.0.0 change**: The previous design and solo frameworks have been merged into `harness-engineering` as 4 internal phases. Design assets (Figma / v0 / md / images) are now **user-owned**; PM only collects asset paths and forwards them to engineering. The `design-intake` phase inside engineering parses these assets into a machine-readable `contract.json` + `tokens.json`.

### 2.2 Core Framework Responsibility Boundaries (Non-overlap Principle)

```
┌──────────────────────┐                              ┌──────────────────────────────┐
│      harness-pm      │  pm-to-engineering.md        │      harness-engineering     │
│                      │ ───────────────────────────► │                              │
│   "Do the right      │   PRD + AC-xxx               │   "Write good code"          │
│    thing"            │   API contract               │                              │
│                      │   Design asset paths         │   Phase 0: design-intake     │
│   Strategy · Market  │   Routing fields             │   Phase 1: frontend          │
│   PRD · API contract │   (project_mode /            │   Phase 2: backend           │
│   Metrics            │    exploration_mode /        │   Phase 3: integration       │
│                      │    task_type / scope)        │                              │
│                      │                              │   Full-Stack Engineering     │
│                      │ ◄─────────────────────────── │   Delivery (4 phases)        │
│                      │  engineering-to-pm.md        │                              │
│                      │  (integration results +      │                              │
│                      │   feedback, on demand)       │                              │
└──────────────────────┘                              └──────────────────────────────┘
```

**Two core supporting chains**:

1. **pm → engineering** (`pm-to-engineering.md`): PRD + stable AC IDs + API contract + Design asset paths + Routing fields (project_mode / exploration_mode / task_type / scope) + Business Context Digest + Tracking Plan + Key Decisions
   - Consumer: harness-engineering's design-intake skill (Phase 0)
   - Scenario: All engineering work — the single entry point for any engineering delivery
   - **Routing fields** drive engineering phase execution:
     - `project_mode` (`fullstack` | `separate`): drives engineering directory layout (single repo `app/+api/+lib/` vs two roots joined by `contract.json`)
     - `exploration_mode` (`skip` | `standard` | `deep`): drives engineering phase routing depth
     - `task_type` + `scope`: suggested phase path (non-binding; engineering may deviate with user consent)
   - **Design assets are user-owned**: PM only collects paths (Figma URL / v0 export / local md / image files). PM never produces or transforms design output. If no design assets exist, the handoff carries a degraded-mode note and engineering's design-intake derives a minimal contract from PRD + user conversation.

2. **engineering → pm** (`engineering-to-pm.md`): Integration results + Implemented Features + Tech Stack + Key Decisions + Suggested Product Adjustments + Open Items
   - Consumer: harness-pm's session-start skill (auto-detect) → prd-orchestrator phase 0 Branch B (engineering feedback triage)
   - Scenario: Reverse feedback loop — when engineering discovers scope/AC impact, TECH_STACK change, architecture decision, or accumulates ≥3 bugfix LOOPs in a session
   - **Trigger (4 tiers)**: scope/AC impact OR TECH_STACK change OR architecture decision OR multi-bugfix accumulation

**Responsibility boundary iron rules**:

| Domain | Owner | Boundary Violations Forbidden |
|------|------|---------|
| Product Requirements (PRD/AC/Persona/API Contract) | harness-pm | engineering does not modify PRD; PM owns the contract spec |
| Design Assets (Figma/tokens/components) | **User** (collected by PM, consumed by engineering) | PM does not produce design output; engineering parses but does not own design source |
| Frontend Implementation (UI code/state/styling) | harness-engineering (Phase 1) | PM does not write UI code; frontend TDD is owned by ACT but visual tuning may involve human |
| Backend Implementation (API/data/migration) | harness-engineering (Phase 2) | PM does not write backend code; API contract is PM-owned but implementation is engineering-owned |
| Integration Verification (e2e/contract-check/mock-switch) | harness-engineering (Phase 3) | PM does not run integration tests; visual checks route to human (no Playwright) |
| Engineering Evidence (tests/coverage/review) | harness-engineering | PM consumes evidence via handoff, never directly inspects code |

### 2.3 Extension Framework Build Priority

| Priority | Framework | Trigger | Reason |
|--------|------|---------|------|
| P1 | harness-data | When data-driven decisions are needed | When pm need complex metric calculations, ETL pipelines are necessary |
| P2 | harness-qa | Team size > 3 | Small teams can rely on engineering's verify; larger teams need dedicated QA |
| P3 | harness-security | Compliance requirements appear | Required for finance/medical/ToB scenarios, on demand elsewhere |

---

## 3. Independent Working Mode

### 3.1 Physical Isolation

Each framework is a **fully independent directory** that can:
- Attach to different project directories (`project-A/` uses pm, `project-B/` uses engineering)
- Be loaded by different Agent instances (Agent A loads pm, Agent B loads engineering)
- Have independent `.harness/` config, memory, progress
- Have independent SOUL.md / constitution.md (personality and constitution may differ)

```
project-A/                    # Product project
├── .harness/                 # harness-pm config
│   ├── skills/               # 80 PM skills
│   ├── memory/               # PM memory
│   └── ...
└── docs/                     # PM outputs (PRD, strategy, metrics)

project-B/                    # Engineering project
├── .harness/                 # harness-engineering config
│   ├── skills/               # 21 engineering skills
│   ├── memory/               # engineering memory
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
| harness-pm | Complete product research, PRD generation, API contract spec, metrics design | Does not depend on engineering producing code to deliver PRD |
| harness-engineering | Complete 4-phase engineering delivery (design-intake → frontend → backend → integration) | Does not depend on pm's PRD (can get requirements from user conversation; design-intake supports degraded mode) |

**Self-sufficiency principle**: Each framework's design-intake / brainstorming skill must support a "no handoff document" mode, obtaining requirements from user conversation.

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
│   └── pm-to-engineering-template.md # PM → Engineering template
│
├── pm-to-engineering.md         # Contract: PM → Engineering (PRD + AC + API contract + Design paths + Routing)
└── engineering-to-pm.md         # Contract: Engineering → PM (Integration results + feedback, on demand)
```

**Note**: templates are scaffolds only (under `templates/`). The transferable unit is a self-contained `packages/<handoff_id>/` directory with contract, manifest, hashes, and artifacts.

### 4.2 Contract Document Flow Diagram

```
┌──────────────────────┐                              ┌──────────────────────────────┐
│      harness-pm      │  pm-to-engineering.md        │      harness-engineering     │
│                      │ ───────────────────────────► │                              │
│  Producer:           │   Forward contract           │  Consumer:                   │
│  • PRD.md            │   • PRD + AC-xxx             │  • design-intake (Phase 0)   │
│  • API contract      │   • API contract             │                              │
│  • Design asset      │   • Design asset paths       │  Produces:                   │
│    paths             │   • Routing fields           │  • contract.json             │
│  • Routing fields    │                              │  • tokens.json               │
│                      │                              │  • engineering code          │
│                      │ ◄─────────────────────────── │                              │
│  Consumer:           │  engineering-to-pm.md        │  Producer:                   │
│  • session-start     │   Reverse feedback           │  • session-end               │
│    (auto-detect)     │   • Integration results      │  • triggered on 4 conditions │
│  • prd-orchestrator  │   • Suggested adjustments    │    (scope/AC/TECH_STACK/     │
│    phase 0 Branch B  │   • Open items               │     architecture/≥3 bugfix)  │
└──────────────────────┘                              └──────────────────────────────┘
```

**Flow description** (arrow direction = document flow):

| Contract Document | Source Framework | Target Framework | Content |
|---------|--------|---------|------|
| pm-to-engineering.md | harness-pm | harness-engineering | PRD + AC-xxx + API contract + Design asset paths + Routing fields + Business Context Digest |
| engineering-to-pm.md | harness-engineering | harness-pm | Integration results + Implemented Features + Tech Stack + Suggested Product Adjustments + Open Items (on demand) |

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
| Product AC | `AC-<feature>-<sequence>` | harness-pm PRD | engineering | `AC-F01-001: User can log in` |
| Backend AC | `BAC-<feature>-<sequence>` | harness-engineering (Phase 2) | integration / pm | `BAC-F01-001: POST /login returns 200 on valid credentials` |
| Integration AC | `IAC-<feature>-<sequence>` | harness-engineering (Phase 3) | pm | `IAC-F01-001: Login→Dashboard flow passes e2e` |

> **Design ACs (DAC)**: In v2.x, the design framework produced `DAC-xxx` IDs. In v3.0.0, design assets are user-owned and parsed by engineering's design-intake phase. Design constraints are extracted into `contract.json` and tracked as part of the frontend AC set (still `AC-xxx` scoped to the feature). The separate `DAC-` prefix is retired; design constraints are no longer separately numbered — they flow into the engineering `contract.json` and are verified by the frontend/integration phases.

**AC flow and anti-corruption rules**:
- harness-pm's PRD produces `AC-xxx` (with `ac_id` field), the sole source of product ACs. At production time it is intercepted by the **UI Directive Overreach Gate**, strictly forbidding PM from describing specific UI layouts here.
- harness-engineering's design-intake (Phase 0) preserves PM AC IDs and meaning byte-for-byte. Design asset parsing extracts visual/interaction constraints into `contract.json` without renumbering PM ACs.
- Engineering Phase 2 (backend) may introduce `BAC-xxx` IDs for backend-specific acceptance criteria (e.g., API response codes, error handling, auth flows) not covered by product ACs.
- Engineering Phase 3 (integration) may introduce `IAC-xxx` IDs for end-to-end integration acceptance criteria.
- IDs are immutable, gaps are valid, and retired IDs are never reused or renumbered.
- Engineering's verify (Phase 3) checks `AC-xxx` (product), `BAC-xxx` (backend), and `IAC-xxx` (integration) to ensure all constraints are verified at the appropriate phase.

Scoped stable IDs prevent collisions across features and keep source/revision traceable without relying on list position.

#### 4.3.3 Dedicated Templates and Data Files

**Template files** (scaffolds for producing contract documents, all located under `docs/handoff/templates/`):

| Template | Purpose | Key Fields |
|------|------|---------|
| `templates/handoff-template.md` | Generic handoff | Phase summary / Deliverables list / AC / Open items |
| `pm-to-engineering-template.md` | PM → Engineering | Product context / PRD / stable AC IDs / API contract / Design asset paths / Routing fields (project_mode + exploration_mode + task_type + scope) / Business Context Digest |
| `engineering-to-pm-template.md` | Engineering → PM | Integration results / Implemented Features / Tech Stack / Suggested Product Adjustments / Open Items (on demand) |

**Data files** (machine-readable contract carriers, produced inside engineering workspace):

| Data File | Purpose | Producer Phase |
|---------|------|------|
| `contract.json` | Parsed design contract (component semantics + tokens + AC mapping) | Phase 0 design-intake |
| `tokens.json` | Design tokens extracted from user assets (W3C format) | Phase 0 design-intake |

### Contract Document Write Access Rules

Handoff documents enforce **Write Access Unidirectional Isolation**:

| Document | Writer | Reader |
|------|--------|--------|
| pm-to-engineering.md | harness-pm | harness-engineering |
| engineering-to-pm.md | harness-engineering | harness-pm |

**Rules**:
1. Producer writes outbound handoff document at session-end (single current pointer, archive history)
2. Consumer can only read inbound handoff documents, **modification forbidden**
3. If the consumer needs to feed back upstream, use `AskUserQuestion` to have the user relay, or write to its own outbound handoff document
4. Bidirectional read/write of the same Markdown document is not allowed

### 4.4 Multi-person Collaboration Scenarios

When multiple Agents (or multiple people + Agents) collaborate:

```
Scenario: Alice owns PM, Bob owns Engineering

1. Alice's Agent produces pm-to-engineering.md, uploads to shared storage
2. Bob manually downloads pm-to-engineering.md, places it in his docs/handoff/
3. Bob's Agent reads it, runs Phase 0 design-intake → Phase 1 frontend → Phase 2 backend → Phase 3 integration
4. Bob's Agent produces engineering-to-pm.md (if reverse feedback is triggered)
5. Alice transfers the engineering-to-pm.md back, her Agent's session-start auto-detects it
```

**Key constraints**:
- Contract documents are the **sole collaboration medium**, no reliance on real-time communication
- Upload/download is done manually by humans (current stage)
- Future orchestration layer may automate the flow (not a current goal)

---

## 5. Core Framework Details

### 5.1 harness-pm (Product Management Framework)

**Positioning**: "Do the right thing" — product exploration, market analysis, PRD generation, API contract spec, metrics operations

**Four Principles**:
1. Discovery First — Don't assume requirements; let research data speak. Implemented via the `exploration_mode` mechanism for executable exploration control (deep/standard/skip three-level mode, family-wide, see Section 6.3 state.yaml Schema)
2. Contract-Driven — PRD drives engineering; PM owns the API contract spec and design asset path collection (PM does NOT produce design output)
3. Data-Driven — Use data to reduce guessing; decision authority stays with humans
4. Closed-Loop — Metrics → Monitoring → Iteration → Feedback

**LOOP Engine**:
```
    ┌────────────────────────────────────────────────────────┐
    │                                                        │
    ▼                                                        │
  PLAN ──► RESEARCH ──► VALIDATE ──pass──► DELIVER          │
                       │                                    │
                       └─fail──► back to RESEARCH/PLAN ────┘
                                  │
                                  └─ iteration ≥ 10 ──► hard breaker
```

**Skill System** (84 skills = 80 domain + 4 meta):
- Module 1 Discovery (12): user-research / market (insight / opportunity deprecated shells deleted)
- Module 2 Business Strategy (13): business / planning (positioning / stakeholder deprecated shells deleted)
- Module 3 Ideation & Design (9): prd / validation (ideation deprecated shell deleted; visual/interaction moved to harness-engineering Phase 0)
- Module 4 Metrics Design (4): metrics
- Module 5 Metrics Operations (11): analysis / decision / experiment
- Module 6 Growth Operations (14): growth / acquisition / activation / retention / revenue
- Module 7 Monitoring & Iteration (17): monitoring / diagnosis / iteration / release

**Core Outputs**:
- `docs/product/PRD.md` — Product Requirements Document (with AC-xxx + API contract section)
- `docs/strategy/PRODUCT_STRATEGY.md` — Product Strategy
- `docs/metrics/tracking-plan.md` — Tracking Plan
- `docs/handoff/pm-to-engineering.md` — Handoff to Engineering (single handoff target)

**Signature Mechanisms**:
- **UI Directive Overreach Gate**: In the PRD output gate, forcibly intercepts PM sneaking in specific visual/interaction forms (e.g., "left sidebar", "red button"), requiring only business rules and state transitions to be described, ensuring downstream design space is not constrained at the source.
- **Engineering→PM Reverse Loop Closure**: prd-orchestrator phase 0 ("Upstream Feedback Handling") Branch B consumes `engineering-to-pm.md`. Branch B triages engineering feedback (accept/reject/defer), pre-filters items whose owning ACs are in `batch.superseded_acs` (already-decided, skip re-triage), routes accepted PRD-impact items to phase 1 (design-prd) for PRD update with all 4 quality gates (Branch B only prepares the change request — never directly writes PRD), and appends knowledge items to `memory/knowledge-base.md`. PM session-start uses batch-aware detection (4 modes: first-consumption guard / incremental / full fallback / body cross-check) to identify new vs superseded feedback.
- **Routing Fields**: PM's handoff carries 4 routing fields (`project_mode` / `exploration_mode` / `task_type` / `scope`) that drive engineering's phase execution. PM declares the suggested routing but does not enforce it — engineering may deviate with user consent.
- **Design Asset Path Collection**: PM collects design asset paths (Figma URL / v0 export / local md / image files) from the user and forwards them in `pm-to-engineering.md`. PM never produces, transforms, or augments design output. If no design assets exist, PM notes degraded mode and engineering's design-intake derives a minimal contract from PRD + user conversation.
- **FEATURES.md Cross-Framework Reconciliation**: PM and engineering maintain independent `FEATURES.md` with different status vocabularies (PM 7-state: pending/in_progress/review/approved/developing/launched/blocked; engineering 5-state: pending/in_progress/review/done/blocked). Synchronization is handoff-driven only (no direct cross-framework writes): engineering's `engineering-to-pm.md` carries an "Implemented Features" section reporting engineering-side status; PM session-start cross-checks each engineering-`done` feature against PM's `FEATURES.md` and flags drift if PM still shows `approved` while engineering reports `done` (PM should be at least `developing`). See `DOMAIN_BOUNDARIES.md` for the full reconciliation table and 4 rules.

**Known Issues and Optimization Directions**:
- ⚠️ 80 skills is still too many; the 2 remaining sub-orchestrators in Module 6 (activation/revenue) can be merged into growth's sub-phases (acquisition/retention stubs deleted)

### 5.2 harness-engineering (4-Phase Engineering Framework)

**Positioning**: "Write good code" — 4-phase engineering delivery across design-intake → frontend → backend → integration

**Karpathy's Four Principles**:
1. Think Before Coding — Don't make assumptions for the user
2. Simplicity First — No speculative abstractions
3. Surgical Changes — Only modify code that must be changed
4. Goal-Driven Execution — Loop verification until achieved

**LOOP Engine** (4-substage per phase):
```
    ┌──────────────────────────────────────────────────────────────┐
    │                                                              │
    ▼                                                              │
  PLAN ──► ACT ──► VERIFY ──pass──► REVIEW ──pass──► DONE        │
                 │                  │                              │
                 │                  └─fail──► back to ACT ────────┤
                 └─fail──► RESEARCH (iteration +1)                │
                                  │                               │
                                  └─ iteration ≥ 10 ──► hard breaker
                                     (attempt 11 forbidden; reset
                                      requires explicit user auth)
```

> Each of the 4 phases runs its own LOOP; phase checkpoint (`👤` human decision) gates phase transition. Verify-full passes → code-review → DONE.

**Four Phases**:

| Phase | Name | Input | Output | ACT Skills |
|-------|------|-------|--------|------------|
| 0 | design-intake | `pm-to-engineering.md` (PRD + API contract + design asset paths) **or** user-provided assets directly (degraded mode) | `contract.json` + `tokens.json` | design-intake |
| 1 | frontend | `contract.json` + `tokens.json` + design assets (dual-input: contract layer + visual layer) | Frontend code (TDD, mock-backed) | frontend-implementation / webapp-testing |
| 2 | backend | API contract from `contract.json` | Backend implementation (api + data + migration) | api-implementation / data-layer / migration / dependency-management |
| 3 | integration | frontend + backend | mock→real switch + e2e verification + `engineering-to-pm.md` | mock-to-real-switch / e2e-verification / contract-verify / verify / code-review / product-engineering-review |

**Phase 0 design asset types** (user-owned; PM collects paths in family mode):

| Asset type | Examples | Phase 0 route |
|------------|----------|---------------|
| Image | `.png` / `.jpg` / `.webp` (screenshots, sketches, mockups, Figma exports) | Multimodal extraction (color / typography / spacing / layout) |
| Code | v0 export, `tailwind.config.js`, `theme.ts`, `globals.css`, shadcn `components.json` | Code parsing (extract tokens + component structure) |
| Markdown | `*.md` design specs with structured sections | Markdown structuring |
| Figma | Figma URL / export (used as visual reference in Phase 1) | Path forwarded to Phase 1 dual-input |

> **Degraded mode**: when no design assets exist, Phase 0 produces `contract.json` + `tokens.json` based on PRD only; visual fidelity is marked as 👤 human-adjusted in Phase 1.

**Phase Checkpoint Mechanism**:
- Each phase produces a lightweight `phase-N-report.md` (inter-phase handoff within the same workspace)
- `state.yaml` records `substage_progress` to track phase completion
- Phase advance requires explicit user confirmation (`👤` human decision point)
- No silent phase transitions

**Project Mode** (drives directory layout):
- **fullstack** (Next.js / Remix): one repo, `app/` (frontend) + `api/` (backend) + `lib/` (shared)
- **separate** (React + Express): two roots, `contract.json` is the single source of truth joining them

**Skill System** (25 skills = 21 domain + 4 meta):
- design-intake (1): design-intake — Phase 0 ACT; parses user design assets into contract.json + tokens.json
- frontend (2): frontend-implementation / webapp-testing — Phase 1 ACT
- backend (4): api-implementation / data-layer / migration / dependency-management — Phase 2 ACT
- integration (6): mock-to-real-switch / e2e-verification / contract-verify / verify / code-review / product-engineering-review — Phase 3 ACT
- engineering (8): brainstorming / writing-plans / test-driven-development / test-coverage / systematic-debugging / performance-optimization / writing-skills / writing-documentation — cross-phase planning + TDD + debugging + docs
- meta (4): session-start / session-end / skill-maintenance / memory-maintenance

**Loop Types** (5 types):
- `feature` — New feature development
- `bugfix` — Bug fix
- `refactor` — Refactoring
- `optimize` — Performance optimization
- `migration` — Code/framework/data migration

**Core Outputs**:
- `docs/product/PROJECT.md` — Product requirements (engineering perspective; produced by harness-pm, consumed by engineering)
- `docs/engineering/TECH_STACK.md` — Tech stack
- `docs/engineering/ENGINEERING_PLAN.md` — Product-level engineering plan (feature inventory + shared infrastructure + dependency graph)
- `.harness/loops/specs/<feature>/spec.md` — Single-feature spec (with AC + BAC + IAC)
- `contract.json` — Parsed design contract (Phase 0 output)
- `tokens.json` — Design tokens (Phase 0 output)
- `phase-N-report.md` — Inter-phase report (lightweight, same workspace)

**Signature Mechanisms**:
- **Dual-input Mode**: Frontend agent (Phase 1) simultaneously reads the contract layer (`contract.json` parsed from design assets) AND the visual layer (original design assets — Figma / v0 / md / images). This ensures visual fidelity to the original design, not just the parsed contract.
- **TDD Hard Rule**: if implementation code is found to exist before a failing test, delete that implementation and return to RED. Frontend TDD is owned by ACT; visual tuning may involve human intervention (no Playwright — visual checks route to 👤 human).
- **AC Status Tracking**: spec.md ACs carry a `[status: pending|done|superseded]` suffix; code-review owns the `done` transition, enabling session-start 1a AC Change Impact Analysis to identify affected tasks
- **AC Change Impact Analysis**: on accepting a handoff that `supersedes` an already-consumed one, session-start uses the envelope `batch` field as the primary change signal (with first-consumption guard). For incremental batches, `batch.added_acs` route through the Plan pipeline, `batch.modified_acs` are treated as added (new ID) + superseded (old ID), `batch.superseded_acs` mark owning task ACs as `[status: superseded]` (done tasks create fix tasks, never reopen), `batch.unchanged_acs` keep their evidence.
- **bugfix Contract Change Detection**: when a bugfix changes the API contract, the workflow prompts the user to upgrade to a `refactor` flow (contract changes have wider blast radius than pure bug fixes).
- **Branch Isolation**: before any code mutation, work happens on a dedicated branch — standalone tasks use `feature/<task-id>`, product-level nested tasks share `feature/<product-task-id>`. Subsequent delivery rounds (incremental PM→engineering handoffs after MVP) use `feature/<product-task-id>-iter-<N>` to keep iteration history auditable.
- **Engineering→PM Reverse Feedback Trigger (4 tiers)**: engineering's session-end emits `engineering-to-pm.md` when ANY of the following is true — (1) scope/AC impact: implemented feature deviates from pm-to-engineering ACs, or new AC-xxx is proposed, or existing AC is infeasible; (2) TECH_STACK change: `TECH_STACK.md` was modified; (3) architecture decision: a cross-feature or non-reversible architectural choice was made; (4) multi-bugfix accumulation: ≥3 bugfix LOOPs accumulated in a session without triggering tier 1-3. When none trigger, session-end may skip publication entirely.
- **Nested Task Switch Protocol**: product-level `current_nested_task` transitions require 4 gates (completion / worktree cleanliness / branch strategy / update + log)
- **Fix Task Exception**: when product-engineering-review finds a Critical issue in a `done` nested task, the done task is NOT re-opened; a `<original-task-id>-fix-<N>` task is created with inherited ACs marked `[status: pending]` for re-verification
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

# Optional (Engineering only — 4-phase tracking)
substage_progress:                          # Engineering: tracks phase completion
  phase_0: "done"
  phase_1: "in_progress"
  phase_2: "pending"
  phase_3: "pending"
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
> | engineering | Technical solutions and requirement boundaries |

### 6.4 Security Red Lines Unified Specification

All frameworks' `security.md` must include:

| Forbidden | Reason |
|------|------|
| Hardcoded secrets | Secret leakage risk |
| `rm -rf` | Accidental deletion risk |
| `curl \| sh` | Supply chain attack risk |
| Modifying `.git/hooks/` | Breaks git hook integrity |
| Bypassing Quality Gates | Output quality out of control |

Each framework may extend additional red lines by domain.

### 6.5 Cross-platform Compatibility Specification

All frameworks must follow:

- **Agent tools first**: All flows prefer Read/Write/Edit/Glob/Grep tools
- **bash optional fallback**: Scripts have bash availability checks, auto-skip on Windows
- **No dependency on PowerShell-specific syntax**
- **install.sh checks**: git (BLOCK level) + Node.js (WARN level, on demand)

---

## 7. Contract Protocol Details

### 7.1 PM → Engineering Contract

**File**: `docs/handoff/pm-to-engineering.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Phase Summary | ✅ | What this delivery contains |
| Deliverables List | ✅ | PRD path, API contract path, tracking plan path |
| AC-xxx List | ✅ | Engineering ACs, for spec.md to reuse |
| API Contract | ✅ | PM-owned business capability contract (actors / invariants / scale / latency expectations / failure impact). Technical endpoints, protocols, error codes, and OpenAPI 3.0 (deep mode) are derived by Engineering in Phase 0/2; PM does not own technical interface design. |
| Business Context Digest | ✅ | Engineering-relevant business constraints, scale, concurrency, and performance expectations |
| Design Asset Paths | ✅ | User-owned design assets (Figma URL / v0 export / local md / image files); PM collects paths only, never produces design output. Empty list = degraded mode (engineering derives minimal contract from PRD) |
| Routing Fields | ✅ | `project_mode` (fullstack/separate) + `exploration_mode` (skip/standard/deep) + `task_type` + `scope` — drives engineering phase execution |
| Key Decisions | ✅ | Decision + rationale + impact scope |
| Open Items | ✅ | Questions for engineering to confirm |
| Suggested Next Step | ✅ | What engineering can do |

**Consumer**: harness-engineering's design-intake skill (Phase 0)

### 7.2 Engineering → PM Contract

**File**: `docs/handoff/engineering-to-pm.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Phase Summary | ✅ | One-sentence summary of what was done and what was fed back |
| Engineering Metrics & Issues | ✅ | LCP/INP/API latency/coverage/known bugs/tech debt with target values |
| Issues & Adjustments | ✅ | Merged section with sub-tables: (a) User Feedback Themes — dev observations + early user signals; (b) Technical Constraints Discovered — constraints + rationale + impact scope + suggested adjustment; (c) Suggested Product Adjustments — engineering-side suggestions with `Change` column (`[added]`/`[unchanged]`/`[modified]`/`[superseded]`) and affected AC-xxx, PM retains PRD decision rights; (d) Open Items — issues for PM to handle or confirm with engineering |
| Implementation Summary | ✅ | Merged section with sub-tables: (a) Tech Stack — tech stack / code repository / current version; (b) Implemented Features — Feature ID / Feature / Status (`pending`/`in_progress`/`review`/`done`) / Path/Endpoint / Notes, consumed by PM session-start for FEATURES.md Cross-Framework Reconciliation; (c) Key Decisions — decision + rationale + impact scope |
| Product-Level Engineering Feedback | ○ | Product-level handoff only (new-product-engineering workflow); aggregates cross-feature engineering metrics and suggested product adjustments. Single-feature handoff omits this section |
| Risk Notes | ✅ | Risk + level + mitigation |
| envelope.batch | ✅ | Required for batch-aware detection. `ac_ids` MUST be the FULL SET (= `added_acs` + `modified_acs` new IDs + `unchanged_acs`); superseded AC IDs do NOT appear in `ac_ids` |

**Consumer**: harness-pm's session-start skill (auto-detect) → prd-orchestrator phase 0 Branch B (engineering feedback triage)

**Trigger (4 tiers)**: scope/AC impact OR TECH_STACK change OR architecture decision OR multi-bugfix accumulation (≥3 bugfix LOOPs in a session). When none trigger, session-end may skip publication entirely (see §5.2).

---

## 8. Collaboration Workflow Examples

### 8.1 Building a New Product from 0 to 1 (Two-Framework Collaboration)

```
Phase 1: Product Definition (harness-pm)
├── new-product workflow
├── Output: PRD.md (with AC-xxx + API contract section) / PRODUCT_STRATEGY.md / Persona
├── Collect: user design asset paths (Figma / v0 / md / images)
└── Output: pm-to-engineering.md (PRD + AC + API contract + design paths + routing)

Phase 2: Engineering Delivery (harness-engineering)
├── new-product-engineering workflow (plans all features + shared infrastructure first)
├── Phase 0: design-intake — parse design assets → contract.json + tokens.json
├── Phase 1: frontend — TDD with mock API, dual-input (contract + visual)
├── Phase 2: backend — implement API + data layer + migrations
├── Phase 3: integration — mock→real switch + e2e + contract-verify + code-review
└── Output: ENGINEERING_PLAN.md + code + tests + spec.md (with AC + BAC + IAC)
```

### 8.2 Iterating on an Existing Product (PM + Engineering Collaboration)

```
Phase 1: Iteration Requirements (harness-pm)
├── iteration workflow
├── Output: PRD update (new/modified AC-xxx)
└── Output: replace the pm-to-engineering.md current pointer and archive the superseded contract

Phase 2: Engineering Implementation (harness-engineering)
├── new-feature / bugfix workflow
├── Consumes: pm-to-engineering.md (updated version)
├── Branch: feature/<product-task-id>-iter-<N> (iteration branch strategy; see §5.2)
└── Output: code updates + engineering-to-pm.md (engineering feedback, batch field populated)

Phase 3: Reverse Loop Closure (harness-pm)
├── session-start auto-detects engineering-to-pm.md and applies batch-aware detection
├── Routes accepted consumption to prd-orchestrator phase 0 Branch B
├── Branch B triages each feedback item (accept/reject/defer); pre-filters items whose owning ACs are in batch.superseded_acs
├── PRD-impact items → phase 1 (design-prd) with 4 quality gates
└── Knowledge items → memory/knowledge-base.md
```

> Iteration branch strategy note: when Phase 1 delivers an incremental pm-to-engineering.md (`batch.type: incremental`), Phase 2 uses `feature/<product-task-id>-iter-<N>` (N = batch.id) to keep iteration history auditable without polluting the original `feature/<product-task-id>` branch. Phase 3 closes the reverse loop: PM session-start routes `engineering-to-pm.md` to prd-orchestrator phase 0 Branch B, which triages and routes accepted items per type — never directly editing PRD (preserving the 4-gate invariant).

### 8.3 Full-Stack vs Separated Mode

```
Full-Stack Mode (Next.js / Remix):
├── Single repo: app/ (frontend) + api/ (backend) + lib/ (shared)
├── Phase 0: design-intake → contract.json
├── Phase 1: frontend (app/) — TDD with mock API
├── Phase 2: backend (api/) — implement API
└── Phase 3: integration — mock→real switch (config flip only, no code change)

Separated Mode (React + Express):
├── Two roots: frontend/ + backend/
├── contract.json is the single source of truth joining them
├── Phase 0: design-intake → contract.json (shared)
├── Phase 1: frontend (frontend/) — TDD with mock API
├── Phase 2: backend (backend/) — implement API per contract.json
└── Phase 3: integration — mock→real switch + contract-verify (frontend ↔ backend ↔ PRD)
```

---

## 9. Relationship with Single-Framework Usage

### 9.1 Single-Framework User Perspective

If a user uses only one framework (e.g., only harness-engineering for engineering):

- **Fully self-sufficient**: design-intake / brainstorming gets requirements from user conversation, does not depend on pm-to-engineering.md
- **No contract documents**: docs/handoff/ directory is empty or only has README
- **Degraded design mode**: if no user design assets provided, design-intake derives a minimal contract from PRD + user conversation
- **Independent work**: All flows close the loop within the framework

### 9.2 Multi-Framework User Perspective

If a user uses both frameworks (pm + engineering):

- **Contract collaboration**: Pass requirements via documents under docs/handoff/
- **Manual flow**: User manually copies contract documents to target framework's docs/handoff/
- **Independent memory**: Each framework has its own memory, no interference

### 9.3 Multi-person Collaboration Perspective

If multiple people + multiple Agents collaborate:

- **One framework per person**: Alice uses pm, Bob uses engineering
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

### 10.2 Reliability Optimization (v2.2, completed)

- ✅ harness-pm's 5 overreaching design skills deleted + design-orchestrator split into prd-orchestrator
- ✅ harness-pm's 5 deprecated shell orchestrators deleted
- ✅ Cross-framework contract anti-overreach guardrails deployed
- ✅ Batch Delivery Protocol added (envelope `batch` field + first-consumption guard)
- ✅ Solo→PM Reverse Loop Closure (prd-orchestrator phase 0 Branch B)
- ✅ Skill-count baseline & shared-file drift cleanup

### 10.3 v3.0.0 Restructuring (this round, 2026-07-06)

**Motivation**: The v2.x 3-framework architecture (pm + design + solo) had two structural problems:
1. **solo's UI fidelity was poor** — engineering received design via a parsed contract layer but lost the visual fidelity of the original design assets, producing UI that "felt weird" and didn't match the design.
2. **Frontend/backend parallel development was blocked** — solo was a single engineering framework with no internal phase separation, making it hard to parallelize frontend and backend work or to verify their integration.

**Resolution**: Consolidated into a 2-framework architecture with 4 internal phases:
- ✅ Deleted the legacy design framework directory entirely (design assets are now user-owned)
- ✅ Deleted the legacy solo framework; merged its engineering skills into `harness-engineering`
- ✅ Built `harness-engineering` with 4 phases: Phase 0 design-intake → Phase 1 frontend → Phase 2 backend → Phase 3 integration
- ✅ **Dual-input mode**: frontend agent (Phase 1) simultaneously reads the parsed contract (`contract.json`) AND the original visual design assets (Figma / v0 / md / images), ensuring visual fidelity
- ✅ PM no longer produces design output; PM only collects design asset paths and forwards them to engineering
- ✅ New handoff documents: `pm-to-engineering.md` (forward) + `engineering-to-pm.md` (reverse feedback)
- ✅ New routing fields: `project_mode` (fullstack/separate) + `exploration_mode` (skip/standard/deep) + `task_type` + `scope`
- ✅ New AC types: `BAC-xxx` (backend AC) + `IAC-xxx` (integration AC); `DAC-xxx` retired (design constraints flow into `contract.json`)
- ✅ Phase checkpoint mechanism: `phase-N-report.md` + `state.yaml.substage_progress`
- ✅ Framework = workspace: engineering is a single workspace; no cross-workspace coordination needed within the 4 phases
- ✅ validate.ps1 rewritten for 2-framework consistency checking
- ✅ bugfix contract change detection: bugfix that changes API contract prompts upgrade to refactor flow
- ✅ All root documents updated (ARCHITECTURE / README / README.zh / DOMAIN_BOUNDARIES / HANDOFF_PROTOCOL)

### 10.4 Mid-term Evolution (v3.1+, 1-2 months)

- 📋 harness-data built (P1, data pipeline framework)
- 📋 Contract document versioning (support historical tracing, without breaking "only read latest" principle)
- 📋 OpenAPI 3.0 deep-mode contract generation (auto-generate from PRD in deep exploration mode)

### 10.5 Long-term Evolution (v4.0, 3-6 months, on demand)

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

### Decision 2: 2-Framework + 4-Phase vs 4-Framework Separation (v3.0.0)

**Choice**: 2 frameworks (pm + engineering) with 4 internal phases
**Rationale**:
- v2.x's 3-framework split (pm/design/solo) had poor UI fidelity and blocked frontend/backend parallelism
- 4-framework split (pm/frontend/backend/integration) would create cross-workspace coordination overhead and contract documents between every phase
- Consolidating engineering into one framework with 4 phases keeps the workspace unified; phase transitions use lightweight `phase-N-report.md` instead of full handoff envelopes
- Design assets are user-owned (Figma/v0/md), removing the need for a separate design framework

**Trade-off**:
- Engineering framework is larger (25 skills vs solo's 19), but INDEX.md grouping by phase keeps it navigable
- Phase 0 design-intake is a new skill, but it replaces the entire legacy design framework (net reduction)

### Decision 3: Contract Documents vs Shared Source of Truth

**Choice**: Contract documents (current stage)
**Rationale**:
- Shared source of truth requires orchestration layer support; no orchestration layer currently
- Contract documents are the lowest-coupling collaboration method
- For multi-person collaboration, manual upload/download of contract documents suffices

**Trade-off**:
- Serialization overhead (Agent produces → document → Agent parses)
- Information loss (mitigated by structured fields)

**Future evolution**: When the orchestration layer is ready, a shared source of truth can gradually replace some contract documents.

### Decision 4: Dual-Input Mode for Frontend (v3.0.0)

**Choice**: Frontend agent (Phase 1) reads both `contract.json` AND original design assets
**Rationale**:
- v2.x's design→engineering handoff passed only a parsed contract layer; visual fidelity was lost
- Original design assets (Figma / v0 / md / images) carry visual nuance that no contract can fully capture
- Dual-input ensures the frontend agent can match the design visually, not just structurally

**Trade-off**:
- Frontend agent must process two input sources (slightly more context)
- Visual tuning may require human intervention (no Playwright; visual checks route to 👤 human)

### Decision 5: AC Numbering Cross-Framework Alignment

**Choice**: AC-xxx (product) + BAC-xxx (backend) + IAC-xxx (integration)
**Rationale**:
- PRD's AC-xxx is the source; engineering preserves without renumbering
- Backend-specific acceptance criteria (API response codes, error handling) receive BAC-xxx prefix
- Integration acceptance criteria (e2e flows) receive IAC-xxx prefix
- verify (Phase 3) checks all three sources to ensure constraints are not lost

**Trade-off**:
- spec.md has multiple AC sets, slightly more complex
- But the benefit (phase-specific verifiability) far outweighs the cost

### Decision 6: Framework = Workspace (v3.0.0)

**Choice**: Each framework is a single workspace; internal phases share one workspace
**Rationale**:
- v2.x's 3-framework split had each framework in its own workspace, requiring cross-workspace contract coordination
- 4-framework split would have the same problem, multiplied
- Consolidating engineering's 4 phases into one workspace eliminates cross-workspace coordination for phase transitions
- Phase transitions use lightweight `phase-N-report.md` (same workspace) instead of full handoff envelopes (cross-workspace)

**Trade-off**:
- All engineering code (frontend + backend + integration) lives in one workspace
- But this matches real-world full-stack development (Next.js / Remix already work this way)

---

## 12. Risk Assessment and Mitigation

### 12.1 Context Explosion Risk

**Risk**: A single framework has too many skills (e.g., harness-pm 80 skills); INDEX.md may not fit
**Mitigation**:
- INDEX.md grouped into 7 modules, each listing skill names
- Orchestrators handle orchestration; Agent loads specific pipeline skills only when needed
- Long-term: consider merging redundant orchestrators (e.g., growth's 4 sub-orchestrators)

### 12.2 Contract Document Information Loss

**Risk**: PM produces PRD → handoff document parsing → may lose information; especially the PM → Engineering link, where a pure AC list cannot convey business context
**Mitigation**:
- Contract documents use structured fields (tables/JSON) to reduce natural language ambiguity
- AC-xxx numbering aligned cross-framework, traceable
- pm-to-engineering.md adds Business Context Digest: engineering must use these business constraints during technical feasibility analysis
- Design asset paths are forwarded as-is (no transformation loss)

### 12.3 Visual Fidelity Risk (v3.0.0)

**Risk**: Even with dual-input mode, the frontend agent may not perfectly match the original design
**Mitigation**:
- Dual-input ensures the agent has both the parsed contract AND the original visual assets
- Visual tuning may involve human intervention (👤 human decision point)
- No Playwright dependency — visual checks are human-gated, not machine-gated
- Degraded mode: if no design assets, engineering derives a minimal contract from PRD + user conversation (clearly marked as degraded)

### 12.4 Multi-person Collaboration Version Conflicts

**Risk**: Multiple people modify contract documents simultaneously, versions inconsistent
**Mitigation**:
- Fixed current-pointer documents expose the latest state; immutable handoff IDs and `docs/handoff/archive/` preserve history without burdening normal consumers
- Multi-person collaboration managed via Git branches (PR merge does not overwrite mainline)
- Current stage: manual flow; future orchestration layer can handle automatically

### 12.5 Extension Framework Build Lag

**Risk**: harness-data build lag affects the full chain
**Mitigation**:
- Extension frameworks built on demand (P1/P2/P3 priority)
- Core frameworks (pm/engineering) already cover main scenarios
- Before data is built, related capabilities are backstopped by harness-engineering's verify/webapp-testing

---

## 13. Summary

harness-all is a multi-Agent framework family with **Independence First, Contract Collaboration**. The v3.0.0 stage focuses on a 2-framework architecture (pm + engineering) with engineering's 4 internal phases (design-intake → frontend → backend → integration), with cross-framework collaboration via contract documents.

**Core Value**:
- Each Agent specializes in one domain, avoiding context explosion and memory pollution
- Contract documents are the sole collaboration medium, supporting multi-person + multi-Agent collaboration
- Cross-platform compatible, Agent tools first, bash optional fallback
- Frameworks are fully independent, can attach to different projects/working directories
- Engineering's 4-phase design enables parallel frontend/backend development with integration verification

**Current Status**:
- 2 core frameworks all built (pm + engineering)
- Contract document system connected (pm↔engineering closed loop)
- AC numbering system aligned cross-framework (AC + BAC + IAC)
- LOOP engine unified specification
- Design assets are user-owned; PM collects paths; engineering parses them

**Next Priorities**:
- Short-term: stabilize 4-phase execution; refine design-intake asset parsing
- Mid-term: harness-data build (P1)
- Long-term: Orchestration layer exploration (on demand)

---

## Appendix A: Framework File Structure Comparison

| File/Directory | harness-pm | harness-engineering |
|-----------|:---:|:---:|
| AGENTS.md | ✅ | ✅ |
| SOUL.md | ✅ | ✅ |
| constitution.md | ✅ | ✅ |
| README.md | ✅ | ✅ |
| install.sh | ✅ | ✅ |
| .harness/loops/LOOP.md | ✅ | ✅ |
| .harness/skills/INDEX.md | ✅ | ✅ |
| .harness/skills/meta/ | ✅ (4 skills) | ✅ (4 skills) |
| .harness/skills/<domain>/ | ✅ (80 domain skills) | ✅ (21 domain skills) |
| .harness/skills/workflows/ | ✅ (11 workflows) | ✅ (9 workflows) |
| .harness/rules/security.md | ✅ | ✅ |
| .harness/rules/prompt-defense.md | ✅ | ✅ |
| .harness/memory/ | ✅ | ✅ |
| .harness/FEATURES.md | ✅ | ✅ |
| .harness/VERSION | ✅ | ✅ |
| .harness/templates/ | ✅ | ✅ |
| .harness/data/ | ❌ | ✅ (design CSVs) |
| .harness/craft/ | ❌ | ✅ (craft notes) |
| .harness/hooks/ | ❌ | ✅ |
| .harness/scripts/ | ❌ | ✅ |
| docs/handoff/ | ✅ | ✅ |

**Skill count note**: Each framework's total skill count = domain skills + 4 meta skills. harness-pm totals 84, harness-engineering totals 26.

## Appendix B: Contract Document Matrix

| Source \ Target | harness-pm | harness-engineering |
|-----------|:---:|:---:|
| harness-pm | - | pm-to-engineering.md |
| harness-engineering | engineering-to-pm.md (on demand) | - |

## Appendix C: LOOP Loop Type Comparison

| Framework | Loop Type | Trigger Scenario | Max Iterations |
|------|---------|---------|:---:|
| harness-pm | research | User research / market analysis | 5 |
| harness-pm | prd | PRD generation / solution design | 5 |
| harness-pm | iteration | Data-driven iteration | 3 |
| harness-pm | growth | Growth breakthrough | 3 |
| harness-pm | pivot | Strategic adjustment | 5 |
| harness-engineering | feature | New feature development | 5 |
| harness-engineering | bugfix | Bug fix | 3 |
| harness-engineering | optimize | Performance optimization | 3 |
| harness-engineering | refactor | Refactoring | 3 |
| harness-engineering | migration | Code/framework/data migration | 3 |

**Single LOOP Hard Circuit Breaker**: Unified across all frameworks at 10 iterations; stop and request human intervention when exceeded.

**Naming Convention**: Loop types are named by domain semantics to avoid cross-framework confusion.

---

**Document Version**: v3.0.0 · 2026-07-06 (2-framework + 4-phase restructuring; legacy design and solo frameworks merged into harness-engineering)
**Maintainer**: harness-all Architect
**Next Review**: At v3.1 release (harness-data build kickoff)
