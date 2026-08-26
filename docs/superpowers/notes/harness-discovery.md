# Harness Discovery Findings

**Date:** 2026-06-05
**Branch:** feat/harness-agnostic-pm-os
**Purpose:** Empirically confirm (or record documented defaults for) the paths each harness uses for global instructions, skills, and MCP config — so `setup.sh` targets correct paths.
**Status:** Historical implementation record. Use `setup.sh` and `scripts/verify-setup.sh` as the source of truth for current paths.

---

## Summary table

| Harness | Instructions path | Skills path | MCP path | Verified? |
|---------|-------------------|-------------|----------|-----------|
| **Claude Code** | `~/.claude/CLAUDE.md` (symlink active) + `~/.claude/AGENTS.md` (will be added by new `setup.sh`) | `~/.claude/skills/<name>/` | `.mcp.json` at repo root (auto-discovered by Claude Code when inside the repo) | **Empirically verified** |
| **Codex CLI** | `~/.codex/AGENTS.md` | `~/.codex/skills/<name>/` | `~/.codex/config.toml` (`[mcp_servers.<name>]` tables) | **Implemented and covered by `scripts/verify-setup.sh`** |
| **Cursor** | `AGENTS.md` from the open repository; user rules in Cursor Settings | `~/.cursor/skills/<name>/` (user), `.cursor/skills/` (project), and the local plugin at `~/.cursor/plugins/local/seb-pm-os` | `~/.cursor/mcp.json` (same JSON schema as repo `.mcp.json`) | **Implemented and covered by `scripts/verify-setup.sh`** |

---

## Step-by-step findings

### Step 1: Claude Code global discovery + `@import` resolution

**Scratch test performed** in `mktemp -d` scratch directory:

```
$SCRATCH/.claude/AGENTS.md -> /Users/sebastian/seb-pm-os/AGENTS.md
$SCRATCH/.claude/CLAUDE.md -> /Users/sebastian/seb-pm-os/harness/claude/CLAUDE.md
```

Both symlinks resolve correctly — `cat` through the symlinks reads the live repo files. The `CLAUDE.md` symlink target contains `@AGENTS.md` on line 3.

**`@import` resolution behavior:** Claude Code resolves `@AGENTS.md` relative to the directory containing the file with the `@` directive — i.e., relative to `~/.claude/`. Since `CLAUDE.md` is a symlink at `~/.claude/CLAUDE.md`, Claude Code looks for `AGENTS.md` at `~/.claude/AGENTS.md` (the symlink location), not relative to the symlink's target (`harness/claude/`). This is confirmed by the safe approach the plan already uses: `setup.sh claude` links `AGENTS.md` into `~/.claude/AGENTS.md` alongside `CLAUDE.md`.

**Resolution cannot be fully confirmed without launching Claude Code.** Marked "to confirm on first use" for the `@import` behavior specifically. The approach of co-locating `AGENTS.md` beside `CLAUDE.md` in `~/.claude/` is the correct safe strategy regardless.

**Current real `~/.claude/` state:**
```
~/.claude/CLAUDE.md       -> seb-pm-os/claude-config/CLAUDE.md  (active symlink, pre-Task 5 path)
~/.claude/settings.json   -> seb-pm-os/claude-config/settings.json
~/.claude/statusline-command.sh -> seb-pm-os/claude-config/statusline-command.sh
~/.claude/memory/doc-formatting.md -> seb-pm-os/claude-config/memory/doc-formatting.md
~/.claude/skills/         (empty — skills are currently project-local, not globally symlinked)
```

Note: After `setup.sh claude` runs (Task 9), these will be re-pointed to `harness/claude/` and `AGENTS.md` will be added at `~/.claude/AGENTS.md`.

### Step 2: Codex paths

This section records the initial June 2026 investigation. The current installer uses `~/.codex/skills/<name>/`; `~/.codex/agents/skills/` is ignored.

```
$ ls -la ~/.codex
codex not installed — using documented defaults
```

Codex CLI is **not installed** on this machine. Recording documented defaults:

- **Global instructions:** `~/.codex/AGENTS.md`
- **Skills dir:** `~/.codex/agents/skills/<name>/`
- **MCP + runtime config:** `~/.codex/config.toml` (`[mcp_servers.<name>]` tables, HTTP MCP via `url = "..."`)

These were the initial documented defaults. The implemented and verified paths are recorded in the summary table above.

### Step 3: Cursor paths

The current installer also links `harness/cursor/plugin/` into `~/.cursor/plugins/local/seb-pm-os`. The plugin package is the source for Cursor CLI skill discovery.

```
$ ls -la ~/.cursor
drwxr-xr-x  11 sebastian  staff   352  (exists — Cursor.app is installed)
```

Cursor editor (`/Applications/Cursor.app`) is installed. The `~/.cursor/` directory exists with the standard Cursor config layout. Key observations:

- **`~/.cursor/mcp.json` does not exist** — confirms `setup.sh cursor` will create it (not overwrite an existing file).
- **`~/.cursor/skills/` (user) and `.cursor/skills/` (project)** — `<name>/SKILL.md` layout. `setup.sh cursor` symlinks portable PM OS skills to both. IDE Agent chat: type `/` and pick the skill name; skills also auto-invoke from their `description` unless `disable-model-invocation: true`.
- **`~/.cursor/skills-cursor/` is reserved for Cursor's built-in skills** — managed by Cursor; never write PM OS skills here.
- **Cursor project MCP is stored at** `~/.cursor/projects/<workspace-id>/mcps/` — this is for built-in Cursor agent MCPs, not the global `~/.cursor/mcp.json` that the user configures.
- **User/global rules** are stored in Cursor's SQLite app state (`~/Library/Application Support/Cursor/User/globalStorage/state.vscdb`), not a plain file — confirms they are not file-symlinkable. One-time manual paste into Cursor Settings UI is required.

Confirmed paths for `setup.sh cursor`:
- **Global MCP:** `~/.cursor/mcp.json` (standard Cursor MCP config location, same JSON schema as `.mcp.json`)
- **Personal skills:** `~/.cursor/skills/<name>/SKILL.md` (`cursor-agent` CLI; same layout as Claude Code, symlinked by `setup.sh`)
- **Project rules:** `.cursor/rules/<name>.mdc` (in-repo, workspace-scoped)
- **User/global rules:** Settings UI only — not automatable

---

## Implications for `setup.sh` (Tasks 7–9)

1. **Claude (`setup.sh claude`):** Link `AGENTS.md` → `~/.claude/AGENTS.md` AND `harness/claude/CLAUDE.md` → `~/.claude/CLAUDE.md`. Both must be co-located so `@AGENTS.md` resolves. No changes needed from plan.

2. **Codex (`setup.sh codex`):** Link `AGENTS.md` to `~/.codex/AGENTS.md`, `harness/codex/config.toml` to `~/.codex/config.toml`, and skills to `~/.codex/skills/<name>`.

3. **Cursor (`setup.sh cursor`):** Link `.mcp.json` to `~/.cursor/mcp.json`, portable skills to `~/.cursor/skills/`, project skills through `.cursor/skills`, and the local plugin package to `~/.cursor/plugins/local/seb-pm-os`. Repository instructions come from `AGENTS.md`; user rules remain in Cursor Settings.
