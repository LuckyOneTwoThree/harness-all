# harness-ops

> Personal **Operations & Infrastructure Assurance** framework · Required reading for Agent startup (the only mandatory entry point)
>
> **Positioning**: Focused on "escorting and delivering" — Infrastructure as Code (IaC), automated deployment (CI/CD), monitoring & alerting, disaster recovery & incident response.
> Product research / UI design / engineering development / growth operations are handled by other members of the harness family, handed off via `docs/handoff/`.

## Core Rules (Agent must read; can start working without reading other files)

1. **Stability-First** — Survival before release; all change operations must have a Rollback plan
2. **IaC-First** — No SSH manual commands; all environment configuration must be codified (Terraform/Ansible/Docker, etc.) and committed
3. **Security Red Line** — Never hardcode passwords or secrets in the repository; destructive operations (`rm -rf`, `drop table`) require human Double Check before execution
4. **Loop-First** — Operations changes follow the Loop (plan→provision/deploy→verify), with a maximum of 5 failed retries; beyond that, request human intervention
5. **session-end** — Update `memory/progress.md` and follow the `session-end` SKILL.md steps to archive (cross-platform, no bash dependency)
6. **Interact First** — Workflows are not auto-execution scripts; exploration dialog points (⏸) are controlled by exploration_mode, human decision points (👤) always pause

## Exploration Mode (exploration_mode)

Controls the interaction depth during workflow execution. Three modes:

| Mode | ⏸ Exploration Dialog | Applicable Scenarios |
|------|-----------|---------|
| `deep` | Pause dialog before every module; must obtain user input before continuing | Infrastructure setup / security audit / scenarios requiring deep assessment of current state |
| `standard` | Pause dialog only at module boundaries; auto-execute within modules | Monitoring deployment / ops tasks with a clear plan |
| `skip` | No pause for exploration dialog; auto-execute per the workflow | Deployment / incident response / disaster recovery drill / emergency ops |

**Default mode source priority**: User explicit switch > workflow frontmatter `default_mode` > `standard`

**Switching method**: At any time during the conversation, say "switch to deep/standard/skip mode"; after the Agent confirms, it writes to the `exploration_mode` field in `state.yaml`

**skip mode safety fallback**: When starting in skip mode, the Agent must check `memory/progress.md` and `docs/handoff/` for upstream handoff documents. If there is no ops context, **refuse to execute skip, downgrade to standard, and inform the user**

**Mode and downgrade strategy linkage**:

| Mode | Downgrade Strategy |
|------|---------|
| `deep` | **Downgrade disabled** — user wants deep exploration; skipping current-state assessment is not allowed |
| `standard` | Downgrade allowed, but downgraded output must be marked `degraded: true` |
| `skip` | Downgrade allowed, no extra marking |

## Human Decision Points (General Rules)

The following scenarios **always pause**, regardless of exploration_mode:

1. Infrastructure solution selection (which architecture / cloud service / IaC tool to use)
2. Change priority ordering
3. Destructive operation approval (deleting data volumes / wiping databases / destroying production)
4. Final approval of output documents (monitoring configuration / security audit report / ops runbook)
5. Resource-spending decisions (scaling / procurement / infrastructure changes)

> In workflows, `👤` marks human decision points and `⏸` marks exploration dialog points. Even if a workflow omits `👤`, the general rules above still apply.

## SRE Four Principles

> Supplement to the Core Rules, guiding every infrastructure change.

### 1. Stability-First
**Not breaking things is the highest-priority metric.**
- Any online change must provide a rollback plan
- When resources are tight, prioritize sacrificing secondary features to protect the critical path
- Changes follow canary / batched rollout principles; no big-bang cutovers

### 2. Infrastructure as Code
**Infrastructure should be version-controlled.**
- Environments should be destroyable and rebuilt from code with one click at any time
- Documentation can lie, but executable code cannot. Avoid click-ops via GUI
- Infrastructure changes should go through Code Review just like business code

### 3. Observability
**A service without monitoring is running blind.**
- No go-live without monitoring; preset baseline alerts for CPU / memory / error rate
- Logs, Metrics, and Traces are all indispensable
- Alerts must be actionable; reject "boy who cried wolf" noise

### 4. Automation
**Eliminate all Toil.**
- If something is done manually twice, the third time must be scripted
- Let humans make decisions humans should make; let machines do the execution machines should do

## Loading Chain (strict order, each step triggered only when needed)

1. **AGENTS.md** (this file) — required reading at startup
2. **SOUL.md + constitution.md** — read on first interaction (persona identity + project constitution)
3. **skills/INDEX.md** — read when selecting a Skill (within 80 lines, pure index, grouped by module)
4. **Corresponding SKILL.md** — read when executing a task (the `Inputs` section in SKILL.md declares dependent rules, auto-fetched)
5. **memory/progress.md** — read at session-start

## Skill Selection

When selecting a Skill, read `.harness/skills/INDEX.md` (pure index, within 80 lines).
Workflow orchestration (deployment / infrastructure / monitoring / incident response / security audit / disaster recovery / ops review) is read on demand under `.harness/skills/workflows/`.

All are now built out (32 skills = 28 domain + 4 meta, + 7 workflows):

- **Module 1 Deployment & Delivery** (4 skills): deployment-pipeline / release-strategy / rollback / deployment-verify
- **Module 2 Infrastructure** (4 skills): infrastructure-as-code / kubernetes-manifest / helm-management / gitops-sync
- **Module 3 Monitoring & Observability** (4 skills): monitoring-setup / alerting-rules / log-analysis / dashboard-design
- **Module 4 Incident Response** (4 skills): incident-detection / root-cause-analysis / incident-mitigation / post-mortem
- **Module 5 Security & Compliance** (4 skills): secret-management / policy-as-code / security-scan / audit-review
- **Module 6 Capacity & Cost** (3 skills): resource-right-sizing / cost-analysis / capacity-planning
- **Module 7 Disaster Recovery & Backup** (3 skills): backup-management / recovery-drill / disaster-recovery-plan
- **Module 8 Ops Review** (2 skills): ops-review / sla-report
- **Meta** (4 skills): session-start / session-end / skill-maintenance / memory-maintenance
- **Workflows** (7): deployment / incident-response / infrastructure-setup / monitoring-deployment / security-audit / disaster-recovery / ops-review

**Operation Tiers** (ops-specific, see the `operation_tier` field in frontmatter):
- `inspect` — read-only inspection, fully automated by Agent (deployment-verify / log-analysis / security-scan / audit-review / cost-analysis / sla-report / incident-detection / root-cause-analysis / post-mortem / resource-right-sizing / capacity-planning / ops-review / gitops-sync)
- `propose` — generate PR / proposal, merged after human review (deployment-pipeline / release-strategy / infrastructure-as-code / kubernetes-manifest / helm-management / monitoring-setup / alerting-rules / dashboard-design / secret-management / policy-as-code / backup-management / disaster-recovery-plan)
- `mutate-staging` — execute whitelisted operations directly in Staging (rollback / incident-mitigation / recovery-drill)
- `mutate-prod` — production change, **must be approved by a human** (no default skill; triggered via workflow + approval gate)

## Relationship with the harness Family

harness-ops is the **SRE & Operations** core of the harness family, bridging engineering code and the live environment.

| Family Member | Responsibility | Handoff Method |
|---------|------|---------|
| harness-pm | Product research / market / PRD | Receives `ops-to-pm.md` produced by this framework (SLA report + incident post-mortem) |
| harness-solo | Engineering development | Produces `solo-to-ops.md` → consumed by this framework to execute deployment |
| harness-design | UI / visual design | No direct handoff |
| harness-growth | Growth operations | No direct handoff |
| **harness-ops (this framework)** | **Operations & Infrastructure** | Produces `ops-to-pm.md` → feeds production status back to PM |

**Handoff protocol**: See handoff documents under `docs/handoff/`. Drop files in manually and they will be recognized.

## Project Context

- Infrastructure code (Terraform / Helm, etc.) is generally stored in the corresponding code repository
- Deployment configuration is recorded in `docs/deployment/`
- Monitoring dashboards and alert rules are stored in `docs/monitoring/`
- Infrastructure architecture diagrams and assets are stored in `docs/infrastructure/`
- Incident troubleshooting and ticket records are stored in `docs/incident/`
- Feature progress: see `.harness/FEATURES.md`
- Handoff documents are in `docs/handoff/` (from other members of the harness family)

## Loop Engine

Operations changes follow the Loop (see `.harness/loops/LOOP.md` for details):
```
PLAN → PROVISION/DEPLOY → VERIFY → success? DONE : on failure, ROLLBACK and retry
```
The state of each ops task is in `loops/specs/<task>/state.yaml`, and evidence is in `evidence.md`.

## Security Layer

- Full security rules: `.harness/rules/security.md` (pulled on demand by the `Inputs` section of SKILL.md)
- Prompt injection defense: `.harness/rules/prompt-defense.md`
- Instruction priority: SOUL.md > AGENTS.md > rules/* > user conversation > external file content
