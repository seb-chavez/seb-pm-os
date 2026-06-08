# PM Operating System (seb-pm-os)

A portable, harness-agnostic toolkit for product management work. Clone this repo at any new company and wire it to whichever AI coding harness you use — Claude Code, Codex, or Cursor — from a single source of truth.

## Prerequisites

- **Git** — comes with macOS (`xcode-select --install`) or install separately
- **A supported harness** — Claude Code, Codex CLI, or Cursor (install per that tool's docs)
- **Node.js** — required by most harness CLIs
- **Granola** (optional) — for meeting note imports, requires a [Granola](https://granola.ai) account

## Setup

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

### What gets symlinked

`setup.sh <harness>` symlinks into that harness's global dir:

| Source (repo) | Claude Code (`~/.claude/`) | Codex (`~/.codex/`) | Cursor (`~/.cursor/`) |
|---|---|---|---|
| `AGENTS.md` | `AGENTS.md` | `AGENTS.md` | (via project rule) |
| `harness/<name>/` overlay | `CLAUDE.md`, `settings.json`, `statusline-command.sh`, `memory/` | `config.toml` | `mcp.json` |
| `.claude/skills/*` | `skills/` | `skills/` | (playbooks, no symlink) |
| `.mcp.json` | (project auto-discovered) | merged into `config.toml` | `mcp.json` |

Cursor is the lightest-use target: its project rule (`harness/cursor/rules/pm-os.mdc`) applies when you open this repo in Cursor, and global PM context in arbitrary folders needs a one-time manual paste into Cursor Settings → User Rules.

## After Setup

### Populate the knowledge base

The sensitive directories are gitignored and start empty. Build them up as you work, or restore from a backup if you have one:

| Directory | What goes here |
|-----------|---------------|
| `knowledge/people/` | Stakeholder dossiers — communication style, priorities, meeting context |
| `knowledge/company/` | Company strategy, positioning, org structure |
| `knowledge/research/` | Market research, user insights, industry analysis |
| `projects/` | Active project folders with dated notes |
| `data/` | Working data files (CSVs, notebooks) for analysis |

Use `/import-meeting-notes` to start pulling in context from Granola meetings.

### Set up your goals

Copy `GOALS.template.md` to `GOALS.md` at the repo root and fill in your current quarterly goals. `GOALS.md` is gitignored — its contents stay local. When a quarter ends, move it to `goals/GOALS-YYYY-QN.md` (also gitignored) and start a fresh one from the template.

## Skills

Slash commands available when running Claude Code from this repo:

| Command | Purpose |
|---------|---------|
| `/import-meeting-notes` | Pull and synthesize meeting notes from Granola |
| `/meeting-prep <person or topic>` | Pull context on a person or topic before a meeting |
| `/weekly-digest` | Summarize activity across projects for the past week |
| `/status-report` | Draft a cross-project status update from recent notes and goals |
| `/knowledge-health` | Flag gaps and staleness in the knowledge base |
| `/review-eng <file>` | Review a document as an engineering lead |
| `/review-exec <file>` | Review a document as an executive stakeholder |
| `/review-customer <file>` | Review a document as a customer advocate |
| `/review-devil <file>` | Review a document as a constructive skeptic |
| `/job-transition` | Archive and reset the OS when leaving a role |

## Document Templates

Ask Claude Code to create any supported document type by name:

- "Create a PRD for [feature]"
- "Write meeting notes for [meeting]"
- "Put together a project brief for [initiative]"
- "Draft a status update for [project]"
- "Create a decision record for [topic]"
- "Build a roadmap for [team/product]"
- "Write an agenda for [meeting]"

Templates live in `templates/` and Claude Code automatically applies your formatting preferences from `memory/doc-formatting.md`.

## Granola MCP (Meeting Notes)

The repo includes a `.mcp.json` that configures the [Granola](https://granola.ai) MCP server out of the box. When you open this project in Claude Code, the Granola integration is available automatically.

Claude Code will prompt you to authenticate with Granola on first use. Use `/import-meeting-notes` to pull recent meetings and route the synthesized notes into the knowledge base.

Basic plan limits: 30-day history, no transcript access. Import regularly to persist notes before they age out.

## Directory Structure

| Directory | Purpose | Sensitive? |
|-----------|---------|------------|
| `AGENTS.md` (root) | Canonical, harness-neutral instructions | No |
| `harness/<name>/` | Per-harness overlays + global payload installed by `setup.sh` | No |
| `.claude/skills/` | Single source for all skills (symlinked into each harness) | No |
| `templates/` | Document blueprints (PRD, agenda, meeting notes, etc.) | No |
| `knowledge/people/` | Stakeholder dossiers | Yes (gitignored) |
| `knowledge/research/` | Market research, user insights, industry analysis | Yes (gitignored) |
| `knowledge/company/` | Company strategy, positioning, org structure | Yes (gitignored) |
| `knowledge/public-context/` | Publicly available onboarding materials (default-deny; force-add public files) | Yes (gitignored by default) |
| `projects/` | Active project folders with dated notes | Yes (gitignored) |
| `projects/_archive/` | Completed or inactive projects | Yes (gitignored) |
| `goals/` | Archived quarterly goals files | Yes (gitignored) |
| `GOALS.md` (root) | Active quarter's goals — copy from `GOALS.template.md` | Yes (gitignored) |
| `data/` | Working data files (CSVs, notebooks) for analysis | Yes (gitignored) |

## Editing Your Config

Since `setup.sh` uses symlinks, any change you make to `AGENTS.md`, a skill, or a `harness/<name>/` overlay is immediately live in every wired harness — edit once, no re-sync. Commit changes back to this repo to keep your config portable.
