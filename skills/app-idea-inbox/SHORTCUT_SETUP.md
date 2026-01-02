# iOS Shortcut Setup: "Log App Idea"

Quick voice capture for app ideas on the go.

## Option 1: Reminders-Based (Recommended)

### Create the Shortcut

1. Open **Shortcuts** app on iPhone
2. Tap **+** to create new shortcut
3. Name it: **"Log App Idea"**

### Add Actions

```
1. [Dictate Text]
   - Stop listening: After Pause
   - Language: English

2. [Add New Reminder]
   - Reminder: Dictated Text
   - List: "App Ideas"  ← Create this list first
   - Notes: (leave empty)

3. [Show Notification]
   - Title: "Idea Logged"
   - Body: Dictated Text
```

### Configure Trigger

- Add to Home Screen
- Add to Lock Screen (iOS 18+)
- Say "Hey Siri, Log App Idea"

### Sync to Mac

On Mac, the inbox skill reads from Reminders:
```bash
/app-idea inbox --source=reminders
```

---

## Option 2: Voice Memo + Transcription

### Create the Shortcut

```
1. [Record Audio]
   - Audio Quality: Normal
   - Start Recording: Immediately
   - Finish Recording: On Tap

2. [Save File]
   - Service: iCloud Drive
   - Path: /Shortcuts/AppIdeas/
   - File Name: idea-[Current Date].m4a

3. [Transcribe Audio]  ← iOS 17+ on-device
   - Audio: Recorded Audio

4. [Add New Reminder]
   - Reminder: Transcribed Text
   - List: "App Ideas"
   - Notes: "Voice memo: idea-[date].m4a"

5. [Show Notification]
   - Title: "Idea Recorded"
   - Body: Transcribed Text (truncated)
```

---

## Option 3: Notes-Based

```
1. [Dictate Text]

2. [Create Note]
   - Folder: "App Ideas"
   - Title: "Idea: [Date]"
   - Body: Dictated Text

3. [Show Notification]
```

Sync via:
```bash
/app-idea inbox --source=notes
```

---

## Option 4: GitHub Issue (Advanced)

Requires GitHub shortcut action or API call.

```
1. [Dictate Text]

2. [Get Contents of URL]
   - URL: https://api.github.com/repos/OWNER/REPO/issues
   - Method: POST
   - Headers: Authorization: token YOUR_PAT
   - Body: {"title": "App Idea", "body": "[Dictated]", "labels": ["app-idea"]}

3. [Show Notification]
```

---

## Recommended Setup

1. **Create "App Ideas" Reminders list** on iPhone
2. **Install Shortcut** (Option 1)
3. **Add to Lock Screen** for quick access
4. **Run `/app-idea inbox`** on Mac daily

## Tips

- Speak clearly: "App idea: [title]. The problem is [problem]. It would be like [inspiration] but for [audience]."
- Keep ideas under 30 seconds for best transcription
- Add "urgent" or "important" to prioritize in inbox

## Troubleshooting

- **Dictation not working**: Check Settings > General > Keyboard > Enable Dictation
- **Reminders not syncing**: Check iCloud settings on both devices
- **Transcription fails**: Ensure iOS 17+ and on-device processing enabled
