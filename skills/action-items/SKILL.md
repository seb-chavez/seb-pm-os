---
name: action-items
description: Use when capturing, listing, or completing personal action items during or after meetings. Triggers on "action items", "add action item", "capture a task", "what do I owe", "what's outstanding", "mark done", "complete action item".
disable-model-invocation: true
compatibility: Requires GESTALT_API_KEY or gestalt CLI with Linear connected at https://valon.tools/apps
allowed-tools: Bash Read
---

# Action Items

## Overview

Manual task tracker for commitments captured during live meetings. Creates and manages **Linear issues** on the Escrow team with the `product-management` label, assigned to Sebastian, in the **zz - Seb's Product Issues** Linear project. Works in Claude Code, Cursor, and Codex after `./setup.sh <harness>`.

**Backend:** Linear via Gestalt CLI (`gestalt app invoke linear …`). Not MCP — see [Gestalt linear skill](https://valon.tools) for auth. Prerequisites: `GESTALT_URL=https://valon.tools`, `GESTALT_API_KEY` in the environment, Linear connected at https://valon.tools/apps.

Does not write tasks to people files, project notes, or meeting imports.

## Invocation

Skill name is **`action-items`** (plural).

| Harness | Invoke |
|---------|--------|
| **Cursor terminal** (primary) | `agent "/action-items"` one-shot, or run `agent` then type `/action-items` in the session |
| Cursor IDE chat | `/action-items`, `/action-items add …`, `/action-items done …` |
| Claude Code | `/action-items`, `/action-items add …`, `/action-items done …` |
| Codex CLI | `$action-items`, `$action-items add …` (not `/`) |

**Cursor terminal notes:** Run `agent` from the repo root (`seb-pm-os`). After `./setup.sh cursor` or skill changes, exit and start a new `agent` session — the CLI does not hot-reload skills. The `/` autocomplete picker is unreliable for local PM OS skills (200+ toolshed skills dominate); type the full `/action-items` or use `agent "/action-items"` one-shot.

Also works via natural language (e.g. "list my action items", "mark ESC-1234 done").

## When NOT to use

- Importing meeting context (decisions, sentiment) — use `/import-meeting-notes`
- Meeting prep beyond your task list — use `/meeting-prep`

## Linear defaults

Every action item is a Linear issue with these fixed values:

| Field | Value |
|-------|-------|
| **Team** | Escrow (`ESC`) |
| **Label** | `product-management` (always) |
| **Assignee** | Sebastian Chavez (`sebastian.chavez@valon.com`) |
| **Linear project** | `zz - Seb's Product Issues` |
| **Initial state** | Todo |

**Resolved IDs** (use directly — re-resolve via `fetchData` only if creation fails with invalid ID):

| Constant | ID |
|----------|-----|
| Team Escrow | `d00ed9ed-c1d1-410c-93ef-8bc8ff4323b1` |
| Label `product-management` | `2d19d054-ae40-4106-989d-adf5e92d964c` |
| Assignee Sebastian | `d49f19ba-a98f-4649-88bc-50f9723fbed2` |
| Project `zz - Seb's Product Issues` | `db52cfd3-fc05-40f2-b9d5-87d7ed0f385b` |
| State Todo | `c74e787a-bf90-48bd-bd4c-3cf92ddaa54a` |
| State Done | `1b224144-7240-4678-b35f-d69b4248d0d7` |

**Optional vertical labels** (add to `labelIds` when the vertical is set — in addition to `product-management`):

| Vertical | Label name | ID |
|----------|------------|-----|
| `escrow management` | `escrow-management` | `0b4485f7-0b90-43c1-9d96-0933f1ac6cae` |
| `escrow core` | `escrow-core` | `fd5241e8-202f-445c-829c-32f314cbd2bf` |
| (EA/QC work) | `escrow-analysis` | `9d622b29-f7ee-4e4c-aad6-2d7cd98aabc6` |

For `mortgage insurance`, `property insurance`, and `property taxes`, put the vertical in the issue description only (no team label yet).

## Issue format

**Title:** short imperative (e.g. "Write PRD for escrow refunds").

**Description** (markdown body — metadata the old `ai-NNN` blocks used):

```markdown
**Source:** Live meeting with Dean
**Project:** proj-2026-escrow-refunds
**Vertical:** escrow management
**Links:** https://notion.so/...
**Notes:** Cover refund timing and edge cases
```

Omit lines for unset optional fields. Append link URLs to **Links** as comma-separated values.

**Identifier:** Linear returns `ESC-####` (e.g. `ESC-4178`). Use this instead of the old `ai-NNN` IDs.

## Project linking

**Linear project vs description:** Every issue is always added to the Linear project **zz - Seb's Product Issues** (`projectId` on create). Separately, the description **Project** field is an optional canonical folder slug for PM OS context — see below.

When context points at a project, set **Project** in the description to the folder slug under `canonical/projects/` (e.g. `proj-2026-fha-mip-payment-recon-scale`).

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

**When to set it:**
- User names one or more verticals
- Context clearly maps to a vertical (e.g. Assurant/SWBC → `property insurance`; tax installments → `property taxes`; FHA MIP → `mortgage insurance`)
- Cross-cutting platform or multi-surface work → `escrow core`, alone or combined with a vertical

**When to omit:** Admin, hiring, or org-wide work with no product vertical. If unsure between two verticals, include both in the description rather than guessing one.

## Modes

| Mode | Trigger examples | Behavior |
|------|------------------|----------|
| `add` | "add action item", "capture: write PRD", `/action-items add` | Prompt for fields, then create a Linear issue |
| `list` (default) | "action items", "what's open", "what do I owe" | Show open Escrow PM issues assigned to Sebastian |
| `done` | "mark ESC-1234 done", "complete write PRD" | Move issue to Done state |

If the user gives partial info with `add`, capture what they provided and ask only for missing fields.

## Gestalt commands

All invocations use `GESTALT_URL=https://valon.tools gestalt app invoke linear … --format json`.

### Add — create issue

```bash
GESTALT_URL=https://valon.tools gestalt app invoke linear issueCreate --format json \
  -p 'input:={"teamId":"d00ed9ed-c1d1-410c-93ef-8bc8ff4323b1","title":"TITLE","labelIds":["2d19d054-ae40-4106-989d-adf5e92d964c"],"assigneeId":"d49f19ba-a98f-4649-88bc-50f9723fbed2","projectId":"db52cfd3-fc05-40f2-b9d5-87d7ed0f385b","stateId":"c74e787a-bf90-48bd-bd4c-3cf92ddaa54a","description":"DESCRIPTION"}'
```

Add `"dueDate":"YYYY-MM-DD"` to the input object when due date is set. Append optional vertical label IDs to `labelIds`.

**Add flow:**

1. Parse any fields already in the user's message
2. Ask for missing required fields and any useful optional fields — keep it to one short round of questions, not an interrogation
3. Build the description from Source / Project / Vertical / Links / Notes
4. Call `issueCreate` with defaults above
5. Confirm with the Linear identifier (`ESC-####`), URL, and a one-line summary

### List — open issues

Query via `fetchData`:

```bash
GESTALT_URL=https://valon.tools gestalt app invoke linear fetchData --format json \
  -p 'query:="query { issues(filter: { team: { key: { eq: \"ESC\" } }, assignee: { email: { eq: \"sebastian.chavez@valon.com\" } }, labels: { some: { name: { eq: \"product-management\" } } } }, first: 50) { nodes { identifier title dueDate url state { name type } description } } } }"'
```

**Filter client-side:** drop issues where `state.type` is `completed`, `canceled`, or `duplicate`.

**Output format:**

```
## Open Action Items

### Overdue
- **ESC-1234** — Write PRD for escrow refunds — due 2026-06-14 — [Linear](url)

### Due this week
- **ESC-1235** — Review escrow metrics — due 2026-06-18

### No due date
- **ESC-1236** — Follow up with legal on wording
```

Omit empty sections. Sort within each bucket by due date ascending. Parse **Project** / **Vertical** from description when present for display.

### Done — complete issue

1. Match by identifier (`ESC-1234`) or fuzzy-match on title if no ID given
2. If ambiguous, ask which issue
3. Resolve issue UUID if only identifier given (use `fetchData` with `issue(id: "ESC-1234")` or search)
4. Update state to Done:

```bash
GESTALT_URL=https://valon.tools gestalt app invoke linear issueUpdate --format json \
  -p 'id:="ISSUE_UUID"' \
  -p 'input:={"stateId":"1b224144-7240-4678-b35f-d69b4248d0d7"}'
```

Use quoted JSON for `id` (`id:="uuid"`). Identifier-only updates: resolve UUID first via `fetchData`.

5. Confirm completion with identifier and URL

## Add — fields to collect

| Field | Required | Notes |
|-------|----------|-------|
| Action | Yes | Short imperative title (Linear issue title) |
| Due | No | `YYYY-MM-DD` or relative date interpreted in user's timezone |
| Source | No | Meeting, person, or context where it came up |
| Project | No | Active project folder slug — see [Project linking](#project-linking) |
| Vertical | No | One or more team verticals — see [Vertical tagging](#vertical-tagging) |
| Links | No | Comma-separated URLs (Notion doc, ticket, etc.) |
| Notes | No | Extra context |

## Rules

- **Only create/update Linear issues** via this skill — never store action items in people files, project notes, Granola imports, or `canonical/action-items.md`
- Always apply team **Escrow**, label **`product-management`**, assignee **Sebastian**, and Linear project **zz - Seb's Product Issues**
- Use today's date when interpreting relative due dates unless the user specifies otherwise
- If Gestalt/Linear is unavailable, tell the user: "Linear isn't available — check GESTALT_API_KEY and connect Linear at https://valon.tools/apps"

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Writing tasks to people or project notes | All tasks go to Linear via this skill only |
| Writing to `canonical/action-items.md` | Deprecated — use Linear |
| Using old `ai-NNN` IDs | Use Linear identifiers (`ESC-####`) |
| Forgetting `product-management` label | Always include `2d19d054-ae40-4106-989d-adf5e92d964c` in `labelIds` |
| Missing assignee or Linear project | Always set `assigneeId` to Sebastian and `projectId` to `zz - Seb's Product Issues` |
| Unquoted UUID in `issueUpdate -p id:=…` | Use `-p 'id:="uuid"'` (JSON string) |
| Asking for every optional field when user is mid-meeting | Capture action first; ask for due date and links in one short follow-up |
| Linking to archived or wrong projects | Only set **Project** for folders under `canonical/projects/proj-*`; never `_archive/` |
| Invalid vertical values | Use only the five allowed verticals in the description |
