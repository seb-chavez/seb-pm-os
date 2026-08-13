---
name: prd-drafting
description: Drafts Product Requirements Documents from /prd-research output using seb-pm-os templates and writing rules. Use after /prd-research when the user wants a PRD outline or full PRD, says prd-drafting, or asks to turn briefing/decisions into a Notion PRD. Does not replace research.
disable-model-invocation: true
---

# PRD Drafting

Turn **`/prd-research` output** into a PRD shaped by this repo's template and prose rules. Research teaches; the PRD commits scope and requirements.

**Upstream:** `/prd-research` (toolshed). **Not a substitute for:** `/jake-beta-prd-write` (different template and discovery flow). Use this skill when you want `templates/prds/prd.md` + `memory/prd-writing.md`.

## Writing paradigm (overrides all other guidance)

**This section wins over `memory/prd-writing.md`, `memory/writing-style.md`, and raw research notes when they conflict.** The PRD is a product document for mixed audiences (PM, ops, eng leads, client stakeholders). It is not a technical design doc, architecture note, or project tracker export.

### Voice

Write like a seasoned senior PM who can explain a messy domain to a smart non-engineer in five minutes. Plain sentences. Concrete examples. Distill complexity; do not reproduce it.

- **Problem:** human pain and business stakes. A reader who never opens Linear should understand what is broken and why we care.
- **Proposal:** what we will deliver and how users/systems behave after. Light technical context only when it clarifies scope boundaries.
- **Requirements:** outcomes and constraints engineering can design against. Not implementation recipes.

### Ground the "why" in pain, not schedules

Deadlines, Linear milestones, and roadmap labels are **planning context**. They are not the problem.

| Wrong (schedule as "why") | Right (pain as "why") |
| ------------------------- | --------------------- |
| "Why it matters: PRD Ready 2026-09-25, tech scoping 2026-10-30, launch 2027-04-01. Carrington go-live Q1 2027. SWBC is Q4 2026 must-have." | "Why it matters: Without carrier insurance data on these loans, escrow analysts manually chase certificates and miss force-placed coverage windows. Carrington onboarding adds ~40k loans where this gap becomes daily ops load. SWBC is the first carrier where we have no automated feed at all." |
| "Engineering target 2026-12-18 per Linear." | "If we miss December, Carrington cutover slips and ops runs dual systems through tax season." (one sentence, tied to consequence) |

Put milestone dates in **Plan → Timeline** or a single Strategy sentence that names the **business consequence** of missing the date. Never list milestone names or dates as the Problem "why."

### Problem section: distill, don't dump

Research bundles are technical. The Problem section **translates** them into product language.

**Do:**
- Open with the broken workflow in everyday terms (what happens today, what should happen).
- Name who hurts with one concrete example each (borrowers, ops, client, compliance).
- State financial or compliance exposure in plain numbers when sourced ("$X in misapplied premiums last quarter," not "reconciliation drift").
- Use short paragraphs a VP could skim on a phone.

**Do not:**
- Paste research structure (World Today → Gaps → Stakeholder Context).
- Recite ticket IDs, contract names, adapter types, cron jobs, enum states, or class names in body prose.
- Write label-heavy robot prose ("Core workflow gap. Related failure modes. Who it hurts.") without filling each with real meaning.
- Use "Why it matters" to summarize project management metadata.

**Translation rule:** When `research-notes/codebase.md` or `briefing.md` names an integration pattern, contract, or ticket, ask: *What breaks for a person if we do not ship this?* Write that answer. Link the ticket in References; keep the body human.

### Technical language: where it belongs

| Section | Technical depth |
| ------- | ---------------- |
| Problem (all subsections) | **None.** Business and operator language only. |
| Success metrics | **None.** Count outcomes in operator or business terms. |
| Strategy | Milestone + **why that milestone exists for the business** (one short paragraph max). |
| Proposal narrative | **Sparing.** Name systems or vendors only when the reader needs them to understand scope ("receive daily files from SWBC"). |
| Requirements | **Outcome-focused.** What must be true for users and the business. Engineering chooses how. |
| Plan / Dependencies | Names of teams, vendors, external systems OK when the dependency is the point. |

**Never in requirements or Problem prose:**
- "Implementation sits on the generic X contract (ESC-####) as a Y adapter, not a forked Z cron family."
- "Uses the PropertyInsuranceIntegration interface."
- "Cron family," "adapter," "enum," "state machine," "VDS table," unless reduced to behavior ("system ingests carrier files daily").

Engineering writes the TDD with implementation vocabulary. The PRD gives them constraints and acceptance outcomes.

### Requirements are outcomes, not design

Format stays `[P0] **Name**: one testable outcome sentence.`

Each requirement should pass the **ops reader test:** Could Escrow ProdOps read this line and know whether the shipped product meets the bar, without knowing our codebase?

| Wrong | Right |
| ----- | ----- |
| `[P0] **SWBC adapter**: Implement SwbcIntegration on PropertyInsuranceIntegration per ESC-4961.` | `[P0] **Daily SWBC certificate feed**: Escrow receives updated hazard insurance certificates for SWBC-serviced loans without manual file upload.` |
| `[P0] **Diff job**: Nightly cron diffs incoming feed against loan_escrow_insurance.` | `[P0] **Stale cert detection**: When carrier data changes, ops sees which loans need review before disbursement.` |

Pull technical facts from research to **inform** requirements; do not **copy** them into requirement lines.

### Anti-slop checklist (apply while drafting, not only at end)

Before moving to the next subsection, read the draft aloud. Cut or rewrite if any line:

1. Could have been generated by reading Linear milestones alone.
2. Uses jargon that ProdOps or a client PM would not use in conversation.
3. Describes *how engineering should build* instead of *what must be true when done*.
4. Lists facts without saying why a human cares.
5. Sounds like a research summary rather than a PM making a case.

## When NOT to use

- No research bundle yet → run `/prd-research` first.
- User only wants to understand the problem → read `briefing.md`, do not draft.
- User wants Jake's adaptive PRD structure or interactive discovery → `/jake-beta-prd-write`.

## On invocation

1. **Research directory.** Ask once if not provided: path to the folder that contains `briefing.md` (e.g. `canonical/projects/disbursements-rejection-cutoff/`).
2. **Deliverable.** Infer from the user message:
   - **Outline** — Problem four subsections + Proposal headings + stub tables; no full requirements list.
   - **Full PRD** — all template sections with substantive content.
   - **Update** — path to existing `prd*.md` or Notion URL; merge new decisions, do not rewrite from scratch unless asked.
3. **Doc count.** If `decisions.md` or the user describes P0/P1 (or multiple milestones), confirm one PRD per doc before drafting Proposal.

Do not re-run `/prd-research` or launch parallel Slack/Notion/Linear discovery agents. Targeted lookup is allowed only when a specific fact is missing from the bundle (search `research-notes/` first, then one narrow Slack/Linear/Notion query).

## Mandatory reads (before writing)

Read in order:

1. `{research_dir}/briefing.md`
2. `{research_dir}/decisions.md`
3. `{research_dir}/sources.md`
4. [references/research-to-prd.md](references/research-to-prd.md)
5. `templates/prds/prd.md` (structure)
6. `memory/prd-writing.md` (Problem vs Proposal rules; **subordinate to Writing paradigm above**)
7. `memory/doc-formatting.md` and `memory/writing-style.md`

Pull from `research-notes/` only for sections you are drafting; do not load the entire folder into context up front. When reading technical notes, **translate to product language before writing**; never paste or paraphrase codebase vocabulary into Problem.

## Gate: decisions before Proposal

Read `decisions.md`. For each open architectural or scope decision that Proposal would assume:

- If the user already stated a choice in this conversation, record it in the draft (and optionally append a one-line resolution to `decisions.md` if they ask to update research files).
- If still open and Proposal cannot proceed without a pick, list the decision IDs/questions and **stop after Problem** (outline or full Problem only).
- If open but deferrable, put in **Plan → Open Questions** with owner; do not silently assume in requirements.

## Drafting order

Follow `memory/prd-writing.md` section order strictly:

1. **Problem** (complete all four subsections before any Proposal text)
2. **Proposal**
3. **Plan** (Open Questions last)

Within Problem, use the template subsections verbatim. Apply **Writing paradigm** first, then `memory/prd-writing.md` anti-patterns (no solutioning in Problem or Success metrics, no em dashes, `approx.` not `~` for Notion, no individual names in body prose).

**One-line description** at the top of the file: fill in **last**, after Problem and Proposal are stable. It should state the user/business outcome in one plain sentence, not a milestone or integration name.

### Outline mode

For each section, write tight prose a senior PM would actually ship (not bullet dumps of research). Include empty or placeholder tables where the template expects them. Flag 3–5 highest-risk Open Questions.

### Full PRD mode

- **Requirements:** `[P0]` / `[P1]` prefix; format `[P0] **Name**: one-sentence outcome.` Colon after name, period at end; no em dashes. **Ops reader test** on every line.
- **References (under Problem):** For local drafts, link `briefing.md`, key tickets, and `sources.md`. For **Notion**, link only workspace URLs (Notion, Linear, Incident.io); never `canonical/` or other local paths. Tickets and architecture docs live here, not in body prose.
- **Regulatory requirements:** cite primary sources named in `research-notes/regulatory.md` in plain compliance language; do not invent thresholds not in research.
- **Platform / infra:** absorb `research-notes/codebase.md` into behavioral requirements and brief Proposal narrative. Do not name contracts, adapters, crons, or tables unless reduced to user-visible behavior.

### Local output paths

Default next to research:

- Single: `{research_dir}/prd.md`
- Split: `{research_dir}/prd-<slug>.md` (slug from user or P0/P1 labels)

User may override path. Do not write under `front-porch/` unless they ask.

## Notion (default for full PRDs)

Per `AGENTS.md` document defaults:

1. Show one-line confirmation: title, Document Type `["PRD"]`, Group Tag Escrow, Status `Draft`, parent Documents data source.
2. Wait for user confirm unless they said "draft local only" or "no Notion."
3. `notion-create-pages` with `parent.type = "data_source_id"` and Documents data source `collection://28e2df0f-f7ba-80ea-8f77-000b22c3b280`.
4. Return the Notion URL.

**Updating an existing Notion PRD:** `notion-fetch` with `include_discussions: true`; prefer `update_content` over `replace_content`; preserve comment threads.

## Quality pass (before handoff)

Self-check without re-researching. **Writing paradigm checks first:**

| Check | Action |
|-------|--------|
| "Why it matters" is mostly dates/milestones? | Rewrite around customer/ops/compliance pain; move dates to Plan |
| Problem reads like research or Linear export? | Distill to plain workflow + who hurts + stakes |
| Codebase/ticket jargon in Problem or requirements? | Translate to outcomes; link tickets in References only |
| Requirement describes implementation? | Rewrite as testable user/business outcome |
| ProdOps would ask "what does that mean?" | Simplify or cut |
| Solution language in Problem? | Move to Proposal |
| Success metrics describe builds or code? | Rewrite as outcomes; no function names, states, or dashboards in measurement column |
| Row is really a requirement (messaging, observability, eng-op volume)? | Move to Proposal requirements; keep Success table minimal |
| Separate outcome and guardrail tables? | Merge into one table with Type column (Primary, Secondary, Guardrail) |
| Metric names need a glossary? | Short name in Metric column; plain sentence in Description column |
| Local paths in Notion draft? | Replace with workspace links (Notion, Linear, Incident.io) |
| Requirement untestable? | Add measurable acceptance line in business terms |
| Claim contradicts `briefing.md`? | Fix draft or note Open Question |
| Milestone dates / loan counts | Match research or latest user correction; keep in Plan unless tied to business consequence in Strategy |

**High-stakes** (client-facing, compliance, money movement): offer `/review-panel` on the local `prd.md` before Notion push.

Optional: if Codex CLI is installed, run a read-only pass on the draft + `briefing.md` for internal contradictions (same bar as research QC, lighter scope).

## Examples

```
/prd-drafting canonical/projects/disbursements-rejection-cutoff — outline for P0 only
```

```
/prd-drafting ~/Desktop/foo-research full PRD, local only
```

```
/prd-drafting canonical/projects/disbursements-rejection-cutoff update prd-p0.md after we chose D1 option B
```

## Related

| Skill | Relationship |
|-------|----------------|
| `/prd-research` | Required upstream; produces `briefing.md`, `decisions.md`, `research-notes/` |
| `/review-panel` | Optional pre-share review |
| `/jake-beta-prd-write` | Alternate PRD system; do not mix templates in one doc |

After adding this skill to the repo, run `./setup.sh cursor` (or your harness) so `/prd-drafting` is on the skills path.
