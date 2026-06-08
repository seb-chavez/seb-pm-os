# Harness-Agnostic PM OS Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor `seb-pm-os` so the same PM workflows run on Claude Code, Codex CLI, and Cursor from one source of truth, switched by a one-time `./setup.sh <harness>` per harness.

**Architecture:** A canonical, harness-neutral `AGENTS.md` holds the PM "brain"; skills stay single-sourced in `.claude/skills/` and are symlinked into each harness's global dir; thin per-harness overlays live under `harness/<name>/`; `setup.sh <harness>` wires the chosen harness's global config to the repo. The recording feature is deleted.

**Tech Stack:** Markdown (instructions/skills), Bash (`setup.sh`, verification scripts), TOML (Codex config), JSON (MCP config). No application code or test framework — "tests" are verification commands (file/symlink/grep assertions) run against a scratch `HOME`.

**Spec:** `docs/superpowers/specs/2026-06-05-harness-agnostic-pm-os-design.md`

**Branch:** `feat/harness-agnostic-pm-os` (already checked out).

---

## Scope note

This is one cohesive refactor, not independent subsystems — the installer depends on the restructure, so it stays a single plan. Tasks are ordered to land low-risk, fully-known changes first (deletion, content split) before the harness-discovery-dependent installer work. Tasks 1–5 require no knowledge of Codex/Cursor internals. Task 6 empirically confirms the few harness mechanics that the spec flagged as "verified during implementation"; Tasks 7–9 build on those findings.

## File structure

**Delete:**
- `.claude/skills/setup-recording/`, `.claude/skills/start-recording/`, `.claude/skills/stop-recording/`
- `docs/superpowers/plans/2026-04-30-native-meeting-recorder.md`
- `docs/superpowers/specs/2026-04-30-native-meeting-recorder-design.md`

**Create:**
- `AGENTS.md` (root) — canonical PM brain + repo conventions
- `harness/codex/config.toml` — Codex runtime + MCP
- `harness/cursor/rules/pm-os.mdc` — Cursor project rule referencing `AGENTS.md`
- `scripts/verify-setup.sh` — automated symlink/idempotency/drift checks

**Move (via `git mv`):**
- `claude-config/` → `harness/claude/` (keeps `CLAUDE.md`, `settings.json`, `statusline-command.sh`, `memory/doc-formatting.md`)

**Modify:**
- `.claude/skills/delegate-research/SKILL.md` — advisory, harness-neutral
- `.claude/skills/import-meeting-notes/SKILL.md` — Granola-only
- `harness/claude/CLAUDE.md` — thin: `@AGENTS.md` + Claude-only overlay
- `CLAUDE.md` (root) — thin pointer to `AGENTS.md`
- `.gitignore` — drop recorder data rules
- `setup.sh` — take a `<harness>` argument
- `README.md` — new layout + `setup.sh <harness>` usage

---

### Task 1: Remove the recording feature

**Files:**
- Delete: `.claude/skills/setup-recording/`, `.claude/skills/start-recording/`, `.claude/skills/stop-recording/`
- Delete: `docs/superpowers/plans/2026-04-30-native-meeting-recorder.md`, `docs/superpowers/specs/2026-04-30-native-meeting-recorder-design.md`
- Modify: `.gitignore`

- [ ] **Step 1: Delete the three recording skill directories**

```bash
git rm -r .claude/skills/setup-recording .claude/skills/start-recording .claude/skills/stop-recording
```

- [ ] **Step 2: Delete the two historical recorder docs**

```bash
git rm docs/superpowers/plans/2026-04-30-native-meeting-recorder.md docs/superpowers/specs/2026-04-30-native-meeting-recorder-design.md
```

- [ ] **Step 3: Remove the recorder block from `.gitignore`**

Delete these four lines (currently lines 14–17):

```
# Native meeting recorder data
data/models/
data/recordings/
data/transcripts/
```

- [ ] **Step 4: Verify the deletions and check for dangling references**

Run:
```bash
ls .claude/skills | grep -c recording   # expect 0
grep -rn -e "data/transcripts" -e "data/recordings" -e "BlackHole" -e "whisper" --include="*.md" --include="*.json" --exclude-dir=.git . | grep -v docs/superpowers/specs/2026-06-05
```
Expected: the only remaining hit is in `.claude/skills/import-meeting-notes/SKILL.md` (handled in Task 2). `README.md` should produce **no** hits (it never documented the recorder). If anything else appears, note it for cleanup.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "feat: remove native meeting recorder feature"
```

---

### Task 2: Strip `import-meeting-notes` to Granola-only

**Files:**
- Modify: `.claude/skills/import-meeting-notes/SKILL.md`

- [ ] **Step 1: Replace the frontmatter description (line 3)**

Old:
```
description: Use when the user wants to import, pull, or review meeting notes from Granola or local recordings. Triggers on phrases like "import meeting notes", "check my recent meetings", "pull notes from my sync", "import transcript", or any request involving meeting notes from Granola or local recordings.
```
New:
```
description: Use when the user wants to import, pull, or review meeting notes from Granola. Triggers on phrases like "import meeting notes", "check my recent meetings", "pull notes from my sync", or any request involving Granola meeting notes.
```

- [ ] **Step 2: Replace the Overview (line 10)**

Old:
```
Pulls meeting content from available sources (Granola MCP or local transcripts from `/stop-recording`), synthesizes key details, and routes them to the appropriate knowledge folders. The goal is structured context, not raw transcripts.
```
New:
```
Pulls meeting content from the Granola MCP, synthesizes key details, and routes them to the appropriate knowledge folders. The goal is structured context, not raw transcripts.
```

- [ ] **Step 3: Replace the "When NOT to use" bullets (lines 14–16)**

Old:
```
- The user wants to write notes manually
- Notes aren't from Granola or a local recording (e.g., pasting from another tool)
- The user just wants to read a transcript without importing
```
New:
```
- The user wants to write notes manually
- Notes aren't from Granola (e.g., pasting from another tool)
- The user just wants to read a meeting summary without importing
```

- [ ] **Step 4: Replace the entire "## Sources" section (lines 18–31) with a Granola-only version**

New section body (replaces everything from `## Sources` through the source-priority list, up to but not including `## Tracking imported meetings`):

```markdown
## Source

This skill imports from the **Granola MCP**. Call the Granola MCP tool to list recent meetings; each returns a summary with attendees, date, and AI-generated notes. If the MCP server is not configured or returns an error, tell the user: "Granola isn't available — check that the Granola MCP server is configured."
```

- [ ] **Step 5: Update the import-log `source` field note (line 39)**

Old:
```
- `source` — `"granola"` or `"local"`
```
New:
```
- `source` — `"granola"`
```

- [ ] **Step 6: Replace Step 1 of the procedure (line 62)**

Old:
```
1. **Check available sources.** Try Granola MCP first (call the Granola tool to list recent meetings). Then check for local transcripts in `data/transcripts/` using Glob. **Load `data/imported-meetings.json`** if it exists and cross-reference against the returned meetings. Filter already-imported meetings from the picker by default (mention the count of hidden meetings so the user can opt to re-import).
```
New:
```
1. **List recent meetings.** Call the Granola MCP tool to list recent meetings. **Load `data/imported-meetings.json`** if it exists and cross-reference against the returned meetings. Filter already-imported meetings from the picker by default (mention the count of hidden meetings so the user can opt to re-import).
```

- [ ] **Step 7: Delete the local-cleanup procedure step (line 73)**

Remove this entire step:
```
8. **Clean up local source files (if applicable).** If the imported meeting came from a local transcript, ask the user whether to delete the source files (the `.wav` in `data/recordings/` and `.txt` in `data/transcripts/`). Delete if confirmed.
```

- [ ] **Step 8: Delete the local-transcripts "Common Mistakes" row (line 120)**

Remove this table row:
```
| Ignoring local transcripts when Granola is available | Always check both sources — the user may have used local recording for a meeting Granola didn't capture |
```

- [ ] **Step 9: Verify no recorder references remain**

Run:
```bash
grep -n -e "local" -e "transcript" -e "recording" -e "/start-recording" -e "/stop-recording" .claude/skills/import-meeting-notes/SKILL.md
```
Expected: no hits for `local`, `/start-recording`, `/stop-recording`, or `recording`. (The word "transcripts" may remain only in the "No raw transcripts" rule and "no transcript access" Granola note — both correct and unrelated to the recorder.)

- [ ] **Step 10: Commit**

```bash
git add .claude/skills/import-meeting-notes/SKILL.md
git commit -m "feat: make import-meeting-notes Granola-only"
```

---

### Task 3: Neutralize `delegate-research`

**Files:**
- Modify: `.claude/skills/delegate-research/SKILL.md`

- [ ] **Step 1: Replace the "## How to delegate" section (lines 32–58) up to the "### Prompt template" heading**

Replace the block that begins `## How to delegate` and the `Use the \`Task\` tool ...` table through the end of that table (the three-row table mapping research type → `subagent_type`) with:

```markdown
## How to delegate

If your harness supports sub-agent delegation, dispatch a sub-agent to do the read-heavy work so only its summary returns to the main context. The mechanism differs by harness:

- **Claude Code:** dispatch a read-only research sub-agent (an "Explore" agent for codebase exploration, a general-purpose agent for web/doc research, or a planning agent for evaluating approaches).
- **Other CLI harnesses:** use the harness's equivalent "spawn a sub-task / sub-agent" capability, if present.
- **No sub-agent support:** do the research inline in the current session — but summarize aggressively as you go instead of letting raw file or page contents pile up in the conversation.
```

Keep the `### Prompt template`, `### Parallel delegation`, `## After the sub-agent returns`, and `## Common Mistakes` sections as-is — they are already harness-neutral.

- [ ] **Step 2: Verify the Claude-only mechanics are gone**

Run:
```bash
grep -n -e "subagent_type" -e "\`Task\` tool" .claude/skills/delegate-research/SKILL.md
```
Expected: no hits.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/delegate-research/SKILL.md
git commit -m "feat: make delegate-research harness-neutral (advisory)"
```

---

### Task 4: Create the canonical `AGENTS.md`

**Files:**
- Create: `AGENTS.md` (root)
- Reference (read-only): `claude-config/CLAUDE.md`, current root `CLAUDE.md`

This consolidates the harness-neutral PM brain (from `claude-config/CLAUDE.md`) plus repo conventions (from the current root `CLAUDE.md`) into one file. The Claude-only "Minimize permission prompts" section is intentionally **excluded** here — it moves to the Claude overlay in Task 5.

- [ ] **Step 1: Seed `AGENTS.md` from the global instructions**

```bash
cp claude-config/CLAUDE.md AGENTS.md
```

- [ ] **Step 2: Change the top heading**

In `AGENTS.md`, replace the first line `# Global User Instructions` with:
```
# PM Operating System — Canonical Instructions
```
And replace the line `These rules apply to all projects and sessions.` with:
```
Harness-neutral instructions for PM work. Every harness (Claude Code, Codex, Cursor) loads this file. Harness-specific rules live in `harness/<name>/` overlays, not here.
```

- [ ] **Step 3: Delete the entire "## Minimize permission prompts" section**

Remove everything from the `## Minimize permission prompts` heading through the end of its "### When Bash is truly necessary" subsection (i.e., up to but not including `## Workflow`). This is Claude-harness-specific and moves to the overlay in Task 5.

- [ ] **Step 4: Replace the "## Context Conservation" section**

Old:
```
## Context Conservation

Prefer delegating research and exploration tasks to sub-agents to preserve main session context. Use the `Task` tool with the appropriate `subagent_type` (`Explore`, `general-purpose`, or `Plan`) instead of doing 5+ read-only tool calls in the main session. See `.claude/skills/delegate-research.md` for the full protocol.
```
New:
```
## Context Conservation

When your harness supports sub-agents, prefer delegating research and exploration to a sub-agent to preserve main-session context. Rule of thumb: if a task needs 5+ read-only tool calls just to gather information, delegate it and keep only the summary. If your harness has no sub-agent capability, research inline but summarize aggressively rather than letting raw file dumps accumulate. See the `delegate-research` skill for the full protocol.
```

- [ ] **Step 5: Append a "## Repo layout & conventions" section**

Add this at the end of `AGENTS.md` (absorbs the durable content from the current root `CLAUDE.md`):

```markdown
## Repo layout & conventions

This OS is a version-controlled toolkit cloned at each company. Key directories:

| Directory | Purpose |
|-----------|---------|
| `AGENTS.md` (root) | Canonical, harness-neutral instructions (this file) |
| `harness/<name>/` | Per-harness overlays + global payload installed by `setup.sh` |
| `.claude/skills/` | Single source for all skills (symlinked into each harness) |
| `templates/` | Document blueprints (PRD, agenda, etc.) |
| `knowledge/people|research|company/` | Stakeholder, research, and strategy notes (gitignored) |
| `projects/` | Active project folders with dated notes (gitignored) |
| `goals/`, `GOALS.md` | Quarterly goals (gitignored) |
| `data/` | Working data files (gitignored) |

Naming: meeting notes `YYYY-MM-DD-topic.md`; people files `firstname-lastname.md`; archived goals `goals/GOALS-YYYY-QN.md` (active goals stay at root as `GOALS.md`).
```

- [ ] **Step 6: Verify `AGENTS.md` is harness-neutral**

Run:
```bash
grep -n -e "Minimize permission prompts" -e "subagent_type" -e "parser-level syntax heuristics" AGENTS.md
```
Expected: no hits. The permission-prompt content and sub-agent mechanics must be absent.

- [ ] **Step 7: Commit**

```bash
git add AGENTS.md
git commit -m "feat: add canonical harness-neutral AGENTS.md"
```

---

### Task 5: Restructure `claude-config/` → `harness/claude/` + thin entrypoints

**Files:**
- Move: `claude-config/` → `harness/claude/`
- Modify: `harness/claude/CLAUDE.md`
- Modify: `CLAUDE.md` (root)

- [ ] **Step 1: Move the Claude payload into the harness overlay dir**

```bash
mkdir -p harness
git mv claude-config harness/claude
```
Verify:
```bash
ls harness/claude        # expect: CLAUDE.md  memory  settings.json  statusline-command.sh
```

- [ ] **Step 2: Rewrite `harness/claude/CLAUDE.md` as a thin overlay**

Replace its **entire** contents with the following. The body below is the Claude-only permission-prompt section (previously the top of the file) plus an `@AGENTS.md` import so the canonical brain loads too:

```markdown
# Claude Code — Local Overlay

@AGENTS.md

The canonical, harness-neutral instructions are imported above from `AGENTS.md`. The rules below are specific to the Claude Code harness.

## Minimize permission prompts

Claude Code has two independent permission gates: (1) the allowlist in `~/.claude/settings.json` and (2) parser-level syntax heuristics that cannot be disabled. The heuristics fire on certain patterns regardless of what's in the allowlist. To keep prompts to a minimum, follow these rules:

### Always prefer dedicated tools over Bash for file/content work
- Reading files → `Read` tool (never `cat`, `head`, `tail`, `sed`)
- Listing files/directories → `Glob` tool (never `ls`, `find`)
- Searching file contents → `Grep` tool (never `grep`, `rg`, `awk`)
- Editing files → `Edit` / `Write` tools (never `sed -i`, heredocs, `>`)

These tools bypass the Bash parser entirely, so they never trigger syntax heuristics or permission prompts for allowed operations.

### Avoid patterns that trigger syntax heuristics
- **Chained commands**: `&&`, `||`, `;` — split into separate tool calls when possible
- **Pipes**: `|` — use the dedicated tool, then process result in next call
- **Quoted strings in commands**: `echo "---"` — avoid decorative separators
- **Escaped special chars in paths**: `\(site\)`, `\&`, `\$` — always prompts; use Read/Glob instead
- **Redirects to subshells**: `$(...)`, `` `...` `` — inherently ambiguous to parser

### When Bash is truly necessary
- Quote paths with double quotes: `"path/with (parens)/"` instead of `path/with\ \(parens\)/`
- Prefer single-command invocations over chains
- For git/gh/package managers, use the fully allowlisted subcommands directly
```

- [ ] **Step 3: Rewrite the root `CLAUDE.md` as a thin pointer**

Replace the **entire** contents of the root `CLAUDE.md` with:

```markdown
# seb-pm-os

@AGENTS.md

The canonical instructions for this repo live in `AGENTS.md` (imported above). This file exists so harnesses that key off `CLAUDE.md` load the same instruction set as those that read `AGENTS.md` directly. Do not duplicate content here — edit `AGENTS.md`.
```

- [ ] **Step 4: Verify the import wiring and that no content is orphaned**

Run:
```bash
test -f harness/claude/CLAUDE.md && test -f harness/claude/settings.json && test -f AGENTS.md && echo OK
grep -n "@AGENTS.md" harness/claude/CLAUDE.md CLAUDE.md   # expect one hit in each
grep -n "Minimize permission prompts" harness/claude/CLAUDE.md   # expect 1 hit (overlay)
```
Expected: `OK`, an `@AGENTS.md` line in both files, and the permission section present only in the overlay.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "refactor: move claude-config to harness/claude and thin out CLAUDE.md entrypoints"
```

---

### Task 6: Confirm harness discovery mechanisms (de-risk)

The spec flagged a few harness mechanics as "confirmed during implementation." Confirm them now so `setup.sh` (Task 9) targets correct paths. Record findings inline in this task's commit message. If a harness isn't installed yet, use the documented default noted below and re-confirm on first real use.

**Files:**
- Create: `docs/superpowers/notes/harness-discovery.md` (findings record)

- [ ] **Step 1: Confirm Claude Code global discovery + `@import` resolution**

Create a scratch home and link the Claude payload the way `setup.sh` will:
```bash
SCRATCH=$(mktemp -d)
mkdir -p "$SCRATCH/.claude"
ln -s "$PWD/AGENTS.md" "$SCRATCH/.claude/AGENTS.md"
ln -s "$PWD/harness/claude/CLAUDE.md" "$SCRATCH/.claude/CLAUDE.md"
cat "$SCRATCH/.claude/CLAUDE.md"   # confirm @AGENTS.md line is present and resolvable beside it
ls -l "$SCRATCH/.claude"
```
Expected: both symlinks resolve. Record whether Claude Code resolves `@AGENTS.md` relative to `~/.claude/` (the symlink location) — if it does, linking `AGENTS.md` into `~/.claude/` alongside `CLAUDE.md` (as above) is sufficient. Note the result.

- [ ] **Step 2: Confirm Codex paths (or record documented defaults)**

If `codex` is installed, check where it reads global instructions, skills, and MCP. Record the actual paths. Documented defaults to assume otherwise:
- Global instructions: `~/.codex/AGENTS.md`
- Skills dir: `~/.codex/agents/skills/<name>/`
- MCP + runtime config: `~/.codex/config.toml` (`[mcp_servers.<name>]` tables)

```bash
ls -la ~/.codex 2>/dev/null || echo "codex not installed — using documented defaults"
```

- [ ] **Step 3: Confirm Cursor paths (or record documented defaults)**

Documented defaults to assume:
- Global MCP: `~/.cursor/mcp.json` (same JSON schema as repo `.mcp.json`)
- Project rules: `.cursor/rules/<name>.mdc`
- User (global) rules: set in Cursor Settings UI — not file-symlinkable (manual one-time paste)

```bash
ls -la ~/.cursor 2>/dev/null || echo "cursor not installed — using documented defaults"
```

- [ ] **Step 4: Record findings**

Create `docs/superpowers/notes/harness-discovery.md` with a short table: for each harness, the confirmed (or assumed-default) paths for instructions, skills, and MCP, and whether each was empirically verified or is a default to confirm later.

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/notes/harness-discovery.md
git commit -m "docs: record harness discovery paths for setup.sh"
```

---

### Task 7: Create the Codex overlay

**Files:**
- Create: `harness/codex/config.toml`
- Reference: `.mcp.json` (root)

- [ ] **Step 1: Author `harness/codex/config.toml`**

Use the MCP server(s) from the repo's `.mcp.json` (currently just `granola`, an HTTP MCP). Create `harness/codex/config.toml`:

```toml
# Codex runtime config for seb-pm-os.
# Installed to ~/.codex/config.toml by `./setup.sh codex`.
# MCP servers mirror the repo's .mcp.json.

[mcp_servers.granola]
url = "https://mcp.granola.ai/mcp"
```

If Task 6 confirmed Codex requires a different MCP schema (e.g. `command`-based stdio rather than `url`), substitute the confirmed format here and note it in `harness-discovery.md`.

- [ ] **Step 2: Verify TOML is well-formed**

Run:
```bash
python3 -c "import tomllib,sys; tomllib.load(open('harness/codex/config.toml','rb')); print('TOML OK')"
```
Expected: `TOML OK`.

- [ ] **Step 3: Commit**

```bash
git add harness/codex/config.toml
git commit -m "feat: add Codex harness overlay (config.toml + MCP)"
```

---

### Task 8: Create the Cursor overlay

**Files:**
- Create: `harness/cursor/rules/pm-os.mdc`

- [ ] **Step 1: Author the Cursor project rule**

Create `harness/cursor/rules/pm-os.mdc`:

```mdc
---
description: PM Operating System canonical instructions
alwaysApply: true
---

The canonical, harness-neutral PM instructions for this workspace live in `AGENTS.md` at the repo root. Read and follow `AGENTS.md` for all PM work in this repo: document templates, meeting-note routing, workflow rules, and the skills index.

Skills under `.claude/skills/<name>/SKILL.md` are playbooks. When the user asks to run one (e.g. "run the meeting-prep playbook"), read that skill's `SKILL.md` and follow its steps. Cursor does not expose these as slash-commands.
```

- [ ] **Step 2: Verify frontmatter + reference**

Run:
```bash
test -f harness/cursor/rules/pm-os.mdc && grep -q "AGENTS.md" harness/cursor/rules/pm-os.mdc && echo OK
```
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add harness/cursor/rules/pm-os.mdc
git commit -m "feat: add Cursor harness overlay (project rule)"
```

---

### Task 9: Rewrite `setup.sh` to take a `<harness>` argument

**Files:**
- Modify: `setup.sh`

- [ ] **Step 1: Replace `setup.sh` with the harness-aware installer**

Replace the **entire** contents of `setup.sh` with:

```bash
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
```

- [ ] **Step 2: Make it executable and run a syntax check**

Run:
```bash
chmod +x setup.sh
bash -n setup.sh && echo "syntax OK"
./setup.sh            # expect usage + non-zero exit
./setup.sh bogus      # expect "Unknown harness" + usage + non-zero exit
```
Expected: `syntax OK`; both invocations print usage and exit non-zero.

- [ ] **Step 3: Smoke-test each harness against a scratch HOME**

Run (does not touch your real `~/.claude`):
```bash
SCRATCH=$(mktemp -d)
HOME="$SCRATCH" ./setup.sh claude
HOME="$SCRATCH" ./setup.sh codex
HOME="$SCRATCH" ./setup.sh cursor
readlink "$SCRATCH/.claude/AGENTS.md"            # -> repo AGENTS.md
readlink "$SCRATCH/.claude/skills/meeting-prep"  # -> repo skill dir
readlink "$SCRATCH/.codex/agents/skills/meeting-prep"
readlink "$SCRATCH/.cursor/mcp.json"             # -> repo .mcp.json
```
Expected: every `readlink` prints a path inside this repo; no errors.

- [ ] **Step 4: Commit**

```bash
git add setup.sh
git commit -m "feat: setup.sh <harness> installs claude/codex/cursor from one source"
```

---

### Task 10: Add an automated verification script

**Files:**
- Create: `scripts/verify-setup.sh`

- [ ] **Step 1: Author `scripts/verify-setup.sh`**

Create `scripts/verify-setup.sh` — proves symlinks resolve, the install is idempotent, and edits are drift-free, all against a scratch HOME:

```bash
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
```

- [ ] **Step 2: Run it**

Run:
```bash
chmod +x scripts/verify-setup.sh
./scripts/verify-setup.sh
```
Expected: `PASS: all verification checks`.

- [ ] **Step 3: Commit**

```bash
git add scripts/verify-setup.sh
git commit -m "test: add setup verification (symlinks, idempotency, drift)"
```

---

### Task 11: Update `README.md` for the new layout

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Replace the intro + "## Setup" section (lines 3, 12–25)**

Replace line 3 intro:
```
A portable toolkit for product management work powered by Claude Code. Clone this repo at any new company, run the setup script, and get a fully configured Claude Code environment with your preferred settings, skills, and document templates.
```
with:
```
A portable, harness-agnostic toolkit for product management work. Clone this repo at any new company and wire it to whichever AI coding harness you use — Claude Code, Codex, or Cursor — from a single source of truth.
```

Replace the `## Setup` fenced block and the numbered list (lines 14–25) with:
````
```bash
git clone https://github.com/seb-chavez/seb-pm-os.git
cd seb-pm-os
./setup.sh claude    # or: ./setup.sh codex   |   ./setup.sh cursor
```

Run it once per harness you use. Each call:
1. Backs up any existing config for that harness (`.backup.YYYY-MM-DD` suffix)
2. Symlinks this repo's canonical `AGENTS.md`, skills, and that harness's overlay into the harness's global config dir
3. Prints a summary of what was linked and backed up

Because each harness reads its own global dir, all wired harnesses coexist — switching is just launching the other tool (`claude` / `codex`), no re-run needed. Re-run `setup.sh` only on a new machine, when adding a new skill, or after changing the portable-skills list.
````

- [ ] **Step 2: Replace "### What gets symlinked" + "### What stays project-local" (lines 27–40)**

Replace both subsections with:

````markdown
### What gets symlinked

`setup.sh <harness>` symlinks into that harness's global dir:

| Source (repo) | Claude Code (`~/.claude/`) | Codex (`~/.codex/`) | Cursor (`~/.cursor/`) |
|---|---|---|---|
| `AGENTS.md` | `AGENTS.md` | `AGENTS.md` | (via project rule) |
| `harness/<name>/` overlay | `CLAUDE.md`, `settings.json`, `statusline-command.sh`, `memory/` | `config.toml` | `mcp.json` |
| `.claude/skills/*` | `skills/` | `agents/skills/` | (playbooks, no symlink) |
| `.mcp.json` | (project auto-discovered) | merged into `config.toml` | `mcp.json` |

Cursor is the lightest-use target: its project rule (`harness/cursor/rules/pm-os.mdc`) applies when you open this repo in Cursor, and global PM context in arbitrary folders needs a one-time manual paste into Cursor Settings → User Rules.
````

- [ ] **Step 3: Update the "## Directory Structure" table (lines 105–106)**

Replace these two rows:
```
| `claude-config/` | Global Claude Code config (symlinked to `~/.claude/` via `setup.sh`) | No |
| `.claude/skills/` | Claude Code slash command skills | No |
```
with:
```
| `AGENTS.md` (root) | Canonical, harness-neutral instructions | No |
| `harness/<name>/` | Per-harness overlays + global payload installed by `setup.sh` | No |
| `.claude/skills/` | Single source for all skills (symlinked into each harness) | No |
```

- [ ] **Step 4: Update the "## Editing Your Config" section (lines 118–120)**

Replace its body with:
```
Since `setup.sh` uses symlinks, any change you make to `AGENTS.md`, a skill, or a `harness/<name>/` overlay is immediately live in every wired harness — edit once, no re-sync. Commit changes back to this repo to keep your config portable.
```

- [ ] **Step 5: Update Prerequisites to not imply Claude-only (lines 8–9)**

Replace:
```
- **Node.js** — required to run Claude Code
- **Claude Code** — install per [Anthropic's docs](https://docs.anthropic.com/en/docs/claude-code)
```
with:
```
- **A supported harness** — Claude Code, Codex CLI, or Cursor (install per that tool's docs)
- **Node.js** — required by most harness CLIs
```

- [ ] **Step 6: Verify README has no stale references**

Run:
```bash
grep -n -e "claude-config" -e "powered by Claude Code" -e "recording" README.md
```
Expected: no hits.

- [ ] **Step 7: Commit**

```bash
git add README.md
git commit -m "docs: update README for harness-agnostic layout and setup.sh <harness>"
```

---

## Final verification (run after all tasks)

- [ ] **Spec coverage sweep**

```bash
./scripts/verify-setup.sh                 # symlinks, idempotency, drift -> PASS
grep -rn "claude-config" --exclude-dir=.git . | grep -v docs/superpowers   # expect no hits
ls harness                                # expect: claude codex cursor
ls .claude/skills | wc -l                 # expect 11
grep -q "@AGENTS.md" CLAUDE.md harness/claude/CLAUDE.md && echo "imports OK"
```

- [ ] **Manual harness parity (do the ones you have installed)**
  - Claude Code: from the repo, confirm `/meeting-prep` still appears in the slash menu with its description preview. After `./setup.sh claude`, open a session in another directory and confirm AGENTS.md guidance is active.
  - Codex: after `./setup.sh codex`, launch `codex` from any directory; confirm it loads `AGENTS.md` and that `meeting-prep` is available; confirm the Granola MCP connects (or note the format fix from Task 6/7).
  - Cursor: open the repo in Cursor; confirm the project rule loads `AGENTS.md`; confirm MCP from `~/.cursor/mcp.json`.

- [ ] **Open the PR** (per workflow: feature branch → PR, never push to `main` directly).

---

## Notes for the implementer

- This repo has no test framework; verification is file/symlink/grep assertions. Always test `setup.sh` against a scratch `HOME=$(mktemp -d)` — never against your real `~/.claude` until the scratch run passes.
- Commit after every task (frequent commits).
- Tasks 1–5 are fully deterministic. Task 6 may surface a path/format that differs from the documented defaults; if so, update `harness/codex/config.toml` (Task 7) and the relevant `setup.sh` paths (Task 9) accordingly, and record it in `docs/superpowers/notes/harness-discovery.md`.
- Codex HTTP-MCP support and Claude `@import` resolution from a symlinked `~/.claude/CLAUDE.md` are the two highest-uncertainty spots — confirm them empirically in Task 6 before relying on them.
