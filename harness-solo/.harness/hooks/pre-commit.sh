#!/bin/bash
# pre-commit.sh — Pre-commit scheduler
# Git hook usage: symlink or copy this file to .git/hooks/pre-commit
#
# Responsibility: invoke guards/*.sh to check staged files
# Note: hooks are skipped in pure PowerShell environments on Windows; the verify skill acts as a fallback

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
# Detect whether this file contains CRLF; if so, strip \r and re-exec
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"
GUARDS_DIR="$HARNESS_DIR/hooks/guards"

if [ ! -d "$GUARDS_DIR" ]; then
  echo "WARN: $GUARDS_DIR does not exist, skipping pre-commit checks"
  exit 0
fi

exit_code=0

# 1. Secret leak detection
echo "→ guard-secret.sh"
bash "$GUARDS_DIR/guard-secret.sh" || exit_code=1

# 2. Sensitive file blocking
echo "→ guard-sensitive-file.sh"
bash "$GUARDS_DIR/guard-sensitive-file.sh" || exit_code=1

# commit-msg is handled separately by the commit-msg hook; not duplicated here

if [ $exit_code -ne 0 ]; then
  echo ""
  echo "BLOCK: pre-commit checks failed"
  echo "To bypass (not recommended): git commit --no-verify"
  exit 1
fi

echo "✓ pre-commit checks passed"
exit 0
