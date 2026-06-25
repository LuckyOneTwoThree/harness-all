---
workflow_id: A
name: setup
description: "Initialize a new harness-ops project by guiding users through filling in core configuration files"
default_mode: skip
---

# Workflow: Project Onboarding

> Applicable scenario: A new project using harness-ops for the first time, needs to initialize config files
> Core mode: Guide the user in filling out constitution.md / SOUL.md / OPS_STRATEGY.md
> Note: OPS_STRATEGY.md only fills in the skeleton info known to the user at this stage; the full infrastructure setup is executed by the infrastructure-setup-workflow.

## Differences from Other Workflows

| Dimension | infrastructure-setup-workflow | **setup** |
|------|-------------|----------|
| Goal | Provision infrastructure via IaC | Initialize project config |
| Prerequisite | setup completed | **install.sh executed** (setup.md itself lives in .harness/, so reaching this workflow proves install.sh ran) |
| LOOP | provision | **No LOOP (configuration-focused)** |
| Output | Terraform/K8s manifests deployed | **Configuration files filled with skeleton** |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm first-time use
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Sanity-check config files are in place  │
│                                         │
│  - AGENTS.md / SOUL.md / constitution.md│
│    exist in project root?               │
│  - docs/infrastructure/OPS_STRATEGY.md  │
│    exists?                              │
│                                         │
│  ★ If any missing → prompt to re-run    │
│    install.sh or copy from              │
│    .harness/templates/ manually         │
└────────┬────────────────────────────────┘
         │ All present
         ▼
┌─────────────────────────────────────────┐
│ Soft-check upstream handoff (non-blocking)│
│                                         │
│  - docs/handoff/solo-to-ops.md          │
│    exists?                              │
│                                         │
│  ★ If exists → read it for tech stack / │
│    deployment requirements to prefill   │
│    architecture topology                │
│  ★ If missing → note "no upstream       │
│    handoff; user will provide info      │
│    manually" and continue (non-blocking)│
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ Fill in         │  Persona + tech preferences
│ SOUL.md         │  - IaC toolchain (Terraform / Pulumi / Ansible)
│                 │  - Container orchestration (K8s / Swarm / Nomad)
│                 │  - Monitoring stack (Prometheus / Grafana / Loki)
│                 │  - CI/CD platform (GitHub Actions / GitLab CI / ArgoCD)
│                 │  - Cloud provider (AWS / Aliyun / self-hosted)
└────────┬────────┘
         ▼
┌─────────────────┐
│ Fill in         │  Project constitution
│ constitution.md │  - Derived from ops characteristics (not copying generic rules)
│                 │  - Each clause verifiable
│                 │  - Example: no plaintext secrets in repo / destructive ops require human double-check / no production release on Friday
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Fill in OPS_STRATEGY.md (skeleton)      │
│                                         │
│  - Architecture topology & tech stack   │
│    (cloud provider / compute / data /   │
│    IaC toolchain)                       │
│  - Deployment standards                 │
│    (env separation / release strategy / │
│    change window / rollback criteria)   │
│  - Monitoring & alerting matrix         │
│    (dimension × tool × threshold ×      │
│    responder)                           │
│  - Disaster recovery plan               │
│    (backup / AZ DR / degradation)       │
│                                         │
│  ★ Only fill in skeleton info known to  │
│    user                                 │
│  ★ Full provisioning is executed by     │
│    infrastructure-setup-workflow        │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ Validate        │  - All 4 files filled in?
│ configuration   │  - Constitution clauses verifiable?
│ completeness    │  - OPS_STRATEGY rollback criteria clear?
│                 │  - Upstream handoff noted (if any)?
└────────┬────────┘
         │ Pass
         ▼
┌─────────────────┐
│ session-end     │  Record onboarding info to progress.md
│                 │  - Tech stack / architecture topology / key constitution points
│                 │  - Next step: enter infrastructure-setup-workflow for actual provisioning
└─────────────────┘
```

## Key Checkpoints

- [ ] SOUL.md's tech preferences filled? (IaC / K8s / monitoring / CI/CD / cloud provider)
- [ ] constitution.md clauses verifiable? (Not "be stable", but "no plaintext AK/SK in repo; destructive ops require human double-check")
- [ ] OPS_STRATEGY.md rollback criteria clear? (Not "rollback if problem", but "5xx error rate > 1% for 1 minute → immediate rollback")
- [ ] Upstream handoff (solo-to-ops.md) noted if present?
- [ ] All 5 files (AGENTS.md, SOUL.md, constitution.md, OPS_STRATEGY.md, progress.md) saved?

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| Config files missing (partial install) | Prompt to re-run install.sh or copy from .harness/templates/ manually |
| Constitution clauses not verifiable | Help user rewrite as verifiable descriptions |
| OPS_STRATEGY rollback criteria vague | Help user rewrite as quantified trigger conditions (metric threshold + duration) |
| No upstream handoff | Non-blocking; prompt user to provide tech stack info manually, or suggest running harness-solo first |

## Division of Labor with install.sh

| Stage | Responsibility |
|------|------|
| install.sh | Copy template files to project directory (mechanical operation) |
| **setup workflow** | Guide user to fill in template content (intelligent guidance) |

install.sh only ensures "files in place"; setup workflow ensures "content filled correctly".
