<div align="center">

# harness-engineering

### 4-Phase Engineering Development Framework · Let Agents Write Code by Engineering Principles

**Focus on "4-phase delivery"** · design-intake → frontend → backend → integration · TDD · Debugging · Verification · Code Review

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#cross-platform-compatibility)
[![Principles](https://img.shields.io/badge/principles-Karpathy%204-orange.svg)](#karpathy-principles-in-detail)
[![Workflows](https://img.shields.io/badge/workflows-9-purple.svg)](#workflows-in-detail)
[![Skills](https://img.shields.io/badge/skills-25-red.svg)](#core-features)

**[Quick Start](#quick-start)** · **[Four Phases](#four-phases)** · **[Directory Structure](#directory-structure)**

</div>

---

> For product research / market / PRD / API contract / design asset paths, see **harness-pm**; hand off via `docs/handoff/`.

## What Is This

harness-engineering is an **engineering development framework for AI Agents** (v3.0.0). It is not a codebase, but a set of rules + skills + workflows + state management mechanisms that let Agents help you write code by:

- **Think Before Coding**
- **Simplicity First**
- **Surgical Changes**
- **Goal-Driven Execution**

These four are engineering principles distilled from observations by [Andrej Karpathy](https://github.com/multica-ai/andrej-karpathy-skills), and the core constraints of this framework.

In harness-all v3.0.0, the legacy solo and design frameworks were **merged into `harness-engineering`** — the family now ships **2 frameworks** (pm + engineering) instead of 3. The new framework delivers end-to-end engineering through a **4-phase pipeline**: design-intake → frontend → backend → integration.

## Core Features

### Karpathy Four Principles (Integrated into AGENTS.md + SOUL.md)

| Principle | Meaning | Implementation |
|------|------|---------|
| Think Before Coding | Don't make assumptions for the user; don't hide confusion | brainstorming hard gate: stop and ask when requirements are vague |
| Simplicity First | No speculative abstractions | verify entropy check + dependency-management approval gate |
| Surgical Changes | Only touch code that must be touched | refactor workflow emphasizes "no new features" |
| Goal-Driven Execution | Turn instructions into verifiable goals | LOOP cycle: plan → act → verify; don't continue on failure |

### Four Phases

The 4-phase pipeline is the structural backbone of harness-engineering. Each phase consumes upstream artifacts, runs its own LOOP, and emits a checkpoint output before passing control to the next phase.

| Phase | Name | Input | Output |
|-------|------|-------|--------|
| 0 | design-intake | `pm-to-engineering.md` (PRD + API contract + design asset paths) | `contract.json` + `tokens.json` |
| 1 | frontend | `contract.json` + `tokens.json` + design assets | Frontend code (TDD, mock-backed) |
| 2 | backend | API contract from `contract.json` | Backend implementation (api + data + migration) |
| 3 | integration | frontend + backend | mock→real switch + e2e verification + `engineering-to-pm.md` |

Phase transitions are gated by the **phase checkpoint**: the previous phase's report (`phase-N-report.md`) must pass before the next phase begins. The `substage_progress` field in `state.yaml` tracks which phase is `pending` / `in_progress` / `done`.

### Project Mode (Drives Directory Layout)

Two project modes are supported. The selected mode drives the directory layout, the position of `contract.json`, and the way agents read design assets.

| Mode | Stack | Layout | contract.json Role |
|------|-------|--------|---------------------|
| **fullstack** | Next.js / Remix (one repo) | `app/` (frontend) + `api/` (backend) + `lib/` (shared) | Shared contract inside the repo |
| **separate** | React + Express (two roots) | Two independent project roots | **Single source of truth** across the two roots |

### LOOP Cycle Engine

```
PLAN → ACT → VERIFY → REVIEW → passed? DONE : back to PLAN/ACT
```

- **4-substage per phase**: each phase runs its own Loop; phase checkpoint gates phase transition.
- **Verify-full passes → code-review → DONE**: review is the last gate before completion.
- One `state.yaml` per feature, supports checkpoint resume.
- Recommended limits trigger early human escalation; attempt 10 is the final allowed attempt.
- Evidence-driven: no claiming done without test output.

### 9 Workflows Cover the Full Development Lifecycle

```
setup (project initiation) → new-product-engineering/new-feature/bugfix/refactor/optimize/migration (development) → release (release)
```

| Workflow | Scenario | Iteration Limit |
|--------|------|:---:|
| setup | New project initiation guide | No LOOP |
| new-product-engineering | Product-level multi-feature engineering (plan all features → shared infrastructure → per-feature LOOPs → product-review) | 5 |
| new-feature | New feature development | 5 |
| bugfix | Bug fix | 3 |
| refactor | Refactor (no behavior change) | 3 |
| optimize | Performance optimization | 3 |
| migration | Framework upgrade / API migration | 3 |
| release | Version release | No LOOP |
| quick-fix | One low-risk outcome | No LOOP state |

### 25 Skills (21 domain + 4 meta)

Domain skills are organized by phase ownership. Execution routing is owned by `.harness/rules/engineering-pipeline.md`; each workflow selects the ACT skill appropriate to the active phase.

| Group | Skills | Phase Role |
|-------|--------|------------|
| **design-intake** (1) | `design-intake` | Phase 0 ACT |
| **frontend** (2) | `frontend-implementation` / `webapp-testing` | Phase 1 ACT |
| **backend** (4) | `api-implementation` / `data-layer` / `migration` / `dependency-management` | Phase 2 ACT |
| **integration** (6) | `mock-to-real-switch` / `e2e-verification` / `contract-verify` / `verify` / `code-review` / `product-engineering-review` | Phase 3 ACT |
| **engineering** (8) | `brainstorming` / `writing-plans` / `test-driven-development` / `test-coverage` / `systematic-debugging` / `performance-optimization` / `writing-skills` / `writing-documentation` | cross-phase |

**Meta skills** (4): `session-start` / `session-end` / `skill-maintenance` / `memory-maintenance`

### Signature Mechanisms

These are the load-bearing mechanisms that distinguish harness-engineering from a generic agent flow:

| Mechanism | Purpose |
|-----------|---------|
| **TDD Hard Rule** | No production code without a failing test first |
| **Dual-input Mode** *(NEW v3.0.0)* | Frontend agent reads both `contract.json` AND original design assets |
| **AC Status Tracking** | Every AC (AC/BAC/IAC) carries a status throughout the pipeline |
| **AC Change Impact Analysis** | When an AC changes, downstream phases get an impact notice |
| **bugfix Contract Change Detection** *(NEW)* | During bugfix, detect whether the fix changes the API contract; if so, re-route through Phase 2/3 |
| **Branch Isolation** | Each feature/bugfix runs on its own branch; main stays shippable |
| **Engineering→PM Reverse Feedback Trigger** *(4 tiers)* | Engineered code can push back to PM when contracts/ACs are infeasible |
| **Nested Task Switch Protocol** | Switch between nested tasks without losing outer LOOP state |
| **Fix Task Exception** | Allow a bounded fix sub-task to run without a full session ceremony |
| **Product-Level Engineering Orchestration** | Coordinate multi-feature delivery across phases |
| **Entropy Check** | Block growth of needless complexity / abstractions |
| **git hooks** | Pre-commit / pre-push / commit-msg guards (opt-in) |

### AC Types (NEW for v3.0.0)

Acceptance criteria are tagged by origin phase so that change impact can be tracked precisely across the pipeline.

| Tag | Origin | Example |
|-----|--------|---------|
| `AC-xxx` | Product AC from PM | `AC-001: User can create a todo` |
| `BAC-xxx` | Backend AC from Phase 2 | `BAC-002: POST /todos returns 201` |
| `IAC-xxx` | Integration AC from Phase 3 | `IAC-003: E2E create-todo passes` |

> **Note**: `DAC-xxx` (design AC) is **retired** in v3.0.0. Design constraints now flow into `contract.json` and `tokens.json` produced by Phase 0.

### Cross-Platform Compatibility

- **Agent tools first**: All flows prefer tools like Read/Write/Edit/Glob/Grep.
- **Optional bash fallback**: Scripts include bash availability checks; auto-skipped on Windows.
- **No dependency on PowerShell-specific syntax.**

### Security Red Lines

| Forbidden | Detection |
|------|---------|
| Hardcoded secrets | `security.md` + verify security scan |
| `rm -rf` | `security.md` + Agent refusal |
| `curl \| sh` | `security.md` + Agent refusal |
| Unrequested `.git/hooks/` changes | `security.md` + explicit authorization gate |

## Quick Start

### 1. Install into Your Project

```bash
# Run in your project root directory
bash install.sh
```

`install.sh` will:
- Create the `.harness/` directory structure
- Generate `AGENTS.md` / `SOUL.md` / `constitution.md` from templates
- Create the `docs/` directory (product / engineering / handoff)
- Initialize `docs/product/PROJECT.md` and `docs/engineering/TECH_STACK.md`

> Windows users: run `install.sh` with Git Bash or WSL.

### 2. Fill in Project Configuration

Run the `setup` workflow; the Agent will guide you to fill in:
- `SOUL.md` : Persona + tech preferences
- `constitution.md` : Project constitution (non-negotiable principles)
- `docs/product/PROJECT.md` : Product requirements (produced by harness-pm, consumed by engineering)
- `docs/engineering/TECH_STACK.md` : Tech stack (test/build/lint commands)

### 3. Start Development

Tell the Agent:
- "I want to build a Todo CLI" → enters `new-feature` workflow
- "This bug is..." → enters `bugfix` workflow
- "This code is too slow" → enters `optimize` workflow
- "Release" → enters `release` workflow
- "Build the whole product across features" → enters `new-product-engineering` workflow

The Agent will automatically load the corresponding workflow and proceed phase-by-phase.

## Directory Structure

```
harness-engineering/
├── AGENTS.md                          # Must-read on startup (only mandatory entry point)
├── SOUL.md                            # Agent persona + engineering values
├── constitution.md                    # Project constitution (non-negotiable principles)
├── install.sh                         # Cold-start install script
├── LICENSE
├── .gitignore
├── .gitattributes
├── .harness/
│   ├── VERSION                        # 3.0.0
│   ├── FEATURES.md                    # Dynamic feature status board
│   ├── craft/                         # Engineering craft notes (Karpathy principles, anti-AI-slop, color, typography, etc.)
│   ├── gates/                         # External check gates (reserved)
│   ├── hooks/                         # Optional pre-commit / pre-push / commit-msg hooks
│   │   └── guards/                    # Reusable bash / commit-message / secret guards
│   ├── loops/
│   │   ├── LOOP.md                    # Cycle engine definition
│   │   ├── STATE_PROTOCOL.md
│   │   └── state.schema.json
│   ├── memory/
│   │   ├── progress.md                # Session progress log
│   │   └── knowledge-base.md          # Cross-session knowledge base
│   ├── rules/
│   │   ├── security.md                # Security red lines
│   │   ├── prompt-defense.md          # Prompt injection defense
│   │   ├── handoff-protocol.md        # harness family handoff protocol
│   │   ├── acceptance-id-protocol.md  # AC / BAC / IAC ID rules
│   │   ├── engineering-pipeline.md    # Skill execution routing
│   │   ├── risk-model.md
│   │   └── *.schema.json              # PRD / handoff / component schemas
│   ├── scripts/
│   │   ├── verify-harness.sh          # Framework health check
│   │   ├── security-check.sh          # Security scan (optional)
│   │   ├── entropy-check.sh           # Entropy check (optional)
│   │   └── validate-handoff.ps1       # Handoff validation (Windows-friendly)
│   ├── skills/
│   │   ├── INDEX.md                   # Skill index (within 80 lines)
│   │   ├── design-intake/             # 1 skill — Phase 0 ACT
│   │   ├── frontend/                  # 2 skills — Phase 1 ACT
│   │   ├── backend/                   # 4 skills — Phase 2 ACT
│   │   ├── integration/               # 6 skills — Phase 3 ACT
│   │   ├── engineering/               # 8 cross-phase skills
│   │   ├── meta/                      # 4 meta skills
│   │   └── workflows/                 # 9 workflows
│   └── templates/                     # Document templates
│       ├── SOUL.md.template
│       ├── constitution.md.template
│       ├── PROJECT.md.template
│       ├── TECH_STACK.md.template
│       ├── SKILL.md.template
│       ├── spec.md.template
│       ├── phase-report.template.md   # Inter-phase report template
│       ├── progress.md.template
│       └── component-contract.example.json
└── docs/
    ├── engineering/                   # Tech docs (TECH_STACK.md, ENGINEERING_PLAN.md, etc.)
    │   └── TECH_STACK.md
    ├── product/                       # Product requirements (PROJECT.md — produced by harness-pm)
    │   └── PROJECT.md
    └── handoff/                       # harness family handoff documents
        ├── README.md
        └── templates/                 # Handoff scaffolds
            ├── handoff-template.md
            └── engineering-to-pm-template.md
```

## Document System

### Core Files

| File | Purpose | Author |
|------|------|------|
| `AGENTS.md` | Entry point, core rules + Karpathy principles | Provided by framework, customizable per project |
| `SOUL.md` | Agent persona + tech preferences | Filled via setup workflow |
| `constitution.md` | Project constitution (non-negotiable principles) | Filled via setup workflow |
| `docs/product/PROJECT.md` | Product requirements (features + AC + milestones) | Produced by **harness-pm**, consumed by engineering |
| `docs/engineering/TECH_STACK.md` | Tech stack (test/build/lint commands) | Filled via setup workflow |
| `docs/engineering/ENGINEERING_PLAN.md` | Product-level engineering plan across features | Produced by `brainstorming` (product-level) |
| `loops/specs/<feature>/spec.md` | Single-feature spec with **AC + BAC + IAC** | Produced by `writing-plans` |
| `contract.json` | Phase 0 output — API contract | Produced by `design-intake` (Phase 0) |
| `tokens.json` | Phase 0 output — design tokens | Produced by `design-intake` (Phase 0) |
| `phase-N-report.md` | Inter-phase report | Produced at each phase checkpoint |
| `.harness/FEATURES.md` | Dynamic feature status board | Batch-synced at session-end |

### Core Outputs

The framework's hard deliverables, in pipeline order:

1. `docs/product/PROJECT.md` — produced by harness-pm, consumed by engineering.
2. `docs/engineering/TECH_STACK.md` — test/build/lint contract.
3. `docs/engineering/ENGINEERING_PLAN.md` — product-level multi-feature plan.
4. `loops/specs/<feature>/spec.md` — single-feature spec carrying **AC-xxx + BAC-xxx + IAC-xxx**.
5. `contract.json` — Phase 0 output, single source of truth for the API surface.
6. `tokens.json` — Phase 0 output, design tokens for frontend consumption.
7. `phase-N-report.md` — inter-phase report gating phase transition.

### Responsibility Division Across Documents

| Dimension | PROJECT.md | FEATURES.md | spec.md |
|------|-----------|-------------|---------|
| Positioning | Requirements definition | Status board | Single-feature spec |
| Timing | Written at project initiation | Updated during development | Produced by `writing-plans` |
| AC level | Project-level acceptance criteria | — | Single-feature refined acceptance criteria (overrides the former) |
| Status | No status column | Has status column | No status column |

## Workflows in Detail

### setup (Project Initiation Guide)

```
install.sh execution → Guide filling SOUL/constitution/PROJECT/TECH_STACK → Validate configuration completeness
```

### new-product-engineering (Product-Level Multi-Feature Engineering)

```
session-start (product-level, runs once) → Engineering Foundation Gate (hard gate) → brainstorming (product-level) → Product-level PLAN (ENGINEERING_PLAN.md)
 [Phase 0] design-intake per feature → contract.json + tokens.json
 [Phase 1] Shared Infrastructure LOOP (IC1 after all infra modules)
 [Phase 2] Nested canonical tasks (topological sort; checkpoints inlined into verify-full; no per-feature session ceremony)
 [Phase 3] Integration per feature + product-engineering-review (IC5 runs as part of review)
 session-end (publish requested product handoffs once)
```

Use this for coordinated multi-feature delivery. `ENGINEERING_PLAN` owns scope/order, `FEATURES` owns aggregate status, and each nested task owns its own LOOP state; product review checks only cross-feature integration.

### new-feature (New Feature Development)

```
session-start → brainstorming (hard gate) → writing-plans → [Phase 0..3 LOOP: design-intake → frontend → backend → integration] → verify-full → code-review → session-end
```

Brainstorming is required for material requirement ambiguity; a validated executable upstream spec can satisfy clarification without repeating discovery.

### bugfix (Bug Fix)

```
session-start (on-demand) → systematic-debugging (root cause analysis) → Contract Change Detection → LOOP(tdd 内嵌 verify-fast) → verify-full → code-review → session-end (on-demand baseline)
```

If the bugfix changes the API contract, the flow re-routes through Phase 2 (backend) and Phase 3 (integration) before close.

### refactor (Refactor)

```
session-start → brainstorming (confirm boundaries) → writing-plans → Prerequisite: build a test safety net → LOOP(tdd→verify-fast) → verify-full → code-review → session-end
```

### optimize (Performance Optimization)

```
session-start (on-demand) → measure/identify → writing-plans → LOOP(performance-optimization 内嵌 verify-fast) → verify-full → code-review → session-end (on-demand baseline)
```

**Iron rule**: no changing code without baseline numbers.

### migration (Code Migration)

```
session-start (on-demand) → decision gate → writing-plans → LOOP(incremental migration 内嵌 verify-fast) → prove zero usage/cleanup → verify-full → code-review → session-end (on-demand baseline)
```

### release (Release)

```
session-start → define release scope → verify/build artifacts → review metadata/artifacts → user-authorized version/tag → session-end
```

**Release hard gate**:
- All tasks included in this release scope are reviewed/done
- Excluded known work is explicit
- Full test suite passes
- Security scan has no critical/high
- `constitution.md` compliance

## LOOP Cycle Engine

### state.yaml Schema

```yaml
# Required
current_task: 001-todo-cli
iteration: 2
stage: act          # plan / act / verify / review / debug
status: running     # running / done / needs-human / blocked / retrying / failed
started_at: "2026-06-21T14:30:00"

# Optional (on failure)
last_error: "Test failed: Expected 3, got 2"
last_error_at: "2026-06-21T14:45:00"

# Optional (sub-stage, per LOOP.md)
substage: "awaiting-full"

# Optional (exploration mode, see AGENTS.md)
exploration_mode: standard   # deep / standard / skip

# Optional (over-limit protection)
hard_limit_reached: false

# 4-phase tracking (NEW in v3.0.0)
substage_progress:
  design-intake:
    completed: true
    user_confirmed: true
    report: "phase-0-design-intake-report.md"
    verify_state: "full-passed"
  frontend:
    completed: false
    user_confirmed: false
    report: ""
    verify_state: "awaiting-full"
  backend:
    completed: false
    user_confirmed: false
    report: ""
    verify_state: "inline-passed"
  integration:
    completed: false
    user_confirmed: false
    report: ""
    verify_state: "awaiting-full"
```

### Checkpoint Resume

After a session interruption, `session-start` reads `state.yaml` and resumes from the interruption point — including the active phase and sub-stage.

### Over-Limit Protection

| Workflow | Iteration Limit | Over-Limit Handling |
|--------|:---:|---------|
| new-product-engineering | 5 (per feature) | Request human intervention |
| new-feature | 5 | Request human intervention |
| bugfix | 3 | Request human intervention |
| refactor | 3 | Request human intervention |
| optimize | 3 | Request human intervention |
| migration | 3 | Request human intervention |
| Hard cap | 10 | Failed attempt 10 triggers breaker; attempt 11 is forbidden |

## harness Family (v3.0.0 — 2 frameworks)

harness-engineering is the **engineering delivery** member of the harness family. The v3.0.0 restructure collapsed the legacy 3 frameworks (pm / design / solo) into **2 frameworks** (pm + engineering); the former solo and design frameworks are merged here. Members collaborate via document handoff:

| Family Member | Responsibility | Handoff |
|---------|------|---------|
| harness-pm | Product research / market / PRD / API contract / design asset paths | Produces `docs/handoff/pm-to-engineering.md` → consumed by this framework |
| **harness-engineering (this framework)** | **4-phase engineering delivery** | Produces `docs/handoff/engineering-to-pm.md` (integration results + open issues) |

## Karpathy Principles in Detail

### 1. Think Before Coding

**Don't make assumptions for the user; don't hide confusion.**

- When requirements are vague, list possible interpretations for the user to choose
- Ask when unsure; don't guess
- Briefly explain the plan before implementing, especially when there are tradeoffs
- When a plan feels overcomplicated, proactively suggest a simpler path

### 2. Simplicity First

**Solve the problem with minimal code; no speculative abstractions.**

- Don't add features that weren't requested
- Don't create abstractions for one-off code
- Don't add unneeded "flexibility" or "configurability"
- Don't write error handling for scenarios that can't happen
- If 200 lines can be written as 50 lines, rewrite it

### 3. Surgical Changes

**Only touch code that must be touched; clean up the mess you made.**

- Don't change code, comments, or formatting unrelated to the current task
- Don't refactor what isn't broken
- Match existing style, even if you prefer another
- If your changes produce unused variables/imports/functions → clean them up
- Pre-existing dead code: you may mention it, but don't touch it

### 4. Goal-Driven Execution

**Turn instructions into verifiable goals; loop until achieved.**

| Don't say this | Say this |
|-----------|---------|
| "Add validation" | "Write tests covering invalid input, then make the tests pass" |
| "Fix this bug" | "Write a test that reproduces the bug, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after the refactor, and complexity drops" |

## Security Red Lines

See [`.harness/rules/security.md`](.harness/rules/security.md) for full security rules.

| Forbidden | Reason |
|------|------|
| Hardcoded secrets | Secret leakage risk |
| `rm -rf` | Accidental deletion risk |
| `curl \| sh` | Supply chain attack risk |
| Replacing `.git/hooks/` without explicit approval | Breaks user-owned Git configuration |
| `git push --force` to main | Overwrites others' commits |

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

**[⬆ Back to top](#harness-engineering)**

</div>
