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

### Problem: one or two paragraphs, not an essay

The opening **Problem** section is one paragraph, two at most. It answers what is broken, who bears the cost, and why it matters — woven into normal prose.

**Do:**
- Write the way you would explain this in Slack to a cross-functional lead.
- Keep it short enough to read on a phone in 30 seconds.

**Do not:**
- Use subheaders, numbered blocks, or bold audience labels (**Operators**, **Borrowers**, **Client**) inside Problem.
- Use bullet lists to enumerate who hurts.
- Write four paragraphs covering every failure mode and edge case.
- Paste research structure (World Today → Gaps → Stakeholder Context).

| Wrong | Right |
| ----- | ----- |
| "**Operators:** manual cert chase. **Borrowers:** force-placed risk." | "Analysts spend hours chasing SWBC certificates by email, and borrowers sit exposed to unnecessary force-placed coverage." |
| 600-word essay with labeled subsections | Two tight paragraphs on the core gap (second only for a distinct risk like dual-system double pay) |

Strategy, Success, and scope stay in their template subsections below the opening Problem paragraphs. Only the opening Problem block follows the 1–2 paragraph rule.

### References: bottom of doc, workspace only

**Placement:** One `## References` section at the **very bottom** of the PRD, after Plan and Open Questions. Like paper citations — never nested under Problem, Strategy, or any other section.

**Allowed:** Workspace URLs any teammate can open: Notion, Linear, Gong, Incident.io, Confluence, Figma.

**Never include in References (or anywhere in the published PRD):**
- Local files (`briefing.md`, `decisions.md`, `sources.md`, `prd.md`)
- Repo paths (`canonical/`, `memory/`, `research-notes/`)
- Meta instructions (`memory/doc-formatting.md`, `memory/writing-style.md`, `memory/prd-writing.md`)
- Raw ticket IDs without a Linear URL

Pull links from `sources.md` during drafting. Research files inform the draft; the published doc stands alone.

**Never append** formatting guides, skill paths, or repo housekeeping to the PRD footer or body.

### Problem section: distill, don't dump

Research bundles are technical. The Problem opening **translates** them into product language.

**Do:**
- Open with the broken workflow in everyday terms (what happens today, what should happen).
- Weave who bears the cost into the prose naturally (no bold labels).
- State financial or compliance exposure in plain numbers when sourced.
- Use one or two short paragraphs total.

**Do not:**
- Paste research structure (World Today → Gaps → Stakeholder Context).
- Recite ticket IDs, contract names, adapter types, cron jobs, enum states, or class names in body prose.
- Write label-heavy robot prose ("Core workflow gap. Related failure modes. Who it hurts.").
- Use "Why it matters" as a labeled subsection or milestone list.

**Translation rule:** When `research-notes/codebase.md` or `briefing.md` names an integration pattern, contract, or ticket, ask: *What breaks for a person if we do not ship this?* Write that answer. Link the source in **References** at the bottom; keep the body human.

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

Before moving to the next section, read the draft aloud. Cut or rewrite if any line:

1. Could have been generated by reading Linear milestones alone.
2. Uses jargon that ProdOps or a client PM would not use in conversation.
3. Describes *how engineering should build* instead of *what must be true when done*.
4. Lists facts without saying why a human cares.
5. Sounds like a research summary rather than a PM making a case.
6. Problem opening is more than two paragraphs or uses bold audience labels.
7. References appear mid-doc, include local files, or cite `memory/` paths.
8. The doc footer or body mentions repo instruction files.

## When NOT to use

- No research bundle yet → run `/prd-research` first.
- User only wants to understand the problem → read `briefing.md`, do not draft.
- User wants Jake's adaptive PRD structure or interactive discovery → `/jake-beta-prd-write`.

## On invocation

1. **Research directory.** Ask once if not provided: path to the folder that contains `briefing.md` (e.g. `canonical/projects/disbursements-rejection-cutoff/`).
2. **Deliverable.** Infer from the user message:
   - **Outline** — Problem opening (1–2 paragraphs) + other Problem subsections + Proposal headings + stub tables; no full requirements list.
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

1. **Problem** (opening paragraphs + strategy/success/scope subsections) — complete before Proposal
2. **Proposal**
3. **Plan** (Open Questions last)
4. **References** (workspace URLs only; very bottom)

Within the Problem **opening**, write one or two paragraphs only — no subheaders, bold audience tags, or bullet lists. Other Problem subsections (Strategy, Success, scope) follow the template. Apply **Writing paradigm** first, then `memory/prd-writing.md` anti-patterns (no solutioning in Problem or Success metrics, no em dashes, `approx.` not `~` for Notion, no individual names in body prose).

**One-line description** at the top of the file: fill in **last**, after Problem and Proposal are stable. It should state the user/business outcome in one plain sentence, not a milestone or integration name.

### Outline mode

For each section, write tight prose a senior PM would actually ship (not bullet dumps of research). Include empty or placeholder tables where the template expects them. Flag 3–5 highest-risk Open Questions.

### Full PRD mode

- **Strip author instructions:** Delete italic template guidance (including "Author instruction (delete before share)" blocks) from the published doc. Never ship `memory/` paths or repo references.
- **Requirements:** `[P0]` / `[P1]` prefix; format `[P0] **Name**: one-sentence outcome.` Colon after name, period at end; no em dashes. **Ops reader test** on every line.
- **References:** Single section at the **bottom** of the doc. Workspace URLs only (Notion, Linear, Gong, Incident.io, Confluence, Figma). Never local files, repo paths, or `memory/` paths — including for local drafts.
- **Regulatory requirements:** cite primary sources named in `research-notes/regulatory.md` in plain compliance language; do not invent thresholds not in research.
- **Platform / infra:** absorb `research-notes/codebase.md` into behavioral requirements and brief Proposal narrative. Do not name contracts, adapters, crons, or tables unless reduced to user-visible behavior.
- **No meta footer:** Never write "Formatting: memory/..." or similar into the PRD.

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
| Problem opening > 2 paragraphs? | Cut to core gap; move edge cases to Risks or drop |
| Bold audience labels or bullet "who hurts" in Problem? | Rewrite as woven prose |
| References under Problem or mid-doc? | Move to single section at bottom |
| Local files, repo paths, or `memory/` in References or footer? | Remove; use workspace URLs from `sources.md` |
| "Formatting: memory/..." or similar in doc? | Delete entirely |
| "Why it matters" is mostly dates/milestones? | Rewrite around customer/ops/compliance pain; move dates to Plan |
| Problem reads like research or Linear export? | Distill to plain workflow + stakes in 1–2 paragraphs |
| Codebase/ticket jargon in Problem or requirements? | Translate to outcomes; link tickets in References only |
| Requirement describes implementation? | Rewrite as testable user/business outcome |
| ProdOps would ask "what does that mean?" | Simplify or cut |
| Solution language in Problem? | Move to Proposal |
| Success metrics describe builds or code? | Rewrite as outcomes; no function names, states, or dashboards in measurement column |
| Row is really a requirement (messaging, observability, eng-op volume)? | Move to Proposal requirements; keep Success table minimal |
| Separate outcome and guardrail tables? | Merge into one table with Type column (Primary, Secondary, Guardrail) |
| Metric names need a glossary? | Short name in Metric column; plain sentence in Description column |
| Local paths in Notion draft? | Replace with workspace links (Notion, Linear, Gong, Incident.io) |
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
