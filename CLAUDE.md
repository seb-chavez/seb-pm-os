# seb-pm-os

A portable PM Operating System — a version-controlled toolkit for product management work, powered by Claude Code. Clone at any new company, run `./setup.sh`, and start working.

## Directory Structure

| Directory | Purpose | Sensitive? |
|-----------|---------|------------|
| `claude-config/` | Global Claude Code config (symlinked to `~/.claude/` via `setup.sh`) | No |
| `.claude/skills/` | Claude Code slash command skills (meeting prep, reviews, digests, etc.) | No |
| `templates/` | Document blueprints (PRD, agenda, meeting notes, etc.) | No |
| `knowledge/people/` | Stakeholder dossiers — communication style, priorities, meeting context | Yes (gitignored) |
| `knowledge/research/` | Market research, user insights, industry analysis | Yes (gitignored) |
| `knowledge/company/` | Company strategy, positioning, org structure | Yes (gitignored) |
| `knowledge/public-context/` | Publicly available onboarding materials for current/next role | No |
| `projects/` | Active project folders with dated notes | Yes (gitignored) |
| `projects/_archive/` | Completed or inactive projects | Yes (gitignored) |
| `goals/` | Archived quarterly goals files | No |
| `data/` | Working data files (CSVs, notebooks) for analysis | Yes (gitignored) |

## Naming Conventions

- **Meeting notes**: `YYYY-MM-DD-topic.md` (e.g., `2026-04-22-dean-sync.md`)
- **People files**: `firstname-lastname.md` (e.g., `dean-nolan.md`)
- **Archived goals**: `GOALS-YYYY-QN.md` (e.g., `GOALS-2026-Q2.md`)
- Active quarterly goals always live at root as `GOALS.md`

## Key Workflows

- **Import meeting notes**: `/import-meeting-notes`
- **Job transition**: `/job-transition`
- **Project archival**: Move completed project folders to `projects/_archive/`
