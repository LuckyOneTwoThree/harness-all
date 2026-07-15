<div align="center">

**🌐 Language / 语言**: **English** | [中文](./README.zh.md)

---

# 🪢 harness-all

### Agent-agnostic Product Delivery Harness for AI-native R&D

> **A local-first governance & delivery protocol layer for AI product R&D — not another multi-agent runtime.** It sits *above* your Agent tools (Claude Code, Cursor, Trae, Codex, ...), giving them persistent project memory, domain SOPs, contract-based handoff, and quality gates that survive tool switches. Current domain packs: harness-pm (product) + harness-engineering (software engineering); the family grows on demand.

---

![Version](https://img.shields.io/badge/version-v3.0-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-2-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-109-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-20-purple.svg?style=for-the-badge&logo=git)
![Handoffs](https://img.shields.io/badge/handoffs-2-teal.svg?style=for-the-badge&logo=markdown)
![Loop Types](https://img.shields.io/badge/loop--types-10-red.svg?style=for-the-badge&logo=circleci)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)

---

## What this is — and what it isn't

harness-all is **not** CrewAI, LangGraph, AutoGen/MAF, or Agent Orchestrator. Those are **Agent runtimes** — they decide which Agent runs this task, in what order, with what branching, and how they message each other *this time*.

harness-all is a **governance & delivery layer** — it decides what long-term R&D process your project follows, what memory it keeps across sessions, how work is handed off and accepted across roles, and how the next session (or the next tool) picks up where the last one left off.

```
Agent runtime frameworks (CrewAI / LangGraph / MAF / Agent Orchestrator)
  = Agent scheduling · execution engine · message passing · state graph

harness-all
  = Domain SOP + Memory + Contract Delivery + Quality Governance
```

The two layers are **orthogonal and composable**: a runtime can execute inside a harness workspace; a harness workspace can outlive any specific runtime.

| Question | Agent runtimes | harness-all |
|----------|:--------------:|:-----------:|
| Which Agents run this task, in what order? | ✅ Core strength | ❌ Not our job |
| How do Agents message each other in real time? | ✅ Core strength | ❌ Not our job |
| What should the project remember 3 months from now? | ⚠️ Usually session-bound | ✅ Local files are the source of truth |
| How do PM and Engineering hand off without info loss? | ⚠️ You build it yourself | ✅ Contract documents + AC numbering |
| What counts as "done" — and who is allowed to say so? | ⚠️ You build it yourself | ✅ Review-owned completion + evidence gates |
| If I switch from Claude Code to Codex, does the project survive? | ❌ Usually no | ✅ Tool-agnostic by design |

**Other frameworks orchestrate Agents. harness-all orchestrates long-term R&D discipline, project context, and trusted delivery.**

</div>

---

## What makes it different

Five design choices that distinguish harness-all from both runtime frameworks and prompt libraries:

**1. Roles are long-term domain workspaces, not one-off Agent personas.**
A CrewAI role is a `role + goal + backstory` YAML served for one workflow. A harness framework is a persistent "department": it has its own constitution, skills, memory, progress, domain boundary, and outbound contracts — and it keeps working across sessions.

**2. Contract-based delivery, not free-form Agent conversation.**
PM → Engineering is not a chat message. It is a versioned package: PRD + AC numbering + API contract + design asset paths + routing fields + SHA-256 manifest + receipt. Consumers are read-only; reverse feedback flows through a separate outbound contract. This borrows from mature software-engineering practice (bounded context, API contract, event envelope, artifact provenance) rather than from multi-agent chat.

**3. "Done" is a governance state, not an Agent's claim.**
`status: done` is written exclusively by the code-review skill — never by verify. Combined with a hard circuit breaker at iteration 10, evidence-driven completion, and permanent AC IDs (supersede, never delete), this directly targets the Agent failure mode of confusing "generated output" with "finished work."

**4. Local files are the source of truth; Agent tools are replaceable clients.**
Markdown / YAML / JSON on disk is the only truth. Indexes can be rebuilt. The Agent tool (Claude Code today, Codex tomorrow, something unknown next year) is a replaceable execution client. Project knowledge, decisions, contracts, and audit trails do not live inside any vendor's chat history.

**5. Frameworks are independent, with deliberately no shared mutable state.**
109 skills are split across PM and Engineering. Each Agent loads only its own domain. Cross-domain collaboration transmits the minimum explicit contract — never a shared memory all Agents can read and pollute. This is more conservative than "one shared blackboard everyone writes to," but it is what keeps context clean and failure isolated in serious, long-running projects.

---

## Framework Family

harness-all is a **collection of independent domain packs**. Each pack is a self-contained domain specialist (skills + workflows + memory + constitution). Packs collaborate via contract documents, not shared state.

| Member | Type | Domain | Status | Skills | Workflows |
|:------:|------|--------|:------:|:------:|:---------:|
| **harness-pm** | Core | Product · Strategy · Market · PRD · API Contract · Metrics | ✅ Built | 84 | 11 |
| **harness-engineering** | Core | Software Engineering Delivery (4 phases: design-intake · frontend · backend · integration) | ✅ Built | 25 | 9 |
| harness-data | Extension | Data Pipeline · ETL · Metric Production | 📋 P1 To Build | — | — |
| harness-qa | Extension | Quality Assurance · Automated Testing · Performance Testing | ⚠️ P2 On Demand | — | — |
| harness-security | Extension | Security Audit · Compliance · Penetration Testing | ⚠️ P3 On Demand | — | — |

> **The family is open-ended.** Software engineering is just one domain type; the same architecture (AGENTS.md + skills/ + LOOP + contract documents) supports any specialized Agent framework — data, QA, security, ML, DevOps, etc.

---

## Pick Your Stack

The family ships **2 core packs today** (pm + engineering). Each is fully functional on its own; combine them when you need cross-domain data flow.

```
┌─────────────────────────────────┐   ┌──────────────────────────────────────────────┐
│ Mode 1: Engineering Only        │   │ Mode 2: Full Studio (PM + Engineering)        │
│                                 │   │                                              │
│   User ─────────► Engineering   │   │   User ──► PM ──pm-to-engineering.md──► Engineering
│                   (4 phases)    │   │            ◄──engineering-to-pm.md──          │
│                                 │   │              (reverse feedback, on demand)   │
│   "I just write code"           │   │   "Full product studio"                      │
└─────────────────────────────────┘   └──────────────────────────────────────────────┘
```

> **Future modes**: when harness-data / harness-qa / harness-security are built, the same contract-document pattern extends naturally — each new pack adds new handoff document types (e.g., `engineering-to-qa.md`, `qa-to-engineering.md`). The architecture is designed for growth, not capped at 2.

Each pack is **self-sufficient** — engineering's design-intake supports a degraded mode with no upstream PM handoff, deriving a minimal contract from user conversation. When you combine packs, they collaborate via structured contract documents under `docs/handoff/`.

### End-to-end flow (Mode 2)

```
┌──────────────────┐                              ┌──────────────────────────────────────────┐
│   harness-pm     │   pm-to-engineering.md       │   harness-engineering                    │
│                  │ ───────────────────────────► │                                          │
│  • PRD + AC-xxx  │   (PRD + API contract        │   Phase 0: design-intake                 │
│  • API contract  │    + design asset paths      │     → contract.json + tokens.json        │
│  • Design paths  │    + routing fields)         │   Phase 1: frontend (TDD + dual-input)   │
│  • Routing fields│                              │     → frontend code (mock-backed)        │
│                  │ ◄─────────────────────────── │   Phase 2: backend                       │
│                  │   engineering-to-pm.md       │     → api + data + migration             │
│                  │   (integration results +     │   Phase 3: integration                   │
│                  │    feedback, on demand)      │     → mock→real + e2e + code-review      │
└──────────────────┘                              └──────────────────────────────────────────┘
```

---

## Why harness

**The problem**: Every AI conversation starts from zero. No project memory, no domain expertise, no quality gates. And when you switch Agent tools, everything is lost again.

```
❌ Without a framework
  Conversation 1: "Write a PRD"        → Agent asks everything from scratch
  Conversation 2: "Implement this"     → Agent doesn't know the PRD
  Conversation 3: "Fix this bug"       → Agent doesn't know the architecture
  Switch from Claude Code to Cursor    → Start over, again
  ...every conversation is amnesiac, every tool switch is a reset
```

**harness gives AI Agents persistent project knowledge that survives tool switches**:

| Without harness | With harness |
|----------------|--------------|
| Re-explain project every conversation | `knowledge-base.md` accumulates across sessions |
| Forgets on close | `progress.md` auto-restores context |
| Switching Agent tools = starting over | Local files are truth; tools are replaceable clients |
| One Agent does everything poorly | Specialized Agent per domain |
| "I think it's done" | LOOP engine + evidence gates + review-owned completion |
| Verbal handoff, info lost | Structured contract documents with AC numbering + SHA-256 manifest |
| Agent loops forever on failure | Hard circuit breaker at iteration 10 |
| One-size-fits-all process | Three exploration modes (skip / standard / deep) |

**One-line summary**: Prompt engineering teaches an Agent to do one thing; a framework gives it persistent memory, domain expertise, and engineering discipline that improves with use — independent of which Agent tool you happen to run.

---

## Quick Start by Role

### Choose your pack

The family is open-ended. Currently 2 core packs are built; each specializes in one domain and works independently.

| You are | Pack | Type | What it does |
|---------|-----------|------|-------------|
| Product Manager | **harness-pm** | Product pack | Research → PRD → API Contract → Metrics → Iteration |
| Developer (full-stack) | **harness-engineering** | Software engineering pack | 4-phase delivery: design parsing → frontend → backend → integration |
| Data Engineer | *harness-data* (P1, to build) | Data pack | ETL · pipelines · metric production |
| QA Engineer | *harness-qa* (P2, on demand) | QA pack | Automated testing · performance testing |
| Security Engineer | *harness-security* (P3, on demand) | Security pack | Audit · compliance · penetration testing |

### Install

```bash
# 1. Clone the framework family to any location (one-time)
cd /path/to/your-parent-dir
git clone https://github.com/LuckyOneTwoThree/harness-all.git

# 2. Navigate to your project (create one if not exists)
cd /path/to/your-project

# 3. Install the framework you need (engineering as example)
bash /path/to/your-parent-dir/harness-all/harness-engineering/install.sh
```

The install script creates the `.harness/` directory structure, copies core config files, and initializes memory.

> **Windows users — `bash` command routing**
>
> On Windows, the system-provided `bash.exe` is a WSL stub, not Git Bash. If you see "WSL has no installed distribution", the `bash` command was routed to WSL.
>
> **Three solutions (pick one):**
> 1. **Use Git Bash terminal** (recommended): open "Git Bash", then `cd /d/your-project && bash /path/to/install.sh`
> 2. **Full path in PowerShell**: `& "C:\Program Files\Git\bin\bash.exe" install.sh`
> 3. **Permanent alias** (one-time): add to PowerShell profile (`notepad $PROFILE`):
>    ```powershell
>    function bash { & "C:\Program Files\Git\bin\bash.exe" @args }
>    ```

### Start the Agent

Open your AI Agent (e.g., Trae IDE, Claude Code, Cursor) in the project directory. The Agent auto-reads:
1. `AGENTS.md` — mandatory startup rules
2. `SOUL.md` + `constitution.md` — domain values and non-negotiable principles
3. `skills/INDEX.md` → specific `SKILL.md` — on-demand skill loading
4. `memory/progress.md` — cross-session context restore

### Combine packs

When using both packs, contract documents flow between them:

```
┌──────────────┐   pm-to-engineering.md    ┌──────────────────┐
│  harness-pm  │ ─────────────────────────►│  harness-        │
│              │   (PRD + AC + API contract│  engineering     │
│  PRD + AC +  │    + design paths +       │                  │
│  API contract│    routing fields)        │  Phase 0 → 1 → 2 │
│  + routing   │                           │  → 3             │
│              │ ◄─────────────────────────│                  │
│              │   engineering-to-pm.md    │                  │
│              │   (integration results +  │                  │
│              │    feedback, on demand)   │                  │
└──────────────┘                           └──────────────────┘
```

Copy the complete `docs/handoff/packages/<handoff_id>/` directory to the downstream pack. A Markdown contract alone is not portable — the consumer must verify its manifest and bundled artifacts.

---

## Framework Catalog

### harness-pm — "Do the right thing" (Product pack)

Product exploration, market analysis, PRD generation, API contract spec, metrics operations. 84 skills (80 domain + 4 meta) including 17 orchestrators across 7 modules.

**Signature mechanisms**:
- **UI Directive Overreach Gate** — blocks PM from sneaking visual specs into PRD
- **Routing Fields** — `project_mode` + `exploration_mode` + `task_type` + `scope` drive engineering phase execution
- **Design Asset Path Collection** — PM collects user-owned design asset paths (Figma / v0 / md / images); PM never produces design output
- **Batch-aware Reverse Feedback** — prd-orchestrator phase 0 Branch B detects `batch.added_acs` / `batch.superseded_acs` from engineering-to-pm handoff
- **Change Impact Analysis** — reads `state.yaml.ac_change` to assess blast radius of added/superseded ACs

Core outputs: `PRD.md` / `pm-to-engineering.md`

### harness-engineering — "Write good code" (Software engineering pack)

4-phase engineering delivery: design-intake → frontend → backend → integration. 25 skills (21 domain + 4 meta) + 9 workflows. This is the **software engineering** member of the family — other domain types (data, QA, security, etc.) are added as separate packs, not as skills inside engineering.

**Four phases**:

| Phase | Name | Input | Output |
|-------|------|-------|--------|
| 0 | design-intake | `pm-to-engineering.md` (PRD + API contract + design asset paths) **or** user-provided assets directly (degraded mode) | `contract.json` + `tokens.json` |
| 1 | frontend | `contract.json` + `tokens.json` + design assets (dual-input: contract layer + visual layer) | Frontend code (TDD, mock-backed) |
| 2 | backend | API contract from `contract.json` | Backend implementation (api + data + migration) |
| 3 | integration | frontend + backend | mock→real switch + e2e verification + `engineering-to-pm.md` |

**Phase 0 accepts these user-owned design asset types** (PM collects paths in family mode; user drops them directly in degraded mode):

| Asset type | Examples | Phase 0 route |
|------------|----------|---------------|
| Image | `.png` / `.jpg` / `.webp` (screenshots, sketches, mockups, Figma exports) | Multimodal extraction (color / typography / spacing / layout) |
| Code | v0 export, `tailwind.config.js`, `theme.ts`, `globals.css`, shadcn `components.json` | Code parsing (extract tokens + component structure) |
| Markdown | `*.md` design specs with structured sections | Markdown structuring |
| Figma | Figma URL / export (used as visual reference in Phase 1) | Path forwarded to Phase 1 dual-input |

**Signature mechanisms**:
- **Dual-input Mode** — frontend agent reads both `contract.json` AND original design assets (visual fidelity)
- **TDD Hard Rule** — behavior change requires a failing test first; code written before tests is deleted
- **AC Numbering** — `AC-xxx` (product) + `BAC-xxx` (backend) + `IAC-xxx` (integration); `DAC-xxx` retired
- **Review-owned Completion** — `status: done` is written exclusively by code-review skill, never by verify
- **bugfix Contract Change Detection** — bugfix that changes API contract prompts upgrade to refactor flow
- **Three exploration modes** — `skip` (quick-fix) / `standard` (full 4-phase) / `deep` (OpenAPI + nested tasks)
- **Phase Checkpoint** — each phase produces `phase-N-report.md`; phase advance requires user confirmation

Core outputs: `TECH_STACK.md` / `spec.md` / `contract.json` / `engineering-to-pm.md`

---

## Signature Mechanisms in Depth

These are not paper designs — they are enforced in SKILL.md Process / Quality gates / Prohibited sections, with concrete file writes and state transitions.

### LOOP engine with hard circuit breaker

```
    ┌──────────────────────────────────────────────────────┐
    │                                                      │
    ▼                                                      │
  PLAN ──► ACT ──► VERIFY ──pass──► REVIEW ──pass──► done │
                 │                  │
                 │                  └─fail──► back to ACT │
                 └─fail──► RESEARCH (iteration +1)        │
                                  │                        │
                                  └─ iteration ≥ 10 ──► hard breaker
                                     (attempt 11 forbidden; reset needs
                                      explicit user authorization)
```

- **Evidence-driven**: no claiming completion without proof (Core Rule)
- **Checkpoint resume**: `state.yaml` persists iteration / stage / substage / last_error
- **Hard circuit breaker**: attempt 10 may complete; attempt 11 is prohibited; reset requires explicit user authorization
- **Substage enum**: `inline-passed` / `inline-failed` / `awaiting-full` / `full-running` / `full-passed` / `full-failed` — eliminates `stage: verify` ambiguity
- **Single increment rule**: iteration increments exactly once before ACT begins, never during failure handling
- **Phase tracking** (engineering only): `state.yaml.substage_progress` records phase_0..phase_3 completion

### AC numbering with permanent retention

```
PM (PRD)            Engineering
  │                 Phase 0          Phase 2          Phase 3
  │                 design-intake    backend          integration
  │                     │               │                │
  └──► AC-F01-001 ─────►│ preserved ────►│                │
                        │               └──► BAC-F01-001 │
                        │                   (new)        │
                        │                                │
                        └────────────────► IAC-F01-001 ──┘
                                            (new)

  All three AC types are tracked via state.yaml.ac_ids
  Phase 3 verify runs a triple-source check (AC + BAC + IAC)
```

- **Permanent**: IDs are never renumbered or recycled
- **Supersede, don't delete**: changed semantics → new ID, old ID marked `[superseded]` with pointer to replacement
- **Superseded ACs do NOT appear in envelope `ac_ids`** — only their replacement does
- **Phase-specific verification**: AC-xxx verified at all phases; BAC-xxx at Phase 3; IAC-xxx at Phase 3

### Batch delivery protocol

```yaml
batch:
  id: 2
  type: incremental  # or "full" for first delivery / re-broadcast
  added_acs: [AC-F01-004]           # new scope
  modified_acs: [AC-F01-002]        # reverse feedback: same ID, requested change
  superseded_acs: [AC-F01-001]      # retired, replaced by AC-F01-004
  unchanged_acs: [AC-F01-003]
```

- Producer fills `batch` in envelope; consumer (downstream session-start) reads it to scope triage without re-deriving diff
- `ac_ids` envelope field MUST equal `added_acs + modified_acs + unchanged_acs` (superseded excluded)
- Validator enforces this equality at handoff consumption

### Cross-framework reconciliation

Each pack maintains its own `FEATURES.md` with lifecycle-appropriate status. Synchronization flows through handoff documents, not direct writes:

| PM status | Engineering status | Meaning |
|-----------|---------------------|---------|
| `approved` | `pending` | PM handoff ready; Engineering not started |
| `developing` | `in_progress` / `review` | Engineering actively developing or in verify |
| `launched` | `done` | Engineering code-review passed AND PM launched |
| `blocked` | `blocked` | Blocked (reason may differ by framework) |

### Security red lines (absolute prohibitions)

- No hardcoded secrets / API keys in code
- No `rm -rf /` / `curl | sh` / `chmod -R 777` / `git push --force to main`
- No executing `DROP DATABASE/TABLE`
- No Git hook installation without explicit user authorization
- No bypassing verify skill to claim completion
- Sensitive files (`.env` / `*.pem` / `*.key` / `id_rsa` / `credentials.json`) are never read

---

## How It Works

### Architecture: current state and target direction

**Today** — a three-layer, file-based, runtime-free system:

```
┌─────────────────────────────────────────────────────────────────┐
│  Orchestration Layer (deferred — see trigger conditions below)   │
│  • Multi-Agent scheduling · shared source of truth · cross-LOOP │
└─────────────────────────────────────────────────────────────────┘
                          ↕  contract documents
┌─────────────────────────────────────────────────────────────────┐
│  Framework Layer (Current focus)                                │
│  ┌──────────────────┐   ┌──────────────────────────────────┐    │
│  │  harness-pm      │   │  harness-engineering             │    │
│  │  (84 skills)     │   │  (25 skills, 4 phases)           │    │
│  └──────────────────┘   └──────────────────────────────────┘    │
│  + Extension packs: data (P1) / qa (P2) / security (P3)         │
└─────────────────────────────────────────────────────────────────┘
                          ↕  load chain
┌─────────────────────────────────────────────────────────────────┐
│  Foundation Layer (inside each framework)                       │
│  AGENTS.md · SOUL.md · constitution.md · LOOP.md · skills/      │
└─────────────────────────────────────────────────────────────────┘
```

**Target direction** — four layers, with harness-all owning L1 + L2 and borrowing L3 rather than rebuilding it:

```
┌───────────────────────────────────────────────────────┐
│ L4 Control Plane (Reins)                              │
│ Project view · task graph · run monitor · contract    │
│ chain · human approval                                │
├───────────────────────────────────────────────────────┤
│ L3 Runtime Adapters (borrow, don't rebuild)           │
│ Claude Code / Codex / Cursor / Trae /                 │
│ Agent Orchestrator / LangGraph / MAF                  │
├───────────────────────────────────────────────────────┤
│ L2 Governance Kernel                                  │
│ LOOP · state machine · quality gate · policy ·        │
│ validator (machine-enforced, not prompt-only)         │
├───────────────────────────────────────────────────────┤
│ L1 Domain Packs                                       │
│ PM / Engineering / QA / Security / Data               │
│ Skills · Memory Spec · Contract Schema · SOP          │
└───────────────────────────────────────────────────────┘
```

**On the orchestration layer**: it is deferred, not abandoned. The current file-based contract protocol is the lowest-coupling collaboration method and is sufficient for 2 packs. We will revisit a minimal orchestration layer when trigger conditions are met — e.g., pack count ≥ 3, or cross-machine collaboration becomes a real need. Until then, humans act as the router, which is a deliberate trade-off for context cleanliness and auditability.

### Contract collaboration

Packs pass structured requirements via `docs/handoff/` documents. Each document has a clear **producer** and **consumer**. Write access is one-directional — consumers read only, never modify.

| Producer → Consumer | Document |
|:---:|---|
| pm → engineering | `pm-to-engineering.md` (PRD + AC + API contract + design asset paths + routing) |
| engineering → pm | `engineering-to-pm.md` (integration results + feedback, on demand) |

Each handoff envelope carries: `schema_version` / `handoff_id` / `producer` / `consumer` / `created_at` / `source_revision` / `supersedes` / `status` / `ac_ids` + optional `batch` + `artifacts[]`. Consumer validates SHA-256 manifest and writes a receipt.

### Three exploration modes (engineering)

| Mode | Trigger | Phases | state.yaml | LOOP | verify-full | code-review |
|------|---------|:------:|:----------:|:----:|:-----------:|:-----------:|
| `skip` | quick-fix (Risk Gate 6 items all green) | Phase 3 only | 0 fields | no | no | diff review only |
| `standard` | default | Phase 0 → 1 → 2 → 3 | 7-9 fields | yes | yes | yes |
| `deep` | new-product-engineering / ambiguous | Phase 0 (deep) → 1 → 2 → 3 + OpenAPI | 10 fields | yes (nested) | yes | yes + product-engineering-review |

Mode source priority: user explicit > auto-detect > workflow `default_mode` > standard.

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

## Honest Scope

**What harness-all does well today**:
- Persistent project memory that survives session resets and Agent tool switches
- Domain-specialized workspaces with clean context boundaries
- Contract-based cross-domain handoff with versioning, AC numbering, and audit trails
- Engineering discipline: TDD, review-owned completion, hard circuit breaker, evidence gates
- Three flow-intensity modes (skip / standard / deep) for different task sizes

**What it does NOT do (and is not trying to do)**:
- It is **not an Agent runtime**. It does not spawn Agent processes, schedule concurrent execution, or manage Agent heartbeats. For that, use CrewAI / LangGraph / MAF / Agent Orchestrator.
- It does **not auto-route** cross-pack handoffs. Today, humans copy the handoff package to the downstream pack. (A minimal registry + CLI delivery is on the roadmap — see target architecture L4.)
- It does **not provide a visual debugger** or real-time run monitor yet. State is human-readable files (`state.yaml`, `phase-N-report.md`, `progress.md`); a control plane (Reins) is planned.

**Where rules currently live**:
- Most governance rules (LOOP transitions, AC semantics, write-access isolation, quality gates) are encoded in `SKILL.md` Process / Quality gates / Prohibited sections and enforced by the Agent reading them.
- A validator script (`scripts/validate.ps1`) checks structural consistency post-hoc.
- **Forward direction**: migrate the most safety-critical rules (state transitions, iteration cap, done-permission, manifest integrity) from prompt-only to machine-enforced (L2 Governance Kernel) so they hold even if an Agent skips or forgets a rule.

---

## Key Design Decisions

### Why agent-agnostic, not agent-bound

Agent tools (Claude Code, Cursor, Codex, Trae, Cline, ...) evolve fast and lock you into their session model. harness-all keeps project knowledge in local files that any tool can read, so switching tools does not reset your project. This is "framework lifecycle decoupled from Agent-tool lifecycle."

### Why a framework family, not a single framework

A single framework loading all domain skills would explode the Agent's context and pollute its memory. The family architecture lets each Agent specialize in one domain (product / engineering / data / QA / security / ...). New domain packs can be added on demand without touching existing ones — they just add new handoff document types.

### Why 2 core packs + 4 phases (v3.0.0)

The v2.x 3-framework split (pm/design/solo) had poor UI fidelity (solo received design via a parsed contract, losing visual nuance) and blocked frontend/backend parallelism. Consolidating engineering into one pack with 4 internal phases keeps the workspace unified; phase transitions use lightweight `phase-N-report.md` instead of full handoff envelopes. Design assets are now user-owned (Figma/v0/md).

### Why independent, not unified

Context explosion and memory pollution are the core pain points of AI Agent collaboration. A single Agent loading 109 skills wastes tokens and degrades output quality. Independent packs let each Agent specialize.

### Why contract documents, not shared state

No orchestration layer exists yet. Contract documents are the lowest-coupling collaboration method — produce a document, consume it downstream. When orchestration arrives, shared state can gradually replace some contracts.

### Why minimal frontmatter

Heavy YAML frontmatter (`triggers` / `reads` / `writes` / `quality_gates` / `max_iterations`) is rare in open-source conventions. Minimal frontmatter (`name` + `description`) plus natural-language body sections is the mainstream approach — more readable, more maintainable.

### Why hard circuit breaker at 10

Agents can hallucinate progress and loop forever on failure. Iteration 10 is the absolute cap — attempt 10 may complete, but attempt 11 is prohibited. This prevents runaway token consumption while leaving room for genuine iteration.

### Why review-owned completion

`status: done` is written exclusively by the code-review skill, never by verify. This separation prevents the verify skill from self-certifying completion — a fundamental audit trail guarantee.

---

## Documentation

| Document | Content |
|----------|---------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Full architecture design (v3.0.0) |
| [DOMAIN_BOUNDARIES.md](./DOMAIN_BOUNDARIES.md) | Normative ownership and routing rules |
| [HANDOFF_PROTOCOL.md](./HANDOFF_PROTOCOL.md) | Versioned contract protocol |
| [UPGRADING.md](./UPGRADING.md) | Conflict-safe framework upgrade process |
| [harness-pm/README.md](./harness-pm/README.md) | PM pack details |
| [harness-engineering/README.md](./harness-engineering/README.md) | Engineering pack details |

Each pack's `AGENTS.md` is the mandatory entry point read by the Agent at startup.

---

## License

MIT License — see the LICENSE file in each pack's root directory.

### Maintainer

[@LuckyOneTwoThree](https://github.com/LuckyOneTwoThree)

---

<div align="center">

**harness-all** · Other frameworks orchestrate Agents; we orchestrate long-term R&D discipline, project context, and trusted delivery.

**Independence First · Contract Collaboration · Loop Verification · Security Red Lines**

</div>
