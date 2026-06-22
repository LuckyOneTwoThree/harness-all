# 工作流 F：发版

> 适用场景：版本发布、CHANGELOG 更新、打 tag、构建发布物
> 核心模式：verify 全量验证 → writing-documentation 更新 CHANGELOG → 打 tag → 构建发布物

## 与其他工作流的差异

| 维度 | new-feature | **release** |
|------|-------------|------------|
| 目标 | 实现新功能 | 发布版本 |
| 前置 | brainstorming | **所有计划功能已完成（FEATURES.md 全 done）** |
| LOOP | tdd→verify | **无 LOOP（验证为主）** |
| 产出 | 代码 + 测试 | **版本号 + tag + CHANGELOG + 发布物** |

## 流程

```
┌─────────────────┐
│ session-start   │  加载上下文，确认发版范围
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ 发版前置检查（硬门）                    │
│                                         │
│  - FEATURES.md 所有功能状态为 done？    │
│  - PROJECT.md 的成功指标已达标？        │
│  - PROJECT.md 的里程碑状态已更新？      │
│  - 全量测试通过？                       │
│  - verify skill 综合检查通过？          │
│  - 安全扫描无 critical/high？           │
│  - constitution 合规？                  │
│                                         │
│  ★ 任何一条不满足 → 不发版              │
└────────┬────────────────────────────────┘
         │ 通过
         ▼
┌─────────────────┐
│ writing-docu-   │  更新 CHANGELOG
│ mentation       │  - Added / Fixed / Changed
│                 │  - 关联 issue 号
│                 │  - 从 iterations.log 提取变更
└────────┬────────┘
         ▼
┌─────────────────┐
│ 版本号管理      │  按语义化版本
│                 │  - major: 不兼容的 API 变更
│                 │  - minor: 向后兼容的新功能
│                 │  - patch: 向后兼容的修复
└────────┬────────┘
         ▼
┌─────────────────┐
│ 构建 + 验证     │
│                 │  - 构建发布物（如 npm pack / go build）
│                 │  - 在干净环境验证发布物可运行
│                 │  - 展示构建输出
└────────┬────────┘
         ▼
┌─────────────────┐
│ 打 tag          │  git tag v<X.Y.Z>
│                 │  - annotated tag 含 CHANGELOG 摘要
│                 │  - 不自动 push（需用户确认）
└────────┬────────┘
         ▼
┌─────────────────────┐
│ requesting-code-    │  发版审查
│ review              │  - CHANGELOG 准确？
│                     │  - 版本号合理？
│                     │  - 发布物完整？
└──────────┬──────────┘
           │ 通过
           ▼
┌─────────────────┐
│ session-end     │  归档 + baseline
│                 │  - 记录发版信息到 progress.md
│                 │  - 可选产出 solo-to-growth.md
└─────────────────┘
```

## 关键检查点

- [ ] FEATURES.md 所有功能状态为 done？
- [ ] PROJECT.md 的成功指标已达标？（逐条对照，展示数据）
- [ ] PROJECT.md 的里程碑状态已更新？（在 FEATURES.md 中更新）
- [ ] 全量测试通过？（展示输出）
- [ ] verify 综合检查通过？
- [ ] 安全扫描无 critical/high？
- [ ] CHANGELOG 更新了？（Added/Fixed/Changed）
- [ ] 版本号符合语义化版本？
- [ ] 发布物在干净环境验证过？
- [ ] tag 打了？（不自动 push）

## 失败处理

| 失败点 | 处理方式 |
|--------|---------|
| 有功能未 done | 不发版，先完成或从本版本移除 |
| 测试失败 | 修复后重新验证，不许跳过 |
| 安全扫描有 critical | 修复后发版，不许忽略 |
| 发布物构建失败 | 修复构建问题，不许发布损坏的产物 |
| code-review 不通过 | 修复问题后重新审查 |

## 安全原则

1. **不自动 push tag**：tag 打在本地，push 需用户明确确认
2. **不自动 publish**：npm publish / docker push 等需用户明确确认
3. **发布物验证**：必须在干净环境验证可运行，不能"构建成功就发"
4. **CHANGELOG 准确**：从 iterations.log 提取，不凭记忆编写
