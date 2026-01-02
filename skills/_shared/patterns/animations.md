# Animation Patterns

SwiftUI animations with accessibility support.

## Spring Parameters

| Interaction | Response | Damping |
|-------------|----------|---------|
| Button press | 0.2 | 0.6 |
| Screen transition | 0.4 | 0.85 |
| Celebration | 0.6 | 0.7 |
| Reveal | 0.5 | 0.75 |
| Interactive | 0.15 | 0.8 |

## Countdown Reveal

```swift
struct CountdownRevealView: View {
    @State private var countdown = 3
    @State private var blurRadius: CGFloat = 30
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ZStack {
            content.blur(radius: blurRadius)
            if countdown > 0 {
                Text("\(countdown)")
                    .font(.system(size: 120, weight: .bold))
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .onAppear { startCountdown() }
    }

    func startCountdown() {
        guard !reduceMotion else { blurRadius = 0; return }
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                withAnimation(.spring(response: 0.3)) { countdown = 3 - i }
                HapticManager.shared.lightTap()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.spring(response: 0.6)) { countdown = 0; blurRadius = 0 }
            HapticManager.shared.success()
        }
    }
}
```

## Button Press Effect

```swift
struct PressableButton: View {
    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    let action: () -> Void

    var body: some View {
        Button(action: { HapticManager.shared.mediumTap(); action() }) {
            content
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .shadow(radius: isPressed ? 4 : 8, y: isPressed ? 2 : 4)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard !reduceMotion else { return }
                    withAnimation(.spring(response: 0.2)) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3)) { isPressed = false }
                }
        )
    }
}
```

## Accessibility

Always check `@Environment(\.accessibilityReduceMotion)` and skip/simplify animations when true.
