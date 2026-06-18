---
name: weekly-digest
description: Use when reviewing what happened across projects and the knowledge base in the past week. Triggers on "weekly digest", "what happened this week", "weekly summary", "recap the week".
disable-model-invocation: true
---

# Weekly Digest

## Overview

Scans files modified in the past 7 days across projects, canonical, and goals. Synthesizes a summary of activity and decisions. Includes open action items from `canonical/action-items.md`.

## Invocation

`/weekly-digest` — or natural language (e.g. "what happened this week").

## When NOT to use

- The user wants a status report for stakeholders (use `/status-report` instead)
- The user is asking about a specific meeting or person (use `/meeting-prep` instead)

## Steps

1. Run `git log --since="7 days ago" --name-only --pretty=format:""` to find files modified in the past week
2. Filter to files under `canonical/`
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
(From `canonical/action-items.md` — open section only)

### Knowledge Base Updates
- [what was added/changed] in [which canonical area]
(Pulled from canonical/ changes)

### Goal Progress
- [any updates to canonical/GOALS.md]
```

5. Print the digest to the terminal
6. Ask: "Want me to save this digest?" — if yes, write to `canonical/data/digests/YYYY-MM-DD-digest.md` (create `canonical/data/digests/` if it doesn't exist)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Including unchanged files in the digest | Only report on files modified in the git log |
| Missing action items | Read `canonical/action-items.md` if it exists |
| Forgetting to offer the save option | Always ask after presenting the digest |
