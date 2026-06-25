---
name: infrastructure-as-code
description: Terraform/Ansible IaC management, generating / planning / applying infrastructure code; plan can be auto-run, apply requires human confirmation
operation_tier: propose
requires_approval: true
---
# Infrastructure as Code — Terraform/Ansible IaC Management

## When to use
- When cloud resources need to be created/modified
- When terraform plan/apply needs to be executed
- During infrastructure drift detection
- When the user requests "configure a new environment
- When infrastructure-setup-workflow triggers

## Inputs
- docs/infrastructure/OPS_STRATEGY.md
- docs/infrastructure/
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md

## Outputs
- docs/infrastructure/
- loops/specs/<task-name>/spec.md
- loops/specs/<task-name>/state.yaml
- loops/specs/<task-name>/evidence.md
- memory/knowledge-base.md

## Ground Rules

1. **IaC must come first** — reject ClickOps; all resources must be declared via code
2. **plan can be automatic, apply requires confirmation** — production apply must be approved by humans
3. **state files are core assets** — remote backend + encryption + version control
4. **Do not hardcode credentials** — inject variables via tfvars/env, no plaintext
5. **destroy is high-risk** — requires human double confirmation + resource whitelist

## Process

### 1. Assess IaC Requirements

Read `OPS_STRATEGY.md` to understand the architecture topology and selections:
- Cloud provider: AWS / GCP / Azure / Alibaba Cloud / Tencent Cloud
- IaC tool: Terraform / Pulumi / Crossplane
- Configuration management: Ansible / SaltStack

Determine the scope of this task:
- Create resources / modify existing resources / destroy resources
- Affected environment: dev / staging / production

### 2. Generate/Modify IaC Code

#### Terraform Structure
```
infrastructure/
├── modules/                    # reusable modules
│   ├── vpc/
│   ├── eks/
│   ├── rds/
│   └── alb/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars    # no sensitive info
│   ├── staging/
│   └── production/
└── shared/
    └── remote_state.tf         # S3 backend config
```

#### Generation Principles
- Modular: split resources by responsibility into modules; do not write giant monoliths
- Version pinning: explicitly specify provider versions (`version = "~> 4.0"`)
- Tagging standards: tag all resources with `Environment` / `Project` / `ManagedBy`
- Least privilege: IAM policies follow the principle of least privilege
- Encryption by default: storage/transit encrypted by default

### 3. Execute terraform plan (Agent can auto-run)

```bash
# Initialize
terraform init -backend-config=backend.hcl

# Format and validate
terraform fmt -check -diff
terraform validate

# Plan (dry-run)
terraform plan -out=tfplan -input=false
```

**Agent parses plan output**:
- Identify resources to create/modify/destroy
- Assess impact
- Generate a plan summary for human review

```
## Terraform Plan Summary
- Create: 3 resources (VPC, Subnet, IGW)
- Modify: 1 resource (EKS cluster adds a node group)
- Destroy: 0 resources
- Impact: medium (new resources, does not affect existing)
- Estimated duration: 8 minutes
- Risk assessment: low
```

### 4. Execute terraform apply (production requires human confirmation)

**Staging environment**:
- Agent can directly execute `terraform apply -auto-approve`
- Verify resource creation succeeded after execution

**Production environment**:
- Agent shows the plan summary
- Use AskUserQuestion to request human confirmation
- After human confirmation, execute `terraform apply`
- Verify after execution

**Prohibited operations**:
- `terraform destroy` (requires human double confirmation in any environment)
- `terraform force-unlock` (requires human confirmation)
- Modifying state files (requires human confirmation)

### 5. Ansible Configuration Management (if needed)

```yaml
# inventory.yml
all:
  hosts:
    prod-web-01:
      ansible_host: 10.0.1.10
  children:
    webservers:
      hosts:
        prod-web-01:
        prod-web-02:
    dbservers:
      hosts:
        prod-db-01:
```

```yaml
# playbook.yml
- name: Configure web servers
  hosts: webservers
  become: yes
  roles:
    - nginx
    - app-config
  vars:
    env: production
```

**Execution**:
- `ansible-playbook -i inventory.yml playbook.yml --check` (dry-run)
- `ansible-playbook -i inventory.yml playbook.yml` (actual execution)

### 6. Drift Detection

Run periodically:
```bash
terraform plan -detailed-exitcode
# exit code 0: no drift
# exit code 2: drift exists (needs handling)
```

When drift is found:
- Analyze the cause (manual change / external system change)
- Decide: pull back to IaC / update IaC to match reality
- Record to the knowledge base

### 7. Update IaC Asset Library

Append to the IaC asset library in `memory/knowledge-base.md`:
```
| Resource ID | Type | Environment | Module Path | Created | Last Modified |
|--------|------|------|---------|---------|---------|
| vpc-xxx | AWS VPC | production | environments/prod/main.tf | 2026-06-22 | 2026-06-22 |
```

## Prohibitions

- Do not hardcode AK/SK/passwords in .tf files
- Do not run terraform destroy in production (unless human double confirmation)
- Do not use local state (must use remote backend)
- Do not skip terraform plan and apply directly
- Do not modify files under the .terraform/ directory
- Do not apply without understanding the impact

## Relationship to LOOP

**LOOP type**: provision

```
LOOP(provision):
  PLAN:       Assess requirements → generate/modify IaC code
  PROVISION:  terraform plan → [human confirmation] → terraform apply
  VERIFY:     verify resource creation succeeded + tags correct + encryption effective
  Pass? DONE : analyze cause → fix IaC → back to PROVISION
```

## Operation Tiers

| Operation | staging | production |
|------|---------|------------|
| terraform fmt/validate | Agent | Agent |
| terraform plan | Agent | Agent |
| terraform apply | Agent | After human confirmation |
| terraform destroy | Human confirmation | Human double confirmation |
| ansible --check | Agent | Agent |
| ansible-playbook | Agent | After human confirmation |
