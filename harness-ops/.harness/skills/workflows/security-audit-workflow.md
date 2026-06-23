---
workflow_id: E
name: security-audit-workflow
default_mode: deep
---

# Workflow: Security Audit Workflow

> LOOP type: audit
> Trigger scenarios: Periodic security audit, pre-launch security check for new service, compliance requirements, post-security-incident review
> Orchestration Skill: security-scan → policy-as-code → audit-review → [fix suggestions]

## Flowchart

```
┌─────────────────────────────────────────────────────────┐
│ Determine audit scope (images/clusters/IaC/operation    │
│ records)                                                │
└───────────────────────────┬─────────────────────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ security-scan                    │  Image vulnerabilities + CIS baseline + config audit
          │                                   │  Generate scan report [Quality Gate]
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ policy-as-code                   │  Generate/check Kyverno policies
          │                                   │  Identify policy gaps
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ audit-review                     │  K8s audit + Git + Agent operations
          │                                   │  Identify anomalous behavior
          └─────────────────┬───────────────┘
                            ▼
          ┌─────────────────────────────────┐
          │ Generate comprehensive security  │
          │ report                           │
          │ Fix suggestions + priority       │
          │ ranking                          │
          └─────────────────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| After security-scan | No CRITICAL vulnerabilities (production) | Block deployment, rescan after fix |
| After policy-as-code | Policies cover all security standards | Supplement missing policies |
| After audit-review | No high-risk anomalous behavior | Investigate and handle |

## Usage

Tell the Agent:
- "Run security audit" → Trigger this workflow
- "Scan image vulnerabilities" → Start from security-scan
- "Check policy compliance" → Start from policy-as-code
- "Review operation records" → Start from audit-review
