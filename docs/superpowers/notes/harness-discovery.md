# Harness Discovery Findings

**Date:** 2026-06-05
**Branch:** feat/harness-agnostic-pm-os
**Purpose:** Empirically confirm (or record documented defaults for) the paths each harness uses for global instructions, skills, and MCP config — so `setup.sh` targets correct paths.

---

## Summary table

| Harness | Instructions path | Skills path | MCP path | Verified? |
|---------|-------------------|-------------|----------|-----------|
| **Claude Code** | `~/.claude/CLAUDE.md` (symlink active) + `~/.claude/AGENTS.md` (will be added by new `setup.sh`) | `~/.claude/skills/<name>/` | `.mcp.json` at repo root (auto-discovered by Claude Code when inside the repo) | **Empirically verified** |
| **Codex CLI** | `~/.codex/AGENTS.md` | `~/.codex/agents/skills/<name>/` | `~/.codex/config.toml` (`[mcp_servers.<name>]` tables) | Default — confirm on first use (Codex not installed) |
| **Cursor** | Project rules: `.cursor/rules/<name>.mdc`; User/global rules: Cursor Settings UI (not file-symlinkable) | `~/.cursor/skills/<name>/` (`cursor-agent` CLI; auto-invoked by `description`, no slash/`$` command) | `~/.cursor/mcp.json` (same JSON schema as repo `.mcp.json`) | **Empirically verified** — `cursor-agent` CLI installed; MCP + skills symlinked by `setup.sh cursor` |

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

```
$ ls -la ~/.codex
codex not installed — using documented defaults
```

Codex CLI is **not installed** on this machine. Recording documented defaults:

- **Global instructions:** `~/.codex/AGENTS.md`
- **Skills dir:** `~/.codex/agents/skills/<name>/`
- **MCP + runtime config:** `~/.codex/config.toml` (`[mcp_servers.<name>]` tables, HTTP MCP via `url = "..."`)

These defaults are sourced from the Codex CLI documentation and the reference monorepo pattern described in the design spec. Confirm empirically on first Codex install.

### Step 3: Cursor paths

```
$ ls -la ~/.cursor
drwxr-xr-x  11 sebastian  staff   352  (exists — Cursor.app is installed)
```

Cursor editor (`/Applications/Cursor.app`) is installed. The `~/.cursor/` directory exists with the standard Cursor config layout. Key observations:

- **`~/.cursor/mcp.json` does not exist** — confirms `setup.sh cursor` will create it (not overwrite an existing file).
- **`~/.cursor/skills/` is where the `cursor-agent` CLI discovers personal skills** — `<name>/SKILL.md` layout, same as Claude Code. `setup.sh cursor` symlinks the portable PM OS skills here. (Superseded earlier note: the original design assumed Cursor had no skills-dir mechanism; the `cursor-agent` CLI, installed later, does.) Cursor auto-invokes skills from their `description` — there is no slash/`$` command syntax.
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

2. **Codex (`setup.sh codex`):** Use documented defaults. Link `AGENTS.md` → `~/.codex/AGENTS.md`, `harness/codex/config.toml` → `~/.codex/config.toml`, skills → `~/.codex/agents/skills/<name>`. Confirm MCP format (HTTP `url =`) on first real Codex run — if Codex requires stdio `command =` instead of `url =`, update `harness/codex/config.toml`.

3. **Cursor (`setup.sh cursor`):** Link `.mcp.json` → `~/.cursor/mcp.json`. No global-rules symlink (use Settings UI). Project rule in `harness/cursor/rules/pm-os.mdc` applies when repo is open in Cursor. No changes needed from plan.
