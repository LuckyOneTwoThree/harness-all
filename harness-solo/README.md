<div align="center">

# harness-solo

### Personal Engineering Development Framework · Let Agents Write Code by Engineering Principles

**Focus on "writing code"** · Requirements Discovery · TDD · Debugging · Verification · Code Review

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#cross-platform-compatibility)
[![Principles](https://img.shields.io/badge/principles-Karpathy%204-orange.svg)](#karpathy-principles-in-detail)
[![Workflows](https://img.shields.io/badge/workflows-9-purple.svg)](#workflows-in-detail)
[![Skills](https://img.shields.io/badge/skills-19-red.svg)](#core-features)

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
PLAN → ACT → VERIFY-FAST → VERIFY-FULL → CODE-REVIEW → DONE
```

- One `state.yaml` per feature, supports checkpoint resume
- Recommended limits trigger early human escalation; attempt 10 is the final allowed attempt
- Evidence-driven: no claiming done without test output

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

### 19 Skills (15 engineering + 4 meta)

**Engineering skills** : brainstorming / writing-plans / test-driven-development / test-coverage / systematic-debugging / performance-optimization / migration / dependency-management / frontend-implementation / verify / code-review / product-engineering-review / webapp-testing / writing-skills / writing-documentation

Execution routing is owned by `.harness/rules/engineering-pipeline.md`; each workflow selects one ACT skill.

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
| Unrequested `.git/hooks/` changes | security.md + explicit authorization gate |

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
│   ├── craft/                         # Engineering craft notes (Karpathy principles, etc.)
│   ├── gates/                         # External check gates (reserved)
│   ├── hooks/                         # optional pre-commit/pre-push/commit-msg hooks
│   │   └── guards/                    # Reusable bash/commit-message/secret guards
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
│   │   ├── engineering/               # 15 engineering skills
│   │   ├── meta/                      # 4 meta skills
│   │   └── workflows/                 # 9 workflows
│   └── templates/                     # 10 document templates
│       ├── SOUL.md.template
│       ├── constitution.md.template
│       ├── PROJECT.md.template
│       ├── TECH_STACK.md.template
│       ├── SKILL.md.template
│       ├── spec.md.template
│       ├── ADR.md.template
│       └── progress.md.template
└── docs/
    ├── product/                       # Product requirements (PROJECT.md)
    ├── engineering/                   # Tech docs (TECH_STACK.md, ENGINEERING_PLAN-template.md, etc.)
    ├── acceptance/                    # Acceptance documents (install.sh creates)
    ├── decisions/                     # Architecture Decision Records (ADR) (install.sh creates)
    └── handoff/                       # harness family handoff documents
        ├── README.md
        ├── handoff-template.md
        ├── solo-to-growth-template.md
        ├── solo-to-ops-template.md
        └── solo-to-pm-template.md
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

### new-product-engineering (Product-Level Multi-Feature Engineering)

```
session-start → Engineering Foundation Gate (hard gate) → brainstorming (product-level) → Product-level PLAN (ENGINEERING_PLAN.md)
→ [Phase 1] Shared Infrastructure LOOP (IC1 after all infra modules)
→ [Phase 2] Nested canonical tasks (topological sort; checkpoints at real boundaries)
→ product-engineering-review (IC5 runs as part of review) → session-end (publish requested product handoffs once)
```

Use this for coordinated multi-feature delivery. ENGINEERING_PLAN owns scope/order, FEATURES owns aggregate status, and each nested task owns its own LOOP state; product review checks only cross-feature integration.

### new-feature (New Feature Development)

```
session-start → brainstorming (hard gate) → writing-plans → LOOP(tdd→verify-fast) → verify-full → code-review → session-end
```

Brainstorming is required for material requirement ambiguity; a validated executable upstream spec can satisfy clarification without repeating discovery.

### bugfix (Bug Fix)

```
session-start → systematic-debugging (root cause analysis) → LOOP(tdd→verify-fast) → verify-full → code-review → session-end
```

### refactor (Refactor)

```
session-start → brainstorming (confirm boundaries) → writing-plans → Prerequisite: build a test safety net → LOOP(tdd→verify-fast) → verify-full → code-review → session-end
```

### optimize (Performance Optimization)

```
session-start → measure/identify → writing-plans → LOOP(performance ACT→verify-fast) → verify-full → code-review → session-end
```

**Iron rule**: no changing code without baseline numbers.

### migration (Code Migration)

```
session-start → decision gate → writing-plans → LOOP(incremental migration→verify-fast) → prove zero usage/cleanup → verify-full → code-review → session-end
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
- constitution compliance

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

# Optional (sub-stage, used for optimize/migration)
substage: "measure"

# Optional (exploration mode, see AGENTS.md)
exploration_mode: standard   # deep / standard / skip

# Optional (over-limit protection)
hard_limit_reached: false
```

### Checkpoint Resume

After a session interruption, session-start reads `state.yaml` and resumes from the interruption point.

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

## harness Family

harness-solo is the **engineering development** member of the harness family, focused on writing code. Other members collaborate via document handoff:

| Family Member | Responsibility | Handoff |
|---------|------|---------|
| harness-pm | Product research / market / PRD | Produces `docs/handoff/pm-to-solo.md` → consumed by this framework |
| **harness-solo (this framework)** | **Engineering development** | Produces `docs/handoff/solo-to-growth.md` → handed to growth |
| harness-design | UI/visual design (on demand) | Produces design artifacts → implemented by this framework |
| harness-growth | Content/SEO/data (on demand) | Consumes this framework's output |
| harness-ops | Ops/deployment/monitoring (on demand) | Consumes `docs/handoff/solo-to-ops.md` from this framework; produces `docs/handoff/ops-to-pm.md` (SLA + incident review) |

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

**[⬆ Back to top](#harness-solo)**

</div>
