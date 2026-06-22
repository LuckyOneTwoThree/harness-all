#!/bin/bash
# guard-sensitive-file.sh — 敏感文件阻止
# 用法：bash guard-sensitive-file.sh [file_path...]
# 不带参数时检查 staged 文件

set -e

# 受保护文件（禁止修改/删除）
PROTECTED_PATHS=(
  'AGENTS\.md$'
  'SOUL\.md$'
  'constitution\.md$'
  '\.harness/rules/security\.md$'
  '\.harness/rules/prompt-defense\.md$'
  '\.harness/loops/LOOP\.md$'
  '\.git/hooks/'
  '\.github/workflows/'
)

# 敏感文件（禁止提交）
SENSITIVE_PATHS=(
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
  '\.htpasswd$'
)

exit_code=0

check_file() {
  local file="$1"

  # 检查受保护文件
  for pattern in "${PROTECTED_PATHS[@]}"; do
    if [[ "$file" =~ $pattern ]]; then
      echo "BLOCK: 受保护文件被修改: $file"
      echo "如需修改 $file，请用户明确确认"
      exit_code=1
    fi
  done

  # 检查敏感文件
  for pattern in "${SENSITIVE_PATHS[@]}"; do
    if [[ "$file" =~ $pattern ]]; then
      echo "BLOCK: 敏感文件: $file"
      echo "此类文件不应提交到 Git"
      exit_code=1
    fi
  done
}

if [ $# -gt 0 ]; then
  for f in "$@"; do
    check_file "$f"
  done
else
  if git rev-parse --git-dir >/dev/null 2>&1; then
    while read -r f; do
      check_file "$f"
    done < <(git diff --cached --name-only --diff-filter=ACMR)
  else
    echo "WARN: 不在 git 仓库，且未传参数"
    exit 1
  fi
fi

if [ $exit_code -eq 0 ]; then
  echo "OK: 未检测到敏感/受保护文件变更"
fi

exit $exit_code
