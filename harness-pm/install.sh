#!/bin/bash
# install.sh — harness-pm cold-start install script
#
# Usage (two-step install, follows security rules — no curl | bash):
#   curl -o install.sh https://raw.githubusercontent.com/<user>/harness-pm/main/install.sh
#   # Review install.sh contents
#   bash install.sh
#
# Purpose: Initialize the .harness/ framework into the current project and configure the PM working environment

set -e

echo "=== harness-pm cold-start install ==="
echo ""

# Check whether .harness/ already exists in the current directory
if [ -d ".harness" ]; then
  echo "BLOCK: .harness/ already exists in the current directory; appears already initialized"
  echo "To reinstall, please delete .harness/ first or switch to another directory"
  exit 1
fi

# Check whether we are inside the harness-pm repository itself (by checking .harness/skills/pm/)
if [ -d ".harness/skills/pm" ] && [ -f "AGENTS.md" ]; then
  echo "Detected that we are inside the harness-pm repository; skipping clone and initializing directly"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  TEMPLATE_DIR="$SCRIPT_DIR"
else
  # Check git
  if ! command -v git >/dev/null 2>&1; then
    echo "BLOCK: git not found; please install Git first"
    exit 1
  fi

  REPO_URL="https://github.com/LuckyOneTwoThree/harness-pm.git"
  TEMPLATE_BRANCH="main"
  TEMP_DIR=".harness-pm-tmp-$$"

  # Shallow-clone the template repository into a temporary directory
  echo "→ Cloning template repository..."
  git clone --depth 1 -b "$TEMPLATE_BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
    echo "BLOCK: Clone failed; check network or repository URL: $REPO_URL"
    exit 1
  }
  TEMPLATE_DIR="$TEMP_DIR"
fi

# Copy .harness/ to the current directory (including pm skills)
echo "→ Copying .harness/ framework..."
cp -r "$TEMPLATE_DIR/.harness" .harness
echo "  ✓ Copied .harness/skills/pm/ (82 PM skills)"

# Copy AGENTS.md and SOUL.md templates (if they don't exist)
if [ ! -f "AGENTS.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/AGENTS.md.template" AGENTS.md
  echo "  ✓ Created AGENTS.md (from template; please fill in [project name])"
fi
if [ ! -f "SOUL.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/SOUL.md.template" SOUL.md
  echo "  ✓ Created SOUL.md (from template; please fill in [username] and product preferences)"
fi
if [ ! -f "constitution.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/constitution.md.template" constitution.md
  echo "  ✓ Created constitution.md (from template)"
fi

# Create the docs/ directory structure (required by the PM framework)
echo "→ Creating docs/ directory..."
mkdir -p docs/discovery docs/strategy docs/product docs/metrics docs/growth docs/monitoring docs/project docs/handoff

# Initialize PRODUCT_STRATEGY.md from template (if it doesn't exist)
if [ ! -f "docs/strategy/PRODUCT_STRATEGY.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/PRODUCT_STRATEGY.md.template" docs/strategy/PRODUCT_STRATEGY.md
  echo "  ✓ Initialized docs/strategy/PRODUCT_STRATEGY.md (from template; please fill in product strategy)"
fi

# Initialize PRD.md skeleton from template (if it doesn't exist)
if [ ! -f "docs/product/PRD.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/PRD.md.template" docs/product/PRD.md
  echo "  ✓ Initialized docs/product/PRD.md (skeleton; to be filled by design-prd skill)"
fi

# Copy handoff document templates
if [ -d "$TEMPLATE_DIR/docs/handoff" ]; then
  cp -r "$TEMPLATE_DIR/docs/handoff/." docs/handoff/ 2>/dev/null || true
  echo "  ✓ Copied docs/handoff/ handoff protocol documents"
fi

# Create runtime directories (not committed, but required at runtime)
echo "→ Creating runtime directories..."
mkdir -p .harness/memory/archives .harness/loops/specs .harness/gates
mkdir -p output/approvals output/phase-reports output/metrics

# Initialize progress.md from template (if it doesn't exist)
if [ ! -f ".harness/memory/progress.md" ]; then
  cp .harness/templates/progress.md.template .harness/memory/progress.md
  echo "  ✓ Initialized .harness/memory/progress.md"
fi

# Clean up the temporary directory (safe approach: validate path prefix before using rm -r)
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ] && [[ "$TEMP_DIR" == .harness-pm-tmp-* ]]; then
    rm -r -- "$TEMP_DIR"
fi

echo ""
echo "✓ Installation complete"
echo ""
echo "Next steps:"
echo "  1. Edit constitution.md to fill in project-specific principles"
echo "  2. Edit [username] and product preferences in SOUL.md"
echo "  3. Have the AI Agent read AGENTS.md to start working"
echo "  4. Run the setup workflow to guide filling in PRODUCT_STRATEGY.md"
echo ""
echo "Tips:"
echo "  - The .harness/skills/pm/ directory contains 82 PM skills"
echo "  - Tell the Agent 'I want to build a new product' to enter the new-product workflow"
echo "  - Tell the Agent 'existing product needs iteration' to enter the iteration workflow"
echo ""
echo "⚠️ Windows CRLF guidance:"
echo "  On Windows, core.autocrlf=true will turn .sh scripts into CRLF,"
echo "  and Git Bash will fail on CRLF scripts with /bin/bash^M: bad interpreter"
echo "  Solutions:"
echo "    1. git config core.autocrlf false (disable auto-conversion)"
echo "    2. Or add a .gitattributes in the project root to force *.sh to use LF (recommended)"
echo ""
