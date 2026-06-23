#!/bin/bash
# pre-commit.sh — 提交前调度器
# git hook 调用：在 .git/hooks/pre-commit 软链或拷贝本文件
#
# 职责：调用 guards/*.sh 检查 staged 文件
# 注意：Windows 纯 PowerShell 环境跳过 hooks，verify skill 兜底

# CRLF 防御：Windows 下 core.autocrlf 可能导致脚本含 \r，Git Bash 无法执行
# 检测自身是否含 CRLF，若是则去除 \r 后重新执行
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"
GUARDS_DIR="$HARNESS_DIR/hooks/guards"

if [ ! -d "$GUARDS_DIR" ]; then
  echo "WARN: $GUARDS_DIR 不存在，跳过 pre-commit 检查"
  exit 0
fi

exit_code=0

# 1. 密钥泄露检测
echo "→ guard-secret.sh"
bash "$GUARDS_DIR/guard-secret.sh" || exit_code=1

# 2. 敏感文件阻止
echo "→ guard-sensitive-file.sh"
bash "$GUARDS_DIR/guard-sensitive-file.sh" || exit_code=1

# commit-msg 由 commit-msg hook 单独处理，这里不重复

if [ $exit_code -ne 0 ]; then
  echo ""
  echo "BLOCK: pre-commit 检查未通过"
  echo "如需绕过（不推荐）：git commit --no-verify"
  exit 1
fi

echo "✓ pre-commit 检查通过"
exit 0
