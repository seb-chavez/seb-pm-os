# Persistent TODO Tracker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a persistent, file-based task tracker to the PM OS with a `/todo` skill and meeting notes integration.

**Architecture:** A `TODO.md` markdown file at repo root (gitignored) stores tasks as checkboxes. A `/todo` skill provides list/add/done/delete/move operations. The existing `/import-meeting-notes` skill gets a new final step that suggests detected action items for addition.

**Tech Stack:** Markdown, Claude Code skills (SKILL.md files)

---

### Task 1: Add TODO.md to .gitignore

**Files:**
- Modify: `.gitignore`

- [ ] **Step 1: Add TODO.md to gitignore**

Add `TODO.md` to the `.gitignore` file. Place it after the existing entries, with a comment explaining why.

Add these lines at the end of `.gitignore`:

```
# Persistent task list (contains sensitive action items)
TODO.md
```

- [ ] **Step 2: Commit**

```bash
git add .gitignore
git commit -m "chore: gitignore TODO.md for persistent task tracker"
```

---

### Task 2: Create the /todo skill

**Files:**
- Create: `.claude/skills/todo/SKILL.md`

- [ ] **Step 1: Create the skill directory**

```bash
mkdir -p .claude/skills/todo
```

- [ ] **Step 2: Write the skill file**

Create `.claude/skills/todo/SKILL.md` with this exact content:

```markdown
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
    1. Follow up with Dean on Dattos partnership (due: May 9 — overdue!)
    2. Draft Q2 goals (due: May 12)
    3. Research competitor pricing

    ## Recently Completed
    - Prep for board meeting (done: Apr 24)

### Add

1. If `TODO.md` doesn't exist, create it with the `# TODO` header
2. Parse the description and optional `| due: YYYY-MM-DD` from the arguments
3. Append `- [ ] <description>` (with due date suffix if provided) to the end of the open tasks (before any completed items)
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
2. Remove the item at position `from` and insert it at position `to`
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
```

- [ ] **Step 3: Verify the skill file is valid**

Read back `.claude/skills/todo/SKILL.md` and confirm the frontmatter and content are correct.

- [ ] **Step 4: Commit**

```bash
git add .claude/skills/todo/SKILL.md
git commit -m "feat: add /todo skill for persistent task tracking"
```

---

### Task 3: Update /import-meeting-notes to suggest action items

**Files:**
- Modify: `.claude/skills/import-meeting-notes/SKILL.md`

- [ ] **Step 1: Add a new step 8 to the import-meeting-notes skill**

After the existing step 7 ("Clean up local source files"), add a new step 8. Insert the following after step 7 in the Steps section:

```markdown
8. **Suggest action items for TODO.** After importing, scan the synthesized notes for action items — look for patterns like "Action:", "- [ ]", "follow up", "owe", "by [day]", "need to", "should". Display any detected action items and ask: "Want to add any of these to your TODO?" If the user selects items, append them to `TODO.md` (create the file with a `# TODO` header if it doesn't exist). Use the format `- [ ] <description> | due: YYYY-MM-DD` if a date was detected, otherwise `- [ ] <description>`.
```

- [ ] **Step 2: Add a row to the Common Mistakes table**

Append this row to the Common Mistakes table in the import-meeting-notes skill:

```markdown
| Skipping action item suggestion | Always run step 8 after import — even if no action items are detected, confirm "No action items found in this meeting." |
```

- [ ] **Step 3: Verify the updated skill**

Read back `.claude/skills/import-meeting-notes/SKILL.md` and confirm:
- Step 8 exists after step 7
- The new Common Mistakes row is present
- Existing content is unchanged

- [ ] **Step 4: Commit**

```bash
git add .claude/skills/import-meeting-notes/SKILL.md
git commit -m "feat: suggest action items for TODO after meeting import"
```

---

### Task 4: Manual smoke test

- [ ] **Step 1: Test /todo add**

Run `/todo add Test task from smoke test | due: 2026-05-10` and verify:
- `TODO.md` was created at repo root with `# TODO` header
- The task line is present: `- [ ] Test task from smoke test | due: 2026-05-10`

- [ ] **Step 2: Test /todo list**

Run `/todo` with no args and verify:
- The task shows as `1. Test task from smoke test (due: May 10)`
- No "Recently Completed" section appears (nothing completed yet)

- [ ] **Step 3: Test /todo done**

Run `/todo done 1` and verify:
- The task changes to `- [x] Test task from smoke test | due: 2026-05-10 | done: 2026-05-06`
- It appears under "Recently Completed" when listing

- [ ] **Step 4: Clean up**

Delete `TODO.md` (it was a test artifact). It will be recreated when you first use `/todo add` for real.

```bash
rm TODO.md
```
