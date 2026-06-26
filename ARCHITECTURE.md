# harness-all Multi-Agent Framework Family · Architecture Design

> Version: v2.1 · 2026-06-22
> Positioning: A "Personal AI Studio" framework family for AI Agents; each framework works independently and collaborates via contract documents

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
| Memory pollution | Product/engineering/design/growth memories mixed | Each framework has independent memory, no interference |
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
│  harness-pm / harness-design / harness-solo / harness-growth │
│  + Extension frameworks (ops/data/qa/security, built on demand) │
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
| Core | **harness-pm** | Strategy · Market · Product · PRD · Metrics · Growth Monitoring | ✅ Built | 86 skills (82 domain + 4 meta) + 10 workflows |
| Core | **harness-design** | UI · Visual · Interaction · Prototype · Design System | ✅ Built | 19 skills (15 domain + 4 meta) + 7 workflows |
| Core | **harness-solo** | Engineering · TDD · Debugging · Refactoring · Verification | ✅ Built | 21 skills (17 domain + 4 meta) + 8 workflows |
| Core | **harness-growth** | Operations · Content · SEO · Growth Experiments | ✅ Built | 40 skills (36 domain + 4 meta) + 7 workflows |
| Extension | **harness-ops** | Ops · Deployment · Monitoring · Disaster Recovery | ✅ Built | 32 skills (28 domain + 4 meta) + 8 workflows |
| Extension | harness-data | Data Pipeline · ETL · Metric Production | 📋 P1 To Build | - |
| Extension | harness-qa | Quality Assurance · Automated Testing · Performance Testing | ⚠️ P2 On Demand | - |
| Extension | harness-security | Security Audit · Compliance · Penetration Testing | ⚠️ P3 On Demand | - |

### 2.2 Core Framework Responsibility Boundaries (Non-overlap Principle)

```
┌─────────────┐  PRD + Persona + AC   ┌─────────────┐  design-to-solo.md   ┌─────────────┐
│ harness-pm  │ ────────────────────> │harness-design│ ───────────────────> │ harness-solo│
│ "Do the     │                        │ "Make it     │ + component-map     │ "Write good │
│  right      │                        │  look good   │ + tokens.json       │  code"      │
│  thing"     │  PRD + AC + Tracking   │  and usable" │                     │             │
│             │ ───────────────────────────────────────────────────────> │             │
└─────────────┘                        └─────────────┘                     └─────────────┘
       │                                                                     │
       │ Metrics + Growth Strategy                                            │ Implemented Features + Tracking
       ▼                                                                     ▼
       └──────────────────> ┌─────────────┐ <──────────────────────────────┘
                            │harness-growth│
                            │ "Make it     │
                            │  used"       │
                            └─────────────┘
```

**Four core supporting chains**:

1. **pm → design** (`pm-to-design.md`): PRD + Persona + AC-xxx + Style Keywords + Tech Stack
   - Consumer: harness-design's design-brief skill
   - Scenario: When UI/visual/interaction design is needed

2. **pm → solo** (`pm-to-solo.md`): PRD + AC-xxx + **Business Context Digest** + Tracking Plan + Key Decisions
   - Consumer: harness-solo's brainstorming skill
   - Scenario: Pure engineering projects (CLI/backend/API), or when engineering requirements start in parallel with design
   - **Business Context Digest**: PM extracts engineering-relevant constraints (e.g., data scale, concurrency, performance requirements) from user-research.md / market-analysis.md to prevent Solo from making architecture decisions detached from business context

3. **design → solo** (`design-to-solo.md` + `component-map.json` + `tokens.json` + `DESIGN.md`): Design asset paths + AC-xxx (design perspective) + Component Mapping + Design Tokens + Design System
   - Consumer: harness-solo's frontend-implementation / brainstorming / writing-plans / verify skill
   - Scenario: **Frontend engineering implementation strongly depends on this contract** — component-map.json is the single source of truth for component implementation, tokens.json is the source of styling tokens, AC-xxx (design perspective) are verifiable design constraints that become DAC-xxx once entering engineering

**Serial execution not enforced**: pm → design → solo is not the only path. Pure engineering projects can skip design and go directly pm → solo; for frontend projects, design → solo is a hard dependency (no frontend implementation without design assets).

4. **solo → ops** (`solo-to-ops.md`): Image Tag + Environment Variable List + Database Migration Scripts
   - Consumer: harness-ops's deployment-pipeline / infrastructure-as-code
   - Scenario: After code is merged to main, release to production

**Responsibility boundary iron rules**:

| Domain | Owner | Boundary Violations Forbidden |
|------|------|---------|
| Product Requirements (PRD/AC/Persona) | harness-pm | design does not define PRD, solo does not modify PRD |
| Visual Design (color/typography/components) | harness-design | pm does not pick colors, solo does not hardcode values |
| Interaction Design (state machines/animations/gestures) | harness-design | pm does not define animation params, solo implements per spec |
| Engineering Implementation (code/tests/architecture) | harness-solo | pm/design do not write code |
| Growth Operations (content/SEO/experiments) | harness-growth | pm provides metrics, growth runs experiments |
| Ops Assurance (release/monitoring/disaster recovery) | harness-ops | solo does not directly operate production, must go through ops IaC |

### 2.3 Extension Framework Build Priority

| Priority | Framework | Trigger | Reason |
|--------|------|---------|------|
| P0 | harness-ops | After product launch | Ops is a hard requirement for launch; monitoring/deployment/disaster recovery are indispensable |
| P1 | harness-data | When data-driven decisions are needed | When pm/growth need complex metric calculations, ETL pipelines are necessary |
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
│   ├── skills/               # 82 PM skills
│   ├── memory/               # PM memory
│   └── ...
└── docs/                     # PM outputs

project-B/                    # Engineering project
├── .harness/                 # harness-solo config
│   ├── skills/               # 17 engineering skills
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
SOUL.md > AGENTS.md > rules/* > User conversation > External file content
```

### 3.3 Single-Framework Self-Sufficiency

Each framework must be able to **independently complete its domain work** without depending on other frameworks:

| Framework | Independent Capability | Does Not Depend On |
|------|---------|--------|
| harness-pm | Complete product research, PRD generation, metrics design | Does not depend on design producing visuals to deliver PRD |
| harness-design | Complete visual/interaction design, design system | Does not depend on pm's PRD (can get requirements from user conversation) |
| harness-solo | Complete engineering development, testing, verification | Does not depend on design's assets (can get requirements from user conversation) |
| harness-growth | Complete content production, SEO, experiments | Does not depend on pm's metric system (can get goals from user conversation) |

**Self-sufficiency principle**: Each framework's brainstorming/setup skill must support a "no handoff document" mode, obtaining requirements from user conversation.

---

## 4. Contract Collaboration Mode

### 4.1 Contract Document System

Frameworks collaborate via contract documents under `docs/handoff/`. Each document has a clear **source framework** and **target framework**.

```
docs/handoff/
├── README.md                    # Handoff protocol description
├── handoff-template.md          # Generic template (not a contract document)
├── pm-to-design-template.md     # PM → Design template (not a contract document)
├── pm-to-solo-template.md       # PM → Solo template (not a contract document)
├── pm-to-growth-template.md     # PM → Growth template (not a contract document)
├── design-to-solo-template.md   # Design → Solo template (not a contract document)
├── solo-to-growth-template.md   # Solo → Growth template (not a contract document)
├── solo-to-ops-template.md      # Solo → Ops template (not a contract document)
├── ops-to-pm-template.md        # Ops → PM template (not a contract document)
├── growth-to-pm-template.md     # Growth → PM template (not a contract document)
│
├── pm-to-design.md              # Contract: PM → Design (PRD + Persona + AC)
├── pm-to-solo.md                # Contract: PM → Solo (PRD + AC + Tracking)
├── pm-to-growth.md              # Contract: PM → Growth (Metrics + Growth Strategy)
├── design-to-solo.md            # Contract: Design → Solo (Design assets + AC + Component Mapping)
├── design-to-pm.md              # Contract: Design → PM (Design feedback, on demand)
├── solo-to-growth.md            # Contract: Solo → Growth (Implemented features + Tracking)
├── solo-to-pm.md                # Contract: Solo → PM (Engineering feedback, on demand)
├── solo-to-ops.md               # Contract: Solo → Ops (Deployment contract, env vars and DB migration)
├── ops-to-pm.md                 # Contract: Ops → PM (SLA report, incident post-mortem)
├── growth-to-pm.md              # Contract: Growth → PM (Experiment results + Data feedback)
└── component-map.json           # Contract: Design → Solo (Explicit mapping layer, machine-readable)
```

**Note**: Template files (`*-template.md`) are scaffolds for producing contract documents and do not themselves participate in cross-framework flow; contract documents (`*-to-*.md` / `component-map.json`) are the actual collaboration media that get passed.

### 4.2 Contract Document Flow Diagram

```
┌─────────────┐  pm-to-design.md    ┌─────────────┐
│ harness-pm  │ ──────────────────> │harness-design│
│             │ <─────────────────  │             │
│             │  design-to-pm (on demand) │        │
│             │                     └─────────────┘
│             │                           │
│             │                     design-to-solo.md
│             │ pm-to-solo.md       + component-map.json
│             │                           ▼
│             │ ──────────────────> ┌─────────────┐
│             │                     │ harness-solo│
│             │ <─────────────────  │             │
│             │  solo-to-pm (on demand) │         │
└─────────────┘                     └─────────────┘
        ▲                                 │
        │ growth-to-pm.md                 │ solo-to-growth.md
        │                                 ▼
        │                         ┌─────────────┐
        │  pm-to-growth.md        │harness-growth│
        └────────────────────────>│             │
        ▲                         └─────────────┘
        │ ops-to-pm.md                    ▲
        │                                 │ solo-to-ops.md
        │                         ┌─────────────┐
        └──────────────────────── │ harness-ops │
                                  └─────────────┘
```

**Flow description** (arrow direction = document flow):

| Contract Document | Source Framework | Target Framework | Content |
|---------|--------|---------|------|
| pm-to-design.md | harness-pm | harness-design | PRD + Persona + AC-xxx |
| pm-to-solo.md | harness-pm | harness-solo | PRD + AC + Tracking |
| pm-to-growth.md | harness-pm | harness-growth | Metrics + Growth Strategy |
| design-to-solo.md | harness-design | harness-solo | Design assets + AC-xxx (design perspective) + Component Mapping |
| design-to-pm.md | harness-design | harness-pm | Design feedback (on demand) |
| solo-to-growth.md | harness-solo | harness-growth | Implemented features + Tracking |
| solo-to-pm.md | harness-solo | harness-pm | Engineering feedback (on demand) |
| solo-to-ops.md | harness-solo | harness-ops | Image Tag + Environment Variable List + Database Migration Scripts |
| ops-to-pm.md | harness-ops | harness-pm | SLA report + Incident Post-mortem |
| growth-to-pm.md | harness-growth | harness-pm | Experiment results + Data feedback |
| component-map.json | harness-design | harness-solo | Explicit mapping layer (machine-readable) |

### 4.3 Contract Document Specification

#### 4.3.1 General Specification

- **File name**: `<source-framework>-to-<target-framework>.md` (fixed, not split by date)
- **Append mode**: If exists, append this delivery's content; do not overwrite history
- **Single latest**: Downstream only reads the latest state, does not trace historical versions
- **Machine-readable fields**: Key fields use structured formats (tables/JSON) for Agent parsing

#### 4.3.2 AC Numbering System (Cross-framework Alignment)

| AC Type | Prefix | Source | Consumer | Example |
|---------|------|------|--------|------|
| Engineering AC | `AC-xxx` | harness-pm's PRD | harness-solo's spec.md | `AC-001: User can log in` |
| Design AC (within design) | `AC-xxx` (reuses PRD numbering) | harness-design's DESIGN_BRIEF.md | harness-design's LOOP | `AC-001: Contrast ratio ≥4.5:1` (corresponds to PRD's AC-001) |
| Design AC (flowing into engineering) | `DAC-xxx` | harness-design's design-to-solo.md | harness-solo's spec.md | `DAC-001: 375px no overflow` |

**AC flow and anti-corruption rules**:
- harness-pm's PRD produces `AC-xxx` (with `ac_id` field), the sole source of ACs. At production time it is intercepted by the **UI Directive Overreach Gate**, strictly forbidding PM from describing specific UI layouts here.
- harness-design's design-brief reuses PRD's `AC-xxx` numbering. At this stage the **Review and Stripping Mechanism (Push-back)** is executed: if upstream ACs are found to violate rules by including specific UI, the design Agent exercises its right to refuse, strips them, and rewrites them as pure business/UX intent, records them in `[AC Cleanup Record]`, and supplements visual acceptance criteria within the design domain.
- harness-design's design-to-solo.md carries the cleaned design ACs (still `AC-xxx`, consistent with PRD numbering).
- harness-solo's writing-plans converts design ACs to `DAC-xxx` (D prefix to distinguish source, avoiding confusion with engineering ACs).
- harness-solo's verify checks both `AC-xxx` (pure engineering) and `DAC-xxx` (design mapping) to ensure design constraints are not lost at the engineering layer.

**Why DAC-xxx is needed**: The same spec.md may contain both `AC-001` (engineering requirement from PRD) and `DAC-001` (design constraint from design-to-solo.md). The D prefix avoids numbering collisions while making source traceable.

#### 4.3.3 Dedicated Templates and Data Files

**Template files** (scaffolds for producing contract documents):

| Template | Purpose | Key Fields |
|------|------|---------|
| `handoff-template.md` | Generic handoff | Phase summary / Deliverables list / AC / Open items |
| `pm-to-design-template.md` | PM → Design | Product type / Target audience / Tech stack / Persona / PRD path / AC-xxx / Style keywords / Out-of-scope list |
| `pm-to-solo-template.md` | PM → Solo | Product type / Tech stack / PRD path / AC-xxx / Feature priority / Tracking plan / Business Context Digest |
| `pm-to-growth-template.md` | PM → Growth | Product type / Target audience / North Star Metric / OKR / Persona / Growth hypothesis |
| `design-to-solo-template.md` | Design → Solo | Design system assets / Page list / Component list / AC-xxx+DAC-xxx / component-map.json |
| `solo-to-pm-template.md` | Solo → PM | Engineering feedback / implementation status / blocker list (on demand) |
| `solo-to-growth-template.md` | Solo → Growth | Implemented feature list / AC-xxx / Tech stack / Performance metrics / Tracking event list |
| `solo-to-ops-template.md` | Solo → Ops | Deliverable version / Environment variable list / Database scripts / Smoke test / Rollback plan |
| `ops-to-pm-template.md` | Ops → PM | SLA summary / Incident notices / Ops recommendations |
| `growth-to-pm-template.md` | Growth → PM | Experiment results / User feedback / Growth recommendations / Metric anomalies |

**Data files** (machine-readable contract carriers, not templates):

| Data File | Purpose | Structure |
|---------|------|------|
| `component-map.json` | Design → Solo explicit mapping layer | `{ "<DesignComponentName>": { designToken, engineeringComponent, props, states, notes } }` |

### Contract Document Write Access Rules

Handoff documents enforce **Write Access Unidirectional Isolation**:

| Document | Writer | Reader |
|------|--------|--------|
| pm-to-solo.md | harness-pm | harness-solo |
| pm-to-design.md | harness-pm | harness-design |
| pm-to-growth.md | harness-pm | harness-growth |
| design-to-solo.md | harness-design | harness-solo |
| solo-to-growth.md | harness-solo | harness-growth |
| solo-to-ops.md | harness-solo | harness-ops |
| growth-to-pm.md | harness-growth | harness-pm |
| ops-to-pm.md | harness-ops | harness-pm |

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
4. Carol manually downloads design-to-solo.md + component-map.json
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

**Skill System** (86 skills = 82 domain + 4 meta):
- Module 1 Discovery (12): user-research / market (insight / opportunity deprecated shells deleted)
- Module 2 Business Strategy (13): business / planning (positioning / stakeholder deprecated shells deleted)
- Module 3 Ideation & Design (9): prd / validation (ideation deprecated shell deleted; visual/interaction moved to harness-design)
- Module 4 Metrics Design (4): metrics
- Module 5 Metrics Operations (11): analysis / decision / experiment
- Module 6 Growth Operations (16): growth / acquisition / activation / retention / revenue
- Module 7 Monitoring & Iteration (17): monitoring / diagnosis / iteration / release

**Core Outputs**:
- `docs/product/PRD.md` — Product Requirements Document (with AC-xxx)
- `docs/strategy/PRODUCT_STRATEGY.md` — Product Strategy
- `docs/metrics/tracking-plan.md` — Tracking Plan
- `docs/handoff/pm-to-solo.md` — Handoff to Engineering
- `docs/handoff/pm-to-design.md` — Handoff to Design
- `docs/handoff/pm-to-growth.md` — Handoff to Growth

**Signature Mechanisms**:
- **UI Directive Overreach Gate**: In the PRD output gate, forcibly intercepts PM sneaking in specific visual/interaction forms (e.g., "left sidebar", "red button"), requiring only business rules and state transitions to be described, ensuring downstream design space is not constrained at the source.

**Known Issues and Optimization Directions**:
- ⚠️ 82 skills is still too many; the 4 sub-orchestrators in Module 6 (acquisition/activation/retention/revenue) can be merged into growth's sub-phases
- ✅ 5 overreaching design skills deleted + design-orchestrator split into prd-orchestrator (visual/interaction moved to harness-design)
- ✅ 5 deprecated shell orchestrators deleted (insight/positioning/ideation/opportunity/stakeholder)

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

**Skill System** (19 skills = 15 design + 4 meta):
- Requirements & Recommendations: design-brief / design-recommendation
- Design System: design-system / design-system-import / design-system-refactor
- Design Output: visual-design / interaction-design / wireframe / component-design
- Review & Verification: verify / design-lint / design-review / product-design-review / accessibility-audit
- Handoff: design-handoff-spec

**Loop Types** (4 types):
- `visual-design` — Visual design tasks
- `interaction-design` — Interaction design tasks
- `wireframe` — Wireframes / low-fidelity prototypes
- `component` — Component design

**Core Outputs**:
- `docs/visual/DESIGN_BRIEF.md` — Design requirements (with AC-xxx)
- `docs/design-system/DESIGN.md` — Design system (10-section standard format)
- `docs/design-system/tokens.json` / `tokens.css` — Design tokens (W3C format)
- `docs/handoff/design-to-solo.md` — Handoff to Engineering
- `docs/handoff/component-map.json` — Explicit mapping layer (Stitch core innovation)

**Signature Mechanisms**:
- **Push-back Mechanism**: The first stop when the design Agent receives requirements is to forcibly review upstream ACs. If PM is found to have violated rules by hardcoding UI layout directives, the Agent has the right to refuse and Reframe them as UX goals, while publicly displaying the cleanup record to defend professional independence.
- **Data-Driven Design Recommendations**: 8 CSV files (reasoning/products/styles/colors/typography/landing/ux-guidelines/vibes)
- **Anti AI-Slop**: Disable Inter/purple gradients/uniform border radius/Lorem ipsum, mechanically checked by design-lint using Node.js
- **Doubt-Driven Adversarial Review**: design-review uses a fresh-context sub-agent for adversarial review
- **Framework-Agnostic Constraint**: component-map.json's props Type matches TECH_STACK (React→ReactNode / Vue→VNode / Svelte→Snippet / Native→HTMLElement)

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

**Skill System** (21 skills = 17 engineering + 4 meta):
- Requirements & Planning: brainstorming / writing-plans / executing-plans
- Testing & Debugging: test-driven-development / test-coverage / systematic-debugging
- Frontend & Performance: frontend-implementation / webapp-testing / performance-optimization
- Migration & Dependencies: migration / dependency-management
- Verification & Review: verify / product-engineering-review / requesting-code-review / receiving-code-review
- Documentation & Skills: writing-documentation / writing-skills

**Loop Types** (4 types):
- `feature` — New feature development
- `bugfix` — Bug fix
- `optimize` — Performance optimization
- `refactor` — Refactoring

**Core Outputs**:
- `docs/product/PROJECT.md` — Product requirements (engineering perspective)
- `docs/engineering/TECH_STACK.md` — Tech stack
- `docs/engineering/ENGINEERING_PLAN.md` — Product-level engineering plan (feature inventory + shared infrastructure + dependency graph)
- `docs/handoff/solo-to-growth.md` — Handoff to Growth
- `.harness/loops/specs/<feature>/spec.md` — Single-feature spec (with AC + DAC)

**Signature Mechanisms**:
- **Dual-source AC Verification**: verify checks both engineering ACs (AC-xxx) and design ACs (DAC-xxx)
- **Design Asset Consumption Contract**: frontend-implementation reads component-map.json as the single source of truth for component implementation
- **Product-Level Engineering Orchestration**: new-product-engineering workflow plans all features + shared infrastructure + dependency order before per-feature LOOPs; product-engineering-review checks cross-feature consistency (API contract / dependency / data model / config / shared module reuse / integration runnability)
- **Entropy Check**: verify checks file growth rate / LOC growth rate / dependency bloat / TODO backlog
- **git hooks**: pre-commit (secret/sensitive file/commit-msg check) + pre-push

**Known Issues and Optimization Directions**:
- ⚠️ ARCHITECTURE.md has been deleted (by user manually); will be rebuilt per this plan

### 5.4 harness-growth (Operations & Growth Framework)

**Positioning**: "Make it used" — content production, SEO, user operations, growth experiments

**Four Principles**:
1. Experiment-Driven — Every action has a hypothesis and a metric
2. Content-First — Quality > Quantity, no content farming
3. Long-Term — No black-hat SEO, no fake traffic
4. Data-Loop — Every experiment has a conclusion and an action

**LOOP Engine**:
```
PLAN → EXPERIMENT → MEASURE → Pass? DONE : Back to EXPERIMENT/PLAN
```

**Skill System** (40 skills = 36 domain + 4 meta):
- Module 1 Growth Strategy (5): nsm-definition / kpi-tree / aarr-diagnosis / growth-loop-design / four-fits-assessment
- Module 2 Growth Experiments (6): hypothesis-generation / ice-scoring / experiment-design / sample-size-calc / experiment-analysis / experiment-conclusion
- Module 3 Content Marketing (5): content-ideation / content-creation / content-review / content-distribution / content-performance
- Module 4 SEO Optimization (5): keyword-research / serp-analysis / onpage-optimization / technical-seo-audit / ranking-tracking
- Module 5 User Operations (5): user-segmentation / onboarding-design / aha-moment-identification / retention-analysis / churn-rescue
- Module 6 Acquisition & Paid (3): channel-assessment / landing-page-optimization / cac-analysis
- Module 7 Monetization (3): pricing-strategy / paywall-optimization / nrr-analysis
- Module 8 Data Analysis (3): funnel-analysis / cohort-analysis / metric-anomaly-detection
- Module 9 Growth Review (1): growth-review

**Loop Types** (6 types):
- `content` — Content production
- `seo` — SEO optimization
- `experiment` — Growth experiments
- `optimization` — Funnel optimization
- `monetization` — Monetization optimization
- `lifecycle` — User lifecycle management

**Core Outputs**:
- `docs/operations/GROWTH_STRATEGY.md` — Growth Strategy
- `docs/content/` — Content assets
- `docs/seo/` — SEO assets
- `docs/experiment/` — Experiment records
- `docs/handoff/growth-to-pm.md` — Feedback to PM

**Workflows** (6): growth-experiment / growth-review / content-marketing / seo-optimization / lifecycle-operations / growth-strategy

### 5.5 harness-ops (Operations & Infrastructure Framework)

**Positioning**: "Escort and deliver" — Infrastructure as Code, automated deployment, monitoring & alerting, disaster recovery and incident response

**SRE Four Principles**:
1. Stability-First — No incidents is the highest-priority metric
2. Infrastructure as Code — Environments are version-controlled and one-click rebuildable
3. Observability — Logs / Metrics / Traces, none can be missing
4. Automation — Eliminate toil relentlessly

**LOOP Engine**:
```
PLAN → PROVISION/DEPLOY → VERIFY → Pass? DONE : On failure ROLLBACK and retry
```

**Skill System** (32 skills = 28 domain + 4 meta):
- Module 1 Deployment & Delivery (4): deployment-pipeline / release-strategy / rollback / deployment-verify
- Module 2 Infrastructure (4): infrastructure-as-code / kubernetes-manifest / helm-management / gitops-sync
- Module 3 Monitoring & Observability (4): monitoring-setup / alerting-rules / log-analysis / dashboard-design
- Module 4 Incident Response (4): incident-detection / root-cause-analysis / incident-mitigation / post-mortem
- Module 5 Security & Compliance (4): secret-management / policy-as-code / security-scan / audit-review
- Module 6 Capacity & Cost (3): resource-right-sizing / cost-analysis / capacity-planning
- Module 7 Disaster Recovery & Backup (3): backup-management / recovery-drill / disaster-recovery-plan
- Module 8 Ops Review (2): ops-review / sla-report

**Loop Types** (5 types):
- `provision` — Infrastructure deployment (max 3)
- `incident` — Production troubleshooting (max 5)
- `optimization` — Capacity/cost optimization (max 3)
- `recovery` — Disaster recovery (max 3)
- `audit` — Security/compliance audit (max 3)

**Core Outputs**:
- `docs/deployment/` — Deployment records
- `docs/monitoring/` — Monitoring dashboards and alerting rules
- `docs/infrastructure/` — Infrastructure architecture diagrams and assets
- `docs/incident/` — Incident troubleshooting and ticket records
- `docs/handoff/ops-to-pm.md` — SLA report + incident post-mortem feedback to PM

**Workflows** (7): deployment / incident-response / infrastructure-setup / monitoring-deployment / security-audit / disaster-recovery / ops-review

**Signature Mechanisms**:
- **Semi-automated Architecture**: Agent proposes + human approves + GitOps executes. A fully autonomous ops Agent is infeasible within 3-5 years, but a semi-automated framework is feasible and high-value
- **Four Operation Primitives** (frontmatter `operation_tier` field):
  - `inspect` — Read-only inspection, Agent fully automated
  - `propose` — Generate PR/proposal, human reviews then merges
  - `mutate-staging` — Directly execute whitelisted operations on Staging
  - `mutate-prod` — Production change, **human approval mandatory**
- **GitOps PR Indirect Execution**: Agent never directly operates production clusters; goes through PR + human review + ArgoCD/Flux sync (drawing on HolmesGPT + ArgoCD industry consensus)
- **Strict Secret Isolation**: Agent only operates on Secret references (path/key name/CRD), never touches plaintext values (hard constraint, non-negotiable)
- **7-Layer Defense in Depth**: Dry-run / Canary / Approval gate / Rate limit / Rollback / Audit / Blast radius
- **Enhanced frontmatter**: Adds `operation_tier` and `requires_approval` ops-specific fields on top of the family-wide spec
- **7 Knowledge Base Tables**: Incident library / Root cause library / Deployment record library / Monitoring config library / IaC asset library / Ops pattern repository / Pitfall log

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
| `.harness/memory/progress.md` | Session progress log | ✅ |
| `.harness/memory/knowledge-base.md` | Cross-session knowledge base | ✅ |
| `.harness/FEATURES.md` | Dynamic task status board | ✅ |
| `.harness/VERSION` | Framework version | ✅ |
| `docs/handoff/README.md` | Handoff protocol description | ✅ |
| `docs/handoff/handoff-template.md` | Generic handoff template | ✅ |

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
> | growth | Growth status and experiment context |
> | ops | Infrastructure status and security posture |

### 6.4 Security Red Lines Unified Specification

All frameworks' `security.md` must include:

| Forbidden | Reason |
|------|------|
| Hardcoded secrets | Secret leakage risk |
| `rm -rf` | Accidental deletion risk |
| `curl \| sh` | Supply chain attack risk |
| Modifying `.git/hooks/` | Breaks git hook integrity |
| Bypassing Quality Gates | Output quality out of control |

Each framework may extend additional red lines by domain (e.g., growth forbids black-hat SEO, design forbids leaking PII).

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
| Tech Stack | ✅ | Determines component-map.json's props Type system |
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
| Business Context Digest | ✅ | Engineering-relevant constraints extracted by PM from user-research.md / market-analysis.md (data scale / concurrency / performance requirements, etc.), to prevent Solo from making architecture decisions detached from business |
| Key Decisions | ✅ | Decision + rationale + impact scope |
| Open Items | ✅ | Questions for engineering to confirm |
| Suggested Next Step | ✅ | What engineering can do |

**Consumer**: harness-solo's brainstorming skill

### 7.3 PM → Growth Contract

**File**: `docs/handoff/pm-to-growth.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Product Name | ✅ | |
| Product Type | ✅ | web app / mobile / desktop / landing page; determines growth channel strategy |
| Target Audience | ✅ | Affects acquisition strategy |
| Current Stage | ✅ | MVP / PMF / Scaling; determines growth focus |
| Positioning Statement | ✅ | From positioning skill |
| North Star Metric | ✅ | Metric name + current value + target value |
| OKR | ✅ | From planning-okr skill, includes Objective + Key Result + cycle |
| Persona Path | ✅ | docs/discovery/user-research.md (user persona section) |
| Existing Data Assets | ○ | Metric definitions / tracking plan / historical experiment paths; for brand-new projects fill "none" |
| Growth Hypotheses | ✅ | List of hypotheses to validate (e.g., "Content marketing CAC < $50") |
| Key Decisions | ✅ | Decision + rationale + impact scope |
| Open Items | ✅ | Questions for growth to confirm |
| Suggested Next Step | ✅ | What growth can do |

**Consumer**: harness-growth's growth experiment / growth analysis skill

### 7.4 Design → Solo Contract

**File**: `docs/handoff/design-to-solo.md` + `docs/handoff/component-map.json`

**design-to-solo.md Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Design Asset Path | ✅ | docs/visual/<page>.md / docs/interaction/<page>.md |
| Design AC List | ✅ | AC-xxx (design perspective, e.g., "Contrast ratio ≥4.5:1") |
| Component Mapping Path | ✅ | docs/handoff/component-map.json |
| Design System Path | ✅ | docs/design-system/DESIGN.md + tokens.json |
| Open Items | ✅ | Questions to confirm with engineering |

**component-map.json Structure**:

```json
{
  "<DesignComponentName>": {
    "designToken": "<token-name>",
    "engineeringComponent": "<EngineeringComponentName>",
    "props": { "<key>": "<Type>" },
    "states": ["default", "hover", "..."],
    "notes": "<description>"
  }
}
```

**Framework-Agnostic Constraint**: props Type must match the framework in `docs/engineering/TECH_STACK.md`:
- React → `ReactNode` / `JSX.Element`
- Vue → `VNode` / `Slot`
- Svelte → `Snippet` / `Component`
- Native / Web Components → `HTMLElement` / `Slot`
- Unspecified tech stack → use neutral `Slot` / `Component`, mark "pending engineering confirmation" in notes

**Consumer**: harness-solo's brainstorming / frontend-implementation / writing-plans / verify skill

### 7.5 Solo → Growth Contract

**File**: `docs/handoff/solo-to-growth.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Implemented Feature List | ✅ | Feature + path + status |
| Tracking Event List | ✅ | Tracking events already implemented |
| Performance Metrics | ○ | LCP/FID/CLS baseline data |
| Known Limitations | ✅ | Impact of technical constraints on growth |

**Consumer**: harness-growth's growth analysis skill

### 7.6 Growth → PM Contract

**File**: `docs/handoff/growth-to-pm.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Experiment Results | ✅ | Experiment + conclusion (effective / ineffective / inconclusive) + data |
| User Feedback | ✅ | Collection + analysis + priority |
| Growth Recommendations | ✅ | Data-driven next-step recommendations |
| Metric Anomalies | ○ | Anomalous fluctuations + cause analysis |

**Consumer**: harness-pm's insight / iteration skill

### 7.7 Solo → Ops Contract

**File**: `docs/handoff/solo-to-ops.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| Deliverable Version | ✅ | Image Tag or code Commit Hash |
| Environment Variables | ✅ | Config items to add/remove/modify for this deployment |
| Database Scripts | ✅ | Whether Migration is included and its execution order |
| Smoke Test | ✅ | Checkpoints to verify deployment success |
| Rollback Plan | ✅ | Degradation or code rollback measures on error |

**Consumer**: harness-ops's deployment-pipeline / infrastructure-as-code skill

### 7.8 Ops → PM Contract

**File**: `docs/handoff/ops-to-pm.md`

**Key Fields**:

| Field | Required | Description |
|------|:---:|------|
| SLA Availability | ✅ | Overall availability metric for the period (e.g., 99.99%) |
| Incident Notices | ○ | P0/P1 incidents that occurred and post-mortem |
| Cost Optimization | ○ | Cloud billing trends and resource cleanup report |
| Business Recommendations | ✅ | E.g., an API is extremely slow; recommend refactoring in next release |

**Consumer**: harness-pm's iteration / release skill

---

## 8. Collaboration Workflow Examples

### 8.1 Building a New Product from 0 to 1 (Four-Framework Collaboration)

```
Phase 1: Product Definition (harness-pm)
├── new-product workflow
├── Output: PRD.md (with AC-xxx) / PRODUCT_STRATEGY.md / Persona
└── Output: pm-to-design.md + pm-to-solo.md + pm-to-growth.md

Phase 2: Design (harness-design)
├── new-design workflow
├── Consumes: pm-to-design.md
├── Output: DESIGN_BRIEF.md / DESIGN.md / tokens.json / visual/ / interaction/
└── Output: design-to-solo.md + component-map.json

Phase 3: Engineering (harness-solo)
├── new-product-engineering workflow (plans all features + shared infrastructure first)
├── Consumes: pm-to-solo.md + design-to-solo.md + component-map.json
├── Output: ENGINEERING_PLAN.md + code + tests + spec.md (with AC + DAC)
└── Output: solo-to-growth.md + solo-to-ops.md

Phase 4: Growth (harness-growth)
├── Growth experiment workflow
├── Consumes: solo-to-growth.md + pm-to-growth.md
├── Output: content assets / SEO assets / experiment records
└── Output: growth-to-pm.md (feedback loop)
```

### 8.2 Iterating on an Existing Product (PM + Solo Collaboration)

```
Phase 1: Iteration Requirements (harness-pm)
├── iteration workflow
├── Output: PRD update (new/modified AC-xxx)
└── Output: pm-to-solo.md (append iteration requirements)

Phase 2: Engineering Implementation (harness-solo)
├── new-feature / bugfix workflow
├── Consumes: pm-to-solo.md (updated version)
└── Output: code updates + solo-to-pm.md (engineering feedback)
```

### 8.3 Design Redo (PM + Design + Solo Collaboration)

```
Phase 1: Redesign Requirements (harness-pm)
├── Output: PRD update + pm-to-design.md (redesign requirements)

Phase 2: Redesign (harness-design)
├── redesign workflow
├── Consumes: pm-to-design.md + design-system-import (existing assets)
├── Output: updated visual/ / interaction/ / DESIGN.md / tokens.json
└── Output: design-to-solo.md (updated) + component-map.json (updated)

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
- **Version alignment**: Contract documents are not split by date; downstream only reads the latest state

---

## 10. Evolution Roadmap

### 10.1 Current Stage (v2.1, completed)

- ✅ 4 core frameworks built independently (pm/design/solo/growth all complete)
- ✅ Contract document system connected (pm→design→solo→growth→pm closed loop)
- ✅ AC numbering system aligned cross-framework (AC-xxx / DAC-xxx)
- ✅ LOOP engine unified specification (state.yaml + checkpoint resume + cap protection)
- ✅ Foundation layer unified (AGENTS/SOUL/constitution/security/meta skill)

### 10.2 Short-term Optimization (v2.1, within 1-2 weeks)

- ✅ harness-pm's 5 overreaching design skills deleted + design-orchestrator split into prd-orchestrator (kept PRD + change impact analysis; visual/interaction moved to harness-design)
- ✅ harness-pm's 5 deprecated shell orchestrators deleted (insight/positioning/ideation/opportunity/stakeholder)
- ✅ harness-pm's PRD adds ac_id field, aligned with design-brief AC-xxx
- ✅ harness-solo's README skill count corrected (engineering skill mislabeled 17, actually 16, total 20)
- ✅ harness-solo's install.sh adds Node.js check
- ✅ harness-pm's core handoff templates filled in (pm-to-solo-template / pm-to-growth-template)
- ✅ harness-solo's core handoff templates filled in (solo-to-growth-template / solo-to-ops-template)
- ✅ harness-pm's AGENTS.md docs/design/ ownership violation corrected (5 overreaching entries deleted, responsibility boundary description added)
- ✅ Cross-framework contract anti-overreach guardrails deployed (PM side adds UI gate interception + Design side granted Push-back cleanup rewrite right)
- ✅ harness-design's skill count corrected (design skill mislabeled 13, actually 14, total 18)
- ✅ harness-growth's growth skill and workflow built (40 skills + 6 workflows)

### 10.3 Mid-term Evolution (v3.0, 1-2 months)

- ✅ harness-ops built (P0, ops framework, 32 skills + 7 workflows, semi-automated architecture)
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

**Choice**: harness-design introduces LOOP outer gate (design-review + accessibility-audit)
**Rationale**:
- verify + lint inside LOOP are fast checks (mechanical rules)
- design-review + accessibility-audit outside LOOP are deep reviews (adversarial + semantic-level)
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

### Decision 6: component-map.json Framework-Agnostic

**Choice**: props Type matches TECH_STACK, not bound to any framework
**Rationale**:
- harness-design should not prejudge whether downstream engineering uses React/Vue/Svelte
- Hard-binding to React would prevent Vue projects from consuming
- Neutral abstraction (Slot/Component) + Tech Stack constraint is the fundamental solution

**Trade-off**:
- Mapping rules must be maintained on both design-handoff-spec and frontend-implementation sides
- But the benefit (cross-framework compatibility) far outweighs the cost

---

## 12. Risk Assessment and Mitigation

### 12.1 Context Explosion Risk

**Risk**: A single framework has too many skills (e.g., harness-pm 82 skills); INDEX.md may not fit
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
- **pm-to-solo.md adds Business Context Digest**: PM extracts engineering-relevant constraints (data scale / concurrency / performance requirements) from user-research.md / market-analysis.md; Solo must reference it during brainstorming's technical feasibility assessment and proactively raise issues when ACs conflict with business constraints

### 12.3 Multi-person Collaboration Version Conflicts

**Risk**: Multiple people modify contract documents simultaneously, versions inconsistent
**Mitigation**:
- Contract documents are not split by date; downstream only reads the latest state (forces single latest version)
- Multi-person collaboration managed via Git branches (PR merge does not overwrite mainline)
- Current stage: manual flow; future orchestration layer can handle automatically

### 12.4 Inconsistent Philosophy Across Frameworks

**Risk**: The 4 frameworks' LOOP designs differ (pm is data-driven, design is quality-driven, solo is goal-driven), may cause confusion
**Mitigation**:
- Each framework's LOOP is designed independently, optimized by domain characteristics (no forced unification)
- This architecture document explicitly explains the differences and rationale of each framework's LOOP
- Loop type naming follows domain semantics (pm uses research/prd/iteration; design uses visual/interaction/wireframe)

### 12.5 Extension Framework Build Lag

**Risk**: harness-data build lag affects the full chain
**Mitigation**:
- Extension frameworks built on demand (P0/P1/P2/P3 priority)
- Core frameworks (pm/design/solo/growth/ops) already cover main scenarios
- Before data is built, related capabilities are backstopped by harness-solo's verify/webapp-testing + harness-ops's monitoring

---

## 13. Summary

harness-all is a multi-Agent framework family with **Independence First, Contract Collaboration**. The current stage focuses on the independent build of 4 core frameworks + 1 P0 extension framework, with cross-framework collaboration via contract documents.

**Core Value**:
- Each Agent specializes in one domain, avoiding context explosion and memory pollution
- Contract documents are the sole collaboration medium, supporting multi-person + multi-Agent collaboration
- Cross-platform compatible, Agent tools first, bash optional fallback
- Frameworks are fully independent, can attach to different projects/working directories

**Current Status**:
- 4 core frameworks all built (pm/design/solo/growth)
- 1 P0 extension framework built (ops, 32 skills + 7 workflows, semi-automated architecture)
- Contract document system connected (pm→design→solo→growth→pm closed loop + solo→ops→pm closed loop)
- AC numbering system aligned cross-framework
- LOOP engine unified specification

**Next Priorities**:
- Short-term: harness-pm design skill slimming (✅ done) + harness-growth skill build (✅ done) + harness-ops build (✅ done)
- Mid-term: harness-data build (P1)
- Long-term: Orchestration layer exploration (on demand)

---

## Appendix A: Framework File Structure Comparison

| File/Directory | harness-pm | harness-design | harness-solo | harness-growth | harness-ops |
|-----------|:---:|:---:|:---:|:---:|:---:|
| AGENTS.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| SOUL.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| constitution.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| README.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| install.sh | ✅ | ✅ | ✅ | ✅ | ✅ |
| ARCHITECTURE.md | ❌ (deleted) | ❌ | ❌ (deleted) | ❌ | ❌ |
| .harness/loops/LOOP.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/skills/INDEX.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/skills/meta/ | ✅ (4 skills) | ✅ (4 skills) | ✅ (4 skills) | ✅ (4 skills) | ✅ (4 skills) |
| .harness/skills/<domain>/ | ✅ (82 domain skills) | ✅ (15 domain skills) | ✅ (17 domain skills) | ✅ (36 domain skills) | ✅ (28 domain skills) |
| .harness/skills/workflows/ | ✅ (10 workflows) | ✅ (7 workflows) | ✅ (8 workflows) | ✅ (7 workflows) | ✅ (8 workflows) |
| .harness/rules/security.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/rules/prompt-defense.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/memory/ | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/FEATURES.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/VERSION | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/templates/ | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/data/ | ❌ | ✅ (8 CSVs) | ❌ | ❌ | ❌ |
| .harness/craft/ | ❌ | ✅ (4 files) | ❌ | ❌ | ❌ |
| .harness/hooks/ | ❌ | ❌ | ✅ | ❌ | ❌ |
| .harness/scripts/ | ❌ | ❌ | ✅ | ❌ | ❌ |
| docs/handoff/ | ✅ | ✅ | ✅ | ✅ | ✅ |

**Skill count note**: Each framework's total skill count = domain skills + 4 meta skills. For example, harness-design totals 19 skills (15 domain + 4 meta), harness-solo totals 21 skills (17 domain + 4 meta), harness-pm totals 86 skills (82 domain + 4 meta), harness-growth totals 40 skills (36 domain + 4 meta), harness-ops totals 32 skills (28 domain + 4 meta).

## Appendix B: Contract Document Matrix

| Source \ Target | harness-pm | harness-design | harness-solo | harness-growth | harness-ops |
|-----------|:---:|:---:|:---:|:---:|:---:|
| harness-pm | - | pm-to-design.md | pm-to-solo.md | pm-to-growth.md | - |
| harness-design | design-to-pm.md (on demand) | - | design-to-solo.md + component-map.json | - | - |
| harness-solo | solo-to-pm.md (on demand) | - | - | solo-to-growth.md | solo-to-ops.md |
| harness-growth | growth-to-pm.md | - | - | - | - |
| harness-ops | ops-to-pm.md | - | - | - | - |

## Appendix C: LOOP Loop Type Comparison

| Framework | Loop Type | Trigger Scenario | Max Iterations |
|------|---------|---------|:---:|
| harness-pm | research | User research / market analysis | 5 |
| harness-pm | prd | PRD generation / solution design | 5 |
| harness-pm | iteration | Data-driven iteration | 3 |
| harness-pm | growth | Growth breakthrough | 3 |
| harness-pm | pivot | Strategic adjustment | 5 |
| harness-design | visual-design | Visual design tasks | 5 |
| harness-design | interaction-design | Interaction design tasks | 5 |
| harness-design | wireframe | Wireframes / low-fidelity prototypes | 5 |
| harness-design | component | Component design | 5 |
| harness-solo | feature | New feature development | 5 |
| harness-solo | bugfix | Bug fix | 3 |
| harness-solo | optimize | Performance optimization | 3 |
| harness-solo | refactor | Refactoring | 3 |
| harness-growth | content | Content production | 3 |
| harness-growth | seo | SEO optimization | 5 |
| harness-growth | experiment | Growth experiments | 3 |
| harness-growth | optimization | Funnel optimization | 3 |
| harness-growth | monetization | Monetization optimization | 3 |
| harness-growth | lifecycle | User lifecycle | 5 |
| harness-ops | provision | Infrastructure deployment | 3 |
| harness-ops | incident | Production troubleshooting | 5 |
| harness-ops | optimization | Capacity/cost optimization | 3 |
| harness-ops | recovery | Disaster recovery | 3 |
| harness-ops | audit | Security/compliance audit | 3 |

**Single LOOP Hard Circuit Breaker**: Unified across all frameworks at 10 iterations; stop and request human intervention when exceeded.

**Naming Convention**: Loop types are named by domain semantics to avoid cross-framework confusion (e.g., harness-pm uses `prd` instead of `design` to avoid confusion with harness-design's `visual-design` / `interaction-design`).

---

**Document Version**: v2.1 · 2026-06-22 (synced with harness-growth + harness-ops build completion)
**Maintainer**: harness-all Architect
**Next Review**: At v3.0 release (harness-data build kickoff)
