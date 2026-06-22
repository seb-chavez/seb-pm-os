# PRD Writing Guide

Use with `templates/prds/prd.md` (structure) and `memory/doc-formatting.md` (Notion formatting). The template holds section placeholders; this file holds the writing rules we apply when drafting Problem sections.

## Section order

1. **Problem** (four subsections) — complete before Proposal
2. **Proposal** — approach, flows, requirements
3. **Plan** — timeline, risks, **Open Questions last**

Open Questions never live inside Problem. When a question is answered, move the fact into Problem or Proposal and note resolution in the table.

## Problem vs. Proposal

| Problem | Proposal |
| ------- | -------- |
| What is broken, who hurts, stakes, deadline | How we will fix it |
| Outcomes and measurable bars | Uploads, diffs, queues, integrations |
| Risks as facts (e.g., duplicate remit possible) | Mitigations and requirements |
| What we are not trying to solve (milestone scope) | Engineering out-of-scope within the build |

If a sentence names a screen, API, file format, or workflow step the team will build, it belongs in Proposal.

## What is the problem?

**Goal:** A reader can repeat the problem and its stakes after this subsection alone.

**Structure (use what fits):**

1. **Core workflow gap** — What the system does today vs. what must be true. Name the authoritative source (regulator bill, client file, carrier feed, ledger).
2. **Related failure modes** — Separate problems that share a project but are not the same bug (e.g., dual-system double payment during migration). Facts and risks only.
3. **Who it hurts** — Bold labels per audience (Operators, Engineering, Client, Borrowers). One concrete example each.
4. **Why it matters** — Forcing deadline with sourced numbers (today's scale vs. upcoming). Financial or compliance exposure with citations.
5. **References** — Links to research, spreadsheets, tickets, meeting notes. Do not paste long sources inline.

**Do:** Short sentences; attribute claims (person, date, doc, ticket); name the client correctly (subservicer vs. portfolio seller).

**Do not:** Propose solutions; use unverified superlatives ("highest volume in MI," "trust in the platform"); dump tables that belong in Strategy unless essential to stating the problem.

## How does this connect to strategy?

**Goal:** Which priority this serves and why timing matches a milestone.

**Include:** Milestone or conversion (date, volume, client); honest reason for elevation (pipeline, incident, regulatory finding).

**Optional:** One small table only if it shows volume ramp tied to timing (not a general data dump).

**Do not:** Repeat the full Problem narrative; describe how engineering will build the fix; name future clients unless directly tied to the deadline.

## What does success look like?

**Goal:** Outcomes and measurable bars. One sentence of prose, then the metrics table.

- Opening sentence: when success is achieved and the operational bar in outcome terms.
- Each metric row ties to a problem or risk above.
- Baselines need a source (ops report, ticket, dashboard, named incident).
- Prefer **absolute limits** over percentages when volume scales (e.g., STM intervention count per cycle, not "% of certs" if % of a larger book still breaks ops).
- Binary outcomes are fine (zero duplicate remits, zero edit-loss incidents).

## What are we not trying to solve?

**Goal:** Scope line for this milestone.

- Opening: what delivery and by when.
- Bullets: **Topic:** what is excluded and why (timeline, other team, unverified workflow, follow-on).
- Dependencies on other teams: we depend on the answer but do not build their side.
- Typically 5–10 bullets. If unsure whether something is true, use Open Questions instead of stating it as out-of-scope fact.

## Anti-patterns (from review)

- "Milestone thesis," "gating question," "trust in the platform"
- Solutioning in Problem or Success ("ops uploads the bill," "system diffs against HUD")
- Percentage targets that ignore scale (e.g., "<10% manual edits" when 10% of 40k certs exceeds STM capacity)
- Unverified workflows stated as fact (move to Open Questions)
- `~` for approximations in Notion-bound docs (use `approx.`; tildes render as strikethrough)
- Em dashes as sentence connectors (see `doc-formatting.md`)

## After drafting

Run `review-panel` or a single persona review if the doc is high-stakes. For client-facing PRDs, confirm milestone dates and loan counts against the latest spreadsheet or Slack confirmation before pushing to Notion.
