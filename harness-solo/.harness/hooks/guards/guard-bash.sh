#!/bin/bash
# guard-bash.sh — 危险命令验证工具
# 用法：bash guard-bash.sh "your_command"
#
# 定位（重要）：
#   - 不是"自动拦截器"——Agent 通过终端执行 rm -rf / 时，本脚本无法自动跳出来拦截
#   - 而是"主动验证工具"——Agent 在执行复杂 Bash 前，先跑本脚本，通过了再真跑
#   - 真正有效的防护是 Docker 沙盒隔离
#
# Agent 使用方式：
#   1. 执行复杂命令前，先跑 `bash .harness/hooks/guards/guard-bash.sh "cmd"`
#   2. 脚本输出 OK → 可以执行
#   3. 脚本输出 BLOCK → 不要执行，向用户说明

# CRLF 防御：Windows 下 core.autocrlf 可能导致脚本含 \r，Git Bash 无法执行
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

if [ $# -eq 0 ]; then
  echo "用法: bash guard-bash.sh \"your_command\""
  echo "示例: bash guard-bash.sh \"rm -rf node_modules\""
  exit 1
fi

cmd="$1"

# 禁止模式（直接 BLOCK）
BLOCK_PATTERNS=(
  'rm -rf /'
  'rm -rf ~'
  'rm -rf \*'
  'rm -rf \.\.'
  'chmod -R 777 /'
  'curl.*\| *sh'
  'curl.*\| *bash'
  'wget.*\| *sh'
  'wget.*\| *bash'
  ':(){:|:&};:'              # fork bomb
  'mkfs\.'
  'dd if=.*of=/dev/'
  '> /dev/sda'
  'git push --force.*origin/(main|master)'
  'DROP DATABASE'
  'DROP TABLE.*;(?!.*WHERE)'  # 无 WHERE 的 DROP（简化判断）
)

# 需确认模式（WARN，Agent 应询问用户）
WARN_PATTERNS=(
  'git reset --hard'
  'git clean -fd'
  'npm publish'
  'pip install.*--user'
  'rm -rf [^/]'              # rm -rf 相对路径
  'kill -9'
  'pkill'
)

for pattern in "${BLOCK_PATTERNS[@]}"; do
  if echo "$cmd" | grep -qE "$pattern"; then
    echo "BLOCK: 命令匹配禁止模式: $pattern"
    echo "命令: $cmd"
    echo "原因: 破坏性操作，违反 security.md"
    exit 2
  fi
done

for pattern in "${WARN_PATTERNS[@]}"; do
  if echo "$cmd" | grep -qE "$pattern"; then
    echo "WARN: 命令匹配需确认模式: $pattern"
    echo "命令: $cmd"
    echo "建议: 执行前向用户确认"
    exit 1
  fi
done

echo "OK: 命令通过安全检查"
exit 0
