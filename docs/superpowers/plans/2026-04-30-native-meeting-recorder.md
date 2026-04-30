# Native Meeting Recorder Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Claude Code skills for local meeting recording, transcription, and import — a native alternative to Granola for companies that ban third-party meeting recorders.

**Architecture:** Three new skills (`/setup-recording`, `/start-recording`, `/stop-recording`) manage a pipeline of BlackHole (audio capture) → ffmpeg (recording) → whisper.cpp (transcription). The existing `/import-meeting-notes` skill gains a second source: local transcripts alongside Granola MCP. All skills are markdown instruction files — no application code.

**Tech Stack:** BlackHole 2ch, ffmpeg, whisper.cpp, Claude Code skills (SKILL.md files)

**Spec:** `docs/superpowers/specs/2026-04-30-native-meeting-recorder-design.md`

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Create | `.claude/skills/setup-recording/SKILL.md` | One-time setup guide for BlackHole, whisper.cpp, and audio routing |
| Create | `.claude/skills/start-recording/SKILL.md` | Start ffmpeg background recording from BlackHole device |
| Create | `.claude/skills/stop-recording/SKILL.md` | Stop recording, run whisper.cpp, report results |
| Modify | `.claude/skills/import-meeting-notes/SKILL.md` | Add local transcript source alongside Granola MCP |
| Modify | `.gitignore` | Add data/recordings/, data/transcripts/, data/models/ |

---

### Task 1: Update .gitignore for recording data

**Files:**
- Modify: `.gitignore:4-9`

- [ ] **Step 1: Add recording data directories to .gitignore**

Add gitignore entries for the three new data subdirectories. These hold audio files, transcripts, and Whisper model binaries — all local-only, never committed.

In `.gitignore`, after the existing `!data/README.md` line, add:

```
# Native meeting recorder data
data/models/
data/recordings/
data/transcripts/
```

The full `data` section of `.gitignore` should now read:

```
# Sensitive data files (CSVs, notebooks may contain proprietary data)
data/*.csv
data/*.xlsx
data/*.ipynb
data/*.json
!data/README.md

# Native meeting recorder data
data/models/
data/recordings/
data/transcripts/
```

- [ ] **Step 2: Commit**

```bash
git add .gitignore
git commit -m "chore: gitignore recording data directories"
```

---

### Task 2: Create `/setup-recording` skill

**Files:**
- Create: `.claude/skills/setup-recording/SKILL.md`

- [ ] **Step 1: Create the skill directory**

```bash
mkdir -p .claude/skills/setup-recording
```

- [ ] **Step 2: Write SKILL.md**

Create `.claude/skills/setup-recording/SKILL.md` with the following content:

```markdown
---
name: setup-recording
description: Use when setting up local meeting recording for the first time. Triggers on "setup recording", "configure recording", "install blackhole", "install whisper", or any request to set up the native meeting recorder.
---

# Setup Recording

## Overview

One-time setup for the native meeting recording pipeline. Checks prerequisites (BlackHole, whisper.cpp, Whisper model), guides audio routing configuration, and verifies the setup works end-to-end.

## When NOT to use

- The user wants to start or stop a recording (use `/start-recording` or `/stop-recording`)
- The user wants to import meeting notes (use `/import-meeting-notes`)
- Prerequisites are already installed and configured

## Steps

1. **Check BlackHole installation**

   Run `brew list blackhole-2ch` via Bash. If it's not installed, tell the user:

   > BlackHole is not installed. Install it with:
   > ```
   > brew install blackhole-2ch
   > ```
   > After installation, you may need to approve the system extension in **System Settings → Privacy & Security**. Then re-run `/setup-recording`.

   Stop here if not installed — the remaining steps depend on BlackHole.

2. **Check whisper.cpp installation**

   Run `which whisper-cpp` via Bash. If not found, try `which whisper` as an alternative. If neither exists, tell the user:

   > whisper.cpp is not installed. Install it with:
   > ```
   > brew install whisper-cpp
   > ```
   > Then re-run `/setup-recording`.

   Stop here if not installed.

3. **Check for Whisper model**

   Use Glob to check if any `.bin` file exists in `data/models/`. If not, tell the user:

   > No Whisper model found. Download the base English model:
   > ```
   > mkdir -p data/models
   > curl -L -o data/models/ggml-base.en.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin
   > ```
   > This is a ~150 MB download. For better accuracy (but slower), use `ggml-medium.en.bin` instead (~1.5 GB).

   Stop here if no model is available.

4. **Guide multi-output device configuration**

   Tell the user:

   > All prerequisites are installed. Now configure audio routing:
   >
   > 1. Open **Audio MIDI Setup** (search in Spotlight or find in `/Applications/Utilities/`)
   > 2. Click the **+** button in the bottom-left corner
   > 3. Select **Create Multi-Output Device**
   > 4. Check both your normal output (e.g., "MacBook Pro Speakers" or your headphones) AND **"BlackHole 2ch"**
   > 5. Make sure your normal output is listed **first** (drag to reorder if needed)
   > 6. Right-click the new Multi-Output Device and select **"Use This Device For Sound Output"**
   >
   > This routes all system audio to both your speakers/headphones AND BlackHole simultaneously. You hear everything normally, and BlackHole makes it recordable.

5. **Verify with a test recording**

   Run a 5-second test recording via Bash:

   ```
   mkdir -p data/recordings
   ffmpeg -f avfoundation -i ":BlackHole 2ch" -ac 1 -ar 16000 -acodec pcm_s16le -t 5 data/recordings/test.wav -y
   ```

   If this succeeds, tell the user:

   > Test recording captured successfully. Play some audio during the next test to verify content.

   If it fails with a device error, the multi-output device may not be configured correctly. Guide the user to check Audio MIDI Setup.

   Clean up the test file afterward:

   ```
   rm -f data/recordings/test.wav
   ```

6. **Report setup status**

   Summarize what's installed and configured:
   - BlackHole: ✓ installed
   - whisper.cpp: ✓ installed
   - Whisper model: ✓ (model name and location)
   - Multi-output device: ✓ verified (or needs manual check)
   - Ready to use `/start-recording` and `/stop-recording`

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Forgetting to approve BlackHole system extension | Check System Settings → Privacy & Security after install |
| Not setting multi-output as default output | Right-click the device in Audio MIDI Setup → "Use This Device For Sound Output" |
| Downloading wrong Whisper model | Use `.en` models for English-only (faster). Use non-`.en` for multilingual. |
| Running setup while audio is playing | Close media apps first to avoid audio interruption during device switch |
```

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/setup-recording/SKILL.md
git commit -m "feat: add /setup-recording skill for native recorder prerequisites"
```

---

### Task 3: Create `/start-recording` skill

**Files:**
- Create: `.claude/skills/start-recording/SKILL.md`

- [ ] **Step 1: Create the skill directory**

```bash
mkdir -p .claude/skills/start-recording
```

- [ ] **Step 2: Write SKILL.md**

Create `.claude/skills/start-recording/SKILL.md` with the following content:

```markdown
---
name: start-recording
description: Use when the user wants to start recording a meeting. Triggers on "start recording", "record this meeting", "record my meeting", "begin recording", or any request to capture meeting audio.
---

# Start Recording

## Overview

Starts capturing system audio via BlackHole and ffmpeg as a background process. The recording runs silently — no meeting bot, no one knows it's happening. Run this before a meeting starts.

## When NOT to use

- A recording is already active (check for `data/recordings/.active` first)
- The user hasn't run `/setup-recording` yet (BlackHole/whisper.cpp not installed)
- The user wants to stop a recording (use `/stop-recording`)

## Prerequisites

BlackHole, whisper.cpp, and a Whisper model must be installed. If any are missing, tell the user to run `/setup-recording` first.

## Steps

1. **Check for active recording**

   Use Glob to check if `data/recordings/.active` exists. If it does, read it and tell the user:

   > A recording is already active (started at [started_at]). Run `/stop-recording` first, or manually delete `data/recordings/.active` if the previous recording was interrupted.

   Stop here if active.

2. **Ensure data directories exist**

   Run via Bash:

   ```
   mkdir -p data/recordings data/transcripts
   ```

3. **Start ffmpeg recording**

   Generate a filename from the current timestamp. Run via Bash with `run_in_background: true`:

   ```
   ffmpeg -f avfoundation -i ":BlackHole 2ch" -ac 1 -ar 16000 -acodec pcm_s16le data/recordings/YYYY-MM-DD-HH-MM.wav
   ```

   Replace `YYYY-MM-DD-HH-MM` with the actual current timestamp (e.g., `2026-04-30-14-00`).

   Note the background task ID returned — you'll need the PID.

4. **Write the .active state file**

   Write `data/recordings/.active` as JSON:

   ```json
   {
     "pid": <PID from background task>,
     "started_at": "YYYY-MM-DDTHH:MM:SS",
     "audio_file": "data/recordings/YYYY-MM-DD-HH-MM.wav"
   }
   ```

   Use the actual PID from the background ffmpeg process and the current ISO 8601 timestamp.

5. **Confirm to user**

   > Recording started. Audio is being captured from BlackHole to `data/recordings/YYYY-MM-DD-HH-MM.wav`.
   >
   > Run `/stop-recording` when your meeting is done.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Starting a second recording while one is active | Always check `.active` file first |
| Wrong audio device name | The device is `:BlackHole 2ch` (with the colon prefix for audio-only in avfoundation) |
| Not using run_in_background for ffmpeg | ffmpeg must run as a background process — it records until explicitly stopped |
| Forgetting to write .active file | Without it, `/stop-recording` can't find the process |
```

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/start-recording/SKILL.md
git commit -m "feat: add /start-recording skill for meeting audio capture"
```

---

### Task 4: Create `/stop-recording` skill

**Files:**
- Create: `.claude/skills/stop-recording/SKILL.md`

- [ ] **Step 1: Create the skill directory**

```bash
mkdir -p .claude/skills/stop-recording
```

- [ ] **Step 2: Write SKILL.md**

Create `.claude/skills/stop-recording/SKILL.md` with the following content:

```markdown
---
name: stop-recording
description: Use when the user wants to stop a meeting recording and transcribe it. Triggers on "stop recording", "end recording", "finish recording", "done recording", or any request to stop capturing audio.
---

# Stop Recording

## Overview

Stops the active ffmpeg recording, runs whisper.cpp to transcribe the audio locally, and reports results. After this, the user can run `/import-meeting-notes` to synthesize and route the transcript into the knowledge base.

## When NOT to use

- No recording is active (no `data/recordings/.active` file)
- The user wants to start a recording (use `/start-recording`)
- The user wants to import/synthesize notes (use `/import-meeting-notes`)

## Steps

1. **Check for active recording**

   Use Glob to check if `data/recordings/.active` exists. If it does NOT exist, tell the user:

   > No active recording found. Nothing to stop.

   Stop here if no active recording.

2. **Read the state file**

   Read `data/recordings/.active` to get the PID, start time, and audio file path.

3. **Stop the ffmpeg process**

   Send SIGINT for a clean shutdown. Run via Bash:

   ```
   kill -INT <PID>
   ```

   Wait a moment, then verify the process has stopped:

   ```
   kill -0 <PID> 2>/dev/null
   ```

   If it's still running, send SIGTERM:

   ```
   kill -TERM <PID>
   ```

4. **Verify the audio file**

   Check that the audio file exists and has a non-zero size. Run via Bash:

   ```
   ls -lh <audio_file_path>
   ```

   If the file doesn't exist or is empty, tell the user the recording may have failed and stop here.

5. **Transcribe with whisper.cpp**

   Find the whisper binary (`whisper-cpp` or `whisper`) and the model file. Run via Bash:

   ```
   whisper-cpp -m data/models/ggml-base.en.bin -f <audio_file_path> -otxt -of data/transcripts/YYYY-MM-DD-HH-MM
   ```

   Use the same timestamp stem as the audio file (e.g., if audio is `2026-04-30-14-00.wav`, output to `data/transcripts/2026-04-30-14-00`). whisper.cpp will append `.txt` automatically.

   This may take 1-2 minutes for a 30-minute recording on an M1+ Mac.

6. **Delete the .active state file**

   Run via Bash:

   ```
   rm data/recordings/.active
   ```

7. **Report results**

   Read the transcript file to get a word count. Calculate recording duration from the start time in the state file to now. Tell the user:

   > Recording stopped.
   > - **Duration:** [X] minutes
   > - **Audio:** `data/recordings/YYYY-MM-DD-HH-MM.wav` ([size])
   > - **Transcript:** `data/transcripts/YYYY-MM-DD-HH-MM.txt` ([word count] words)
   >
   > Run `/import-meeting-notes` to synthesize and route the transcript to your knowledge base.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Not checking for .active file | Always verify a recording is active before trying to stop |
| Using SIGKILL instead of SIGINT | SIGINT lets ffmpeg finalize the WAV header. SIGKILL may corrupt the file. |
| Wrong model path | Check `data/models/` for available `.bin` files |
| Deleting .active before transcription completes | Only delete after whisper.cpp finishes successfully |
```

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/stop-recording/SKILL.md
git commit -m "feat: add /stop-recording skill for transcription pipeline"
```

---

### Task 5: Modify `/import-meeting-notes` to support local transcripts

**Files:**
- Modify: `.claude/skills/import-meeting-notes/SKILL.md`

- [ ] **Step 1: Update the skill description frontmatter**

In `.claude/skills/import-meeting-notes/SKILL.md`, change the frontmatter `description` from:

```
description: Use when the user wants to import, pull, or review meeting notes from Granola. Triggers on phrases like "import meeting notes", "check my recent meetings", "pull notes from my sync", or any request involving Granola meetings.
```

to:

```
description: Use when the user wants to import, pull, or review meeting notes from Granola or local recordings. Triggers on phrases like "import meeting notes", "check my recent meetings", "pull notes from my sync", "import transcript", or any request involving meeting notes from Granola or local recordings.
```

- [ ] **Step 2: Update the Overview section**

Change the Overview from:

```
Pulls recent Granola meetings via MCP, synthesizes key details, and routes them to the appropriate knowledge folders. The goal is structured context, not raw transcripts.
```

to:

```
Pulls meeting content from available sources (Granola MCP or local transcripts from `/stop-recording`), synthesizes key details, and routes them to the appropriate knowledge folders. The goal is structured context, not raw transcripts.
```

- [ ] **Step 3: Update the "When NOT to use" section**

Change:

```
- Notes aren't from Granola (e.g., pasting from another tool)
```

to:

```
- Notes aren't from Granola or a local recording (e.g., pasting from another tool)
```

- [ ] **Step 4: Add a Sources section before the Steps section**

Insert the following after the "When NOT to use" section and before the "Routing" section:

```markdown
## Sources

This skill supports two meeting data sources. Check both on every invocation.

| Source | How to check | What you get |
|--------|-------------|--------------|
| **Granola MCP** | Call the Granola MCP tool to list recent meetings. If the MCP server is not configured or returns an error, Granola is unavailable. | Meeting summaries with attendees, dates, and AI-generated notes |
| **Local transcripts** | Use Glob to check for `.txt` files in `data/transcripts/`. | Raw whisper.cpp transcripts from `/start-recording` + `/stop-recording` |

**Source priority:**
1. If both sources have content, show both and let the user pick
2. If only Granola is available, use Granola (current behavior)
3. If only local transcripts are available, use local transcripts
4. If neither has content, tell the user: "No meeting data found. Use Granola or run `/start-recording` before your next meeting."
```

- [ ] **Step 5: Update Step 1 in the Steps section**

Change:

```
1. Pull recent meetings via Granola MCP
```

to:

```
1. **Check available sources.** Try Granola MCP first (call the Granola tool to list recent meetings). Then check for local transcripts in `data/transcripts/` using Glob. Present all available meetings from both sources to the user, noting which source each came from.
```

- [ ] **Step 6: Add cleanup step after Step 6**

After the existing step 6 ("Confirm the routing and content with the user before writing anything"), add:

```
7. **Clean up local source files (if applicable).** If the imported meeting came from a local transcript, ask the user whether to delete the source files (the `.wav` in `data/recordings/` and `.txt` in `data/transcripts/`). Delete if confirmed.
```

- [ ] **Step 7: Add a row to the Common Mistakes table**

Add this row to the Common Mistakes table:

```
| Ignoring local transcripts when Granola is available | Always check both sources — the user may have used local recording for a meeting Granola didn't capture |
```

- [ ] **Step 8: Commit**

```bash
git add .claude/skills/import-meeting-notes/SKILL.md
git commit -m "feat: add local transcript support to /import-meeting-notes"
```

---

### Task 6: End-to-end verification

This task verifies the complete pipeline works by running each skill in sequence.

- [ ] **Step 1: Run `/setup-recording`**

Invoke the setup skill and verify it checks for BlackHole, whisper.cpp, and the Whisper model. Confirm it provides the Audio MIDI Setup instructions.

- [ ] **Step 2: Run `/start-recording`**

Invoke the start skill. Verify:
- It creates `data/recordings/.active` with valid JSON (pid, started_at, audio_file)
- An ffmpeg process is running in the background
- The audio file path exists

- [ ] **Step 3: Wait ~10 seconds, then run `/stop-recording`**

Invoke the stop skill. Verify:
- ffmpeg process is stopped
- Audio file has non-zero size
- whisper.cpp produces a transcript in `data/transcripts/`
- `.active` file is deleted
- Results are reported (duration, file size, word count)

- [ ] **Step 4: Run `/import-meeting-notes`**

Invoke the import skill. Verify:
- It detects the local transcript in `data/transcripts/`
- It lists the transcript as an available source
- It synthesizes the content (even if it's just silence/noise from a test recording)
- It proposes routing destinations
- Cleanup is offered for source files

- [ ] **Step 5: Verify clean git status**

All files were committed in Tasks 1-5. Run `git status` to confirm a clean working tree. If verification revealed any fixes, commit them individually with descriptive messages.
