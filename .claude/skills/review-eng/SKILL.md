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
