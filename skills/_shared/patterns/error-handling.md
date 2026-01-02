# Error Handling Patterns

User-facing errors with recovery options.

## Typed Errors

```swift
enum AppError: LocalizedError {
    case saveFailed(underlying: Error)
    case processingFailed
    case networkError
    case permissionDenied(type: String)

    var errorDescription: String? {
        switch self {
        case .saveFailed: return "Unable to save. Please try again."
        case .processingFailed: return "Processing failed. Tap to retry."
        case .networkError: return "No internet connection."
        case .permissionDenied(let type): return "\(type) access required."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .saveFailed: return "Check storage and try again."
        case .processingFailed: return "Restart the app if problem persists."
        case .networkError: return "Check your connection."
        case .permissionDenied: return "Enable in Settings."
        }
    }
}
```

## Error Alert

```swift
@State private var error: AppError?
@State private var showingError = false

.alert("Error", isPresented: $showingError, presenting: error) { err in
    Button("Retry") { retryAction() }
    Button("Cancel", role: .cancel) { }
    if case .permissionDenied = err {
        Button("Settings") { openSettings() }
    }
} message: { err in
    Text(err.localizedDescription)
}
```

## Retry with Backoff

```swift
func withRetry<T>(
    maxAttempts: Int = 3,
    initialDelay: TimeInterval = 1.0,
    operation: () async throws -> T
) async throws -> T {
    var delay = initialDelay
    for attempt in 1...maxAttempts {
        do { return try await operation() }
        catch where attempt < maxAttempts {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            delay *= 2
        }
    }
    throw AppError.processingFailed
}
```

## Permission Recovery

```swift
func checkPermission() async -> Bool {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .authorized: return true
    case .notDetermined: return await AVCaptureDevice.requestAccess(for: .video)
    case .denied, .restricted:
        await MainActor.run { showPermissionAlert = true }
        return false
    @unknown default: return false
    }
}
```
