---
name: status-report
description: Use when drafting a status update or status report to share with stakeholders. Triggers on "status report", "status update", "draft a status update", "weekly update for stakeholders".
disable-model-invocation: true
---

# Status Report

## Overview

Drafts a cross-project status report using the `templates/strategy/status-update.md` template, populated with real content from recent project notes and goal progress.

## Invocation

`/status-report` — or natural language (e.g. "draft a status update for stakeholders").

## When NOT to use

- The user wants an internal weekly recap (use `/weekly-digest` instead)
- The user wants to create a blank status report template (just point them to the template file)

## Steps

1. Read the template from `templates/strategy/status-update.md`
2. Read recent notes from all active project directories — use `Glob` to find `projects/*/notes/*.md`, then read the most recent 3-5 notes per project
3. Read `GOALS.md` for current goal progress
4. Draft a filled-in status report using the template structure:
   - Pull accomplishments from recent project notes (decisions made, milestones hit)
   - Pull upcoming work from open items in `data/action-items.md` and next steps in project notes
   - Pull risks/blockers from any flagged issues in notes
   - Pull metrics from `GOALS.md` key results table
5. Apply formatting defaults from `memory/doc-formatting.md`
6. Present the draft to the user for review
7. On approval, ask where to save the file and write it

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using only the most recent note per project | Read the last 3-5 notes to capture the full reporting period |
| Leaving template placeholder text in the draft | Replace every placeholder — if data is missing, note it explicitly rather than leaving brackets |
| Skipping the formatting defaults | Always read and apply `memory/doc-formatting.md` |
