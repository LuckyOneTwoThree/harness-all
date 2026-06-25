# Skills Index — harness-ops

> Pure index, under 80 lines. Read this file when selecting a Skill, then read the corresponding SKILL.md.
> For workflow orchestration, see `workflows/`.

## Meta Skills (4, ✅ built)

- **session-start** — Session startup, loads context and restores working state
- **session-end** — Session wrap-up, archive + produce ops-to-pm.md
- **skill-maintenance** — Skill health check
- **memory-maintenance** — Memory retention cleanup

## Module 1 Deployment & Delivery (4, ✅ built)

- **deployment-pipeline** — CI/CD pipeline orchestration and execution
- **release-strategy** — Release strategy selection (blue-green / canary / rolling)
- **rollback** — Rollback operations and verification
- **deployment-verify** — Deployment verification and health check

## Module 2 Infrastructure (4, ✅ built)

- **infrastructure-as-code** — Terraform/Ansible IaC management
- **kubernetes-manifest** — K8s YAML generation and maintenance
- **helm-management** — Helm chart management and maintenance
- **gitops-sync** — ArgoCD/Flux GitOps sync management

## Module 3 Monitoring & Observability (4, ✅ built)

- **monitoring-setup** — Prometheus/Grafana monitoring stack deployment
- **alerting-rules** — Alert rule generation and tuning
- **log-analysis** — Log query and analysis (LogQL/ES DSL)
- **dashboard-design** — Grafana Dashboard generation

## Module 4 Incident Response (4, ✅ built)

- **incident-detection** — Incident detection and classification
- **root-cause-analysis** — Root cause analysis (multi-source data correlation)
- **incident-mitigation** — Incident mitigation (whitelisted operations)
- **post-mortem** — Post-mortem report

## Module 5 Security & Compliance (4, ✅ built)

- **secret-management** — Secret reference management (no contact with plaintext)
- **policy-as-code** — Kyverno policy generation
- **security-scan** — Trivy/kube-bench security scanning
- **audit-review** — Audit log analysis

## Module 6 Capacity & Cost (3, ✅ built)

- **resource-right-sizing** — Resource right-sizing recommendations
- **cost-analysis** — Cloud cost analysis and optimization
- **capacity-planning** — Capacity planning recommendations

## Module 7 Disaster Recovery & Backup (3, ✅ built)

- **backup-management** — Velero backup management
- **recovery-drill** — Recovery drill
- **disaster-recovery-plan** — Disaster recovery plan design

## Module 8 Ops Review (2, ✅ built)

- **ops-review** — Ops review report + produce ops-to-pm.md
- **sla-report** — SLA calculation and reporting

## Workflows (8, ✅ all built)

> `default_mode`: deep = forced exploration / standard = pause at module boundaries / skip = direct execution (user can switch at any time)

- **setup** — Project onboarding (config files skeleton) [skip]
- **deployment-workflow** — Full deployment workflow [skip]
- **incident-response-workflow** — Full incident response workflow [skip]
- **infrastructure-setup-workflow** — Infrastructure setup [deep]
- **monitoring-deployment-workflow** — Monitoring stack deployment [standard]
- **security-audit-workflow** — Security audit [deep]
- **disaster-recovery-workflow** — Disaster recovery drill [skip]
- **ops-review-workflow** — Ops review [skip]
