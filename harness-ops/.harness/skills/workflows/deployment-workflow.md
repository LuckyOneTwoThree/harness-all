---
workflow_id: B
name: deployment-workflow
default_mode: skip
---

# Workflow: Deployment Workflow

> LOOP type: provision
> Trigger scenarios: Received solo-to-ops.md handoff document, user requests new version deployment, CI/CD pipeline trigger
> Orchestration Skill: deployment-pipeline → release-strategy → [staging deployment] → deployment-verify → [GitOps PR] → [human approval] → [production deployment] → deployment-verify → [produce ops-to-pm.md]

## Flowchart

```
┌─────────────────────────────────────────────────────────┐
│ Consume solo-to-ops.md (prerequisite hard gate,         │
│ do not start if fields missing)                         │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-pipeline              │  Assess impact + orchestrate pipeline
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ release-strategy                 │  Select release strategy (rolling/canary/blue-green)
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ [staging deployment]             │  Agent can execute directly
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify [Quality Gate 1]│  staging health check + smoke test
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ staging validation │
                  │ passed?            │
                  └─────────┬─────────┘
                    ↓ Yes   │    ↓ No
                            │    Rollback → analyze cause → back to deployment
                            ▼
          ┌─────────────────────────────────┐
          │ Generate GitOps PR (production)  │  Agent generates, does not apply directly
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ [Human approval gate]            │  AskUserQuestion requests confirmation
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ Human approved?    │
                  └─────────┬─────────┘
                    ↓ Yes   │    ↓ No
                            │    Terminate deployment, record reason
                            ▼
          ┌─────────────────────────────────┐
          │ [production deployment]          │  GitOps sync (ArgoCD/Flux)
          │ Canary: 5%→25%→100%              │  deployment-verify at each stage
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify [Quality Gate 2]│  production health check + monitoring validation
          └─────────────────┬───────────────┘
                            │
                  ┌─────────┴─────────┐
                  │ production         │
                  │ validation passed? │
                  └─────────┬─────────┘
                    ↓ Yes   │    ↓ No
                            │    rollback → notify human → exit
                            ▼
          ┌─────────────────────────────────┐
          │ Archive: deployment records +    │
          │ knowledge base                   │
          │ Produce ops-to-pm.md (if needed) │
          └─────────────────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| Prerequisite hard gate | solo-to-ops.md fields complete (6 required fields) | Require solo to complete, do not start deployment |
| staging validation | Health check + smoke test + monitoring stable | Auto-rollback staging, analyze cause |
| Human approval gate | Human reviews GitOps PR | Reject then terminate, record reason |
| Each canary stage | Error rate <1% + normal latency + stable business metrics | Auto-rollback to previous stage |
| production validation | All four checks pass (health + smoke + monitoring + logs) | Trigger rollback, notify human |

## Data Flow

| Stage | Output | Storage Location |
|------|------|---------|
| Consume handoff | Handoff document parse result | progress.md |
| deployment-pipeline | Deployment plan + pipeline config | spec.md + docs/deployment/ |
| release-strategy | Release strategy plan | spec.md |
| staging deployment | K8s Manifest / Helm values | docs/deployment/ |
| staging validation | Validation report | evidence.md |
| GitOps PR | PR content + diff | Git repo |
| production deployment | Deployment record | iterations.log |
| production validation | Final validation report | evidence.md |
| Archive | Deployment records + ops-to-pm.md | docs/deployment/ + docs/handoff/ + knowledge-base.md |

## Interaction with LOOP

```
LOOP(provision):
  PLAN:       deployment-pipeline → release-strategy → generate config
  PROVISION:  staging deployment → [GitOps PR] → [human approval] → production deployment
  VERIFY:     deployment-verify (staging + production each stage)
  Pass? DONE : rollback → analyze cause → fixable back to PROVISION / needs replanning back to PLAN
```

## Execution by Environment

| Operation | staging | production |
|------|---------|------------|
| Generate config | Agent | Agent |
| kubectl apply | Agent | ❌ GitOps PR |
| Health check | Agent | Agent |
| Rollback | Agent auto | Agent suggests + human confirms |
| Database Migration | Agent | Human executes |

## Usage

Tell the Agent:
- "solo delivered a new version, start deployment" → Trigger this workflow
- "Deploy v1.2.3 to staging" → Start from deployment-pipeline
- "staging validation passed, promote to production" → Start from GitOps PR
- "Deployment failed, rollback" → Trigger rollback skill
