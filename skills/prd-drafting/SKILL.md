---
name: prd-drafting
description: Drafts Product Requirements Documents from /prd-research output using seb-pm-os templates and writing rules. Use after /prd-research when the user wants a PRD outline or full PRD, says prd-drafting, or asks to turn briefing/decisions into a Notion PRD. Does not replace research.
disable-model-invocation: true
---

# PRD Drafting

Turn **`/prd-research` output** into a PRD shaped by this repo's template and prose rules. Research teaches; the PRD commits scope and requirements.

**Upstream:** `/prd-research` (toolshed). **Not a substitute for:** `/jake-beta-prd-write` (different template and discovery flow). Use this skill when you want `templates/prds/prd.md` + `memory/prd-writing.md`.

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
6. `memory/prd-writing.md` (Problem vs Proposal rules)
7. `memory/doc-formatting.md` and `memory/writing-style.md`

Pull from `research-notes/` only for sections you are drafting; do not load the entire folder into context up front.

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

Within Problem, use the template subsections verbatim. Apply `memory/prd-writing.md` anti-patterns (no solutioning in Problem or Success metrics, no em dashes, `approx.` not `~` for Notion, no individual names in body prose).

**One-line description** at the top of the file: fill in **last**, after Problem and Proposal are stable.

### Outline mode

For each section, write tight prose (not bullet dumps of research). Include empty or placeholder tables where the template expects them. Flag 3–5 highest-risk Open Questions.

### Full PRD mode

- **Requirements:** `[P0]` / `[P1]` prefix; one sentence acceptance criterion each; functional + non-functional in one list per template.
- **References (under Problem):** For local drafts, link `briefing.md`, key tickets, and `sources.md`. For **Notion**, link only workspace URLs (Notion, Linear, Incident.io); never `canonical/` or other local paths.
- **Regulatory requirements:** cite primary sources named in `research-notes/regulatory.md`; do not invent thresholds not in research.
- **Platform / infra:** if `research-notes/codebase.md` names Workflows, Tasks, Rules, VDS, map behaviors in Proposal narrative without prescribing implementation types in every requirement (behavior first).

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

Self-check without re-researching:

| Check | Action |
|-------|--------|
| Solution language in Problem? | Move to Proposal |
| Success metrics describe builds or code? | Rewrite as outcomes; no function names, states, or dashboards in measurement column |
| Row is really a requirement (messaging, observability, eng-op volume)? | Move to Proposal requirements; keep Success table minimal |
| Separate outcome and guardrail tables? | Merge into one table with Type column (Primary, Secondary, Guardrail) |
| Metric names need a glossary? | Short name in Metric column; plain sentence in Description column |
| Local paths in Notion draft? | Replace with workspace links (Notion, Linear, Incident.io) |
| Requirement untestable? | Add measurable acceptance line |
| Claim contradicts `briefing.md`? | Fix draft or note Open Question |
| Milestone dates / loan counts | Match research or latest user correction |

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
