<div align="center">

**🌐 Language / 语言**: **English** | [中文](./README.zh.md)

---

# 🪢 harness-all

### Personal AI Studio · Multi-Agent Framework Family

> **Pick your stack. Each framework works independently. Combine them when you need to.**

---

![Version](https://img.shields.io/badge/version-v2.2.1-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-3-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-119-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-27-purple.svg?style=for-the-badge&logo=git)
![Handoffs](https://img.shields.io/badge/handoffs-5-teal.svg?style=for-the-badge&logo=markdown)
![Loop Types](https://img.shields.io/badge/loop--types-13-red.svg?style=for-the-badge&logo=circleci)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)

---

| Framework | Domain | Skills | Workflows |
|:---------:|--------|:------:|:---------:|
| **harness-pm** | Strategy · Market · PRD · Metrics | 84 | 10 |
| **harness-design** | Visual · Interaction · Prototype · Design System | 16 | 8 |
| **harness-solo** | Engineering · TDD · Debug · Refactor · Verify | 19 | 9 |

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
│  │  only   │           └─────┘  └─────────┘                 │
│  └─────────┘                                                 │
│                                                              │
│  "I just write code"  "PM + Design"            "Full studio" │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

Each framework is **self-sufficient** — no handoff documents required (solo even has an explicit **standalone mode** that short-circuits the entire handoff validation pipeline when no upstream PM/Design exists). When you combine frameworks, they collaborate via structured contract documents under `docs/handoff/`.

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
| "I think it's done" | LOOP engine + evidence gates + review-owned completion |
| Verbal handoff, info lost | Structured contract documents with AC numbering + SHA-256 manifest |
| Agent loops forever on failure | Hard circuit breaker at iteration 10 |
| One-size-fits-all process | Three exploration modes (skip / standard / deep) |

**One-line summary**: Prompt engineering teaches an Agent to do one thing; a framework gives it persistent memory, domain expertise, and engineering discipline that improves with use.

---

## Quick Start by Role

### Choose your framework

| You are | Framework | What it does |
|---------|-----------|-------------|
| Product Manager | **harness-pm** | Research → PRD → Metrics → Iteration |
| Designer | **harness-design** | Brief → Visual → Interaction → Handoff spec |
| Developer | **harness-solo** | Plan → TDD → Implement → Verify |

### Install

```bash
# 1. Clone the framework family to any location (one-time)
cd /path/to/your-parent-dir
git clone https://github.com/LuckyOneTwoThree/harness-all.git

# 2. Navigate to your project (create one if not exists)
cd /path/to/your-project

# 3. Install the framework you need (solo as example)
bash /path/to/your-parent-dir/harness-all/harness-solo/install.sh
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

When using multiple frameworks, contract documents flow between them:

```
harness-pm → pm-to-design.md → harness-design → design-to-solo.md → harness-solo
                                                       ↑
                                  solo-to-pm.md ───────┘  (reverse feedback)
```

Copy the complete `docs/handoff/packages/<handoff_id>/` directory to the downstream framework. A Markdown contract alone is not portable — the consumer must verify its manifest and bundled artifacts.

---

## Framework Catalog

### harness-pm — "Do the right thing"

Product exploration, market analysis, PRD generation, metrics operations. 84 skills (80 domain + 4 meta) including 17 orchestrators across 7 modules.

**Signature mechanisms**:
- **UI Directive Overreach Gate** — blocks PM from sneaking visual specs into PRD
- **Batch-aware Reverse Feedback** — prd-orchestrator phase 0 Branch B detects `batch.added_acs` / `batch.superseded_acs` from solo-to-pm handoff, avoids re-deriving diff
- **Change Impact Analysis** — reads `state.yaml.ac_change` to assess blast radius of added/superseded ACs

Core outputs: `PRD.md` / `pm-to-design.md` / `pm-to-solo.md`

### harness-design — "Make it look good and usable"

Visual design, interaction design, design system, prototype output. 16 skills (12 domain + 4 meta) + 8 workflows.

**Signature mechanisms**:
- **Push-back** — design Agent can refuse PM's hardcoded UI directives, with AC Cleanup Log for traceability
- **Anti AI-Slop** — bans Inter / purple gradients / Lorem ipsum / overused stock illustrations
- **Doubt-Driven Review** — five-axis review (Visual / Interaction / Accessibility / Consistency / Aesthetic) with WCAG 2.1 AA machine-assertable subset
- **Two-layer contract** — `component-contract.json` (semantic, design-owned) + `component-bindings.json` (engineering binding, solo-owned)

Core outputs: `DESIGN.md` / `tokens.json` / `design-to-solo.md` / `component-contract.json`

### harness-solo — "Write good code"

Engineering, TDD, debugging, verification, code review. 19 skills (15 domain + 4 meta) + 9 workflows.

**Signature mechanisms**:
- **TDD Hard Rule** — behavior change requires a failing test first; code written before tests is deleted
- **Dual-source AC Verification** — verify checks both `AC-xxx` (from PM) and `DAC-xxx` (from Design)
- **Review-owned Completion** — `status: done` is written exclusively by code-review skill, never by verify
- **Standalone Mode** — when no upstream PM/Design handoff exists, session-start short-circuits the entire envelope/batch/manifest/receipt pipeline
- **Three exploration modes** — `skip` (quick-fix, 5 steps, 0 state) / `standard` (11 steps, full LOOP) / `deep` (20 steps, nested tasks + product-engineering-review)

Core outputs: `TECH_STACK.md` / `spec.md` / `solo-to-pm.md`

---

## Signature Mechanisms in Depth

These are not paper designs — they are enforced in SKILL.md Process / Quality gates / Prohibited sections, with concrete file writes and state transitions.

### LOOP engine with hard circuit breaker

```
PLAN → EXECUTE → VERIFY ── pass ──→ REVIEW ──→ done
                  │
                  └─ fail ──→ analyze ──→ RESEARCH (iteration +1)
                                       └─ iteration >= 10 → hard breaker
```

- **Evidence-driven**: no claiming completion without proof (Core Rule)
- **Checkpoint resume**: `state.yaml` persists iteration / stage / substage / last_error
- **Hard circuit breaker**: attempt 10 may complete; attempt 11 is prohibited; reset requires explicit user authorization
- **Substage enum**: `inline-passed` / `inline-failed` / `awaiting-full` / `full-running` / `full-passed` / `full-failed` — eliminates `stage: verify` ambiguity
- **Single increment rule**: iteration increments exactly once before EXECUTE begins, never during failure handling

### AC numbering with permanent retention

```
PM: AC-F01-001 (product AC)        Design: DAC-P01-001 (page AC) / DAC-GLOBAL-001
        │                                          │
        └───────────── tracked via state.yaml.ac_ids ─────────────┘
                                    │
                          solo verify: dual-source check
```

- **Permanent**: IDs are never renumbered or recycled
- **Supersede, don't delete**: changed semantics → new ID, old ID marked `[superseded]` with pointer to replacement
- **Superseded ACs do NOT appear in envelope `ac_ids`** — only their replacement does
- **Cross-package traceability**: design-to-solo's inherited AC-xxx list must be a superset of PM's AC-xxx (PM-owned ACs cannot be silently dropped during design)

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

| PM status | Design status | Solo status | Meaning |
|-----------|---------------|-------------|---------|
| `approved` | `pending` | — | PM handoff ready; Design not started |
| `approved` | `in_progress` | — | Design consuming pm-to-design.md |
| `approved` | `done` | `pending` | Design complete; Solo not started |
| `developing` | `done` | `in_progress` | Solo consuming design-to-solo.md |
| `launched` | `done` | `done` | Fully launched |

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
Orchestration Layer (future, not a current goal)
                    ↕ contract documents
Framework Layer    pm / design / solo
                    ↕ load chain
Foundation Layer   AGENTS.md · SOUL.md · constitution.md · LOOP.md · skills/
```

### Contract collaboration

Frameworks pass structured requirements via `docs/handoff/` documents. Each document has a clear **producer** and **consumer**. Write access is one-directional — consumers read only, never modify.

| Producer → Consumer | Document |
|:---:|---|
| pm → design | `pm-to-design.md` |
| pm → solo | `pm-to-solo.md` |
| design → solo | portable package with `design-to-solo.md` + `component-contract.json` |
| design → pm | `design-to-pm.md` (reverse feedback) |
| solo → pm | `solo-to-pm.md` (reverse feedback) |

Each handoff envelope carries: `schema_version` / `handoff_id` / `producer` / `consumer` / `created_at` / `source_revision` / `supersedes` / `status` / `mode` / `ac_ids` + optional `batch` + `artifacts[]`. Consumer validates SHA-256 manifest and writes a receipt.

### Three exploration modes (solo)

| Mode | Trigger | Steps | state.yaml | LOOP | verify-full | code-review |
|------|---------|:-----:|:----------:|:----:|:-----------:|:-----------:|
| `skip` | quick-fix (Risk Gate 6 items all green) | 5 | 0 fields | no | no | diff review only |
| `standard` | default | 11 | 7-9 fields | yes | yes | yes |
| `deep` | new-product-engineering / ambiguous | 20 | 10 fields | yes (nested) | yes | yes + product-engineering-review |

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

### Why independent, not unified

Context explosion and memory pollution are the core pain points of AI Agent collaboration. A single Agent loading 119 skills wastes tokens and degrades output quality. Independent frameworks let each Agent specialize.

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
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Full architecture design (v2.2.1) |
| [DOMAIN_BOUNDARIES.md](./DOMAIN_BOUNDARIES.md) | Normative ownership and routing rules |
| [HANDOFF_PROTOCOL.md](./HANDOFF_PROTOCOL.md) | Versioned contract protocol |
| [UPGRADING.md](./UPGRADING.md) | Conflict-safe framework upgrade process |
| [harness-pm/README.md](./harness-pm/README.md) | PM framework details |
| [harness-design/README.md](./harness-design/README.md) | Design framework details |
| [harness-solo/README.md](./harness-solo/README.md) | Engineering framework details |

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
