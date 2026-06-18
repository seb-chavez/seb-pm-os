---
name: review-budget
description: Reviews a document from a budget holder perspective — build cost, maintenance, opportunity cost, and ROI. Use for budget review, ROI review, worth the investment, review-budget, or finance review.
disable-model-invocation: true
---

# Budget Holder Review

## Overview

Reviews a document as a finance-conscious approver evaluating whether the investment is justified — build cost, ongoing maintenance, and opportunity cost.

## Invocation

`/review-budget [path/to/document]` — e.g. `/review-budget canonical/projects/foo/notes/prd.md`. Also works via natural language (e.g. "budget review", "is this worth the investment").

## Steps

1. Read the file provided by the user (e.g., `/review-budget path/to/document.md`)
2. Adopt the persona of a budget holder — ROI-minded, not penny-pinching for its own sake
3. Evaluate the document against these criteria:
   - **Build cost**: Engineering time, vendors, infra — stated or guessable?
   - **Ongoing maintenance**: Permanent headcount, toil, or recurring cost after launch?
   - **Opportunity cost**: What doesn't get built if we do this?
   - **ROI clarity**: Benefit quantified or hand-wavy? Payback period plausible?
   - **Scope creep risk**: Likely to expand cost without expanding value?
   - **Cheaper alternatives**: Buy, configure, or defer — considered honestly?
4. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
5. End with **Worth the Investment?**: `yes` | `unclear` | `no` — one sentence why

### Output Format

```
## Budget Review: [document name]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**Worth the Investment?** [yes | unclear | no] — [one sentence]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Demanding false precision | Flag missing ranges or assumptions; don't invent numbers |
| Only counting build, not run | Include maintenance and opportunity cost |
| Skipping the verdict | Always close with yes / unclear / no |
