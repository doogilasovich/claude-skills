#!/bin/bash
#
# Claude Skills Installer
# Symlinks skills, hooks, and docs to ~/.claude/
#

set -e

CLAUDE_DIR="${HOME}/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Claude Skills Installer"
echo "======================="
echo ""
echo "Source: $SCRIPT_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Backup existing directories if they're not symlinks
for dir in skills hooks docs; do
    target="$CLAUDE_DIR/$dir"
    if [ -d "$target" ] && [ ! -L "$target" ]; then
        backup="$target.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing $dir to $backup"
        mv "$target" "$backup"
    elif [ -L "$target" ]; then
        echo "Removing existing symlink: $target"
        rm "$target"
    fi
done

# Create symlinks
echo ""
echo "Creating symlinks..."
ln -sfn "$SCRIPT_DIR/skills" "$CLAUDE_DIR/skills"
ln -sfn "$SCRIPT_DIR/hooks" "$CLAUDE_DIR/hooks"
ln -sfn "$SCRIPT_DIR/docs" "$CLAUDE_DIR/docs"

echo ""
echo "Installed:"
ls -la "$CLAUDE_DIR" | grep -E "^l" | head -5

echo ""
echo "Done! Skills are now available in Claude Code."
echo ""
echo "To update later, just run: cd $SCRIPT_DIR && git pull"
