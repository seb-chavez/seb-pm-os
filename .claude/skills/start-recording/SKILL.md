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
