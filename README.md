# 🌍 GlobeView

A visionOS demo that renders an interactive 3D globe inside a volumetric SwiftUI window, with drag-to-rotate, pinch-to-zoom, and double-tap-to-reset gestures powered by RealityKit.

---

## 🤔 What this is

GlobeView is a minimal visionOS app built with SwiftUI and RealityKit that loads a `Scene` entity (an Earth USDZ model) from a local `RealityKitContent` Swift Package and renders it inside a volumetric window. It's a focused example of how to combine SwiftUI gestures, RealityKit entities, and a local asset package into a spatial experience on Apple Vision Pro.

[Info.plist Gist](https://gist.github.com/NDCSwift/4407f9b0b04660e5beebb26031f0ac90)

## ✅ Why you'd use it

- **Volumetric window** — demonstrates `WindowGroup` with `.windowStyle(.volumetric)` so content renders with real-world depth
- **Gesture composition** — shows how to layer `DragGesture`, `MagnifyGesture`, and `TapGesture` on RealityKit entities with `.targetedToAnyEntity()`
- **Local RealityKit package** — a clean template for managing `.rkassets`, USDZ models, and USDA scenes through a Swift Package
- **SwiftUI-first** — no UIKit bridging; pure Apple-recommended patterns for visionOS

This is **Part 3** of the visionOS series. Check out the full series:
- [PART 1 — SpatialDemo SwiftUI](https://github.com/NDCSwift/SpatialDemo_SwiftUI) — TabView navigation & local RealityKit package setup
- [PART 2 — visionOS Solar System](https://github.com/NDCSwift/visionos-solar-system) — 3D depth layout, multi-window, and glass ornaments

## 📺 Watch on YouTube

> Part of the [NoahDoesCoding YouTube channel](https://www.youtube.com/@NoahDoesCoding97) — follow along for more visionOS, SwiftUI, and RealityKit tutorials.

---

## ✨ Features

- Loads an Earth USDZ model from a local `RealityKitContent` Swift Package
- **Drag** anywhere on the globe to rotate it freely around the X and Y axes
- **Pinch** to scale the globe between ~2× and ~30×, clamped to sane bounds
- **Double-tap** to reset orientation and scale with an animated transition
- Uses `InputTargetComponent` + generated collision shapes for gesture hit-testing
- Hover highlight effect for clear interactive affordance

---

## 🚀 Getting Started

### 1. Clone the repo

```
git clone https://github.com/NDCSwift/GlobeView.git
cd GlobeView
```

### 2. Open in Xcode

```
open GlobeView.xcodeproj
```

> Requires **Xcode 16+** with the visionOS SDK installed. If prompted, let Xcode resolve the `RealityKitContent` local package automatically.

### 3. Set your Team

In Xcode, select the `GlobeView` target → **Signing & Capabilities** → set your Apple Developer **Team**.

### 4. Set your Bundle ID

Change the Bundle Identifier from the default to something unique to your account (e.g. `com.yourname.GlobeView`).

### 5. Run

Select the **Apple Vision Pro Simulator** (or a physical device) from the scheme menu and hit **Run** (`⌘R`).

---

## 🧱 Project Structure

```
GlobeView/
├── GlobeView/
│   ├── GlobeViewApp.swift      # @main entry point — volumetric WindowGroup
│   ├── ContentView.swift       # RealityView + gestures (drag, pinch, double-tap)
│   ├── Assets.xcassets/        # App icon + accent color
│   └── Info.plist
├── Packages/
│   └── RealityKitContent/      # Local Swift Package for 3D assets
│       ├── Package.swift
│       ├── Sources/RealityKitContent/
│       │   └── RealityKitContent.rkassets/
│       │       ├── Earth.usdz        # The globe model
│       │       ├── Scene.usda        # Root scene composition
│       │       └── Materials/
│       └── Package.realitycomposerpro/   # Reality Composer Pro workspace
└── GlobeView.xcodeproj
```

---

## 🎮 How the gestures work

All gestures target the globe entity via `.targetedToAnyEntity()`, which is why `ContentView` marks the scene with an `InputTargetComponent` and generates collision shapes on load.

| Gesture | Modifier | Effect |
|---|---|---|
| `DragGesture` | `.onChanged` / `.onEnded` | Rotates the globe around Y (yaw) and X (pitch); `onEnded` persists the orientation so the next drag continues from there |
| `MagnifyGesture` | `.onChanged` | Uniformly scales the globe, clamped between 2× and 30× |
| `TapGesture(count: 2)` | `.onEnded` | Animates scale and orientation back to defaults |

State is held in three `@State` properties — `currentScale`, `baseOrientation`, and `globe` — and the `RealityView`'s `update` closure reapplies scale whenever SwiftUI re-renders.

---

## 🛠️ Notes

- The `Packages/RealityKitContent` directory is a **local Swift Package** — Xcode resolves it automatically; no `swift package resolve` needed.
- 3D assets live in `Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets/`. Edit them with **Reality Composer Pro** (included with Xcode).
- To open Reality Composer Pro: in Xcode go to **Xcode → Open Developer Tool → Reality Composer Pro**.
- Reality Composer Pro user-specific files (`*.rcuserdata`) are ignored by git so multiple contributors don't overwrite each other's workspace state.

## 📦 Requirements

| Requirement | Version |
|---|---|
| Xcode | 16+ |
| visionOS SDK | 2.0+ |
| Swift | 6.0+ |
| Apple Vision Pro Simulator | included with Xcode |

> A physical Apple Vision Pro is **not required** — the simulator works for all features in this project.

---

## 📄 License

Provided as-is for educational purposes. Feel free to fork, adapt, and use in your own projects.
