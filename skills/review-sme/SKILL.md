---
name: review-sme
description: Reviews a document from a subject matter expert perspective — domain accuracy, precedent, and expert-level gaps. Grounds mortgage servicing factual checks in Valon toolshed mortgage-domain skills. Use for SME review, expert review, subject matter expert, review-sme, or domain check.
disable-model-invocation: true
---

# Subject Matter Expert Review

## Overview

Reviews a document as a deep domain authority. **Factual and regulatory "is this correct?" checks must be grounded in source material**, not model recall alone.

For **mortgage servicing** documents, Valon toolshed **`mortgage-domain`** (`mortgage-domain-skills`) is the authority. Use the model for judgment only where skills do not speak (gaps, open questions, product tradeoffs), and label those findings **unverified**.

## Invocation

`/review-sme [path/to/document]` — e.g. `/review-sme canonical/projects/foo/notes/prd.md`. Also works via natural language (e.g. "SME review", "have an expert read this").

## Epistemic rules

| Question type | Source |
|---------------|--------|
| Regs, investor/insurer rules, servicing process, terminology, "most restrictive rule" | **`mortgage-domain`** child skills you loaded |
| VDS schema / field definitions | **`vds-entity-router`** (not mortgage-domain) |
| ServiceMac data shape | **`servicemac-domain`** (not mortgage-domain) |
| Missing scope, ambiguous requirements, precedent, "what would an expert ask?" | Model judgment, tagged **unverified** |
| Conflict between doc and a loaded skill | **BLOCKER**; cite the skill path |

Do not state regulatory or process facts as expert findings unless they are supported by a skill you read in this session or clearly marked **unverified**.

## Steps

1. Read the document provided by the user.
2. **Infer domain** (product area, industry, regulation, tech stack). State it in the output.
3. **Ground before judging accuracy** (see below). Skip only if the doc is clearly outside mortgage servicing and you are not using mortgage-domain.
4. Adopt the persona of a respected practitioner — precise, not pedantic.
5. Evaluate against:
   - **Domain accuracy** (grounded checks against loaded skills when mortgage-domain applies)
   - **Industry precedent** (unverified unless sourced)
   - **Expert questions** the doc does not answer
   - **Amateur mistakes** (especially contradictions of loaded skills)
   - **Missing nuance** (oversimplifications that fail in practice)
   - **Standards and compliance** (prefer citations from loaded CFPB/GSE/state skills)
6. Present findings as a numbered list with severity (`BLOCKER` | `CONCERN` | `SUGGESTION`).
7. End with **Expert Verdict**: `credible` | `needs work` | `not credible yet` — one sentence why.

### Mortgage servicing grounding (mandatory when applicable)

Treat the doc as **mortgage servicing** if it discusses escrow, taxes/insurance, loss mitigation, delinquency, foreclosure, bankruptcy, MI/PMI, SCRA, early intervention, investor (Fannie/Freddie/Ginnie), FHA/VA/USDA, state servicing/foreclosure rules, or similar.

When applicable:

1. **Read** the toolshed skill **`mortgage-domain`** (full `SKILL.md`). If it is not available in the harness (no toolshed mortgage plugin), set **Grounding: unavailable** in the output, note that factual review is unverified, and continue with other criteria only.
2. From the document, list **topics** (e.g. escrow analysis, RESPA 120-day, LM dual tracking).
3. **Route and read** only the relevant child skills using the quick routing table in `mortgage-domain` (e.g. Escrow → `federal/cfpb/administering-escrow-accounts`; Foreclosure → `workflows/routing-foreclosure-skills` then follow its pointers). Read enough depth to validate claims in the doc (parent `SKILL.md` plus topic-specific files as needed). Do not load the entire tree.
4. Apply **skill layering**: federal + investor + insurer + state; **most restrictive rule wins** when the doc implies a single rule but multiple authorities apply.
5. While reviewing, cross-check every material factual/regulatory claim in the doc against what you read. Missing coverage in skills ≠ "wrong"; say **not covered in skills consulted** and mark **unverified** if you would otherwise rely on model knowledge.

Optional: if the doc is escrow **operations/triage** at Valon (not regulatory text), add toolshed **`escrow-triage`** or project `canonical/` only for internal process; still use mortgage-domain for compliance accuracy.

### Output format

```
## SME Review: [document name]

**Domain inferred:** [domain]
**Grounding:** mortgage-domain | partial (list gaps) | unavailable | not applicable
**Skills consulted:** [toolshed paths read, or "none"]

1. **[SEVERITY]** [finding] [grounded: `path/to/skill` | unverified]
   → [recommendation]

...

**Expert Verdict:** [credible | needs work | not credible yet] — [one sentence]
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Generic expertise with no domain anchor | State domain; load mortgage-domain when applicable |
| Stating regs/process from memory | Cite a consulted skill path or tag **unverified** |
| Loading all mortgage-domain files | Route from the doc topics; read targeted skills only |
| Using mortgage-domain for VDS/ServiceMac | Use `vds-entity-router` / `servicemac-domain` instead |
| Nitpicking terminology over substance | Flag errors that would undermine credibility with real experts |
| Missing the verdict | Always close with credible / needs work / not credible yet |
