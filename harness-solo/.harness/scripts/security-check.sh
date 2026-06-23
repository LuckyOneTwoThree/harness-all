#!/bin/bash
# security-check.sh — 安全扫描（可选兜底脚本）
# 用法：bash security-check.sh
#
# ⚠️ 跨平台说明：本脚本是可选兜底，仅在 bash 可用环境下执行。
# Windows 或无 bash 环境下，Agent 必须按 verify SKILL.md 的"方式 A"用 Grep 工具扫描
# （密钥模式 / 硬编码凭证 / 危险命令 / .gitignore 检查）。
#
# 职责：调用 guards/*.sh 检查整个项目（不只 staged 文件）

# CRLF 防御：Windows 下 core.autocrlf 可能导致脚本含 \r，Git Bash 无法执行
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"
GUARDS_DIR="$HARNESS_DIR/hooks/guards"
exit_code=0

echo "=== Security Check ==="

# 1. 密钥泄露检测（全项目扫描）
echo "→ guard-secret.sh（全项目扫描）"
if bash "$GUARDS_DIR/guard-secret.sh" . 2>/dev/null; then
  echo "  ✓ 无密钥泄露"
else
  echo "  ✗ 检测到密钥泄露"
  exit_code=1
fi

# 2. 敏感文件检查（全项目）
echo "→ guard-sensitive-file.sh（全项目扫描）"
# 手动扫描，因为不带参数时检查 staged
sensitive_found=0
while IFS= read -r -d '' f; do
  if bash "$GUARDS_DIR/guard-sensitive-file.sh" "$f" 2>/dev/null | grep -q "BLOCK"; then
    echo "  ✗ 敏感文件: $f"
    sensitive_found=1
  fi
done < <(find . -type f -not -path '*/.git/*' -not -path '*/node_modules/*' -print0 2>/dev/null)
if [ "$sensitive_found" -eq 0 ]; then
  echo "  ✓ 无敏感文件"
else
  exit_code=1
fi

# 3. 检查 .gitignore 是否包含 .env
echo "→ .gitignore 检查"
if [ -f ".gitignore" ]; then
  if grep -qE '^\.env' .gitignore 2>/dev/null; then
    echo "  ✓ .env 在 .gitignore 中"
  else
    echo "  ⚠ .env 不在 .gitignore 中"
  fi
else
  echo "  ⚠ 无 .gitignore 文件"
fi

# 4. 检查 hooks 是否安装（非阻塞警告）
echo "→ Git hooks 安装检查"
if [ -d ".git/hooks" ]; then
  if [ -L ".git/hooks/pre-commit" ] || [ -f ".git/hooks/pre-commit" ]; then
    echo "  ✓ pre-commit hook 已安装"
  else
    echo "  ⚠ pre-commit hook 未安装（纯 PowerShell 环境可忽略，verify skill 兜底）"
  fi
else
  echo "  - 非 git 仓库，跳过 hooks 检查"
fi

echo ""
if [ $exit_code -eq 0 ]; then
  echo "✓ Security Check 通过"
else
  echo "✗ Security Check 未通过"
fi
exit $exit_code
