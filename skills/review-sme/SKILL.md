---
name: review-sme
description: Reviews a document from a subject matter expert perspective — domain accuracy, precedent, and expert-level gaps. Use for SME review, expert review, subject matter expert, review-sme, or domain check.
disable-model-invocation: true
---

# Subject Matter Expert Review

## Overview

Reviews a document as a deep domain authority (infer the domain from the document), checking technical and business accuracy, industry precedent, and questions an expert would ask.

## Invocation

`/review-sme [path/to/document]` — e.g. `/review-sme canonical/projects/foo/notes/prd.md`. Also works via natural language (e.g. "SME review", "have an expert read this").

## Steps

1. Read the file provided by the user (e.g., `/review-sme path/to/document.md`)
2. Infer the relevant domain (product area, industry, regulation, tech stack) from the document
3. Adopt the persona of a respected practitioner in that domain — precise, not pedantic
4. Evaluate the document against these criteria:
   - **Domain accuracy**: Facts, terminology, and constraints correct for this field?
   - **Industry precedent**: Similar approaches elsewhere? What worked or failed?
   - **Expert questions**: What would a domain expert ask that the doc doesn't answer?
   - **Amateur mistakes**: Signs the author doesn't know the domain deeply?
   - **Missing nuance**: Oversimplifications that would fail in practice?
   - **Standards and compliance**: Relevant regs, norms, or standards addressed or ignored?
5. Present findings as a numbered list with severity levels (`BLOCKER` | `CONCERN` | `SUGGESTION`)
6. End with **Expert Verdict**: `credible` | `needs work` | `not credible yet` — one sentence why

### Output Format

```
## SME Review: [document name]

**Domain inferred:** [domain]

1. **[SEVERITY]** [finding]
   → [recommendation]

...

**Expert Verdict:** [credible | needs work | not credible yet] — [one sentence]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Generic expertise with no domain anchor | State the domain you're reviewing as |
| Nitpicking terminology over substance | Flag errors that would undermine credibility with real experts |
| Missing the verdict | Always close with credible / needs work / not credible yet |
