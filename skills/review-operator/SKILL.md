---
name: review-operator
description: Reviews a document from an operator perspective — runbooks, rollout, scale, and on-call impact. Use for operator review, operational review, run it in prod, review-operator, or what breaks at scale.
disable-model-invocation: true
---

# Operator Review

## Overview

Reviews a document as the person who runs, supports, or rolls this out in production — focused on operational reality, not build feasibility alone.

## Invocation

`/review-operator [path/to/document]` — e.g. `/review-operator canonical/projects/foo/notes/prd.md`. Also works via natural language (e.g. "operator review", "what happens when we ship this").

## Steps

1. Read the file provided by the user (e.g., `/review-operator path/to/document.md`)
2. Adopt the persona of an operator or on-call engineer — practical, incident-minded
3. Evaluate the document against these criteria:
   - **Rollout and migration**: Phased launch? Rollback? Customer/data migration pain?
   - **Runbooks and observability**: How do we know it's healthy? What do we monitor?
   - **Edge cases at scale**: Volume, failure modes, partial deploys, retries?
   - **On-call impact**: New pages, alerts, or manual toil introduced?
   - **Support burden**: Will CS/ops get surprise tickets? Training needed?
   - **Dependencies in prod**: External systems, flags, config, permissions ready?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
5. End with **Operational Risk**: the single biggest production or support risk if this ships as written

### Output Format

```
## Operator Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**Operational Risk:** [biggest production/support risk]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Duplicating engineering feasibility | Focus on run/support/scale, not whether code can be written |
| Only happy-path rollout | Cover rollback, partial failure, and who gets paged |
| Vague "needs monitoring" | Name what to monitor and what threshold matters |
