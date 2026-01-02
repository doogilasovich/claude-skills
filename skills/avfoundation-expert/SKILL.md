---
name: avfoundation-expert
description: Expert in AVFoundation for iOS/macOS video and audio capture, playback, processing, and composition. Knows critical performance pitfalls, threading requirements, and best practices learned from real debugging sessions.
---

# AVFoundation Expert

Deep expertise in Apple's AVFoundation framework for video/audio capture, playback, processing, and composition. This skill encapsulates critical lessons learned from real debugging sessions plus comprehensive framework knowledge.

## Critical Lessons Learned

### AVCaptureVideoPreviewLayer Blocking Issue

**Problem**: Creating a second `AVCaptureVideoPreviewLayer` for the same `AVCaptureSession` blocks the main thread for ~9 seconds.

**Root Cause**: AVFoundation internally synchronizes when multiple preview layers reference the same capture session. The second layer creation triggers an expensive blocking operation.

**Symptoms**:
- Screen transitions freeze for 9+ seconds
- UI becomes unresponsive during camera view changes
- Happens when SwiftUI recreates views with camera previews

**Solution**: Reuse a single persistent camera layer that repositions based on state, rather than creating separate layer instances.

```swift
// BAD: Creates blocking when both exist for same session
struct Screen1: View {
    var body: some View {
        CameraPreview(session: session) // Layer 1
    }
}

struct Screen2: View {
    var body: some View {
        CameraPreview(session: session) // Layer 2 - BLOCKS 9 seconds
    }
}

// GOOD: Single layer that repositions
struct Container: View {
    @State private var currentScreen: Screen

    var body: some View {
        ZStack {
            // Single persistent layer
            CameraPreview(session: session)
                .frame(width: frameForScreen.width, height: frameForScreen.height)
                .position(x: frameForScreen.midX, y: frameForScreen.midY)
                .opacity(shouldShowCamera ? 1 : 0)

            // Screen content overlays
            currentScreenContent
        }
    }
}
```

### UIViewRepresentable Session Identity Check

**Problem**: SwiftUI's `updateUIView` triggers `didSet` on session property, causing unnecessary layer recreation even when session hasn't changed.

**Solution**: Guard against identity-equal reassignment:

```swift
class CameraPreviewView: UIView {
    var session: AVCaptureSession? {
        didSet {
            // CRITICAL: Only update if session actually changed
            guard session !== oldValue else { return }
            updatePreviewLayer()
        }
    }

    private func updatePreviewLayer() {
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil

        guard let session = session else { return }

        let newPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        newPreviewLayer.videoGravity = .resizeAspectFill
        newPreviewLayer.frame = bounds
        layer.addSublayer(newPreviewLayer)
        previewLayer = newPreviewLayer
    }
}
```

## Capture Session Architecture

### Session Setup Best Practices

```swift
@MainActor
class CameraManager: ObservableObject {
    @Published var session: AVCaptureSession?
    @Published var isSessionRunning = false

    private var isSetUp = false

    // Lazy setup - don't initialize camera until needed
    func ensureCameraReady() {
        guard !isSetUp else { return }
        isSetUp = true
        setupCamera()
    }

    private func setupCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        // Configure on background queue, update UI on main
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Add inputs/outputs here
            captureSession.startRunning()

            DispatchQueue.main.async {
                self?.session = captureSession
                self?.isSessionRunning = true
            }
        }
    }
}
```

### Input/Output Configuration

```swift
// Video input (front camera)
guard let frontCamera = AVCaptureDevice.default(
    .builtInWideAngleCamera,
    for: .video,
    position: .front
) else { return }

let cameraInput = try AVCaptureDeviceInput(device: frontCamera)
if captureSession.canAddInput(cameraInput) {
    captureSession.addInput(cameraInput)
}

// Audio input
if let audioDevice = AVCaptureDevice.default(for: .audio) {
    let audioInput = try AVCaptureDeviceInput(device: audioDevice)
    if captureSession.canAddInput(audioInput) {
        captureSession.addInput(audioInput)
    }
}

// Movie file output for recording
let movieOutput = AVCaptureMovieFileOutput()
if captureSession.canAddOutput(movieOutput) {
    captureSession.addOutput(movieOutput)
}
```

### Recording Delegate Pattern

```swift
extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    // MUST be nonisolated for delegate conformance
    nonisolated func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        if let error = error {
            print("Recording error: \(error)")
            return
        }

        // Dispatch to MainActor for UI updates
        Task { @MainActor in
            self.recordedURL = outputFileURL
            self.recordingCompletedSubject.send(outputFileURL)
        }
    }
}
```

## Video Playback

### AVPlayer Preloading Pattern

Preload players for smooth transitions:

```swift
func preloadPlayer(for url: URL) async -> AVPlayer {
    let asset = AVURLAsset(url: url)

    // Load essential properties asynchronously
    _ = try? await asset.load(.isPlayable)

    let playerItem = AVPlayerItem(asset: asset)
    let player = AVPlayer(playerItem: playerItem)

    // Wait for player item to become ready
    if playerItem.status != .readyToPlay {
        await withCheckedContinuation { continuation in
            var observer: NSKeyValueObservation?
            observer = playerItem.observe(\.status, options: [.new]) { item, _ in
                if item.status == .readyToPlay || item.status == .failed {
                    observer?.invalidate()
                    continuation.resume()
                }
            }
        }
    }

    return player
}
```

### VideoPlayerView with UIViewControllerRepresentable

```swift
struct VideoPlayerView: UIViewControllerRepresentable {
    var url: URL
    var preloadedPlayer: AVPlayer?
    @Binding var isPlaying: Bool
    var loop: Bool = false
    var onPlaybackEnded: () -> Void

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        let player = preloadedPlayer ?? AVPlayer(url: url)

        controller.player = player
        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = false
        controller.allowsVideoFrameAnalysis = false  // Disable Live Text

        // Mirror for front camera preview matching
        controller.view.transform = CGAffineTransform(scaleX: -1, y: 1)

        // Set up end-of-playback notification
        if let playerItem = player.currentItem {
            NotificationCenter.default.addObserver(
                context.coordinator,
                selector: #selector(Coordinator.playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: playerItem
            )
        }

        return controller
    }

    class Coordinator: NSObject {
        var player: AVPlayer?
        var loop: Bool = false
        var onPlaybackEnded: (() -> Void)?

        @objc func playerDidFinishPlaying() {
            if loop {
                player?.seek(to: .zero) { [weak self] _ in
                    self?.player?.play()
                }
            }
            onPlaybackEnded?()
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
```

### Memory Leak Prevention

Always clean up NotificationCenter observers:

```swift
struct SharePreviewSheet: View {
    @State private var player: AVPlayer?
    @State private var playerLoopObserver: NSObjectProtocol?

    var body: some View {
        VideoPlayer(player: player)
            .onAppear { setupPlayer() }
            .onDisappear { cleanupPlayer() }
    }

    private func cleanupPlayer() {
        // CRITICAL: Remove observer before releasing player
        if let observer = playerLoopObserver {
            NotificationCenter.default.removeObserver(observer)
            playerLoopObserver = nil
        }
        player?.pause()
        player = nil
    }
}
```

## Video Processing

### Video Reversal Architecture

```swift
actor VideoReverser {
    func reverseVideo(inputURL: URL, outputURL: URL) async throws -> URL {
        let asset = AVURLAsset(url: inputURL)

        // Load tracks asynchronously
        let videoTrack = try await asset.loadTracks(withMediaType: .video).first!
        let audioTrack = try? await asset.loadTracks(withMediaType: .audio).first

        // Phase 1: Read video frames (chunked for memory)
        let videoSamples = try await readVideoSamplesChunked(from: asset, track: videoTrack)

        // Phase 2: Process audio (reverse samples)
        let reversedAudio = try await processAudioReverse(from: audioTrack)

        // Phase 3: Write reversed video with synchronized audio
        try await writeReversedVideo(
            videoSamples: videoSamples.reversed(),
            audioSamples: reversedAudio,
            to: outputURL
        )

        return outputURL
    }
}
```

### Face Detection with Vision Framework

```swift
actor FaceDetector {
    private let sampleRate: Int = 5  // Sample every Nth frame
    private let minConfidence: Float = 0.5
    private let presenceThreshold: Double = 0.30  // 30% of frames

    struct FaceAnalysis {
        let faceRectsByFrame: [Int: CGRect]
        let averageFacePosition: CGRect?
        let hasFace: Bool
        let totalFrames: Int
    }

    func analyzeVideo(url: URL) async throws -> FaceAnalysis {
        let asset = AVURLAsset(url: url)
        let reader = try AVAssetReader(asset: asset)

        var faceRects: [Int: CGRect] = [:]
        var frameIndex = 0

        while let sampleBuffer = output.copyNextSampleBuffer() {
            // Only process every Nth frame
            if frameIndex % sampleRate == 0 {
                if let faceRect = try await detectFace(in: sampleBuffer) {
                    faceRects[frameIndex] = faceRect
                }
            }
            frameIndex += 1
        }

        // Interpolate missing frames
        let interpolated = interpolateFacePositions(faceRects, totalFrames: frameIndex)

        // Calculate average position
        let avgPosition = calculateAveragePosition(faceRects)

        // Determine if face is present (30%+ threshold)
        let presenceRatio = Double(faceRects.count) / Double(frameIndex / sampleRate)

        return FaceAnalysis(
            faceRectsByFrame: interpolated,
            averageFacePosition: avgPosition,
            hasFace: presenceRatio >= presenceThreshold,
            totalFrames: frameIndex
        )
    }
}
```

### AVAssetExportSession Best Practices

```swift
func exportVideo(
    composition: AVMutableComposition,
    to outputURL: URL,
    preset: String = AVAssetExportPresetHighestQuality
) async throws {
    // Remove existing file
    try? FileManager.default.removeItem(at: outputURL)

    guard let exportSession = AVAssetExportSession(
        asset: composition,
        presetName: preset
    ) else {
        throw ExportError.sessionCreationFailed
    }

    exportSession.outputURL = outputURL
    exportSession.outputFileType = .mp4
    exportSession.shouldOptimizeForNetworkUse = true

    await exportSession.export()

    switch exportSession.status {
    case .completed:
        return
    case .failed:
        throw exportSession.error ?? ExportError.unknown
    case .cancelled:
        throw ExportError.cancelled
    default:
        throw ExportError.unknown
    }
}
```

## Threading and Concurrency

### MainActor Isolation

```swift
// Camera operations MUST be MainActor isolated
@MainActor
class CameraManager: ObservableObject {
    @Published var session: AVCaptureSession?
    @Published var isRecording = false
}

// Delegate methods must be nonisolated
extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    nonisolated func fileOutput(...) {
        // Dispatch back to MainActor for state updates
        Task { @MainActor in
            self.isRecording = false
        }
    }
}
```

### Background Processing

```swift
// Start capture session on background queue
DispatchQueue.global(qos: .userInitiated).async {
    captureSession.startRunning()

    DispatchQueue.main.async {
        self.isSessionRunning = true
    }
}

// Heavy video processing on background actor
actor VideoProcessor {
    func process(url: URL) async throws -> URL {
        // CPU-intensive work here
    }
}
```

### Combine for Thread-Safe Callbacks

```swift
class CameraManager {
    // Thread-safe alternative to closures
    private let recordingCompletedSubject = PassthroughSubject<URL, Never>()
    var recordingCompletedPublisher: AnyPublisher<URL, Never> {
        recordingCompletedSubject.eraseToAnyPublisher()
    }
}

// Subscribe on main thread
cameraManager.recordingCompletedPublisher
    .receive(on: DispatchQueue.main)
    .sink { [weak self] url in
        self?.handleRecordingComplete(url: url)
    }
    .store(in: &cancellables)
```

## Common Pitfalls

### 1. Multiple Preview Layers
**Problem**: Creating multiple `AVCaptureVideoPreviewLayer` instances for the same session causes 9-second blocking.
**Solution**: Reuse single layer, reposition based on state.

### 2. Session Configuration on Main Thread
**Problem**: `startRunning()` blocks main thread.
**Solution**: Configure and start session on background queue.

### 3. Forgetting to Remove Observers
**Problem**: NotificationCenter observers leak memory.
**Solution**: Always remove in `deinit` or `onDisappear`.

### 4. UIViewRepresentable Unnecessary Updates
**Problem**: SwiftUI calls `updateUIView` frequently, triggering expensive operations.
**Solution**: Guard with identity checks (`===`) before expensive operations.

### 5. Player Item Status Not Ready
**Problem**: Playing before `readyToPlay` causes silent failures.
**Solution**: Observe `.status` and wait for `readyToPlay`.

### 6. Missing Audio Session Configuration
**Problem**: Audio doesn't record or plays through wrong route.
**Solution**: Configure `AVAudioSession` category before capture.

```swift
try AVAudioSession.sharedInstance().setCategory(
    .playAndRecord,
    mode: .videoRecording,
    options: [.defaultToSpeaker, .allowBluetooth]
)
try AVAudioSession.sharedInstance().setActive(true)
```

### 7. Video Orientation Issues
**Problem**: Recorded video appears rotated.
**Solution**: Apply preferred transform from video track.

```swift
let videoTrack = try await asset.loadTracks(withMediaType: .video).first!
let transform = try await videoTrack.load(.preferredTransform)
// Apply transform to composition or layer
```

### 8. Memory Pressure During Video Processing
**Problem**: Loading entire video into memory causes crashes.
**Solution**: Process in chunks, release samples after processing.

```swift
// Process in chunks
let chunkSize = 100
for chunk in videoSamples.chunked(into: chunkSize) {
    process(chunk)
    autoreleasepool { }  // Release memory between chunks
}
```

## Performance Tips

1. **Preload assets** before transitions for smooth UX
2. **Use `.high` preset** instead of `.photo` for video capture (faster)
3. **Disable `allowsVideoFrameAnalysis`** if Live Text not needed
4. **Sample frames** for detection (every 5th frame) instead of all
5. **Use actors** for video processing to prevent data races
6. **Export with `shouldOptimizeForNetworkUse`** for faster uploads

## Debugging Tools

### Timing Measurements

```swift
let start = CFAbsoluteTimeGetCurrent()
// ... operation ...
let elapsed = CFAbsoluteTimeGetCurrent() - start
print("Operation took \(String(format: "%.3f", elapsed))s")
```

### Session Status Logging

```swift
print("Session running: \(captureSession.isRunning)")
print("Inputs: \(captureSession.inputs.count)")
print("Outputs: \(captureSession.outputs.count)")
```

## Version

**Version**: 1.0.0
**Last Updated**: December 2025
**Compatible**: iOS 15+, macOS 12+, Swift 5.9+, Swift 6 concurrency
