# [Project Name] - Product Requirements Document

*One-line description of the project.*

*Fill this in last. One plain sentence on the user/business outcome. Delete all italic author instructions before sharing the doc.*

## Reviewers

*Stakeholders who must review and sign off before work begins.*


| Name       | Role         | Status   | Date       |
| ---------- | ------------ | -------- | ---------- |
| Jane Smith | Product Lead | Approved | 2026-01-15 |
|            |              |          |            |


## Problem

*Author instruction (delete before share): One paragraph by default, 2 to 4 sentences. State the gap and direct consequence once, then stop. A second paragraph requires a separate current harm from this exact workflow. Route mappings, ownership decisions, analog metrics, status updates, and milestone timing elsewhere. No subheaders, bold audience labels, bullet lists, or solution.*

*Author instruction (delete before share): Complete the subsections below before writing Proposal.*

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
- Name individuals or their positions in prose. State organizational constraints as facts.

*Example shape: "[Client] [Milestone] ([date]) requires [workflow] to work at [scale]; today's process does not. This is [P0/P1] because [pipeline / finding / incident], not because [workflow] is the largest area in the org."*

### What does success look like?

*Outcomes and measurable bars only. One sentence of prose, then one metrics table. Keep the table small: only what proves this build succeeded.*

**Opening sentence:** State when success is achieved (milestone/date) and the operational bar in outcome terms: capacity held, zero class of incident, timeliness, no duplicate payments, etc.

**Do not** describe the solution (no "ops uploads," "system diffs," "exception queue"). Those belong in Proposal. **Do not** list requirement behaviors as metrics (messaging copy, observability, eng-op ticket volume, internal processing SLAs). Those belong in Requirements.

**Metrics table:** One table with a **Type** column (Primary, Secondary, Guardrail). Primary = main scorecard (usually one row). Secondary = supporting bet validation (0–2 rows). Guardrail = non-negotiable risk; ship blocked if breached.

Columns: **Type** | **Metric** (short name) | **Description** (one sentence a tired reader needs) | Baseline | Target | How we measure. **5am test:** Description must stand alone.


| Type | Metric | Description | Current Baseline | Target | How we measure |
| ---- | ------ | ----------- | ---------------- | ------ | -------------- |
| Primary | [Short name] | [What we are proving succeeded] | [Sourced today state] | [Outcome at milestone] | [What to count or compare] |
| Guardrail | [Short name] | [Downside risk we will not accept] | [Sourced today state] | [Limit] | [What to count or compare] |


**Metric guidance:**
- Baselines need a source (ops report, ticket, dashboard, named incident).
- Prefer **absolute limits** over percentages when volume is scaling (e.g., "stay within STM capacity: &lt;N interventions per cycle" rather than "&lt;10% of certs" if 10% of a larger book still breaks ops).
- Binary outcomes are fine where appropriate (zero duplicate remits, zero edit-loss incidents).
- **Measurement method:** describe the outcome in operator or business terms. Engineering picks instrumentation during design. Do not name functions, enum states, log fields, or specific dashboards here (that is TDD territory).

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

*Each item is one testable statement. Functional and non-functional requirements share one list.*

**Format:** `[<priority>] **<requirement name>**: <requirement details>.`

- Use a **colon** after the bold name, not an em dash. End each line with a period.
- One sentence of acceptance criteria per item; no rationale paragraphs.

- [P0] **Requirement name**: Acceptance criterion in one sentence.
- [P1] **Requirement name**: Acceptance criterion in one sentence.

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


## References

*Author instruction (delete before share): Workspace URLs only at the bottom of the doc. Notion, Linear, Gong, Incident.io, Confluence, Figma. Never local files or repo paths.*

- [Source title](https://...)
