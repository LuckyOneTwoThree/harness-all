#!/bin/bash
# install.sh — harness-engineering cold-start install script
#
# Usage (two-step install, follows security rules — no curl | bash):
#   curl -o install.sh https://raw.githubusercontent.com/LuckyOneTwoThree/harness-engineering/main/install.sh
#   # Review install.sh contents
#   bash install.sh
#
# Purpose: Install the .harness/ template into the current directory and initialize the project
#          Local-first: if run from within harness-all/harness-engineering/, copy local files directly;
#          otherwise clone the standalone repository from GitHub.

set -e

echo "=== harness-engineering cold-start install ==="
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

# Check Node.js (hard dependency for frontend engineering/testing; WARN does not block install)
if ! command -v node >/dev/null 2>&1; then
  echo "WARN: Node.js not found. Skills such as frontend-implementation and webapp-testing hard-depend on Node. TDD itself is language-agnostic; it only needs Node when the target project is Node-based."
  echo "      Please install Node.js afterwards (v18+ recommended): https://nodejs.org/"
fi

# Detect if running from within the harness-all repo (local install)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "$SCRIPT_DIR/.harness" ]; then
  # Local install: script is inside harness-all/harness-engineering/
  echo "→ Using local framework files from: $SCRIPT_DIR"
  TEMPLATE_DIR="$SCRIPT_DIR"
  TEMP_DIR=""
else
  # Remote install: clone from GitHub (for standalone single-framework use)
  echo "→ Cloning template repository..."
  REPO_URL="https://github.com/LuckyOneTwoThree/harness-engineering.git"
  TEMPLATE_BRANCH="main"
  TEMP_DIR=".harness-engineering-tmp-$$"
  git clone --depth 1 -b "$TEMPLATE_BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
    echo "BLOCK: Clone failed; check network or repository URL: $REPO_URL"
    echo "Tip: If you already cloned harness-all, run this script from harness-all/harness-engineering/"
    exit 1
  }
  TEMPLATE_DIR="$TEMP_DIR"
fi

# Copy .harness/ to the current directory
echo "→ Copying .harness/ framework..."
cp -r "$TEMPLATE_DIR/.harness" .harness

# Copy the canonical AGENTS.md and user-owned templates (if they don't exist)
if [ ! -f "AGENTS.md" ]; then
  cp "$TEMPLATE_DIR/AGENTS.md" AGENTS.md
  echo "  ✓ Created AGENTS.md (from canonical framework rules)"
fi
if [ ! -f "SOUL.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/SOUL.md.template" SOUL.md
  echo "  ✓ Created SOUL.md (from template; please fill in tech preferences)"
fi
if [ ! -f "constitution.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/constitution.md.template" constitution.md
  echo "  ✓ Created constitution.md (from template)"
fi

# Create the docs/ directory structure (only directories required by the engineering framework; design belongs to other harness family members)
echo "→ Creating docs/ directory..."
mkdir -p docs/product docs/engineering docs/acceptance docs/handoff/archive docs/handoff/receipts docs/handoff/packages docs/decisions

# Initialize PROJECT.md and TECH_STACK.md from templates (if they don't exist)
if [ ! -f "docs/product/PROJECT.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/PROJECT.md.template" docs/product/PROJECT.md
  echo "  ✓ Initialized docs/product/PROJECT.md (from template; please fill in product requirements)"
fi
if [ ! -f "docs/engineering/TECH_STACK.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/TECH_STACK.md.template" docs/engineering/TECH_STACK.md
  echo "  ✓ Initialized docs/engineering/TECH_STACK.md (from template; please fill in the tech stack)"
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

# Clean up the temporary directory (only in remote mode; local mode has no TEMP_DIR)
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ] && [[ "$TEMP_DIR" == .harness-engineering-tmp-* ]]; then
    rm -r -- "$TEMP_DIR"
fi

# Set script executable permissions (Unix only; Windows has no chmod; hooks handled by Git Bash itself)
if command -v chmod >/dev/null 2>&1; then
  chmod +x .harness/hooks/guards/*.sh .harness/hooks/*.sh .harness/scripts/*.sh 2>/dev/null || true
  echo "  ✓ Set script executable permissions"
else
  echo "  · Windows environment: skipping chmod (hooks must run via Git Bash)"
fi

echo ""
echo "✓ Installation complete"
echo ""
echo "Next steps:"
echo "  1. Edit constitution.md to fill in project-specific principles"
echo "  2. Edit tech preferences in SOUL.md"
echo "  3. Have the AI Agent read AGENTS.md to start working"
echo "  4. Edit docs/product/PROJECT.md to fill in product requirements"
echo "  5. Edit docs/engineering/TECH_STACK.md to fill in the tech stack"
echo ""
echo "Tips: Install git hooks (optional):"
echo "  macOS/Linux:"
echo "    ln -sf ../../.harness/hooks/pre-commit.sh .git/hooks/pre-commit"
echo "    ln -sf ../../.harness/hooks/pre-push.sh .git/hooks/pre-push"
echo "    ln -sf ../../.harness/hooks/commit-msg.sh .git/hooks/commit-msg"
echo "  Windows (Git Bash):"
echo "    cp .harness/hooks/pre-commit.sh .git/hooks/pre-commit"
echo "    cp .harness/hooks/pre-push.sh .git/hooks/pre-push"
echo "    cp .harness/hooks/commit-msg.sh .git/hooks/commit-msg"
echo "    # ⚠️ Must convert line endings! Otherwise Git Bash cannot execute:"
echo "    sed -i 's/\r$//' .git/hooks/pre-commit .git/hooks/pre-push .git/hooks/commit-msg"
echo "  Windows (PowerShell):"
echo "    Copy-Item .harness/hooks/pre-commit.sh .git/hooks/pre-commit -Force"
echo "    Copy-Item .harness/hooks/pre-push.sh .git/hooks/pre-push -Force"
echo "    Copy-Item .harness/hooks/commit-msg.sh .git/hooks/commit-msg -Force"
echo "    # ⚠️ Must convert line endings! Otherwise Git Bash cannot execute:"
echo '    (Get-Content .git/hooks/pre-commit) -join "`n" | Set-Content -NoNewline .git/hooks/pre-commit'
echo '    (Get-Content .git/hooks/pre-push) -join "`n" | Set-Content -NoNewline .git/hooks/pre-push'
echo '    (Get-Content .git/hooks/commit-msg) -join "`n" | Set-Content -NoNewline .git/hooks/commit-msg'
echo ""
echo "  ⚠️ Windows note: symbolic links (ln -s) require admin privileges by default; cp is recommended instead"
echo "  ⚠️ CRLF risk: Windows core.autocrlf=true will turn .sh files into CRLF,"
echo "     and Git Bash cannot execute CRLF scripts (error: /bin/bash^M: bad interpreter)"
echo "     Solutions:"
echo "     1. The .gitattributes in the project root already forces *.sh to use LF (recommended)"
echo "     2. After copying, manually run sed -i 's/\\r$//' to convert (as above)"
echo "     3. Hook scripts have built-in CRLF self-repair logic (fallback)"
