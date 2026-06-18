---
name: weekly-digest
description: Use when reviewing what happened across projects and the knowledge base in the past week. Triggers on "weekly digest", "what happened this week", "weekly summary", "recap the week".
disable-model-invocation: true
---

# Weekly Digest

## Overview

Scans files modified in the past 7 days across projects, knowledge, and goals. Synthesizes a summary of activity and decisions. Includes open action items from `data/action-items.md`.

## Invocation

`/weekly-digest` — or natural language (e.g. "what happened this week").

## When NOT to use

- The user wants a status report for stakeholders (use `/status-report` instead)
- The user is asking about a specific meeting or person (use `/meeting-prep` instead)

## Steps

1. Run `git log --since="7 days ago" --name-only --pretty=format:""` to find files modified in the past week
2. Filter to files under `projects/`, `knowledge/`, and `GOALS.md`
3. Read each modified file
4. Synthesize into the following sections:

### Digest Format

```
## Weekly Digest: [date range]

### Activity by Project
- **[project-name]**: [summary of notes added, decisions made]
(Repeat for each active project with changes)

### Decisions Made
- [decision] — [date, context]
(Pulled from meeting notes and project notes)

### Open Action Items
- [ ] [action] — id: ai-NNN, due: [date]
(From `data/action-items.md` — open section only)

### Knowledge Base Updates
- [what was added/changed] in [which knowledge area]
(Pulled from knowledge/ changes)

### Goal Progress
- [any updates to GOALS.md]
```

5. Print the digest to the terminal
6. Ask: "Want me to save this digest?" — if yes, write to `data/digests/YYYY-MM-DD-digest.md` (create `data/digests/` if it doesn't exist)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Including unchanged files in the digest | Only report on files modified in the git log |
| Missing action items | Read `data/action-items.md` if it exists |
| Forgetting to offer the save option | Always ask after presenting the digest |
