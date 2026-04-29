# Global User Instructions

These rules apply to all projects and sessions.

## Minimize permission prompts

Claude Code has two independent permission gates: (1) the allowlist in `~/.claude/settings.json` and (2) parser-level syntax heuristics that cannot be disabled. The heuristics fire on certain patterns regardless of what's in the allowlist. To keep prompts to a minimum, follow these rules:

### Always prefer dedicated tools over Bash for file/content work
- Reading files → `Read` tool (never `cat`, `head`, `tail`, `sed`)
- Listing files/directories → `Glob` tool (never `ls`, `find`)
- Searching file contents → `Grep` tool (never `grep`, `rg`, `awk`)
- Editing files → `Edit` / `Write` tools (never `sed -i`, heredocs, `>`)

These tools bypass the Bash parser entirely, so they never trigger syntax heuristics or permission prompts for allowed operations.

### Avoid patterns that trigger syntax heuristics
- **Chained commands**: `&&`, `||`, `;` — split into separate tool calls when possible
- **Pipes**: `|` — use the dedicated tool, then process result in next call
- **Quoted strings in commands**: `echo "---"` — avoid decorative separators
- **Escaped special chars in paths**: `\(site\)`, `\&`, `\$` — always prompts; use Read/Glob instead
- **Redirects to subshells**: `$(...)`, `` `...` `` — inherently ambiguous to parser

### When Bash is truly necessary
- Quote paths with double quotes: `"path/with (parens)/"` instead of `path/with\ \(parens\)/`
- Prefer single-command invocations over chains
- For git/gh/package managers, use the fully allowlisted subcommands directly

## Workflow

- **Never push to `main` or `master`** directly. Always use a feature branch + PR.
- **Never use destructive git operations** (`reset --hard`, `push --force`, `branch -D`) without explicit user approval for the specific action.
- **Don't commit unless the user explicitly asks.**

## Granola Meeting Notes

This project has a Granola MCP integration. When the user asks to import or check meeting notes:

### Step 1: Pull and present
- Use the Granola MCP tools (`list_meetings`, `get_meetings`) to pull recent meetings
- Show the user what's available (date, attendees, brief summary)
- Ask which meeting(s) to import

### Step 2: Synthesize, don't copy
- **Never store raw transcripts or full meeting dumps.** Extract only the important details:
  - Key decisions made
  - Action items (who owes what, by when)
  - Stakeholder positions, concerns, or sentiment
  - Context that would be useful in future conversations
- Keep it concise — this is a knowledge base, not a transcript archive

### Step 3: Route to multiple destinations
A single meeting often updates several files. For example, a user research sync with Becky Weinstein should:
- Update `knowledge/research/` with the research findings, insights, or methodology discussed
- Update `knowledge/people/becky-weinstein.md` with Becky-specific context (her concerns, priorities, what you owe her)

Routing rules:
| Content type | Destination |
|-------------|-------------|
| Person-specific context (opinions, style, action items) | `knowledge/people/firstname-lastname.md` |
| Research findings, insights, methodology | `knowledge/research/` |
| Strategy, positioning, org changes | `knowledge/company/` |
| Project-specific decisions or progress | `projects/[project-name]/notes/YYYY-MM-DD-topic.md` |

### Step 4: Confirm before writing
- Present the proposed routing: which files will be created/updated and with what content
- **Always ask the user to confirm**, especially with ambiguous names or multi-destination writes

### Step 5: Write
- For people files: **append** a new dated `### YYYY-MM-DD - [topic]` entry under `## Meeting notes`. Never overwrite existing entries.
- For research/company/project files: create or append as appropriate
- Follow the template structure from `knowledge/people/README.md` for people files

Basic plan limits: 30-day history, no transcript access. Import regularly to persist notes before they age out.

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

## Skills

Available slash commands for PM workflows and document reviews:

| Command | Purpose |
|---------|---------|
| `/meeting-prep <person or topic>` | Pull context on a person or topic before a meeting |
| `/weekly-digest` | Summarize activity across projects for the past week |
| `/status-report` | Draft a cross-project status update from recent notes and goals |
| `/knowledge-health` | Flag gaps and staleness in the knowledge base |
| `/review-eng <file>` | Review a document as an engineering lead |
| `/review-exec <file>` | Review a document as an executive stakeholder |
| `/review-customer <file>` | Review a document as a customer advocate |
| `/review-devil <file>` | Review a document as a constructive skeptic |

## Context Conservation

Prefer delegating research and exploration tasks to sub-agents to preserve main session context. Use the `Task` tool with the appropriate `subagent_type` (`Explore`, `general-purpose`, or `Plan`) instead of doing 5+ read-only tool calls in the main session. See `.claude/skills/delegate-research.md` for the full protocol.
