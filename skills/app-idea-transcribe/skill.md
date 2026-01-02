---
name: app-idea-transcribe
description: Transcribe voice memos.
user_invocable: true
---

# /app-idea transcribe

Transcribe voice memos to ideas. See `_reference.md` for schema.

## Args

```
transcribe                         # Process all new voice memos
transcribe --file=/path/to/audio   # Specific file
transcribe --list                  # Show unprocessed memos
```

## Voice Memo Location

```
~/Library/Group Containers/group.com.apple.VoiceMemos.shared/Recordings/
```

Files: `.m4a` format

## Transcription

Use Whisper CLI (requires: `brew install openai-whisper`):

```bash
whisper audio.m4a --model small --language en --output_format txt
```

Or use macOS built-in (via Shortcuts):
```bash
shortcuts run "Transcribe Audio" -i audio.m4a
```

## Parsing Transcript

Look for structure:
```
"App idea: [title]"
"The problem is [problem]"
"Basically [one-liner]"
"Similar to [inspiration]"
```

If unstructured, use full transcript as rawTranscript and prompt for clarification.

## Behavior

1. Find new/unprocessed voice memos
2. Transcribe each
3. Parse for idea components
4. Create spark entry with source=voice
5. Move processed files to archive
6. If unclear, prompt for details

## Archive Location

```
~/.claude/app-ideas/voice-archive/
```

## Output

```
🎤 Transcribing voice memos...

Found 2 new recordings:

1. Recording_2024-01-15.m4a (0:45)
   Transcribing... done

   Parsed:
   - Title: "Recipe scaler app"
   - Problem: "Converting recipe portions is tedious"
   - One-liner: "Voice-first recipe scaling"

   → Created app-006

2. Recording_2024-01-14.m4a (1:23)
   Transcribing... done

   Raw transcript (couldn't parse structure):
   "I was thinking about how annoying it is when..."

   What's the app idea title?
   > Parking spot finder

   What problem does it solve?
   > Never remember where I parked

   → Created app-007

✅ Transcribed 2 memos, created 2 ideas

   Review: /app-idea list --status=spark
```
