# BabyMilestones
An iOS app to record and track children's growth and development milestones.

## Tech Stack
- **Platform**: iOS 26.0+
- **Language**: Swift 6.0
- **UI Framework**: SwiftUI (native state management)
- **State Management**: @State, @Observable, @Environment (no MVVM abstraction)
- **Data Persistence**: SwiftData (planned for Phase 01)
- **Architecture**: Modern SwiftUI with async/await
- **Code Style**: SwiftFormat with 2-space indentation

## Development Approach
This project follows a phased development approach with clear milestones and incremental delivery. See the [Phase Roadmap](docs/phases-index.md) for the complete development plan.

### Phase Overview
- **Phase 00**: Foundation & Architecture (current) - Basic structure and draft models
- **Phase 01**: Local Storage - SwiftData integration
- **Phase 02**: Record Entry UI - Basic data input and viewing
- **Phase 03**: Growth Standards - WHO/CDC standards parsing
- **Phase 04**: Growth Charts - Visualization and percentile tracking
- **Phase 05**: Multi-Child Management - Support for multiple children
- **Phase 06**: iCloud Sync - Cloud synchronization
- **Phase 07**: Export & Sharing - Data portability
- **Phase 08**: Enhanced Experience - iOS 26 features and localization
- **Phase 09**: Security & Privacy - Data protection
- **Phase 10**: Community & Extensions - Contribution guidelines
- **Phase 11**: Release & CI - Automated testing and deployment

## Project Structure
```
app-ios/BabyMeasure/
├── Domain/              # Core data models (Phase 00 draft models)
├── BabyMeasureApp.swift # App entry point
└── ContentView.swift    # Root view

docs/                    # Phase documentation and technical designs
scripts/                 # Development tools and automation
resource/                # Growth standards data (WHO/CDC)
```

## Development Tools
- **Lint & Format**: 
  - Run `./scripts/format.sh` to check formatting (macOS only)
  - Run `./scripts/format.sh --fix` to auto-fix formatting issues
  - Alternative: `cd scripts && swift run hScript lint --fix` (requires build setup)
- **Environment Info**: Run `cd scripts && swift run hScript env` to display development environment details

## Getting Started
1. Open `app-ios/BabyMeasure.xcodeproj` in Xcode 26.0+
2. Select iPhone 17 Pro simulator
3. Build and run (⌘+R)

## Documentation
- [Phase Roadmap](docs/phases-index.md) - Complete development phases
- [Phase 00: Foundation](docs/phase-00-foundation.md) - Current phase details
- [Growth Standards Reference](resource/prc-wst-423-2022.pdf) - WHO/CDC data source
