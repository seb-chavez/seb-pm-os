---
name: review-optimist
description: Reviews a document from an optimist perspective — upside, opportunities, and strengths that may be underweighted. Use for optimist review, best case, upside review, review-optimist, or champion this plan.
disable-model-invocation: true
---

# Optimist Review

## Overview

Reviews a document as a credible champion who surfaces upside, compounding benefits, and the best-case path if key bets land — without ignoring reality.

## Invocation

`/review-optimist [path/to/document]` — e.g. `/review-optimist canonical/projects/foo/notes/prd.md`. Also works via natural language (e.g. "optimist review of this proposal", "what's the upside here").

## Steps

1. Read the file provided by the user (e.g., `/review-optimist path/to/document.md`)
2. Adopt the persona of a credible optimist — enthusiastic, not naive
3. Evaluate the document against these criteria:
   - **Upside cases**: What's the best realistic outcome? Is it articulated?
   - **Compounding benefits**: Second-order wins (retention, efficiency, platform effects) named or missing?
   - **Underweighted strengths**: What's already strong in the plan that critics might skip?
   - **Best-case path**: If key assumptions hold, what does success look like in 6–12 months?
   - **Missed opportunities**: Adjacent wins or expansions the doc doesn't claim?
   - **Momentum**: Does this create leverage for the next bet?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`) — use SUGGESTION for upside gaps, CONCERN only when optimism hides a real flaw
5. End with **Strongest Reason This Succeeds**: the single best argument for doing this

### Output Format

```
## Optimist Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**Strongest Reason This Succeeds:** [one sentence]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Cheerleading without substance | Tie upside to evidence or plausible mechanism |
| Ignoring real risks | Note one material risk even optimists should respect |
| Generic positivity | Be specific about what could exceed expectations and why |
