# Sound Design Patterns

Audio feedback integration with AVFoundation.

## Sound Manager

```swift
actor SoundManager {
    static let shared = SoundManager()

    private var players: [String: AVAudioPlayer] = [:]

    func preload(sounds: [String]) async {
        for sound in sounds {
            guard let url = Bundle.main.url(forResource: sound, withExtension: "wav") else { continue }
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                players[sound] = player
            } catch {
                print("Failed to load: \(sound)")
            }
        }
    }

    func play(_ sound: String, volume: Float = 1.0) {
        guard let player = players[sound] else { return }
        player.volume = volume
        player.currentTime = 0
        player.play()
    }
}
```

## Usage

```swift
// Preload on app launch
await SoundManager.shared.preload(sounds: ["pop", "swoosh", "success"])

// Play on action
SoundManager.shared.play("success", volume: 0.7)
```

## Best Practices

- Respect silent mode (check `AVAudioSession` settings)
- Keep sounds short (< 1 second for UI feedback)
- Use consistent volume levels
- Provide setting to disable sounds
- Pair with haptic feedback for multimodal experience
