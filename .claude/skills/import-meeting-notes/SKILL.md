---
name: import-meeting-notes
description: Use when the user wants to import, pull, or review meeting notes from Granola. Triggers on phrases like "import meeting notes", "check my recent meetings", "pull notes from my sync", or any request involving Granola meeting notes.
---

# Import Meeting Notes

## Overview

Pulls meeting content from the Granola MCP, synthesizes key details, and routes them to the appropriate knowledge folders. The goal is structured context, not raw transcripts.

## When NOT to use

- The user wants to write notes manually
- Notes aren't from Granola (e.g., pasting from another tool)
- The user just wants to read a meeting summary without importing

## Source

This skill imports from the **Granola MCP**. Call the Granola MCP tool to list recent meetings; each returns a summary with attendees, date, and AI-generated notes. If the MCP server is not configured or returns an error, tell the user: "Granola isn't available — check that the Granola MCP server is configured."

## Tracking imported meetings

To avoid re-presenting meetings already synced, the skill maintains an import log at `data/imported-meetings.json` (gitignored via `data/*.json`).

**Format:** a JSON object with an `imported` array. Each entry has:
- `source` — `"granola"`
- `source_id` — Granola meeting UUID
- `title` — meeting title (for human readability)
- `date` — ISO datetime of the meeting
- `imported_at` — `YYYY-MM-DD` of when it was synced
- `destinations` — array of file paths the synthesis was written to

**Usage:**
- **Before presenting meetings**, read this file (if it exists) and cross-reference IDs against the meetings returned by Granola.
- By default, filter already-imported meetings out of the picker. Briefly mention how many were filtered (e.g., "2 already-imported meetings hidden — say so if you want to re-import"). If the user explicitly wants to re-import one, show it.
- **After a successful import**, append a new entry with the meeting's source, source_id, title, date, `imported_at`, and `destinations`.
- If the log file doesn't exist yet, create it with `{ "imported": [] }` before appending.

## Routing

| Content type | Destination |
|-------------|-------------|
| Person-specific context | `knowledge/people/firstname-lastname.md` |
| Research findings | `knowledge/research/` |
| Strategy/org context | `knowledge/company/` |
| Project decisions | `projects/[project-name]/notes/` |

## Steps

1. **List recent meetings.** Call the Granola MCP tool to list recent meetings. **Load `data/imported-meetings.json`** if it exists and cross-reference against the returned meetings. Filter already-imported meetings from the picker by default (mention the count of hidden meetings so the user can opt to re-import).
2. Show the user what's available (date, attendees, summary), noting which source each came from
3. User picks which meeting(s) to import
4. **Synthesize** the meeting — extract only key details, not raw transcripts:
   - Decisions made
   - Stakeholder positions and sentiment
   - Useful context for future conversations
   - **Do not extract action items** — capture tasks with `/action-items add`
5. Propose where to write — a single meeting may produce multiple files (see Routing table above)
6. Confirm the routing and content with the user before writing anything
7. **Append to the import log.** Add an entry to `data/imported-meetings.json` with the meeting's source, source_id, title, date, today's date as `imported_at`, and the `destinations` list. Create the file with `{"imported": []}` if it doesn't exist yet.

## Output Format

Each destination file gets an appended section like:

```markdown
### YYYY-MM-DD - Topic
- Key point 1
- Key point 2
```

## Example

A research sync with Becky Weinstein might produce:

**→ `knowledge/people/becky-weinstein.md`** (appended)
```markdown
### 2026-04-23 - User research sync
- Wants to run 5 more interviews before we finalize personas
- Concerned about sample bias in the enterprise segment
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
| Extracting action items into local knowledge files | Use `/action-items add` → `data/action-items.md` instead |
