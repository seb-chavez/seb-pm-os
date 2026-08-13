# PRD Writing Guide

Use with `templates/prds/prd.md` (structure), `memory/doc-formatting.md` (Notion formatting), and `memory/writing-style.md` (prose). The template holds section placeholders; this file holds the writing rules we apply when drafting Problem sections.

The `/prd-drafting` skill extends this guide with worked examples; both share the same voice rules below.

## Voice and audience

Write like a seasoned senior PM explaining a messy domain to a smart non-engineer. Plain sentences. Concrete examples. **Distill complexity; do not reproduce it.**

The PRD is a product document for mixed audiences (PM, ops, eng leads, client stakeholders). It is not a technical design doc, architecture note, or project tracker export. Engineering writes the TDD with implementation vocabulary; the PRD gives constraints and acceptance outcomes.

| Section | Language |
| ------- | -------- |
| Problem (all subsections) | Business and operator terms only |
| Success metrics | Outcomes in operator or business terms |
| Strategy | Why this priority now, tied to business consequence |
| Proposal narrative | Sparing technical context only where scope needs it |
| Requirements | Testable user/business outcomes |
| Plan / Timeline | Milestone dates live here |

**Ops reader test:** Could Escrow ProdOps read a Problem paragraph or requirement line and know what breaks or what "done" looks like, without knowing our codebase? If not, simplify.

**Translation rule:** When research or tickets name an integration pattern, contract, adapter, or cron, ask *what breaks for a person if we do not ship this?* Write that answer. Link the source in **References** at the bottom of the doc; keep body prose human.

## Section order

1. **Problem** (opening paragraphs + strategy, success, scope subsections) — complete before Proposal
2. **Proposal** — approach, flows, requirements
3. **Plan** — timeline, risks, **Open Questions last**
4. **References** — workspace URLs only; single list at the very bottom

Open Questions never live inside Problem. When a question is answered, move the fact into Problem or Proposal and note resolution in the table.

## Problem vs. Proposal

| Problem | Proposal |
| ------- | -------- |
| What is broken, who hurts, business stakes | What we will deliver and how users/systems behave after |
| Outcomes and measurable bars | Behavioral requirements and scope boundaries |
| Risks as facts (e.g., duplicate remit possible) | Mitigations and requirements |
| What we are not trying to solve (milestone scope) | Engineering out-of-scope within the build |

If a sentence names a screen, API, file format, or workflow step the team will build, it belongs in Proposal.

Deadlines and milestone dates are **planning context** (Plan → Timeline, or one Strategy sentence with business consequence). They are not the problem and must not stand in for "why it matters."

## Problem (opening paragraphs)

**Goal:** A reader who never opens Linear can repeat the problem and its stakes after reading this section alone.

**Length:** One paragraph by default; 2 to 4 sentences. A second paragraph requires a separate, directly related current harm that cannot fit clearly in the first.

**Content:** Weave together what is broken, who bears the cost, and why it matters now in normal prose. Stop once the core gap and direct consequence are clear. Do not use subheaders, numbered blocks, bold audience labels (**Operators**, **Borrowers**), or bullet lists to spell out "who hurts." Say it the way you would in a Slack message to a cross-functional lead.

**Why it matters: wrong vs. right**

| Wrong | Right |
| ----- | ----- |
| "PRD Ready 2026-09-25, tech scoping 2026-10-30, launch 2027-04-01. Carrington go-live Q1 2027. SWBC is Q4 2026 must-have." | "Without carrier insurance data on these loans, escrow analysts manually chase certificates and miss force-placed coverage windows. Carrington onboarding adds approx. 40k loans where this gap becomes daily ops load." |
| "**Operators:** manual cert chase. **Borrowers:** force-placed risk. **Client:** onboarding blocked." | "Analysts spend hours chasing SWBC certificates by email, borrowers sit exposed to unnecessary force-placed coverage, and Carrington onboarding cannot scale on manual work." |
| "Sagent sends the data. Valon does not. The exchange will stop. SWBC will lose the data it needs." | "When Carrington moves from Sagent to Valon OS, SWBC will stop receiving the data it needs to monitor coverage and request payments." |
| Core gap followed by mappings, review ownership, another integration's exception rate, and pilot timing | Stop after the core gap. Route those facts to Proposal, Open Questions, Success, Risks, or Plan. |

**Do:** Short sentences; sourced numbers when they clarify stakes (loan counts, manual hours, dollars at risk). Name the client correctly (subservicer vs. portfolio seller). State each cause, transition, and consequence once.

**Do not:** Propose solutions; recite project management metadata as the "why"; paste research structure verbatim; use contract names, adapter types, cron jobs, enum states, or ticket IDs in body prose; use bold labels or bullets to enumerate audiences; write an essay; retain a fact only because it appeared in research.

**Compression pass:** For each sentence, identify the new fact. Delete or combine any sentence that repeats an adjacent fact. Remove background that does not change the problem, stakes, or scope. If the paragraph builds toward its point, move the point to the first sentence.

**Relevance gate:** Include a fact in Problem only when it (1) describes the current gap or direct consequence, (2) concerns this exact workflow and integration, and (3) is necessary to understand why the work is needed. All three must be true.

- File formats, mapping drafts, payment ownership, and funding models belong in Proposal or Open Questions.
- Vendor response status belongs in Plan or Dependencies.
- Pilot dates and launch windows belong in Strategy or Plan.
- Metrics from another integration are omitted unless the same causal mechanism is proven and the comparison changes a requirement or measurable outcome.

## People and teams

PRD body prose is about the problem, constraints, and outcomes — not who said what in a meeting.

**Do not** name individuals in Problem, Strategy, Success, Proposal narrative, or Risks. Wrong: "INC-230 made wire safety non-negotiable for John Colella. Ben Zhou needs ops self-serve back." Right: "INC-230 made wire safety a hard constraint. Operations needs self-serve cancel where it is safe."

**Use team or function names only when the dependency is the point:** Escrow engineering, Treasury, ProdOps, tax operations. Skip even those when the sentence works without them.

**Where names are OK:**
- **Reviewers** table (sign-off list)
- **Open Questions** and **Dependencies** Owner/POC columns (role or team preferred: "Escrow PM," "Escrow eng"; use a person's name only when one DRI is required and no role label fits)

**Do not** turn stakeholder quotes, preferences, or internal debates into PRD narrative. If a person's position matters, state the constraint as a fact ("wire delay is unacceptable after INC-230") and link the ticket or meeting in **References**.

## References

**Placement:** One section at the **very bottom** of the PRD, after Plan and Open Questions. Like a paper's citations — not nested under Problem, Strategy, or any other section.

**Allowed links:** Workspace URLs any teammate can open: Notion, Linear, Gong, Incident.io, Confluence, Figma, client-facing docs hosted on the web.

**Never link:**
- Local files (`briefing.md`, `decisions.md`, `sources.md`, `prd.md`)
- Repo paths (`canonical/`, `memory/`, `research-notes/`)
- Meta instructions (`memory/doc-formatting.md`, `memory/writing-style.md`, `memory/prd-writing.md`)

Research files inform the draft. The published PRD stands alone with durable workspace links pulled from `sources.md`. Ticket IDs belong as linked Linear URLs in References, not as raw IDs in body prose.

**Do not** append formatting guides, skill paths, or repo housekeeping to the PRD footer.

## How does this connect to strategy?

**Goal:** Which company or client priority this serves and **why now** in business terms.

**Include:** The honest reason this rose on the roadmap (client onboarding, incident, regulatory finding, ops load at scale). One milestone or conversion (date, volume, client) **only if** you tie it to a business consequence of hitting or missing it.

**Optional:** One small table only if it shows volume ramp tied to a real operational or client constraint (not a general data dump).

**Do not:** Repeat the full Problem narrative; list Linear milestone names as the strategy rationale; describe how engineering will build the fix; name future clients unless directly tied to a stated business constraint; name individuals or quote their positions in prose.

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

## Requirements (Proposal)

Requirements are **outcome-focused constraints** for engineering to design against. Not implementation recipes.

**Format (every requirement line):**

`[<priority>] **<requirement name>**: <requirement details>.`

Example: `[P0] **Per-loan cancel in multi-loan batch**: Operator can cancel one loan in an approved multi-loan group without eng-op when within the agreed buffer window.`

- **Priority:** `[P0]`, `[P1]`, etc. in square brackets.
- **Name:** bold, short label.
- **Separator:** colon after the name. **No em dashes** in requirement lines.
- **Details:** one testable outcome sentence; end with a period. Pass the **ops reader test**.

**Wrong vs. right**

| Wrong | Right |
| ----- | ----- |
| `[P0] **SWBC adapter**: Implement SwbcIntegration on PropertyInsuranceIntegration per ESC-4961.` | `[P0] **Daily SWBC certificate feed**: Escrow receives updated hazard insurance certificates for SWBC-serviced loans without manual file upload.` |
| `[P0] **Diff job**: Nightly cron diffs incoming feed against loan_escrow_insurance.` | `[P0] **Stale cert detection**: When carrier data changes, ops sees which loans need review before disbursement.` |

Functional and non-functional requirements share one list. No rationale paragraphs under each item. Pull technical facts from research to inform requirements; do not copy codebase vocabulary into requirement lines.

## What are we not trying to solve?

**Goal:** Scope line for this milestone.

- Opening: what delivery and by when (product terms, not ticket IDs).
- Bullets: **Topic:** what is excluded and why (timeline, other team, unverified workflow, follow-on).
- Dependencies on other teams: we depend on the answer but do not build their side.
- Typically 5–10 bullets. If unsure whether something is true, use Open Questions instead of stating it as out-of-scope fact.

## Plan and timeline

**Goal:** When we ship and what we depend on. This is where milestone dates belong.

- List dates with **business consequence** when helpful ("If X slips past Y, Carrington cutover runs dual systems through tax season").
- Do not repeat the same date list in Problem "Why it matters" or Strategy without adding new meaning.
- Risks and Open Questions stay in plain language; technical mitigation details belong in Proposal or the eng TDD.

## Anti-patterns (from review)

- **Essay Problem** — Adding a second paragraph without a separate direct harm, or covering every edge case instead of the core gap
- **Robot Problem structure** — Subheaders, numbered blocks, or bold audience labels (**Operators**, **Borrowers**) inside the Problem opening
- **References in the wrong place** — Citation lists under Problem or mid-doc instead of a single section at the bottom
- **Local or repo links in References** — `briefing.md`, `decisions.md`, `canonical/`, `memory/`, or any path only the author can open
- **Meta content in the PRD** — Footer or inline mentions of `memory/doc-formatting.md`, `memory/writing-style.md`, or other repo instruction files
- **Schedule as "why"** — Linear milestones, roadmap labels, or PRD-ready dates standing in for customer/ops/compliance pain
- **Research dump voice** — Label-heavy prose that mirrors briefing structure without distilling
- **Implementation in requirements** — Contract names, adapter types, cron families, class names, table names, or ticket IDs in requirement lines or Problem body (link tickets in References)
- Importance sentences, AI vocabulary, contrast structures, vague authority, summary endings (see `memory/writing-style.md`)
- "Milestone thesis," "gating question," "trust in the platform"
- Solutioning in Problem or Success ("ops uploads the bill," "system diffs against HUD")
- Percentage targets that ignore scale (e.g., "<10% manual edits" when 10% of 40k certs exceeds STM capacity)
- Unverified workflows stated as fact (move to Open Questions)
- Individual names in body prose (Reviewers and Owner/POC columns excepted; see **People and teams**)
- Local file paths or gitignored research paths anywhere in the published PRD (see **References**)
- Code-level measurement specs in Success metrics (function names, state enums, log fields, named dashboards; see **What does success look like?**)
- Requirement behaviors listed as metrics (messaging, observability, eng-op volume, internal SLAs; those belong in Proposal)
- Separate outcome and guardrail metric tables (use one table with a Type column)
- Analyst-style metric names that need a glossary ("eligible completion rate" without saying eligible for what)
- Stakeholder monologues ("Person A wants X, Person B blocked Y") — state the constraint, not the conversation
- `~` for approximations in Notion-bound docs (use `approx.`; tildes render as strikethrough)
- Em dashes in requirement lines (use `[P0] **Name**: details.` per **Requirements (Proposal)**)

## After drafting

Run `review-panel` or a single persona review if the doc is high-stakes. For client-facing PRDs, confirm milestone dates and loan counts against the latest spreadsheet or Slack confirmation before pushing to Notion.
