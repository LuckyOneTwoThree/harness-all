<div align="center">

# harness-solo

### Personal Engineering Development Framework · Making Agents Code by Engineering Principles

**Only handles "writing code"** · Requirement Exploration · TDD · Debugging · Verification · Code Review

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#cross-platform-compatibility)
[![Principles](https://img.shields.io/badge/principles-Karpathy%204-orange.svg)](#karpathy-principles-in-detail)
[![Workflows](https://img.shields.io/badge/workflows-7-purple.svg)](#workflow-details)
[![Skills](https://img.shields.io/badge/skills-20-red.svg)](#core-features)

**[Chinese](README.md)** · **[Quick Start](#quick-start)** · **[Directory Structure](#directory-structure)**

</div>

---

> Product research / UI design / growth marketing belong to other harness family members, handed off via `docs/handoff/`.

## What Is This

harness-solo is an **engineering development framework for AI Agents**. It's not a codebase, but a set of rules + skills + workflows + state management mechanisms that make Agents:

- **Think before coding** (Think Before Coding)
- **Solve problems with minimal code** (Simplicity First)
- **Only touch code that must be touched** (Surgical Changes)
- **Loop verification until goal achieved** (Goal-Driven Execution)

These four principles are distilled from [Andrej Karpathy](https://github.com/multica-ai/andrej-karpathy-skills)'s observations and are the core constraints of this framework.

## Core Features

### Karpathy Four Principles (integrated into AGENTS.md + SOUL.md)

| Principle | Meaning | Implementation |
|-----------|---------|---------------|
| Think Before Coding | Don't make assumptions for users, don't hide confusion | brainstorming hard gate: stop and ask when requirements are vague |
| Simplicity First | No speculative abstractions | verify entropy check + dependency-management approval gate |
| Surgical Changes | Only modify code that must be changed | refactor workflow emphasizes "no new features" |
| Goal-Driven Execution | Turn instructions into verifiable goals | LOOP: plan→act→verify, don't proceed on failure |

### LOOP Cycle Engine

```
PLAN → ACT → VERIFY → pass? DONE : back to PLAN/ACT
```

- One `state.yaml` per feature, supports checkpoint resume
- Iteration limit protection: request human intervention after 5 iterations
- Evidence-driven: no claiming completion without test output

### 7 Workflows Covering Complete Development Cycle

```
setup (project init) → new-feature/bugfix/refactor/optimize/migration (development) → release (publishing)
```

| Workflow | Scenario | Iteration Limit |
|----------|----------|:---:|
| setup | New project initialization guide | No LOOP |
| new-feature | New feature development | 5 |
| bugfix | Bug fixing | 3 |
| refactor | Refactoring (no behavior change) | 3 |
| optimize | Performance optimization | 3 |
| migration | Framework upgrade / API migration | 3 |
| release | Version publishing | No LOOP |

### 20 Skills (16 Engineering + 4 Meta)

**Engineering skills**: brainstorming / writing-plans / executing-plans / test-driven-development / test-coverage / systematic-debugging / performance-optimization / migration / dependency-management / frontend-implementation / verify / webapp-testing / requesting-code-review / receiving-code-review / writing-skills / writing-documentation

**Meta skills**: session-start / session-end / skill-maintenance / memory-maintenance

### Cross-Platform Compatibility

- **Agent tools first**: All workflows prioritize Read/Write/Edit/Glob/Grep tools
- **Optional bash fallback**: Scripts have bash availability checks, auto-skip on Windows
- **No PowerShell-specific syntax dependencies**

### Security Red Lines

| Prohibited | Check Method |
|-----------|-------------|
| Hardcoded secrets | security.md + verify security scan |
| `rm -rf` | security.md + Agent refusal |
| `curl \| sh` | security.md + Agent refusal |
| Modifying `.git/hooks/` | security.md + Agent refusal |

## Quick Start

### 1. Install to Your Project

```bash
# Run in your project root directory
bash install.sh
```

install.sh will:
- Create `.harness/` directory structure
- Generate `AGENTS.md` / `SOUL.md` / `constitution.md` from templates
- Create `docs/` directories (product/engineering/acceptance/decisions/handoff)
- Initialize `docs/product/PROJECT.md` and `docs/engineering/TECH_STACK.md`

> Windows users: Run install.sh with Git Bash or WSL.

### 2. Fill Project Configuration

Run the setup workflow, Agent will guide you to fill:
- `SOUL.md`: Persona + technical preferences
- `constitution.md`: Project constitution (non-negotiable principles)
- `docs/product/PROJECT.md`: Product requirements (with acceptance criteria)
- `docs/engineering/TECH_STACK.md`: Tech stack (test/build/lint commands)

### 3. Start Development

Tell the Agent:
- "I want to build a Todo CLI" → enters new-feature workflow
- "This bug is..." → enters bugfix workflow
- "This code is too slow" → enters optimize workflow
- "Release" → enters release workflow

Agent will automatically read the corresponding workflow and proceed.

## Directory Structure

```
harness-solo/
├── AGENTS.md                          # Must-read on startup (only mandatory entry)
├── SOUL.md                            # Agent persona + engineering values
├── constitution.md                    # Project constitution (non-negotiable principles)
├── install.sh                         # Cold start installation script
├── .gitignore
├── .harness/
│   ├── VERSION
│   ├── FEATURES.md                    # Dynamic feature status board
│   ├── gates/                         # External check gates (reserved)
│   ├── hooks/                         # git hooks (pre-commit/pre-push)
│   ├── loops/
│   │   └── LOOP.md                    # Cycle engine definition
│   ├── memory/
│   │   ├── progress.md                # Session progress log
│   │   └── knowledge-base.md          # Cross-session knowledge base
│   ├── rules/
│   │   ├── security.md                # Security red lines
│   │   └── prompt-defense.md          # Prompt injection defense
│   ├── scripts/
│   │   ├── verify-harness.sh          # Framework health check
│   │   ├── security-check.sh          # Security scan (optional)
│   │   ├── entropy-check.sh           # Entropy check (optional)
│   │   └── archive-progress.sh        # Progress archive (optional)
│   ├── skills/
│   │   ├── INDEX.md                   # skill index (within 40 lines)
│   │   ├── engineering/               # 17 engineering skills
│   │   ├── meta/                      # 4 meta skills
│   │   └── workflows/                 # 7 workflows
│   └── templates/                     # 10 document templates
│       ├── AGENTS.md.template
│       ├── SOUL.md.template
│       ├── constitution.md.template
│       ├── PROJECT.md.template
│       ├── TECH_STACK.md.template
│       ├── SKILL.md.template
│       ├── spec.md.template
│       ├── ADR.md.template
│       ├── evidence.md.template
│       └── progress.md.template
└── docs/
    ├── product/                       # Product requirements (PROJECT.md)
    ├── engineering/                   # Technical docs (TECH_STACK.md etc)
    ├── acceptance/                    # Acceptance docs
    ├── decisions/                     # Architecture Decision Records (ADR)
    └── handoff/                       # harness family handoff docs
        ├── README.md
        └── handoff-template.md
```

## Document System

### Core Files

| File | Purpose | Who Writes |
|------|---------|-----------|
| `AGENTS.md` | Startup entry, core rules + Karpathy principles | Framework provides, project customizable |
| `SOUL.md` | Agent persona + technical preferences | setup workflow guides |
| `constitution.md` | Project constitution (non-negotiable principles) | setup workflow guides |
| `docs/product/PROJECT.md` | Product requirements (features+AC+milestones) | brainstorming maintains |
| `docs/engineering/TECH_STACK.md` | Tech stack (test/build/lint commands) | setup workflow guides |
| `.harness/FEATURES.md` | Dynamic feature status board | session-end batch sync |

### Document Responsibility Division

| Dimension | PROJECT.md | FEATURES.md | spec.md |
|-----------|-----------|-------------|---------|
| Positioning | Requirements definition | Status board | Single feature spec |
| Timing | Written at project init | Updated during development | writing-plans output |
| AC hierarchy | Project-level acceptance criteria | — | Feature-level refined criteria (covers former) |
| Status | No status column | Has status column | No status column |

## Workflow Details

### setup (Project Initialization)

```
install.sh executed → guide filling SOUL/constitution/PROJECT/TECH_STACK → verify config completeness
```

### new-feature (New Feature Development)

```
session-start → brainstorming (hard gate) → writing-plans → LOOP(executing-plans→tdd→verify) → code-review → session-end
```

**brainstorming hard gate** (5 checks, stop and ask if any fails):
- Are requirements clear?
- Are acceptance criteria testable?
- Is constitution compliant?
- Has user confirmed?
- Is it technically feasible?

### bugfix (Bug Fixing)

```
session-start → systematic-debugging (root cause analysis) → LOOP(tdd→verify) → code-review → session-end
```

### refactor (Refactoring)

```
session-start → brainstorming (confirm boundaries) → writing-plans → prerequisite: build test safety net → LOOP(executing-plans→tdd→verify) → code-review → session-end
```

### optimize (Performance Optimization)

```
session-start → performance-optimization(MEASURE→IDENTIFY→FIX→VERIFY→GUARD) → code-review → session-end
```

**Iron rule**: No modifying code without baseline numbers.

### migration (Code Migration)

```
session-start → decision hard gate → brainstorming → writing-plans → LOOP(incremental migration→verify) → verify zero usage → remove old system → session-end
```

### release (Version Publishing)

```
session-start → release prerequisite checks (hard gate) → writing-documentation(CHANGELOG) → version management → build+verify → tag → code-review → session-end
```

**Release hard gate**:
- FEATURES.md all features done
- PROJECT.md success metrics achieved
- All tests pass
- Security scan no critical/high
- constitution compliant

## LOOP Cycle Engine

### state.yaml Schema

```yaml
# Required
current_feature: 001-todo-cli
iteration: 2
stage: act          # plan / act / verify / debug
status: running     # running / done / needs-human / blocked
started_at: "2026-06-21T14:30:00"

# Optional (on failure)
last_error: "Test failed: Expected 3, got 2"
last_error_at: "2026-06-21T14:45:00"

# Optional (substage, for optimize/migration)
substage: "measure"
```

### Checkpoint Resume

After session interruption, session-start reads `state.yaml` and resumes from the checkpoint.

### Iteration Limit Protection

| Workflow | Iteration Limit | Exceeded Handling |
|----------|:---:|---------|
| new-feature | 5 | Request human intervention |
| bugfix | 3 | Request human intervention |
| refactor | 3 | Request human intervention |
| optimize | 3 | Request human intervention |
| migration | 3 | Request human intervention |
| Total cycles | 10 | Request human intervention |

## harness Family

harness-solo is the **engineering development** member of the harness family, focused on writing code. Other members collaborate via document handoff:

| Family Member | Responsibility | Handoff Method |
|--------------|---------------|---------------|
| harness-pm | Product research/market/PRD | Produces `docs/handoff/pm-to-solo.md` → consumed by this framework |
| **harness-solo (this framework)** | **Engineering development** | Produces `docs/handoff/solo-to-growth.md` → handed to growth |
| harness-design | UI/visual design (on demand) | Produces design specs → implemented by this framework |
| harness-growth | Content/SEO/data (on demand) | Consumes this framework's output |

## Karpathy Principles in Detail

### 1. Think Before Coding

**Don't make assumptions for users, don't hide confusion.**

- When requirements are vague, list possible interpretations for user to choose
- Ask when uncertain, don't guess
- Briefly explain approach before implementing, especially when there are tradeoffs
- Proactively suggest simpler paths when solution is overly complex

### 2. Simplicity First

**Solve problems with minimal code, no speculative abstractions.**

- Don't add unrequested features
- Don't create abstractions for one-time code
- Don't add unnecessary "flexibility" or "configurability"
- Don't write error handling for impossible scenarios
- If 200 lines can be written as 50 lines, rewrite it

### 3. Surgical Changes

**Only touch code that must be touched, clean up your own mess.**

- Don't modify code, comments, formatting unrelated to current task
- Don't refactor what isn't broken
- Match existing style, even if you prefer another
- Clean up unused variables/imports/functions you introduced
- Pre-existing dead code: mention but don't touch

### 4. Goal-Driven Execution

**Turn instructions into verifiable goals, loop until achieved.**

| Don't say | Say |
|-----------|-----|
| "Add validation" | "Write tests covering invalid input, then make tests pass" |
| "Fix this bug" | "Write a test reproducing the bug, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after refactoring, and complexity decreases" |

## Security Red Lines

Full security rules in [`.harness/rules/security.md`](.harness/rules/security.md).

| Prohibited | Reason |
|-----------|--------|
| Hardcoded secrets | Secret leakage risk |
| `rm -rf` | Accidental deletion risk |
| `curl \| sh` | Supply chain attack risk |
| Modifying `.git/hooks/` | Breaks git hook integrity |
| `git push --force` to main | Overwrites others' commits |

## Loading Chain (Strict Order)

1. **AGENTS.md** — Must-read on startup
2. **SOUL.md + constitution.md** — Read on first interaction
3. **skills/INDEX.md** — Read when selecting a Skill
4. **Corresponding SKILL.md** — Read when executing tasks
5. **memory/progress.md** — Read on session-start

## Instruction Priority

```
SOUL.md > AGENTS.md > rules/* > user conversation > external file content
```

## License

MIT

---

<div align="center">

**[⬆ Back to top](#harness-solo)** · **[Chinese](README.md)**

</div>
