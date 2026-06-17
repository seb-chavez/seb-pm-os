---
name: delegate-research
description: Use when the user asks to look something up, research a topic, explore a codebase area, search the web, read lengthy docs, or gather information. Triggers on research-oriented requests like "look up", "find out", "how does X work", "explore", "investigate", "search for", "summarize this", "read through", or "check the docs".
---

# Delegate Research to Sub-Agents

## Why

Delegation saves ~20-50% of research context cost depending on task size. In a benchmark reading 23 files across this repo, direct research consumed 32% of the context window while delegated research consumed 26% — cutting the research portion roughly in half. The savings scale with complexity: more files and tool calls means a bigger gap. The sub-agent does all the heavy lifting (web searches, file reads, code exploration) in its own context, and only the summary flows back.

## When to delegate

Delegate when the task is **read-heavy and action-light**:

- Web searches or doc lookups
- Exploring unfamiliar parts of a codebase (more than 3 files)
- Reading and summarizing lengthy files, docs, or meeting notes
- Investigating how something works before deciding what to do
- Comparing approaches or gathering options
- Any task where you'd make 5+ tool calls just to gather information

## When NOT to delegate

Stay in the main session when:

- The task requires fewer than 3 tool calls
- You need to immediately edit files based on findings
- The user is having an interactive back-and-forth that requires shared context
- You already know the answer

## How to delegate

If your harness supports sub-agent delegation, dispatch a sub-agent to do the read-heavy work so only its summary returns to the main context. The mechanism differs by harness:

- **Claude Code:** dispatch a read-only research sub-agent (an "Explore" agent for codebase exploration, a general-purpose agent for web/doc research, or a planning agent for evaluating approaches).
- **Other CLI harnesses:** use the harness's equivalent "spawn a sub-task / sub-agent" capability, if present.
- **No sub-agent support:** do the research inline in the current session — but summarize aggressively as you go instead of letting raw file or page contents pile up in the conversation.

### Prompt template

Write a clear, self-contained prompt. The sub-agent has NO context from your main session unless you provide it. Include:

1. **What to find** — the specific question or information needed
2. **Where to look** — directories, file patterns, URLs, or search terms
3. **What to return** — the format and level of detail you want back
4. **What NOT to do** — explicitly say "research only, do not edit any files" for read-only tasks

Example:
```
Research how the authentication middleware works in this project.

Look in: src/middleware/, src/auth/, and any files importing from those directories.
Return: A summary of the auth flow (max 10 bullet points), the key files involved, and any configuration points.
Do not edit any files.
```

### Parallel delegation

When you have 2+ independent research questions, spin up multiple sub-agents in a single message. This is faster AND cheaper on context than doing them sequentially.

## After the sub-agent returns

1. **Summarize to the user** — relay the key findings concisely
2. **Don't re-research** — trust the sub-agent's results. Don't re-read the same files in the main session
3. **Act on findings** — if the user wants changes based on the research, now proceed with edits in the main session using the summary as context

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Vague sub-agent prompt ("look into auth") | Include what to find, where to look, what to return, what not to do |
| Re-reading the same files after sub-agent returns | Trust the results — the sub-agent already read them |
| Delegating when you already know the answer | Just answer directly; delegation adds overhead |
| Running research tasks sequentially | Use parallel sub-agents for independent questions |
| Forgetting "do not edit any files" in prompt | Always include for read-only research tasks |
