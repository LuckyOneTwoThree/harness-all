#!/bin/bash
# verify-harness.sh — 框架健康检查（可选兜底脚本）
# 用法：bash verify-harness.sh
# 检查 .harness/ 结构完整性、必填文件是否存在
#
# ⚠️ 跨平台说明：本脚本是可选兜底，仅在 bash 可用环境下执行。
# Windows 或无 bash 环境下，Agent 可用 Glob/Read 工具按本脚本的检查清单自检。

# CRLF 防御：Windows 下 core.autocrlf 可能导致脚本含 \r，Git Bash 无法执行
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"

echo "=== Harness 健康检查 ==="

errors=0

# 自动创建运行时目录（在 .gitignore 里，新 clone 的项目不存在）
RUNTIME_DIRS=(
  ".harness/memory"
  ".harness/memory/archives"
  ".harness/loops/specs"
)
for d in "${RUNTIME_DIRS[@]}"; do
  mkdir -p "$d" 2>/dev/null
done

# 必填文件检查
REQUIRED_FILES=(
  "AGENTS.md"
  "SOUL.md"
  "constitution.md"
  ".harness/VERSION"
  ".harness/loops/LOOP.md"
  ".harness/skills/INDEX.md"
  ".harness/rules/security.md"
  ".harness/rules/prompt-defense.md"
  ".harness/FEATURES.md"
  ".harness/.gitignore"
)

echo "→ 必填文件检查"
for f in "${REQUIRED_FILES[@]}"; do
  if [ -f "$f" ]; then
    echo "  ✓ $f"
  else
    echo "  ✗ 缺失: $f"
    errors=$((errors + 1))
  fi
done

# 必填目录检查（骨架，缺失 = 报错）
REQUIRED_DIRS=(
  ".harness/skills/workflows"
  ".harness/skills/engineering"
  ".harness/skills/meta"
  ".harness/hooks/guards"
  ".harness/loops/specs"
  ".harness/memory"
  ".harness/memory/archives"
  ".harness/scripts"
  ".harness/templates"
  ".harness/rules"
)

echo "→ 必填目录检查（骨架）"
for d in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$d" ]; then
    echo "  ✓ $d/"
  else
    echo "  ✗ 缺失: $d/"
    errors=$((errors + 1))
  fi
done

# 可选目录检查（按需添加，缺失 = 提示但不报错）
OPTIONAL_DIRS=(
  ".harness/gates"
  "docs/product"
  "docs/engineering"
  "docs/acceptance"
  "docs/handoff"
)

echo "→ 可选目录检查（按需，缺失不报错）"
for d in "${OPTIONAL_DIRS[@]}"; do
  if [ -d "$d" ]; then
    echo "  ✓ $d/"
  else
    echo "  · 未启用: $d/（按需创建）"
  fi
done

# Guard 脚本检查
echo "→ Guard 脚本检查"
GUARDS=(
  ".harness/hooks/guards/guard-secret.sh"
  ".harness/hooks/guards/guard-bash.sh"
  ".harness/hooks/guards/guard-sensitive-file.sh"
  ".harness/hooks/guards/guard-commit-msg.sh"
  ".harness/hooks/pre-commit.sh"
  ".harness/hooks/pre-push.sh"
)
for g in "${GUARDS[@]}"; do
  if [ -f "$g" ]; then
    echo "  ✓ $g"
  else
    echo "  ✗ 缺失: $g"
    errors=$((errors + 1))
  fi
done

# Scripts 脚本检查
echo "→ Scripts 脚本检查"
SCRIPTS=(
  ".harness/scripts/archive-progress.sh"
  ".harness/scripts/entropy-check.sh"
  ".harness/scripts/security-check.sh"
  ".harness/scripts/verify-harness.sh"
)
for s in "${SCRIPTS[@]}"; do
  if [ -f "$s" ]; then
    echo "  ✓ $s"
  else
    echo "  ✗ 缺失: $s"
    errors=$((errors + 1))
  fi
done

# AGENTS.md 行数检查（constitution.md 上限 150 行）
echo "→ AGENTS.md 行数检查"
if [ -f "AGENTS.md" ]; then
  agents_lines=$(wc -l < AGENTS.md | tr -d ' ')
  if [ "$agents_lines" -le 100 ]; then
    echo "  ✓ $agents_lines 行（≤100）"
  elif [ "$agents_lines" -le 150 ]; then
    echo "  ⚠ $agents_lines 行（建议 ≤100，当前可接受）"
  else
    echo "  ✗ $agents_lines 行（超过 150，违反 constitution.md 原则5）"
    errors=$((errors + 1))
  fi
fi

echo ""
if [ $errors -eq 0 ]; then
  echo "✓ Harness 健康检查通过"
  exit 0
else
  echo "✗ 发现 $errors 个问题"
  exit 1
fi
