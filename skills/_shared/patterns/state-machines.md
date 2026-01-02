# State Machine Patterns

Unified state management for complex flows.

## Basic State Machine

```swift
enum AppState: Equatable {
    case idle
    case loading(message: String, progress: Double?)
    case processing
    case success
    case failure(Error)

    var isInteractive: Bool {
        switch self {
        case .idle, .success: return true
        default: return false
        }
    }
}

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var state: AppState = .idle

    func transition(to newState: AppState) {
        guard canTransition(from: state, to: newState) else { return }
        withAnimation(.spring(response: 0.3)) { state = newState }
    }

    private func canTransition(from: AppState, to: AppState) -> Bool {
        switch (from, to) {
        case (.idle, .loading), (.loading, .processing),
             (.processing, .success), (.processing, .failure),
             (.success, .idle), (.failure, .idle), (_, .failure):
            return true
        default: return false
        }
    }
}
```

## Loading State Enum

```swift
enum LoadingState: Equatable {
    case idle
    case loading(message: String, progress: Double?)
    case success
    case failure(AppError)
}
```

## View Binding

```swift
var body: some View {
    content
        .overlay {
            switch state {
            case .loading(let msg, let progress):
                LoadingOverlay(message: msg, progress: progress)
            case .failure(let error):
                ErrorOverlay(error: error, retry: { transition(to: .idle) })
            default: EmptyView()
            }
        }
        .disabled(!state.isInteractive)
}
```
