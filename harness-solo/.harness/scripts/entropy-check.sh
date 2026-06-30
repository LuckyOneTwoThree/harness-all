#!/bin/bash
# Optional Bash implementation of verify/Reference/entropy-baseline.md.

if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e
BASELINE=".harness/memory/baseline.json"

source_files() {
  find . -type f \( \
    -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o \
    -name '*.vue' -o -name '*.svelte' -o -name '*.py' -o -name '*.go' -o \
    -name '*.rs' -o -name '*.java' -o -name '*.c' -o -name '*.cpp' \
  \) \
    -not -path '*/.git/*' -not -path '*/node_modules/*' \
    -not -path '*/dist/*' -not -path '*/build/*' -print0 2>/dev/null
}

current_files=$(source_files | awk 'BEGIN { RS="\0" } length($0) { n++ } END { print n+0 }')
current_loc=$(source_files | xargs -0 awk 'NF { n++ } END { print n+0 }' 2>/dev/null)
current_loc=${current_loc:-0}

if [ -f package.json ] && command -v node >/dev/null 2>&1; then
  current_deps=$(node -e "const p=require('./package.json'); console.log(Object.keys(p.dependencies||{}).length)" 2>/dev/null || echo 0)
elif [ -f requirements.txt ]; then
  current_deps=$(grep -cE '^[[:space:]]*[^#[:space:]]' requirements.txt 2>/dev/null || echo 0)
else
  current_deps=0
fi

current_todos=$(source_files | xargs -0 grep -Eho '(TODO|FIXME)' 2>/dev/null | wc -l | tr -d ' ')

echo "=== Entropy Check ==="
echo "files=$current_files loc=$current_loc deps=$current_deps todos=$current_todos"

warnings=0
failures=0
if [ "$current_todos" -gt 50 ]; then
  echo "FAIL: TODO/FIXME count $current_todos > 50"
  failures=$((failures + 1))
elif [ "$current_todos" -gt 20 ]; then
  echo "WARN: TODO/FIXME count $current_todos > 20"
  warnings=$((warnings + 1))
fi

if [ ! -f "$BASELINE" ]; then
  echo "INFO: no baseline; growth checks skipped"
else
  value() { grep -oE "\"$1\"[[:space:]]*:[[:space:]]*[0-9]+" "$BASELINE" | grep -oE '[0-9]+$' | head -1; }
  base_files=$(value files); base_loc=$(value loc); base_deps=$(value deps); base_todos=$(value todos)

  if [ -n "$base_files" ] && [ "$base_files" -gt 0 ]; then
    delta=$((current_files - base_files)); growth=$((delta * 100 / base_files))
    if [ "$growth" -gt 20 ] && [ "$delta" -gt 50 ]; then
      echo "WARN: files +${growth}% and +${delta}"
      warnings=$((warnings + 1))
    fi
  fi

  if [ -n "$base_loc" ] && [ "$base_loc" -gt 0 ]; then
    growth=$(((current_loc - base_loc) * 100 / base_loc))
    if [ "$growth" -gt 50 ]; then
      echo "WARN: LOC +${growth}%"
      warnings=$((warnings + 1))
    fi
  fi

  if [ -n "$base_deps" ]; then
    delta=$((current_deps - base_deps))
    if [ "$delta" -gt 6 ]; then
      echo "FAIL: dependencies +$delta"
      failures=$((failures + 1))
    elif [ "$delta" -gt 3 ]; then
      echo "WARN: dependencies +$delta"
      warnings=$((warnings + 1))
    fi
  fi

  if [ -n "$base_todos" ] && [ "$base_todos" -gt 0 ]; then
    growth=$(((current_todos - base_todos) * 100 / base_todos))
    if [ "$growth" -gt 50 ] && [ "$current_todos" -le 50 ]; then
      echo "WARN: TODO/FIXME +${growth}%"
      warnings=$((warnings + 1))
    fi
  fi
fi

if [ "$failures" -gt 0 ]; then
  echo "Entropy check failed: $failures failure(s), $warnings warning(s)."
  exit 2
fi
if [ "$warnings" -gt 0 ]; then
  echo "Entropy check passed with $warnings warning(s)."
  exit 0
fi
echo "Entropy check passed."
