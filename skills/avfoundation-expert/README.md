# AVFoundation Expert Skill

Expert knowledge in Apple's AVFoundation framework for iOS/macOS development.

## What This Skill Covers

- **Video Capture**: AVCaptureSession, camera setup, recording
- **Video Playback**: AVPlayer, preloading, looping, UIKit integration
- **Video Processing**: Reversal, face detection, composition, export
- **Threading**: MainActor isolation, background processing, Combine
- **Performance**: Critical pitfalls and optimization techniques

## Key Lessons Captured

1. **AVCaptureVideoPreviewLayer Blocking**: Creating multiple layers for the same session blocks for ~9 seconds. Reuse single layer.

2. **UIViewRepresentable Identity Checks**: Guard against identity-equal reassignment to prevent expensive operations.

3. **Player Preloading**: Wait for `readyToPlay` status before playback for smooth transitions.

4. **Memory Management**: Remove NotificationCenter observers, process video in chunks.

## Usage

When working with AVFoundation in iOS/macOS projects, this skill provides:
- Architecture patterns for camera apps
- Threading best practices
- Common pitfall solutions
- Performance optimization tips

## Origin

Created from real debugging sessions investigating screen transition delays in a video recording app. The 18-second delay was traced to AVCaptureVideoPreviewLayer blocking behavior.
