#!/bin/bash
# verify-harness.sh — Framework health check (optional fallback script)
# Usage: bash verify-harness.sh
# Check .harness/ structural integrity and required file existence
#
# ⚠️ Cross-platform note: this script is an optional fallback, only executed when bash is available.
# On Windows or environments without bash, the Agent can self-check using Glob/Read tools according to this script's checklist.

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"

echo "=== Harness Health Check ==="

errors=0

# Auto-create runtime directories (listed in .gitignore; absent in freshly cloned projects)
RUNTIME_DIRS=(
  ".harness/memory"
  ".harness/memory/archives"
  ".harness/loops/specs"
)
for d in "${RUNTIME_DIRS[@]}"; do
  mkdir -p "$d" 2>/dev/null
done

# Required files check
REQUIRED_FILES=(
  "AGENTS.md"
  "SOUL.md"
  "constitution.md"
  ".harness/VERSION"
  ".harness/loops/LOOP.md"
  ".harness/skills/INDEX.md"
  ".harness/rules/security.md"
  ".harness/rules/prompt-defense.md"
  ".harness/FEATURES.md"
  ".harness/.gitignore"
)

echo "→ Required files check"
for f in "${REQUIRED_FILES[@]}"; do
  if [ -f "$f" ]; then
    echo "  ✓ $f"
  else
    echo "  ✗ missing: $f"
    errors=$((errors + 1))
  fi
done

# Required directories check (skeleton; missing = error)
REQUIRED_DIRS=(
  ".harness/skills/workflows"
  ".harness/skills/engineering"
  ".harness/skills/meta"
  ".harness/hooks/guards"
  ".harness/loops/specs"
  ".harness/memory"
  ".harness/memory/archives"
  ".harness/scripts"
  ".harness/templates"
  ".harness/rules"
)

echo "→ Required directories check (skeleton)"
for d in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$d" ]; then
    echo "  ✓ $d/"
  else
    echo "  ✗ missing: $d/"
    errors=$((errors + 1))
  fi
done

# Optional directories check (added on demand; missing = notice, no error)
OPTIONAL_DIRS=(
  ".harness/gates"
  "docs/product"
  "docs/engineering"
  "docs/acceptance"
  "docs/handoff"
)

echo "→ Optional directories check (on demand; missing does not error)"
for d in "${OPTIONAL_DIRS[@]}"; do
  if [ -d "$d" ]; then
    echo "  ✓ $d/"
  else
    echo "  · not enabled: $d/ (create on demand)"
  fi
done

# Guard scripts check
echo "→ Guard scripts check"
GUARDS=(
  ".harness/hooks/guards/guard-secret.sh"
  ".harness/hooks/guards/guard-bash.sh"
  ".harness/hooks/guards/guard-sensitive-file.sh"
  ".harness/hooks/guards/guard-commit-msg.sh"
  ".harness/hooks/pre-commit.sh"
  ".harness/hooks/pre-push.sh"
)
for g in "${GUARDS[@]}"; do
  if [ -f "$g" ]; then
    echo "  ✓ $g"
  else
    echo "  ✗ missing: $g"
    errors=$((errors + 1))
  fi
done

# Scripts check
echo "→ Scripts check"
SCRIPTS=(
  ".harness/scripts/archive-progress.sh"
  ".harness/scripts/entropy-check.sh"
  ".harness/scripts/security-check.sh"
  ".harness/scripts/verify-harness.sh"
)
for s in "${SCRIPTS[@]}"; do
  if [ -f "$s" ]; then
    echo "  ✓ $s"
  else
    echo "  ✗ missing: $s"
    errors=$((errors + 1))
  fi
done

# AGENTS.md line count check (constitution.md upper limit 150 lines)
echo "→ AGENTS.md line count check"
if [ -f "AGENTS.md" ]; then
  agents_lines=$(wc -l < AGENTS.md | tr -d ' ')
  if [ "$agents_lines" -le 100 ]; then
    echo "  ✓ $agents_lines lines (≤100)"
  elif [ "$agents_lines" -le 150 ]; then
    echo "  ⚠ $agents_lines lines (recommended ≤100, currently acceptable)"
  else
    echo "  ✗ $agents_lines lines (exceeds 150, violates constitution.md principle 5)"
    errors=$((errors + 1))
  fi
fi

echo ""
if [ $errors -eq 0 ]; then
  echo "✓ Harness health check passed"
  exit 0
else
  echo "✗ Found $errors issue(s)"
  exit 1
fi
