#!/bin/bash
# pre-push.sh — Pre-push checks
# Git hook usage: symlink or copy this file to .git/hooks/pre-push
#
# Responsibility: run tests before pushing (if any), prevent destructive pushes

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

# 1. Prevent force push to main/master
# pre-push hook receives via stdin: <local ref> <local sha> <remote ref> <remote sha>
protected_branches="main master"
zero="0000000000000000000000000000000000000000"

while read -r local_ref local_sha remote_ref remote_sha; do
  # Skip branch deletion (local_sha is all zeros)
  [ "$local_sha" = "$zero" ] && continue
  # Skip new branch (remote_sha is all zeros, no history to compare)
  [ "$remote_sha" = "$zero" ] && continue

  for branch in $protected_branches; do
    if [ "$remote_ref" = "refs/heads/$branch" ]; then
      # Non-fast-forward = force push: remote_sha is not an ancestor of local_sha
      if ! git merge-base --is-ancestor "$remote_sha" "$local_sha" 2>/dev/null; then
        echo "BLOCK: force push to $branch is forbidden (non-fast-forward update)"
        echo "  remote: $remote_sha"
        echo "  local:  $local_sha"
        exit 1
      fi
    fi
  done
done

# 2. Run tests (if the project has a test command)
if [ -f "package.json" ]; then
  if grep -q '"test"' package.json 2>/dev/null; then
    echo "→ Running tests..."
    npm test --silent 2>&1 | tail -20
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
      echo "BLOCK: tests failed, push denied"
      exit 1
    fi
  fi
elif [ -f "pyproject.toml" ] || [ -f "pytest.ini" ]; then
  echo "→ Running tests..."
  python -m pytest --tb=short 2>&1 | tail -20
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "BLOCK: tests failed, push denied"
    exit 1
  fi
fi

# 3. Run verify-harness health check (cross-platform fallback)
# Skipped when bash is unavailable on Windows; the verify skill acts as a fallback inside the IDE
if [ -f ".harness/scripts/verify-harness.sh" ] && command -v bash >/dev/null 2>&1; then
  echo "→ verify-harness.sh health check..."
  bash .harness/scripts/verify-harness.sh || {
    echo "WARN: harness health check failed (push allowed, but recommended to fix)"
  }
else
  echo "· Skipping verify-harness.sh (no bash environment; verify skill acts as fallback)"
fi

echo "✓ pre-push checks passed"
exit 0
