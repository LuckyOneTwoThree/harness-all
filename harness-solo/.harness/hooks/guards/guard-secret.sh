#!/bin/bash
# guard-secret.sh — Secret leak detection
# Usage: bash guard-secret.sh [file_or_dir]
# Checks staged files when no argument is provided
#
# Positioning: proactive validation tool (invoked by Agent or git pre-commit)
# Not an auto-interceptor; it is a "run first, then decide" tool

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

# Secret patterns (high confidence)
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

# Sensitive file names
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

  # Check whether the file name is sensitive
  for pattern in "${SENSITIVE_FILES[@]}"; do
    if [[ "$file" =~ $pattern ]]; then
      echo "BLOCK: sensitive file name $file (matched $pattern)"
      exit_code=1
    fi
  done

  # Check whether the file content contains secrets
  if [ -f "$file" ]; then
    for pattern in "${PATTERNS[@]}"; do
      if grep -qE "$pattern" "$file" 2>/dev/null; then
        echo "BLOCK: $file contains a suspected secret (matched $pattern)"
        grep -nE "$pattern" "$file" 2>/dev/null | head -3
        exit_code=1
      fi
    done
  fi
}

if [ $# -gt 0 ]; then
  # Explicit arguments (use process substitution to avoid losing subshell variables)
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
  # Check staged files (use process substitution to avoid losing subshell variables)
  if git rev-parse --git-dir >/dev/null 2>&1; then
    while read -r f; do
      check_file "$f"
    done < <(git diff --cached --name-only --diff-filter=ACM)
  else
    echo "WARN: not in a git repository and no arguments provided; cannot check"
    exit 1
  fi
fi

if [ $exit_code -eq 0 ]; then
  echo "OK: no secret leaks detected"
fi

exit $exit_code
