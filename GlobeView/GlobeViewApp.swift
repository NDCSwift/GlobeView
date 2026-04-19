//
//  Project: GlobeView
//  File: GlobeViewApp.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import SwiftUI

/// App entry point.
///
/// Defines a single volumetric `WindowGroup` that hosts `ContentView`. The
/// volumetric style is what allows the globe to render with true depth in the
/// user's space rather than as a flat panel.
@main
struct GlobeViewApp: App {
    var body: some Scene {
        // `WindowGroup` + `.volumetric` style = a 3D window on visionOS.
        // The `id` is useful if other parts of the app want to open or dismiss
        // this specific window via `@Environment(\.openWindow)`.
        WindowGroup(id: "volumetric") {
            ContentView()
        }
        // Volumetric windows render 3D content with depth, not just a flat plane.
        .windowStyle(.volumetric)
        // Default bounding box for the window, measured in real-world meters.
        // 0.5m cube gives the globe room to breathe without dominating the room.
        .defaultSize(width: 0.5, height: 0.5, depth: 0.5, in: .meters)
        // Lock the window size so pinch-to-zoom scales the globe, not the window.
        .windowResizability(.contentSize)
    }
}
