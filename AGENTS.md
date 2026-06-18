# PM Operating System — Canonical Instructions

Harness-neutral instructions for PM work. Every harness (Claude Code, Codex, Cursor) loads this file. Harness-specific rules live in `harness/<name>/` overlays, not here.

## Workflow

How changes to this repo are made:

- **Never push to `main`/`master` directly.** Every change lands via a feature branch + PR.
- **Use a git worktree for agent-run or multi-commit work; a plain branch for small edits.** `setup.sh` symlinks your live `~/.claude`/`~/.codex`/`~/.cursor` config to absolute paths in the main checkout, so editing those paths on a branch can dangle your live symlinks. A worktree keeps the main checkout (and its symlinks) stable while the work happens in a separate folder.
- **Commit in small logical steps** locally, then push the branch and open a PR.
- **CI must be green before merge.** `.github/workflows/ci.yml` runs `scripts/verify-setup.sh` (symlink/idempotency/drift), `shellcheck`, and content invariants on every PR.
- **After a PR merges, re-run `./setup.sh <harness>` locally** to re-point your symlinks at the updated files. This is the only "deploy" step.
- **Never use destructive git operations** (`reset --hard`, `push --force`, `branch -D`) without explicit user approval for the specific action.
- **Don't commit unless the user explicitly asks.**

## Writing & Communication

Default to the brevity a real person would use. The failure mode to avoid is the
"slop grenade": dropping a long AI-generated block where a human would write a
line or two. It wastes the reader's time, buries the one sentence that matters,
and kills dialogue by leaving no room to reply.

- **Match the medium.** Slack, chat, and email replies are short by nature —
  one to three sentences, then stop. Reserve length for things meant to be long
  (PRDs, briefs, specs).
- **Sharpen, don't inflate.** The job is to make the point clearer, not longer.
  Cut anything that doesn't carry meaning.
- **Lead with the answer.** Put the conclusion or the ask first; add context
  only if the reader needs it to act.
- **Leave room to respond.** A reply should invite pushback, not foreclose it
  with an exhaustive monologue.
- **Skip the scaffolding.** No throat-clearing intros, no restating the
  question, no "let me know if you have questions" filler, no summary of what
  you just said.

When in doubt, write less. A 90%-there sentence the reader can act on beats a
complete essay they have to mine. (Spirit: noslopgrenade.com and nohello.net.)

## Granola Meeting Notes

This project has a Granola MCP integration. When the user asks to import or check meeting notes:

### Step 1: Pull and present
- Use the Granola MCP tools (`list_meetings`, `get_meetings`) to pull recent meetings
- Show the user what's available (date, attendees, brief summary)
- Ask which meeting(s) to import

### Step 2: Synthesize, don't copy
- **Never store raw transcripts or full meeting dumps.** Extract only the important details:
  - Key decisions made
  - Stakeholder positions, concerns, or sentiment
  - Context that would be useful in future conversations
- **Do not extract or store action items during meeting imports.** Capture tasks manually with the `action-items` skill during or after meetings.
- Keep it concise — this is a knowledge base, not a transcript archive

### Step 3: Route to multiple destinations
A single meeting often updates several files. For example, a user research sync with Becky Weinstein should:
- Update `canonical/research/` with the research findings, insights, or methodology discussed
- Update `canonical/people/becky-weinstein.md` with Becky-specific context (her concerns, priorities, what you owe her)

Routing rules:
| Content type | Destination |
|-------------|-------------|
| Person-specific context (opinions, style, priorities) | `canonical/people/firstname-lastname.md` |
| Research findings, insights, methodology | `canonical/research/` |
| Strategy, positioning, org changes | `canonical/company/` |
| Project-specific decisions or progress | `canonical/projects/[project-name]/notes/YYYY-MM-DD-topic.md` |

### Step 4: Confirm before writing
- Present the proposed routing: which files will be created/updated and with what content
- **Always ask the user to confirm**, especially with ambiguous names or multi-destination writes

### Step 5: Write
- For people files: **append** a new dated `### YYYY-MM-DD - [topic]` entry under `## Meeting notes`. Never overwrite existing entries.
- For research/company/project files: create or append as appropriate
- Follow the template structure from `canonical/people/README.md` for people files

Basic plan limits: 30-day history, no transcript access. Import regularly to persist notes before they age out.

## Gestalt (CLI only)

Gestalt is **not** in `.mcp.json`. Valon apps (Slack, Linear, BigQuery, etc.) are accessed via the Gestalt CLI, not MCP — the Gestalt MCP server exposes too many tools for agent harnesses.

**Prerequisites:** `GESTALT_URL=https://valon.tools` and `GESTALT_API_KEY` in the environment (typically `~/.zshrc`). The `gestalt` CLI must be installed (`brew install valon-technologies/gestalt/gestalt` or equivalent).

**When the user needs Valon app data:**
- Run `gestalt app invoke <app> <operation> …` via Bash, or follow the toolshed `gestalt` / per-app skills if installed.
- Connect apps at https://valon.tools/apps before first use.

Do not add Gestalt to `.mcp.json`.

## Action Items

Personal action items live in `canonical/action-items.md` (gitignored). Use the `action-items` skill to capture a task during a meeting, list open items, or mark one complete. Do not write action items to people profiles, project notes, or meeting imports.

## Document Templates

When asked to create a document, use the matching template from this repo as the structural blueprint. Read the template file, then fill in every section with real content based on the user's input.

Always apply the formatting defaults from `memory/doc-formatting.md` when generating any document.

If the user asks to "create a document" without specifying a type, ask which format they want.

| Keyword | Template |
|---------|----------|
| "PRD" or "product requirements document" | `templates/prds/prd.md` |
| "agenda" | `templates/meetings/agenda.md` |
| "meeting notes" | `templates/meetings/meeting-notes.md` |
| "decision log" or "decision record" | `templates/meetings/decision-log.md` |
| "project brief" | `templates/strategy/project-brief.md` |
| "status update" or "status report" | `templates/strategy/status-update.md` |
| "roadmap" | `templates/strategy/roadmap.md` |

### Default destination: Notion

Generated docs (PRD, project brief, status update, roadmap, meeting notes, decision log) **push to Notion by default**, not just to a local file. Valon's canonical doc home is the workspace-level **Documents** database (data source `collection://28e2df0f-f7ba-80ea-8f77-000b22c3b280`).

Use the Notion MCP `notion-create-pages` tool with `parent.type = "data_source_id"` and the Documents data source ID.

**Defaults for new pages created by the Escrow PM:**

| Property | Value |
|----------|-------|
| `Doc name` (title) | Title of the doc (e.g., "PRD: [Feature]") |
| `Document Type` | `["PRD"]`, `["Proposal"]`, `["Notes"]`, etc. — match the template type |
| `Document Status` | `"In progress"` (use `"Not started"` if it's a placeholder) |
| `Status` | `"Draft"` for fresh docs; `"In Review"` once shared |
| `Group Tag` | Escrow page: `https://www.notion.so/2992df0ff7ba8044b56ee79426ac8988` |
| `Document Owner` | sebastian.chavez@valon.com (look up user ID via Notion MCP `notion-search` with `query_type=user` if needed) |

**Document Type → template mapping:**
- PRD template → `Document Type: ["PRD"]`
- Project brief → `Document Type: ["Proposal"]`
- Status update → `Document Type: ["Update"]`
- Roadmap → `Document Type: ["Strategy"]`
- Meeting notes → `Document Type: ["Notes"]`
- Decision log → `Document Type: ["Documentation"]`

**Workflow:**
1. Generate the doc content per the local template, applying `memory/doc-formatting.md`.
2. Before pushing, show the user a one-line summary: title, Document Type, Group Tag, Status, parent.
3. After user confirms, call Notion MCP `notion-create-pages` and return the resulting Notion URL.
4. If the user wants a different parent page (e.g., nested under a Project), ask before pushing.

Full schema and option values: see memory `reference-valon-notion-documents-db`.

## Skills

Playbooks live in `skills/<name>/SKILL.md`. Run `./setup.sh <harness>` once per harness to symlink them into that tool's global skills directory.

| Skill | Purpose |
|-------|---------|
| `action-items` | Capture, list, or complete personal action items (`canonical/action-items.md`) |
| `meeting-prep` | Pull context on a person or topic before a meeting |
| `import-meeting-notes` | Pull and synthesize meeting notes from Granola |
| `weekly-digest` | Summarize activity across projects for the past week |
| `status-report` | Draft a cross-project status update from recent notes and goals |
| `knowledge-health` | Flag gaps and staleness in the knowledge base |
| `review-panel` | Multi-persona panel review with synthesized feedback |
| `review-pessimist` / `review-optimist` / `review-sme` / `review-new-hire` / `review-operator` / `review-budget` / `review-engineer` / `review-executive` / `review-champion-user` | Single-persona document review |
| `job-transition` | Archive and reset the OS when leaving a role |

**How to invoke (same skill, different UI):**

| Harness | Invocation |
|---------|------------|
| Claude Code | `/action-items`, `/meeting-prep dean`, etc. after `./setup.sh claude` |
| Cursor IDE | `/action-items`, `/meeting-prep dean`, etc. after `./setup.sh cursor` |
| Cursor terminal | `agent` then `/action-items` — or `agent "/action-items"` from the shell |
| Codex | `$action-items` or `/skills` after `./setup.sh codex` |

Cursor and Codex also match skills from natural language when the task fits the skill `description`.

## Context Conservation

When your harness supports sub-agents, prefer delegating research and exploration to a sub-agent to preserve main-session context. Rule of thumb: if a task needs 5+ read-only tool calls just to gather information, delegate it and keep only the summary. If your harness has no sub-agent capability, research inline but summarize aggressively rather than letting raw file dumps accumulate. See the `delegate-research` skill for the full protocol.

## Parallel Dispatch & File Isolation

When your harness supports concurrent sub-agents, you can run independent work in parallel to finish faster. The risk is two agents writing the same file and clobbering each other — lost work and merge conflicts. Before dispatching more than one agent, plan file isolation:

1. **Map each task to its write-set** — the exact files and directories it will create, edit, move, or delete. State each write-set explicitly before dispatching. Read-only access does not count toward a write-set.
2. **Check for overlap.** Two tasks may run in parallel only if their write-sets are disjoint. Overlapping reads are fine; overlapping writes are not.
3. **Treat structural tasks as global.** Any task that moves, renames, or restructures a directory conflicts with every task that touches files under that path. Run these alone, after the others — never in the same parallel batch.
4. **Choose the dispatch shape:**
   - Disjoint write-sets → dispatch together in parallel.
   - Overlapping write-sets → either sequence them, or give each agent its own isolated workspace (a dedicated git worktree) and reconcile on merge.
   - Unsure whether they overlap → default to worktree isolation. Do not guess.
5. **State the plan first.** Before the first dispatch, write out which tasks run in parallel, which are sequenced, and why. This is the artifact to check if something clobbers.

Worktree isolation — one checkout per agent — makes clobbering structurally impossible, at the cost of a merge step afterward. When in doubt, prefer it over reasoning hard about overlap: a cheap merge beats lost work.

## Repo layout & conventions

This OS is a version-controlled toolkit cloned at each company. Key directories:

| Directory | Purpose |
|-----------|---------|
| `AGENTS.md` (root) | Canonical, harness-neutral instructions (this file) |
| `harness/<name>/` | Per-harness overlays + global payload installed by `setup.sh` |
| `skills/` | Single source for all skills (symlinked into each harness) |
| `memory/` | Shared formatting and reference docs (e.g. `doc-formatting.md`) |
| `templates/` | Document blueprints (PRD, agenda, etc.) |
| `canonical/people|research|company/` | Stakeholder, research, and strategy notes (gitignored) |
| `canonical/projects/` | Active project folders with dated notes (gitignored) |
| `canonical/goals/`, `canonical/GOALS.md` | Quarterly goals (gitignored) |
| `canonical/action-items.md` | Personal action items (gitignored) |
| `canonical/data/` | Working data files (gitignored) |

Naming: meeting notes `YYYY-MM-DD-topic.md`; people files `firstname-lastname.md`; archived goals `canonical/goals/GOALS-YYYY-QN.md` (active goals live at `canonical/GOALS.md`).
