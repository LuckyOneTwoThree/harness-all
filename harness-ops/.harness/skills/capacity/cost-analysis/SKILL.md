---
name: cost-analysis
description: Cloud cost analysis and optimization, identifying idle resources, over-provisioning, and reservable instances, producing cost reports
triggers:
  - During monthly cost audits
  - When the user requests "cloud cost analysis"
  - When cost grows abnormally
  - When the optimization LOOP triggers
  - On budget overrun alerts
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

# Cost Analysis — Cloud Cost Analysis and Optimization

## Ground Rules

1. **Cost data comes from the cloud provider** — do not estimate, use actual billing data
2. **Optimization must not sacrifice availability** — never delete production resources to save money
3. **Reserved instances require long-term commitment** — do not purchase RI/SP blindly
4. **Cost reports are decision-oriented** — do not just list data, provide optimization recommendations

## Process

### 1. Collect Cost Data

```bash
# AWS Cost Explorer
aws ce get-cost-and-usage \
  --time-period Start=2026-05-01,End=2026-06-01 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=SERVICE

# For Alibaba Cloud / Tencent Cloud, use the billing API
```

### 2. Analyze Cost Structure

```
## Monthly Cost Report (May 2026)

### Total Cost: ¥45,678

### By Service
| Service | Cost | Share | YoY Change |
|------|------|------|---------|
| EC2/ECS | ¥18,000 | 39% | +5% |
| RDS | ¥12,000 | 26% | +0% |
| S3/OSS | ¥5,000 | 11% | +15% |
| LoadBalancer | ¥3,500 | 8% | +0% |
| CloudWatch | ¥2,000 | 4% | +20% |
| Other | ¥5,178 | 11% | -2% |

### By Environment
| Environment | Cost | Share |
|------|------|------|
| production | ¥35,000 | 77% |
| staging | ¥8,000 | 18% |
| dev | ¥2,678 | 6% |
```

### 3. Identify Optimization Opportunities

#### Idle Resources
```
## Idle Resource Identification

### EC2 Instances
| Instance ID | Type | Monthly Cost | Avg CPU Usage | Status | Recommendation |
|--------|------|--------|-----------|------|------|
| i-xxx1 | t3.large | ¥800 | 3% | Idle | Stop or terminate |
| i-xxx2 | t3.medium | ¥500 | 8% | Low usage | Downsize to t3.small |

### EBS Volumes
| Volume ID | Size | Monthly Cost | Last Attached | Status | Recommendation |
|------|------|--------|---------|------|------|
| vol-xxx | 100GB | ¥100 | 30 days ago | Unattached | Snapshot then terminate |

### Load Balancers
| LB ID | Type | Monthly Cost | Backend Instances | Status | Recommendation |
|-------|------|--------|---------|------|------|
| lb-xxx | ALB | ¥300 | 0 | Idle | Terminate |
```

#### Over-provisioning
```
## Over-provisioning Identification

### RDS Instances
| Instance ID | Type | Monthly Cost | CPU Usage | Connections | Recommendation |
|--------|------|--------|--------|--------|------|
| db-xxx | db.r5.xlarge | ¥3,000 | 15% | 20/1000 | Downsize to db.r5.large |

### ECS Tasks
| Service | Current Config | Monthly Cost | CPU Usage | Recommendation |
|------|---------|--------|--------|------|
| payment | 2 vCPU/4GB | ¥1,200 | 25% | Invoke resource-right-sizing |
```

#### Reserved Instance Opportunities
```
## Reserved Instance Recommendations

### Long-running EC2 Instances
| Instance Type | Count | On-Demand Monthly Cost | RI Monthly Cost | Savings | Commitment |
|---------|------|-----------|---------|------|--------|
| t3.medium | 5 | ¥2,500 | ¥1,500 | 40% | 1 year |

### Recommendations
- Purchase 5 t3.medium 1-year RIs, monthly savings ¥1,000
- Core production services, long-running, suitable for RI
```

### 4. Produce Optimization Recommendations

```
## Cost Optimization Recommendations

### Immediately Executable (Low Risk)
1. Stop idle EC2 i-xxx1 → monthly savings ¥800
2. Terminate unattached EBS vol-xxx → monthly savings ¥100
3. Terminate idle ALB lb-xxx → monthly savings ¥300
Subtotal: monthly savings ¥1,200

### Needs Assessment (Medium Risk)
4. Downsize RDS db-xxx → monthly savings ¥1,500 (performance impact must be assessed)
5. Invoke resource-right-sizing to optimize ECS → monthly savings ¥600
Subtotal: monthly savings ¥2,100

### Long-term Commitment (Low Risk but Requires Budget)
6. Purchase 5 t3.medium RIs → monthly savings ¥1,000 (upfront payment required)
Subtotal: monthly savings ¥1,000

### Total Optimization Potential: monthly savings ¥4,300 (9.4%)
```

### 5. Update Knowledge Base

Append to `memory/knowledge-base.md`:
```
| Month | Total Cost | Before Optimization | After Optimization | Savings | Main Optimization Items |
|------|--------|--------|--------|------|-----------|
| 2026-05 | ¥45,678 | ¥45,678 | ¥41,378 | ¥4,300 | Idle resources + downsizing + RI |
```

## Prohibitions

- Do not delete critical production environment resources to save money
- Do not downsize without assessing performance impact
- Do not purchase RIs blindly (long-term demand must be confirmed)
- Do not report cost without providing optimization recommendations

## Relationship to LOOP

**LOOP type**: optimization

```
LOOP(optimization):
  PLAN:       Collect cost data → analyze structure
  PROVISION:  Identify optimization opportunities → produce recommendations
  VERIFY:     Assess risk → confirm executability
  Pass? DONE : Skip optimization for now → re-analyze next time
```
