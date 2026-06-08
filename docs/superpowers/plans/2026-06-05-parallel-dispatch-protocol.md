# Parallel Dispatch Protocol Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make any LLM working in this repo reason about file isolation *before* dispatching concurrent agents, so parallel work runs as much as possible without clobbering files or creating merge conflicts.

**Architecture:** The reasoning protocol is a written instruction (an LLM judgment task, not something a hook can compute), so it lives in the canonical harness-neutral `AGENTS.md` where every harness reads it (Task 1, required). An optional Claude-Code-only `PreToolUse` hook acts as a backstop that re-injects the reminder at dispatch time (Task 2, optional). The hook cannot compute file overlap — it only forces the question to be asked — so Task 1 does the real work.

**Tech Stack:** Markdown (`AGENTS.md`), JSON (`harness/claude/settings.json`), Bash (hook script + `setup.sh`), `jq` for JSON validation.

---

## Assumptions & Preconditions

- The harness-agnostic refactor is complete: canonical instructions live in `AGENTS.md`, Claude overlay lives under `harness/claude/`.
- Run all commands from the repo root: `/Users/sebastian/seb-pm-os`.
- Do **not** commit unless the user explicitly asks (repo workflow rule in `AGENTS.md`).
- Work on a feature branch, never `main` (repo workflow rule).

## File Structure

| File | Change | Responsibility |
|------|--------|----------------|
| `AGENTS.md` | Modify (insert one section) | The harness-neutral isolation protocol every LLM reads — the core deliverable |
| `harness/claude/hooks/parallel-dispatch-check.sh` | Create | Claude-only hook script that prints the reminder as `additionalContext` (optional) |
| `harness/claude/settings.json` | Modify (add `hooks` key) | Registers the hook on the subagent-dispatch tool (optional) |
| `setup.sh` | Modify (add one symlink line) | Installs the hook script into `~/.claude/hooks/` (optional; also fix the stale `claude-config/` paths if not already done) |

Task 1 is self-contained and ships value alone. Task 2 is optional and only benefits the Claude Code harness.

---

### Task 1: Add the Parallel Dispatch Protocol to AGENTS.md (REQUIRED)

**Files:**
- Modify: `AGENTS.md` (insert a new section between `## Context Conservation` and `## Repo layout & conventions`)

- [ ] **Step 1: Confirm the insertion point**

Run: `grep -n "^## " AGENTS.md`
Expected: output includes the lines `## Context Conservation` and `## Repo layout & conventions`, with Context Conservation appearing immediately before Repo layout. The new section goes between them.

- [ ] **Step 2: Insert the protocol section**

Use an Edit that anchors on the start of the `## Repo layout & conventions` heading and inserts the new section before it.

Find this exact text:

```
## Repo layout & conventions
```

Replace it with (note the new section, then a blank line, then the original heading):

```
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
```

- [ ] **Step 3: Verify the section is present exactly once and correctly placed**

Run: `grep -c "## Parallel Dispatch & File Isolation" AGENTS.md`
Expected: `1`

Run: `grep -n "^## " AGENTS.md`
Expected: `## Parallel Dispatch & File Isolation` appears between `## Context Conservation` and `## Repo layout & conventions`.

- [ ] **Step 4: Verify the file is still well-formed Markdown**

Run: `tail -n 30 AGENTS.md`
Expected: the new section reads cleanly, followed by the intact `## Repo layout & conventions` section and its table.

- [ ] **Step 5: Commit (only if the user has asked you to commit)**

```bash
git add AGENTS.md
git commit -m "docs: add parallel dispatch & file isolation protocol to AGENTS.md"
```

---

### Task 2: Add the Claude Code enforcement hook (OPTIONAL — Claude harness only)

Skip this task unless you want a dispatch-time backstop. It only helps the Claude Code harness, not other LLMs, and it fires on every subagent dispatch (including single-agent ones), injecting the reminder each time. The protocol in Task 1 is what actually does the work.

**Files:**
- Create: `harness/claude/hooks/parallel-dispatch-check.sh`
- Modify: `harness/claude/settings.json` (add a top-level `hooks` key)
- Modify: `setup.sh` (add one symlink line so the script installs to `~/.claude/hooks/`)

- [ ] **Step 1: Create the hook script**

Create `harness/claude/hooks/parallel-dispatch-check.sh` with exactly this content (the heredoc avoids JSON-in-JSON escaping problems):

```bash
#!/usr/bin/env bash
# PreToolUse hook for sub-agent dispatch (Task / Agent tool).
# Backstop reminder to verify file isolation before parallel dispatch.
# The authoritative protocol lives in AGENTS.md → "Parallel Dispatch & File Isolation".
# This hook cannot compute file overlap; it only re-asks the question at dispatch time.

cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "Parallel dispatch check (see AGENTS.md -> Parallel Dispatch & File Isolation): before dispatching multiple agents, confirm each agent's write-set is disjoint. Structural/move tasks conflict with everything under that path -- run them alone. If write-sets overlap or you are unsure, sequence the tasks or give each agent its own git worktree."
  }
}
JSON
```

- [ ] **Step 2: Make the hook script executable**

Run: `chmod +x harness/claude/hooks/parallel-dispatch-check.sh`
Expected: no output, exit code 0.

- [ ] **Step 3: Verify the script emits valid hook JSON**

Run: `bash harness/claude/hooks/parallel-dispatch-check.sh | jq .`
Expected: pretty-printed JSON with a `hookSpecificOutput` object containing `hookEventName: "PreToolUse"` and a non-empty `additionalContext` string. `jq` exits 0 (proves the JSON is valid).

- [ ] **Step 4: Register the hook in settings.json**

The matcher `"Task|Agent"` is a regex that matches whichever name your Claude Code version uses for the subagent-dispatch tool (historically `Task`; newer builds may surface it as `Agent`). Matching both is safe.

Edit `harness/claude/settings.json`. Find this exact text:

```
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-command.sh"
  },
  "enabledPlugins": {
```

Replace it with:

```
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-command.sh"
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Task|Agent",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/parallel-dispatch-check.sh"
          }
        ]
      }
    ]
  },
  "enabledPlugins": {
```

- [ ] **Step 5: Verify settings.json is still valid JSON**

Run: `jq . harness/claude/settings.json > /dev/null && echo OK`
Expected: `OK` (exit 0). If `jq` errors, you introduced a syntax error — fix the trailing commas/braces before continuing.

- [ ] **Step 6: Confirm the hook block parsed as expected**

Run: `jq '.hooks.PreToolUse[0]' harness/claude/settings.json`
Expected: an object with `matcher: "Task|Agent"` and a `hooks` array whose command is `bash ~/.claude/hooks/parallel-dispatch-check.sh`.

- [ ] **Step 7: Wire the script into setup.sh**

First check which base path `setup.sh` installs from:

Run: `grep -n "backup_and_link" setup.sh`
Expected: a list of `backup_and_link "$SCRIPT_DIR/<base>/..." "$CLAUDE_DIR/..."` lines.

- If those lines reference `$SCRIPT_DIR/claude-config/...`, the refactor has **not** updated `setup.sh` yet. Fix all of them to `$SCRIPT_DIR/harness/claude/...` as part of this step (they currently point at a directory that no longer exists), then add the hook line below.
- If they already reference `$SCRIPT_DIR/harness/claude/...`, just add the hook line.

Add this line immediately after the `doc-formatting.md` `backup_and_link` line:

```bash
backup_and_link "$SCRIPT_DIR/harness/claude/hooks/parallel-dispatch-check.sh" "$CLAUDE_DIR/hooks/parallel-dispatch-check.sh"
```

(`backup_and_link` already runs `mkdir -p "$(dirname "$dest")"`, so it will create `~/.claude/hooks/` automatically — no extra step needed.)

- [ ] **Step 8: Verify setup.sh is syntactically valid**

Run: `bash -n setup.sh && echo OK`
Expected: `OK` (exit 0). This parses the script without executing it.

- [ ] **Step 9: (Optional) Install and smoke-test the hook locally**

Only do this if the user wants the hook active in their live `~/.claude/` now.

Run: `./setup.sh`
Expected: summary output showing `~/.claude/hooks/parallel-dispatch-check.sh` linked.

Run: `bash ~/.claude/hooks/parallel-dispatch-check.sh | jq .`
Expected: the same valid hook JSON as Step 3, proving the installed symlink resolves.

- [ ] **Step 10: Commit (only if the user has asked you to commit)**

```bash
git add harness/claude/hooks/parallel-dispatch-check.sh harness/claude/settings.json setup.sh
git commit -m "feat(claude): add parallel-dispatch isolation backstop hook"
```

---

## Self-Review Checklist (for the executing agent, before reporting done)

1. **Task 1 shipped:** `grep -c "## Parallel Dispatch & File Isolation" AGENTS.md` returns `1`, and the section sits between Context Conservation and Repo layout.
2. **If Task 2 done:** `jq . harness/claude/settings.json` exits 0; the hook script is executable and emits valid JSON; `bash -n setup.sh` exits 0; `setup.sh` no longer references the dead `claude-config/` path.
3. **No stray commits:** you only committed if the user explicitly asked.
4. **Branch hygiene:** all work is on a feature branch, not `main`.
