# harness-ops

> Personal **Operations & Infrastructure Reliability** Framework · harness family member

## Positioning

Focused on "escorting and delivering" — Infrastructure as Code (IaC), automated deployment (CI/CD), monitoring & alerting systems, disaster recovery and incident response.

Product research / UI design / engineering development / growth operations are handled by other members of the harness family, handed off via `docs/handoff/` contract documents.

## Core Features

- **SRE Four Principles** : Stability-First / IaC / Observability / Automation
- **Loop Cycle Engine** : PLAN → PROVISION/DEPLOY → VERIFY, supports 5 cycle types (provision/incident/optimization/recovery/audit)
- **Semi-automated architecture** : Agent proposes + human approves + GitOps executes; production environment operated indirectly via PRs
- **Contract collaboration** : Receives `solo-to-ops.md` (engineering handoff), produces `ops-to-pm.md` (SLA report + incident retrospective)
- **Security red lines** : Strict secret isolation (Agent never touches plaintext), destructive change interception, environment isolation
- **Four operation primitives** : inspect (automatic) / propose (generate PR) / mutate-staging (Agent executes) / mutate-prod (human approval)

## Skill System (8 modules, 28 domain skills + 4 meta = 32)

- **Module 1 Deployment & Delivery** (4): deployment-pipeline / release-strategy / rollback / deployment-verify
- **Module 2 Infrastructure** (4): infrastructure-as-code / kubernetes-manifest / helm-management / gitops-sync
- **Module 3 Monitoring & Observability** (4): monitoring-setup / alerting-rules / log-analysis / dashboard-design
- **Module 4 Incident Response** (4): incident-detection / root-cause-analysis / incident-mitigation / post-mortem
- **Module 5 Security & Compliance** (4): secret-management / policy-as-code / security-scan / audit-review
- **Module 6 Capacity & Cost** (3): resource-right-sizing / cost-analysis / capacity-planning
- **Module 7 Disaster Recovery & Backup** (3): backup-management / recovery-drill / disaster-recovery-plan
- **Module 8 Ops Review** (2): ops-review / sla-report

## Workflows (7)

- **deployment-workflow** — Full deployment flow: solo-to-ops → IaC plan → provision → verify → ops-to-pm
- **incident-response-workflow** — Full incident flow: detect → mitigate → verify → root-cause → post-mortem
- **infrastructure-setup-workflow** — Infrastructure setup: IaC → K8s → Helm → GitOps → verify
- **monitoring-deployment-workflow** — Monitoring deployment: monitoring-setup → alerting → dashboard → verify
- **security-audit-workflow** — Security audit: scan → policy → audit-review → fix recommendations
- **disaster-recovery-workflow** — Disaster recovery drill: backup → recovery-drill → verify → report
- **ops-review-workflow** — Ops review: sla + cost → ops-review → ops-to-pm

## Quick Start

```bash
# 1. Enter the project directory
cd your-project

# 2. Install the harness-ops framework
bash /path/to/harness-ops/install.sh

# 3. Fill in OPS_STRATEGY.md as needed (infrastructure strategy)
# 4. Start using: Agent reads AGENTS.md on startup
```

## Directory Structure

```
harness-ops/
├── AGENTS.md              # Agent must-read on startup (only mandatory entry point)
├── SOUL.md                # Agent persona definition
├── constitution.md        # Project constitution
├── install.sh             # Install script
├── .harness/
│   ├── loops/LOOP.md      # Cycle engine definition (5 cycle types)
│   ├── skills/            # Skill library (8 modules, 28 domain + 4 meta = 32)
│   │   ├── meta/          # 4 meta skills
│   │   ├── deployment/    # Deployment & delivery skills (4)
│   │   ├── infrastructure/# Infrastructure skills (4)
│   │   ├── monitoring/    # Monitoring & observability skills (4)
│   │   ├── incident/      # Incident response skills (4)
│   │   ├── security/      # Security & compliance skills (4)
│   │   ├── capacity/      # Capacity & cost skills (3)
│   │   ├── recovery/      # Disaster recovery & backup skills (3)
│   │   ├── review/        # Ops review skills (2)
│   │   └── workflows/     # Workflows (7)
│   ├── rules/             # Security rules and defense
│   ├── memory/            # Cross-session memory (7 knowledge base tables)
│   └── templates/         # Project templates
└── docs/
    ├── handoff/           # Cross-framework handoff documents
    ├── infrastructure/    # Infrastructure architecture and assets
    ├── monitoring/        # Monitoring dashboards and alerting rules
    ├── incident/          # Incident investigation and ticket records
    └── deployment/        # Deployment configuration records
```

## Automation Boundaries (Core Design)

| Operation Type | staging | production |
|---------|---------|------------|
| inspect (get/describe/plan/scan) | Agent fully automatic | Agent fully automatic |
| propose (generate Manifest/PR) | Agent | Agent |
| mutate (scale/rollback/restart) | Agent executes directly | GitOps PR + human review |
| mutate high-risk (delete/RBAC) | Human approval | Human double confirmation |
| Secret value operations | ❌ Forbidden | ❌ Forbidden |

## Relationship with the harness Family

| Member | Responsibility | Handoff with ops |
|------|------|--------------|
| harness-pm | Product research / PRD | Receives ops SLA reports |
| harness-solo | Engineering development | Produces solo-to-ops.md handed to ops for deployment |
| harness-design | UI / visual design | No direct handoff |
| harness-growth | Growth operations | No direct handoff |
| **harness-ops** | **Operations & Infrastructure** | Produces ops-to-pm.md feeding back production status |

## Design Basis

See `../ARCHITECTURE.md` Section 2.1 (Framework Family Positioning) and Section 4.2 (Contract Flow Matrix) for details.
