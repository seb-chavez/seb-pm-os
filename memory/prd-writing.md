# PRD Writing Guide

Use with `templates/prds/prd.md` (structure), `memory/doc-formatting.md` (Notion formatting), and `memory/writing-style.md` (prose). The template holds section placeholders; this file holds the writing rules we apply when drafting Problem sections.

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

**Do:** Short sentences; attribute claims with dates, docs, and tickets (not people's opinions in prose). Name the client correctly (subservicer vs. portfolio seller).

**Do not:** Propose solutions; use unverified superlatives ("highest volume in MI," "trust in the platform"); dump tables that belong in Strategy unless essential to stating the problem; name individuals in body prose (see **People and teams** below).

## People and teams

PRD body prose is about the problem, constraints, and outcomes — not who said what in a meeting.

**Do not** name individuals in Problem, Strategy, Success, Proposal narrative, or Risks. Wrong: "INC-230 made wire safety non-negotiable for John Colella. Ben Zhou needs ops self-serve back." Right: "INC-230 made wire safety a hard constraint. Operations needs self-serve cancel where it is safe."

**Use team or function names only when the dependency is the point:** Escrow engineering, Treasury, ProdOps, tax operations. Skip even those when the sentence works without them.

**Where names are OK:**
- **Reviewers** table (sign-off list)
- **Open Questions** and **Dependencies** Owner/POC columns (role or team preferred: "Escrow PM," "Escrow eng"; use a person's name only when one DRI is required and no role label fits)

**Do not** turn stakeholder quotes, preferences, or internal debates into PRD narrative. If a person's position matters, state the constraint as a fact ("wire delay is unacceptable after INC-230") or link the ticket/meeting note in References.

## How does this connect to strategy?

**Goal:** Which priority this serves and why timing matches a milestone.

**Include:** Milestone or conversion (date, volume, client); honest reason for elevation (pipeline, incident, regulatory finding).

**Optional:** One small table only if it shows volume ramp tied to timing (not a general data dump).

**Do not:** Repeat the full Problem narrative; describe how engineering will build the fix; name future clients unless directly tied to the deadline; name individuals or quote their positions in prose.

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

- Importance sentences, AI vocabulary, contrast structures, vague authority, summary endings (see `memory/writing-style.md`)
- "Milestone thesis," "gating question," "trust in the platform"
- Solutioning in Problem or Success ("ops uploads the bill," "system diffs against HUD")
- Percentage targets that ignore scale (e.g., "<10% manual edits" when 10% of 40k certs exceeds STM capacity)
- Unverified workflows stated as fact (move to Open Questions)
- Individual names in body prose (Reviewers and Owner/POC columns excepted; see **People and teams**)
- Stakeholder monologues ("Person A wants X, Person B blocked Y") — state the constraint, not the conversation
- `~` for approximations in Notion-bound docs (use `approx.`; tildes render as strikethrough)
- Em dashes as sentence connectors (see `doc-formatting.md`)

## After drafting

Run `review-panel` or a single persona review if the doc is high-stakes. For client-facing PRDs, confirm milestone dates and loan counts against the latest spreadsheet or Slack confirmation before pushing to Notion.
