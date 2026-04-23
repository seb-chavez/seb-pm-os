# PM Operating System (seb-pm-os)

A portable toolkit for product management work powered by Claude Code. Clone this repo at any new company, run the setup script, and get a fully configured Claude Code environment with your preferred settings, formatting standards, and document templates.

## What's Inside

**Claude Code Config** (`claude-config/`)
- `settings.json` - Permissions, sandbox config, and plugin settings
- `CLAUDE.md` - Global instructions including template auto-reference rules
- `memory/doc-formatting.md` - Document formatting defaults (fonts, spacing, tables, etc.)

**Document Templates** (`templates/`)
- `prds/prd.md` - Product Requirements Document
- `meetings/agenda.md` - Meeting Agenda
- `meetings/meeting-notes.md` - Meeting Notes
- `meetings/decision-log.md` - Decision Record
- `strategy/project-brief.md` - Project/Initiative Brief
- `strategy/status-update.md` - Stakeholder Status Report
- `strategy/roadmap.md` - Roadmap Planning Document

## Setup

```bash
git clone <repo-url>
cd seb-pm-os
./setup.sh
```

The setup script will:
1. Back up any existing Claude Code config files (with a `.backup.YYYY-MM-DD` suffix)
2. Symlink the config files from this repo into `~/.claude/`
3. Print a summary of what was linked and backed up

Running the script again is safe. It skips files that are already linked correctly.

### Granola MCP (Meeting Notes)

The repo includes a `.mcp.json` that configures the [Granola](https://granola.ai) MCP server out of the box. When you open this project in Claude Code, the Granola integration is available automatically.

**Prerequisites:** You need a Granola account with meeting notes. Claude Code will prompt you to authenticate with Granola on first use.

**What it does:** Pulls your meeting notes from Granola and synthesizes them into the knowledge base:
- Stakeholder context routes to `knowledge/people/`
- Research findings route to `knowledge/research/`
- Project decisions route to `projects/[project-name]/notes/`

**How to use:**
```
Import my recent Granola meeting notes
```

See `workflows/import-meeting-notes.md` for the full workflow details.

## Using Templates

With Claude Code running, ask it to create any supported document type by name:

- "Create a PRD for [feature]"
- "Write meeting notes for [meeting]"
- "Put together a project brief for [initiative]"
- "Draft a status update for [project]"
- "Create a decision record for [topic]"
- "Build a roadmap for [team/product]"
- "Write an agenda for [meeting]"

Claude Code will automatically use the matching template and apply your formatting preferences.

## Editing Your Config

Since the setup script uses symlinks, any changes you make to files in `claude-config/` are immediately reflected in `~/.claude/`, and vice versa. Commit changes back to this repo to keep your config portable.
