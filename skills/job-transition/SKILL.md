---
name: job-transition
description: Use when leaving a role and starting a new one, or when resetting the PM OS for a new company. Triggers on "transitioning jobs", "leaving my job", "starting a new role", "reset the OS", "job transition".
---

# Job Transition

## Overview

Walks through archiving company-specific context, preserving what's portable, and resetting the OS for a clean start at a new role.

## When NOT to use

- The user is archiving a single completed project (just move it to `projects/_archive/`)
- The user is updating their goals mid-quarter (just edit `GOALS.md` directly)

## Steps

Walk through each step, confirming before making changes.

### 1. Archive active projects

Move each project folder from `projects/` to `projects/_archive/`:

```
projects/projectname/ → projects/_archive/projectname/
```

No renaming needed — the folder contents (notes, docs) already have dates.

### 2. Clear company knowledge

Everything in `knowledge/company/` is company-specific and shouldn't carry over:

- Review each file for anything personally useful (frameworks you developed, lessons learned)
- Save portable takeaways to `knowledge/research/` if worth keeping
- Delete all files in `knowledge/company/` except `README.md`

### 3. Clear people knowledge

Stakeholder dossiers in `knowledge/people/` are role-specific:

- Review each file — some contacts may be worth keeping across jobs
- Delete files for people you won't work with again
- Keep files for lasting professional relationships, but strip company-specific context

### 4. Clear public context

Replace or delete contents of `knowledge/public-context/` with materials relevant to the new role.

### 5. Archive goals

Move the current `GOALS.md` to `goals/` with a quarter suffix:

```
GOALS.md → goals/GOALS-2026-Q2.md
```

Create a fresh `GOALS.md` at root for the new role.

### 6. Update MCP integrations

Review `.mcp.json` — some integrations (like Granola) are personal and carry over. Others may be company-specific and should be removed.

### 7. Commit and start fresh

Commit the archived state so you have a clean snapshot of the previous role, then begin populating for the new one.

## Important

- **Do this before your last day** — you may lose access to tools/context needed to review files
- **Don't delete the archive** — previous project context is useful for resume updates, case studies, and pattern recognition
- Confirm with the user before each destructive step (deleting files, clearing directories)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Deleting knowledge without reviewing for portable takeaways | Always review each file before clearing — frameworks and lessons learned carry over |
| Forgetting to archive goals | Move `GOALS.md` to `goals/` before creating a fresh one |
| Clearing people files for lasting contacts | Keep files for professional relationships that span jobs, just strip company-specific context |
