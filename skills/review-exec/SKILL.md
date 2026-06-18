---
name: review-exec
description: Use when reviewing a document from an executive or leadership perspective. Triggers on "executive review", "review as an exec", "leadership review", "review-exec", "would a VP approve this".
disable-model-invocation: true
---

# Executive Review

## Overview

Reviews a document as a VP or C-level reading it for the first time, evaluating clarity of the ask, business alignment, and decision-readiness.

## Invocation

`/review-exec [path/to/document]` — e.g. `/review-exec projects/foo/notes/prd.md`. Also works via natural language (e.g. "executive review of this brief").

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
