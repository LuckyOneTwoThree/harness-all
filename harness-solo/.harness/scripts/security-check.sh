#!/bin/bash
# security-check.sh — Security scan (optional fallback script)
# Usage: bash security-check.sh
#
# ⚠️ Cross-platform note: this script is an optional fallback, only executed when bash is available.
# On Windows or environments without bash, the Agent must use the Grep tool to scan following "Method A" in verify SKILL.md
# (secret patterns / hardcoded credentials / dangerous commands / .gitignore check).
#
# Responsibility: invoke guards/*.sh to check the entire project (not just staged files)

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"
GUARDS_DIR="$HARNESS_DIR/hooks/guards"
exit_code=0

echo "=== Security Check ==="

# 1. Secret leak detection (full project scan)
echo "→ guard-secret.sh (full project scan)"
if bash "$GUARDS_DIR/guard-secret.sh" . 2>/dev/null; then
  echo "  ✓ No secret leaks"
else
  echo "  ✗ Secret leak detected"
  exit_code=1
fi

# guard-secret owns both content patterns and sensitive filenames; do not run a second scanner.

# 2. Check whether .gitignore contains .env
echo "→ .gitignore check"
if [ -f ".gitignore" ]; then
  if grep -qE '^\.env' .gitignore 2>/dev/null; then
    echo "  ✓ .env is in .gitignore"
  else
    echo "  ⚠ .env is not in .gitignore"
  fi
else
  echo "  ⚠ No .gitignore file"
fi

# 3. Check whether hooks are installed (non-blocking warning)
echo "→ Git hooks installation check"
if [ -d ".git/hooks" ]; then
  if [ -L ".git/hooks/pre-commit" ] || [ -f ".git/hooks/pre-commit" ]; then
    echo "  ✓ pre-commit hook installed"
  else
    echo "  ⚠ pre-commit hook not installed (can be ignored in pure PowerShell environments; verify skill acts as fallback)"
  fi
else
  echo "  - Not a git repository, skipping hooks check"
fi

echo ""
if [ $exit_code -eq 0 ]; then
  echo "✓ Security Check passed"
else
  echo "✗ Security Check failed"
fi
exit $exit_code
