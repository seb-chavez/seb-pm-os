# Projects

Every task gets its own folder. One folder per active project. Move completed projects to `_archive/`.

## How it works

When you come back the next day, point Claude at the project folder:

```
@canonical/projects/board-deck-q2/ Get up to speed on this project,
then help me finish the revenue slide.
```

Claude reads every file in the folder — all the research, all the drafts, all the data. It picks up exactly where you left off.

## Suggested project structure

```
project-name/
├── brief.md          ← Project brief / charter
├── prd.md            ← Product requirements
├── status.md         ← Current status and updates
├── decisions.md      ← Decision log
├── drafts/           ← Work in progress
└── notes/            ← Working notes, scratch
```

## Tips
- Keep a `status.md` updated — it's the fastest way for Claude to know where things stand
- Use `decisions.md` to log choices and rationale so you don't re-litigate them
- When a project wraps, move the whole folder to `_archive/` for future reference
