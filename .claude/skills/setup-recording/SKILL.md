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
