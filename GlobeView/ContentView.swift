//
//  Project: GlobeView
//  File: ContentView.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import SwiftUI
import RealityKit
import RealityKitContent

/// The main volumetric view that renders an interactive 3D globe.
///
/// `ContentView` loads the `Scene` entity from the bundled `RealityKitContent`
/// Swift package and attaches gesture handlers so the user can drag to rotate
/// and pinch to scale the globe inside a visionOS volumetric window.
struct ContentView: View {

    // MARK: - State

    /// Tracks the current uniform scale applied to the globe. Persists across
    /// gesture updates so pinch-to-zoom is cumulative instead of resetting.
    @State private var currentScale: Float = 10.0

    /// Remembers the globe's orientation between drag gestures so each new
    /// drag rotates *from* where the user left off, not from identity.
    @State private var baseOrientation: simd_quatf = .init(angle: 0, axis: [0, 1, 0])

    /// Reference to the loaded scene entity so gesture handlers can mutate it
    /// outside of the RealityView `make` closure.
    @State private var globe: Entity?

    // MARK: - Body

    var body: some View {
        RealityView { content in
            // `make` closure — runs once when the RealityView is first created.
            // Load the `Scene` entity from the RealityKitContent package bundle.
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {

                // Initial transform: scale up the model and center it.
                scene.scale = SIMD3<Float>(repeating: currentScale)
                scene.position = [0, 0, 0]

                // Enable hit-testing + input so gestures can target the entity.
                scene.components.set(InputTargetComponent())
                scene.generateCollisionShapes(recursive: true)

                content.add(scene)
                globe = scene
            }
        } update: { _ in
            // `update` closure — runs whenever SwiftUI state changes.
            // Apply the latest scale from state so pinch gestures take effect.
            globe?.scale = SIMD3<Float>(repeating: currentScale)
        }
        // MARK: - Drag to rotate
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    // Convert 2D drag translation into rotation around Y (yaw) and X (pitch).
                    let translation = value.gestureValue.translation
                    let yAngle = Float(translation.width) * 0.005
                    let xAngle = Float(translation.height) * 0.005

                    // Compose the incremental rotation with the stored base orientation
                    // so rotation accumulates instead of snapping back to zero.
                    let yaw = simd_quatf(angle: yAngle, axis: [0, 1, 0])
                    let pitch = simd_quatf(angle: xAngle, axis: [1, 0, 0])
                    value.entity.orientation = yaw * pitch * baseOrientation
                }
                .onEnded { value in
                    // Commit the final orientation as the new base for the next drag.
                    baseOrientation = value.entity.orientation
                }
        )
        // MARK: - Pinch to scale
        .gesture(
            MagnifyGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    // Multiply against the baseline (10.0) so zoom feels proportional.
                    let newScale = Float(value.magnification) * 10.0
                    // Clamp to a sensible range to avoid inverting or exploding the model.
                    currentScale = min(max(newScale, 2.0), 30.0)
                }
        )
        // MARK: - Double-tap to reset
        .gesture(
            TapGesture(count: 2)
                .targetedToAnyEntity()
                .onEnded { value in
                    // Reset orientation and scale so the user can recover from a bad angle.
                    withAnimation(.easeInOut(duration: 0.35)) {
                        currentScale = 10.0
                    }
                    value.entity.orientation = simd_quatf(angle: 0, axis: [0, 1, 0])
                    baseOrientation = value.entity.orientation
                }
        )
        // Add a subtle hover effect so the globe reads as interactive on visionOS.
        .hoverEffect(.highlight)
    }
}

// MARK: - Preview

#Preview(windowStyle: .volumetric) {
    ContentView()
}
