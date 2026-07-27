# Research bundle → PRD sections

Use after `/prd-research`. The research bundle is the **only** primary source for facts; the PRD compresses and decides scope.

## Required inputs (`{research_dir}/`)

| File | Role in drafting |
|------|------------------|
| `briefing.md` | Narrative source for Problem, strategy tie-in, gaps, money section |
| `decisions.md` | Unresolved questions must be resolved (or parked in Open Questions) before Proposal |
| `sources.md` | Citations and confidence; link from Problem References |
| `research-notes/*.md` | Detail on demand: `regulatory.md`, `codebase.md`, `ops-current-state.md`, `customer.md`, `accounting.md`, `bug-catalog.md`, etc. |

If `briefing.md` or `research-notes/` is missing, stop and run `/prd-research` first.

## Section mapping

| PRD section (`templates/prds/prd.md`) | Primary research sources |
|---------------------------------------|---------------------------|
| One-line description (top) | `briefing.md` Executive Summary; write **last** |
| **Problem → What is the problem?** | `briefing.md` §1 World Today, §4 Gaps; `ops-current-state.md`, `bug-catalog.md` (patterns, not ticket dump) |
| **Problem → Strategy** | `briefing.md` §1; `stakeholder-context.md`; `GOALS.md` if user points to it |
| **Problem → Success** | `briefing.md` §4 + risks; ops/customer stakes; **outcomes only** |
| **Problem → Not trying to solve** | `decisions.md` scope forks; `briefing.md` §4; explicit milestone boundary |
| **Proposal → How solve** | `decisions.md` **after PM resolves** chosen options; `briefing.md` §5 pointers only until decided |
| **Proposal → How it works** | `codebase.md`, `existing-tools.md`; link mocks if stakeholder-context names them |
| **Requirements** | `codebase.md` (what exists), `regulatory.md` (must-haves), `decisions.md`; one testable line each |
| **Dependencies** | `stakeholder-context.md` |
| **Plan → Timeline** | `stakeholder-context.md`; Linear dates from research |
| **Plan → Risks** | `bug-catalog.md` patterns, `briefing.md` §4 |
| **Plan → Open Questions** | Leftovers from `decisions.md` + new gaps found while drafting |

## What not to paste

- Do not paste `briefing.md` or research-notes into the PRD. Link in **References** under Problem.
- Do not re-litigate research in Proposal. If research is wrong, fix research files or note in Open Questions.
- PRDs from Notion found during research stay excluded unless the PM explicitly asks to incorporate them.

## Multiple PRDs

When `decisions.md` or the PM specifies phased delivery (e.g. P0 kill switch vs P1 buffer):

- One file per doc: `prd-p0.md`, `prd-p1.md`, or names the PM gives.
- Shared Problem facts: cross-link or one sentence + link to sibling PRD.
- **Not trying to solve** on P0 should name P1 explicitly and vice versa.

## Confidence labels

Preserve `[DATA VERIFIED]` / `[INTERPRETATION VERIFIED]` from research when a claim is high-stakes (compliance, dollars, volume). In the PRD, prefer sourced prose (ticket, date, doc link) over inline bracket tags unless the PM wants tags kept.
