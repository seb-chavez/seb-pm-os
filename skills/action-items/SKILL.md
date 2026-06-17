---
name: action-items
description: Use when capturing, listing, or completing personal action items during or after meetings. Triggers on "action items", "add action item", "capture a task", "what do I owe", "what's outstanding", "mark done", "complete action item".
---

# Action Items

## Overview

Manual task tracker for commitments captured during live meetings. Stores items in `data/action-items.md` with stable IDs. Works in Claude Code, Cursor, and Codex after `./setup.sh <harness>`.

## Invocation

| Harness | Examples |
|---------|----------|
| Claude Code | `/action-items`, `/action-items add write PRD for X`, `/action-items done ai-001` |
| Cursor | "add action item", "list my action items", "mark ai-001 done" |
| Codex | `$action-items`, `$action-items add write PRD for X` |

Does not write tasks to people files, project notes, or meeting imports.

## When NOT to use

- Importing meeting context (decisions, sentiment) — use `/import-meeting-notes`
- Meeting prep beyond your task list — use `/meeting-prep`

## Storage

**File:** `data/action-items.md` (gitignored — personal data)

On first use, create the file from `data/action-items.template.md` if it does not exist.

**ID format:** `ai-001`, `ai-002`, … — assign the next sequential ID by scanning existing `### ai-NNN` headings in the file.

**Item format:**

```markdown
### ai-003 — Write PRD for escrow refunds
- **Status:** open
- **Created:** 2026-06-16
- **Due:** 2026-06-20
- **Source:** Live meeting with Dean
- **Links:** https://notion.so/...
- **Notes:** Cover refund timing and edge cases
```

Completed items move from `## Open` to `## Done`. Set `**Status:** done` and add `**Completed:** YYYY-MM-DD`. Keep all other fields.

## Modes

| Mode | Trigger examples | Behavior |
|------|------------------|----------|
| `add` | "add action item", "capture: write PRD", `/action-items` (Claude only) | Prompt for fields, then append to `## Open` |
| `list` (default) | "action items", "what's open", "what do I owe" | Show open items only |
| `done` | "mark ai-003 done", "complete write PRD" | Move item to `## Done`, update status |

If the user gives partial info with `add`, capture what they provided and ask only for missing fields.

## Add — fields to collect

| Field | Required | Notes |
|-------|----------|-------|
| Action | Yes | Short imperative title (becomes the `### ai-NNN — [title]` heading) |
| Due | No | `YYYY-MM-DD` or relative date interpreted in user's timezone |
| Source | No | Meeting, person, or context where it came up |
| Links | No | Comma-separated URLs (Notion doc, ticket, etc.) |
| Notes | No | Extra context |

**Add flow:**

1. Parse any fields already in the user's message
2. Ask for missing required fields and any useful optional fields — keep it to one short round of questions, not an interrogation
3. Assign the next `ai-NNN` ID
4. Append the item under `## Open` in `data/action-items.md`
5. Confirm with the assigned ID and a one-line summary

## List — output format

```
## Open Action Items

### Overdue
- **ai-001** — Write PRD for escrow refunds — due 2026-06-14 — source: Dean sync

### Due this week
- **ai-003** — Review escrow metrics — due 2026-06-18

### No due date
- **ai-005** — Follow up with legal on wording
```

Omit empty sections. Sort within each bucket by due date ascending.

## Done flow

1. Match by ID (`ai-003`) or fuzzy-match on action title if no ID given
2. If ambiguous, ask which item
3. Set status to `done`, add `**Completed:**` today's date
4. Move the entire item block from `## Open` to `## Done`
5. Confirm completion

## Rules

- **Only write to `data/action-items.md`** — never store action items in people files, project notes, or Granola imports
- Preserve completed items in `## Done` for history
- Use today's date for `Created` and `Completed` unless the user specifies otherwise

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Writing tasks to people or project notes | All tasks go to `data/action-items.md` only |
| Deleting completed items | Move to `## Done` and update status |
| Reusing or skipping IDs | Always scan the file and assign the next `ai-NNN` |
| Asking for every optional field when user is mid-meeting | Capture action first; ask for due date and links in one short follow-up |
