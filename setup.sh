#!/usr/bin/env bash
set -euo pipefail

# PM Operating System - Setup Script
# Symlinks Claude Code config files from this repo into ~/.claude/

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
DATE=$(date +%Y-%m-%d)

backed_up=()
linked=()
skipped=()

backup_and_link() {
    local src="$1"
    local dest="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # If destination exists and is already a symlink to our source, skip
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        skipped+=("$dest (already linked)")
        return
    fi

    # If destination exists (file or different symlink), back it up
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local backup="${dest}.backup.${DATE}"
        mv "$dest" "$backup"
        backed_up+=("$dest -> $backup")
    fi

    # Create symlink
    ln -s "$src" "$dest"
    linked+=("$dest -> $src")
}

echo "PM Operating System - Setup"
echo "==========================="
echo ""

# Ensure ~/.claude/ and ~/.claude/memory/ exist
mkdir -p "$CLAUDE_DIR/memory"

# Symlink each config file
backup_and_link "$SCRIPT_DIR/claude-config/settings.json" "$CLAUDE_DIR/settings.json"
backup_and_link "$SCRIPT_DIR/claude-config/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
backup_and_link "$SCRIPT_DIR/claude-config/memory/doc-formatting.md" "$CLAUDE_DIR/memory/doc-formatting.md"

# Print summary
echo "Setup complete!"
echo ""

if [ ${#linked[@]} -gt 0 ]; then
    echo "Linked:"
    for item in "${linked[@]}"; do
        echo "  $item"
    done
    echo ""
fi

if [ ${#backed_up[@]} -gt 0 ]; then
    echo "Backed up (originals preserved):"
    for item in "${backed_up[@]}"; do
        echo "  $item"
    done
    echo ""
fi

if [ ${#skipped[@]} -gt 0 ]; then
    echo "Skipped (already correct):"
    for item in "${skipped[@]}"; do
        echo "  $item"
    done
    echo ""
fi

echo "Your Claude Code config is now managed from: $SCRIPT_DIR"
echo "Templates are available at: $SCRIPT_DIR/templates/"
