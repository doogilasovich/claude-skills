# Secure Storage Patterns

Keychain and encryption for sensitive data.

## Keychain Helper

```swift
actor SecureStorage {
    static let shared = SecureStorage()

    func store(_ data: Data, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.failed(status) }
    }

    func retrieve(forKey key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else { throw KeychainError.failed(status) }
        return result as? Data
    }

    func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

enum KeychainError: Error {
    case failed(OSStatus)
}
```

## Data Encryption (CryptoKit)

```swift
import CryptoKit

func encrypt(_ data: Data, key: SymmetricKey) throws -> Data {
    try AES.GCM.seal(data, using: key).combined!
}

func decrypt(_ data: Data, key: SymmetricKey) throws -> Data {
    let box = try AES.GCM.SealedBox(combined: data)
    return try AES.GCM.open(box, using: key)
}

func generateKey() -> SymmetricKey {
    SymmetricKey(size: .bits256)
}
```

## Best Practices

| Data Type | Storage |
|-----------|---------|
| API keys | Keychain |
| Auth tokens | Keychain |
| User preferences | UserDefaults (non-sensitive) |
| Credentials | Keychain + encryption |
| Cached data | File system (encrypted if sensitive) |

Never store sensitive data in:
- UserDefaults
- Unencrypted files
- Source code
