---
name: weekly-priorities
description: Use when drafting or updating the weekly priorities post for #servicing-pm. Triggers on "weekly priorities", "draft my priorities", "this week's priorities", "priorities for the week", "update priorities slack link", "sync priorities permalink".
disable-model-invocation: true
---

# Weekly Priorities

## Overview

Drafts the forward-looking weekly priorities list for **#servicing-pm** and prepends a new week block to `canonical/PRIORITIES.md`. User posts to Slack manually, then optionally returns with the permalink to record it.

**Slack channel:** [#servicing-pm](https://valon-technologies.slack.com/archives/C09BLTWGTGR) (`C09BLTWGTGR`)

Weeks always start **Monday**. The week heading uses that Monday's date: `**Week of YYYY-MM-DD**`.

## Slack formatting

`PRIORITIES.md` week blocks double as the Slack post — use formatting Slack renders correctly:

- **Week and area labels** — bold, not `#` / `##` / `###` (Slack ignores heading syntax)
- **Items** — plain text: `- [ ] Title — context`. Do not bold every item title; reserve bold for a specific emphasis inside the line if needed
- **Slack-ready copy** — the week block only: from `**Week of …**` through the last item. Omit the file title, intro paragraph, `---` separators, and the `**Slack:**` metadata line

## Invocation

`/weekly-priorities` — or natural language (e.g. "draft my weekly priorities", "priorities for next week").

| Mode | Trigger examples |
|------|------------------|
| **Draft** (default) | `/weekly-priorities`, "draft this week's priorities" |
| **Link** | `/weekly-priorities link <slack-url>`, "add the slack link for this week" |

## When NOT to use

- Backward-looking recap of the past week — use `/weekly-digest`
- Stakeholder status document — use `/status-report`
- Capturing a single task from a meeting — use `/action-items`

## Area sections

Use these headings in this order; **omit sections with no items**:

1. Admin
2. Escrow Management
3. Property Insurance
4. Property Taxes
5. Mortgage Insurance

## Draft workflow

### 1. Determine the target Monday

- **This week** (default): the Monday of the calendar week containing today.
- **Next week**: the Monday after the current week's Monday.
- If the user names a date, use the Monday of that week.

Do not create a duplicate week block — if that Monday already exists in `PRIORITIES.md`, offer to edit it instead of prepending a new one.

### 2. Gather context

Read in parallel where possible:

| Source | Use for |
|--------|---------|
| `canonical/PRIORITIES.md` | Carry forward unchecked `[ ]` items from the most recent week; note recently completed `[x]` items only if they inform what's next |
| `canonical/action-items.md` | Open commitments that belong on the public priorities list (not every action item — filter to team-visible work) |
| `canonical/GOALS.md` | Quarterly focus — surface goals that need attention this week |
| `canonical/projects/*/notes/*.md` | Last 7 days of notes per active project — emerging work, blockers, next steps |

If `canonical/PRIORITIES.md` does not exist, create it from `canonical/PRIORITIES.template.md`.

### 3. Draft items

Each item is one line:

```markdown
- [ ] Short title — brief context or next step
```

Rules:

- **Carry forward** unchecked items from last week unless clearly done or no longer relevant (ask before dropping).
- **Propose new items** from gathered context; do not invent work with no source.
- **Keep titles scannable** — short noun phrase; em dash for one line of context. No bold on titles by default.
- **Drop empty area sections** — do not include placeholder sections.
- Cap at ~8–12 items total unless the user asks for more; flag overflow as "stretch" or defer to next week.

### 4. Present for review

Show:

1. **Target week** — `Week of YYYY-MM-DD` (Monday)
2. **Draft list** — grouped by area, same format as the file
3. **Sources** — one line each on what drove new vs carried items
4. **Slack-ready copy** — the week block only (no file header, no `**Slack:**` line, no `---`); ready to paste into #servicing-pm

Ask the user to edit, approve, or add/remove items before writing.

### 5. Write to PRIORITIES.md

On approval, prepend a new week block **below** the file intro (after the `---` following the rolling-tracker paragraph):

```markdown
**Week of YYYY-MM-DD**

**Slack:** _(post to #servicing-pm, then run `/weekly-priorities link <url>`)_

**Admin**
- [ ] Title — context
...
---

```

Leave the placeholder Slack line until the user provides a permalink.

### 6. Remind user to post

After writing, tell the user:

1. Paste the **Slack-ready copy** into [#servicing-pm](https://valon-technologies.slack.com/archives/C09BLTWGTGR)
2. Copy the message permalink and run `/weekly-priorities link <url>` (or paste the URL in chat)

## Link workflow

When the user provides a Slack message permalink for the current (or named) week:

1. Parse the week from context or ask which `**Week of YYYY-MM-DD**` block to update
2. Replace the `**Slack:**` line with:

```markdown
**Slack:** [#servicing-pm post](<permalink>) *(last edited YYYY-MM-DD)*
```

Use today's date for `last edited`.

## Checkbox sync

When the user marks items done in Slack or in conversation:

- Update checkboxes in `PRIORITIES.md` for the relevant week (`[ ]` → `[x]`)
- Do not auto-sync from Slack API — user drives updates via chat or manual edits

## Common mistakes

| Mistake | Fix |
|---------|-----|
| Using Sunday or Friday as week start | Always use Monday's date in the heading |
| Including every open action item | Only items appropriate for the public #servicing-pm post |
| Leaving empty area sections | Drop sections with no items |
| Writing before user approves the draft | Present draft first; write only on confirmation |
| Duplicating a week block | Check for existing `**Week of` before prepending |
| Using `#` headings in week blocks | Use `**Week of …**` and `**Area**` — Slack won't render markdown headings |
| Bolding every item title | Plain item lines; bold only for deliberate emphasis |
