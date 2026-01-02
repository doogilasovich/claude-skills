# Visual Hierarchy Patterns

Clear UI emphasis with primary/secondary/tertiary levels.

## Hierarchical Button

```swift
struct HierarchicalButton: View {
    enum Emphasis { case primary, secondary, tertiary }

    let title: String
    let emphasis: Emphasis
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(emphasis == .primary ? .headline : .subheadline)
                .foregroundStyle(foreground)
                .frame(maxWidth: emphasis == .primary ? .infinity : nil)
                .padding(.horizontal, padding)
                .padding(.vertical, 12)
                .background(background)
                .cornerRadius(emphasis == .tertiary ? 8 : 12)
        }
    }

    private var foreground: Color {
        switch emphasis {
        case .primary: return .white
        case .secondary: return .accentColor
        case .tertiary: return .secondary
        }
    }

    private var background: some View {
        Group {
            switch emphasis {
            case .primary: Color.accentColor
            case .secondary: Color.accentColor.opacity(0.15)
            case .tertiary: Color.clear
            }
        }
    }

    private var padding: CGFloat {
        emphasis == .primary ? 24 : (emphasis == .secondary ? 16 : 12)
    }
}
```

## Action Sheet Layout

```swift
VStack(spacing: 12) {
    HierarchicalButton(title: "Share", emphasis: .primary, action: share)
    HierarchicalButton(title: "Save", emphasis: .secondary, action: save)
    HierarchicalButton(title: "Cancel", emphasis: .tertiary, action: cancel)
}
```

## Information Density

```swift
struct AdaptiveInfo: View {
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        if sizeCategory.isAccessibilityCategory {
            CompactInfo() // Essential info only
        } else {
            DetailedInfo() // Full info
        }
    }
}
```

## Smart Defaults

```swift
// Show recommended option prominently
VStack {
    RecommendedOption(option: suggested) // Primary
    DisclosureGroup("Other options") {   // Hidden
        ForEach(others) { OtherOption($0) }
    }
}
```
