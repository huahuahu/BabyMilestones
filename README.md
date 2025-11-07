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

## Git Hooks (Auto Lint Before Commit & Push)

This repo uses optional local Git hooks to keep formatting clean:

1. `pre-commit`: Runs `hScript lint --fix`, stages any auto-fix changes, then runs a final `hScript lint` check. Commit is blocked if lint fails.
2. `pre-push`: Runs the same auto-fix sequence. If fixes produce new unstaged changes, it stages them and aborts the push so you can create (or amend) a commit including those changes. Then a final lint check must pass to proceed.

Why abort after staging on push? Git determines objects to send before `pre-push` runs—new commits created inside the hook wouldn’t be included. Aborting lets you commit the staged formatting changes and re-push.

### Enable Hooks
```sh
git config core.hooksPath .githooks
```

### Manual Lint Commands
```sh
./scripts/.build/debug/hScript lint        # check
./scripts/.build/debug/hScript lint --fix  # fix then verify
```

If the binary is missing, build tools first:
```sh
swift build --package-path scripts
```

### Typical Workflow
```sh
git add .
git commit -m "feat: add measurement form"
git push            # pre-push may stage formatting -> abort -> amend
git commit --amend --no-edit   # if formatting staged
git push
```

To disable hooks temporarily:
```sh
git config --unset core.hooksPath
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
