<div align="center">

# harness-solo

### Personal Engineering Development Framework · Let Agents Write Code by Engineering Principles

**Focus on "writing code"** · Requirements Discovery · TDD · Debugging · Verification · Code Review

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#cross-platform-compatibility)
[![Principles](https://img.shields.io/badge/principles-Karpathy%204-orange.svg)](#karpathy-principles-in-detail)
[![Workflows](https://img.shields.io/badge/workflows-7-purple.svg)](#workflows-in-detail)
[![Skills](https://img.shields.io/badge/skills-20-red.svg)](#core-features)

**[Quick Start](#quick-start)** · **[Directory Structure](#directory-structure)**

</div>

---

> For product research / UI design / growth operations, see other members of the harness family; hand off via `docs/handoff/`.

## What Is This

harness-solo is an **engineering development framework for AI Agents**. It is not a codebase, but a set of rules + skills + workflows + state management mechanisms that let Agents help you write code by:

- **Think Before Coding**
- **Simplicity First**
- **Surgical Changes**
- **Goal-Driven Execution**

These four are engineering principles distilled from observations by [Andrej Karpathy](https://github.com/multica-ai/andrej-karpathy-skills), and the core constraints of this framework.

## Core Features

### Karpathy Four Principles (Integrated into AGENTS.md + SOUL.md)

| Principle | Meaning | Implementation |
|------|------|---------|
| Think Before Coding | Don't make assumptions for the user; don't hide confusion | brainstorming hard gate: stop and ask when requirements are vague |
| Simplicity First | No speculative abstractions | verify entropy check + dependency-management approval gate |
| Surgical Changes | Only touch code that must be touched | refactor workflow emphasizes "no new features" |
| Goal-Driven Execution | Turn instructions into verifiable goals | LOOP cycle: plan → act → verify; don't continue on failure |

### LOOP Cycle Engine

```
PLAN → ACT → VERIFY → Pass? DONE : Back to PLAN/ACT
```

- One `state.yaml` per feature, supports checkpoint resume
- Iteration limit protection: exceeding 5 requests human intervention
- Evidence-driven: no claiming done without test output

### 7 Workflows Cover the Full Development Lifecycle

```
setup (project initiation) → new-feature/bugfix/refactor/optimize/migration (development) → release (release)
```

| Workflow | Scenario | Iteration Limit |
|--------|------|:---:|
| setup | New project initiation guide | No LOOP |
| new-feature | New feature development | 5 |
| bugfix | Bug fix | 3 |
| refactor | Refactor (no behavior change) | 3 |
| optimize | Performance optimization | 3 |
| migration | Framework upgrade / API migration | 3 |
| release | Version release | No LOOP |

### 20 Skills (16 engineering + 4 meta)

**Engineering skills** : brainstorming / writing-plans / executing-plans / test-driven-development / test-coverage / systematic-debugging / performance-optimization / migration / dependency-management / frontend-implementation / verify / webapp-testing / requesting-code-review / receiving-code-review / writing-skills / writing-documentation

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

## Quick Start

### 1. Install into Your Project

```bash
# Run in your project root directory
bash install.sh
```

install.sh will:
- Create the `.harness/` directory structure
- Generate `AGENTS.md` / `SOUL.md` / `constitution.md` from templates
- Create the `docs/` directory (product/engineering/acceptance/decisions/handoff)
- Initialize `docs/product/PROJECT.md` and `docs/engineering/TECH_STACK.md`

> Windows users: run install.sh with Git Bash or WSL.

### 2. Fill in Project Configuration

Run the setup workflow; the Agent will guide you to fill in:
- `SOUL.md` : Persona + tech preferences
- `constitution.md` : Project constitution (non-negotiable principles)
- `docs/product/PROJECT.md` : Product requirements (including acceptance criteria)
- `docs/engineering/TECH_STACK.md` : Tech stack (test/build/lint commands)

### 3. Start Development

Tell the Agent:
- "I want to build a Todo CLI" → enters new-feature workflow
- "This bug is..." → enters bugfix workflow
- "This code is too slow" → enters optimize workflow
- "Release" → enters release workflow

The Agent will automatically load the corresponding workflow and proceed accordingly.

## Directory Structure

```
harness-solo/
├── AGENTS.md                          # Must-read on startup (only mandatory entry point)
├── SOUL.md                            # Agent persona + engineering values
├── constitution.md                    # Project constitution (non-negotiable principles)
├── install.sh                         # Cold-start install script
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
│   │   ├── INDEX.md                   # Skill index (within 80 lines)
│   │   ├── engineering/               # 16 engineering skills
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
    ├── engineering/                   # Tech docs (TECH_STACK.md, etc.)
    ├── acceptance/                    # Acceptance documents
    ├── decisions/                     # Architecture Decision Records (ADR)
    └── handoff/                       # harness family handoff documents
        ├── README.md
        ├── handoff-template.md
        ├── solo-to-growth-template.md
        └── solo-to-ops-template.md
```

## Document System

### Core Files

| File | Purpose | Author |
|------|------|------|
| `AGENTS.md` | Entry point, core rules + Karpathy principles | Provided by framework, customizable per project |
| `SOUL.md` | Agent persona + tech preferences | Filled via setup workflow |
| `constitution.md` | Project constitution (non-negotiable principles) | Filled via setup workflow |
| `docs/product/PROJECT.md` | Product requirements (features + AC + milestones) | Maintained by brainstorming |
| `docs/engineering/TECH_STACK.md` | Tech stack (test/build/lint commands) | Filled via setup workflow |
| `.harness/FEATURES.md` | Dynamic feature status board | Batch-synced at session-end |

### Responsibility Division Across Documents

| Dimension | PROJECT.md | FEATURES.md | spec.md |
|------|-----------|-------------|---------|
| Positioning | Requirements definition | Status board | Single-feature spec |
| Timing | Written at project initiation | Updated during development | Produced by writing-plans |
| AC level | Project-level acceptance criteria | — | Single-feature refined acceptance criteria (overrides the former) |
| Status | No status column | Has status column | No status column |

## Workflows in Detail

### setup (Project Initiation Guide)

```
install.sh execution → Guide filling SOUL/constitution/PROJECT/TECH_STACK → Validate configuration completeness
```

### new-feature (New Feature Development)

```
session-start → brainstorming (hard gate) → writing-plans → LOOP(executing-plans→tdd→verify) → code-review → session-end
```

**brainstorming hard gate** (5 checks; stop and ask if any one is not met):
- Are requirements clear?
- Are acceptance criteria testable?
- Is the constitution compliant?
- Has the user confirmed?
- Is it technically feasible?

### bugfix (Bug Fix)

```
session-start → systematic-debugging (root cause analysis) → LOOP(tdd→verify) → code-review → session-end
```

### refactor (Refactor)

```
session-start → brainstorming (confirm boundaries) → writing-plans → Prerequisite: build a test safety net → LOOP(executing-plans→tdd→verify) → code-review → session-end
```

### optimize (Performance Optimization)

```
session-start → performance-optimization(MEASURE→IDENTIFY→FIX→VERIFY→GUARD) → code-review → session-end
```

**Iron rule**: no changing code without baseline numbers.

### migration (Code Migration)

```
session-start → Decision hard gate → brainstorming → writing-plans → LOOP(incremental migration→verify) → Verify zero usage → Remove old system → session-end
```

### release (Release)

```
session-start → Pre-release checks (hard gate) → writing-documentation(CHANGELOG) → Version number management → Build + verify → Tag → code-review → session-end
```

**Release hard gate**:
- All features in FEATURES.md are done
- PROJECT.md success metrics met
- Full test suite passes
- Security scan has no critical/high
- constitution compliance

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

# Optional (sub-stage, used for optimize/migration)
substage: "measure"
```

### Checkpoint Resume

After a session interruption, session-start reads `state.yaml` and resumes from the interruption point.

### Over-Limit Protection

| Workflow | Iteration Limit | Over-Limit Handling |
|--------|:---:|---------|
| new-feature | 5 | Request human intervention |
| bugfix | 3 | Request human intervention |
| refactor | 3 | Request human intervention |
| optimize | 3 | Request human intervention |
| migration | 3 | Request human intervention |
| Total cycle | 10 | Request human intervention |

## harness Family

harness-solo is the **engineering development** member of the harness family, focused on writing code. Other members collaborate via document handoff:

| Family Member | Responsibility | Handoff |
|---------|------|---------|
| harness-pm | Product research / market / PRD | Produces `docs/handoff/pm-to-solo.md` → consumed by this framework |
| **harness-solo (this framework)** | **Engineering development** | Produces `docs/handoff/solo-to-growth.md` → handed to growth |
| harness-design | UI/visual design (on demand) | Produces design artifacts → implemented by this framework |
| harness-growth | Content/SEO/data (on demand) | Consumes this framework's output |

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
| Modifying `.git/hooks/` | Breaks git hook integrity |
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

**[⬆ Back to top](#harness-solo)**

</div>
