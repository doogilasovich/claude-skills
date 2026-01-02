# Haptic Feedback Patterns

Centralized haptic management for consistent tactile feedback.

## HapticManager Singleton

```swift
final class HapticManager {
    static let shared = HapticManager()

    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let heavy = UIImpactFeedbackGenerator(style: .heavy)
    private let rigid = UIImpactFeedbackGenerator(style: .rigid)
    private let soft = UIImpactFeedbackGenerator(style: .soft)
    private let notification = UINotificationFeedbackGenerator()
    private let selection = UISelectionFeedbackGenerator()

    init() { prepareAll() }

    func prepareAll() {
        [light, medium, heavy, rigid, soft].forEach { $0.prepare() }
        notification.prepare()
        selection.prepare()
    }

    // Impact
    func lightTap() { light.impactOccurred() }
    func mediumTap() { medium.impactOccurred() }
    func heavyTap() { heavy.impactOccurred() }

    // Notification
    func success() { notification.notificationOccurred(.success) }
    func warning() { notification.notificationOccurred(.warning) }
    func error() { notification.notificationOccurred(.error) }

    // Selection
    func selectionChanged() { selection.selectionChanged() }
}
```

## Animation Pairing Guide

| Animation | Haptic |
|-----------|--------|
| Button tap | `.light` or `.medium` |
| Success | `.success` notification |
| Error | `.error` notification |
| Selection | `.selection` |
| Threshold | `.rigid` |
| Reveal | `.heavy` + `.success` |

## Celebration Pattern

```swift
extension HapticManager {
    func celebrationBurst() {
        success()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { self.lightTap() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { self.softTap() }
    }
}
```
