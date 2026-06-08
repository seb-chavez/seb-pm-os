#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
SCRATCH="$(mktemp -d)"
fail() { echo "FAIL: $1"; exit 1; }

# 1. Install all three harnesses into the scratch HOME.
HOME="$SCRATCH" "$REPO/setup.sh" claude >/dev/null
HOME="$SCRATCH" "$REPO/setup.sh" codex  >/dev/null
HOME="$SCRATCH" "$REPO/setup.sh" cursor >/dev/null

# 2. Symlinks resolve into the repo.
[ "$(readlink "$SCRATCH/.claude/AGENTS.md")" = "$REPO/AGENTS.md" ] || fail "claude AGENTS.md link"
[ "$(readlink "$SCRATCH/.codex/agents/skills/meeting-prep")" = "$REPO/.claude/skills/meeting-prep" ] || fail "codex skill link"
[ "$(readlink "$SCRATCH/.cursor/mcp.json")" = "$REPO/.mcp.json" ] || fail "cursor mcp link"

# 3. Idempotency: re-running reports skips, creates no .backup files.
out="$(HOME="$SCRATCH" "$REPO/setup.sh" claude)"
echo "$out" | grep -q "already linked" || fail "claude not idempotent"
find "$SCRATCH" -name "*.backup.*" | grep -q . && fail "unexpected backup on re-run" || true

# 4. Drift proof: editing through the codex skill path changes the repo file.
probe="$SCRATCH/.codex/agents/skills/meeting-prep/SKILL.md"
marker="verify-marker-$$"
printf '\n<!-- %s -->\n' "$marker" >> "$probe"
grep -q "$marker" "$REPO/.claude/skills/meeting-prep/SKILL.md" || fail "drift: edit did not write through"
# cleanup the probe line from the real file
git -C "$REPO" checkout -- .claude/skills/meeting-prep/SKILL.md

echo "PASS: all verification checks"
