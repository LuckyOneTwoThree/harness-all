---
workflow_id: A
name: infrastructure-setup-workflow
description: "Set up infrastructure through IaC generation, Kubernetes manifests, GitOps sync, and deployment verification"
default_mode: deep
---

# Workflow: Infrastructure Setup Workflow

> LOOP type: provision
> Trigger scenarios: New environment setup, infrastructure scaling, new service launch requiring resource configuration
> Orchestration Skill: infrastructure-as-code → kubernetes-manifest → helm-management → gitops-sync → deployment-verify

## Flowchart

```
┌─────────────────────────────────────────────────────────┐
│ Assess infrastructure requirements (read OPS_STRATEGY.md)│
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ infrastructure-as-code            │  Generate Terraform/Ansible
          │                                   │  terraform plan [Quality Gate]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ [Human approval]                  │  production apply requires confirmation
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ terraform apply                   │  Create cloud resources
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ kubernetes-manifest               │  Generate K8s deployment config
          │ or helm-management                │  or Helm values
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ gitops-sync                       │  Submit GitOps PR
          │                                   │  [Human review + merge]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ deployment-verify                 │  Verify resource creation + config correct
          └─────────────────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| After terraform plan | Resource changes as expected + no unexpected destruction | Fix IaC code |
| After K8s Manifest generation | Best practice checks pass | Fix Manifest |
| Before apply (production) | Human confirms plan summary | Reject then terminate |
| Post-deployment validation | Resources Running + health check pass | Troubleshoot and fix |

## Usage

Tell the Agent:
- "Set up new staging environment" → Trigger this workflow
- "Configure infrastructure for new service" → Start from infrastructure-as-code
- "Scale EKS node group" → Start from infrastructure-as-code
