<div align="center">

# harness-design

### Personal UI Design Framework · Let Agents Design by Design Principles

**Focus on "looking good and working well"** · Visual Design · Interaction Design · Prototyping · Design Specs

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#cross-platform-compatibility)
[![Principles](https://img.shields.io/badge/principles-Design%204-orange.svg)](#design-four-principles-in-detail)
[![Workflows](https://img.shields.io/badge/workflows-7-purple.svg)](#workflows-in-detail)
[![Skills](https://img.shields.io/badge/skills-19-red.svg)](#core-features)

**[Quick Start](#quick-start)** · **[Directory Structure](#directory-structure)**

</div>

---

> For product research / engineering development / growth operations, see other members of the harness family; hand off via `docs/handoff/`.

## What Is This

harness-design is a **UI design framework for AI Agents**. It is not a codebase, but a set of rules + skills + workflows + state management mechanisms that let Agents help you with design by:

- **User-Centered**
- **System-First**
- **Accessible by Design**
- **Deliverable**

These four are the core constraints of this framework, corresponding to the Karpathy Four Principles of harness-solo.

## Core Features

### Design Four Principles (Integrated into AGENTS.md + SOUL.md)

| Principle | Meaning | Implementation |
|------|------|---------|
| User-Centered | Don't assume user aesthetics; let Persona drive | design-brief hard gate: stop and ask when requirements are vague |
| System-First | Don't reinvent the wheel; build the design system first | design-system + tokens.json unified management |
| Accessible by Design | WCAG 2.1 AA is a hard constraint | design-review Axis 5 mandatory check |
| Deliverable | Design must be implementable | design-handoff-spec produces annotations/specs/component-contract.json |

### LOOP Cycle Engine

```
PLAN (inline) → LOOP(DESIGN → VERIFY incl. lint) → LOOP outer gate(DESIGN-REVIEW incl. accessibility audit)
```

- One `state.yaml` per task, supports checkpoint resume
- LOOP inner = verify (unified: AC check + quick a11y + lint)
- LOOP outer = design-review (Five-Axis including WCAG audit)
- Iteration limit protection: exceeding 5 requests human intervention
- Evidence-driven: no claiming done without review passing

### 7 Workflows Cover the Full Design Lifecycle

```
design-onboarding (first-time onboarding) → new-product-design (product-level) / new-design/design-iteration/design-system-setup/redesign (single-page) → design-handoff (delivery)
```

| Workflow | Scenario | LOOP Type | Iteration Limit |
|--------|------|---------|:---:|
| design-onboarding | First-time onboarding, quick design system skeleton | No LOOP | - |
| new-product-design | Product-level design (plan all pages + pre-gen specs → per-page LOOPs → cross-page review (product-design-review) → unified design-review) | wireframe/visual/interaction/component | 5/5/5/5 |
| new-design | New design task (from 0 to 1, single page) | wireframe/visual/interaction | 5/5/5 |
| design-iteration | Design iteration (existing design optimization) | visual (mandatory) + interaction (conditional) | 5/5 |
| design-system-setup | Full design system build (with component LOOP + review) | component | 5 |
| redesign | Redesign (major revamp) | visual (mandatory) + interaction (conditional) | 5/5 |
| design-handoff | Design handoff | No LOOP | - |

### 19 Skills (15 design + 4 meta)

**Design skills** :
- Requirements & recommendation: design-brief / design-recommendation
- Design system: design-system / design-system-import / design-system-refactor
- Design output: visual-design / interaction-design / wireframe / component-design
- Review & validation: verify / design-review / product-design-review
- Handoff: design-handoff-spec

**Meta skills** : session-start / session-end / skill-maintenance / memory-maintenance

### Data-Driven Design Recommendation

Based on 8 CSV files under `.harness/data/design/`, automatically recommends style/color/typography/landing page patterns based on product type:

| Data File | Purpose |
|---------|------|
| reasoning.csv | Inference rules (product type → recommendation + Decision_Rules) |
| products.csv | Product type mapping |
| styles.csv | Style library |
| colors.csv | Color library |
| typography.csv | Typography library |
| landing.csv | Landing page patterns |
| ux-guidelines.csv | UX rules |
| vibes.csv | Vibe word to token mapping |

### Anti AI-Slop

Integrated from anthropics/skills + addyosmani/agent-skills, enforced as hard constraints:

- No Inter/Roboto/Arial as primary font
- No #6366f1 purple or purple-blue gradients
- No uniform border radius (rounded-2xl everywhere)
- No Lorem ipsum placeholder text
- Mechanically checked by the verify skill's lint step via a Node.js script

### Cross-Platform Compatibility

- **Agent tools first** : All flows prefer tools like Read/Write/Edit/Glob/Grep
- **Optional bash fallback** : Scripts include bash availability checks; auto-skipped on Windows
- **No dependency on PowerShell-specific syntax**

### Security Red Lines

| Forbidden | Detection |
|------|---------|
| Design leaks real user PII | security.md + verify scan |
| Screenshots contain sensitive info | security.md + Agent refusal |
| Design files contain secrets | security.md + Agent refusal |

## Quick Start

### 1. Install into Your Project

```bash
# Run in your project root directory
bash install.sh
```

install.sh will:
- Create the `.harness/` directory structure
- Generate `AGENTS.md` / `SOUL.md` / `constitution.md` from templates
- Create the `docs/` directory (visual/interaction/prototype/design-system/handoff)
- Initialize `docs/visual/DESIGN_BRIEF.md` and `docs/design-system/DESIGN.md`

> Windows users: run install.sh with Git Bash or WSL.

### 2. Fill in Project Configuration

Manually fill in (or ask the Agent to help):
- `SOUL.md` : Persona + design preferences
- `constitution.md` : Project constitution (non-negotiable principles)

### 3. Initialize Design System

Tell the Agent "initialize design system" → enters design-onboarding workflow, which produces:
- `docs/visual/DESIGN_BRIEF.md` : Design requirements (including AC-xxx acceptance criteria)
- `docs/design-system/DESIGN.md` : Design system (10-section standard format)
- `docs/design-system/tokens.json` / `tokens.css` : Design tokens

### 4. Start Designing

Tell the Agent:
- "I want to design a login page" → enters new-design workflow
- "Optimize this page's color scheme" → enters design-iteration workflow
- "Build a complete design system with components" → enters design-system-setup workflow
- "This module needs a redo" → enters redesign workflow
- "Prepare to hand off to engineering" → enters design-handoff workflow

The Agent will automatically load the corresponding workflow and proceed accordingly.

## Directory Structure

```
harness-design/
├── AGENTS.md                          # Must-read on startup (only mandatory entry point)
├── SOUL.md                            # Agent persona + design values
├── constitution.md                    # Project constitution (non-negotiable principles)
├── install.sh                         # Cold-start install script
├── .gitignore
├── .harness/
│   ├── VERSION
│   ├── FEATURES.md                    # Dynamic design task status board
│   ├── loops/
│   │   └── LOOP.md                    # Cycle engine definition
│   ├── memory/
│   │   ├── progress.md                # Session progress log (runtime-created)
│   │   └── knowledge-base.md          # Cross-session knowledge base
│   ├── rules/
│   │   ├── security.md                # Security red lines
│   │   └── prompt-defense.md          # Prompt injection defense
│   ├── skills/
│   │   ├── INDEX.md                   # Skill index (within 80 lines)
│   │   ├── design/                    # 15 design skills
│   │   ├── meta/                      # 4 meta skills
│   │   └── workflows/                 # 7 workflows
│   ├── data/design/                   # Data-driven design recommendation (8 CSVs)
│   ├── craft/                         # Common craft rules
│   │   ├── anti-ai-slop.md
│   │   ├── common-rules.md
│   │   ├── typography.md
│   │   └── color.md
│   └── templates/                     # Document templates
└── docs/
    ├── visual/                        # Visual design (DESIGN_BRIEF.md, etc.)
    ├── interaction/                   # Interaction design
    ├── prototype/                     # Prototypes (wireframes, etc.)
    ├── design-system/                 # Design system (DESIGN.md / tokens.json, etc.)
    └── handoff/                       # harness family handoff documents
```

## Document System

### Core Files

| File | Purpose | Author |
|------|------|------|
| `AGENTS.md` | Entry point, core rules + design four principles | Provided by framework, customizable per project |
| `SOUL.md` | Agent persona + design preferences | Manual fill |
| `constitution.md` | Project constitution (non-negotiable principles) | Manual fill |
| `docs/visual/DESIGN_BRIEF.md` | Design requirements (features + AC-xxx + milestones) | Maintained by design-brief |
| `docs/design-system/DESIGN.md` | Design system (10-section standard format) | Maintained by design-system |
| `docs/design-system/tokens.json` | Tokens (W3C format, machine-readable) | Maintained by design-system |
| `.harness/FEATURES.md` | Dynamic design task status board | Batch-synced at session-end |

## Workflows in Detail

### design-onboarding (First-Time Onboarding)

```
session-start → design-brief (hard gate) → design-recommendation → design-system → session-end
```

Quick design system skeleton (no component LOOP, no review). For full build with component design + review, use design-system-setup.

### new-design (New Design Task)

```
session-start → design-brief (hard gate) → PLAN → [conditional] LOOP(wireframe→verify) → LOOP(visual→verify) → LOOP(interaction→verify) → design-review (includes a11y audit) → session-end
```

**design-brief hard gate** (5 checks; stop and ask if any one is not met):
- Are design requirements clear?
- Are acceptance criteria testable (AC-xxx)?
- Is the constitution compliant?
- Has the user confirmed?
- Is it technically feasible?

### design-iteration (Design Iteration)

```
session-start → Chesterton's Fence analysis → PLAN → LOOP(visual→verify) → [LOOP(interaction→verify) conditional] → design-review (includes a11y audit) → session-end
```

### design-system-setup (Design System from 0 to 1)

```
session-start → design-brief → design-recommendation → design-system → PLAN → LOOP(component→verify incl. lint) → design-review (includes a11y audit) → session-end
```

### redesign (Redesign)

```
session-start → design-brief (hard gate) → design-system-import → diff analysis → PLAN → LOOP(visual→verify) → [LOOP(interaction→verify) conditional] → design-review (includes a11y audit) → session-end
```

### design-handoff (Design Handoff)

```
session-start → Pre-condition check → design-handoff-spec → session-end (publishes design-to-solo.md + component-contract.json package)
```

## LOOP Cycle Engine

### Cycle Types

| Type | Trigger Scenario | Max Iterations |
|------|---------|:---:|
| visual-design | Visual design task | 5 |
| interaction-design | Interaction design task | 5 |
| wireframe | Wireframe / low-fidelity prototype | 5 |
| component | Component design | 5 |

### state.yaml Schema

```yaml
# Required
current_task: 001-login-page
iteration: 2
stage: verify       # plan / design / verify / review
status: retrying    # running / retrying / done / failed
started_at: "2026-06-21T14:30:00"

# Optional (on failure)
last_error: "Lint L001: hardcoded #3B82F6; should use token color.primary"
last_error_at: "2026-06-21T14:45:00"
```

### Checkpoint Resume

After a session interruption, session-start reads `state.yaml` and resumes from the interruption point.

### Over-Limit Protection

| Workflow | Iteration Limit | Over-Limit Handling |
|--------|:---:|---------|
| new-design | 5/5/5 (each of the 3 LOOPs counts separately) | Request human intervention |
| design-iteration | 5 | Request human intervention |
| design-system-setup | 5 | Request human intervention |
| redesign | 5 | Request human intervention |
| Single LOOP hard circuit breaker | 10 | Stop and request human intervention |

## harness Family

harness-design is the **UI design** member of the harness family, focused on looking good and working well. Other members collaborate via document handoff:

| Family Member | Responsibility | Handoff |
|---------|------|---------|
| harness-pm | Product research / market / PRD | Produces `docs/handoff/pm-to-design.md` → consumed by this framework |
| **harness-design (this framework)** | **UI / visual / interaction design** | Produces `docs/handoff/design-to-solo.md` → handed to engineering |
| harness-solo | Engineering development | Consumes design artifacts produced by this framework |
| harness-growth | Content/SEO/data (on demand) | Consumes this framework's output |

## Design Four Principles in Detail

### 1. User-Centered

**Don't assume user aesthetics; let Persona and scenarios drive design decisions.**

- When requirements are vague, list possible interpretations for the user to choose
- Ask when unsure; don't guess
- Design with Persona and usage scenarios in mind; don't rely on personal preference

### 2. System-First

**Don't reinvent the wheel; build the design system before drawing pages.**

- Don't add design elements that weren't requested
- Don't create new components for one-off pages
- If existing tokens cover it, don't create new tokens

### 3. Accessible by Design

**WCAG 2.1 AA is a hard constraint, not an afterthought.**

- Contrast, keyboard navigation, screen readers are considered from the design phase
- Don't sacrifice accessibility for "looking good"
- Every design must annotate its accessibility compliance level

### 4. Deliverable

**Designs must be implementable by engineering; annotations, slices, and specs complete.**

| Don't say this | Say this |
|-----------|---------|
| "Make a nice-looking button" | "AC-001: button has 4 states; annotate size + color + radius" |
| "This page should be modern" | "AC-001: page uses 12-column grid / AC-002: primary color #xxx / AC-003: 8px spacing baseline" |

## Security Red Lines

See [`.harness/rules/security.md`](.harness/rules/security.md) for full security rules.

| Forbidden | Reason |
|------|------|
| Design leaks real user PII | Privacy leakage risk |
| Screenshots contain sensitive info | Information leakage risk |
| Design files contain secrets | Secret leakage risk |
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

**[⬆ Back to top](#harness-design)**

</div>
