# Tools & Sub-Agents Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add 8 Claude Code skills (4 tools + 4 review personas) to the PM Operating System.

**Architecture:** Each skill is a markdown file at `.claude/skills/<skill-name>/SKILL.md` following the existing convention set by `delegate-research` and `import-meeting-notes`. Skills use YAML frontmatter with `name` and `description` fields. Descriptions start with "Use when..." and describe only triggering conditions.

**Tech Stack:** Markdown, Claude Code skill spec (YAML frontmatter)

**Spec correction:** The design spec assumed flat `.md` files and setup.sh symlinks. The actual convention uses subdirectories with `SKILL.md` inside, and skills are project-local (no symlink needed).

---

### Task 1: Create meeting-prep skill

**Files:**
- Create: `.claude/skills/meeting-prep/SKILL.md`

- [ ] **Step 1: Create the skill file**

```markdown
---
name: meeting-prep
description: Use when preparing for a meeting and need context on a person, team, or topic. Triggers on "prep for my meeting", "meeting with [name]", "prep me for", "what do I need to know about [person]".
---

# Meeting Prep

## Overview

Compiles a briefing from your knowledge base before a meeting. Pulls person context, recent project activity, and open action items into a single brief.

## When NOT to use

- You already have the context you need
- The meeting is with someone not in `canonical/people/`and you have no project notes mentioning them

## Steps

1. Take the person name or topic from the user's input (e.g., `/meeting-prep dean` or `/meeting-prep board meeting`)
2. Fuzzy-match the input against filenames in `canonical/people/` — read all matching files
3. Scan recent project notes (`canonical/projects/*/notes/`) for mentions of that person or topic using the Grep tool
4. Read `canonical/GOALS.md` for any relevant items to surface
5. Present a compiled brief with these sections:

### Brief Format

```
## Meeting Prep: [Person/Topic]

### Who They Are
- Role, reports to, communication style, what they care about, pet peeves
(From canonical/people/ file)

### Recent Context
- Last meeting topics and outcomes
- Their current priorities or concerns
(From canonical/people/ meeting notes section)

### Open Action Items
- What you owe them
- What they owe you
(From meeting notes and project notes)

### Relevant Project Activity
- Recent decisions or progress related to this person/topic
(From canonical/projects/*/notes/)

### Goals to Surface
- Any active goals relevant to the meeting
(From canonical/GOALS.md)
```

6. Output the brief in the terminal only — this is ephemeral prep, not a saved document

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reading only the people file and skipping project notes | Always scan `canonical/projects/*/notes/` for mentions too |
| Producing a wall of text | Keep each section to 3-5 bullets max — this is a briefing, not a report |
| Saving the brief to a file | Output to terminal only unless the user explicitly asks to save |
```

- [ ] **Step 2: Verify the file exists and frontmatter is valid**

Run: `head -5 .claude/skills/meeting-prep/SKILL.md`
Expected: YAML frontmatter with `name: meeting-prep` and `description: Use when...`

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/meeting-prep/SKILL.md
git commit -m "feat: add meeting-prep skill"
```

---

### Task 2: Create weekly-digest skill

**Files:**
- Create: `.claude/skills/weekly-digest/SKILL.md`

- [ ] **Step 1: Create the skill file**

```markdown
---
name: weekly-digest
description: Use when reviewing what happened across projects and the knowledge base in the past week. Triggers on "weekly digest", "what happened this week", "weekly summary", "recap the week".
---

# Weekly Digest

## Overview

Scans files modified in the past 7 days across projects, canonical, and goals. Synthesizes a summary of activity, decisions, and outstanding action items.

## When NOT to use

- The user wants a status report for stakeholders (use `/status-report` instead)
- The user is asking about a specific meeting or person (use `/meeting-prep` instead)

## Steps

1. Run `git log --since="7 days ago" --name-only --pretty=format:""` to find files modified in the past week
2. Filter to files under `canonical/`
3. Read each modified file
4. Synthesize into the following sections:

### Digest Format

```
## Weekly Digest: [date range]

### Activity by Project
- **[project-name]**: [summary of notes added, decisions made]
(Repeat for each active project with changes)

### Decisions Made
- [decision] — [date, context]
(Pulled from meeting notes and project notes)

### Open Action Items
- [ ] [action] — owner: [name], due: [date]
(Pulled from meeting notes across all projects)

### Knowledge Base Updates
- [what was added/changed] in [which canonical area]
(Pulled from canonical/ changes)

### Goal Progress
- [any updates to canonical/GOALS.md]
```

5. Print the digest to the terminal
6. Ask: "Want me to save this digest?" — if yes, write to `canonical/data/digests/YYYY-MM-DD-digest.md` (create `canonical/data/digests/` if it doesn't exist)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Including unchanged files in the digest | Only report on files modified in the git log |
| Missing action items buried in meeting notes | Grep for patterns like "Action:", "owe", "by [day]", "- [ ]" |
| Forgetting to offer the save option | Always ask after presenting the digest |
```

- [ ] **Step 2: Verify the file exists and frontmatter is valid**

Run: `head -5 .claude/skills/weekly-digest/SKILL.md`
Expected: YAML frontmatter with `name: weekly-digest` and `description: Use when...`

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/weekly-digest/SKILL.md
git commit -m "feat: add weekly-digest skill"
```

---

### Task 3: Create status-report skill

**Files:**
- Create: `.claude/skills/status-report/SKILL.md`

- [ ] **Step 1: Create the skill file**

```markdown
---
name: status-report
description: Use when drafting a status update or status report to share with stakeholders. Triggers on "status report", "status update", "draft a status update", "weekly update for stakeholders".
---

# Status Report

## Overview

Drafts a cross-project status report using the `templates/strategy/status-update.md` template, populated with real content from recent project notes and goal progress.

## When NOT to use

- The user wants an internal weekly recap (use `/weekly-digest` instead)
- The user wants to create a blank status report template (just point them to the template file)

## Steps

1. Read the template from `templates/strategy/status-update.md`
2. Read recent notes from all active project directories — use `Glob` to find `canonical/projects/*/notes/*.md`, then read the most recent 3-5 notes per project
3. Read `canonical/GOALS.md` for current goal progress
4. Draft a filled-in status report using the template structure:
   - Pull accomplishments from recent project notes (decisions made, milestones hit)
   - Pull upcoming work from action items and next steps in notes
   - Pull risks/blockers from any flagged issues in notes
   - Pull metrics from `canonical/GOALS.md` key results table
5. Apply formatting defaults from `memory/doc-formatting.md`
6. Present the draft to the user for review
7. On approval, ask where to save the file and write it

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using only the most recent note per project | Read the last 3-5 notes to capture the full reporting period |
| Leaving template placeholder text in the draft | Replace every placeholder — if data is missing, note it explicitly rather than leaving brackets |
| Skipping the formatting defaults | Always read and apply `memory/doc-formatting.md` |
```

- [ ] **Step 2: Verify the file exists and frontmatter is valid**

Run: `head -5 .claude/skills/status-report/SKILL.md`
Expected: YAML frontmatter with `name: status-report` and `description: Use when...`

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/status-report/SKILL.md
git commit -m "feat: add status-report skill"
```

---

### Task 4: Create knowledge-health skill

**Files:**
- Create: `.claude/skills/knowledge-health/SKILL.md`

- [ ] **Step 1: Create the skill file**

```markdown
---
name: knowledge-health
description: Use when checking for gaps, staleness, or missing information in the knowledge base. Triggers on "knowledge health", "check my knowledge base", "what's missing", "what's stale", "health check".
---

# Knowledge Health Check

## Overview

Scans the knowledge base and active projects for gaps, missing fields, and staleness. Produces a health report showing what's complete, what has gaps, and what needs attention.

## When NOT to use

- The user wants to fix a specific file (just edit it directly)
- The user is asking about a specific person or project (use `/meeting-prep` instead)

## Steps

1. **Scan people files** — read every `.md` file in `canonical/people/` (except README.md). For each file, check for:
   - Missing "Cares about" or "cares about" field
   - Missing "Communication style" or "communication style" field
   - No "## Meeting notes" or "## Recent context" section
   - No dated entries (### YYYY-MM-DD) in the last 30 days
2. **Check company knowledge** — list files in `canonical/company/`. Flag if the directory contains only README.md
3. **Check active projects** — for each directory in `canonical/projects/` (excluding `_archive`), find the most recent note by filename date. Flag projects with no notes in the last 14 days
4. **Check goals** — read `canonical/GOALS.md`. Flag if the key results table still has empty cells or placeholder text like "_Define your"
5. Present the health report:

### Report Format

```
## Knowledge Base Health Check

### People (X files)
- ✓ [name] — complete
- ⚠ [name] — missing: [fields], last updated: [date]
- ✗ [name] — missing: [fields], no recent entries

### Company Knowledge
- [status: populated / empty]

### Active Projects
- ✓ [project] — last note: [date]
- ⚠ [project] — last note: [date] (X days ago)

### Goals
- [status: populated / has placeholders]

### Summary
[X] complete | [Y] need attention | [Z] stale
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Only checking for exact field names | Check case-insensitively and look for variations (e.g., "Cares about" vs "cares about" vs "What they care about") |
| Reporting README.md as a content file | Exclude README.md from all scans |
| Not explaining what's missing | Always specify which fields are missing, not just "incomplete" |
```

- [ ] **Step 2: Verify the file exists and frontmatter is valid**

Run: `head -5 .claude/skills/knowledge-health/SKILL.md`
Expected: YAML frontmatter with `name: knowledge-health` and `description: Use when...`

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/knowledge-health/SKILL.md
git commit -m "feat: add knowledge-health skill"
```

---

### Task 5: Create review-eng skill

**Files:**
- Create: `.claude/skills/review-eng/SKILL.md`

- [ ] **Step 1: Create the skill file**

```markdown
---
name: review-eng
description: Use when reviewing a document from an engineering feasibility perspective. Triggers on "engineering review", "review as an engineer", "technical review", "review-eng".
---

# Engineering Review

## Overview

Reviews a document as an engineering lead evaluating feasibility, technical constraints, and implementation clarity.

## Steps

1. Read the file provided by the user (e.g., `/review-eng path/to/document.md`)
2. Adopt the persona of a senior engineering lead who has been asked to review this document for feasibility
3. Evaluate the document against these criteria:
   - **Technical constraints**: Are assumptions stated? Are there unstated technical limitations?
   - **Complexity**: Is the scope realistic? Are there underestimated areas?
   - **Dependencies**: Are external dependencies identified? Are integration points clear?
   - **Acceptance criteria**: Are success conditions specific and measurable, not vague ("fast", "scalable")?
   - **Edge cases**: Are error states, failure modes, and boundary conditions addressed?
   - **Architecture risks**: Are there design choices that could cause problems at scale or over time?
4. Present findings as a numbered list, each with:
   - **Severity**: `BLOCKER` | `CONCERN` | `SUGGESTION`
   - **Finding**: What the issue is
   - **Recommendation**: How to fix it

### Output Format

```
## Engineering Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

2. **[SEVERITY]** [finding]
   → [recommendation]

...
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reviewing writing quality instead of technical feasibility | Stay in the engineering persona — focus on buildability, not prose |
| Marking everything as a blocker | Reserve BLOCKER for things that would prevent implementation. Use CONCERN and SUGGESTION for lesser issues |
| Giving vague feedback like "needs more detail" | Be specific: what detail is missing and why it matters for implementation |
```

- [ ] **Step 2: Verify the file exists and frontmatter is valid**

Run: `head -5 .claude/skills/review-eng/SKILL.md`
Expected: YAML frontmatter with `name: review-eng` and `description: Use when...`

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/review-eng/SKILL.md
git commit -m "feat: add review-eng skill"
```

---

### Task 6: Create review-exec skill

**Files:**
- Create: `.claude/skills/review-exec/SKILL.md`

- [ ] **Step 1: Create the skill file**

```markdown
---
name: review-exec
description: Use when reviewing a document from an executive or leadership perspective. Triggers on "executive review", "review as an exec", "leadership review", "review-exec", "would a VP approve this".
---

# Executive Review

## Overview

Reviews a document as a VP or C-level reading it for the first time, evaluating clarity of the ask, business alignment, and decision-readiness.

## Steps

1. Read the file provided by the user (e.g., `/review-exec path/to/document.md`)
2. Adopt the persona of a VP who has 5 minutes to read this document and decide whether to approve, push back, or ask questions
3. Evaluate the document against these criteria:
   - **"So what" clarity**: Is the core point or ask clear in the first paragraph? Would an exec know what's being asked of them?
   - **Business alignment**: Are metrics tied to business outcomes (revenue, retention, cost), not just technical outputs (uptime, latency)?
   - **Explicit ask**: Is there a clear decision or action requested? Or does the doc just inform without asking?
   - **Signal-to-noise**: Is the doc concise enough for an exec audience? Too much implementation detail buries the ask
   - **Timeline and resources**: Are costs, headcount, and timeline implications stated?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
5. End with a one-line **Executive Takeaway**: what an exec would conclude from this doc as written

### Output Format

```
## Executive Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**Executive Takeaway:** [one sentence — what a VP would walk away thinking after reading this]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reviewing technical depth instead of executive clarity | Focus on: is the ask clear, is the business case made, can a decision be made? |
| Ignoring the structure of the doc | Execs skim — the first paragraph and section headers matter more than body text |
| Forgetting the executive takeaway | Always end with the one-line summary |
```

- [ ] **Step 2: Verify the file exists and frontmatter is valid**

Run: `head -5 .claude/skills/review-exec/SKILL.md`
Expected: YAML frontmatter with `name: review-exec` and `description: Use when...`

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/review-exec/SKILL.md
git commit -m "feat: add review-exec skill"
```

---

### Task 7: Create review-customer skill

**Files:**
- Create: `.claude/skills/review-customer/SKILL.md`

- [ ] **Step 1: Create the skill file**

```markdown
---
name: review-customer
description: Use when reviewing a document from an end-user or customer impact perspective. Triggers on "customer review", "review as a customer", "user impact review", "review-customer", "how does this affect users".
---

# Customer Review

## Overview

Reviews a document as an end-user advocate, evaluating user impact, migration burden, and whether the proposed work solves the right problem.

## Steps

1. Read the file provided by the user (e.g., `/review-customer path/to/document.md`)
2. Adopt the persona of a customer advocate who represents the end-user's interests in product decisions
3. Evaluate the document against these criteria:
   - **Who's affected**: Are the impacted users identified? How many? Which segments?
   - **Migration and transition**: If behavior changes, is there a migration path? Will users be surprised?
   - **Problem-solution fit**: Does this solve the stated user problem, or a proxy/internal problem disguised as a user need?
   - **User mental model**: Does the solution match how users think about the problem? Is there jargon or internal framing that wouldn't make sense to a user?
   - **Validation evidence**: Is there user research, feedback, or data supporting this direction? Or is it assumption-driven?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
5. End with a **User Impact Summary**: who is affected and what changes for them

### Output Format

```
## Customer Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**User Impact Summary:** [who is affected] — [what changes for them]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reviewing from a business perspective instead of user perspective | Stay in the customer advocate persona — ask "would a user care about this?" |
| Accepting "improves user experience" without specifics | Push for concrete impact: which users, what behavior changes, what's the before/after |
| Skipping the validation evidence check | Always ask: is there data or research behind this, or is it an assumption? |
```

- [ ] **Step 2: Verify the file exists and frontmatter is valid**

Run: `head -5 .claude/skills/review-customer/SKILL.md`
Expected: YAML frontmatter with `name: review-customer` and `description: Use when...`

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/review-customer/SKILL.md
git commit -m "feat: add review-customer skill"
```

---

### Task 8: Create review-devil skill

**Files:**
- Create: `.claude/skills/review-devil/SKILL.md`

- [ ] **Step 1: Create the skill file**

```markdown
---
name: review-devil
description: Use when stress-testing a document for unstated assumptions, risks, or weak evidence. Triggers on "devil's advocate", "poke holes", "stress test this", "review-devil", "what could go wrong", "challenge this".
---

# Devil's Advocate Review

## Overview

Reviews a document as a constructive skeptic, surfacing unstated assumptions, hidden risks, evidence gaps, and failure scenarios.

## Steps

1. Read the file provided by the user (e.g., `/review-devil path/to/document.md`)
2. Adopt the persona of a constructive skeptic whose job is to find the weakest points in the argument before it goes to a broader audience
3. Evaluate the document against these criteria:
   - **Unstated assumptions**: What is being taken as fact without evidence? What "obvious truths" might be wrong?
   - **Risk coverage**: Are risks identified? Are they honest, or are they softened to look manageable? What risks are missing entirely?
   - **Failure scenarios**: What happens if this doesn't work? Is there a fallback? What's the blast radius?
   - **Single points of failure**: Is success dependent on one person, one vendor, one assumption, or one timeline holding?
   - **Evidence gaps**: Are claims supported by data, research, or precedent? Or are they assertion-driven?
   - **Optimism bias**: Are timelines, estimates, or projections realistic? Is there a track record to validate them?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
5. End with a **Strongest Counterargument**: the single best reason this plan might fail

### Output Format

```
## Devil's Advocate Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**Strongest Counterargument:** [the single best reason this plan might fail]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Being destructive instead of constructive | Every finding should include a recommendation, not just criticism |
| Nitpicking minor issues instead of finding real risks | Focus on things that could actually derail the plan, not formatting or word choice |
| Pulling punches to be polite | The value of this review is honesty — flag real concerns even if they're uncomfortable |
```

- [ ] **Step 2: Verify the file exists and frontmatter is valid**

Run: `head -5 .claude/skills/review-devil/SKILL.md`
Expected: YAML frontmatter with `name: review-devil` and `description: Use when...`

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/review-devil/SKILL.md
git commit -m "feat: add review-devil skill"
```

---

### Task 9: Update CLAUDE.md with skills reference table

**Files:**
- Modify: `claude-config/CLAUDE.md` (add skills section after the Document Templates section, before Context Conservation)

- [ ] **Step 1: Add the skills table**

Add the following after the Document Templates section (after line 92) and before the Context Conservation section:

```markdown
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
```

- [ ] **Step 2: Verify the section was added correctly**

Read `claude-config/CLAUDE.md` and confirm the Skills section appears between Document Templates and Context Conservation.

- [ ] **Step 3: Commit**

```bash
git add claude-config/CLAUDE.md
git commit -m "feat: add skills reference table to CLAUDE.md"
```

---

### Task 10: Update project CLAUDE.md with skills directory

**Files:**
- Modify: `CLAUDE.md` (project root — add skills to the directory structure table)

- [ ] **Step 1: Add skills row to the directory structure table**

Add a row to the directory structure table in the project-root `CLAUDE.md`:

```markdown
| `.claude/skills/` | Claude Code slash command skills (meeting prep, reviews, digests, etc.) | No |
```

Add it after the `claude-config/` row.

- [ ] **Step 2: Verify the row was added**

Read `CLAUDE.md` and confirm the `.claude/skills/` row is in the directory structure table.

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "feat: add skills directory to project CLAUDE.md"
```
