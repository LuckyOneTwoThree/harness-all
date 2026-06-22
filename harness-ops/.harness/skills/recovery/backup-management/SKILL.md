---
name: backup-management
description: Velero 备份管理，配置备份计划/执行备份/验证备份完整性
triggers:
  - 需要配置备份策略时
  - 执行定期备份时
  - 部署前需要备份时
  - 备份完整性验证时
  - 用户要求"备份数据"时
reads:
  - docs/infrastructure/OPS_STRATEGY.md
  - rules/security.md
  - loops/LOOP.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<task-name>/spec.md
  - loops/specs/<task-name>/evidence.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
operation_tier: propose
requires_approval: false
---

# Backup Management — Velero 备份管理

## 铁律

1. **备份必须验证** —— 未验证的备份等于没有备份
2. **备份有保留期** —— 不无限保留，按策略清理
3. **备份加密存储** —— 备份内容可能含敏感数据
4. **恢复演练必须定期执行** —— 不演练的备份不可信

## 流程

### 1. 配置备份计划

#### Velero Schedule CRD
```yaml
apiVersion: velero.io/v1
kind: Schedule
metadata:
  name: production-daily-backup
  namespace: velero
spec:
  schedule: "0 2 * * *"  # 每天凌晨 2 点
  template:
    includedNamespaces:
    - production
    - monitoring
    excludedResources:
    - events
    - pods
    storageLocation: default
    ttl: 720h  # 保留 30 天
    hooks:
      resources:
      - name: backup-hook
        includedNamespaces:
        - production
        preHooks:
        - exec:
            container: app
            command:
            - /bin/sh
            - -c
            - "pg_dump -U postgres dbname > /backup/db.sql"
        postHooks:
        - exec:
            container: app
            command:
            - /bin/sh
            - -c
            - "rm /backup/db.sql"
```

#### 备份策略
| 类型 | 频率 | 保留期 | 范围 | 存储 |
|------|------|--------|------|------|
| 每日备份 | 每天 2:00 | 30 天 | production 命名空间 | S3/OSS |
| 每周备份 | 每周日 3:00 | 90 天 | 全集群 | S3/OSS（不同区域） |
| 部署前备份 | 部署触发 | 7 天 | 变更相关资源 | S3/OSS |
| 数据库快照 | 每小时 | 24 小时 | RDS/PVC | 云厂商快照 |

### 2. 执行备份

```bash
# 手动触发备份
velero backup create manual-backup-2026-06-22 \
  --include-namespaces production \
  --wait

# 部署前备份（由 deployment-pipeline 触发）
velero backup create pre-deploy-$(date +%Y%m%d-%H%M) \
  --include-namespaces production \
  --label-selector app=payment-service
```

### 3. 验证备份完整性

```bash
# 查看备份状态
velero backup get

# 查看备份详情
velero backup describe <backup-name> --details

# 验证备份内容
velero backup download <backup-name>
tar -tzf <backup-name>.tar.gz | head -20

# 检查备份是否有错误
velero backup describe <backup-name> | grep -i error
```

#### 验证报告
```
## 备份验证报告

### 备份: production-daily-backup-2026-06-22
- 状态: Completed
- 开始时间: 2026-06-22 02:00:00
- 完成时间: 2026-06-22 02:05:32
- 耗时: 5 分 32 秒
- 资源数: 156
- 卷数: 8
- 总大小: 2.3 GB
- 错误: 0
- 警告: 0

### 验证结果
- [x] 备份状态 Completed
- [x] 无错误
- [x] 资源数符合预期
- [x] 卷数据完整
- [x] 可下载并解压
```

### 4. 备份监控

```yaml
# Prometheus 告警规则
- alert: VeleroBackupFailed
  expr: velero_backup_last_status{status="failed"} == 1
  for: 5m
  labels:
    severity: P1
  annotations:
    summary: "Velero 备份失败"
    description: "备份 {{ $labels.schedule }} 失败"

- alert: VeleroBackupStale
  expr: time() - velero_backup_last_timestamp > 86400
  for: 1h
  labels:
    severity: P2
  annotations:
    summary: "Velero 备份超过 24 小时未执行"
```

### 5. 备份清理

```bash
# 按保留期清理（Velero 自动执行）
# 手动删除旧备份
velero backup delete <old-backup-name> --confirm
```

### 6. 更新知识库

`memory/knowledge-base.md` 追加：
```
| 备份名 | 类型 | 时间 | 大小 | 状态 | 保留至 | 验证 |
|--------|------|------|------|------|--------|------|
| daily-2026-06-22 | 每日 | 02:00 | 2.3GB | Completed | 2026-07-22 | ✓ |
```

## 禁止事项

- 不跳过备份验证
- 不无限保留备份（按策略清理）
- 不在 production 命名空间测试恢复（用独立 namespace）
- 不将备份存储在同一可用区（需跨区域）

## 与 LOOP 的关系

**所属 LOOP 类型**：recovery（PLAN 阶段）

本 skill 配置备份计划，recovery-drill skill 执行恢复演练。
