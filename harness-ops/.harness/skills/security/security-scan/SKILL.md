---
name: security-scan
description: Trivy/kube-bench security scanning, image vulnerabilities/CIS benchmark/config audit, generating remediation recommendations
triggers:
  - When scanning images for vulnerabilities after build
  - During periodic security audits
  - During pre-deployment security checks
  - When a new CVE is discovered and impact assessment is required
  - When security-audit-workflow triggers
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<task-name>/evidence.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
operation_tier: inspect
requires_approval: false
---

# Security Scan — Security Scanning and Remediation Recommendations

## Ground Rules

1. **Scanning does not block deployment** — scans are advisory, not hard gates (unless CRITICAL vulnerabilities)
2. **Remediation has priorities** — CRITICAL > HIGH > MEDIUM > LOW
3. **No remediation, no report** — scan results must come with remediation recommendations
4. **Periodic scanning** — not one-time, but a continuous process

## Process

### 1. Image Vulnerability Scanning (Trivy)

```bash
# Scan an image
trivy image registry.example.com/payment-service:v1.2.3

# JSON output (easier for the Agent to parse)
trivy image -f json -o scan-result.json registry.example.com/payment-service:v1.2.3

# Scan only HIGH and CRITICAL
trivy image --severity HIGH,CRITICAL registry.example.com/payment-service:v1.2.3
```

#### Parse Scan Results
```json
{
  "Results": [
    {
      "Target": "payment-service:v1.2.3 (alpine 3.18)",
      "Vulnerabilities": [
        {
          "VulnerabilityID": "CVE-2026-1234",
          "PkgName": "openssl",
          "InstalledVersion": "3.1.0",
          "FixedVersion": "3.1.1",
          "Severity": "CRITICAL",
          "Title": "OpenSSL buffer overflow",
          "Description": "..."
        }
      ]
    }
  ]
}
```

#### Generate Remediation Recommendations
```
## Image Scan Report

### Image: payment-service:v1.2.3
### Scan Time: 2026-06-22T14:30:00
### Vulnerability Counts: CRITICAL: 2, HIGH: 5, MEDIUM: 12, LOW: 8

### CRITICAL Vulnerabilities (must fix)
| CVE | Package | Current Version | Fixed Version | Recommendation |
|-----|-----|---------|---------|------|
| CVE-2026-1234 | openssl | 3.1.0 | 3.1.1 | Upgrade base image |
| CVE-2026-5678 | libxml2 | 2.10.0 | 2.10.4 | Upgrade base image |

### Remediation Plan
1. Update the Dockerfile base image: alpine:3.18 → alpine:3.19
2. Rebuild the image and re-scan to verify
3. Deploy only after CRITICAL vulnerabilities are fixed
```

### 2. CIS Benchmark Check (kube-bench)

```bash
# Run the CIS benchmark check
kube-bench --benchmark cis-1.8

# JSON output
kube-bench --json > cis-report.json
```

#### Parse Check Results
```
## CIS Benchmark Report

### Check Statistics: PASS: 45, WARN: 8, FAIL: 3

### FAIL Items (must fix)
| ID | Check Item | Status | Remediation |
|------|--------|------|---------|
| 4.2.6 | --protect-kernel-defaults not set | FAIL | Add this parameter to kubelet config |
| 4.2.9 | --event-qps not set | FAIL | Set to 0 |
| 5.1.5 | RBAC not enabled | FAIL | Enable RBAC mode |

### WARN Items (recommended to fix)
[...]
```

### 3. Configuration Audit (kube-hunter)

```bash
# Penetration testing
kube-hunter --remote

# JSON output
kube-hunter --json > hunter-report.json
```

#### Parse Results
```
## Security Risk Scan Report

### Risks Found
| Severity | Risk | Node | Remediation |
|--------|------|------|---------|
| HIGH | CAP_NET_RAW not restricted | node-1 | Add a Pod Security Policy |
| MEDIUM | Anonymous auth enabled | api-server | Set --anonymous-auth=false |
```

### 4. IaC Security Scanning (Checkov/Tfsec)

```bash
# Scan Terraform code
checkov -d infrastructure/

# Or use tfsec
tfscan infrastructure/
```

#### Parse Results
```
## IaC Security Scan Report

### Files Scanned: 15
### Issues Found: 3

| File | Line | Check | Severity | Remediation |
|------|------|--------|--------|---------|
| main.tf | 45 | AWS S3 not encrypted | HIGH | Add server_side_encryption |
| main.tf | 78 | Security group too permissive | MEDIUM | Tighten 0.0.0.0/0 |
```

### 5. Generate the Comprehensive Security Report

```
## Comprehensive Security Scan Report

### Scan Scope
- Image: payment-service:v1.2.3
- Cluster: production
- IaC: infrastructure/

### Scan Results Summary
| Category | CRITICAL | HIGH | MEDIUM | LOW |
|------|----------|------|--------|-----|
| Image vulnerabilities | 2 | 5 | 12 | 8 |
| CIS benchmark | 0 | 3 | 8 | 0 |
| Configuration audit | 0 | 1 | 2 | 0 |
| IaC security | 0 | 1 | 2 | 0 |

### Remediation Priority
1. [P0] Fix 2 CRITICAL image vulnerabilities (upgrade base image)
2. [P1] Fix 3 CIS benchmark FAIL items
3. [P1] Fix 1 HIGH configuration audit item
4. [P2] Fix IaC security issues
5. [P3] Address MEDIUM/LOW items

### Deployment Decision
- CRITICAL vulnerabilities not fixed: deployment to production is not recommended
- Re-scan to verify after remediation
```

### 6. Update the Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Scan Date | Image/Target | CRITICAL | HIGH | Remediation Status | Report Path |
|---------|----------|----------|------|---------|---------|
| 2026-06-22 | payment-service:v1.2.3 | 2 | 5 | Fixed | docs/security/scan-2026-06-22.md |
```

## Prohibitions

- Do not skip CRITICAL vulnerabilities and deploy directly
- Do not tamper with scan results
- Do not scan without providing remediation recommendations
- Do not run kube-hunter in the production environment (may impact services)

## Relationship to LOOP

**LOOP type**: audit

```
LOOP(audit):
  PLAN:       Define the scan scope
  PROVISION:  Execute scans (Trivy/kube-bench/kube-hunter/Checkov)
  VERIFY:     Parse results + generate report
  Pass? DONE : Remediate → re-scan
```
