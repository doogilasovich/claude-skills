# Retention Systems

Streaks, notifications, achievements.

## Streak Tracking

```swift
actor StreakManager {
    static let shared = StreakManager()
    private let defaults = UserDefaults.standard

    var currentStreak: Int {
        get { defaults.integer(forKey: "streak") }
        set { defaults.set(newValue, forKey: "streak") }
    }

    var lastActivityDate: Date? {
        defaults.object(forKey: "lastActivity") as? Date
    }

    func recordActivity() {
        let now = Date()
        if let last = lastActivityDate {
            let days = Calendar.current.dateComponents([.day], from: last, to: now).day ?? 0
            switch days {
            case 0: break // Same day
            case 1, 2: currentStreak += 1 // Consecutive (2 = grace period)
            default: currentStreak = 1 // Reset
            }
        } else {
            currentStreak = 1
        }
        defaults.set(now, forKey: "lastActivity")
    }

    var isAtRisk: Bool {
        guard let last = lastActivityDate else { return false }
        let hours = Date().timeIntervalSince(last) / 3600
        return hours > 20 && hours < 48
    }
}
```

## Push Notifications

```swift
class NotificationManager {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()

    func requestPermission() async -> Bool {
        try? await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func scheduleDaily(hour: Int, title: String, body: String) async {
        var date = DateComponents()
        date.hour = hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        try? await center.add(UNNotificationRequest(identifier: "daily", content: content, trigger: trigger))
    }

    func scheduleReengagement(afterHours: Int, title: String, body: String) async {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(afterHours * 3600), repeats: false)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        try? await center.add(UNNotificationRequest(identifier: "reengage", content: content, trigger: trigger))
    }
}
```

## Achievement System

```swift
enum Achievement: String, CaseIterable, Codable {
    case firstAction, streak3, streak7, shared5

    var title: String { /* ... */ }
    var icon: String { /* ... */ }
}

actor AchievementManager {
    static let shared = AchievementManager()

    var unlocked: Set<Achievement> {
        get { /* decode from UserDefaults */ }
        set { /* encode to UserDefaults */ }
    }

    func unlock(_ achievement: Achievement) -> Bool {
        guard !unlocked.contains(achievement) else { return false }
        unlocked.insert(achievement)
        Task { @MainActor in
            HapticManager.shared.success()
            NotificationCenter.default.post(name: .achievementUnlocked, object: achievement)
        }
        return true
    }
}
```
