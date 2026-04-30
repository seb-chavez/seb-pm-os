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
