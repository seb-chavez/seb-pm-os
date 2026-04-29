---
name: knowledge-health
description: Use when checking for gaps, staleness, or missing information in the knowledge base. Triggers on "knowledge health", "check my knowledge base", "what's missing", "what's stale", "health check".
---

# Knowledge Health Check

## Overview

Scans the knowledge base and active projects for gaps, missing fields, and staleness. Produces a health report showing what's complete, what has gaps, and what needs attention.

## When NOT to use

- The user wants to fix a specific file (just edit it directly)
- The user is asking about a specific person or project (use `/meeting-prep` instead)

## Steps

1. **Scan people files** — read every `.md` file in `knowledge/people/` (except README.md). For each file, check for:
   - Missing "Cares about" or "cares about" field
   - Missing "Communication style" or "communication style" field
   - No "## Meeting notes" or "## Recent context" section
   - No dated entries (### YYYY-MM-DD) in the last 30 days
2. **Check company knowledge** — list files in `knowledge/company/`. Flag if the directory contains only README.md
3. **Check active projects** — for each directory in `projects/` (excluding `_archive`), find the most recent note by filename date. Flag projects with no notes in the last 14 days
4. **Check goals** — read `GOALS.md`. Flag if the key results table still has empty cells or placeholder text like "_Define your"
5. Present the health report:

### Report Format

```
## Knowledge Base Health Check

### People (X files)
- ✓ [name] — complete
- ⚠ [name] — missing: [fields], last updated: [date]
- ✗ [name] — missing: [fields], no recent entries

### Company Knowledge
- [status: populated / empty]

### Active Projects
- ✓ [project] — last note: [date]
- ⚠ [project] — last note: [date] (X days ago)

### Goals
- [status: populated / has placeholders]

### Summary
[X] complete | [Y] need attention | [Z] stale
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Only checking for exact field names | Check case-insensitively and look for variations (e.g., "Cares about" vs "cares about" vs "What they care about") |
| Reporting README.md as a content file | Exclude README.md from all scans |
| Not explaining what's missing | Always specify which fields are missing, not just "incomplete" |
