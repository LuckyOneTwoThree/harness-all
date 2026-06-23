#!/bin/bash
# guard-secret.sh — 密钥泄露检测
# 用法：bash guard-secret.sh [file_or_dir]
# 不带参数时检查 staged 文件
#
# 定位：主动验证工具（Agent 或 git pre-commit 调用）
# 不是自动拦截器，是"先跑一遍再决定"的工具

# CRLF 防御：Windows 下 core.autocrlf 可能导致脚本含 \r，Git Bash 无法执行
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

# 密钥模式（高置信度）
PATTERNS=(
  'sk-[a-zA-Z0-9]{20,}'           # OpenAI
  'AKIA[A-Z0-9]{16}'              # AWS Access Key
  'ghp_[a-zA-Z0-9]{36}'           # GitHub PAT
  'gho_[a-zA-Z0-9]{36}'           # GitHub OAuth
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'  # PEM
  'AIza[0-9A-Za-z\-_]{35}'        # Google API
  'xox[baprs]-[a-zA-Z0-9-]+'      # Slack
  'eyJ[a-zA-Z0-9_-]*\.eyJ'        # JWT
)

# 敏感文件名
SENSITIVE_FILES=(
  '\.env$'
  '\.env\.local$'
  '\.env\.production$'
  '\.env\.staging$'
  'credentials\.json$'
  'service-account.*\.json$'
  'id_rsa$'
  'id_ed25519$'
  '\.pem$'
  '\.key$'
)

exit_code=0

check_file() {
  local file="$1"

  # 检查文件名是否敏感
  for pattern in "${SENSITIVE_FILES[@]}"; do
    if [[ "$file" =~ $pattern ]]; then
      echo "BLOCK: 敏感文件名 $file（匹配 $pattern）"
      exit_code=1
    fi
  done

  # 检查文件内容是否包含密钥
  if [ -f "$file" ]; then
    for pattern in "${PATTERNS[@]}"; do
      if grep -qE "$pattern" "$file" 2>/dev/null; then
        echo "BLOCK: $file 包含疑似密钥（匹配 $pattern）"
        grep -nE "$pattern" "$file" 2>/dev/null | head -3
        exit_code=1
      fi
    done
  fi
}

if [ $# -gt 0 ]; then
  # 显式传参（用进程替换避免子 shell 变量丢失）
  for target in "$@"; do
    if [ -d "$target" ]; then
      while read -r f; do
        check_file "$f"
      done < <(find "$target" -type f -not -path '*/.git/*' -not -path '*/node_modules/*')
    else
      check_file "$target"
    fi
  done
else
  # 检查 staged 文件（用进程替换避免子 shell 变量丢失）
  if git rev-parse --git-dir >/dev/null 2>&1; then
    while read -r f; do
      check_file "$f"
    done < <(git diff --cached --name-only --diff-filter=ACM)
  else
    echo "WARN: 不在 git 仓库，且未传参数，无法检查"
    exit 1
  fi
fi

if [ $exit_code -eq 0 ]; then
  echo "OK: 未检测到密钥泄露"
fi

exit $exit_code
