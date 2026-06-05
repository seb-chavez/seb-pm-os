# Claude Code — Local Overlay

@AGENTS.md

The canonical, harness-neutral instructions are imported above from `AGENTS.md`. The rules below are specific to the Claude Code harness.

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
