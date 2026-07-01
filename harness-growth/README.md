<div align="center">

# harness-growth

### Personal Growth Operations Framework · Let Agents Run Operations by Growth Principles

**Focus on "getting the product used"** · Content Production · SEO · User Operations · Growth Experiments

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#cross-platform-compatibility)
[![Principles](https://img.shields.io/badge/principles-Growth%204-orange.svg)](#growth-four-principles-in-detail)
[![Workflows](https://img.shields.io/badge/workflows-7-brightgreen.svg)](#workflows-in-detail)
[![Skills](https://img.shields.io/badge/skills-40-brightgreen.svg)](#core-features)

**[Quick Start](#quick-start)** · **[Directory Structure](#directory-structure)**

</div>

---

> For product research / UI design / engineering development, see other members of the harness family; hand off via `docs/handoff/`.

## What Is This

harness-growth is a **growth operations framework for AI Agents**. It is not a codebase, but a set of rules + skills + workflows + state management mechanisms that let Agents help you with growth by:

- **Experiment-Driven** — Every action has a hypothesis and a metric
- **Content-First** — Quality > quantity; no content farming
- **Long-Term** — No black-hat SEO; no fake traffic
- **Data-Loop** — Every experiment has a conclusion and an action

These four are the core constraints of the growth framework, corresponding to the Karpathy Four Principles of harness-solo.

## Core Features

### Growth Four Principles (Integrated into AGENTS.md + SOUL.md)

| Principle | Meaning | Implementation |
|------|------|---------|
| Experiment-Driven | Growth is an experiment, not a gut call | PLAN stage must write hypothesis and metrics |
| Content-First | Content quality > quantity | Content production skills check quality gates |
| Long-Term | SEO long-termism; no black-hat | security.md forbids black-hat tactics |
| Data-Loop | Every experiment has a conclusion and an action | MEASURE stage must write a conclusion |

### LOOP Cycle Engine

```
PLAN → EXPERIMENT → MEASURE → Pass? DONE : Back to EXPERIMENT/PLAN
```

- One `state.yaml` per experiment, supports checkpoint resume
- Iteration limit protection: exceeding 5 requests human intervention
- Evidence-driven: no claiming done without data

### 4 Meta Skills (Built)

**Meta skills** : session-start / session-end / skill-maintenance / memory-maintenance

### Domain Skills (9 modules, 36 domain skills (+ 4 meta = 40 total), ✅ all built)

Categorized by AARRR + supporting layer:

- **Module 1 Growth Strategy** (5 skills, ✅): nsm-definition / kpi-tree / aarr-diagnosis / growth-loop-design / four-fits-assessment
- **Module 2 Growth Experiments** (6 skills, ✅): hypothesis-generation / ice-scoring / experiment-design / sample-size-calc / experiment-analysis / experiment-conclusion
- **Module 3 Content Marketing** (5 skills, ✅): content-ideation / content-creation / content-review / content-distribution / content-performance
- **Module 4 SEO Optimization** (5 skills, ✅): keyword-research / serp-analysis / onpage-optimization / technical-seo-audit / ranking-tracking
- **Module 5 User Operations** (5 skills, ✅): user-segmentation / onboarding-design / aha-moment-identification / retention-analysis / churn-rescue
- **Module 6 Acquisition & Paid Media** (3 skills, ✅): channel-assessment / landing-page-optimization / cac-analysis
- **Module 7 Monetization** (3 skills, ✅): pricing-strategy / paywall-optimization / nrr-analysis
- **Module 8 Data Analysis** (3 skills, ✅): funnel-analysis / cohort-analysis / metric-anomaly-detection
- **Module 9 Growth Review** (1 skill, ✅): growth-review

See `.harness/skills/INDEX.md` for the full index.

### Workflows (7, ✅ all built)

- **setup** [skip] (✅): Project kickoff guidance — guide filling in SOUL/constitution/GROWTH_STRATEGY
- **growth-experiment-workflow** (✅): hypothesis-generation → ice-scoring → experiment-design → sample-size-calc → [execute] → experiment-analysis → experiment-conclusion
- **growth-review-workflow** (✅): data analysis → aarr-diagnosis → growth-review
- **content-marketing-workflow** (✅): content-ideation → content-creation → content-review[quality gate] → content-distribution → [publish] → content-performance
- **seo-optimization-workflow** (✅): keyword-research → serp-analysis → onpage-optimization → technical-seo-audit[quality gate] → [publish] → ranking-tracking
- **lifecycle-operations-workflow** (✅): user-segmentation → onboarding-design → aha-moment-identification → retention-analysis[metric gate] → churn-rescue
- **growth-strategy-workflow** (✅): nsm-definition → kpi-tree → aarr-diagnosis → growth-loop-design → four-fits-assessment[quality gate]

### Cross-Platform Compatibility

- **Agent tools first** : All flows prefer tools like Read/Write/Edit/Glob/Grep
- **Optional bash fallback** : Scripts include bash availability checks; auto-skipped on Windows
- **No dependency on PowerShell-specific syntax**

### Security Red Lines

| Forbidden | Detection |
|------|---------|
| Black-hat SEO (keyword stuffing, hidden text, link farms) | security.md + Agent refusal |
| Fake traffic (clicks, downloads, ratings, followers) | security.md + Agent refusal |
| Leaking user PII | security.md + data masking |
| Scraping competitors' non-public data | security.md + Agent refusal |

## Quick Start

### 1. Install into Your Project

```bash
# Run in your project root directory
bash install.sh
```

install.sh will:
- Create the `.harness/` directory structure
- Generate `AGENTS.md` / `SOUL.md` / `constitution.md` from templates
- Create the `docs/` directory (content/seo/experiment/operations/handoff)
- Initialize `docs/operations/GROWTH_STRATEGY.md`

> Windows users: run install.sh with Git Bash or WSL.

### 2. Fill in Project Configuration

Edit the following files:
- `SOUL.md` : Persona + growth preferences
- `constitution.md` : Project constitution (non-negotiable principles)
- `docs/operations/GROWTH_STRATEGY.md` : Growth strategy (goals, channels, experiment plan)

### 3. Start Growth Work

Tell the Agent:
- "I want to create a piece of content about X" → content production
- "Optimize this page's SEO" → SEO optimization
- "Design an A/B test" → growth experiment
- "Analyze last week's retention data" → growth analysis

The Agent will automatically load the corresponding skill and proceed accordingly.

## Directory Structure

```
harness-growth/
├── AGENTS.md                          # Must-read on startup (only mandatory entry point)
├── SOUL.md                            # Agent persona + growth values
├── constitution.md                    # Project constitution (non-negotiable principles)
├── install.sh                         # Cold-start install script
├── .gitignore
├── .harness/
│   ├── VERSION
│   ├── FEATURES.md                    # Dynamic experiment status board
│   ├── loops/
│   │   └── LOOP.md                    # Cycle engine definition
│   ├── memory/
│   │   ├── progress.md                # Session progress log
│   │   └── knowledge-base.md          # Cross-session knowledge base
│   ├── rules/
│   │   ├── security.md                # Security red lines
│   │   └── prompt-defense.md          # Prompt injection defense
│   ├── skills/
│   │   ├── INDEX.md                   # Skill index (within 80 lines)
│   │   ├── meta/                      # 4 meta skills
│   │   ├── strategy/                  # Growth strategy skills (5)
│   │   ├── experiment/                # Growth experiment skills (6)
│   │   ├── content/                   # Content marketing skills (5)
│   │   ├── seo/                       # SEO optimization skills (5)
│   │   ├── lifecycle/                 # User operations skills (5)
│   │   ├── acquisition/               # Acquisition & paid media skills (3)
│   │   ├── monetization/              # Monetization skills (3)
│   │   ├── analytics/                 # Data analysis skills (3)
│   │   ├── review/                    # Growth review skills (1)
│   │   └── workflows/                 # Workflows (7)
│   └── templates/                     # Document templates
└── docs/
    ├── content/                       # Content assets
    ├── seo/                           # SEO assets
    ├── experiment/                    # Experiment records
    ├── operations/                    # Operations docs (GROWTH_STRATEGY.md)
    └── handoff/                       # harness family handoff documents
        ├── README.md
        └── templates/                 # handoff templates (scaffolds)
            ├── handoff-template.md
            └── growth-to-pm-template.md
```

## Document System

### Core Files

| File | Purpose | Author |
|------|------|------|
| `AGENTS.md` | Entry point, core rules + growth four principles | Provided by framework, customizable per project |
| `SOUL.md` | Agent persona + growth preferences | Filled by user |
| `constitution.md` | Project constitution (non-negotiable principles) | Filled by user |
| `docs/operations/GROWTH_STRATEGY.md` | Growth strategy (goals + channels + experiment plan) | Filled by user |
| `.harness/FEATURES.md` | Dynamic experiment status board | Batch-synced at session-end |

## LOOP Cycle Engine

### state.yaml Schema

```yaml
# Required
current_task: 001-blog-seo-experiment
iteration: 2
stage: experiment     # plan / experiment / measure / revise
status: running       # running / retrying / done / failed / needs-human / blocked
started_at: "2026-06-21T14:30:00"

# Optional (on failure)
last_error: "Insufficient experiment data samples; cannot reach a significant conclusion"
last_error_at: "2026-06-21T14:45:00"

# Optional (sub-stage)
substage: "ab-test"
```

### Checkpoint Resume

After a session interruption, session-start reads `state.yaml` and resumes from the interruption point.

### Over-Limit Protection

| Cycle Type | Iteration Limit | Over-Limit Handling |
|---------|:---:|---------|
| content | 3 | Request human intervention |
| seo | 5 | Request human intervention |
| experiment | 3 | Request human intervention |
| optimization | 3 | Request human intervention |
| monetization | 3 | Request human intervention |
| lifecycle | 5 | Request human intervention |
| Total cycle | 10 | Request human intervention |

## harness Family

harness-growth is the **growth operations** member of the harness family, focused on getting the product used. Other members collaborate via document handoff:

| Family Member | Responsibility | Handoff |
|---------|------|---------|
| harness-pm | Product research / market / PRD | Consumes pm output; feeds back growth data |
| harness-solo | Engineering development | Produces `solo-to-growth.md` → consumed by this framework |
| harness-design | UI/visual design (on demand) | Produces design artifacts → referenced by this framework |
| **harness-growth (this framework)** | **Growth operations** | Produces `growth-to-pm.md` → fed back to pm |

## Growth Four Principles in Detail

### 1. Experiment-Driven

**Growth is an experiment, not a gut call; every action has a hypothesis and a metric.**

- Every growth action starts with a hypothesis ("doing X will lift Y by Z%")
- Every experiment defines metrics (primary metric + guardrail metrics)
- Actions without a hypothesis and metrics are not taken
- A failed experiment is also a conclusion; record and archive it

### 2. Content-First

**Content quality > quantity; no content farming.**

- One high-quality piece > ten low-quality pieces
- No keyword stuffing for SEO; no mass-produced homogeneous content
- Content must be valuable to users, not written for algorithms

### 3. Long-Term

**SEO is a long-term investment; no black-hat, no fake traffic.**

- No keyword stuffing, hidden text, or link farms
- No fake clicks, downloads, or ratings
- Accept that SEO takes time (3–6 months); do the right thing

### 4. Data-Loop

**Every experiment has a conclusion; every conclusion has an action; form a closed loop.**

- An experiment must end with a conclusion (effective / ineffective / inconclusive)
- Effective → scale up; ineffective → stop; inconclusive → redesign the experiment
- Loop: hypothesis → experiment → measure → conclusion → action → new hypothesis

## Security Red Lines

See [`.harness/rules/security.md`](.harness/rules/security.md) for full security rules.

| Forbidden | Reason |
|------|------|
| Black-hat SEO | Search engine penalty risk; harms long-term brand |
| Fake traffic (clicks/downloads/ratings/followers) | Fake data pollutes decisions; violates platform rules |
| Leaking user PII | Privacy compliance risk (GDPR/CCPA) |
| Scraping competitors' non-public data | Legal risk; violates ToS |
| Modifying `.git/hooks/` | Breaks git hook integrity |

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

**[⬆ Back to top](#harness-growth)**

</div>
