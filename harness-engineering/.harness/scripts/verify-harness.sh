#!/bin/bash
# verify-harness.sh — Framework health check (optional fallback script)
# Usage: bash verify-harness.sh [framework-type]
#   framework-type: pm | engineering (default: auto-detect)
#
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

# ──────────────────────────────────────────
# Auto-detect framework type from AGENTS.md or directory structure
# ──────────────────────────────────────────
FW_TYPE="${1:-}"

if [ -z "$FW_TYPE" ]; then
  # Auto-detect: look for domain skill directories
  if [ -d ".harness/skills/engineering" ]; then
    FW_TYPE="engineering"
  elif [ -d ".harness/skills/pm" ]; then
    FW_TYPE="pm"
  else
    FW_TYPE="unknown"
  fi
fi

echo "=== Harness Health Check (framework: $FW_TYPE) ==="

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

# ──────────────────────────────────────────
# Required files check (common to all frameworks)
# ──────────────────────────────────────────
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

# ──────────────────────────────────────────
# Required directories check (common skeleton)
# ──────────────────────────────────────────
REQUIRED_DIRS_COMMON=(
  ".harness/skills/workflows"
  ".harness/skills/meta"
  ".harness/loops/specs"
  ".harness/memory"
  ".harness/memory/archives"
  ".harness/templates"
  ".harness/rules"
)

# Framework-specific domain skill directory
case "$FW_TYPE" in
  pm)     REQUIRED_DIRS_DOMAIN=(".harness/skills/pm") ;;
  engineering)   REQUIRED_DIRS_DOMAIN=(".harness/skills/engineering") ;;
  *)      REQUIRED_DIRS_DOMAIN=() ;;
esac

# Engineering-specific directories
REQUIRED_DIRS_ENGINEERING=(
  ".harness/hooks/guards"
  ".harness/scripts"
)

echo "→ Required directories check (skeleton)"
for d in "${REQUIRED_DIRS_COMMON[@]}" "${REQUIRED_DIRS_DOMAIN[@]}"; do
  if [ -d "$d" ]; then
    echo "  ✓ $d/"
  else
    echo "  ✗ missing: $d/"
    errors=$((errors + 1))
  fi
done

# Engineering-only directories
if [ "$FW_TYPE" = "engineering" ]; then
  for d in "${REQUIRED_DIRS_ENGINEERING[@]}"; do
    if [ -d "$d" ]; then
      echo "  ✓ $d/"
    else
      echo "  ✗ missing: $d/"
      errors=$((errors + 1))
    fi
  done
fi

# ──────────────────────────────────────────
# Optional directories check
# ──────────────────────────────────────────
OPTIONAL_DIRS_COMMON=(
  ".harness/gates"
  "docs/handoff"
)

# Framework-specific optional docs directories
case "$FW_TYPE" in
  pm)     OPTIONAL_DIRS_DOMAIN=("docs/product" "docs/strategy" "docs/discovery" "docs/monitoring") ;;
  engineering)   OPTIONAL_DIRS_DOMAIN=("docs/product" "docs/engineering" "docs/acceptance" "docs/decisions") ;;
  *)      OPTIONAL_DIRS_DOMAIN=() ;;
esac

echo "→ Optional directories check (on demand; missing does not error)"
for d in "${OPTIONAL_DIRS_COMMON[@]}" "${OPTIONAL_DIRS_DOMAIN[@]}"; do
  if [ -d "$d" ]; then
    echo "  ✓ $d/"
  else
    echo "  · not enabled: $d/ (create on demand)"
  fi
done

# ──────────────────────────────────────────
# Engineering-specific checks: guard scripts and utility scripts
# ──────────────────────────────────────────
if [ "$FW_TYPE" = "engineering" ]; then
  echo "→ Guard scripts check (engineering only)"
  GUARDS=(
    ".harness/hooks/guards/guard-secret.sh"
    ".harness/hooks/guards/guard-bash.sh"
    ".harness/hooks/guards/guard-commit-msg.sh"
    ".harness/hooks/pre-commit.sh"
    ".harness/hooks/pre-push.sh"
    ".harness/hooks/commit-msg.sh"
  )
  for g in "${GUARDS[@]}"; do
    if [ -f "$g" ]; then
      echo "  ✓ $g"
    else
      echo "  ✗ missing: $g"
      errors=$((errors + 1))
    fi
  done

  echo "→ Scripts check (engineering only)"
  SCRIPTS=(
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
fi

# ──────────────────────────────────────────
# AGENTS.md line count check (constitution.md: AGENTS.md ≤ 150 lines)
# ──────────────────────────────────────────
echo "→ AGENTS.md line count check"
if [ -f "AGENTS.md" ]; then
  agents_lines=$(wc -l < AGENTS.md | tr -d ' ')
  if [ "$agents_lines" -le 150 ]; then
    echo "  ✓ $agents_lines lines (≤150)"
  else
    echo "  ✗ $agents_lines lines (exceeds 150, violates constitution.md principle 5)"
    errors=$((errors + 1))
  fi
fi

echo ""
if [ $errors -eq 0 ]; then
  echo "✓ Harness health check passed (framework: $FW_TYPE)"
  exit 0
else
  echo "✗ Found $errors issue(s) (framework: $FW_TYPE)"
  exit 1
fi
