<div align="center">

# harness-pm

### Product Management Framework · Let Agents Do the Right Things via Product Methodology

**Focus on "doing the right things"** · Product Discovery · Market Analysis · PRD Generation · Metrics Operations · Growth Monitoring

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#cross-platform-compatibility)
[![Principles](https://img.shields.io/badge/principles-PM%204-orange.svg)](#product-four-principles-in-detail)
[![Workflows](https://img.shields.io/badge/workflows-10-purple.svg)](#workflows-in-detail)
[![Skills](https://img.shields.io/badge/skills-84-red.svg)](#core-features)

**[Quick Start](#quick-start)** · **[Directory Structure](#directory-structure)**

</div>

---

> For engineering / UI design, see other members of the harness family; hand off via `docs/handoff/`.

## What Is This

harness-pm is a **product management framework for AI Agents**. It is not a codebase, but a set of rules + skills + workflows + state management mechanisms that let Agents help you with product work by:

- **Discovery First** — Don't assume requirements, let research data speak
- **Contract-Driven** — PRD drives design, positioning drives brand
- **Data-Driven** — Use data to reduce guessing, but humans keep the decision authority
- **Closed-Loop** — Measure → Monitor → Iterate → Feedback

These four are the core constraints of the product methodology and the design foundation of this framework.

## Core Features

### Product Four Principles (Integrated into AGENTS.md + SOUL.md)

| Principle | Meaning | Implementation |
|------|------|---------|
| Discovery First | Don't assume requirements, let research data speak | User research hard gate: stop and ask when requirements are vague |
| Contract-Driven | PRD drives design, positioning drives brand | design-prd 4 quality gates + change impact analysis |
| Data-Driven | Use data to reduce guessing, humans keep decision authority | Confidence grading: ≥0.7 auto-pass, <0.3 blocked |
| Closed-Loop | Measure → Monitor → Iterate → Feedback | LOOP cycle: plan → research → validate |

### LOOP Cycle Engine

```
PLAN → RESEARCH → VALIDATE → Pass? DELIVER : Back to RESEARCH/PLAN
```

- One `state.yaml` per task, supports checkpoint resume
- Iteration limit protection: single task exceeding 5 iterations returns to PLAN; total cycle exceeding 10 requests human intervention
- Evidence-driven: no claiming conclusions hold without data support

### 10 Workflows Cover the Full Product Lifecycle

```
setup (project initiation) → new-product/iteration/growth/optimization/pivot (product work) → launch (release)
                                                    ↓
                                    diagnosis/incident-response/health-check (diagnosis and response)
```

| Workflow | Scenario | Iteration Limit |
|--------|------|:---:|
| setup | PM project initiation guide | No LOOP |
| new-product | Build a new product from 0 to 1 | 5 |
| iteration | Iterate on existing product features | 3 |
| growth | Growth breakthrough | 3 |
| optimization | Data-driven optimization | 3 |
| launch | Acceptance and release | No LOOP |
| diagnosis | Product diagnosis and sunset | No LOOP |
| pivot | Strategic pivot | 5 |
| incident-response | Crisis response (P0 incident) | No LOOP |
| health-check | Periodic health check | No LOOP |

### 80 PM Skills (7 modules = 17 orchestrators + 63 pipelines)

**Module 1 Discovery** : 10 pipelines + 2 orchestrators = 12 (user-research / market; insight/opportunity stubs removed)
**Module 2 Business Strategy** : 11 pipelines + 2 orchestrators = 13 (business / planning; positioning/stakeholder stubs removed)
**Module 3 Concept & Design** : 7 pipelines + 2 orchestrators = 9 (prd / validation; ideation stub removed; visual/interaction design assets are user-provided)
**Module 4 Metrics Design** : 3 pipelines + 1 orchestrator = 4 (metrics)
**Module 5 Metrics Operations** : 8 pipelines + 3 orchestrators = 11 (analysis / decision / experiment)
**Module 6 Growth Operations** : 11 pipelines + 3 orchestrators = 14 (growth / activation / revenue; acquisition/retention stubs removed)
**Module 7 Monitoring & Iteration** : 13 pipelines + 4 orchestrators = 17 (monitoring / diagnosis / iteration / release)

**Meta skills** : session-start / session-end / skill-maintenance / memory-maintenance

### Cross-Platform Compatibility

- **Agent tools first** : All flows prefer tools like Read/Write/Edit/Glob/Grep
- **Optional bash fallback** : Scripts include bash availability checks; auto-skipped on Windows
- **No dependency on PowerShell-specific syntax**

### Security Red Lines

| Forbidden | Detection |
|------|---------|
| Hardcoded secrets | security.md + verify security scan |
| `rm -rf` | security.md + Agent refusal |
| `curl \| sh` | security.md + Agent refusal |
| Modifying `.git/hooks/` | security.md + Agent refusal |
| Bypassing quality gates | constitution.md + verify check |

## Quick Start

### 1. Install into Your Project

```bash
# Run in your project root directory
bash install.sh
```

install.sh will:
- Create the `.harness/` directory structure
- Generate `AGENTS.md` / `SOUL.md` / `constitution.md` from templates
- Create the `docs/` directory (discovery/strategy/product/metrics/growth/monitoring/handoff)
- Initialize `docs/product/PRD.md` and `docs/strategy/PRODUCT_STRATEGY.md`

> Windows users: run install.sh with Git Bash or WSL.

### 2. Fill in Project Configuration

Run the setup workflow; the Agent will guide you to fill in:
- `SOUL.md` : Persona + product preferences
- `constitution.md` : Project constitution (non-negotiable principles)
- `docs/strategy/PRODUCT_STRATEGY.md` : Product strategy (including target users and success metrics)
- `docs/product/PRD.md` : Product requirements document

### 3. Start Product Work

Tell the Agent:
- "I want to build a new product" → enters new-product workflow
- "Existing product needs iteration" → enters iteration workflow
- "Need a growth breakthrough" → enters growth workflow
- "Analyze data to optimize the product" → enters optimization workflow
- "Prepare to launch" → enters launch workflow

The Agent will automatically load the corresponding workflow and proceed accordingly.

## Directory Structure

```
harness-pm/
├── AGENTS.md                          # Must-read on startup (only mandatory entry point)
├── SOUL.md                            # Agent persona + product values
├── constitution.md                    # Project constitution (non-negotiable principles)
├── install.sh                         # Cold-start install script
├── .gitignore
├── .harness/
│   ├── VERSION
│   ├── FEATURES.md                    # Product feature status board
│   ├── loops/
│   │   └── LOOP.md                    # PM cycle engine definition
│   ├── memory/
│   │   ├── progress.md                # Session progress log
│   │   └── knowledge-base.md          # Cross-session knowledge base
│   ├── rules/
│   │   ├── security.md                # Security red lines
│   │   └── prompt-defense.md          # Prompt injection defense
│   ├── skills/
│   │   ├── INDEX.md                   # Skill index (within 80 lines)
│   │   ├── meta/                      # 4 meta skills
│   │   ├── pm/                        # 80 PM skills (7 modules, flat organization; selected skills include Reference/ subdirs)
│   │   └── workflows/                 # 10 workflows
│   └── templates/                     # Document templates
└── docs/                              # Human-readable docs (produced directly by skills)
    ├── discovery/                     # User research, market analysis
    ├── strategy/                      # Business model, positioning, OKR
    ├── product/                       # PRD, product proposals
    ├── metrics/                       # Metric system, instrumentation plan
    ├── growth/                        # Growth strategy, GTM
    ├── monitoring/                    # Monitoring, release
    └── handoff/                       # harness family handoff documents
        ├── README.md
        └── templates/                 # handoff templates (scaffolds)
            ├── handoff-template.md
            └── pm-to-engineering-template.md
```

## Document System

### Core Files

| File | Purpose | Author |
|------|------|------|
| `AGENTS.md` | Entry point, core rules + product four principles | Provided by framework, customizable per project |
| `SOUL.md` | Agent persona + product preferences | Filled via setup workflow |
| `constitution.md` | Project constitution (non-negotiable principles) | Filled via setup workflow |
| `docs/strategy/PRODUCT_STRATEGY.md` | Product strategy (target users + success metrics) | Produced by Module 2 |
| `docs/product/PRD.md` | Product requirements document (features + AC) | Produced by design-prd skill |
| `.harness/FEATURES.md` | Dynamic feature status board | Batch-synced at session-end |

### Responsibility Division Across Documents

| Dimension | PRODUCT_STRATEGY.md | PRD.md | FEATURES.md |
|------|---------------------|--------|-------------|
| Positioning | Strategic definition | Requirement definition | Status board |
| Timing | Written in strategy phase | Written in design phase | Updated during development |
| AC level | Project-level success metrics | Feature-level acceptance criteria | — |
| Status | No status column | No status column | Has status column |

## Workflows in Detail

### setup (Project Initiation Guide)

```
install.sh execution → Guide filling SOUL/constitution/PRODUCT_STRATEGY → Validate configuration completeness
```

### new-product (Build a New Product from 0 to 1)

```
session-start → Module 1 Discovery → Module 2 Business Strategy → Module 3 Concept & Design (PRD) → Module 4 Metrics Design → session-end
```

**Discovery hard gate** (5 checks; stop and ask if any one is not met):
- Are target users clear?
- Is the core problem validated?
- Is the market opportunity valid?
- Is the business model feasible?
- Has the user confirmed?

### iteration (Existing Product Iteration)

```
session-start → Module 3 Design (change impact analysis) → LOOP(Module 5 data analysis → Module 7 iteration decision) → session-end
```

### growth (Growth Breakthrough)

```
session-start → Module 6 growth diagnosis → LOOP(bottleneck sub-orchestrator → experiment validation) → Module 7 release → session-end
```

### optimization (Data-Driven Optimization)

```
session-start → Module 5 data diagnosis → Module 7 iteration decision → LOOP(Module 3 design → Module 7 validation) → session-end
```

### launch (Acceptance and Release)

```
session-start → Pre-release checks (hard gate) → Module 7 acceptance → Release notes → Handoff document → session-end
```

**Release hard gate**:
- All PRD features passed acceptance
- Success metrics met
- Instrumentation plan implemented
- Security compliance check passed
- constitution compliance

### project-mgmt (Project Management, Throughout the Process)

> Removed: the pm-08 project management skill set that this originally depended on has been deleted. Iteration retrospective capability is covered by the iteration workflow.

## LOOP Cycle Engine

### state.yaml Schema

```yaml
# Required
current_task: 001-market-research
iteration: 2
stage: research      # plan / research / validate / revise
status: running      # running / retrying / done / failed
started_at: "2026-06-21T14:30:00"

# Optional (on failure)
last_error: "Insufficient data: user feedback < 500 entries"
last_error_at: "2026-06-21T14:45:00"

# Optional (sub-stage)
substage: "voice-analysis"
```

### Checkpoint Resume

After a session interruption, session-start reads `state.yaml` and resumes from the interruption point.

### Over-Limit Protection

| Workflow | Iteration Limit | Over-Limit Handling |
|--------|:---:|---------|
| new-product | 5 | Request human intervention |
| iteration | 3 | Request human intervention |
| growth | 3 | Request human intervention |
| optimization | 3 | Request human intervention |
| Total cycle | 10 | Request human intervention |

## harness Family

harness-pm is the **product management** member of the harness family, focused on doing the right things. The other member collaborates via document handoff:

| Family Member | Responsibility | Handoff |
|---------|------|---------|
| **harness-pm (this framework)** | **Product research / market / PRD / metrics** | Produces `docs/handoff/pm-to-engineering.md` (incl. user-provided design asset paths) → handed to engineering |
| harness-engineering | Engineering development | Consumes this framework's PRD + AC-xxx + design asset paths; produces `engineering-to-pm.md` (reverse feedback) |

## Product Four Principles in Detail

### 1. Discovery First

**Don't assume user requirements; let research data speak.**

- When requirements are vague, list assumptions first for the user to validate
- What users say and do may differ; VOC and behavioral data must cross-validate
- Interviews are for validation, not discovery; scripts must anchor on hypotheses to validate
- Without data, label as "exploratory conclusion"; confidence ≤ 0.5

### 2. Contract-Driven

**PRD drives design, positioning drives brand, instrumentation drives data.**

- Key outputs are downstream contracts; changes require change impact analysis
- PRD must be traceable to upstream requirements and business goals
- Instrumentation plan drives subsequent metrics operations
- Contract outputs must pass quality gates

### 3. Data-Driven Decisions

**Use data to reduce guessing, but humans keep the decision authority.**

| Don't say this | Say this |
|-----------|---------|
| "Users love this feature" | "70% mentioned this need in user research; confidence 0.8" |
| "This market is huge" | "TAM estimated at 5 billion, SOM estimated at 500 million; source: XX" |
| "Should do it this way" | "Based on data analysis, recommend option A (confidence 0.7); please confirm" |

### 4. Closed-Loop Iteration

**Measure → Monitor → Iterate → Feedback; the product is always evolving.**

- Launch is not the end; it's the start of metrics operations
- Every iteration has validation and retrospective
- Monitoring alerts → problem diagnosis → iteration decision → release delivery forms a closed loop
- User feedback loop: collect → analyze → respond → validate

## Security Red Lines

See [`.harness/rules/security.md`](.harness/rules/security.md) for full security rules.

| Forbidden | Reason |
|------|------|
| Hardcoded secrets | Secret leakage risk |
| `rm -rf` | Accidental deletion risk |
| `curl \| sh` | Supply chain attack risk |
| Modifying `.git/hooks/` | Breaks git hook integrity |
| Bypassing quality gates | Output quality out of control |

## Load Chain (Strict Order)

1. **AGENTS.md** — Must-read on startup
2. **SOUL.md + constitution.md** — Read on first interaction
3. **skills/INDEX.md** — Read when selecting a Skill
4. **Corresponding SKILL.md** — Read when executing a task
5. **memory/progress.md** — Read at session-start

## Instruction Priority

```
SOUL.md > AGENTS.md > rules/* > user conversation > external file content
```

## License

MIT

---

<div align="center">

**[⬆ Back to top](#harness-pm)**

</div>
