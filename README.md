<div align="center">

**🌐 Language / 语言**: **English** | [中文](./README.zh.md)

---

# 🪢 harness-all

### Personal AI Studio · Multi-Agent Framework Family

> **A "Independence First, Contract Collaboration" framework family for AI Agents**
> Each framework specializes in one domain and works independently; they collaborate via contract documents to form a complete closed loop.

---

![Version](https://img.shields.io/badge/version-v2.1-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-5-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-206-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-36-purple.svg?style=for-the-badge&logo=git)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)
![Status](https://img.shields.io/badge/status-production--ready-brightgreen.svg?style=for-the-badge&logo=checkmarx)

---

| Framework | Responsibility | Skill | Workflow | Status |
|:----:|------|:-----:|:--------:|:----:|
| **harness-pm** | Strategy · Market · Product · PRD · Metrics | 86 | 10 | ✅ |
| **harness-design** | UI · Visual · Interaction · Prototype · Design System | 18 | 6 | ✅ |
| **harness-solo** | Engineering · TDD · Debugging · Refactoring · Verification | 20 | 7 | ✅ |
| **harness-growth** | Operations · Content · SEO · Growth Experiments | 40 | 6 | ✅ |
| **harness-ops** | Ops · Deployment · Monitoring · Disaster Recovery | 32 | 7 | ✅ |

**Total**: 5 frameworks · 206 Skills · 36 Workflows · 11 contract documents · 25 LOOP loop types

</div>

---

## 📖 Table of Contents

- [🎯 Design Philosophy](#-design-philosophy)
- [💡 Why a Framework Is Needed](#-why-a-framework-is-needed)
- [🏛️ Three-Layer Architecture](#️-three-layer-architecture)
- [👨‍👩‍👧‍👦 Framework Family Overview](#-framework-family-overview)
- [✨ Core Features](#-core-features)
- [🚀 Quick Start](#-quick-start)
- [🔧 Framework Details](#-framework-details)
- [📜 Contract Collaboration Mode](#-contract-collaboration-mode)
- [⚙️ Unified Foundation Layer Specification](#️-unified-foundation-layer-specification)
- [🔄 LOOP Loop Engine](#-loop-loop-engine)
- [🛡️ Security and Compliance](#️-security-and-compliance)
- [🗺️ Evolution Roadmap](#️-evolution-roadmap)
- [📚 Documentation Navigation](#-documentation-navigation)
- [🤝 Contribution and License](#-contribution-and-license)

---

## 🎯 Design Philosophy

### Core Principle: Independence First, Contract Collaboration

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Independent Work ──── Contract Collaboration ──── Multi-Agent Orchestration │
│   (Current stage)        (Current stage)            (Future evolution, non-goal) │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Why independent rather than unified**:

| Dimension | Unified Framework | Independent Frameworks (This Approach) |
|------|---------|-------------------|
| Context cost | Single Agent loads all skills, context explosion | Each Agent loads only its domain skills |
| Memory pollution | Product/engineering/design/growth memories mixed | Each framework has independent memory, no interference |
| Debug isolation | A bug in one domain affects everything | Frameworks are fully isolated |
| Tool adaptation | One toolchain fits all scenarios | Each framework picks tools as needed |
| Project ownership | One project, one Agent | Different frameworks can attach to different projects/working directories |

**Conclusion**: Context explosion and memory pollution are the core pain points of AI Agent collaboration. Independent frameworks are the most pragmatic choice today.

### Four Iron Rules

1. **Independent Self-Sufficiency** — Each framework must be able to independently complete its domain work without depending on other frameworks
2. **Contract Collaboration** — Frameworks pass requirements via contract documents under `docs/handoff/`
3. **Loop Verification** — All tasks go through LOOP (plan→execute→verify), evidence-driven
4. **Security Red Lines** — Non-negotiable principles written into constitution.md; Agents must comply

---

## 💡 Why a Framework Is Needed

### The Real Dilemma of AI Agents Without a Framework

Most people use AI Agents like this: open a conversation → describe the requirement → get a result → close the conversation. Next time you open it, everything starts from zero.

```
❌ Daily life without a framework

  1st conversation:  "Help me write a PRD"        → Agent doesn't know your product background, asks from scratch
  2nd conversation:  "Help me design this page"   → Agent doesn't know what the PRD looks like, asks from scratch
  3rd conversation:  "Help me implement this feature" → Agent doesn't know what the design looks like, asks from scratch
  4th conversation:  "Help me write a growth plan" → Agent doesn't know the product status, asks from scratch
  ...every conversation is amnesiac, every time you have to rebuild context
```

**The core problem is not that the Agent isn't smart enough, but that there is no persistent project memory and domain knowledge.**

### What the Framework Solves

The essence of the harness framework is not "a better prompt", but **building a persistent project knowledge system for AI Agents**:

| Capability | Without Framework | With harness Framework |
|------|---------------|---------------------|
| **Project Knowledge Base** | Re-explain project background every conversation | `knowledge-base.md` continuously accumulates project decisions, tech choices, pitfalls |
| **Workspace Memory** | Forgetting on conversation close | `progress.md` keeps progress across sessions, auto-restores next time |
| **Domain Specialization** | One Agent does everything, none well | Each framework focuses on one domain, skills precisely match scenarios |
| **Context Efficiency** | Full load, severe token waste | Load INDEX → SKILL.md on demand, only read what's necessary |
| **Traceable Collaboration** | Verbal/chat records pass requirements | Contract documents (handoff) structured passing, AC numbering aligned cross-framework |
| **Verifiable Quality** | "I think it's done" | LOOP engine + evidence gate, no claiming completion without evidence |
| **Security Red Lines** | Agent may overreach | constitution.md non-negotiable, security.md unified prohibitions |
| **Reusable Experience** | Start from zero every project | Templates + knowledge base + skills reusable across projects |

### Three-Layer Knowledge System

```
┌─────────────────────────────────────────────────────────────┐
│  🧠 Project Knowledge Base (knowledge-base.md)               │
│                                                             │
│  Continuously accumulated project decisions · tech choices · pitfalls · best practices │
│  → Agent auto-reads at every startup, no need to re-explain project background │
│  → Auto-archives new knowledge at session end, the more you use it the better it knows your project │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  📋 Workspace Memory (progress.md + FEATURES.md)             │
│                                                             │
│  Cross-session progress · current task status · historical decision records │
│  → session-start auto-restores context, no lost work progress │
│  → FEATURES.md board-style tracking of all task statuses     │
│  → state.yaml supports checkpoint resume, recoverable after interruption │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  📐 Domain Specification (AGENTS.md + SOUL.md + constitution.md) │
│                                                             │
│  Domain values · working principles · security red lines · non-negotiable rules │
│  → Clear Agent behavior boundaries, no overreach or drift    │
│  → Different frameworks have different personalities and principles, specialized not generalized │
│  → Clear rule priority: SOUL > AGENTS > rules > conversation > external files │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Framework vs Pure Prompt Engineering: The Essential Difference

| Dimension | Pure Prompt Engineering | harness Framework |
|------|----------------------|-------------------|
| Knowledge Persistence | None (every conversation from zero) | knowledge-base.md accumulates across sessions |
| Context Recovery | None (manual copy-paste) | progress.md + session-start auto-restore |
| Domain Specialization | Via prompt role description (fragile) | SOUL.md + 82 PM skills precisely matched |
| Quality Assurance | Manual checking | LOOP loop + evidence gate + verify skill |
| Collaboration Handoff | Copy-paste chat records | Contract documents structured passing + AC numbering alignment |
| Security Boundary | Via prompt constraints (overridable) | constitution.md non-negotiable + security.md |
| Experience Reuse | Rewrite prompts every project | Templates + skills + knowledge base reusable across projects |
| Extensibility | Prompts grow longer, hard to maintain | Skills modular, INDEX loads on demand |

**One-line summary**: Prompt Engineering is "teach an Agent to do one thing"; Framework is "let an Agent have persistent project memory and domain expertise, getting stronger with use".

### Real-World Scenario Comparison

**Scenario: You're building a new product, from 0 to 1**

```
❌ Without a framework:

  You: Help me write a PRD
  AI: Sure, please tell me what your product is? Who are the target users?...
  You: (spend 30 minutes explaining background)
  AI: (produces PRD)
  You: Help me design the homepage
  AI: Sure, please tell me what your PRD content is?...
  You: (spend 10 minutes re-explaining)
  ...every domain switch requires rebuilding context, knowledge cannot accumulate

✅ With harness framework:

  You: Start harness-pm, begin new-product workflow
  Agent: (auto-reads knowledge-base, understands project background)
  Agent: (executes new-product workflow, produces PRD + contract documents)
  You: Switch to harness-design
  Agent: (auto-reads pm-to-design.md, precisely understands requirements)
  Agent: (produces design assets + component-map.json)
  You: Switch to harness-solo
  Agent: (auto-reads design-to-solo.md + component-map.json)
  Agent: (precisely implements code, AC numbering aligned verification)
  ...each domain auto-inherits upstream outputs, knowledge continuously accumulates
```

---

## 🏛️ Three-Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Orchestration Layer (Future, not a current goal)            │
│  - Multi-Agent scheduling / shared source of truth / cross-framework LOOP │
└─────────────────────────────────────────────────────────────┘
                          ↕ Contract documents
┌─────────────────────────────────────────────────────────────┐
│  Framework Layer (Current focus)                             │
│  harness-pm / harness-design / harness-solo                  │
│  harness-growth / harness-ops                                │
│  + Extension frameworks (data/qa/security, built on demand)  │
└─────────────────────────────────────────────────────────────┘
                          ↕ Load chain
┌─────────────────────────────────────────────────────────────┐
│  Foundation Layer (inside each framework)                    │
│  AGENTS.md / SOUL.md / constitution.md / LOOP.md / skills/  │
└─────────────────────────────────────────────────────────────┘
```

### Applicable Scenarios

- **Personal AI Studio**: One person + multiple AI Agents, each Agent specializes in one domain
- **Small team collaboration**: Different members own different frameworks, aligned via contract documents
- **Multi-project parallelism**: Each framework can attach to different project directories without interference

---

## 👨‍👩‍👧‍👦 Framework Family Overview

### Framework Classification and Status

| Category | Framework | Responsibility | Status | Skill Count |
|------|------|------|------|---------|
| Core | **harness-pm** | Strategy · Market · Product · PRD · Metrics · Growth Monitoring | ✅ Built | 86 skills (82 domain + 4 meta) + 10 workflows |
| Core | **harness-design** | UI · Visual · Interaction · Prototype · Design System | ✅ Built | 18 skills (14 domain + 4 meta) + 6 workflows |
| Core | **harness-solo** | Engineering · TDD · Debugging · Refactoring · Verification | ✅ Built | 20 skills (16 domain + 4 meta) + 7 workflows |
| Core | **harness-growth** | Operations · Content · SEO · Growth Experiments | ✅ Built | 40 skills (36 domain + 4 meta) + 6 workflows |
| Extension | **harness-ops** | Ops · Deployment · Monitoring · Disaster Recovery | ✅ Built | 32 skills (28 domain + 4 meta) + 7 workflows |
| Extension | harness-data | Data Pipeline · ETL · Metric Production | 📋 P1 To Build | - |
| Extension | harness-qa | Quality Assurance · Automated Testing · Performance Testing | ⚠️ P2 On Demand | - |
| Extension | harness-security | Security Audit · Compliance · Penetration Testing | ⚠️ P3 On Demand | - |

### Framework Responsibility Boundaries (Non-overlap Principle)

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
                                   ▲
                                   │ solo-to-ops.md (deployment contract)
                                   │
                            ┌─────────────┐
                            │ harness-ops │
                            │ "Escort and │
                            │  deliver"   │
                            └─────────────┘
                                   │
                                   │ ops-to-pm.md (SLA + incident post-mortem)
                                   ▼
                            (feedback to harness-pm)
```

**Responsibility boundary iron rules**:

| Domain | Owner | Boundary Violations Forbidden |
|------|------|---------|
| Product Requirements (PRD/AC/Persona) | harness-pm | design does not define PRD, solo does not modify PRD |
| Visual Design (color/typography/components) | harness-design | pm does not pick colors, solo does not hardcode values |
| Interaction Design (state machines/animations/gestures) | harness-design | pm does not define animation params, solo implements per spec |
| Engineering Implementation (code/tests/architecture) | harness-solo | pm/design do not write code |
| Growth Operations (content/SEO/experiments) | harness-growth | pm provides metrics, growth runs experiments |
| Ops Assurance (release/monitoring/disaster recovery) | harness-ops | solo does not directly operate production, must go through ops IaC |

---

## ✨ Core Features

### 1. Independent Frameworks · Context Isolation

Each framework is a fully independent directory that can attach to different project directories, be loaded by different Agent instances, and have independent `.harness/` config, memory, progress.

### 2. Contract Collaboration · Cross-Framework Alignment

Pass requirements via contract documents under `docs/handoff/`, supporting multi-person + multi-Agent collaboration. AC numbering system aligned cross-framework (`AC-xxx` engineering + `DAC-xxx` design flowing into engineering).

### 3. LOOP Engine · Evidence-Driven

Unified loop engine across all frameworks, supporting state.yaml checkpoint resume, iteration cap protection, evidence-driven principle. Single LOOP Hard Circuit Breaker at 10 iterations.

### 4. Security Red Lines · Non-negotiable

Each framework's `constitution.md` defines non-negotiable principles; `rules/security.md` defines unified prohibitions. The ops framework additionally adds strict Secret isolation and 7-layer defense in depth.

### 5. Cross-platform Compatible

Agent tools first (Read/Write/Edit/Glob/Grep), bash optional fallback. All scripts have bash availability checks, auto-skip on Windows.

### 6. Semi-automated Architecture (harness-ops exclusive)

Agent proposes + human approves + GitOps executes. Four operation primitives (inspect/propose/mutate-staging/mutate-prod) precisely control the automation boundary.

---

## 🚀 Quick Start

### 1. Choose the framework you need

```bash
# Full personal AI studio (recommended)
git clone <harness-all-repo>

# Or clone only a single framework
git clone <harness-pm-repo>      # Product Management
git clone <harness-design-repo>  # UI Design
git clone <harness-solo-repo>    # Engineering
git clone <harness-growth-repo>  # Operations & Growth
git clone <harness-ops-repo>     # Ops Assurance
```

### 2. Install to your project

```bash
# Enter your project directory
cd my-project

# Run the install script (using harness-solo as an example)
bash /path/to/harness-solo/install.sh

# The install script will:
# 1. Check dependencies (git required, Node.js on demand)
# 2. Create the .harness/ directory structure
# 3. Copy AGENTS.md / SOUL.md / constitution.md
# 4. Initialize memory/progress.md
# 5. Create the docs/handoff/ directory
```

### 3. Start the Agent

```
# Start an AI Agent in your project directory (e.g., Trae IDE)

# The Agent will auto-read via the load chain:
# 1. AGENTS.md (mandatory read at startup)
# 2. SOUL.md + constitution.md (on first interaction)
# 3. skills/INDEX.md (when selecting a Skill)
# 4. Corresponding SKILL.md (when executing tasks)
# 5. memory/progress.md (at session-start)
```

### 4. Multi-framework Collaboration

```bash
# Scenario: PM produces PRD → Design produces design assets → Solo implements code

# 1. Use harness-pm in the product project directory
cd product-project
# Agent produces: docs/handoff/pm-to-design.md + pm-to-solo.md

# 2. Manually copy contract documents to the design project
cp product-project/docs/handoff/pm-to-design.md design-project/docs/handoff/

# 3. Use harness-design in the design project directory
cd design-project
# Agent consumes pm-to-design.md, produces: design-to-solo.md + component-map.json

# 4. Manually copy contract documents to the engineering project
cp design-project/docs/handoff/design-to-solo.md engineering-project/docs/handoff/
cp design-project/docs/handoff/component-map.json engineering-project/docs/handoff/

# 5. Use harness-solo in the engineering project directory
cd engineering-project
# Agent consumes pm-to-solo.md + design-to-solo.md + component-map.json, implements code
```

---

## 🔧 Framework Details

### harness-pm (Product Management Framework)

> **Positioning**: "Do the right thing" — product exploration, market analysis, PRD generation, metrics operations

**Four Principles**:
1. Discovery First — Don't assume requirements; let research data speak
2. Contract-Driven — PRD drives design, positioning drives brand
3. Data-Driven — Use data to reduce guessing; decision authority stays with humans
4. Closed-Loop — Metrics → Monitoring → Iteration → Feedback

**Skill System** (86 skills = 82 domain + 4 meta):
- Module 1 Discovery (12): user-research / market
- Module 2 Business Strategy (13): business / planning
- Module 3 Ideation & Design (9): prd / validation
- Module 4 Metrics Design (4): metrics
- Module 5 Metrics Operations (11): analysis / decision / experiment
- Module 6 Growth Operations (16): growth / acquisition / activation / retention / revenue
- Module 7 Monitoring & Iteration (17): monitoring / diagnosis / iteration / release

**Signature Mechanisms**:
- **UI Directive Overreach Gate**: Forcibly intercepts PM sneaking in specific visual/interaction forms at PRD output
- **orchestrator-pipeline two-layer architecture**: 19 orchestrators orchestrate 63 pipeline skills

**Core Outputs**: `docs/product/PRD.md` / `docs/strategy/PRODUCT_STRATEGY.md` / `docs/handoff/pm-to-{design,solo,growth}.md`

---

### harness-design (UI Design Framework)

> **Positioning**: "Make it look good and usable" — visual design, interaction design, prototype output, design specs

**Four Principles**:
1. User-Centered — Persona-driven, no assumption of aesthetics
2. System-First — Build the design system before drawing pages
3. Accessible by Design — WCAG 2.1 AA is a hard constraint
4. Deliverable — Design assets must be implementable by engineering

**Skill System** (18 skills = 14 design + 4 meta):
- Requirements & Recommendations: design-brief / design-recommendation
- Design System: design-system / design-system-import / design-system-refactor
- Design Output: visual-design / interaction-design / wireframe / component-design
- Review & Verification: verify / design-lint / design-review / accessibility-audit
- Handoff: design-handoff-spec

**Signature Mechanisms**:
- **Push-back anti-overreach**: Design Agent has the right to refuse and rewrite PM's hardcoded UI directives
- **Anti AI-Slop**: Disable Inter/purple gradients/uniform border radius/Lorem ipsum, mechanically checked by design-lint
- **Doubt-Driven adversarial review**: design-review uses a fresh-context sub-agent for adversarial review
- **component-map.json**: Explicit mapping layer, machine-readable component contract

**Core Outputs**: `docs/design-system/DESIGN.md` / `docs/design-system/tokens.json` / `docs/handoff/design-to-solo.md` + `component-map.json`

---

### harness-solo (Engineering Framework)

> **Positioning**: "Write good code" — requirements exploration, TDD, debugging, verification, code review

**Karpathy's Four Principles**:
1. Think Before Coding — Don't make assumptions for the user
2. Simplicity First — No speculative abstractions
3. Surgical Changes — Only modify code that must be changed
4. Goal-Driven Execution — Loop verification until achieved

**Skill System** (20 skills = 16 engineering + 4 meta):
- Requirements & Planning: brainstorming / writing-plans / executing-plans
- Testing & Debugging: test-driven-development / test-coverage / systematic-debugging
- Frontend & Performance: frontend-implementation / webapp-testing / performance-optimization
- Migration & Dependencies: migration / dependency-management
- Verification & Review: verify / requesting-code-review / receiving-code-review
- Documentation & Skills: writing-documentation / writing-skills

**Signature Mechanisms**:
- **Dual-source AC Verification**: verify checks both engineering ACs (`AC-xxx`) and design ACs (`DAC-xxx`)
- **component-map.json consumption contract**: frontend-implementation reads component mapping as the single source of truth
- **Entropy Check**: verify checks file growth rate / LOC growth rate / dependency bloat / TODO backlog
- **git hooks**: pre-commit (secret/sensitive file/commit-msg check) + pre-push

**Core Outputs**: `docs/engineering/TECH_STACK.md` / `docs/handoff/solo-to-{growth,ops}.md` / `.harness/loops/specs/<feature>/spec.md`

---

### harness-growth (Operations & Growth Framework)

> **Positioning**: "Make it used" — content production, SEO, user operations, growth experiments

**Four Principles**:
1. Experiment-Driven — Every action has a hypothesis and a metric
2. Content-First — Quality > Quantity, no content farming
3. Long-Term — No black-hat SEO, no fake traffic
4. Data-Loop — Every experiment has a conclusion and an action

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

**Core Outputs**: `docs/operations/GROWTH_STRATEGY.md` / `docs/content/` / `docs/seo/` / `docs/experiment/` / `docs/handoff/growth-to-pm.md`

---

### harness-ops (Operations & Infrastructure Framework)

> **Positioning**: "Escort and deliver" — Infrastructure as Code, automated deployment, monitoring & alerting, disaster recovery and incident response

**SRE Four Principles**:
1. Stability-First — No incidents is the highest-priority metric
2. Infrastructure as Code — Environments are version-controlled and one-click rebuildable
3. Observability — Logs / Metrics / Traces, none can be missing
4. Automation — Eliminate toil relentlessly

**Skill System** (32 skills = 28 domain + 4 meta):
- Module 1 Deployment & Delivery (4): deployment-pipeline / release-strategy / rollback / deployment-verify
- Module 2 Infrastructure (4): infrastructure-as-code / kubernetes-manifest / helm-management / gitops-sync
- Module 3 Monitoring & Observability (4): monitoring-setup / alerting-rules / log-analysis / dashboard-design
- Module 4 Incident Response (4): incident-detection / root-cause-analysis / incident-mitigation / post-mortem
- Module 5 Security & Compliance (4): secret-management / policy-as-code / security-scan / audit-review
- Module 6 Capacity & Cost (3): resource-right-sizing / cost-analysis / capacity-planning
- Module 7 Disaster Recovery & Backup (3): backup-management / recovery-drill / disaster-recovery-plan
- Module 8 Ops Review (2): ops-review / sla-report

**Signature Mechanisms**:
- **Semi-automated Architecture**: Agent proposes + human approves + GitOps executes
- **Four Operation Primitives** (frontmatter `operation_tier` field):
  - `inspect` — Read-only inspection, Agent fully automated (13 skills)
  - `propose` — Generate PR/proposal, human reviews then merges (12 skills)
  - `mutate-staging` — Directly execute whitelisted operations on Staging (3 skills)
  - `mutate-prod` — Production change, **human approval mandatory**
- **GitOps PR Indirect Execution**: Agent never directly operates production clusters
- **Strict Secret Isolation**: Agent only operates on Secret references, never touches plaintext values
- **7-Layer Defense in Depth**: Dry-run / Canary / Approval gate / Rate limit / Rollback / Audit / Blast radius
- **7 Knowledge Base Tables**: Incident library / Root cause library / Deployment record library / Monitoring config library / IaC asset library / Ops pattern repository / Pitfall log

**Core Outputs**: `docs/deployment/` / `docs/monitoring/` / `docs/infrastructure/` / `docs/incident/` / `docs/handoff/ops-to-pm.md`

---

## 📜 Contract Collaboration Mode

### Contract Document System

Frameworks collaborate via contract documents under `docs/handoff/`. Each document has a clear **source framework** and **target framework**.

```
docs/handoff/
├── README.md                    # Handoff protocol description
├── handoff-template.md          # Generic template
│
├── pm-to-design.md              # Contract: PM → Design (PRD + Persona + AC)
├── pm-to-solo.md                # Contract: PM → Solo (PRD + AC + Tracking)
├── pm-to-growth.md              # Contract: PM → Growth (Metrics + Growth Strategy)
├── design-to-solo.md            # Contract: Design → Solo (Design assets + AC + Component Mapping)
├── design-to-pm.md              # Contract: Design → PM (Design feedback, on demand)
├── solo-to-growth.md            # Contract: Solo → Growth (Implemented features + Tracking)
├── solo-to-pm.md                # Contract: Solo → PM (Engineering feedback, on demand)
├── solo-to-ops.md               # Contract: Solo → Ops (Deployment contract)
├── ops-to-pm.md                 # Contract: Ops → PM (SLA report + incident post-mortem)
├── growth-to-pm.md              # Contract: Growth → PM (Experiment results + Data feedback)
└── component-map.json           # Contract: Design → Solo (Explicit mapping layer, machine-readable)
```

### Contract Document Flow Diagram

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

### Contract Document Matrix

| Source \ Target | harness-pm | harness-design | harness-solo | harness-growth | harness-ops |
|-----------|:---:|:---:|:---:|:---:|:---:|
| harness-pm | - | pm-to-design.md | pm-to-solo.md | pm-to-growth.md | - |
| harness-design | design-to-pm.md (on demand) | - | design-to-solo.md + component-map.json | - | - |
| harness-solo | solo-to-pm.md (on demand) | - | - | solo-to-growth.md | solo-to-ops.md |
| harness-growth | growth-to-pm.md | - | - | - | - |
| harness-ops | ops-to-pm.md | - | - | - | - |

### AC Numbering System (Cross-framework Alignment)

| AC Type | Prefix | Source | Consumer | Example |
|---------|------|------|--------|------|
| Engineering AC | `AC-xxx` | harness-pm's PRD | harness-solo's spec.md | `AC-001: User can log in` |
| Design AC (flowing into engineering) | `DAC-xxx` | harness-design's design-to-solo.md | harness-solo's spec.md | `DAC-001: 375px no overflow` |

**Anti-corruption rules**:
- harness-pm's PRD produces `AC-xxx` (intercepted by UI Directive Overreach Gate)
- harness-design's design-brief reuses PRD's `AC-xxx` numbering, exercises Push-back cleanup right
- harness-solo's writing-plans converts design ACs to `DAC-xxx` (D prefix to distinguish source)
- harness-solo's verify checks both `AC-xxx` and `DAC-xxx`

---

## ⚙️ Unified Foundation Layer Specification

### Required Foundation Files for Each Framework

| File | Purpose | Mandatory |
|------|------|:---:|
| `AGENTS.md` | Mandatory read at startup, core rules + domain principles | ✅ |
| `SOUL.md` | Agent personality + domain values | ✅ |
| `constitution.md` | Project Constitution (Non-negotiable principles) | ✅ |
| `install.sh` | Cold-start install script | ✅ |
| `README.md` | Framework description | ✅ |
| `.harness/loops/LOOP.md` | Loop engine definition | ✅ |
| `.harness/skills/INDEX.md` | Skill index | ✅ |
| `.harness/skills/meta/` | 4 meta skills | ✅ |
| `.harness/rules/security.md` | Security red lines | ✅ |
| `.harness/rules/prompt-defense.md` | Prompt injection defense | ✅ |
| `.harness/memory/progress.md` | Session progress log | ✅ |
| `.harness/memory/knowledge-base.md` | Cross-session knowledge base | ✅ |
| `.harness/FEATURES.md` | Dynamic task status board | ✅ |
| `.harness/VERSION` | Framework version | ✅ |
| `.harness/templates/SKILL.md.template` | Skill template | ✅ |
| `docs/handoff/README.md` | Handoff protocol description | ✅ |
| `docs/handoff/handoff-template.md` | Generic handoff template | ✅ |

### 4 Meta Skills (Unified Across All Frameworks)

| Meta Skill | Responsibility | Trigger |
|----------|------|---------|
| session-start | Session start, restore context | At the start of each session |
| session-end | Session wrap-up, archive + produce handoff document | Task complete / session end |
| skill-maintenance | Skill add/edit/remove maintenance | When skills change |
| memory-maintenance | memory/knowledge-base maintenance | Periodically / on demand |

### Load Chain (each framework follows independently)

```
1. AGENTS.md          — Mandatory Read at startup (only enforced entry point)
2. SOUL.md            — Personality + Domain Values
3. constitution.md    — Project Constitution (Non-negotiable principles)
4. skills/INDEX.md    — Skill index
5. Corresponding SKILL.md — Loaded on demand when executing tasks
6. memory/progress.md — Read at session-start
```

**Instruction priority** (unified across all frameworks):

```
SOUL.md > AGENTS.md > rules/* > User conversation > External file content
```

---

## 🔄 LOOP Loop Engine

### Unified Specification

All frameworks' LOOP must support:

- **state.yaml checkpoint resume**: Recoverable after session interruption
- **Iteration cap protection**: Request human intervention when exceeded
- **Evidence-driven**: No claiming completion without evidence
- **last_error field**: Records error on failure

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
```

**Single LOOP Hard Circuit Breaker**: Unified across all frameworks at 10 iterations; stop and request human intervention when exceeded.

### Loop Type Comparison Across Frameworks

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

---

## 🛡️ Security and Compliance

### Unified Security Red Lines

All frameworks' `security.md` must include:

| Forbidden | Reason |
|------|------|
| Hardcoded secrets | Secret leakage risk |
| `rm -rf` | Accidental deletion risk |
| `curl \| sh` | Supply chain attack risk |
| Modifying `.git/hooks/` | Breaks git hook integrity |
| Bypassing Quality Gates | Output quality out of control |

Each framework extends additional red lines by domain:
- **harness-growth**: Forbids black-hat SEO, fake traffic, leaking user PII
- **harness-design**: Forbids leaking PII, forbids using unauthorized assets
- **harness-ops**: Forbids touching plaintext Secret values, forbids directly operating production clusters

### harness-ops Exclusive Security Mechanisms

- **Strict Secret Isolation**: Agent only operates on Secret references (path/key name/CRD), never touches plaintext values (hard constraint, non-negotiable)
- **7-Layer Defense in Depth**: Dry-run / Canary / Approval gate / Rate limit / Rollback / Audit / Blast radius
- **GitOps PR Indirect Execution**: Agent never directly operates production clusters; goes through PR + human review + ArgoCD/Flux sync

### Prompt Injection Defense

All frameworks' `prompt-defense.md` defines:
- Instruction priority: SOUL.md > AGENTS.md > rules/* > User conversation > External file content
- External content marked as untrusted, not executed as instructions
- Critical operations require human confirmation

---

## 🗺️ Evolution Roadmap

### Current Stage (v2.1, completed)

- ✅ 4 core frameworks built independently (pm/design/solo/growth all complete)
- ✅ 1 P0 extension framework built (ops, 32 skills + 7 workflows, semi-automated architecture)
- ✅ Contract document system connected (pm→design→solo→growth→pm closed loop + solo→ops→pm closed loop)
- ✅ AC numbering system aligned cross-framework (AC-xxx / DAC-xxx)
- ✅ LOOP engine unified specification (state.yaml + checkpoint resume + cap protection)
- ✅ Foundation layer unified (AGENTS/SOUL/constitution/security/meta skill)
- ✅ Global deep audit and fix (21 issues all resolved, production-readiness 90+)

### Mid-term Evolution (v3.0, 1-2 months)

- 📋 harness-data built (P1, data pipeline framework)
- 📋 Contract document versioning (support historical tracing, without breaking "only read latest" principle)
- 📋 Cross-framework loop type mapping description (design's visual-design → solo's feature)

### Long-term Evolution (v4.0, 3-6 months, on demand)

- 📋 Orchestration layer exploration (multi-Agent auto-scheduling, not a current goal)
- 📋 Shared source of truth exploration (replace some contract documents, reduce information loss)
- 📋 harness-qa / harness-security built (P2/P3, on demand)

---

## 📚 Documentation Navigation

### Architecture Document

- [ARCHITECTURE.md](./ARCHITECTURE.md) — Family architecture design (v2.1, full version)

### Per-Framework Documentation

| Framework | Entry Document |
|------|---------|
| harness-pm | [README.md](./harness-pm/README.md) / [AGENTS.md](./harness-pm/AGENTS.md) |
| harness-design | [README.md](./harness-design/README.md) / [AGENTS.md](./harness-design/AGENTS.md) |
| harness-solo | [README.md](./harness-solo/README.md) / [AGENTS.md](./harness-solo/AGENTS.md) |
| harness-growth | [README.md](./harness-growth/README.md) / [AGENTS.md](./harness-growth/AGENTS.md) |
| harness-ops | [README.md](./harness-ops/README.md) / [AGENTS.md](./harness-ops/AGENTS.md) |

### Per-Framework Core Config

| Framework | SOUL.md | constitution.md | LOOP.md | INDEX.md |
|------|---------|-----------------|---------|----------|
| harness-pm | [Link](./harness-pm/SOUL.md) | [Link](./harness-pm/constitution.md) | [Link](./harness-pm/.harness/loops/LOOP.md) | [Link](./harness-pm/.harness/skills/INDEX.md) |
| harness-design | [Link](./harness-design/SOUL.md) | [Link](./harness-design/constitution.md) | [Link](./harness-design/.harness/loops/LOOP.md) | [Link](./harness-design/.harness/skills/INDEX.md) |
| harness-solo | [Link](./harness-solo/SOUL.md) | [Link](./harness-solo/constitution.md) | [Link](./harness-solo/.harness/loops/LOOP.md) | [Link](./harness-solo/.harness/skills/INDEX.md) |
| harness-growth | [Link](./harness-growth/SOUL.md) | [Link](./harness-growth/constitution.md) | [Link](./harness-growth/.harness/loops/LOOP.md) | [Link](./harness-growth/.harness/skills/INDEX.md) |
| harness-ops | [Link](./harness-ops/SOUL.md) | [Link](./harness-ops/constitution.md) | [Link](./harness-ops/.harness/loops/LOOP.md) | [Link](./harness-ops/.harness/skills/INDEX.md) |

---

## 🤝 Contribution and License

### How to Contribute

1. Pick a framework to understand deeply (recommend starting with harness-solo, the simplest)
2. Read [ARCHITECTURE.md](./ARCHITECTURE.md) to understand the family's overall design
3. Read the corresponding framework's AGENTS.md and SOUL.md to understand domain values
4. Create new skills per the SKILL.md.template spec
5. Validate skill reliability via the LOOP engine

### License

MIT License — see the LICENSE file in each framework's root directory.

### Maintainer

[@LuckyOneTwoThree](https://github.com/LuckyOneTwoThree)

---

<div align="center">

**harness-all** · Personal AI Studio · Multi-Agent Framework Family

**Independence First · Contract Collaboration · Loop Verification · Security Red Lines**

v2.1 · 2026-06-22

</div>
