# Research bundle → PRD sections

Use after `/prd-research`. The research bundle is the **only** primary source for facts; the PRD compresses and decides scope.

**Translation mandate:** Research is often technical. The PRD **distills** it into senior-PM prose. Never copy codebase vocabulary, milestone lists, or ticket titles into Problem body text. See **Writing paradigm** in `SKILL.md` (overrides this file when they conflict).

## Required inputs (`{research_dir}/`)

| File | Role in drafting |
|------|------------------|
| `briefing.md` | Facts for Problem; translate §1/§4 into pain and stakes, not a research recap |
| `decisions.md` | Unresolved questions must be resolved (or parked in Open Questions) before Proposal |
| `sources.md` | Citations and confidence; link from Problem References |
| `research-notes/*.md` | Detail on demand; **translate** before writing (especially `codebase.md`, `ops-current-state.md`) |

If `briefing.md` or `research-notes/` is missing, stop and run `/prd-research` first.

## Section mapping

| PRD section (`templates/prds/prd.md`) | Primary research sources | Writing note |
|---------------------------------------|---------------------------|--------------|
| One-line description (top) | `briefing.md` Executive Summary; write **last** | User/business outcome in plain language |
| **Problem → What is the problem?** | `briefing.md` §1 World Today, §4 Gaps; `ops-current-state.md`, `bug-catalog.md` | Workflow gap + who hurts. No ticket dumps. No adapter/cron language. |
| **Problem → Strategy** | `briefing.md` §1; `stakeholder-context.md`; `GOALS.md` if user points to it | Why now = business consequence of waiting, not a Linear milestone list |
| **Problem → Success** | `briefing.md` §4 + risks; ops/customer stakes | Outcomes only; one typed metrics table (Primary / Secondary / Guardrail) |
| **Problem → Not trying to solve** | `decisions.md` scope forks; `briefing.md` §4; explicit milestone boundary | Milestone scope in product terms |
| **Proposal → How solve** | `decisions.md` **after PM resolves** chosen options; `briefing.md` §5 pointers only until decided | Brief approach narrative; sparing vendor/system names |
| **Proposal → How it works** | `codebase.md`, `existing-tools.md`; link mocks if stakeholder-context names them | User/operator flows first; technical detail only where scope needs it |
| **Requirements** | `codebase.md` (what exists), `regulatory.md` (must-haves), `decisions.md` | One outcome line each; **ops reader test**; no implementation recipes |
| **Dependencies** | `stakeholder-context.md` | Teams, vendors, external systems OK here |
| **Plan → Timeline** | `stakeholder-context.md`; Linear dates from research | **Home for milestone dates**; tie to consequence when helpful |
| **Plan → Risks** | `bug-catalog.md` patterns, `briefing.md` §4 | Plain-language risk statements |
| **Plan → Open Questions** | Leftovers from `decisions.md` + new gaps found while drafting | |

## What not to paste

- Do not paste `briefing.md` or research-notes into the PRD. Link in **References** under Problem.
- Do not paste Linear milestone names/dates into Problem "Why it matters."
- Do not paste contract names, adapter types, cron families, class names, or enum states into Problem or requirements.
- **Notion PRDs:** References must be workspace URLs only. Local paths (`canonical/`, `briefing.md`, `decisions.md`) are for drafting; readers cannot open them.
- **Success metrics:** One table with Type column (Primary, Secondary, Guardrail). Outcome language only in measurement column. No requirement behaviors as metrics. No function names, enum states, log fields, or named observability tools; engineering defines instrumentation in design docs.
- Do not re-litigate research in Proposal. If research is wrong, fix research files or note in Open Questions.
- PRDs from Notion found during research stay excluded unless the PM explicitly asks to incorporate them.

## Multiple PRDs

When `decisions.md` or the PM specifies phased delivery (e.g. P0 kill switch vs P1 buffer):

- One file per doc: `prd-p0.md`, `prd-p1.md`, or names the PM gives.
- Shared Problem facts: cross-link or one sentence + link to sibling PRD.
- **Not trying to solve** on P0 should name P1 explicitly and vice versa.

## Confidence labels

Preserve `[DATA VERIFIED]` / `[INTERPRETATION VERIFIED]` from research when a claim is high-stakes (compliance, dollars, volume). In the PRD, prefer sourced prose (ticket, date, doc link) over inline bracket tags unless the PM wants tags kept.
