# [Project Name] - Product Requirements Document

*One-line description of the project.*

*Fill this in last. It is the executive summary of the whole PRD. A reader should grasp the problem and the plan in under two minutes, then find requirements fast. Cut thin sections rather than padding them; link to research instead of pasting it.*

## Reviewers

*Stakeholders who must review and sign off before work begins.*


| Name       | Role         | Status   | Date       |
| ---------- | ------------ | -------- | ---------- |
| Jane Smith | Product Lead | Approved | 2026-01-15 |
|            |              |          |            |


## Problem

*Complete all four subsections below before writing Proposal. Problem states what is broken and why it matters now; it does not describe the solution. Open Questions belong at the bottom of this doc under Plan, not here.*

### What is the problem?

*Describe the broken workflow today in plain language. A reader should be able to repeat the problem and its stakes after reading this subsection alone.*

**Structure (use what fits; skip blocks that do not apply):**

1. **Core workflow gap** (2–4 sentences): What the system does today vs. what must be true. Name the authoritative source of truth (regulator, client, carrier, ledger) when relevant. Contrast with a mature analog elsewhere in the product if it clarifies the gap.

2. **Related failure modes** (0–2 short paragraphs): Separate problems that share a project but are not the same bug (e.g., dual-system double payment during a migration). State facts and risks; do not prescribe fixes.

3. **Who it hurts:** Bullet or bold labels per audience (**Operators**, **Engineering**, **Client**, **Borrowers**). One concrete example each (person, ticket, incident, review finding) beats generic pain.

4. **Why it matters:** The forcing deadline (client milestone, conversion, contract date). Today's scale vs. upcoming scale with sourced numbers. Financial or compliance exposure with citations (ticket, incident $, client quote). Distinguish near-term deadline from longer-term bar when both exist.

5. **References:** Link out to research, spreadsheets, incident tickets, and meeting notes. Do not summarize long sources inline.

**Do:**
- Write for engineers and operators, not executives. Short sentences; one idea per sentence.
- Attribute claims with dates, docs, and tickets.
- Name the **client** correctly (e.g., subservicer onboarding a portfolio vs. the portfolio seller).

**Do not:**
- Propose uploads, diffs, dashboards, or integrations here.
- Use filler framing ("gating question," "trust in the platform," "highest-volume workflow in the vertical") unless you can defend it with data.
- Dump tables or timelines that belong in Strategy unless they are essential to stating the problem.
- Name individuals in body prose or turn internal debates into narrative ("X needs Y," "X blocked Z"). State constraints as facts; use team names only when necessary. See `memory/prd-writing.md` (**People and teams**). Reviewers table and Owner/POC columns are the exceptions.

### How does this connect to our strategy & priorities?

*Answer: which company or client priority does this serve, and why is it timed to this milestone? Still no solution.*

**Include:**
- The milestone or conversion this unblocks (date, volume, client).
- Why this project is elevated vs. default priority for the team (honest reason: pipeline delivery, regulatory finding, incident, not superlatives).
- At most one small table **only if** it shows why timing is tied to volume ramp (not a general data dump).

**Do not:**
- Repeat the full Problem narrative (deadline, loan counts) if already stated above. One cross-reference is enough.
- Describe how engineering will build the fix.
- Name future clients or analyst personas unless directly tied to the deadline.
- Name individuals or their positions in prose. State organizational constraints as facts (see `memory/prd-writing.md`, **People and teams**).

*Example shape: "[Client] [Milestone] ([date]) requires [workflow] to work at [scale]; today's process does not. This is [P0/P1] because [pipeline / finding / incident], not because [workflow] is the largest area in the org."*

### What does success look like?

*Outcomes and measurable bars only. One sentence of prose, then the metrics table.*

**Opening sentence:** State when success is achieved (milestone/date) and the operational bar in outcome terms: capacity held, zero class of incident, timeliness, no duplicate payments, etc.

**Do not** describe the solution (no "ops uploads," "system diffs," "exception queue"). Those belong in Proposal.

**Metrics table:** Each row ties to a problem or risk above.


| Metric | Current Baseline | Target | Measurement Method |
| ------ | ---------------- | ------ | ------------------ |
| [Name] | [Sourced today state] | [Outcome at milestone] | [How we will measure] |


**Metric guidance:**
- Baselines need a source (ops report, ticket, dashboard, named incident).
- Prefer **absolute limits** over percentages when volume is scaling (e.g., "stay within STM capacity: &lt;N interventions per cycle" rather than "&lt;10% of certs" if 10% of a larger book still breaks ops).
- Binary outcomes are fine where appropriate (zero duplicate remits, zero edit-loss incidents).
- Readiness rows may reference test cycles and sign-off criteria before go-live.

### What are we not trying to solve?

*Draw the scope line for this milestone. Opening sentence: what delivery and by when. Then bullets.*

This project is scoped to [outcome] before **[date]**. The following are explicitly out of scope (separate tracks or later milestones):

- **[Topic]:** What is excluded and why (timeline, other team owns it, unverified workflow, follow-on after ops discovery). One to two sentences per bullet.
- **[Dependency on another team]:** We depend on the answer but do not build their side.

**Do:**
- Keep to the bullets that matter for this milestone (typically 5–10).
- Separate "we won't build post-pay recon" from "we won't automate HUD connectivity" from "we won't fix unrelated product areas."

**Do not:**
- State unverified workflows as fact (if unsure, move to Open Questions and omit from out-of-scope or soften).
- Duplicate Proposal content or re-list requirements as exclusions.

## Proposal

*Write Proposal only after Problem subsections are stable. This is where approach, flows, and requirements live.*

### How do we intend to solve this problem?

*One to three sentences: the approach, and why it beats the alternative considered (e.g., why not SFTP-first). Save detail for requirements and flows below.*

### How will our solution work?

*Link mocks or diagrams (Figma, architecture sketch). Use bullets for key flows or trade-offs, not long prose.*

### Requirements

*Each item is one testable statement. One sentence of acceptance criteria; no rationale paragraphs. Functional requirements state what the system does; non-functional requirements state measurable quality bars (performance, capacity, reliability, durability). Use one list for both.*

- [P0] **Requirement name** — Acceptance criterion
- [P1] **Requirement name** — Acceptance criterion

**Out of Scope**
*Features we are deferring within the engineering track (distinct from Problem "what we are not trying to solve").*

### What dependencies do we have on others?


| Team | Dependency | POC |
| ---- | ---------- | --- |
|      |            |     |


## Plan

*Timeline and risks may be filled as the project matures. Open Questions stay at the bottom of the doc.*

### Timeline


| Milestone | Description | Target Date | Status |
| --------- | ----------- | ----------- | ------ |
|           |             |             |        |


### Risks and Mitigations


| Risk | Likelihood | Impact | Mitigation |
| ---- | ---------- | ------ | ---------- |
|      |            |        |            |


### Open Questions

*Unresolved questions that block scope, design, or go-live. Prefer owners who can answer from ops, client, or eng. When answered, move facts into Problem or Proposal and note resolution here.*


| Question | Owner | Due Date | Resolution |
| -------- | ----- | -------- | ---------- |
|          |       |          |            |


---

*Formatting: `memory/doc-formatting.md`. Prose: `memory/writing-style.md`. Use `approx.` not `~` for estimates (Notion renders tildes as strikethrough). No em dashes as sentence connectors.*
