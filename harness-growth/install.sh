#!/bin/bash
# install.sh — harness-growth cold-start install script
#
# Usage (two-step install, follows security rules — no curl | bash):
#   curl -o install.sh https://raw.githubusercontent.com/LuckyOneTwoThree/harness-growth/main/install.sh
#   # Review install.sh contents
#   bash install.sh
#
# Purpose: Install the .harness/ template into the current directory and initialize the project
#          Supports both local install (from harness-all repo) and remote clone install

set -e

echo "=== harness-growth cold-start install ==="
echo ""

# Check whether .harness/ already exists in the current directory
if [ -d ".harness" ]; then
  echo "BLOCK: .harness/ already exists in the current directory; appears already initialized"
  echo "To reinstall, please delete .harness/ first or switch to another directory"
  exit 1
fi

# Check git
if ! command -v git >/dev/null 2>&1; then
  echo "BLOCK: git not found; please install Git first"
  exit 1
fi

# Detect if running from within the harness-all repo (local install)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "$SCRIPT_DIR/.harness" ]; then
  # Local install: script is inside harness-all/harness-growth/
  echo "→ Using local framework files from: $SCRIPT_DIR"
  TEMPLATE_DIR="$SCRIPT_DIR"
else
  # Remote install: clone from GitHub (for standalone single-framework use)
  echo "→ Cloning template repository..."
  REPO_URL="https://github.com/LuckyOneTwoThree/harness-growth.git"
  TEMPLATE_BRANCH="main"
  TEMP_DIR=".harness-growth-tmp-$$"
  git clone --depth 1 -b "$TEMPLATE_BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
    echo "BLOCK: Clone failed; check network or repository URL: $REPO_URL"
    echo "Tip: If you already cloned harness-all, run this script from harness-all/harness-growth/"
    exit 1
  }
  TEMPLATE_DIR="$TEMP_DIR"
fi

# Copy .harness/ to the current directory
echo "→ Copying .harness/ framework..."
cp -r "$TEMPLATE_DIR/.harness" .harness

# Copy AGENTS.md and SOUL.md templates (if they don't exist)
if [ ! -f "AGENTS.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/AGENTS.md.template" AGENTS.md
  echo "  ✓ Created AGENTS.md (from template)"
fi
if [ ! -f "SOUL.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/SOUL.md.template" SOUL.md
  echo "  ✓ Created SOUL.md (from template; please fill in growth preferences)"
fi
if [ ! -f "constitution.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/constitution.md.template" constitution.md
  echo "  ✓ Created constitution.md (from template)"
fi

# Create the docs/ directory structure (only directories required by the growth framework; product/design/engineering belong to other harness family members)
echo "→ Creating docs/ directory..."
mkdir -p docs/content docs/seo docs/experiment docs/operations docs/handoff

# Initialize GROWTH_STRATEGY.md from template (if it doesn't exist)
if [ ! -f "docs/operations/GROWTH_STRATEGY.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/GROWTH_STRATEGY.md.template" docs/operations/GROWTH_STRATEGY.md
  echo "  ✓ Initialized docs/operations/GROWTH_STRATEGY.md (from template; please fill in growth strategy)"
fi

# Copy handoff document templates (if the template repository has them)
if [ -d "$TEMPLATE_DIR/docs/handoff" ]; then
  cp -r "$TEMPLATE_DIR/docs/handoff/." docs/handoff/ 2>/dev/null || true
  echo "  ✓ Copied docs/handoff/ handoff protocol documents"
fi

# Create runtime directories (not committed, but required at runtime)
echo "→ Creating runtime directories..."
mkdir -p .harness/memory/archives .harness/loops/specs

# Initialize progress.md from template (if it doesn't exist)
if [ ! -f ".harness/memory/progress.md" ]; then
  cp .harness/templates/progress.md.template .harness/memory/progress.md
  echo "  ✓ Initialized .harness/memory/progress.md"
fi

# Clean up the temporary directory (only in remote mode; safe approach: validate path prefix before using rm -r)
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ] && [[ "$TEMP_DIR" == .harness-growth-tmp-* ]]; then
    rm -r -- "$TEMP_DIR"
fi

echo ""
echo "✓ Installation complete"
echo ""
echo "Next steps:"
echo "  1. Edit constitution.md to fill in project-specific principles"
echo "  2. Edit growth preferences in SOUL.md"
echo "  3. Edit docs/operations/GROWTH_STRATEGY.md to fill in growth strategy"
echo "  4. Have the AI Agent read AGENTS.md to start working"
echo ""
echo "⚠️ Windows CRLF guidance:"
echo "  On Windows, core.autocrlf=true will turn .sh scripts into CRLF,"
echo "  and Git Bash will fail on CRLF scripts with /bin/bash^M: bad interpreter"
echo "  Solutions:"
echo "    1. git config core.autocrlf false (disable auto-conversion)"
echo "    2. Or add a .gitattributes in the project root to force *.sh to use LF (recommended)"
echo ""
