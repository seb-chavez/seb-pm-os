# PM Operating System (seb-pm-os) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a portable, version-controlled PM Operating System repo with Claude Code config, document formatting standards, 7 PM templates, and a one-command setup script.

**Architecture:** Flat repo with two top-level concerns: `claude-config/` (mirrors `~/.claude/` for symlinking) and `templates/` (PM document blueprints organized by category). A `setup.sh` script handles installation by backing up existing config and creating symlinks.

**Tech Stack:** Bash (setup script), Markdown (templates, docs), JSON (settings)

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Create | `claude-config/settings.json` | Claude Code permissions and sandbox config |
| Create | `claude-config/CLAUDE.md` | Global behavioral instructions + template auto-reference rules |
| Create | `claude-config/memory/doc-formatting.md` | Document formatting defaults |
| Create | `templates/prds/prd.md` | Product Requirements Document template |
| Create | `templates/meetings/agenda.md` | Meeting agenda template |
| Create | `templates/meetings/meeting-notes.md` | Meeting notes template |
| Create | `templates/meetings/decision-log.md` | Decision record template |
| Create | `templates/strategy/project-brief.md` | Project/initiative brief template |
| Create | `templates/strategy/status-update.md` | Stakeholder status report template |
| Create | `templates/strategy/roadmap.md` | Roadmap planning document template |
| Create | `setup.sh` | Backup-and-symlink installer |
| Create | `README.md` | Repo overview and usage instructions |

---

### Task 1: Initialize Git Repo and Directory Structure

**Files:**
- Create: `.gitignore`
- Create: all directories (`claude-config/memory/`, `templates/prds/`, `templates/meetings/`, `templates/strategy/`, `docs/superpowers/specs/`, `docs/superpowers/plans/`)

- [ ] **Step 1: Initialize the git repo**

```bash
cd /Users/sebastianchavez/seb-pm-os
git init
```

- [ ] **Step 2: Create directory structure**

```bash
mkdir -p claude-config/memory
mkdir -p templates/prds
mkdir -p templates/meetings
mkdir -p templates/strategy
```

- [ ] **Step 3: Create .gitignore**

Write to `.gitignore`:

```
.DS_Store
*.backup.*
```

- [ ] **Step 4: Commit**

```bash
git add .gitignore
git commit -m "chore: initialize repo with directory structure and gitignore"
```

---

### Task 2: Claude Code Config Files

**Files:**
- Create: `claude-config/settings.json`
- Create: `claude-config/CLAUDE.md`
- Create: `claude-config/memory/doc-formatting.md`

- [ ] **Step 1: Copy settings.json**

Copy the exact contents of `~/.claude/settings.json` into `claude-config/settings.json`. This is Sebastian's current working config with:
- Sandbox enabled, auto-allow bash when sandboxed
- Permission allowlists for git, package managers, system utils, GitHub CLI
- Deny rules for sudo, rm -rf, force push, hard reset
- Enabled plugins: superpowers, frontend-design

The file is 246 lines. Copy it verbatim.

- [ ] **Step 2: Copy doc-formatting.md**

Copy the exact contents of `~/.claude/memory/doc-formatting.md` into `claude-config/memory/doc-formatting.md`. This is 45 lines covering font, margins, heading spacing, body text, tables, dashes, and horizontal rules. Copy it verbatim.

- [ ] **Step 3: Create CLAUDE.md with template auto-reference rules**

Copy the existing `~/.claude/CLAUDE.md` (33 lines) and append a new section. The final file should contain:

1. The existing content (Global User Instructions, Minimize permission prompts, Workflow sections) unchanged
2. A new section appended at the end:

```markdown
## Document Templates

When asked to create a document, use the matching template from this repo as the structural blueprint. Read the template file, then fill in every section with real content based on the user's input.

Always apply the formatting defaults from `memory/doc-formatting.md` when generating any document.

If the user asks to "create a document" without specifying a type, ask which format they want.

| Keyword | Template |
|---------|----------|
| "PRD" or "product requirements document" | `templates/prds/prd.md` |
| "agenda" | `templates/meetings/agenda.md` |
| "meeting notes" | `templates/meetings/meeting-notes.md` |
| "decision log" or "decision record" | `templates/meetings/decision-log.md` |
| "project brief" | `templates/strategy/project-brief.md` |
| "status update" or "status report" | `templates/strategy/status-update.md` |
| "roadmap" | `templates/strategy/roadmap.md` |
```

- [ ] **Step 4: Verify all three files exist and have content**

```bash
wc -l claude-config/settings.json claude-config/CLAUDE.md claude-config/memory/doc-formatting.md
```

Expected: settings.json ~246 lines, CLAUDE.md ~50 lines, doc-formatting.md ~45 lines.

- [ ] **Step 5: Commit**

```bash
git add claude-config/
git commit -m "feat: add Claude Code config files with template auto-reference rules"
```

---

### Task 3: PRD Template

**Files:**
- Create: `templates/prds/prd.md`

- [ ] **Step 1: Create the PRD template**

Write to `templates/prds/prd.md`:

```markdown
# [Product/Feature Name] - Product Requirements Document

## Overview

Provide a brief summary of what this product or feature is and why it matters. One to two paragraphs.

## Problem Statement

Describe the problem this product or feature solves. Who experiences the problem, how often, and what is the impact of not solving it?

## Target Users

Identify the primary and secondary users of this feature. Describe their roles, goals, and relevant context.

## Success Metrics

Define how you will measure whether this product or feature is successful. List specific, measurable metrics with target values.

| Metric | Current Baseline | Target | Measurement Method |
|--------|-----------------|--------|-------------------|
| | | | |

## Proposed Solution

Describe the solution at a high level. What will the user experience look like? How does it work?

## Functional Requirements

List the specific functional requirements. Each requirement should be testable and unambiguous.

| ID | Requirement | Priority (P0/P1/P2) | Notes |
|----|-------------|---------------------|-------|
| FR-1 | | | |

## Non-Functional Requirements

List performance, security, scalability, accessibility, and other non-functional requirements.

| ID | Requirement | Priority (P0/P1/P2) | Notes |
|----|-------------|---------------------|-------|
| NFR-1 | | | |

## Scope

### In Scope

List what is explicitly included in this effort.

### Out of Scope

List what is explicitly excluded and why.

## Dependencies

List any dependencies on other teams, systems, or projects. Include the status of each dependency and any risks associated with it.

| Dependency | Owner | Status | Risk |
|-----------|-------|--------|------|
| | | | |

## Risks and Mitigations

Identify risks that could impact delivery or success. For each risk, describe the likelihood, impact, and mitigation strategy.

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| | | | |

## Timeline

Outline the high-level milestones and target dates.

| Milestone | Target Date | Status |
|-----------|------------|--------|
| | | |

## Open Questions

List any unresolved questions that need answers before or during implementation.

| Question | Owner | Due Date | Resolution |
|----------|-------|----------|------------|
| | | | |
```

- [ ] **Step 2: Commit**

```bash
git add templates/prds/prd.md
git commit -m "feat: add PRD template"
```

---

### Task 4: Meeting Agenda Template

**Files:**
- Create: `templates/meetings/agenda.md`

- [ ] **Step 1: Create the agenda template**

Write to `templates/meetings/agenda.md`:

```markdown
# [Meeting Name] - Agenda

## Meeting Details

| Field | Value |
|-------|-------|
| Date | |
| Time | |
| Location/Link | |
| Facilitator | |
| Note Taker | |

## Attendees

List all attendees and their roles.

| Name | Role |
|------|------|
| | |

## Objective

State the single primary objective of this meeting in one sentence.

## Pre-Read Materials

List any documents, links, or context attendees should review before the meeting.

-

## Agenda Topics

| # | Topic | Owner | Time (min) | Goal |
|---|-------|-------|-----------|------|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |

## Desired Outcomes

List the specific outcomes or decisions expected from this meeting.

-

## Parking Lot

Space for topics that come up but are not on the agenda. Capture them here to address later.

-
```

- [ ] **Step 2: Commit**

```bash
git add templates/meetings/agenda.md
git commit -m "feat: add meeting agenda template"
```

---

### Task 5: Meeting Notes Template

**Files:**
- Create: `templates/meetings/meeting-notes.md`

- [ ] **Step 1: Create the meeting notes template**

Write to `templates/meetings/meeting-notes.md`:

```markdown
# [Meeting Name] - Notes

## Meeting Details

| Field | Value |
|-------|-------|
| Date | |
| Time | |
| Location/Link | |
| Facilitator | |
| Note Taker | |

## Attendees

| Name | Role | Present? |
|------|------|----------|
| | | |

## Key Discussion Points

Summarize each major topic discussed. Use a subsection per topic if the meeting covered multiple areas.

### Topic 1: [Name]

Summary of the discussion, key arguments, and context shared.

## Decisions Made

| Decision | Rationale | Owner |
|----------|-----------|-------|
| | | |

## Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| | | | |

## Follow-Up Items

Items that need further discussion or investigation but do not have a clear action yet.

-

## Next Meeting

| Field | Value |
|-------|-------|
| Date | |
| Key Topics | |
```

- [ ] **Step 2: Commit**

```bash
git add templates/meetings/meeting-notes.md
git commit -m "feat: add meeting notes template"
```

---

### Task 6: Decision Log Template

**Files:**
- Create: `templates/meetings/decision-log.md`

- [ ] **Step 1: Create the decision log template**

Write to `templates/meetings/decision-log.md`:

```markdown
# [Decision Title] - Decision Record

## Decision Details

| Field | Value |
|-------|-------|
| Date | |
| Status | Proposed / Accepted / Superseded / Deprecated |
| Decision Maker(s) | |
| Stakeholders Consulted | |

## Context

Describe the situation and business context that prompted this decision. What problem are you solving? What constraints exist?

## Options Considered

### Option 1: [Name]

Description of the option.

**Pros:**
-

**Cons:**
-

**Estimated Effort:**

### Option 2: [Name]

Description of the option.

**Pros:**
-

**Cons:**
-

**Estimated Effort:**

### Option 3: [Name]

Description of the option.

**Pros:**
-

**Cons:**
-

**Estimated Effort:**

## Decision

State the decision clearly in one to two sentences.

## Rationale

Explain why this option was chosen over the alternatives. Reference the specific pros/cons that drove the decision.

## Consequences

Describe what happens as a result of this decision. Include both positive outcomes and trade-offs accepted.

## Revisit Criteria

Under what conditions should this decision be revisited? List specific triggers.

-
```

- [ ] **Step 2: Commit**

```bash
git add templates/meetings/decision-log.md
git commit -m "feat: add decision log template"
```

---

### Task 7: Project Brief Template

**Files:**
- Create: `templates/strategy/project-brief.md`

- [ ] **Step 1: Create the project brief template**

Write to `templates/strategy/project-brief.md`:

```markdown
# [Project/Initiative Name] - Project Brief

## Executive Summary

A two to three sentence summary of the project: what it is, why it matters, and what success looks like.

## Problem / Opportunity

Describe the problem being solved or opportunity being pursued. Include data, user feedback, or business context that supports the case.

## Goals and Success Metrics

| Goal | Metric | Target | Timeframe |
|------|--------|--------|-----------|
| | | | |

## Scope

### What This Includes

-

### What This Does Not Include

-

## Stakeholders

| Name | Role | Involvement Level |
|------|------|-------------------|
| | | Accountable / Responsible / Consulted / Informed |

## Approach

Describe the high-level approach. How will this be executed? What methodology or framework applies?

## Timeline

| Phase | Description | Target Date |
|-------|------------|------------|
| | | |

## Resource Needs

List the people, tools, budget, or other resources required.

| Resource | Type | Status |
|----------|------|--------|
| | | Available / Requested / Blocked |

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| | | | |

## Open Questions

-
```

- [ ] **Step 2: Commit**

```bash
git add templates/strategy/project-brief.md
git commit -m "feat: add project brief template"
```

---

### Task 8: Status Update Template

**Files:**
- Create: `templates/strategy/status-update.md`

- [ ] **Step 1: Create the status update template**

Write to `templates/strategy/status-update.md`:

```markdown
# [Project/Team Name] - Status Update

## Report Details

| Field | Value |
|-------|-------|
| Reporting Period | |
| Author | |
| Date | |
| Overall Status | On Track / At Risk / Blocked |

## Summary

A two to three sentence summary of where things stand this period.

## Key Accomplishments

What was completed or shipped this period?

-

## Upcoming Milestones

What is expected to be completed in the next period?

| Milestone | Target Date | Confidence |
|-----------|------------|------------|
| | | High / Medium / Low |

## Risks and Blockers

| Issue | Type (Risk/Blocker) | Impact | Owner | Mitigation / Ask |
|-------|-------------------|--------|-------|-----------------|
| | | | | |

## Asks / Decisions Needed

List any decisions or support needed from leadership or stakeholders.

| Ask | Context | Needed By | Owner |
|-----|---------|-----------|-------|
| | | | |

## Metrics

| Metric | Last Period | This Period | Trend |
|--------|-----------|------------|-------|
| | | | |
```

- [ ] **Step 2: Commit**

```bash
git add templates/strategy/status-update.md
git commit -m "feat: add status update template"
```

---

### Task 9: Roadmap Template

**Files:**
- Create: `templates/strategy/roadmap.md`

- [ ] **Step 1: Create the roadmap template**

Write to `templates/strategy/roadmap.md`:

```markdown
# [Product/Team Name] - Roadmap

## Vision

A one to two sentence description of the long-term direction this roadmap supports.

## Strategic Pillars

List the key themes or strategic pillars that organize the work on this roadmap.

1. **[Pillar Name]:** Brief description
2. **[Pillar Name]:** Brief description
3. **[Pillar Name]:** Brief description

## Now (Current Quarter)

Work that is actively in progress or committed for this quarter.

| Initiative | Pillar | Status | Owner | Notes |
|-----------|--------|--------|-------|-------|
| | | Not Started / In Progress / Complete | | |

## Next (Next Quarter)

Work that is planned and scoped but not yet started.

| Initiative | Pillar | Confidence | Owner | Dependencies |
|-----------|--------|------------|-------|-------------|
| | | High / Medium / Low | | |

## Later (Future Quarters)

Work that is directionally planned but not yet scoped or committed.

| Initiative | Pillar | Rationale |
|-----------|--------|-----------|
| | | |

## Dependencies

| Dependency | Affects | Owner | Status |
|-----------|---------|-------|--------|
| | | | |

## Assumptions

List assumptions that underpin this roadmap. If any assumption changes, the roadmap should be revisited.

-

## Change Log

Track significant changes to the roadmap over time.

| Date | Change | Reason |
|------|--------|--------|
| | | |
```

- [ ] **Step 2: Commit**

```bash
git add templates/strategy/roadmap.md
git commit -m "feat: add roadmap template"
```

---

### Task 10: Setup Script

**Files:**
- Create: `setup.sh`

- [ ] **Step 1: Create setup.sh**

Write to `setup.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# PM Operating System - Setup Script
# Symlinks Claude Code config files from this repo into ~/.claude/

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
DATE=$(date +%Y-%m-%d)

backed_up=()
linked=()
skipped=()

backup_and_link() {
    local src="$1"
    local dest="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # If destination exists and is already a symlink to our source, skip
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        skipped+=("$dest (already linked)")
        return
    fi

    # If destination exists (file or different symlink), back it up
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local backup="${dest}.backup.${DATE}"
        mv "$dest" "$backup"
        backed_up+=("$dest -> $backup")
    fi

    # Create symlink
    ln -s "$src" "$dest"
    linked+=("$dest -> $src")
}

echo "PM Operating System - Setup"
echo "==========================="
echo ""

# Ensure ~/.claude/ and ~/.claude/memory/ exist
mkdir -p "$CLAUDE_DIR/memory"

# Symlink each config file
backup_and_link "$SCRIPT_DIR/claude-config/settings.json" "$CLAUDE_DIR/settings.json"
backup_and_link "$SCRIPT_DIR/claude-config/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
backup_and_link "$SCRIPT_DIR/claude-config/memory/doc-formatting.md" "$CLAUDE_DIR/memory/doc-formatting.md"

# Print summary
echo "Setup complete!"
echo ""

if [ ${#linked[@]} -gt 0 ]; then
    echo "Linked:"
    for item in "${linked[@]}"; do
        echo "  $item"
    done
    echo ""
fi

if [ ${#backed_up[@]} -gt 0 ]; then
    echo "Backed up (originals preserved):"
    for item in "${backed_up[@]}"; do
        echo "  $item"
    done
    echo ""
fi

if [ ${#skipped[@]} -gt 0 ]; then
    echo "Skipped (already correct):"
    for item in "${skipped[@]}"; do
        echo "  $item"
    done
    echo ""
fi

echo "Your Claude Code config is now managed from: $SCRIPT_DIR"
echo "Templates are available at: $SCRIPT_DIR/templates/"
```

- [ ] **Step 2: Make setup.sh executable**

```bash
chmod +x setup.sh
```

- [ ] **Step 3: Commit**

```bash
git add setup.sh
git commit -m "feat: add setup script for backup-and-symlink installation"
```

---

### Task 11: README

**Files:**
- Create: `README.md`

- [ ] **Step 1: Create README.md**

Write to `README.md`:

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add README with setup and usage instructions"
```

---

### Task 12: Final Verification

- [ ] **Step 1: Verify the full directory structure**

```bash
find /Users/sebastianchavez/seb-pm-os -type f | sort
```

Expected output should include all 12 files:
- `.gitignore`
- `README.md`
- `claude-config/CLAUDE.md`
- `claude-config/memory/doc-formatting.md`
- `claude-config/settings.json`
- `docs/superpowers/plans/2026-04-22-pm-operating-system.md`
- `docs/superpowers/specs/2026-04-22-pm-operating-system-design.md`
- `setup.sh`
- `templates/meetings/agenda.md`
- `templates/meetings/decision-log.md`
- `templates/meetings/meeting-notes.md`
- `templates/prds/prd.md`
- `templates/strategy/project-brief.md`
- `templates/strategy/roadmap.md`
- `templates/strategy/status-update.md`

- [ ] **Step 2: Verify git log shows all commits**

```bash
git log --oneline
```

Expected: 11 commits (init + config + 7 templates + setup + readme + any plan/spec commits).

- [ ] **Step 3: Verify setup.sh is executable**

```bash
ls -la setup.sh
```

Expected: `-rwxr-xr-x` permissions.
