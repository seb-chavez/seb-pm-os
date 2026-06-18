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

# 4. Drift proof: editing through the codex skill path changes the repo file.
probe="$SCRATCH/.codex/skills/meeting-prep/SKILL.md"
marker="verify-marker-$$"
printf '\n<!-- %s -->\n' "$marker" >> "$probe"
grep -q "$marker" "$REPO/skills/meeting-prep/SKILL.md" || fail "drift: edit did not write through"
# cleanup the probe line from the real file
git -C "$REPO" checkout -- skills/meeting-prep/SKILL.md

echo "PASS: all verification checks"
