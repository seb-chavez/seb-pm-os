---
name: meeting-prep
description: Use when preparing for a meeting and need context on a person, team, or topic. Triggers on "prep for my meeting", "meeting with [name]", "prep me for", "what do I need to know about [person]".
---

# Meeting Prep

## Overview

Compiles a briefing from your knowledge base before a meeting. Pulls person context, recent project activity, and open action items into a single brief.

## When NOT to use

- You already have the context you need
- The meeting is with someone not in `knowledge/people/` and you have no project notes mentioning them

## Steps

1. Take the person name or topic from the user's input (e.g., `/meeting-prep dean` or `/meeting-prep board meeting`)
2. Fuzzy-match the input against filenames in `knowledge/people/` — read all matching files
3. Scan recent project notes (`projects/*/notes/`) for mentions of that person or topic using the Grep tool
4. Read `GOALS.md` for any relevant items to surface
5. Present a compiled brief with these sections:

### Brief Format

```
## Meeting Prep: [Person/Topic]

### Who They Are
- Role, reports to, communication style, what they care about, pet peeves
(From knowledge/people/ file)

### Recent Context
- Last meeting topics and outcomes
- Their current priorities or concerns
(From knowledge/people/ meeting notes section)

### Open Action Items
- What you owe them
- What they owe you
(From meeting notes and project notes)

### Relevant Project Activity
- Recent decisions or progress related to this person/topic
(From projects/*/notes/)

### Goals to Surface
- Any active goals relevant to the meeting
(From GOALS.md)
```

6. Output the brief in the terminal only — this is ephemeral prep, not a saved document

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reading only the people file and skipping project notes | Always scan `projects/*/notes/` for mentions too |
| Producing a wall of text | Keep each section to 3-5 bullets max — this is a briefing, not a report |
| Saving the brief to a file | Output to terminal only unless the user explicitly asks to save |
