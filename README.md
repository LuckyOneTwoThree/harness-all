<div align="center">

**🌐 Language / 语言**: **English** | [中文](./README.zh.md)

---

# 🪢 harness-all

### Personal AI Studio · Multi-Agent Framework Family

> **A framework collection, not a single framework.** Each member is an independent, domain-specialized Agent framework. Current members: harness-pm (product) + harness-engineering (software engineering). The family is designed to grow — data / qa / security frameworks can be added on demand.

---

![Version](https://img.shields.io/badge/version-v3.0-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-2-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-109-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-19-purple.svg?style=for-the-badge&logo=git)
![Handoffs](https://img.shields.io/badge/handoffs-2-teal.svg?style=for-the-badge&logo=markdown)
![Loop Types](https://img.shields.io/badge/loop--types-10-red.svg?style=for-the-badge&logo=circleci)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)

---

## Framework Family

harness-all is a **collection of independent Agent frameworks**. Each framework is a self-contained domain specialist (skills + workflows + memory + constitution). Frameworks collaborate via contract documents, not shared state.

| Member | Type | Domain | Status | Skills | Workflows |
|:------:|------|--------|:------:|:------:|:---------:|
| **harness-pm** | Core | Product · Strategy · Market · PRD · API Contract · Metrics | ✅ Built | 84 | 10 |
| **harness-engineering** | Core | Software Engineering Delivery (4 phases: design-intake · frontend · backend · integration) | ✅ Built | 26 | 9 |
| harness-data | Extension | Data Pipeline · ETL · Metric Production | 📋 P1 To Build | — | — |
| harness-qa | Extension | Quality Assurance · Automated Testing · Performance Testing | ⚠️ P2 On Demand | — | — |
| harness-security | Extension | Security Audit · Compliance · Penetration Testing | ⚠️ P3 On Demand | — | — |

> **The family is open-ended.** Software engineering is just one domain type; the same architecture (AGENTS.md + skills/ + LOOP + contract documents) supports any specialized Agent framework — data, QA, security, ML, DevOps, etc.

</div>

---

## Pick Your Stack

The family ships **2 core frameworks today** (pm + engineering). Each is fully functional on its own; combine them when you need cross-domain data flow.

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

> **Future modes**: when harness-data / harness-qa / harness-security are built, the same contract-document pattern extends naturally — each new framework adds new handoff document types (e.g., `engineering-to-qa.md`, `qa-to-engineering.md`). The architecture is designed for growth, not capped at 2.

Each framework is **self-sufficient** — engineering's design-intake supports a degraded mode with no upstream PM handoff, deriving a minimal contract from user conversation. When you combine frameworks, they collaborate via structured contract documents under `docs/handoff/`.

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

**The problem**: Every AI conversation starts from zero. No project memory, no domain expertise, no quality gates.

```
❌ Without a framework
  Conversation 1: "Write a PRD"        → Agent asks everything from scratch
  Conversation 2: "Implement this"     → Agent doesn't know the PRD
  Conversation 3: "Fix this bug"       → Agent doesn't know the architecture
  ...every conversation is amnesiac
```

**harness gives AI Agents persistent project knowledge**:

| Without harness | With harness |
|----------------|--------------|
| Re-explain project every conversation | `knowledge-base.md` accumulates across sessions |
| Forgets on close | `progress.md` auto-restores context |
| One Agent does everything poorly | Specialized Agent per domain |
| "I think it's done" | LOOP engine + evidence gates + review-owned completion |
| Verbal handoff, info lost | Structured contract documents with AC numbering + SHA-256 manifest |
| Agent loops forever on failure | Hard circuit breaker at iteration 10 |
| One-size-fits-all process | Three exploration modes (skip / standard / deep) |

**One-line summary**: Prompt engineering teaches an Agent to do one thing; a framework gives it persistent memory, domain expertise, and engineering discipline that improves with use.

---

## Quick Start by Role

### Choose your framework

The family is open-ended. Currently 2 core frameworks are built; each specializes in one domain and works independently.

| You are | Framework | Type | What it does |
|---------|-----------|------|-------------|
| Product Manager | **harness-pm** | Product framework | Research → PRD → API Contract → Metrics → Iteration |
| Developer (full-stack) | **harness-engineering** | Software engineering framework | 4-phase delivery: design parsing → frontend → backend → integration |
| Data Engineer | *harness-data* (P1, to build) | Data framework | ETL · pipelines · metric production |
| QA Engineer | *harness-qa* (P2, on demand) | QA framework | Automated testing · performance testing |
| Security Engineer | *harness-security* (P3, on demand) | Security framework | Audit · compliance · penetration testing |

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

Open your AI Agent (e.g., Trae IDE) in the project directory. The Agent auto-reads:
1. `AGENTS.md` — mandatory startup rules
2. `SOUL.md` + `constitution.md` — domain values and non-negotiable principles
3. `skills/INDEX.md` → specific `SKILL.md` — on-demand skill loading
4. `memory/progress.md` — cross-session context restore

### Combine frameworks

When using both frameworks, contract documents flow between them:

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

Copy the complete `docs/handoff/packages/<handoff_id>/` directory to the downstream framework. A Markdown contract alone is not portable — the consumer must verify its manifest and bundled artifacts.

---

## Framework Catalog

### harness-pm — "Do the right thing" (Product framework)

Product exploration, market analysis, PRD generation, API contract spec, metrics operations. 84 skills (80 domain + 4 meta) including 17 orchestrators across 7 modules.

**Signature mechanisms**:
- **UI Directive Overreach Gate** — blocks PM from sneaking visual specs into PRD
- **Routing Fields** — `project_mode` + `exploration_mode` + `task_type` + `scope` drive engineering phase execution
- **Design Asset Path Collection** — PM collects user-owned design asset paths (Figma / v0 / md / images); PM never produces design output
- **Batch-aware Reverse Feedback** — prd-orchestrator phase 0 Branch B detects `batch.added_acs` / `batch.superseded_acs` from engineering-to-pm handoff
- **Change Impact Analysis** — reads `state.yaml.ac_change` to assess blast radius of added/superseded ACs

Core outputs: `PRD.md` / `pm-to-engineering.md`

### harness-engineering — "Write good code" (Software engineering framework)

4-phase engineering delivery: design-intake → frontend → backend → integration. 26 skills (22 domain + 4 meta) + 9 workflows. This is the **software engineering** member of the family — other domain types (data, QA, security, etc.) are added as separate frameworks, not as skills inside engineering.

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
  modified_acs: [AC-F01-002]        # same ID, new content
  superseded_acs: [AC-F01-001]      # retired, replaced by AC-F01-004
  unchanged_acs: [AC-F01-003]
```

- Producer fills `batch` in envelope; consumer (downstream session-start) reads it to scope triage without re-deriving diff
- `ac_ids` envelope field MUST equal `added_acs + modified_acs + unchanged_acs` (superseded excluded)
- Validator enforces this equality at handoff consumption

### Cross-framework reconciliation

Each framework maintains its own `FEATURES.md` with lifecycle-appropriate status. Synchronization flows through handoff documents, not direct writes:

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

### Three-layer architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  Orchestration Layer (Future, non-goal)                         │
│  • Multi-Agent scheduling · shared source of truth · cross-LOOP │
└─────────────────────────────────────────────────────────────────┘
                          ↕  contract documents
┌─────────────────────────────────────────────────────────────────┐
│  Framework Layer (Current focus)                                │
│  ┌──────────────────┐   ┌──────────────────────────────────┐    │
│  │  harness-pm      │   │  harness-engineering             │    │
│  │  (84 skills)     │   │  (26 skills, 4 phases)           │    │
│  └──────────────────┘   └──────────────────────────────────┘    │
│  + Extension frameworks: data (P1) / qa (P2) / security (P3)    │
└─────────────────────────────────────────────────────────────────┘
                          ↕  load chain
┌─────────────────────────────────────────────────────────────────┐
│  Foundation Layer (inside each framework)                       │
│  AGENTS.md · SOUL.md · constitution.md · LOOP.md · skills/      │
└─────────────────────────────────────────────────────────────────┘
```

### Contract collaboration

Frameworks pass structured requirements via `docs/handoff/` documents. Each document has a clear **producer** and **consumer**. Write access is one-directional — consumers read only, never modify.

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

## Key Design Decisions

### Why a framework family, not a single framework

A single framework loading all domain skills would explode the Agent's context and pollute its memory. The family architecture lets each Agent specialize in one domain (product / engineering / data / QA / security / ...). New domain frameworks can be added on demand without touching existing ones — they just add new handoff document types.

### Why 2 core frameworks + 4 phases (v3.0.0)

The v2.x 3-framework split (pm/design/solo) had poor UI fidelity (solo received design via a parsed contract, losing visual nuance) and blocked frontend/backend parallelism. Consolidating engineering into one framework with 4 internal phases keeps the workspace unified; phase transitions use lightweight `phase-N-report.md` instead of full handoff envelopes. Design assets are now user-owned (Figma/v0/md).

### Why independent, not unified

Context explosion and memory pollution are the core pain points of AI Agent collaboration. A single Agent loading 109 skills wastes tokens and degrades output quality. Independent frameworks let each Agent specialize.

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
| [harness-pm/README.md](./harness-pm/README.md) | PM framework details |
| [harness-engineering/README.md](./harness-engineering/README.md) | Engineering framework details |

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
