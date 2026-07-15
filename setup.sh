#!/usr/bin/env bash
set -euo pipefail

# PM Operating System - Setup Script
# Usage: ./setup.sh <harness>   where <harness> is: claude, codex, cursor, or all
# Wires the chosen harness's GLOBAL config dir to this repo (one-time per harness).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATE=$(date +%Y-%m-%d)

# Skills that are safe to expose on every harness (all current skills).
PORTABLE_SKILLS=(
  action-items
  delegate-research
  import-meeting-notes
  job-transition
  knowledge-health
  meeting-prep
  review-budget
  review-champion-user
  review-engineer
  review-executive
  review-new-hire
  review-operator
  review-optimist
  review-panel
  review-pessimist
  review-sme
  status-report
  weekly-digest
  weekly-priorities
)

backed_up=()
linked=()
skipped=()

ensure_mcp_json() {
  local mcp="$SCRIPT_DIR/.mcp.json"
  local example="$SCRIPT_DIR/.mcp.json.example"
  if [ -f "$mcp" ]; then
    return
  fi
  if [ ! -f "$example" ]; then
    echo "Missing $mcp and $example — cannot configure MCP." >&2
    exit 1
  fi
  cp "$example" "$mcp"
  echo "Created $mcp from .mcp.json.example — authenticate MCP servers on first use."
}

backup_and_link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    skipped+=("$dest (already linked)")
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup
    # Never leave backups inside a skills/ tree — Cursor scans that dir at startup.
    if [[ "$dest" == */skills/* ]]; then
      local backup_root="${dest%/skills/*}/skills-backups"
      mkdir -p "$backup_root"
      backup="$backup_root/$(basename "$dest").backup.${DATE}"
    else
      backup="${dest}.backup.${DATE}"
    fi
    mv "$dest" "$backup"
    backed_up+=("$dest -> $backup")
  fi
  ln -s "$src" "$dest"
  linked+=("$dest -> $src")
}

prune_stale_skill_backups() {
  local skills_dir="$1"
  [ -d "$skills_dir" ] || return 0
  local entry
  for entry in "$skills_dir"/*.backup.*; do
    # Broken symlinks fail -e; harnesses still scan them and break discovery.
    [ -e "$entry" ] || [ -L "$entry" ] || continue
    rm -rf "$entry"
    backed_up+=("removed stale $entry")
  done
}

link_portable_skills() {
  local target_dir="$1"
  mkdir -p "$target_dir"
  # Old setup.sh left *.backup.* inside skills/; harnesses scan that tree and
  # can fail discovery when those symlinks point at deleted paths.
  prune_stale_skill_backups "$target_dir"
  local name
  for name in "${PORTABLE_SKILLS[@]}"; do
    backup_and_link "$SCRIPT_DIR/skills/$name" "$target_dir/$name"
  done
}

link_project_skills_dir() {
  local dest="$1"
  local src="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    skipped+=("$dest (already linked)")
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup
    backup="${dest}.backup.${DATE}"
    mv "$dest" "$backup"
    backed_up+=("$dest -> $backup")
  fi
  ln -s "$src" "$dest"
  linked+=("$dest -> $src")
}

usage() {
  echo "Usage: ./setup.sh <harness>"
  echo "Supported harnesses: claude, codex, cursor, all"
}

setup_claude() {
  local d="$HOME/.claude"
  mkdir -p "$d/memory"
  backup_and_link "$SCRIPT_DIR/AGENTS.md" "$d/AGENTS.md"
  backup_and_link "$SCRIPT_DIR/harness/claude/CLAUDE.md" "$d/CLAUDE.md"
  backup_and_link "$SCRIPT_DIR/harness/claude/settings.json" "$d/settings.json"
  backup_and_link "$SCRIPT_DIR/harness/claude/statusline-command.sh" "$d/statusline-command.sh"
  backup_and_link "$SCRIPT_DIR/memory/doc-formatting.md" "$d/memory/doc-formatting.md"
  backup_and_link "$SCRIPT_DIR/memory/writing-style.md" "$d/memory/writing-style.md"
  link_portable_skills "$d/skills"
}

setup_codex() {
  local d="$HOME/.codex"
  mkdir -p "$d"
  backup_and_link "$SCRIPT_DIR/AGENTS.md" "$d/AGENTS.md"
  backup_and_link "$SCRIPT_DIR/harness/codex/config.toml" "$d/config.toml"
  # Codex discovers skills in ~/.codex/skills/<name>/SKILL.md (alongside its
  # built-in .system skills). Not ~/.codex/agents/skills — that dir is ignored.
  link_portable_skills "$d/skills"
}

setup_cursor() {
  local d="$HOME/.cursor"
  mkdir -p "$d"
  ensure_mcp_json
  # Cursor reads MCP from ~/.cursor/mcp.json (same schema as repo .mcp.json).
  backup_and_link "$SCRIPT_DIR/.mcp.json" "$d/mcp.json"
  # Cursor discovers personal skills in ~/.cursor/skills/<name>/SKILL.md (same
  # <name>/SKILL.md layout the skills already use). IDE chat: /name in the slash
  # menu. Terminal: run `agent`, then /name inside the session (or `agent "/name"`).
  # Never use ~/.cursor/skills-cursor — that dir is reserved for Cursor's built-in skills.
  link_portable_skills "$d/skills"
  # Project-level skills (.cursor/skills/) — IDE Agent chat discovers these when this
  # repo is open. User-level ~/.cursor/skills/ alone is sometimes not enough for /name.
  # Project skills: one symlink to skills/ (picker indexes real paths better than per-skill symlinks).
  link_project_skills_dir "$SCRIPT_DIR/.cursor/skills" "$SCRIPT_DIR/skills"
  # Terminal CLI indexes plugin skills for the / menu (same path as toolshed).
  # Use a minimal plugin package — not the whole repo — so discovery matches cache plugins.
  local local_plugins="$d/plugins/local"
  mkdir -p "$local_plugins"
  backup_and_link "$SCRIPT_DIR/harness/cursor/plugin" "$local_plugins/seb-pm-os"
  echo "Cursor: open this repo so AGENTS.md loads as project instructions."
  echo "        Reload the window (Cmd+Shift+P → Developer: Reload Window) if /skills do not appear yet."
  echo "        For PM context outside this repo, add a short AGENTS.md pointer in Cursor Settings > User Rules once."
  echo "Cursor terminal: quit any running \`agent\` session, then \`cd\` to this repo and run \`agent\`."
  echo "        Type \`/action-items\` in the slash menu (or \`agent \"/action-items\"\` one-shot)."
  echo "        Restart \`agent\` after setup or skill changes — CLI does not hot-reload skills."
}

print_summary() {
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
    all)
      setup_claude
      setup_codex
      setup_cursor
      ;;
    *) echo "Unknown harness: $harness"; echo ""; usage; exit 1 ;;
  esac

  print_summary
}

main "$@"
