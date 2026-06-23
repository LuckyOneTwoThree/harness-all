#!/bin/bash
# guard-bash.sh — Dangerous command validation tool
# Usage: bash guard-bash.sh "your_command"
#
# Positioning (important):
#   - Not an "auto-interceptor" — when an Agent executes rm -rf / via the terminal,
#     this script cannot automatically pop up to intercept it
#   - Rather, it is a "proactive validation tool" — before executing complex Bash
#     commands, the Agent runs this script first and only executes for real if it passes
#   - Truly effective protection is Docker sandbox isolation
#
# Agent usage:
#   1. Before executing complex commands, run `bash .harness/hooks/guards/guard-bash.sh "cmd"` first
#   2. If the script outputs OK → safe to execute
#   3. If the script outputs BLOCK → do not execute, explain to the user

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

if [ $# -eq 0 ]; then
  echo "Usage: bash guard-bash.sh \"your_command\""
  echo "Example: bash guard-bash.sh \"rm -rf node_modules\""
  exit 1
fi

cmd="$1"

# Blocked patterns (direct BLOCK)
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
  'DROP TABLE.*;(?!.*WHERE)'  # DROP without WHERE (simplified check)
)

# Confirm-required patterns (WARN, Agent should ask the user)
WARN_PATTERNS=(
  'git reset --hard'
  'git clean -fd'
  'npm publish'
  'pip install.*--user'
  'rm -rf [^/]'              # rm -rf with relative path
  'kill -9'
  'pkill'
)

for pattern in "${BLOCK_PATTERNS[@]}"; do
  if echo "$cmd" | grep -qE "$pattern"; then
    echo "BLOCK: command matches blocked pattern: $pattern"
    echo "Command: $cmd"
    echo "Reason: destructive operation, violates security.md"
    exit 2
  fi
done

for pattern in "${WARN_PATTERNS[@]}"; do
  if echo "$cmd" | grep -qE "$pattern"; then
    echo "WARN: command matches confirm-required pattern: $pattern"
    echo "Command: $cmd"
    echo "Suggestion: confirm with the user before executing"
    exit 1
  fi
done

echo "OK: command passed security check"
exit 0
