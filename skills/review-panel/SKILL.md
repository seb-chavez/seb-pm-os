---
name: review-panel
description: Dispatches a panel of reviewers with different POVs to read a document and synthesize feedback. Use for review panel, panel review, multiple perspectives, roundtable review, team review, or stress-test a doc before sharing.
---

# Review Panel

## Overview

Runs a panel of reviewers — each with a distinct persona — on the same document, then synthesizes consensus, tensions, and prioritized fixes.

Every panelist maps to a standalone `review-*` skill. Default panel: **pessimist**, **optimist**, **sme**, **new-hire**.

## Invocation

```
/review-panel [path/to/document]
/review-panel [path] --operator --budget
/review-panel [path] --engineer --executive --champion-user
```

Natural language: "run a review panel on this PRD", "get multiple perspectives on canonical/projects/foo/brief.md".

Parse optional flags from the user's message. If no document path is given, ask for one.

## Workflow

### 1. Confirm the panel

Default roster (always included unless user says otherwise):

| Persona | Skill |
|---------|-------|
| Pessimist | `review-pessimist` |
| Optimist | `review-optimist` |
| Subject matter expert | `review-sme` |
| New hire | `review-new-hire` |

Optional add-ons (include when flagged or user asks):

| Flag | Skill |
|------|-------|
| `--operator` | `review-operator` |
| `--budget` | `review-budget` |
| `--engineer` | `review-engineer` |
| `--executive` | `review-executive` |
| `--champion-user` | `review-champion-user` |

### 2. Dispatch reviewers

**If the harness supports sub-agents:** dispatch one read-only sub-agent per panelist in a single parallel batch. Each prompt must be self-contained:

```
Read and follow skills/review-[name]/SKILL.md exactly.

Document: [absolute or repo-relative path]

Return only that skill's output format. Do not edit files. Do not review from other personas.
```

**If no sub-agent support:** run each skill sequentially in the current session (read each `SKILL.md`, apply that persona), keeping outputs under separate persona headers.

### 3. Synthesize

After all reviewers return, produce one synthesis — do not dump raw sub-agent output without merging.

```
## Review Panel: [document name]

### Panel
[List who participated]

### Per-persona highlights
#### Pessimist
[Top 2–3 findings]

#### Optimist
...

[repeat for each panelist]

### Consensus
Findings flagged by 2+ reviewers (or strong agreement across lenses).

### Tension
Places personas disagree — e.g. optimist sees upside pessimist dismisses. Name both sides; don't pick a winner unless one side has a clear factual error.

### Top fixes before sharing
1. [Highest-impact fix]
2. ...
3. ...
(max 3–5 items, ordered by impact)
```

## Standalone skills

Run any persona alone without the full panel:

| Skill | Persona |
|-------|---------|
| `review-pessimist` | Constructive skeptic |
| `review-optimist` | Credible champion |
| `review-sme` | Domain expert |
| `review-new-hire` | First-week newcomer |
| `review-operator` | Production operator |
| `review-budget` | Budget holder |
| `review-engineer` | Engineering lead |
| `review-executive` | Executive |
| `review-champion-user` | Champion end-user |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| One blended review voice | Follow each skill's persona before synthesizing |
| Skipping synthesis | User wants consensus, tension, and top fixes — not separate full reports pasted together |
| Too many panelists by default | Stick to four unless user requests add-ons |
| Re-reading the doc N times in main session after sub-agents | Trust sub-agent returns; synthesize from their output |
| Inventing persona criteria inline | Always use the matching `review-*` skill |
