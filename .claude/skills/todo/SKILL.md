---
name: todo
description: Use when the user wants to manage their persistent task list. Triggers on "todo", "add a task", "mark done", "what's on my list", "my action items", "what's overdue", "reprioritize".
---

# TODO

## Overview

Manages a persistent task list stored in `TODO.md` at the repo root. Tasks persist across sessions. Supports adding, completing, deleting, reordering, and listing tasks.

## When NOT to use

- The user is asking about Claude Code's built-in `/tasks` command (that manages background bash processes)
- The user wants to track project-level milestones (use `GOALS.md` instead)

## File Format

`TODO.md` lives at repo root and is gitignored. Format:

    # TODO

    - [ ] Task description | due: YYYY-MM-DD
    - [ ] Task without a due date
    - [x] Completed task | done: YYYY-MM-DD

Rules:
- One task per line, markdown checkbox syntax
- Optional `| due: YYYY-MM-DD` suffix for due dates
- Completed items: `[x]` with appended `| done: YYYY-MM-DD`
- Order = priority (top = highest)
- Single `# TODO` header, flat list, no grouping

## Commands

Parse the user's arguments to determine which command to run:

| Input | Command |
|-------|---------|
| No args, or "list" | **List** |
| `add <description>` | **Add** |
| `add <description> \| due: YYYY-MM-DD` | **Add with due date** |
| `done <number>` | **Done** |
| `delete <number>` | **Delete** |
| `move <from> <to>` | **Move** |

### List (default)

1. Read `TODO.md`. If it doesn't exist, say: "No tasks yet. Use `/todo add <description>` to create your first task."
2. Parse all lines into open and completed items
3. Display open items as a numbered list. For each item with a due date, compare to today's date. If overdue, append " — overdue!" to the display.
4. Display recently completed items (done within the last 7 days) as a bullet list below, under a "Recently Completed" heading.
5. If no open items exist, say: "All clear — no open tasks."

Display format:

    ## Open Tasks
    1. Follow up with Dean on Dattos partnership (due: May 2 — overdue!)
    2. Draft Q2 goals (due: May 12)
    3. Research competitor pricing

    ## Recently Completed
    - Prep for board meeting (done: Apr 24)

### Add

1. If `TODO.md` doesn't exist, create it with the `# TODO` header
2. Parse the description and optional `| due: YYYY-MM-DD` from the arguments
3. Append `- [ ] <description>` (with due date suffix if provided) to the end of the open tasks (before any completed items). New tasks default to lowest priority; use `/todo move` to reprioritize.
4. Confirm: "Added: <description>"

### Done

1. Read `TODO.md` and parse open items into a numbered list
2. Find the open item at position N (1-indexed)
3. Change `- [ ]` to `- [x]` and append `| done: YYYY-MM-DD` (today's date)
4. Move the line to the end of the file (after all open items, with other completed items)
5. Confirm: "Completed: <description>"

### Delete

1. Read `TODO.md` and parse open items into a numbered list
2. Find the open item at position N (1-indexed)
3. Remove the line entirely
4. Confirm: "Deleted: <description>"

### Move

1. Read `TODO.md` and parse open items into a numbered list
2. Remove the item at position `from` and insert it at position `to` in the resulting list. Example: given [A, B, C, D], `move 4 1` produces [D, A, B, C].
3. Write the updated file
4. Confirm: "Moved: <description> to position <to>"

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| `TODO.md` doesn't exist on list/done/delete/move | Say "No tasks yet. Use `/todo add` to create one." |
| Task number out of range | Say "Task N doesn't exist. You have N open tasks." |
| `move` with same from and to | Say "Task is already at position N." |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Numbering includes completed items | Only number open items — completed items are a separate unnumbered section |
| Forgetting to move completed items to bottom | Completed items always go after all open items |
| Creating TODO.md on list/done/delete when it doesn't exist | Only create the file on `add` |
| Displaying all completed items | Only show items completed in the last 7 days |
