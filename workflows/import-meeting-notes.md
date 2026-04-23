# Import Meeting Notes

Pull recent Granola meetings, synthesize the important details, and store them in the right knowledge folders.

## How to use

```
Check my recent Granola meetings and help me import notes.
```

Or be specific:

```
Import notes from my research sync with Becky today.
```

## What happens

1. Claude pulls recent meetings via Granola MCP
2. Shows you what's available (date, attendees, summary)
3. You pick which meeting(s) to import
4. Claude **synthesizes** the meeting — extracting only key details, not raw transcripts:
   - Decisions made
   - Action items (who owes what, by when)
   - Stakeholder positions and sentiment
   - Useful context for future conversations
5. Claude proposes where to write, which may be **multiple files** from a single meeting:
   - Person-specific context → `knowledge/people/firstname-lastname.md`
   - Research findings → `knowledge/research/`
   - Strategy/org context → `knowledge/company/`
   - Project decisions → `projects/[project-name]/notes/`
6. You confirm the routing and content before anything is written

## Example

A research sync with Becky Weinstein might produce:

**→ `knowledge/people/becky-weinstein.md`** (appended)
```markdown
### 2026-04-23 - User research sync
- Wants to run 5 more interviews before we finalize personas
- Concerned about sample bias in the enterprise segment
- Action: I owe her the screener updates by Monday
```

**→ `knowledge/research/insights.md`** (appended)
```markdown
### 2026-04-23 - Enterprise persona gaps
- Current personas underrepresent mid-market ops buyers
- Becky's team found 3 distinct workflows we hadn't mapped
- Next step: revised persona deck after round 2 interviews
```

## Important

- **No raw transcripts** — synthesized context only, to keep the knowledge base lean
- **Always confirms routing** before writing
- Basic plan: 30-day history, no transcript access. Import regularly.
