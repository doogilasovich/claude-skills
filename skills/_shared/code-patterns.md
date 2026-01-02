# Code Patterns Reference

Shared patterns for code review and fix skills. Load on-demand when implementing fixes.

## Dependency Injection

### DI-001: Constructor Injection
```swift
// BAD
class Service { func fetch() { let client = NetworkClient() } }

// GOOD
class Service {
    private let client: NetworkClientProtocol
    init(client: NetworkClientProtocol) { self.client = client }
}
```

### DI-002: Protocol Abstraction
```swift
protocol NetworkClientProtocol { func get<T: Decodable>(_ path: String) async throws -> T }
extension NetworkClient: NetworkClientProtocol {}
```

### DI-003: Time Provider
```swift
protocol TimeProvider { var now: Date { get } }
struct SystemTime: TimeProvider { var now: Date { Date() } }
```

### DI-004: Singleton Wrapper
```swift
protocol AnalyticsProtocol { func track(_ event: String) }
class AnalyticsWrapper: AnalyticsProtocol {
    func track(_ event: String) { Analytics.shared.track(event) }
}
```

## Memory Management

### MEM-001: Weak Self in Closure
```swift
// BAD: Task { self.data = result }
// GOOD: Task { [weak self] in self?.data = result }
```

### MEM-002: Weak Delegate
```swift
// BAD: var delegate: MyDelegate?
// GOOD: weak var delegate: MyDelegate?
```

### MEM-003: Capture List
```swift
// BAD: closure = { self.update() }
// GOOD: closure = { [weak self] in self?.update() }
```

## Concurrency

### CONC-001: Actor Isolation
```swift
actor DataStore {
    private var cache: [String: Data] = [:]
    func get(_ key: String) -> Data? { cache[key] }
    func set(_ key: String, _ value: Data) { cache[key] = value }
}
```

### CONC-002: MainActor UI
```swift
@MainActor class ViewModel: ObservableObject {
    @Published var data: [Item] = []
    func load() async { data = await service.fetch() }
}
```

### CONC-003: Sendable Compliance
```swift
struct Config: Sendable { let apiKey: String; let timeout: TimeInterval }
```

### CONC-004: Task Cancellation
```swift
func load() async throws {
    try Task.checkCancellation()
    let data = try await fetch()
    try Task.checkCancellation()
    process(data)
}
```

## Error Handling

### ERR-001: Typed Errors
```swift
enum NetworkError: LocalizedError {
    case noConnection, timeout, serverError(Int)
    var errorDescription: String? {
        switch self {
        case .noConnection: "No internet connection"
        case .timeout: "Request timed out"
        case .serverError(let code): "Server error: \(code)"
        }
    }
}
```

### ERR-002: Result Type
```swift
func fetch() async -> Result<Data, NetworkError> {
    do { return .success(try await client.get()) }
    catch { return .failure(.noConnection) }
}
```

### ERR-003: Error Recovery
```swift
func loadWithRetry(attempts: Int = 3) async throws -> Data {
    for attempt in 1...attempts {
        do { return try await load() }
        catch where attempt < attempts { try await Task.sleep(for: .seconds(1)) }
    }
    throw LoadError.maxRetriesExceeded
}
```

## Performance

### PERF-001: Lazy Initialization
```swift
// BAD: let formatter = DateFormatter()
// GOOD: private lazy var formatter: DateFormatter = { let f = DateFormatter(); f.dateStyle = .medium; return f }()
```

### PERF-002: Collection Optimization
```swift
// BAD: items.filter { $0.isActive }.first
// GOOD: items.first { $0.isActive }
```

### PERF-003: Set for Lookups
```swift
// BAD: let ids = [String](); ids.contains(id) // O(n)
// GOOD: let ids = Set<String>(); ids.contains(id) // O(1)
```

## Security

### SEC-001: Keychain Storage
```swift
// BAD: UserDefaults.standard.set(token, forKey: "auth")
// GOOD: KeychainWrapper.set(token, forKey: "auth", accessibility: .whenUnlocked)
```

### SEC-002: Input Validation
```swift
func validate(_ input: String) -> Bool {
    let pattern = "^[a-zA-Z0-9_]{3,20}$"
    return input.range(of: pattern, options: .regularExpression) != nil
}
```

### SEC-003: Certificate Pinning
```swift
class PinnedSession: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                   completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let trust = challenge.protectionSpace.serverTrust,
              SecTrustEvaluateWithError(trust, nil),
              let cert = SecTrustGetCertificateAtIndex(trust, 0),
              pinnedCerts.contains(SecCertificateCopyData(cert) as Data)
        else { completionHandler(.cancelAuthenticationChallenge, nil); return }
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}
```

## Analytics

### ANAL-001: Event Tracking
```swift
analytics.track("screen_viewed", properties: [
    "screen_name": "product_detail",
    "product_id": productId,
    "source": source.rawValue
])
```

### ANAL-002: Funnel Events
```swift
// Complete funnel: viewed → added → checkout → purchased
analytics.track("product_viewed", ["product_id": id])
analytics.track("cart_item_added", ["product_id": id, "quantity": qty])
analytics.track("checkout_started", ["cart_value": total])
analytics.track("purchase_completed", ["order_id": orderId, "revenue": amount])
```

### ANAL-003: Error Analytics
```swift
analytics.track("error_occurred", properties: [
    "error_type": String(describing: type(of: error)),
    "error_message": error.localizedDescription,
    "screen": currentScreen,
    "user_action": lastAction
])
```

## Testing

### TEST-001: Mock Protocol
```swift
class MockNetworkClient: NetworkClientProtocol {
    var mockResponse: Any?
    var shouldFail = false
    func get<T: Decodable>(_ path: String) async throws -> T {
        if shouldFail { throw TestError.mock }
        return mockResponse as! T
    }
}
```

### TEST-002: Async Test
```swift
func testFetch() async throws {
    let mock = MockNetworkClient()
    mock.mockResponse = User(id: "1", name: "Test")
    let service = UserService(client: mock)
    let user = try await service.fetch(id: "1")
    XCTAssertEqual(user.name, "Test")
}
```
