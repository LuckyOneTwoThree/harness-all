#!/bin/bash
# guard-sensitive-file.sh — Sensitive file blocking
# Usage: bash guard-sensitive-file.sh [file_path...]
# Checks staged files when no argument is provided

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

# Protected files (modification/deletion forbidden)
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

# Sensitive files (committing forbidden)
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

  # Check protected files
  for pattern in "${PROTECTED_PATHS[@]}"; do
    if [[ "$file" =~ $pattern ]]; then
      echo "BLOCK: protected file modified: $file"
      echo "To modify $file, get explicit confirmation from the user"
      exit_code=1
    fi
  done

  # Check sensitive files
  for pattern in "${SENSITIVE_PATHS[@]}"; do
    if [[ "$file" =~ $pattern ]]; then
      echo "BLOCK: sensitive file: $file"
      echo "These files should not be committed to Git"
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
    echo "WARN: not in a git repository and no arguments provided"
    exit 1
  fi
fi

if [ $exit_code -eq 0 ]; then
  echo "OK: no sensitive/protected file changes detected"
fi

exit $exit_code
