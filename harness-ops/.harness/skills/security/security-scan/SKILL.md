---
name: security-scan
description: Trivy/kube-bench 安全扫描，镜像漏洞/CIS基线/配置审计，生成修复建议
triggers:
  - 镜像构建后扫描漏洞时
  - 定期安全审计时
  - 部署前安全检查时
  - 发现新 CVE 需要评估影响时
  - security-audit-workflow 触发时
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

# Security Scan — 安全扫描与修复建议

## 铁律

1. **扫描不阻断部署** —— 扫描是建议，不是硬门（除非 CRITICAL 漏洞）
2. **修复有优先级** —— CRITICAL > HIGH > MEDIUM > LOW
3. **不修复不报告** —— 扫描结果必须有修复建议
4. **定期扫描** —— 不是一次性，是持续过程

## 流程

### 1. 镜像漏洞扫描（Trivy）

```bash
# 扫描镜像
trivy image registry.example.com/payment-service:v1.2.3

# JSON 输出（便于 Agent 解析）
trivy image -f json -o scan-result.json registry.example.com/payment-service:v1.2.3

# 只扫描 HIGH 和 CRITICAL
trivy image --severity HIGH,CRITICAL registry.example.com/payment-service:v1.2.3
```

#### 解析扫描结果
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
          "Title": "OpenSSL 缓冲区溢出",
          "Description": "..."
        }
      ]
    }
  ]
}
```

#### 生成修复建议
```
## 镜像扫描报告

### 镜像: payment-service:v1.2.3
### 扫描时间: 2026-06-22T14:30:00
### 漏洞统计: CRITICAL: 2, HIGH: 5, MEDIUM: 12, LOW: 8

### CRITICAL 漏洞（必须修复）
| CVE | 包 | 当前版本 | 修复版本 | 建议 |
|-----|-----|---------|---------|------|
| CVE-2026-1234 | openssl | 3.1.0 | 3.1.1 | 升级基础镜像 |
| CVE-2026-5678 | libxml2 | 2.10.0 | 2.10.4 | 升级基础镜像 |

### 修复方案
1. 更新 Dockerfile 基础镜像: alpine:3.18 → alpine:3.19
2. 重新构建镜像并扫描验证
3. CRITICAL 漏洞修复后再部署
```

### 2. CIS 基线检查（kube-bench）

```bash
# 运行 CIS 基线检查
kube-bench --benchmark cis-1.8

# JSON 输出
kube-bench --json > cis-report.json
```

#### 解析检查结果
```
## CIS 基线检查报告

### 检查项统计: PASS: 45, WARN: 8, FAIL: 3

### FAIL 项（必须修复）
| 编号 | 检查项 | 状态 | 修复建议 |
|------|--------|------|---------|
| 4.2.6 | --protect-kernel-defaults 未设置 | FAIL | kubelet 配置添加该参数 |
| 4.2.9 | --event-qps 未设置 | FAIL | 设置为 0 |
| 5.1.5 | RBAC 未启用 | FAIL | 启用 RBAC 模式 |

### WARN 项（建议修复）
[...]
```

### 3. 配置审计（kube-hunter）

```bash
# 渗透测试
kube-hunter --remote

# JSON 输出
kube-hunter --json > hunter-report.json
```

#### 解析结果
```
## 安全风险扫描报告

### 发现的风险
| 严重度 | 风险 | 节点 | 修复建议 |
|--------|------|------|---------|
| HIGH | CAP_NET_RAW 未限制 | node-1 | 添加 Pod Security Policy |
| MEDIUM | 匿名认证启用 | api-server | 关闭 --anonymous-auth=false |
```

### 4. IaC 安全扫描（Checkov/Tfsec）

```bash
# 扫描 Terraform 代码
checkov -d infrastructure/

# 或使用 tfsec
tfscan infrastructure/
```

#### 解析结果
```
## IaC 安全扫描报告

### 扫描文件: 15 个
### 发现问题: 3 个

| 文件 | 行号 | 检查项 | 严重度 | 修复建议 |
|------|------|--------|--------|---------|
| main.tf | 45 | AWS S3 未加密 | HIGH | 添加 server_side_encryption |
| main.tf | 78 | 安全组过宽 | MEDIUM | 收紧 0.0.0.0/0 |
```

### 5. 生成综合安全报告

```
## 综合安全扫描报告

### 扫描范围
- 镜像: payment-service:v1.2.3
- 集群: production
- IaC: infrastructure/

### 扫描结果汇总
| 类别 | CRITICAL | HIGH | MEDIUM | LOW |
|------|----------|------|--------|-----|
| 镜像漏洞 | 2 | 5 | 12 | 8 |
| CIS 基线 | 0 | 3 | 8 | 0 |
| 配置审计 | 0 | 1 | 2 | 0 |
| IaC 安全 | 0 | 1 | 2 | 0 |

### 修复优先级
1. [P0] 修复 2 个 CRITICAL 镜像漏洞（升级基础镜像）
2. [P1] 修复 3 个 CIS 基线 FAIL 项
3. [P1] 修复 1 个 HIGH 配置审计项
4. [P2] 修复 IaC 安全问题
5. [P3] 处理 MEDIUM/LOW 项

### 部署决策
- CRITICAL 漏洞未修复: 不建议部署到 production
- 修复后重新扫描验证
```

### 6. 更新知识库

`memory/knowledge-base.md` 追加：
```
| 扫描日期 | 镜像/目标 | CRITICAL | HIGH | 修复状态 | 报告路径 |
|---------|----------|----------|------|---------|---------|
| 2026-06-22 | payment-service:v1.2.3 | 2 | 5 | 已修复 | docs/security/scan-2026-06-22.md |
```

## 禁止事项

- 不跳过 CRITICAL 漏洞直接部署
- 不篡改扫描结果
- 不只扫描不报告修复建议
- 不在 production 环境运行 kube-hunter（可能影响服务）

## 与 LOOP 的关系

**所属 LOOP 类型**：audit

```
LOOP(audit):
  PLAN:       确定扫描范围
  PROVISION:  执行扫描（Trivy/kube-bench/kube-hunter/Checkov）
  VERIFY:     解析结果 + 生成报告
  通过? DONE : 修复 → 重新扫描
```
