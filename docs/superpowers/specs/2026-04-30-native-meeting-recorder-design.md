# Native Meeting Recorder — Design Spec

**Date:** 2026-04-30
**Status:** Draft

## Problem

Granola and similar SaaS meeting recorders may not be allowed at some companies. The PM OS needs a native, local alternative that replicates the core value: invisible background audio capture during meetings, followed by AI-powered synthesis into the existing knowledge base.

## Constraints

- **Environment:** Dev-friendly macOS with Homebrew access, M1+ Apple Silicon
- **Meeting platform:** Google Meet (browser-based)
- **No SaaS recorders:** Granola, Otter.ai, Fireflies, etc. are banned
- **Local tooling allowed:** CLI tools, open-source software, local models
- **Transcription:** Fully local via whisper.cpp (no audio leaves the machine)
- **Synthesis:** Claude (via Claude Code) — same as current workflow

## Architecture

### Pipeline

```
Google Meet (browser)
    ↓ system audio
BlackHole (virtual audio driver)
    ↓ audio loopback
ffmpeg (background process)
    ↓ WAV file
whisper.cpp (local transcription)
    ↓ text transcript
Claude Code (/import-meeting-notes)
    ↓ synthesis + routing
Knowledge base (people, projects, research, company)
```

### Components

| Component | Tool | Purpose |
|-----------|------|---------|
| Audio routing | BlackHole 2ch | Virtual audio driver — mirrors system audio to a recordable device |
| Recording | ffmpeg | Captures audio from BlackHole device as a background process |
| Transcription | whisper.cpp | Local speech-to-text on Apple Silicon |
| Synthesis | Claude Code | Extracts decisions, action items, context from transcript |
| Routing | /import-meeting-notes | Routes synthesized content to knowledge base destinations |

### Data directories

All gitignored. Live under `data/`:

```
data/
  models/             # Whisper model files
    ggml-base.en.bin
  recordings/         # Raw .wav audio files
    .active           # JSON state file for current recording (PID, start time, path)
    2026-04-30-14-00.wav
  transcripts/        # whisper.cpp output
    2026-04-30-14-00.txt
```

## Skills

### `/setup-recording` (one-time)

Guides first-time setup of the native recording pipeline.

**Behavior:**
1. Check if BlackHole is installed (`brew list blackhole-2ch`). If not, instruct user to install.
2. Check if whisper.cpp is installed (`which whisper-cpp`). If not, instruct user to install.
3. Check if a Whisper model is downloaded. If not, download `ggml-base.en.bin` to `data/models/` (gitignored).
4. Guide user through macOS Audio MIDI Setup to create a multi-output device (speakers/headphones + BlackHole).
5. Verify the setup by doing a short test recording and playback.

**Prerequisites installed via Homebrew:**
```
brew install blackhole-2ch
brew install whisper-cpp
```

### `/start-recording`

Starts capturing system audio in the background.

**Behavior:**
1. Check that no recording is already active (check `.active` state file).
2. Determine the BlackHole device name for ffmpeg input.
3. Start `ffmpeg` recording as a background process:
   - Input: BlackHole 2ch audio device
   - Output: `data/recordings/YYYY-MM-DD-HH-MM.wav`
   - Format: 16-bit PCM, 16kHz, mono (whisper.cpp optimal input)
4. Write `.active` state file with: PID, start timestamp, output file path.
5. Confirm recording is live.

**Example ffmpeg command:**
```bash
ffmpeg -f avfoundation -i ":BlackHole 2ch" -ac 1 -ar 16000 -acodec pcm_s16le data/recordings/2026-04-30-14-00.wav
```

### `/stop-recording`

Stops the active recording and transcribes it.

**Behavior:**
1. Read `.active` state file to get PID and file path.
2. Send SIGINT to the ffmpeg process (clean shutdown).
3. Verify the audio file was written successfully.
4. Run whisper.cpp on the audio file:
   - Model: `ggml-base.en.bin` (default) — configurable
   - Output: `data/transcripts/YYYY-MM-DD-HH-MM.txt`
5. Delete the `.active` state file.
6. Report: recording duration, transcript file location, word count.
7. Suggest running `/import-meeting-notes` to synthesize and route.

**Example whisper.cpp command:**
```bash
whisper-cpp -m data/models/ggml-base.en.bin -f data/recordings/2026-04-30-14-00.wav -otxt -of data/transcripts/2026-04-30-14-00
```

**`.active` state file format (JSON):**
```json
{
  "pid": 12345,
  "started_at": "2026-04-30T14:00:00",
  "audio_file": "data/recordings/2026-04-30-14-00.wav"
}
```

### Modified `/import-meeting-notes`

Adds a local transcript source alongside the existing Granola MCP source.

**Changes:**
- On invocation, check for both Granola MCP availability and local transcripts in `data/transcripts/`.
- If local transcripts exist, list them with timestamps and let the user select which to import.
- Read the selected transcript file(s) as input for synthesis.
- Synthesis and routing logic remains identical to the current Granola-based flow:
  - Extract decisions, action items, stakeholder positions, context
  - Propose routing destinations (people files, project notes, research, company)
  - Confirm routing with user before writing
  - Append structured sections to destination files
- After successful import, optionally delete the source recording and transcript files.

**Source priority:**
1. If Granola MCP is available, offer both sources
2. If no Granola, default to local transcripts
3. If neither, inform user no meeting data is available

## Recording Specifications

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| Audio format | WAV (PCM) | Uncompressed, whisper.cpp native input |
| Sample rate | 16kHz | Whisper's expected input rate |
| Channels | Mono | Speech doesn't need stereo |
| Bit depth | 16-bit | Standard for speech |
| File size | ~1.9 MB/min | Manageable for hour-long meetings |
| Whisper model | ggml-base.en | Fast (~1-2 min for 30 min audio on M1+), reasonable accuracy |

## Workflow Comparison

### Current (with Granola)

1. Meeting happens → Granola captures passively (automatic)
2. Run `/import-meeting-notes` → pulls from Granola MCP
3. Claude synthesizes → routes to knowledge base

### Native recording

1. Before meeting: run `/start-recording` (manual trigger)
2. Meeting happens → ffmpeg captures system audio via BlackHole
3. After meeting: run `/stop-recording` → whisper.cpp transcribes locally
4. Run `/import-meeting-notes` → reads local transcript
5. Claude synthesizes → routes to knowledge base (same as current)

**Key difference:** Steps 1 and 3 are manual. Everything downstream is identical.

## Edge Cases

| Scenario | Handling |
|----------|----------|
| Claude Code crashes mid-recording | ffmpeg continues running. `/stop-recording` can find it via PID in `.active` file. Fallback: `kill` the PID manually. |
| Forget to start recording | No audio captured. Take manual notes and use standard meeting template. |
| Forget to stop recording | Recording continues, capturing post-meeting audio. Transcript will have extra content; Claude synthesis will focus on meeting-relevant content. |
| Poor audio quality | whisper.cpp will produce a lower-quality transcript. Claude synthesis will work with what's available and flag uncertainty. |
| Multiple meetings back-to-back | Stop and start between meetings. Each gets its own recording and transcript file. |
| Background noise / system sounds | BlackHole captures all system audio. Pause music, mute notifications before recording. |
| Disk space | ~115 MB per hour of audio. Old recordings should be cleaned up after import. |

## Portability

- At a company with Granola access: use existing Granola MCP flow (no change)
- At a restricted company: use native recording flow
- Both paths feed into the same `/import-meeting-notes` skill
- All downstream skills (`/meeting-prep`, `/weekly-digest`, `/status-report`) work identically regardless of source

## Setup Checklist

1. Install BlackHole: `brew install blackhole-2ch`
2. Install whisper.cpp: `brew install whisper-cpp`
3. Download Whisper model (via `/setup-recording` or manually)
4. Configure multi-output device in macOS Audio MIDI Setup
5. Set multi-output device as system default audio output
6. Run `/setup-recording` to verify everything works

## Out of Scope

- **Real-time transcription**: Transcription happens after the meeting, not during.
- **Auto-detection of meetings**: No calendar polling or auto-start. Manual trigger only.
- **Speaker diarization**: whisper.cpp base model doesn't distinguish speakers. Could be added later with a larger model or post-processing.
- **Video recording**: Audio only.
- **Menu bar UI**: No GUI. Everything runs through Claude Code skills.
