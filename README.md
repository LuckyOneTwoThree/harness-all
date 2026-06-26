<div align="center">

**🌐 Language / 语言**: **English** | [中文](./README.zh.md)

---

# 🪢 harness-all

### Personal AI Studio · Multi-Agent Framework Family

> **Pick your stack. Each framework works independently. Combine them when you need to.**

---

![Version](https://img.shields.io/badge/version-v2.1-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-5-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-198-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-40-purple.svg?style=for-the-badge&logo=git)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)

---

| Framework | Domain | Skills | Workflows |
|:---------:|--------|:------:|:---------:|
| **harness-pm** | Strategy · Market · PRD · Metrics | 86 | 10 |
| **harness-design** | Visual · Interaction · Prototype · Design System | 19 | 7 |
| **harness-solo** | Engineering · TDD · Debug · Refactor · Verify | 21 | 8 |
| **harness-growth** | Content · SEO · Experiments · Monetization | 40 | 7 |
| **harness-ops** | Deploy · Monitor · Incident · Disaster Recovery | 32 | 8 |

</div>

---

## Pick Your Stack

One framework is fully functional on its own. Combine them when you need cross-domain data flow.

```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  Mode 1: Solo          Mode 2: Pick & Mix       Mode 3: Full │
│                                                              │
│  Only what you need    Combine as needed         Full chain   │
│                                                              │
│  ┌─────────┐           ┌─────┐  ┌─────────┐     pm → design │
│  │  solo   │           │ pm  │→ │ design  │      → solo      │
│  │  only   │           └─────┘  └─────────┘      → growth   │
│  └─────────┘                                        → ops     │
│                                                              │
│  "I just write code"  "PM + Design, no ops"   "Full studio"  │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

Each framework is **self-sufficient** — no handoff documents required. When you combine frameworks, they collaborate via structured contract documents under `docs/handoff/`.

---

## Why harness

**The problem**: Every AI conversation starts from zero. No project memory, no domain expertise, no quality gates.

```
❌ Without a framework
  Conversation 1: "Write a PRD"        → Agent asks everything from scratch
  Conversation 2: "Design the homepage" → Agent doesn't know the PRD
  Conversation 3: "Implement this"      → Agent doesn't know the design
  ...every conversation is amnesiac
```

**harness gives AI Agents persistent project knowledge**:

| Without harness | With harness |
|----------------|--------------|
| Re-explain project every conversation | `knowledge-base.md` accumulates across sessions |
| Forgets on close | `progress.md` auto-restores context |
| One Agent does everything poorly | Specialized Agent per domain |
| "I think it's done" | LOOP engine + evidence gates |
| Verbal handoff, info lost | Structured contract documents with AC numbering |

**One-line summary**: Prompt engineering teaches an Agent to do one thing; a framework gives it persistent memory and domain expertise that improves with use.

---

## Quick Start by Role

### Choose your framework

| You are | Framework | What it does |
|---------|-----------|-------------|
| Product Manager | **harness-pm** | Research → PRD → Metrics → Iteration |
| Designer | **harness-design** | Brief → Visual → Interaction → Handoff spec |
| Developer | **harness-solo** | Plan → TDD → Implement → Verify |
| Growth / Marketing | **harness-growth** | Hypothesis → Experiment → Content → SEO |
| DevOps / SRE | **harness-ops** | IaC → Deploy → Monitor → Incident response |

### Install

```bash
# 1. Clone the framework family to any location (one-time)
#    Creates a "harness-all" folder in the current directory
cd /path/to/your-parent-dir
git clone https://github.com/LuckyOneTwoThree/harness-all.git
# Now the frameworks are at /path/to/your-parent-dir/harness-all/

# 2. Navigate to your project (create one if not exists)
cd /path/to/your-project

# 3. Install the framework you need (solo as example)
#    The install script auto-detects local files, no network needed
bash /path/to/your-parent-dir/harness-all/harness-solo/install.sh
```

The install script creates the `.harness/` directory structure in your project, copies core config files, and initializes memory.

> **Windows users — `bash` command routing**
>
> On Windows, the system-provided `bash.exe` (in `C:\Windows\System32\` or `WindowsApps\`) is a WSL stub, not Git Bash. If you run `bash install.sh` in PowerShell/CMD and see "WSL has no installed distribution", the `bash` command was routed to WSL instead of Git Bash.
>
> **Three solutions (pick one):**
>
> 1. **Use Git Bash terminal** (recommended): open "Git Bash" from the Start menu, then `cd /d/your-project && bash /path/to/install.sh`
> 2. **Full path in PowerShell**: `& "C:\Program Files\Git\bin\bash.exe" install.sh`
> 3. **Permanent alias** (one-time setup): add to your PowerShell profile (`notepad $PROFILE`):
>    ```powershell
>    function bash { & "C:\Program Files\Git\bin\bash.exe" @args }
>    ```
>    Reopen PowerShell, then `bash install.sh` will route to Git Bash permanently.
>
> This is a known Windows conflict between WSL and Git Bash — both ship a `bash.exe`, but Windows puts the WSL stub earlier in PATH.

### Start the Agent

Open your AI Agent (e.g., Trae IDE) in the project directory. The Agent auto-reads:
1. `AGENTS.md` — mandatory startup rules
2. `SOUL.md` + `constitution.md` — domain values and non-negotiable principles
3. `skills/INDEX.md` → specific `SKILL.md` — on-demand skill loading
4. `memory/progress.md` — cross-session context restore

### Combine frameworks

When using multiple frameworks, contract documents flow between them:

```
harness-pm → pm-to-design.md → harness-design → design-to-solo.md → harness-solo
                                                                    → solo-to-ops.md → harness-ops
```

Copy handoff documents to the downstream framework's `docs/handoff/` directory. The consuming Agent reads them automatically.

---

## Framework Catalog

### harness-pm — "Do the right thing"

Product exploration, market analysis, PRD generation, metrics operations. 86 skills including 19 orchestrators. Signature: **UI Directive Overreach Gate** — blocks PM from sneaking visual specs into PRD.

Core outputs: `PRD.md` / `pm-to-design.md` / `pm-to-solo.md` / `pm-to-growth.md`

### harness-design — "Make it look good and usable"

Visual design, interaction design, design system, prototype output. 19 skills. Signature: **Push-back** — design Agent can refuse PM's hardcoded UI directives. **Anti AI-Slop** — bans Inter/purple gradients/Lorem ipsum.

Core outputs: `DESIGN.md` / `tokens.json` / `design-to-solo.md` / `component-map.json`

### harness-solo — "Write good code"

Engineering, TDD, debugging, verification, code review. 21 skills. Signature: **Dual-source AC verification** — checks both engineering ACs (`AC-xxx`) and design ACs (`DAC-xxx`). **Entropy check** — catches file bloat and dependency creep.

Core outputs: `TECH_STACK.md` / `solo-to-growth.md` / `solo-to-ops.md` / `spec.md`

### harness-growth — "Make it used"

Content production, SEO, user operations, growth experiments. 40 skills across 9 modules. Signature: **Experiment-driven** — every action has a hypothesis and a metric.

Core outputs: `GROWTH_STRATEGY.md` / content assets / experiment records / `growth-to-pm.md`

### harness-ops — "Escort and deliver"

Infrastructure as Code, automated deployment, monitoring, disaster recovery. 32 skills. Signature: **Semi-automated architecture** — Agent proposes, human approves, GitOps executes. Four operation tiers (`inspect` → `propose` → `mutate-staging` → `mutate-prod`) with strict access control.

Core outputs: deployment records / monitoring configs / incident reports / `ops-to-pm.md`

---

## How It Works

### Three-layer architecture

```
Orchestration Layer (future, not a current goal)
                    ↕ contract documents
Framework Layer    pm / design / solo / growth / ops
                    ↕ load chain
Foundation Layer   AGENTS.md · SOUL.md · constitution.md · LOOP.md · skills/
```

### Contract collaboration

Frameworks pass structured requirements via `docs/handoff/` documents. Each document has a clear **producer** and **consumer**. Write access is one-directional — consumers read only, never modify.

| Producer → Consumer | Document |
|:---:|---|
| pm → design | `pm-to-design.md` |
| pm → solo | `pm-to-solo.md` |
| pm → growth | `pm-to-growth.md` |
| design → solo | `design-to-solo.md` + `component-map.json` |
| solo → growth | `solo-to-growth.md` |
| solo → ops | `solo-to-ops.md` |
| growth → pm | `growth-to-pm.md` |
| ops → pm | `ops-to-pm.md` |

AC numbering aligns cross-framework: `AC-xxx` (engineering) from PM, `DAC-xxx` (design) from Design — both verified by solo's verify skill.

### LOOP engine

All tasks follow a plan → execute → verify cycle. Evidence-driven: no claiming completion without proof. `state.yaml` supports checkpoint resume after interruption. Hard circuit breaker at 10 iterations.

### Minimal skill format

Each skill is a single `SKILL.md` with lightweight frontmatter:

```yaml
---
name: skill-name
description: One-sentence description
---
```

Dependency info (when to use, inputs, outputs, quality gates) lives in body text sections — natural language, easy to read and maintain.

---

## Key Design Decisions

### Why independent, not unified

Context explosion and memory pollution are the core pain points of AI Agent collaboration. A single Agent loading 198 skills wastes tokens and degrades output quality. Independent frameworks let each Agent specialize.

### Why contract documents, not shared state

No orchestration layer exists yet. Contract documents are the lowest-coupling collaboration method — produce a document, consume it downstream. When orchestration arrives, shared state can gradually replace some contracts.

### Why minimal frontmatter

Heavy YAML frontmatter (`triggers` / `reads` / `writes` / `quality_gates` / `max_iterations`) is rare in open-source conventions. Minimal frontmatter (`name` + `description`) plus natural-language body sections is the mainstream approach — more readable, more maintainable.

---

## Documentation

| Document | Content |
|----------|---------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Full architecture design (v2.1) |
| [harness-pm/README.md](./harness-pm/README.md) | PM framework details |
| [harness-design/README.md](./harness-design/README.md) | Design framework details |
| [harness-solo/README.md](./harness-solo/README.md) | Engineering framework details |
| [harness-growth/README.md](./harness-growth/README.md) | Growth framework details |
| [harness-ops/README.md](./harness-ops/README.md) | Ops framework details |

Each framework's `AGENTS.md` is the mandatory entry point read by the Agent at startup.

---

## License

MIT License — see the LICENSE file in each framework's root directory.

### Maintainer

[@LuckyOneTwoThree](https://github.com/LuckyOneTwoThree)

---

<div align="center">

**harness-all** · Independence First · Contract Collaboration · Loop Verification · Security Red Lines

</div>
