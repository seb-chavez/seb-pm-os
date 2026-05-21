# Teams

Context on internal teams — both your own team and the teams you depend on or that depend on you. This is the "who does what and how do they think" layer of the org.

## Layout

- `<team>.md` (flat file) — default for teams you have light context on
- `<team>/` (folder) — use when you have multiple files for a single team (your own team, typically)
  - `team.md` — mission, success metrics, customers, scope, values, dependencies, current state
  - `glossary.md` — domain terms, file formats, processes that recur in conversation
  - `resources.md` — links collection (Notion, Figma, Drive, sheets, slides, email aliases)
  - additional files as needed (e.g. per-vertical deep dives)

## Examples

- `escrow/` — current team folder (see `escrow/team.md` as the entry point)
- `platform.md`, `orchestration.md` — partner teams; single file each

## Tips

- Update after re-orgs, leadership changes, or scope shifts
- Capture the *unwritten* parts — operating norms, decision styles, current pain points — not just what's in the org chart
- For your own team, the `team.md` is the doc you'd hand a new PM joining to ramp on team identity
