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
