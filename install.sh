#!/bin/bash

# beads-in-ralph installer
# Installs workflow commands for Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Installing beads-in-ralph"
echo "============================"
echo ""

# Determine installation location
if [ "$1" = "--global" ] || [ "$1" = "-g" ]; then
    INSTALL_DIR="$HOME/.claude/commands"
    INSTALL_TYPE="global (user-level)"
else
    INSTALL_DIR=".claude/commands"
    INSTALL_TYPE="project-level"
fi

echo "📁 Installation type: $INSTALL_TYPE"
echo "📂 Installation directory: $INSTALL_DIR"
echo ""

# Create directory
mkdir -p "$INSTALL_DIR"

# Copy command files
echo "📋 Copying command files..."

cp "$SCRIPT_DIR/.claude/commands/ideate-and-build.md" "$INSTALL_DIR/" 2>/dev/null || \
cp "$SCRIPT_DIR/ideate-and-build.md" "$INSTALL_DIR/" 2>/dev/null || \
echo "   ⚠️  ideate-and-build.md not found in expected locations"

cp "$SCRIPT_DIR/.claude/commands/specs-to-ralph.md" "$INSTALL_DIR/" 2>/dev/null || \
cp "$SCRIPT_DIR/specs-to-ralph.md" "$INSTALL_DIR/" 2>/dev/null || \
echo "   ⚠️  specs-to-ralph.md not found in expected locations"

cp "$SCRIPT_DIR/.claude/commands/workflow-status.md" "$INSTALL_DIR/" 2>/dev/null || \
cp "$SCRIPT_DIR/workflow-status.md" "$INSTALL_DIR/" 2>/dev/null || \
echo "   ⚠️  workflow-status.md not found in expected locations"

echo ""
echo "✅ Installation complete!"
echo ""
echo "📚 Available commands:"
echo "   /project:ideate-and-build  - Full workflow: iterate → beads → ralph"
echo "   /project:specs-to-ralph    - Convert specs to beads and launch ralph"
echo "   /project:workflow-status   - Check beads and ralph status"
echo ""

# Check prerequisites
echo "🔍 Checking prerequisites..."
echo ""

if command -v bd &> /dev/null; then
    echo "   ✅ Beads (bd) is installed: $(bd --version 2>/dev/null || echo 'version unknown')"
else
    echo "   ❌ Beads (bd) not found. Install with:"
    echo "      curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash"
fi

if command -v ralph &> /dev/null; then
    echo "   ✅ Ralph is installed"
else
    echo "   ❌ Ralph not found. Install with:"
    echo "      git clone https://github.com/frankbria/ralph-claude-code.git"
    echo "      cd ralph-claude-code && ./install.sh"
fi

if command -v tmux &> /dev/null; then
    echo "   ✅ tmux is installed"
else
    echo "   ⚠️  tmux not found (optional, for ralph monitoring)"
fi

echo ""
echo "🎉 You're all set! Start Claude Code and try:"
echo "   /project:ideate-and-build Your amazing idea here"
echo ""
