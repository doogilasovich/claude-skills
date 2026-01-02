# Consent & Privacy Patterns

GDPR/CCPA-compliant consent management.

## Consent Manager

```swift
class ConsentManager: ObservableObject {
    static let shared = ConsentManager()

    enum ConsentType: String, CaseIterable {
        case analytics, crashReporting, personalizedAds

        var title: String { /* ... */ }
        var description: String { /* ... */ }
    }

    @Published var consents: [ConsentType: Bool] = [:]

    init() { loadConsents() }

    private func loadConsents() {
        for type in ConsentType.allCases {
            consents[type] = UserDefaults.standard.bool(forKey: "consent_\(type.rawValue)")
        }
    }

    func setConsent(_ type: ConsentType, granted: Bool) {
        consents[type] = granted
        UserDefaults.standard.set(granted, forKey: "consent_\(type.rawValue)")
        applyConsent(type, granted: granted)
    }

    private func applyConsent(_ type: ConsentType, granted: Bool) {
        switch type {
        case .analytics: granted ? Analytics.enable() : Analytics.disable()
        case .crashReporting: /* configure */ break
        case .personalizedAds: /* configure */ break
        }
    }
}
```

## Privacy Dashboard View

```swift
struct PrivacyDashboardView: View {
    @ObservedObject var consentManager = ConsentManager.shared

    var body: some View {
        List {
            Section("Your Data") {
                DataStorageRow(title: "Local Storage", value: storageSize)
            }
            Section("Privacy Controls") {
                ForEach(ConsentManager.ConsentType.allCases, id: \.self) { type in
                    Toggle(type.title, isOn: binding(for: type))
                }
            }
            Section("Data Management") {
                Button("Export My Data") { exportData() }
                Button("Delete All Data", role: .destructive) { deleteData() }
            }
        }
    }
}
```

## Data Deletion

```swift
func deleteAllData() async throws {
    // 1. Delete app data
    // 2. Clear UserDefaults
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    // 3. Clear Keychain
    // 4. Clear caches
    // 5. Notify app to reset state
}
```

## App Tracking Transparency

```swift
func requestTrackingPermission() async {
    let status = await ATTrackingManager.requestTrackingAuthorization()
    // Configure ad SDKs based on status
}
```
