# PM Operating System (seb-pm-os) - Design Spec

**Date:** 2026-04-22
**Author:** Sebastian Chavez
**Status:** v1

## Purpose

A portable, version-controlled repository of Claude Code configuration, document formatting standards, and PM document templates. Designed to be cloned at any new company or context (day job, volunteering, personal projects) and installed with a single setup script, giving Sebastian a fully configured Claude Code environment with his preferred workflows and document generation capabilities.

## Repo Structure

```
seb-pm-os/
├── claude-config/
│   ├── settings.json
│   ├── CLAUDE.md
│   └── memory/
│       └── doc-formatting.md
├── templates/
│   ├── prds/
│   │   └── prd.md
│   ├── meetings/
│   │   ├── agenda.md
│   │   ├── meeting-notes.md
│   │   └── decision-log.md
│   └── strategy/
│       ├── project-brief.md
│       ├── status-update.md
│       └── roadmap.md
├── setup.sh
└── README.md
```

## Components

### 1. claude-config/

A mirror of `~/.claude/` containing the files that get symlinked into place.

**settings.json:** Sebastian's Claude Code permissions and sandbox configuration. Includes:
- Sandbox enabled with auto-allow for bash when sandboxed
- Comprehensive permission allowlists for git, package managers, system utilities, and GitHub CLI
- Deny rules for destructive operations (sudo, rm -rf, force push, hard reset)
- Enabled plugins: superpowers, frontend-design

**CLAUDE.md:** Global behavioral instructions for Claude Code. Current content includes:
- Permission prompt minimization rules (prefer dedicated tools over Bash)
- Syntax heuristic avoidance patterns
- Workflow guardrails (no pushing to main, no destructive git ops, no auto-commits)
- **New in v1:** Document template auto-reference rules (see Section 3 below)

**memory/doc-formatting.md:** Document formatting defaults for all generated documents. Specifies:
- Font: Arial, with specific sizes per heading level (Title 26pt down to Normal 11pt)
- All headings bold; normal text has no bold/italics/underlines
- 1-inch left/right margins
- Tight heading spacing with specific margin-top/bottom values
- Body text: 1.15 line spacing, 6pt space after paragraphs
- Table styling: black header row with white text, top-aligned cells, 1pt borders
- No em/en dashes as sentence connectors; rewrite instead
- No horizontal rules in documents

### 2. templates/

Fully populated document templates with section headings and placeholder guidance. Claude Code uses these as blueprints when asked to generate a specific document type.

**prds/prd.md** - Product Requirements Document:
- Problem statement, target users, success metrics
- Proposed solution, requirements (functional/non-functional)
- Scope (in/out), dependencies, risks
- Timeline, open questions

**meetings/agenda.md** - Meeting Agenda:
- Meeting metadata (date, attendees, objective)
- Topics with time allocations and owners
- Pre-read materials, desired outcomes

**meetings/meeting-notes.md** - Meeting Notes:
- Meeting metadata
- Key discussion points, decisions made
- Action items with owners and due dates
- Follow-up items

**meetings/decision-log.md** - Decision Record:
- Decision title, date, status
- Context, options considered with trade-offs
- Decision made, rationale
- Consequences, revisit criteria

**strategy/project-brief.md** - Project/Initiative Brief:
- Executive summary, problem/opportunity
- Goals and success metrics
- Scope, stakeholders, approach
- Timeline, resource needs, risks

**strategy/status-update.md** - Stakeholder Status Report:
- Reporting period, overall status (on track/at risk/blocked)
- Key accomplishments, upcoming milestones
- Risks and blockers, asks/decisions needed

**strategy/roadmap.md** - Roadmap Planning Document:
- Vision, strategic pillars
- Time horizon breakdown (now/next/later or quarterly)
- Dependencies, assumptions, change log

### 3. CLAUDE.md Template Auto-Reference Rules

Added to CLAUDE.md as a new section. When the user asks Claude Code to create a document, these keyword rules determine which template to use:

| Keyword(s) | Template |
|---|---|
| "PRD", "product requirements document" | `templates/prds/prd.md` |
| "agenda" | `templates/meetings/agenda.md` |
| "meeting notes" | `templates/meetings/meeting-notes.md` |
| "decision log", "decision record" | `templates/meetings/decision-log.md` |
| "project brief" | `templates/strategy/project-brief.md` |
| "status update", "status report" | `templates/strategy/status-update.md` |
| "roadmap" | `templates/strategy/roadmap.md` |

Additional rule: all generated documents must apply the formatting defaults from `memory/doc-formatting.md`.

If the user asks to "create a document" without specifying a type, Claude should ask which format they want rather than guessing.

### 4. setup.sh

A bash script that installs the PM OS configuration:

1. Check that `~/.claude/` exists; create it if not
2. Check that `~/.claude/memory/` exists; create it if not
3. For each file to be symlinked (`settings.json`, `CLAUDE.md`, `memory/doc-formatting.md`):
   - If the target already exists and is not a symlink to this repo, back it up with a `.backup.YYYY-MM-DD` suffix
   - Create a symlink from the repo file to the `~/.claude/` location
4. Print a summary: what was linked, what was backed up

The script should be idempotent: running it twice should not create duplicate backups or break existing symlinks.

### 5. README.md

A brief README explaining:
- What this repo is
- How to install (clone + run setup.sh)
- What's included (config, templates)
- How templates work with Claude Code

## Future Vision (v2+)

Not in scope for v1, but captured here for direction:

- **agents/ directory:** Custom automation agents for PM workflows
- **Notes summarizer agent:** Scans local notes files, summarizes outstanding action items, delivers weekly updates
- **Pain point synthesizer agent:** Takes customer/surface area problem notes and groups them into themes for PRD kickoff
- **Additional automations:** Anything that reduces repetitive PM work through Claude Code agents

The v1 repo structure accommodates this naturally; an `agents/` directory can be added alongside `templates/` when ready.

## Out of Scope for v1

- Company-specific configuration profiles or overrides
- Custom Claude Code skills/plugins
- Integration with external tools (Jira, Linear, Notion, etc.)
- Agent automations (captured in Future Vision)
