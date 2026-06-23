#!/bin/bash
# archive-progress.sh — Memory auto-archive (optional fallback script)
# Usage: bash archive-progress.sh
#
# ⚠️ Cross-platform note: this script is an optional fallback, only executed in bash-available environments (macOS/Linux/Git Bash).
# On Windows or environments without bash, the Agent must perform tool-based operations following steps 4.1-4.2 of session-end SKILL.md
# (Read progress.md → detect line count → split archive → Write back).
#
# Mechanism: wc -l detects line count; when the threshold is exceeded, automatically split and archive to archives/

# CRLF defense: on Windows, core.autocrlf may cause scripts to contain \r, which Git Bash cannot execute
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"
PROGRESS="$HARNESS_DIR/memory/progress.md"
ARCHIVES_DIR="$HARNESS_DIR/memory/archives"
THRESHOLD=200  # line count threshold

if [ ! -f "$PROGRESS" ]; then
  echo "OK: $PROGRESS does not exist, no archive needed"
  exit 0
fi

mkdir -p "$ARCHIVES_DIR"

lines=$(wc -l < "$PROGRESS" | tr -d ' ')

if [ "$lines" -le "$THRESHOLD" ]; then
  echo "OK: progress.md $lines lines (threshold $THRESHOLD), no archive needed"
  exit 0
fi

# Generate archive file name
timestamp=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
archive_file="$ARCHIVES_DIR/progress-$timestamp.md"

# Back up current progress.md
cp "$PROGRESS" "$archive_file"

# Keep the last complete session block (starting with the "## Session:" marker)
# Avoid a fixed tail -N that would cut session context
last_session_line=$(grep -n '^## Session:' "$PROGRESS" | tail -1 | cut -d: -f1)
if [ -n "$last_session_line" ]; then
  tail -n +"$last_session_line" "$PROGRESS" > "$PROGRESS.tmp"
else
  # No session marker, fall back to tail -30
  tail -30 "$PROGRESS" > "$PROGRESS.tmp"
fi
mv "$PROGRESS.tmp" "$PROGRESS"

# Prepend source info to the archive file header
{
  echo "<!-- Archived at: $timestamp -->"
  echo "<!-- Original line count: $lines -->"
  echo "<!-- Archive reason: exceeded threshold of $THRESHOLD lines -->"
  echo ""
  cat "$archive_file"
} > "$archive_file.tmp"
mv "$archive_file.tmp" "$archive_file"

# Update archives/INDEX.md
INDEX_FILE="$ARCHIVES_DIR/INDEX.md"
if [ ! -f "$INDEX_FILE" ]; then
  cat > "$INDEX_FILE" <<'EOF'
# Archive Index

| File | Archived At | Original Lines | Note |
|------|-------------|----------------|------|
EOF
fi

echo "| progress-$timestamp.md | $timestamp | $lines | Auto-archived |" >> "$INDEX_FILE"

echo "✓ Archived: $archive_file ($lines lines)"
echo "✓ progress.md kept the last complete session block"
exit 0
