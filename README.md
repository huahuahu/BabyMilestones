# BabyMilestones

An iOS app to record and track children’s growth and development milestones.

## Tech Stack (Phase 00)
- Swift 6 / Swift Concurrency (async/await)
- SwiftUI (iOS 26 SDK) – native state via `@State`, `@Observable`, `@Environment`
- Draft domain models (`ChildDraft`, `MeasurementDraft`) in-memory only (will migrate to SwiftData in Phase 01)
- Formatting: SwiftFormat (`.swiftformat` config, 2-space indent) + SwiftLint (scripts package managed)
- Dev scripts: SwiftPM utility targets in `scripts/` (e.g. `Env`, `Lint` commands)
- Minimum Deployment: iOS 26.0

## Phase Roadmap
See `docs/phases-index.md` for the full progression. Early highlights:
1. Foundation & Architecture (current) – establish structure & draft models
2. Local Storage – introduce SwiftData persistence layer
3. Record Entry UI – create measurement entry workflows
4. Growth Standards – integrate WHO/CDC percentile logic
5. Growth Charts – visualization components
...

## Domain Draft (Phase 00)
Models are intentionally simple and live in `app-ios/BabyMeasure/Domain/`:
```swift
struct ChildDraft: Identifiable { /* id, name, gender?, birthday */ }
struct MeasurementDraft: Identifiable { /* id, childId, type, value, recordedAt */ }
```
Store prototype:
```swift
@Observable class InMemoryStore { var children: [ChildDraft]; var records: [MeasurementDraft] }
```
These will be replaced by SwiftData entities with minimal API churn.

## Running Dev Scripts
Build utility scripts:
```sh
swift build --package-path scripts
```
Lint (check only):
```sh
swift run --package-path scripts DevTools lint
```
Environment info:
```sh
swift run --package-path scripts DevTools env
```

## Goals of Phase 00
✅ App launches with injected in-memory store
✅ Draft domain models compile & are previewable
✅ Formatting & lint scripts wired
✅ README documents tech & roadmap

## Next Steps
- Implement persistence (Phase 01)
- Add measurement entry & validation (Phase 02)
- Introduce feature flags for experimental UI (optional)

---
Created with the assistance of AI coding workflows; architectural decisions documented in `docs/`.
