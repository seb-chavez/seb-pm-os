#!/usr/bin/env bash
set -euo pipefail

# PM Operating System - Setup Script
# Usage: ./setup.sh <harness>   where <harness> is one of: claude codex cursor
# Wires the chosen harness's GLOBAL config dir to this repo (one-time per harness).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATE=$(date +%Y-%m-%d)

# Skills that are safe to expose on every harness (all current skills).
PORTABLE_SKILLS=(
  delegate-research
  import-meeting-notes
  job-transition
  knowledge-health
  meeting-prep
  review-customer
  review-devil
  review-eng
  review-exec
  status-report
  weekly-digest
)

backed_up=()
linked=()
skipped=()

backup_and_link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    skipped+=("$dest (already linked)")
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="${dest}.backup.${DATE}"
    mv "$dest" "$backup"
    backed_up+=("$dest -> $backup")
  fi
  ln -s "$src" "$dest"
  linked+=("$dest -> $src")
}

link_portable_skills() {
  local target_dir="$1"
  mkdir -p "$target_dir"
  local name
  for name in "${PORTABLE_SKILLS[@]}"; do
    backup_and_link "$SCRIPT_DIR/.claude/skills/$name" "$target_dir/$name"
  done
}

usage() {
  echo "Usage: ./setup.sh <harness>"
  echo "Supported harnesses: claude, codex, cursor"
}

setup_claude() {
  local d="$HOME/.claude"
  mkdir -p "$d/memory"
  backup_and_link "$SCRIPT_DIR/AGENTS.md" "$d/AGENTS.md"
  backup_and_link "$SCRIPT_DIR/harness/claude/CLAUDE.md" "$d/CLAUDE.md"
  backup_and_link "$SCRIPT_DIR/harness/claude/settings.json" "$d/settings.json"
  backup_and_link "$SCRIPT_DIR/harness/claude/statusline-command.sh" "$d/statusline-command.sh"
  backup_and_link "$SCRIPT_DIR/harness/claude/memory/doc-formatting.md" "$d/memory/doc-formatting.md"
  link_portable_skills "$d/skills"
}

setup_codex() {
  local d="$HOME/.codex"
  mkdir -p "$d"
  backup_and_link "$SCRIPT_DIR/AGENTS.md" "$d/AGENTS.md"
  backup_and_link "$SCRIPT_DIR/harness/codex/config.toml" "$d/config.toml"
  link_portable_skills "$d/agents/skills"
}

setup_cursor() {
  local d="$HOME/.cursor"
  mkdir -p "$d"
  # Cursor reads MCP from ~/.cursor/mcp.json (same schema as repo .mcp.json).
  backup_and_link "$SCRIPT_DIR/.mcp.json" "$d/mcp.json"
  # Project rule lives in-repo; remind the user it is workspace-scoped.
  echo "Cursor: project rule is at harness/cursor/rules/pm-os.mdc."
  echo "        Open this repo (or copy harness/cursor/rules/ into your workspace) for it to apply."
  echo "        For PM context in arbitrary folders, paste the AGENTS.md pointer into Cursor Settings > User Rules once."
}

main() {
  local harness="${1:-}"
  if [ -z "$harness" ]; then
    usage
    exit 1
  fi
  echo "PM Operating System - Setup ($harness)"
  echo "======================================"
  echo ""
  case "$harness" in
    claude) setup_claude ;;
    codex)  setup_codex ;;
    cursor) setup_cursor ;;
    *) echo "Unknown harness: $harness"; echo ""; usage; exit 1 ;;
  esac

  echo "Setup complete!"
  echo ""
  if [ ${#linked[@]} -gt 0 ]; then
    echo "Linked:"; for i in "${linked[@]}"; do echo "  $i"; done; echo ""
  fi
  if [ ${#backed_up[@]} -gt 0 ]; then
    echo "Backed up (originals preserved):"; for i in "${backed_up[@]}"; do echo "  $i"; done; echo ""
  fi
  if [ ${#skipped[@]} -gt 0 ]; then
    echo "Skipped (already correct):"; for i in "${skipped[@]}"; do echo "  $i"; done; echo ""
  fi
  echo "Config managed from: $SCRIPT_DIR"
}

main "$@"
