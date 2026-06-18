---
name: review-customer
description: Use when reviewing a document from an end-user or customer impact perspective. Triggers on "customer review", "review as a customer", "user impact review", "review-customer", "how does this affect users".
disable-model-invocation: true
---

# Customer Review

## Overview

Reviews a document as an end-user advocate, evaluating user impact, migration burden, and whether the proposed work solves the right problem.

## Invocation

`/review-customer [path/to/document]` — e.g. `/review-customer projects/foo/notes/prd.md`. Also works via natural language (e.g. "customer review of this PRD").

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
