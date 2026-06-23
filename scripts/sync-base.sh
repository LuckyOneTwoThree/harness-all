#!/usr/bin/env bash
# sync-base.sh — harness-all development sync script
# Ensure base files across the 5 frameworks stay consistent, preventing version fragmentation
#
# Usage: bash scripts/sync-base.sh [--dry-run] [--check]
#   --dry-run  Only show differences, do not sync
#   --check    Strict mode; returns non-zero exit code when differences exist (suitable for CI)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

FRAMEWORKS=("harness-pm" "harness-design" "harness-solo" "harness-growth" "harness-ops")
DRY_RUN=false
CHECK_MODE=false

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --check) CHECK_MODE=true ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

echo "========================================="
echo " harness-all base file sync check"
echo "========================================="
echo ""

DIFF_COUNT=0

# ──────────────────────────────────────────
# 1. Check LOOP.md core structure consistency
# ──────────────────────────────────────────
echo "▶ Checking LOOP.md core structure..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.harness/loops/LOOP.md"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: LOOP.md does not exist"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  # Check hard circuit breaker rule
  if ! grep -q "hard_limit_reached" "$FILE"; then
    echo "  ✗ $fw: LOOP.md missing hard_limit_reached field"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # Check exploration_mode
  if ! grep -q "exploration_mode" "$FILE"; then
    echo "  ✗ $fw: LOOP.md missing exploration_mode field"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # Check hard circuit breaker execution rule
  if ! grep -q "circuit breaker execution rule" "$FILE"; then
    echo "  ✗ $fw: LOOP.md missing hard circuit breaker execution rule"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # Check mandatory Read rule
  if ! grep -qiE "(mandatorily|forcibly).*read.*state\.yaml" "$FILE"; then
    echo "  ⚠ $fw: LOOP.md missing mandatory Read state.yaml rule (new requirement)"
  fi
done

# ──────────────────────────────────────────
# 2. Check constitution.md common principles consistency
# ──────────────────────────────────────────
echo "▶ Checking constitution.md common principles..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/constitution.md"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: constitution.md does not exist"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  # Check common principles 1-4
  if ! grep -qi "zero runtime dependencies" "$FILE"; then
    echo "  ✗ $fw: constitution.md missing principle 1 'Zero Runtime Dependencies'"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
  if ! grep -qi "Agent Tools First" "$FILE"; then
    echo "  ✗ $fw: constitution.md missing principle 2 'Agent Tools First'"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
  if ! grep -qi "Core File Modifications Require" "$FILE"; then
    echo "  ✗ $fw: constitution.md missing principle 3 'Core File Modifications Require Confirmation'"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
  if ! grep -q "frontmatter" "$FILE"; then
    echo "  ✗ $fw: constitution.md missing principle 4 'Skills Must Have Complete Frontmatter'"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # Check Reference/ exception clause
  if ! grep -q "Reference/" "$FILE"; then
    echo "  ✗ $fw: constitution.md principle 5 missing Reference/ exception clause"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # Check exploration-first principle
  if ! grep -qiE "(Exploration|Discovery).?First" "$FILE"; then
    echo "  ✗ $fw: constitution.md missing 'Exploration First' principle"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 3. Check security.md Git Hooks prohibition
# ──────────────────────────────────────────
echo "▶ Checking security.md Git Hooks prohibition..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.harness/rules/security.md"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: security.md does not exist"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  if ! grep -q "\.git/hooks/" "$FILE"; then
    echo "  ✗ $fw: security.md missing .git/hooks/ prohibition"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 4. Check prompt-defense.md external content rule
# ──────────────────────────────────────────
echo "▶ Checking prompt-defense.md external content rule..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.harness/rules/prompt-defense.md"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: prompt-defense.md does not exist"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  # Check for the "external content is instruction" bug
  if grep -qi "external content is instruction" "$FILE"; then
    echo "  ✗ $fw: prompt-defense.md has a bug ('external content is instruction' should be 'data')"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 5. Check .gitattributes hooks LF rule
# ──────────────────────────────────────────
echo "▶ Checking .gitattributes hooks LF rule..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.gitattributes"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: .gitattributes does not exist"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  if ! grep -q "\.harness/hooks/" "$FILE"; then
    echo "  ✗ $fw: .gitattributes missing hooks LF rule"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 6. Check SKILL.md.template quality_gates/max_iterations
# ──────────────────────────────────────────
echo "▶ Checking SKILL.md.template field completeness..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.harness/templates/SKILL.md.template"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: SKILL.md.template does not exist"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  if ! grep -q "quality_gates" "$FILE"; then
    echo "  ✗ $fw: SKILL.md.template missing quality_gates field"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
  if ! grep -q "max_iterations" "$FILE"; then
    echo "  ✗ $fw: SKILL.md.template missing max_iterations field"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 7. Check install.sh CRLF guidance
# ──────────────────────────────────────────
echo "▶ Checking install.sh CRLF guidance..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/install.sh"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: install.sh does not exist"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  if ! grep -qi "CRLF\|crlf\|autocrlf\|bad interpreter" "$FILE"; then
    echo "  ✗ $fw: install.sh missing CRLF risk guidance"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 8. Check workflow frontmatter
# ──────────────────────────────────────────
echo "▶ Checking workflow frontmatter..."

for fw in "${FRAMEWORKS[@]}"; do
  WORKFLOW_DIR="$ROOT_DIR/$fw/.harness/skills/workflows"
  if [ ! -d "$WORKFLOW_DIR" ]; then
    continue
  fi

  for wf in "$WORKFLOW_DIR"/*.md; do
    [ -f "$wf" ] || continue
    BASENAME=$(basename "$wf")

    if ! grep -q "workflow_id:" "$wf"; then
      echo "  ✗ $fw/workflows/$BASENAME: missing workflow_id"
      DIFF_COUNT=$((DIFF_COUNT + 1))
    fi
    if ! grep -q "default_mode:" "$wf"; then
      echo "  ✗ $fw/workflows/$BASENAME: missing default_mode"
      DIFF_COUNT=$((DIFF_COUNT + 1))
    fi
  done
done

# ──────────────────────────────────────────
# 9. Check handoff document write permission one-way isolation
# ──────────────────────────────────────────
echo "▶ Checking handoff document write permission rules..."

for fw in "${FRAMEWORKS[@]}"; do
  SESSION_END="$ROOT_DIR/$fw/.harness/skills/meta/session-end/SKILL.md"
  if [ ! -f "$SESSION_END" ]; then
    continue
  fi

  # Check "append not overwrite" rule
  if ! grep -qi "do not overwrite\|append" "$SESSION_END"; then
    echo "  ⚠ $fw: session-end missing 'append not overwrite' rule"
  fi

  # Check write permission one-way declaration
  if ! grep -qi "Write Access\|Unidirectional\|Only.*may write" "$SESSION_END"; then
    echo "  ⚠ $fw: session-end missing write permission one-way declaration"
  fi
done

# ──────────────────────────────────────────
# Result summary
# ──────────────────────────────────────────
echo ""
echo "========================================="
if [ "$DIFF_COUNT" -eq 0 ]; then
  echo " ✓ All checks passed; base files across the 5 frameworks are consistent"
else
  echo " ✗ Found $DIFF_COUNT inconsistency(ies)"
fi
echo "========================================="

if [ "$CHECK_MODE" = true ] && [ "$DIFF_COUNT" -gt 0 ]; then
  exit 1
fi
