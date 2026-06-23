# Project knowledge base

> Permanent memory, accumulated across sessions. Important findings are written to this file.
> Division of labor with progress.md: progress.md is a session-level temporary log; this file is project-level long-term knowledge.
> Ops framework specific: incident conclusions must be written to this file to avoid repeat incidents.
> The knowledge base is the foundation of Loop compound learning — the conclusions of each round of deployment / incident / optimization settle here and are reused in the next round.

## 1. Incident repository

> Append one row after each incident recovery. Written by the post-mortem skill.

| Incident ID | Severity | Symptom | Root cause | Duration | Impact | Improvements | Date |
|--------|------|------|------|---------|------|--------|------|
| INC-001 | [P0/P1/P2] | [incident description] | [root cause] | [Xmin] | [business impact] | [improvement count] | YYYY-MM-DD |

## 2. Root cause library

> Root cause patterns distilled from multiple incidents. Written by root-cause-analysis / post-mortem.

| Root cause pattern | Applicable scenario | Identification features | Handling | Source |
|---------|---------|---------|---------|------|
| [pattern name] | [when it appears] | [log/metric features] | [stop-bleed + fix] | [incident ID] |

## 3. Deployment records

> Append one row per deployment. Written by deployment-pipeline.

| Deployment ID | Service | Version | Environment | Strategy | Result | Duration | Rollback | Date |
|--------|------|------|------|------|------|------|------|------|
| DEP-001 | [service name] | [v1.2.3] | [staging/prod] | [rolling/canary/blue-green] | [success/failure] | [Xmin] | [yes/no] | YYYY-MM-DD |

## 4. Monitoring assets

> Monitoring alerting / dashboard index. Written by monitoring-setup / alerting-rules / dashboard-design.

| Service | Metrics endpoint | Log label | Dashboard URL | Alert rule | Last updated |
|------|------------|---------|--------------|---------|---------|
| [service name] | [:8080/metrics] | [app=xxx] | [grafana/d/xxx] | [alert-name] | YYYY-MM-DD |

## 5. IaC assets

> Infrastructure resource index. Written by infrastructure-as-code / helm-management / gitops-sync.

| Resource ID/name | Type | Environment | Module path/Chart | Created | Last modified |
|-----------|------|------|---------------|---------|---------|
| [resource name] | [VPC/EKS/RDS/Helm] | [env] | [path] | YYYY-MM-DD | YYYY-MM-DD |

## 6. Ops patterns

> Reusable patterns distilled from multiple ops operations.

| Pattern | Applicable scenario | Example | Source |
|------|---------|------|------|
| [pattern name] | [when to use] | [data/case] | [incident ID/deployment ID] |

## 7. Pitfalls

> Failure lessons to avoid repeating pitfalls.

| Date | Problem | Solution | Related files |
|------|------|---------|---------|
| YYYY-MM-DD | [problem description] | [how it was solved] | [related file paths] |
