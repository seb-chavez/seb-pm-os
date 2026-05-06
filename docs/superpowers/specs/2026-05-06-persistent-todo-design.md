# Persistent TODO Tracker

## Overview

A file-based, persistent task tracker for the PM OS. Tasks are stored in a markdown file at repo root and managed via a `/todo` skill. Supports both self-generated work items and action items extracted from meeting notes.

## File Format

**Location:** `TODO.md` at repo root (gitignored)

```markdown
# TODO

- [ ] Follow up with Dean on Dattos partnership | due: 2026-05-09
- [ ] Draft Q2 goals | due: 2026-05-12
- [ ] Research competitor pricing
- [x] Prep for board meeting | done: 2026-04-24
```

### Rules

- One task per line, standard markdown checkbox syntax
- Optional `| due: YYYY-MM-DD` suffix for due dates
- Completed items get `[x]` and an appended `| done: YYYY-MM-DD`
- Order = priority. Top of the list = highest priority
- No sections, headers, or grouping beyond the single `# TODO` header
- Flat list — no project tags or categories

## Skill Interface

Skill name: `/todo`

| Command | Behavior |
|---------|----------|
| `/todo` (no args) | List open tasks, highlighting overdue items |
| `/todo add <description>` | Append a new task to the bottom of the list |
| `/todo add <description> \| due: YYYY-MM-DD` | Add with a due date |
| `/todo done <number>` | Mark task N as complete (checkbox + done date) |
| `/todo delete <number>` | Remove task N entirely |
| `/todo move <from> <to>` | Reorder — move task from position to position (for reprioritizing) |

### Display Format

When `/todo` is invoked with no args:

```
## Open Tasks
1. Follow up with Dean on Dattos partnership (due: May 9 — overdue!)
2. Draft Q2 goals (due: May 12)
3. Research competitor pricing

## Recently Completed
- Prep for board meeting (done: Apr 24)
```

- Recently completed shows items finished in the last 7 days
- Older completed items stay in the file but are not displayed unless explicitly asked

## Meeting Notes Integration

When `/import-meeting-notes` runs, after importing notes:

1. Scan the imported notes for action items (patterns like "Action:", "- [ ]", "follow up", "owe", "by [day]")
2. Display detected action items to the user
3. Ask: "Want to add any of these to your TODO?"
4. If yes, append selected items to `TODO.md`

This is an addition to the end of the existing `/import-meeting-notes` skill flow. The `/todo` skill itself stays independent.

## Files Changed

| File | Action |
|------|--------|
| `.claude/skills/todo/SKILL.md` | Create — skill definition |
| `TODO.md` | Create on first `/todo add` — the task list |
| `.gitignore` | Edit — add `TODO.md` |
| `.claude/skills/import-meeting-notes/SKILL.md` | Edit — add action item suggestion step |
