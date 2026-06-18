# Tools & Sub-Agents Design

**Date:** 2026-04-29
**Status:** Approved

## Overview

Add 8 Claude Code skills to seb-pm-os: 4 tools that operate on the knowledge base to surface and synthesize information, and 4 review personas that evaluate documents from different stakeholder lenses. All are invoked via slash commands.

## Skill Location & Structure

All skills live in `.claude/skills/` alongside the existing `delegate-research.md`. Each is a single `.md` file with YAML frontmatter (`name`, `description`) following the Claude Code skill specification.

```
.claude/skills/
├── delegate-research.md      (existing)
├── meeting-prep.md
├── weekly-digest.md
├── status-report.md
├── knowledge-health.md
├── review-eng.md
├── review-exec.md
├── review-customer.md
└── review-devil.md
```

### Frontmatter Convention

- `name`: letters, numbers, hyphens only
- `description`: starts with "Use when...", describes triggering conditions only, no workflow summary
- Max 1024 characters total frontmatter

---

## Tools

### meeting-prep

**Command:** `/meeting-prep <person or topic>`

**Description trigger:** Use when preparing for a meeting and need context on a person, team, or topic.

**Behavior:**
1. Fuzzy-match input against filenames in `canonical/people/`
2. Read matched person file(s) — communication style, what they care about, recent interactions
3. Scan recent project notes (`canonical/projects/*/notes/`) for mentions of that person or topic
4. Check `canonical/GOALS.md` for relevant items to surface
5. Present compiled brief: who they are, recent context, open action items owed, likely topics

**Output:** Terminal only (ephemeral prep, not a document).

**Input:** Person name or meeting topic. Examples:
- `/meeting-prep dean`
- `/meeting-prep board meeting`

---

### weekly-digest

**Command:** `/weekly-digest`

**Description trigger:** Use when reviewing what happened across projects and knowledge base in the past week.

**Behavior:**
1. Use `git log --since="7 days ago"` to find files modified in the past week
2. Read modified files across `canonical/projects/`, `canonical/`, and `canonical/GOALS.md`
3. Synthesize into sections:
   - Activity by project
   - Decisions made
   - Action items (with owners/due dates if noted)
   - Knowledge base updates
4. Print digest to terminal
5. Ask if user wants to save — if yes, write to `canonical/data/digests/YYYY-MM-DD-digest.md`

**Output:** Terminal, then optional save.

**Input:** None. Defaults to last 7 days.

---

### status-report

**Command:** `/status-report`

**Description trigger:** Use when drafting a status update or status report to share with stakeholders.

**Behavior:**
1. Read the status update template from `templates/strategy/status-update.md`
2. Read recent notes from all active project directories (`canonical/projects/*/notes/`)
3. Read `canonical/GOALS.md` for goal progress
4. Draft a filled-in status report using the template structure with real content from notes and goals
5. Present draft for review
6. On approval, save to a location the user specifies

**Output:** Draft in terminal, saved on approval.

**Input:** None. Cross-project by default.

---

### knowledge-health

**Command:** `/knowledge-health`

**Description trigger:** Use when checking for gaps, staleness, or missing information in the knowledge base.

**Behavior:**
1. Scan every file in `canonical/people/` — flag files missing key fields:
   - No "Cares about"
   - No "Communication style"
   - No meeting notes section
   - No entries in the last 30 days
2. Check `canonical/company/` — flag if empty (just README)
3. Check active projects in `canonical/projects/` — flag any with no notes in the last 2 weeks
4. Check `canonical/GOALS.md` — flag if key results table still has empty placeholders
5. Present health report: what's complete, what has gaps, what's stale

**Output:** Terminal only.

**Input:** None.

---

## Sub-Agent Review Skills

All four follow the same invocation pattern: provide a file path, receive structured feedback from a specific persona. Each outputs a numbered list of findings with severity levels (blocker / concern / suggestion) and recommended fixes.

### review-eng

**Command:** `/review-eng <file-path>`

**Description trigger:** Use when reviewing a document from an engineering feasibility perspective.

**Persona:** Engineering lead evaluating feasibility.

**Flags:**
- Missing technical constraints or assumptions
- Underestimated complexity or dependencies
- Vague acceptance criteria ("fast", "scalable" without numbers)
- Missing error/edge cases
- Architectural risks not called out

**Output:** Severity-based findings list with recommended fixes.

---

### review-exec

**Command:** `/review-exec <file-path>`

**Description trigger:** Use when reviewing a document from an executive or leadership perspective.

**Persona:** VP or C-level reading a document for the first time.

**Flags:**
- Buried or missing "so what" — is the core ask clear in the first paragraph?
- Metrics not tied to business outcomes
- No explicit ask or decision needed
- Too much detail, not enough synthesis
- Missing timeline or resource implications

**Output:** Severity-based findings list, plus a one-line summary of what an exec would take away from the doc as written.

---

### review-customer

**Command:** `/review-customer <file-path>`

**Description trigger:** Use when reviewing a document from an end-user or customer impact perspective.

**Persona:** End-user advocate.

**Flags:**
- Who's affected and how many
- Missing migration path or transition plan
- Solving a proxy problem instead of the stated problem
- Jargon or assumptions that don't match user mental models
- Missing user feedback or validation evidence

**Output:** Severity-based findings list, plus a user impact summary stating who is affected and what changes for them.

---

### review-devil

**Command:** `/review-devil <file-path>`

**Description trigger:** Use when stress-testing a document for unstated assumptions, risks, or weak evidence.

**Persona:** Constructive skeptic.

**Flags:**
- Unstated assumptions being treated as facts
- Risks glossed over or missing entirely
- "What if this doesn't work" scenarios
- Single points of failure
- Evidence gaps — claims without supporting data
- Optimistic timelines or estimates without basis

**Output:** Severity-based findings list, plus a "strongest counterargument" — the single best reason this plan might fail.

---

## Integration Changes

### CLAUDE.md Update

Add a skills reference table to `claude-config/CLAUDE.md`:

```markdown
## Skills

| Command | Skill | Purpose |
|---------|-------|---------|
| `/meeting-prep` | `meeting-prep` | Pull context on a person or topic before a meeting |
| `/weekly-digest` | `weekly-digest` | Summarize activity across projects for the past week |
| `/status-report` | `status-report` | Draft a cross-project status update from recent notes and goals |
| `/knowledge-health` | `knowledge-health` | Flag gaps and staleness in the knowledge base |
| `/review-eng` | `review-eng` | Review a document as an engineering lead |
| `/review-exec` | `review-exec` | Review a document as an executive stakeholder |
| `/review-customer` | `review-customer` | Review a document as a customer advocate |
| `/review-devil` | `review-devil` | Review a document as a constructive skeptic |
```

### setup.sh Update

Add symlink for the `.claude/skills/` directory so new skills are available after running setup:

```
claude-config/skills/ → ~/.claude/skills/
```

This requires moving the existing `delegate-research.md` from `.claude/skills/` into `claude-config/skills/` (the repo-managed source) and symlinking the directory.

### canonical/data/digests/ Directory

Created on first use by `/weekly-digest` when user opts to save. No need to pre-create.

---

## Out of Scope

- Calendar-aware meeting prep (future enhancement — start manual only)
- Per-project status reports (cross-project only for now)
- Auto-detect review target (explicit file path required)
- Shell scripts or programmatic tooling (skills are markdown instructions only)
