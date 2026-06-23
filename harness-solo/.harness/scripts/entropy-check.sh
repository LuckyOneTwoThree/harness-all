#!/bin/bash
# entropy-check.sh — Project complexity monitoring (optional fallback script)
# Usage: bash entropy-check.sh
#
# ⚠️ Cross-platform note: this script is an optional fallback, only executed when bash is available.
# On Windows or environments without bash, the Agent must use Glob+Read tools following "Method A" in verify SKILL.md
# to count files/loc/deps/todos and compare against baseline.json.
#
# Mechanism: compare against memory/baseline.json to compute growth rates
# baseline.json is written by the session-end skill during archiving
#
# Source: entropy-check from ArtemisAI/Harness_Engineering

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"
BASELINE="$HARNESS_DIR/memory/baseline.json"

# Threshold configuration
MAX_FILES_GROWTH_RATE=20   # File growth per Loop must not exceed 20%
MAX_LOC_GROWTH_RATE=30     # LOC growth per Loop must not exceed 30%
MAX_TODOS=20               # TODO marker upper limit
MAX_NEW_DEPS=3             # New dependencies per Loop upper limit

# Compute current metrics
count_files() {
  find . -type f \
    -not -path '*/.git/*' \
    -not -path '*/node_modules/*' \
    -not -path '*/.harness/memory/archives/*' \
    -not -path '*/.harness/loops/specs/*' \
    2>/dev/null | wc -l | tr -d ' '
}

count_loc() {
  # Use wc -l to count lines directly, avoiding piping entire file contents via cat (performance issue for large projects)
  find . -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' \
    -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.java' \) \
    -not -path '*/.git/*' \
    -not -path '*/node_modules/*' \
    2>/dev/null -print0 | xargs -0 wc -l 2>/dev/null | awk '$NF != "total" {sum+=$1} END {print sum+0}'
}

count_deps() {
  if [ -f "package.json" ]; then
    node -e "console.log(Object.keys(require('./package.json').dependencies || {}).length)" 2>/dev/null || echo 0
  elif [ -f "requirements.txt" ]; then
    grep -c '^[^#]' requirements.txt 2>/dev/null || echo 0
  else
    echo 0
  fi
}

count_todos() {
  grep -rE '(TODO|FIXME|HACK)' . \
    --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' \
    --include='*.py' --include='*.go' \
    --exclude-dir=.git --exclude-dir=node_modules \
    2>/dev/null | wc -l | tr -d ' '
}

current_files=$(count_files)
current_loc=$(count_loc)
current_deps=$(count_deps)
current_todos=$(count_todos)

echo "=== Entropy Check Report ==="
echo "Current metrics:"
echo "  File count: $current_files"
echo "  Lines of code: $current_loc"
echo "  Dependencies: $current_deps"
echo "  TODO/FIXME: $current_todos"
echo ""

# Absolute value check (no baseline needed)
warnings=0
if [ "$current_todos" -gt "$MAX_TODOS" ]; then
  echo "WARN: TODO/FIXME count $current_todos exceeds limit $MAX_TODOS"
  warnings=$((warnings + 1))
fi

# Growth rate check (requires baseline)
if [ ! -f "$BASELINE" ]; then
  echo "INFO: no baseline.json, skipping growth rate check (first run)"
  echo "  baseline.json will be written at session-end"
else
  # Parse baseline.json (simple grep to avoid jq dependency)
  base_files=$(grep -oE '"files"[[:space:]]*:[[:space:]]*[0-9]+' "$BASELINE" | grep -oE '[0-9]+$' || echo 0)
  base_loc=$(grep -oE '"loc"[[:space:]]*:[[:space:]]*[0-9]+' "$BASELINE" | grep -oE '[0-9]+$' || echo 0)
  base_deps=$(grep -oE '"deps"[[:space:]]*:[[:space:]]*[0-9]+' "$BASELINE" | grep -oE '[0-9]+$' || echo 0)

  if [ "$base_files" -gt 0 ]; then
    files_growth=$(( (current_files - base_files) * 100 / base_files ))
    echo "File growth rate: ${files_growth}% (threshold ${MAX_FILES_GROWTH_RATE}%)"
    if [ "$files_growth" -gt "$MAX_FILES_GROWTH_RATE" ]; then
      echo "WARN: file growth rate ${files_growth}% exceeds threshold ${MAX_FILES_GROWTH_RATE}%"
      warnings=$((warnings + 1))
    fi
  fi

  if [ "$base_loc" -gt 0 ]; then
    loc_growth=$(( (current_loc - base_loc) * 100 / base_loc ))
    echo "LOC growth rate: ${loc_growth}% (threshold ${MAX_LOC_GROWTH_RATE}%)"
    if [ "$loc_growth" -gt "$MAX_LOC_GROWTH_RATE" ]; then
      echo "WARN: LOC growth rate ${loc_growth}% exceeds threshold ${MAX_LOC_GROWTH_RATE}%"
      warnings=$((warnings + 1))
    fi
  fi

  if [ "$base_deps" -gt 0 ]; then
    new_deps=$(( current_deps - base_deps ))
    echo "New dependencies: $new_deps (limit $MAX_NEW_DEPS)"
    if [ "$new_deps" -gt "$MAX_NEW_DEPS" ]; then
      echo "WARN: new dependencies $new_deps exceed limit $MAX_NEW_DEPS"
      warnings=$((warnings + 1))
    fi
  fi
fi

echo ""
if [ "$warnings" -gt 0 ]; then
  echo "⚠ Found $warnings warning(s) — complexity inflation, recommend stopping to refactor"
  exit 1
else
  echo "✓ Complexity is within controllable range"
  exit 0
fi
