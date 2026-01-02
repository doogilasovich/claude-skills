---
name: fix-network
description: Fixes caching, deduplication, pagination, offline-first, retry.
---

# Network Fixer

Implement caching, request optimization, and offline-first patterns.

## Checklist

| Issue | Fix |
|-------|-----|
| No caching | Memory + disk cache with TTL |
| Duplicate concurrent requests | Request deduplication |
| Load all data at once | Pagination |
| App unusable offline | Offline-first pattern |
| Aggressive retry | Exponential backoff + jitter |

## Quick Fixes

### Response Caching
```swift
actor ProfileCache {
    private var cache: (profile: Profile, timestamp: Date)?
    private let ttl: TimeInterval = 300
    func fetch() async throws -> Profile {
        if let c = cache, Date().timeIntervalSince(c.timestamp) < ttl { return c.profile }
        let profile = try await networkClient.fetchProfile()
        cache = (profile, Date())
        return profile
    }
}
```

### Request Deduplication
```swift
actor UserService {
    private var inFlight: [String: Task<User, Error>] = [:]
    func fetch(id: String) async throws -> User {
        if let task = inFlight[id] { return try await task.value }
        let task = Task { defer { inFlight.removeValue(forKey: id) }; return try await networkClient.getUser(id) }
        inFlight[id] = task
        return try await task.value
    }
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md`
