---
name: app-idea-inbox
description: Import ideas from mobile sources.
user_invocable: true
---

# /app-idea inbox

Import ideas from Reminders, Notes, Voice Memos, or GitHub. See `_reference.md` for sources.

## Args

```
inbox                              # All sources
inbox --source=reminders           # Reminders only
inbox --source=notes               # Notes only
inbox --source=voice               # Voice Memos only
inbox --source=github              # GitHub issues only
inbox --dry-run                    # Preview without importing
```

## Reminders Import

```applescript
tell application "Reminders"
    set appIdeasList to list "App Ideas"
    set items to reminders in appIdeasList whose completed is false
    repeat with r in items
        -- Extract name and notes
        set completed of r to true
    end repeat
end tell
```

Parse reminder:
- Title → oneLiner
- Notes → problem + rawTranscript

## Notes Import

```applescript
tell application "Notes"
    set appIdeasFolder to folder "App Ideas"
    set notesList to notes in appIdeasFolder
    repeat with n in notesList
        -- Extract name and body
        -- Move to "Processed" folder
    end repeat
end tell
```

## Voice Memos Import

1. Find new files in `~/Library/Group Containers/group.com.apple.VoiceMemos.shared/Recordings/`
2. Filter by naming pattern or date
3. Transcribe with Whisper: `whisper audio.m4a --model small --output_format txt`
4. Parse transcript for idea details
5. Move processed files to archive folder

## GitHub Import

```bash
gh issue list --label "app-idea-inbox" --state open --json number,title,body
# For each issue:
gh issue close N --comment "Imported to app-idea system"
```

## Behavior

1. Check each source
2. Parse content into idea schema
3. Create with status=spark, source={source}
4. Store rawTranscript for voice
5. Mark source as processed
6. Report imports

## Output

```
📥 Importing from inbox...

  Reminders: 2 items
  Notes: 0 items
  Voice: 1 memo (transcribing...)
  GitHub: 0 issues

Imported 3 ideas:

  app-004  💭 spark  "Shazam for bird calls"
           Source: reminders
           "Walking in park, heard weird bird..."

  app-005  💭 spark  "Gym timer with haptics"
           Source: reminders
           "Rest timers suck..."

  app-006  💭 spark  "Recipe scaler"
           Source: voice
           Transcript: "I was cooking and thought..."

Review: /app-idea list --status=spark
```
