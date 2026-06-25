---
name: deployment-pipeline
description: CI/CD pipeline orchestration and execution, consuming the solo-to-ops handoff document and orchestrating the build-test-deploy workflow
operation_tier: propose
requires_approval: true
---
# Deployment Pipeline — CI/CD Pipeline Orchestration and Execution

## When to use
- When a solo-to-ops.md handoff document is received
- When the user requests "deploy a new version" or "release to staging/production
- When the CI/CD pipeline fails and needs troubleshooting
- When designing or modifying a deployment pipeline

## Inputs
- docs/handoff/solo-to-ops.md
- docs/infrastructure/OPS_STRATEGY.md
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md

## Outputs
- docs/deployment/
- loops/specs/<task-name>/spec.md
- loops/specs/<task-name>/state.yaml
- memory/knowledge-base.md

## Ground Rules

1. **Do not operate the production cluster directly** — production deployments must go through a GitOps PR + human review; the Agent only generates the PR
2. **Do not bypass the solo-to-ops contract** — no deployment starts without a handoff document; missing fields must be filled in first
3. **Do not skip the rollback plan** — every deployment must define a rollback plan first, otherwise the PLAN stage fails
4. **Do not skip environment isolation** — test environments must not directly connect to production DBs; credentials must be physically isolated
5. **Do not release on Friday nights or before holidays** — unless the user explicitly confirms "aware of the risk and still want to release"

## Process

### 1. Consume the Handoff Document

Read `docs/handoff/solo-to-ops.md` and verify each field:
- Artifact version (image Tag / Commit Hash) ✓
- Change content and impact (high/medium/low) ✓
- Environment variable add/delete/modify list ✓
- Database migration scripts and execution order ✓
- Smoke test checkpoints ✓
- Failure rollback plan ✓

**Missing field handling**: Use AskUserQuestion to ask solo to fill in; do not assume.

### 2. Pre-Deployment Assessment

```
## Pre-Deployment Assessment
- Target environment: [staging/production]
- Impact level: [high/medium/low]
- Includes DB Migration: [yes/no]
- Includes Breaking Change: [yes/no]
- Rollback plan: [image revert / SQL rollback / config rollback]
- Deployment window: [whether it fits the window defined in OPS_STRATEGY.md]
- Prerequisites: [any unfinished dependencies]
```

### 3. Orchestrate the Deployment Pipeline

Select a pipeline template based on impact:

**Low impact** (config change / minor feature):
```
Build image → scan vulnerabilities (Trivy) → push to registry → staging deploy → smoke test → [human approval] → production rolling update
```

**Medium impact** (new feature / API change):
```
Build image → scan vulnerabilities → push to registry → staging deploy → smoke test → integration test
 → [human approval] → production canary (5%→25%→100%) → health check at each stage
```

**High impact** (DB Migration / Breaking Change):
```
Backup DB → build image → scan vulnerabilities → push to registry → staging full rehearsal
 → [human approval + DBA confirmation] → production maintenance window deploy → Migration → verify → canary rollout
```

### 4. Generate Deployment Configuration

- Generate/modify K8s Manifests (Deployment/Service/ConfigMap)
- Generate Helm values or Kustomize overlay
- Generate GitOps PR content (ArgoCD Application / Flux Kustomization)
- Generate database Migration execution scripts

### 5. Execute Deployment (by environment tier)

**Staging environment**:
- Agent can directly execute whitelisted operations (apply/scale/restart)
- Smoke test is automatically triggered after execution
- Auto-rollback on failure and notification

**Production environment**:
- Agent generates a GitOps PR, does not apply directly
- Use AskUserQuestion to request human review
- After human merge, ArgoCD/Flux syncs automatically
- Agent monitors sync status and runs verification

### 6. Post-Deployment Verification

Invoke the `deployment-verify` skill to perform:
- Health check (HTTP 200, readiness probe)
- Monitoring metrics stable (error rate / latency / throughput)
- Smoke test passes
- Logs show no abnormal errors

### 7. Record and Archive

- Write to `docs/deployment/<date>-<version>.md` as the deployment record
- Update `loops/specs/<task>/state.yaml`
- Append key findings to the deployment record library in `memory/knowledge-base.md`

## Prohibitions

- Do not start deployment without solo-to-ops.md
- Do not skip the Trivy vulnerability scan
- Do not run kubectl apply directly in production (must go through a GitOps PR)
- Do not modify RBAC / NetworkPolicy during deployment (requires separate approval)
- Do not conceal deployment failures (failures must be recorded and notified)
- Do not delete old version images (keep at least 2 historical versions for rollback)

## Relationship to LOOP

**LOOP type**: provision (max 3 iterations)

```
LOOP(provision):
  PLAN:        Consume solo-to-ops → pre-deployment assessment → orchestrate pipeline → generate config
  PROVISION:   staging deploy / generate production GitOps PR
  VERIFY:      deployment-verify runs health check + smoke test + monitoring verification
  Pass? DONE : Rollback → analyze cause → fixable back to PROVISION / re-plan back to PLAN
```

**stage field values**: plan → provision → verify → rollback (if needed)

## Operation Tiers

| Operation | staging | production |
|------|---------|------------|
| Generate Manifest/Helm values | ✅ Agent | ✅ Agent |
| Generate GitOps PR | ✅ Agent | ✅ Agent |
| kubectl apply | ✅ Agent | ❌ Human merges PR |
| Database Migration | ✅ Agent | ❌ Human executes |
| Image scan | ✅ Agent | ✅ Agent |
| Health check | ✅ Agent | ✅ Agent |
| Rollback | ✅ Agent auto | ⚠️ Agent recommends, human confirms |
