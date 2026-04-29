# PM Operating System (seb-pm-os)

A portable toolkit for product management work powered by Claude Code. Clone this repo at any new company, run the setup script, and get a fully configured Claude Code environment with your preferred settings, skills, and document templates.

## Prerequisites

- **Git** — comes with macOS (`xcode-select --install`) or install separately
- **Node.js** — required to run Claude Code
- **Claude Code** — install per [Anthropic's docs](https://docs.anthropic.com/en/docs/claude-code)
- **Granola** (optional) — for meeting note imports, requires a [Granola](https://granola.ai) account

## Setup

```bash
git clone https://github.com/seb-chavez/seb-pm-os.git
cd seb-pm-os
./setup.sh
```

The setup script will:
1. Back up any existing Claude Code config files (with a `.backup.YYYY-MM-DD` suffix)
2. Symlink the config files from this repo into `~/.claude/`
3. Print a summary of what was linked and backed up

Running the script again is safe — it skips files that are already linked correctly.

### What gets symlinked

| Source (`claude-config/`) | Destination (`~/.claude/`) | Purpose |
|---------------------------|---------------------------|---------|
| `settings.json` | `settings.json` | Permissions, sandbox config, plugin settings |
| `CLAUDE.md` | `CLAUDE.md` | Global instructions (templates, workflows, tool preferences) |
| `statusline-command.sh` | `statusline-command.sh` | Status line config |
| `memory/doc-formatting.md` | `memory/doc-formatting.md` | Document formatting defaults |

These apply **globally** to all Claude Code sessions on the machine.

### What stays project-local

Skills (`.claude/skills/`), templates, and the knowledge base only work when Claude Code is running from inside this repo.

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

Create a `GOALS.md` at the repo root with your current quarterly goals. When a quarter ends, rename it to `goals/GOALS-YYYY-QN.md` and start a fresh one.

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
| `claude-config/` | Global Claude Code config (symlinked to `~/.claude/` via `setup.sh`) | No |
| `.claude/skills/` | Claude Code slash command skills | No |
| `templates/` | Document blueprints (PRD, agenda, meeting notes, etc.) | No |
| `knowledge/people/` | Stakeholder dossiers | Yes (gitignored) |
| `knowledge/research/` | Market research, user insights, industry analysis | Yes (gitignored) |
| `knowledge/company/` | Company strategy, positioning, org structure | Yes (gitignored) |
| `knowledge/public-context/` | Publicly available onboarding materials | No |
| `projects/` | Active project folders with dated notes | Yes (gitignored) |
| `projects/_archive/` | Completed or inactive projects | Yes (gitignored) |
| `goals/` | Archived quarterly goals files | No |
| `data/` | Working data files (CSVs, notebooks) for analysis | Yes (gitignored) |

## Editing Your Config

Since the setup script uses symlinks, any changes you make to files in `claude-config/` are immediately reflected in `~/.claude/`, and vice versa. Commit changes back to this repo to keep your config portable.
