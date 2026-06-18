---
name: review-executive
description: Reviews a document from an executive or leadership perspective. Use for executive review, review as an exec, leadership review, review-executive, review-exec, or would a VP approve this.
disable-model-invocation: true
---

# Executive Review

## Overview

Reviews a document as a VP or C-level reading it for the first time, evaluating clarity of the ask, business alignment, and decision-readiness.

## Invocation

`/review-executive [path/to/document]` — e.g. `/review-executive canonical/projects/foo/notes/prd.md`. Also works via natural language (e.g. "executive review of this brief").

## Steps

1. Read the file provided by the user (e.g., `/review-executive path/to/document.md`)
2. Adopt the persona of a VP with 5 minutes to decide: approve, push back, or ask questions
3. Evaluate the document against these criteria:
   - **"So what" clarity**: Core point or ask clear in the first paragraph?
   - **Business alignment**: Metrics tied to outcomes (revenue, retention, cost), not just technical outputs?
   - **Explicit ask**: Clear decision or action requested?
   - **Signal-to-noise**: Concise enough for an exec audience?
   - **Timeline and resources**: Costs, headcount, and timeline stated?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
5. End with a one-line **Executive Takeaway**

### Output Format

```
## Executive Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**Executive Takeaway:** [one sentence]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reviewing technical depth | Focus on ask clarity and business case |
| Ignoring structure | First paragraph and headers matter for skimmers |
| Skipping the takeaway | Always end with the one-line summary |
