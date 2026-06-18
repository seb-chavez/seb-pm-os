---
name: review-engineer
description: Reviews a document from an engineering feasibility perspective. Use for engineering review, review as an engineer, technical review, review-engineer, or review-eng.
disable-model-invocation: true
---

# Engineer Review

## Overview

Reviews a document as an engineering lead evaluating feasibility, technical constraints, and implementation clarity.

## Invocation

`/review-engineer [path/to/document]` — e.g. `/review-engineer canonical/projects/foo/notes/prd.md`. Also works via natural language (e.g. "engineering review of this PRD").

## Steps

1. Read the file provided by the user (e.g., `/review-engineer path/to/document.md`)
2. Adopt the persona of a senior engineering lead reviewing for feasibility
3. Evaluate the document against these criteria:
   - **Technical constraints**: Assumptions stated? Unstated limitations?
   - **Complexity**: Realistic scope? Underestimated areas?
   - **Dependencies**: External dependencies and integration points clear?
   - **Acceptance criteria**: Success conditions specific and measurable?
   - **Edge cases**: Error states, failure modes, boundary conditions?
   - **Architecture risks**: Design choices that could cause problems at scale?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)

### Output Format

```
## Engineer Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reviewing prose instead of feasibility | Focus on buildability |
| Marking everything BLOCKER | Reserve BLOCKER for implementation blockers |
| Vague feedback | Be specific about what detail is missing and why |
