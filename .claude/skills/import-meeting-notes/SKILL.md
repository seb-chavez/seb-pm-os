---
name: import-meeting-notes
description: Use when the user wants to import, pull, or review meeting notes from Granola. Triggers on phrases like "import meeting notes", "check my recent meetings", "pull notes from my sync", or any request involving Granola meetings.
---

# Import Meeting Notes

## Overview

Pulls recent Granola meetings via MCP, synthesizes key details, and routes them to the appropriate knowledge folders. The goal is structured context, not raw transcripts.

## When NOT to use

- The user wants to write notes manually
- Notes aren't from Granola (e.g., pasting from another tool)
- The user just wants to read a transcript without importing

## Routing

| Content type | Destination |
|-------------|-------------|
| Person-specific context | `knowledge/people/firstname-lastname.md` |
| Research findings | `knowledge/research/` |
| Strategy/org context | `knowledge/company/` |
| Project decisions | `projects/[project-name]/notes/` |

## Steps

1. Pull recent meetings via Granola MCP
2. Show the user what's available (date, attendees, summary)
3. User picks which meeting(s) to import
4. **Synthesize** the meeting — extract only key details, not raw transcripts:
   - Decisions made
   - Action items (who owes what, by when)
   - Stakeholder positions and sentiment
   - Useful context for future conversations
5. Propose where to write — a single meeting may produce multiple files (see Routing table above)
6. Confirm the routing and content with the user before writing anything

## Output Format

Each destination file gets an appended section like:

```markdown
### YYYY-MM-DD - Topic
- Key point 1
- Key point 2
- Action: [owner] owes [what] by [when]
```

## Example

A research sync with Becky Weinstein might produce:

**→ `knowledge/people/becky-weinstein.md`** (appended)
```markdown
### 2026-04-23 - User research sync
- Wants to run 5 more interviews before we finalize personas
- Concerned about sample bias in the enterprise segment
- Action: I owe her the screener updates by Monday
```

**→ `knowledge/research/insights.md`** (appended)
```markdown
### 2026-04-23 - Enterprise persona gaps
- Current personas underrepresent mid-market ops buyers
- Becky's team found 3 distinct workflows we hadn't mapped
- Next step: revised persona deck after round 2 interviews
```

## Rules

- **No raw transcripts** — synthesized context only, to keep the knowledge base lean
- **Always confirm routing** with the user before writing
- Basic plan: 30-day history, no transcript access. Import regularly.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Dumping raw transcript into notes | Synthesize — extract decisions, actions, and context only |
| Writing files without confirming routing | Always show proposed destinations and content first |
| Putting all content in one file | A single meeting often routes to 2-3 different knowledge areas |
| Missing action items or owners | Explicitly capture who owes what by when |
