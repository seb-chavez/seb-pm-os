---
name: action-items
description: Use when capturing, listing, or completing personal action items during or after meetings. Triggers on "action items", "add action item", "capture a task", "what do I owe", "what's outstanding", "mark done", "complete action item".
disable-model-invocation: true
---

# Action Items

## Overview

Manual task tracker for commitments captured during live meetings. Stores items in `canonical/action-items.md` with stable IDs. Works in Claude Code, Cursor, and Codex after `./setup.sh <harness>`.

## Invocation

Skill name is **`action-items`** (plural).

| Harness | Invoke |
|---------|--------|
| **Cursor terminal** (primary) | `agent "/action-items"` one-shot, or run `agent` then type `/action-items` in the session |
| Cursor IDE chat | `/action-items`, `/action-items add …`, `/action-items done …` |
| Claude Code | `/action-items`, `/action-items add …`, `/action-items done …` |
| Codex CLI | `$action-items`, `$action-items add …` (not `/`) |

**Cursor terminal notes:** Run `agent` from the repo root (`seb-pm-os`). After `./setup.sh cursor` or skill changes, exit and start a new `agent` session — the CLI does not hot-reload skills. The `/` autocomplete picker is unreliable for local PM OS skills (200+ toolshed skills dominate); type the full `/action-items` or use `agent "/action-items"` one-shot.

Also works via natural language (e.g. "list my action items", "mark ai-003 done").

Does not write tasks to people files, project notes, or meeting imports.

## When NOT to use

- Importing meeting context (decisions, sentiment) — use `/import-meeting-notes`
- Meeting prep beyond your task list — use `/meeting-prep`

## Storage

**File:** `canonical/action-items.md` (gitignored — personal data)

On first use, create the file from `canonical/action-items.template.md` if it does not exist.

**ID format:** `ai-001`, `ai-002`, … — assign the next sequential ID by scanning existing `### ai-NNN` headings in the file.

**Item format:**

```markdown
### ai-003 — Write PRD for escrow refunds
- **Status:** open
- **Created:** 2026-06-16
- **Due:** 2026-06-20
- **Source:** Live meeting with Dean
- **Project:** proj-2026-escrow-refunds
- **Vertical:** escrow management
- **Links:** https://notion.so/...
- **Notes:** Cover refund timing and edge cases
```

Omit **Project** when no active project applies. Omit **Vertical** when no product vertical applies. Completed items move from `## Open` to `## Done`. Set `**Status:** done` and add `**Completed:** YYYY-MM-DD`. Keep all other fields.

## Project linking

When context points at a project, set **Project** to the folder slug under `canonical/projects/` (e.g. `proj-2026-fha-mip-payment-recon-scale`). Resolved path: `canonical/projects/<slug>/`.

**When to set it:**
- User names a `proj-*` slug or project folder
- Title, source, links, or notes clearly map to one active (non-archived) project

**How to resolve:**
1. List folders matching `canonical/projects/proj-*` (exclude `canonical/projects/_archive/`)
2. Prefer an explicit slug in the user's message
3. Otherwise fuzzy-match on keywords in the action title or source against folder names and `brief.md` / `prd.md` titles in candidate folders
4. If ambiguous or no match, omit **Project** — do not guess

**Do not link** to archived projects (`canonical/projects/_archive/`) or cross-cutting work with no single project home.

## Vertical tagging

Tag items with the Escrow team product vertical(s) they touch. Charter reference: [Escrow Team Charter](https://app.notion.com/p/valonlabs/Escrow-Team-Charter-32f2df0ff7ba8082b0feda9e11bfcf8a).

**Allowed values** (use exactly — lowercase):

| Vertical | Typical scope |
|----------|----------------|
| `escrow management` | Escrow analysis, cushions, refunds, escrow accounts, borrower escrow experience |
| `mortgage insurance` | FHA MIP, PMI, mortgage insurance premiums and recon |
| `property insurance` | Hazard insurance, PI vendor integrations, loss draft, force-placed |
| `property taxes` | Tax installments, tax authority payments, tax data |
| `escrow core` | Shared escrow platform, cross-vertical infrastructure, workflows, branding/cutover spanning surfaces |

**Format:** `- **Vertical:** escrow management` for one; comma-separated for multiple: `- **Vertical:** escrow management, escrow core`

**When to set it:**
- User names one or more verticals
- Context clearly maps to a vertical (e.g. Assurant/SWBC → `property insurance`; tax installments → `property taxes`; FHA MIP → `mortgage insurance`)
- Cross-cutting platform or multi-surface work → `escrow core`, alone or combined with a vertical

**When to omit:** Admin, hiring, or org-wide work with no product vertical. If unsure between two verticals, include both rather than guessing one.

## Modes

| Mode | Trigger examples | Behavior |
|------|------------------|----------|
| `add` | "add action item", "capture: write PRD", `/action-items add` | Prompt for fields, then append to `## Open` |
| `list` (default) | "action items", "what's open", "what do I owe" | Show open items only |
| `done` | "mark ai-003 done", "complete write PRD" | Move item to `## Done`, update status |

If the user gives partial info with `add`, capture what they provided and ask only for missing fields.

## Add — fields to collect

| Field | Required | Notes |
|-------|----------|-------|
| Action | Yes | Short imperative title (becomes the `### ai-NNN — [title]` heading) |
| Due | No | `YYYY-MM-DD` or relative date interpreted in user's timezone |
| Source | No | Meeting, person, or context where it came up |
| Project | No | Active project folder slug — see [Project linking](#project-linking) |
| Vertical | No | One or more team verticals — see [Vertical tagging](#vertical-tagging) |
| Links | No | Comma-separated URLs (Notion doc, ticket, etc.) |
| Notes | No | Extra context |

**Add flow:**

1. Parse any fields already in the user's message
2. Ask for missing required fields and any useful optional fields — keep it to one short round of questions, not an interrogation
3. Assign the next `ai-NNN` ID
4. Append the item under `## Open` in `canonical/action-items.md`
5. Confirm with the assigned ID and a one-line summary

## List — output format

```
## Open Action Items

### Overdue
- **ai-001** — Write PRD for escrow refunds — due 2026-06-14 — project: proj-2026-escrow-refunds — vertical: escrow management — source: Dean sync

### Due this week
- **ai-003** — Review escrow metrics — due 2026-06-18 — project: proj-2026-escrow-deployos — vertical: escrow management

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

- **Only write to `canonical/action-items.md`** — never store action items in people files, project notes, or Granola imports
- Preserve completed items in `## Done` for history
- Use today's date for `Created` and `Completed` unless the user specifies otherwise

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Writing tasks to people or project notes | All tasks go to `canonical/action-items.md` only |
| Deleting completed items | Move to `## Done` and update status |
| Reusing or skipping IDs | Always scan the file and assign the next `ai-NNN` |
| Asking for every optional field when user is mid-meeting | Capture action first; ask for due date and links in one short follow-up |
| Linking to archived or wrong projects | Only set **Project** for folders under `canonical/projects/proj-*`; never `_archive/` |
| Invalid vertical values | Use only the five allowed verticals; comma-separate multiples |
