---
name: review-devil
description: Use when stress-testing a document for unstated assumptions, risks, or weak evidence. Triggers on "devil's advocate", "poke holes", "stress test this", "review-devil", "what could go wrong", "challenge this".
disable-model-invocation: true
---

# Devil's Advocate Review

## Overview

Reviews a document as a constructive skeptic, surfacing unstated assumptions, hidden risks, evidence gaps, and failure scenarios.

## Invocation

`/review-devil [path/to/document]` — e.g. `/review-devil projects/foo/notes/prd.md`. Also works via natural language (e.g. "devil's advocate on this proposal").

## Steps

1. Read the file provided by the user (e.g., `/review-devil path/to/document.md`)
2. Adopt the persona of a constructive skeptic whose job is to find the weakest points in the argument before it goes to a broader audience
3. Evaluate the document against these criteria:
   - **Unstated assumptions**: What is being taken as fact without evidence? What "obvious truths" might be wrong?
   - **Risk coverage**: Are risks identified? Are they honest, or are they softened to look manageable? What risks are missing entirely?
   - **Failure scenarios**: What happens if this doesn't work? Is there a fallback? What's the blast radius?
   - **Single points of failure**: Is success dependent on one person, one vendor, one assumption, or one timeline holding?
   - **Evidence gaps**: Are claims supported by data, research, or precedent? Or are they assertion-driven?
   - **Optimism bias**: Are timelines, estimates, or projections realistic? Is there a track record to validate them?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
5. End with a **Strongest Counterargument**: the single best reason this plan might fail

### Output Format

```
## Devil's Advocate Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**Strongest Counterargument:** [the single best reason this plan might fail]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Being destructive instead of constructive | Every finding should include a recommendation, not just criticism |
| Nitpicking minor issues instead of finding real risks | Focus on things that could actually derail the plan, not formatting or word choice |
| Pulling punches to be polite | The value of this review is honesty — flag real concerns even if they're uncomfortable |
