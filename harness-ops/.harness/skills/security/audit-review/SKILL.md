---
name: audit-review
description: Audit log analysis, K8s audit log / Git history / operation record review to identify anomalous behavior
operation_tier: inspect
requires_approval: false
---
# Audit Review — Audit Log Analysis

## When to use
- During periodic security audits
- When a security incident is suspected
- During compliance checks
- When the user requests "review operation records
- When security-audit-workflow triggers

## Inputs
- docs/infrastructure/OPS_STRATEGY.md
- rules/security.md
- loops/LOOP.md
- memory/knowledge-base.md

## Outputs
- loops/specs/<task-name>/evidence.md
- memory/knowledge-base.md

## Ground Rules

1. **Auditing is read-only** — do not modify any logs; only analyze
2. **Every anomaly must have a conclusion** — either confirmed normal or flagged as a risk
3. **Auditing covers the full chain** — K8s audit + Git history + Agent operation records
4. **Do not leak audit content** — audit reports may contain sensitive information; archive after redaction

## Process

### 1. K8s Audit Log Analysis

#### Enable K8s Audit (if not enabled)
```yaml
# kube-apiserver config
--audit-policy-file=/etc/kubernetes/audit-policy.yaml
--audit-log-path=/var/log/kubernetes/audit.log
--audit-log-maxage=30
--audit-log-maxbackup=10
--audit-log-maxsize=100
```

#### Audit Policy
```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
# Log all Secret operations
- level: RequestResponse
  resources:
  - group: ""
    resources: ["secrets"]

# Log all write operations
- level: Request
  verbs: ["create", "update", "patch", "delete"]

# Log authentication failures
- level: Metadata
  verbs: ["get", "list", "watch"]
  omitStages: ["RequestReceived"]
```

#### Analyze Audit Log
```bash
# View recent write operations
kubectl get events -n production --sort-by='.lastTimestamp'

# View Secret access records
grep "secrets" /var/log/kubernetes/audit.log | jq '. | select(.verb=="get")'

# View delete operations
grep '"delete"' /var/log/kubernetes/audit.log | jq '. | {user, resource, namespace, name}'

# View authentication failures
grep '"401"' /var/log/kubernetes/audit.log | jq '. | {user, ip, time}'
```

#### Identify Anomalous Patterns
```
## K8s Audit Anomaly Detection

### 1. Abnormal Secret Access
- User: john.doe
- Operation: get secret db-credentials
- Frequency: 50 times within 1 hour
- Risk: possible credential exfiltration
- Recommendation: investigate user behavior

### 2. Off-Hours Deletion
- Time: 2026-06-22 03:00 AM
- Operation: delete deployment payment-service
- User: unknown-service-account
- Risk: possible misuse or attack
- Recommendation: investigate immediately

### 3. Privilege Escalation
- User: dev-user
- Operation: create clusterrolebinding
- Risk: privilege escalation
- Recommendation: review whether this was authorized
```

### 2. Git History Analysis

```bash
# View recent commits
git log --oneline --since="7 days ago"

# View sensitive file changes
git log --all --pretty=format:"%h %an %ad %s" -- docs/infrastructure/

# View Secret-related commits
git log -p --all -S "password" -- '*.yaml'
git log -p --all -S "api_key" -- '*.yaml'

# View force pushes
git reflog --all | grep "forced update"
```

#### Identify Anomalies
```
## Git History Anomaly Detection

### 1. Sensitive File Modification
- File: infrastructure/terraform.tfvars
- Modifier: dev-user
- Time: 2026-06-22
- Risk: may contain credential changes
- Recommendation: review the change content

### 2. Unusual Commit Time
- Committer: contractor
- Time: weekend early morning
- Risk: possible unauthorized operation
- Recommendation: confirm whether authorized

### 3. Secret Found in History
- File: config.yaml
- Commit: abc123
- Content: contains plaintext password
- Risk: Secret leaked into Git history
- Recommendation: rotate the Secret immediately + clean history
```

### 3. Agent Operation Record Analysis

Read `loops/specs/*/iterations.log`:
- What operations the Agent executed
- Whether any operations failed
- Whether any operations entered needs-human state
- Whether any iterations had abnormal counts

```
## Agent Operation Audit

### Statistics
- Agent operations this week: 45
- Successful: 40
- Failed: 3
- Required human intervention: 2

### Anomalous Operations
1. INC-2026-06-20: 5 iterations without resolution (exceeded limit)
   - Cause: insufficient root cause analysis
   - Recommendation: escalate to a human SRE

2. DEP-2026-06-21: production deployment rejected by human
   - Cause: plan summary indicated resource destruction
   - Recommendation: review the IaC code
```

### 4. Generate the Audit Report

```
## Security Audit Report

### Audit Scope
- Time: 2026-06-15 ~ 2026-06-22
- K8s Audit Log: production cluster
- Git History: gitops-repo + infrastructure-repo
- Agent operations: all loops/specs/

### Findings Summary
| Category | High Risk | Medium Risk | Low Risk | Resolved |
|------|--------|--------|--------|--------|
| K8s Audit | 2 | 5 | 8 | 3 |
| Git History | 1 | 3 | 5 | 2 |
| Agent Operations | 0 | 2 | 4 | 1 |

### High-Risk Items (must be handled)
1. [K8s] Abnormal Secret access (john.doe 50 times/hour)
2. [K8s] Off-hours deletion (unknown SA)
3. [Git] Plaintext password found in history

### Recommended Improvements
1. Tighten RBAC policies
2. Enable Secret access alerts
3. Configure Git push signature verification
4. Add rate limits for Agent operations
```

### 5. Update the Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Audit Date | Scope | High Risk | Medium Risk | Status | Report Path |
|---------|------|--------|--------|---------|---------|
| 2026-06-22 | Full chain | 3 | 10 | In progress | docs/security/audit-2026-06-22.md |
```

## Prohibitions

- Do not modify any audit logs (read-only analysis)
- Do not expose user PII in the report (redact)
- Do not skip reporting high-risk items
- Do not handle high-risk items alone (requires human confirmation)

## Relationship to LOOP

**LOOP type**: audit

```
LOOP(audit):
  PLAN:       Define the audit scope
  PROVISION:  Collect logs (K8s/Git/Agent)
  VERIFY:     Analyze anomalies + generate report
  Pass? DONE : Handle risk items → re-verify
```
