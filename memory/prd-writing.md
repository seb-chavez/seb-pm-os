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
5. **References** — Links readers can open: Notion pages, Linear tickets, Incident.io, client docs. Do not paste long sources inline.

**Do:** Short sentences; attribute claims with dates, docs, and tickets (not people's opinions in prose). Name the client correctly (subservicer vs. portfolio seller).

**Do not:** Propose solutions; use unverified superlatives ("highest volume in MI," "trust in the platform"); dump tables that belong in Strategy unless essential to stating the problem; name individuals in body prose (see **People and teams** below); link local-only paths (see **Notion audience** below).

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

**Goal:** Outcomes and measurable bars. One sentence of prose, then **one metrics table**. Keep the table small: only rows needed to know whether this build succeeded.

- Opening sentence: when success is achieved and the operational bar in outcome terms.
- Each metric row ties to a problem or risk above.
- Baselines need a source (ops report, ticket, dashboard, named incident).
- Prefer **absolute limits** over percentages when volume scales (e.g., STM intervention count per cycle, not "% of certs" if % of a larger book still breaks ops).
- Binary outcomes are fine (zero duplicate remits, zero edit-loss incidents).

**One table, three types** (Type column first):

| Type | Role |
| ---- | ---- |
| **Primary** | Main scorecard. Did we solve the problem this PRD exists to solve? Usually one row. |
| **Secondary** | Supporting outcome that validates a key bet. Use sparingly (0–2 rows). |
| **Guardrail** | Non-negotiable downside risk. Ship blocked if breached. Tied to Problem risks. |

Do not split into separate "outcome" and "guardrail" tables.

**Metrics are not requirements.** If the row describes a feature behavior (messaging copy, observability, internal processing SLA, eng-op ticket volume), it belongs in Proposal requirements, not Success. Metrics prove the build worked; requirements say what to build.

**5am test:** A tired reader should understand every row on its own. **Short plain name** in Metric; **one-sentence Description** in everyday language. If two metrics are related, Description spells out the difference.

**Metrics table columns:** Type | Metric | Description | Baseline | Target | How we measure

**Measurement column (PRD, not TDD):** State what to count or compare in operator or business terms. Engineering chooses logs, tables, and dashboards during design.

**Do:** Primary row: "Cancel success rate" / "Of every cancel attempt on a multi-loan wire batch, does the disbursement actually get canceled?"

**Do not:** Function names, enum states, log field names, or specific observability tools in Success metrics. Requirement behaviors dressed up as metrics (cutoff messaging rate, escrow correction time, eng-op volume). Paired jargon labels without Description context.

## Notion audience

Notion is the default share surface. Readers cannot open your laptop paths.

**Do:** Link Notion pages, Linear, Incident.io, Confluence, and other workspace URLs in References and cross-references.

**Do not:** Reference `canonical/`, `briefing.md`, `decisions.md`, `research-notes/`, or other local-only repo paths in a Notion PRD. Research files inform the draft; the published doc stands alone or links to durable workspace artifacts.

## Requirements (Proposal)

**Format (every requirement line):**

`[<priority>] **<requirement name>**: <requirement details>.`

Example: `[P0] **Per-loan cancel in multi-loan batch**: Operator can cancel one loan in an approved multi-loan group without eng-op when within the agreed buffer window.`

- **Priority:** `[P0]`, `[P1]`, etc. in square brackets.
- **Name:** bold, short label.
- **Separator:** colon after the name. **No em dashes** in requirement lines.
- **Details:** one testable sentence; end with a period.

Functional and non-functional requirements share one list. No rationale paragraphs under each item.

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
- Local file paths or gitignored research paths in Notion-bound PRDs (see **Notion audience**)
- Code-level measurement specs in Success metrics (function names, state enums, log fields, named dashboards; see **What does success look like?**)
- Requirement behaviors listed as metrics (messaging, observability, eng-op volume, internal SLAs; those belong in Proposal)
- Separate outcome and guardrail metric tables (use one table with a Type column)
- Analyst-style metric names that need a glossary ("eligible completion rate" without saying eligible for what)
- Stakeholder monologues ("Person A wants X, Person B blocked Y") — state the constraint, not the conversation
- `~` for approximations in Notion-bound docs (use `approx.`; tildes render as strikethrough)
- Em dashes in requirement lines (use `[P0] **Name**: details.` per **Requirements (Proposal)**)

## After drafting

Run `review-panel` or a single persona review if the doc is high-stakes. For client-facing PRDs, confirm milestone dates and loan counts against the latest spreadsheet or Slack confirmation before pushing to Notion.
