#!/bin/bash
# guard-commit-msg.sh — Commit message format validation
# Usage: bash guard-commit-msg.sh "$1" (git hook invocation, $1 is the commit-msg file path)
#   or bash guard-commit-msg.sh -m "commit message"

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

# Get commit message
if [ "$1" = "-m" ]; then
  msg="$2"
else
  # git commit-msg hook mode
  msg_file="$1"
  if [ -z "$msg_file" ]; then
    echo "Usage: bash guard-commit-msg.sh <commit-msg-file> | -m \"message\""
    exit 1
  fi
  msg=$(cat "$msg_file")
fi

# Conventional Commits format
# <type>(<scope>): <subject>
# type: feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert
PATTERN='^(feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert)(\([a-z0-9-]+\))?: .{1,72}'

if ! echo "$msg" | head -1 | grep -qE "$PATTERN"; then
  echo "BLOCK: commit message does not conform to Conventional Commits format"
  echo ""
  echo "Format: <type>(<scope>): <subject>"
  echo "type: feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert"
  echo "scope: optional, lowercase with hyphens"
  echo "subject: 1-72 characters"
  echo ""
  echo "Your commit:"
  echo "  $(echo "$msg" | head -1)"
  echo ""
  echo "Examples:"
  echo "  feat(auth): add login with password"
  echo "  fix: handle empty username in profile"
  echo "  docs: update AGENTS.md loading chain"
  exit 1
fi

# Check subject length
subject=$(echo "$msg" | head -1 | sed 's/^[^:]*: //')
if [ ${#subject} -gt 72 ]; then
  echo "WARN: subject exceeds 72 characters (current ${#subject})"
fi

# Check whether it ends with a period (not recommended)
if echo "$subject" | grep -qE '\.$'; then
  echo "WARN: ending subject with a period is not recommended"
fi

echo "OK: commit message format is valid"
exit 0
