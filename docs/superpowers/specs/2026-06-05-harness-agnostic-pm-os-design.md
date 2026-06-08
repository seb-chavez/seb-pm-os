# Design: Harness-Agnostic PM Operating System

**Date:** 2026-06-05
**Status:** Draft — pending user review
**Author:** Sebastian Chavez (with Claude)

## Problem

`seb-pm-os` is a portable PM toolkit currently optimized exclusively for **Claude Code**. Its instructions (`CLAUDE.md`), reusable workflows (`.claude/skills/`), config (`settings.json`, hooks, statusline), and `setup.sh` all assume the Claude Code harness. If the company mandates switching individuals to a different LLM/harness (e.g. Codex), the OS effectively breaks: the brain (PM workflows, knowledge, templates) is sound, but it's expressed entirely in Claude Code's dialect.

The goal is to make the OS **harness-agnostic** — separate the durable PM logic from any one harness's mechanics, so the same brain can be wired into whichever harness is mandated, with minimal per-switch effort and **zero content drift**.

## Goals

- One source of truth for PM logic (instructions, skills, templates, knowledge) — no per-harness copies.
- Support running on **Claude Code**, **Codex CLI**, and **Cursor** — one harness active at a time, swapped periodically.
- Switching harnesses is a single command: `./setup.sh <harness>`.
- Preserve the current Claude Code experience exactly (incl. `/skill` slash-commands + prefill preview).
- Reuse a proven multi-harness pattern observed in a large engineering monorepo (studied as research) rather than inventing a new abstraction.

## Non-Goals (out of scope)

- **Gemini CLI** — dropped. It's the only target requiring TOML format conversion of skills; removing it means every remaining target reads markdown skill folders, so pure symlinks suffice.
- **GitHub Copilot** and other harnesses.
- A vendor-neutral skill *DSL* or a code generator that transpiles skills between formats. We symlink shared markdown files instead (the approach used by the reference monorepo).
- New PM workflows/skills. (The recording trio is *deleted*; no new skills are added.)
- Running multiple harnesses simultaneously on the same machine (confirmed: one at a time).
- Rewriting the PM workflows themselves. This is a portability refactor, not a content rewrite.

## Background: prior art from a reference monorepo

Researched a large engineering monorepo that already runs multiple coding-agent harnesses side by side. The pattern observed:

- **`AGENTS.md` is the canonical, always-on instruction file** — every harness (Claude Code, Codex, Cursor) reads it. Hierarchical by scope (root / domain / module). No separate hand-maintained instruction file per harness for shared logic.
- **Skills authored once in `.claude/skills/` and symlinked, not regenerated.** A setup task symlinks portable skill folders into Codex's dir (`~/.codex/agents/skills/<name> → .claude/skills/<name>`), with a maintained allowlist separating ready skills from those needing fixes.
- **Thin per-harness layers**: `.mcp.json` (MCP servers), a Cursor rules file, `.codex/config.toml` (Codex runtime).
- **Setup automation** detects the repo and wires up each harness via per-harness plugins.

We mirror this pattern, scaled down to a personal repo where `setup.sh` installs into the active harness's **global** config dir (the established pattern this repo already uses for `~/.claude/`).

## Architecture

Three layers, cleanly separated:

```
┌─ CANONICAL (one source of truth, harness-neutral, git-tracked) ─┐
│  AGENTS.md            PM brain: workflow rules, Granola routing, │
│                       doc templates + Notion defaults, skills    │
│                       index, context-conservation guidance       │
│  .claude/skills/      All skills, in markdown SKILL.md format     │
│  templates/ knowledge/ projects/ goals/   (already neutral)      │
│  .mcp.json            Canonical MCP server list (stays at root)  │
├─ HARNESS OVERLAYS (thin, per-harness, git-tracked) ─────────────┤
│  harness/claude/      Claude-specific (absorbs claude-config/):  │
│                       permission-prompt rules, settings.json,    │
│                       hooks, statusline, memory/                 │
│  harness/codex/       config.toml; AGENTS.md read natively       │
│  harness/cursor/      rules that point at AGENTS.md + playbooks   │
├─ INSTALLER ─────────────────────────────────────────────────────┤
│  setup.sh <harness>   Symlinks canonical + the chosen overlay    │
│                       into that harness's global config dir       │
└──────────────────────────────────────────────────────────────────┘
```

### Component 1 — Canonical instruction file (`AGENTS.md`)

Today's `claude-config/CLAUDE.md` is **split**:

- **Canonical → `AGENTS.md`** (harness-neutral PM brain): the Workflow rules (branch/PR, no destructive git, don't commit unless asked), Granola meeting-notes routing, Document Templates + Notion defaults, the Skills index, and Context-Conservation guidance (reworded so it doesn't hard-depend on Claude Code's `Task`/sub-agent tool — phrased as "delegate research to a sub-agent if your harness supports one").
- **Claude-specific overlay → `harness/claude/`** (which absorbs today's `claude-config/` — `settings.json`, `statusline-command.sh`, `memory/`): the entire "Minimize permission prompts" section is about Claude Code's permission gates and tool names (`Read`/`Glob`/`Grep`/`Bash` parser heuristics). It is meaningless on other harnesses and moves to the Claude overlay. Adopting `harness/claude/` simply generalizes the staging convention the repo already uses with `claude-config/`.

Each harness's instruction entrypoint defers to the canonical file:
- **Claude Code:** a thin `CLAUDE.md` containing `@AGENTS.md` + the Claude overlay (Claude Code natively supports `@import` and also reads `AGENTS.md`).
- **Codex:** reads root `AGENTS.md` natively.
- **Cursor:** a rule file that references `AGENTS.md`.

### Component 2 — Skills (single source + symlinks)

- Skills stay where they are: `.claude/skills/<name>/SKILL.md`. This remains the **only** copy on disk.
- `setup.sh <harness>` creates **folder symlinks** from the harness's skills dir into the canonical location. Because it's the same bytes on disk, editing a skill through *any* harness's path writes through to the one git-tracked file — zero drift, bidirectional by construction.
  - Claude Code: skills already found in `.claude/skills/` (and/or symlinked to `~/.claude/skills/` for global use) — unchanged, retains `/skill` + prefill preview.
  - Codex: `~/.codex/agents/skills/<name> → <repo>/.claude/skills/<name>` (the same symlink mechanism observed in the reference monorepo). Codex reads markdown skill folders, so slash-invocation works; the prefill-preview UX is Claude Code-specific and not guaranteed identical.
  - Cursor: no per-skill command system → skills are reached as **playbooks** the model reads on request (degraded mode, see Component 4).

### Component 3 — Skill portability allowlist

A maintained list in the installer (mirroring the reference monorepo's two-bucket split — portable vs. needs-fixes) governs which skills get symlinked into foreign harnesses. The skill set drops from 14 to **11** once the recording trio is removed (Component 3.2). **After the `delegate-research` neutralization in Component 3.1, all 11 remaining skills are `PORTABLE`** and `NEEDS_FIXES` is empty. The two-bucket mechanism is retained for *future* skills that may introduce harness-specific dependencies.

Light tool-name references (e.g. "use the Grep tool") inside skills are acceptable — the model on another harness maps them to its own equivalent. Only *procedural* dependence on a Claude Code-only mechanism (background processes, sub-agent dispatch) forces a skill into `NEEDS_FIXES`.

### Component 3.1 — Neutralizing `delegate-research`

`delegate-research` (sub-agent dispatch) is rewritten from prescriptive to advisory. Instead of hard-coding the `Task` tool + `subagent_type`, it reads "if your harness supports sub-agent delegation, use it for multi-step research to conserve context; otherwise perform the research inline." Degrades gracefully to a no-op where sub-agents don't exist. ~10-minute reword. This is the only skill that needs neutralizing; the other previously-coupled skills (the recording trio) are deleted, not fixed.

### Component 3.2 — Removing the recording feature

The recording trio (`setup-recording`, `start-recording`, `stop-recording`) is **deleted entirely** — it's no longer needed, and it was the only harness-coupled, OS-level machinery in the repo. Deletion scope:

- **Delete** the three skill directories under `.claude/skills/`.
- **Strip `import-meeting-notes` to Granola-only**: remove its "local transcripts" source branch (the `data/transcripts/` path, the `/start-recording` guidance, and the local-source cleanup step). The skill imports solely from the Granola MCP afterward.
- **Clean up `.gitignore`**: remove the now-orphaned `data/recordings/` and `data/transcripts/` ignore rules.
- **Scrub `README.md`** of recorder references.
- **Delete the historical recorder docs**: `docs/superpowers/plans/2026-04-30-native-meeting-recorder.md` and `docs/superpowers/specs/2026-04-30-native-meeting-recorder-design.md`.

No `settings.json` change is required (it has no recorder-specific permissions; its only transcript reference is the Granola MCP tool, which stays).

### Component 4 — Cursor degraded mode

Cursor is the **lowest-priority, lightest-use** target and is explicitly degraded. It differs from the CLI harnesses in two structural ways:

1. **It's an editor, not a terminal CLI.** You open a workspace folder in the Cursor app (`cursor .`) rather than launching a global session from any directory. So the "just relaunch and it's globally on" model from the data-flow section does **not** fully apply.
2. **Its config is mostly per-project.** Project rules (`.cursor/rules/*.mdc`) are file-based and symlinkable; **user/global rules are set in Cursor's Settings UI and stored in app state — not cleanly symlinkable.**

What `setup.sh cursor` does, and the resulting floor:
- ✅ Wire **MCP** via Cursor's global `~/.cursor/mcp.json`.
- ✅ Place a `.cursor/rules/` file in the repo referencing `AGENTS.md`, so opening the `seb-pm-os` repo (or a project containing it) in Cursor loads the PM brain.
- ⚠️ For PM instructions to be on in *arbitrary* folders, the user either works inside the repo or pastes the `AGENTS.md` pointer into Cursor's **User Rules once, by hand** (the one step that can't be symlinked).
- ❌ **No slash-command skills, no prefill preview.** Skills are invoked by natural-language reference ("run the meeting-prep playbook for Dean"); the model reads the relevant `SKILL.md` and follows it. This is the accepted floor for Cursor.

### Component 5 — MCP config

- Canonical list **stays at repo root as `.mcp.json`** (today's content: Granola, plus whatever's added). Keeping it at root preserves Claude Code's in-repo auto-discovery when maintaining the OS itself; MCP placement is intentionally independent of the `harness/` grouping used for overlays.
- `setup.sh <harness>` writes/symlinks it to each harness's expected MCP location/format. Claude Code and Codex both consume MCP; mapping is config-location translation, not a rewrite. Cursor MCP support is wired if available, else skipped.

### Component 6 — Installer (`setup.sh <harness>`)

`setup.sh` gains a required harness argument:

- `./setup.sh claude` — current behavior, generalized: symlink `AGENTS.md` + `CLAUDE.md` + Claude overlay (settings, statusline, hooks) + skills + MCP into `~/.claude/`.
- `./setup.sh codex` — symlink `AGENTS.md` → Codex instructions location, `harness/codex/config.toml` → Codex config, each `PORTABLE` skill folder → `~/.codex/agents/skills/`, MCP → Codex MCP config.
- `./setup.sh cursor` — install `.cursor/rules` referencing `AGENTS.md`, MCP if supported.
- No argument → print usage and the list of supported harnesses. Idempotent and re-runnable (re-creating a clobbered symlink is safe). Retains the existing backup-before-link behavior.

## Data flow: setup vs. switching

**One-time wiring (per harness, per machine).** The user runs `./setup.sh <harness>` once for each harness they intend to use, from inside the repo. It lays down signposts (symlinks/config) from that harness's **own** global config dir into the repo's canonical files + the relevant overlay:

- `./setup.sh claude` → `~/.claude/`
- `./setup.sh codex` → `~/.codex/`
- `./setup.sh cursor` → `~/.cursor/` (MCP) + a `.cursor/rules` pointer in the repo (see Component 4 for Cursor's limits)

Because each harness reads a **separate** global dir, all wired harnesses coexist permanently — wiring one never un-wires another.

**Day-to-day switching is just relaunching.** Once wired, the user switches harnesses by simply launching the other tool (`claude` ↔ `codex`) from a terminal in any directory — **no re-running `setup.sh`**. Edits to any skill or to `AGENTS.md` write through to the git-tracked repo files and are immediately live in every wired harness.

**`setup.sh` is only re-run on structural change**, not on a switch: a new machine, adding a brand-new skill that needs a symlink, or changing the portability allowlist. (Cursor, being an editor rather than a terminal CLI, is the exception to "just relaunch" — see Component 4.)

## Error handling / edge cases

- **Clobbered symlink** (folder in `~/.codex/...` deleted/renamed): re-run `setup.sh <harness>` to recreate. Repo files are never at risk.
- **Editor atomic-save**: because we symlink *folders*, file writes inside resolve to the real repo folder; the symlink itself isn't clobbered.
- **Unknown harness arg**: print usage, exit non-zero.
- **A future `NEEDS_FIXES` skill invoked on a foreign harness**: it simply isn't symlinked there, so it's absent rather than broken. (The bucket is empty today; this is the safety behavior for any skill later flagged non-portable.)
- **Existing real file where a symlink should go**: back it up (`.backup.<date>`) before linking, as `setup.sh` already does.

## Testing / verification

- **Installer:** run `./setup.sh claude`, then `codex`, then `cursor` on a scratch HOME; assert the expected symlinks exist and resolve to repo files; assert idempotency on re-run; assert backup-on-conflict.
- **Drift proof:** edit a skill through the Codex symlink path; assert the repo file shows the change and `git diff` reflects it.
- **Claude Code parity:** confirm `/meeting-prep` etc. still appear with prefill preview after `./setup.sh claude`.
- **Content neutrality:** grep `AGENTS.md` for Claude Code-specific tool names / mechanics; assert none remain (those belong in the Claude overlay).
- **Clean deletion:** grep the repo for `start-recording` / `stop-recording` / `setup-recording` / `data/transcripts` / `data/recordings`; assert no dangling references remain outside git history (e.g. in `import-meeting-notes`, `README.md`, `.gitignore`).

## Migration / rollout

1. Split `CLAUDE.md` → `AGENTS.md` (canonical) + `harness/claude/` overlay; rename/absorb `claude-config/` into `harness/claude/`; add thin `CLAUDE.md` deferring to `AGENTS.md`.
2. Keep `.mcp.json` at repo root (canonical); installer maps it outward per harness.
3. Create `harness/codex/` and `harness/cursor/` overlays.
4. Rewrite `setup.sh` to take a harness arg and install the right layers.
5. Neutralize `delegate-research` (advisory reword). Delete the recording trio and clean up references — strip `import-meeting-notes` to Granola-only, scrub `README.md`, remove orphaned `.gitignore` rules, delete the two historical recorder docs (Components 3.1, 3.2).
6. Define the portability allowlist with all 11 remaining skills marked `PORTABLE`.
7. Update `README.md` / `CLAUDE.md` repo docs to describe the new layout and `setup.sh <harness>` usage.

## Open questions

- None blocking. A full scan of each skill for harness-specific tool references happens during implementation to confirm nothing beyond the two known cases needs neutralizing.
