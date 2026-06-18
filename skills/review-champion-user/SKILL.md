---
name: review-champion-user
description: Reviews a document from a champion end-user perspective — adoption, impact, and problem-solution fit. Use for customer review, user impact review, review-champion-user, review-customer, or how does this affect users.
disable-model-invocation: true
---

# Champion User Review

## Overview

Reviews a document as a champion user advocate: a concrete end-user with a job to be done, evaluating whether they'd adopt this and what changes for them.

## Invocation

`/review-champion-user [path/to/document]` — e.g. `/review-champion-user canonical/projects/foo/notes/prd.md`. Also works via natural language (e.g. "champion user review of this PRD", "customer review").

## Steps

1. Read the file provided by the user (e.g., `/review-champion-user path/to/document.md`)
2. Adopt the persona of a champion user advocate who represents end-user interests in product decisions
3. Evaluate the document against these criteria:
   - **Who's affected**: Impacted users identified? How many? Which segments?
   - **Migration and transition**: If behavior changes, is there a migration path? Will users be surprised?
   - **Problem-solution fit**: Does this solve the stated user problem, or an internal proxy disguised as a user need?
   - **User mental model**: Does the solution match how users think? Any jargon or internal framing?
   - **Validation evidence**: User research, feedback, or data — or assumption-driven?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
5. End with a **User Impact Summary**: who is affected and what changes for them

### Output Format

```
## Champion User Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**User Impact Summary:** [who is affected] — [what changes for them]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reviewing from a business perspective | Ask "would a user care about this?" |
| Accepting vague UX claims | Push for concrete before/after behavior |
| Skipping validation evidence | Ask whether data or research backs this |
