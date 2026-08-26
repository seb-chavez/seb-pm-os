#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
SCRATCH="$(mktemp -d)"
fail() { echo "FAIL: $1"; exit 1; }

# 1. Install all three harnesses into the scratch HOME.
HOME="$SCRATCH" "$REPO/setup.sh" all >/dev/null

# 2. Symlinks resolve into the repo.
[ "$(readlink "$SCRATCH/.claude/AGENTS.md")" = "$REPO/AGENTS.md" ] || fail "claude AGENTS.md link"
[ "$(readlink "$SCRATCH/.claude/memory/doc-formatting.md")" = "$REPO/memory/doc-formatting.md" ] || fail "claude doc-formatting link"
[ "$(readlink "$SCRATCH/.claude/memory/writing-style.md")" = "$REPO/memory/writing-style.md" ] || fail "claude writing-style link"
[ "$(readlink "$SCRATCH/.claude/skills/meeting-prep")" = "$REPO/skills/meeting-prep" ] || fail "claude skill link"
[ "$(readlink "$SCRATCH/.codex/skills/meeting-prep")" = "$REPO/skills/meeting-prep" ] || fail "codex skill link"
[ "$(readlink "$SCRATCH/.cursor/skills/meeting-prep")" = "$REPO/skills/meeting-prep" ] || fail "cursor skill link"
[ "$(readlink "$REPO/.cursor/skills")" = "$REPO/skills" ] || fail "cursor project skills dir link"
[ "$(readlink "$SCRATCH/.cursor/plugins/local/seb-pm-os")" = "$REPO/harness/cursor/plugin" ] || fail "cursor local plugin link"
[ -f "$REPO/harness/cursor/plugin/.cursor-plugin/plugin.json" ] || fail "cursor plugin manifest missing"
[ "$(readlink "$SCRATCH/.cursor/mcp.json")" = "$REPO/.mcp.json" ] || fail "cursor mcp link"

# 3. Idempotency: re-running reports skips, creates no .backup files.
out="$(HOME="$SCRATCH" "$REPO/setup.sh" claude)"
echo "$out" | grep -q "already linked" || fail "claude not idempotent"
if find "$SCRATCH" -name "*.backup.*" | grep -q .; then
  fail "unexpected backup on re-run"
fi

# 4. Drift proof: creating a file through the codex skill path writes into the repo.
# Use a unique throwaway file so verification never overwrites an existing local edit.
marker=".verify-marker-$$"
probe="$SCRATCH/.codex/skills/meeting-prep/$marker"
repo_marker="$REPO/skills/meeting-prep/$marker"
trap 'rm -f "$repo_marker"' EXIT
printf 'verify\n' > "$probe"
[ -f "$repo_marker" ] || fail "drift: file did not write through"
rm -f "$repo_marker"
trap - EXIT

echo "PASS: all verification checks"
