# BabyMilestones

An iOS app to record and track children's growth and development milestones.

## Features (Phase 1 - MVP)

- 📊 Track multiple children's growth measurements
- 📏 Record height, weight, and head circumference
- 📅 Automatic same-day measurement override
- 💾 Local data persistence (no internet required)
- ✅ Data validation with reasonable ranges
- 🎯 Simple, intuitive interface

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

1. Clone the repository
2. Open `app-ios/BabyMeasure.xcodeproj` in Xcode
3. Build and run on simulator or device

## Project Structure

```
app-ios/
├── BabyMeasure/           # Main app source
│   ├── Models/            # Data models
│   ├── Persistence/       # Data storage layer
│   ├── Stores/            # State management
│   └── Views/             # SwiftUI views
├── BabyMeasureTests/      # Unit tests
└── BabyMeasureUITests/    # UI tests
```

## Documentation

- [Project Development Plan](docs/project-development-plan.md) - Overall project roadmap
- [Phase 1 Implementation Summary](docs/phase1-implementation-summary.md) - Detailed Phase 1 documentation

## Development

### Running Tests

```bash
# Using Xcode
# Product → Test (⌘U)

# Or via xcodebuild
xcodebuild test -project app-ios/BabyMeasure.xcodeproj -scheme BabyMeasure
```

### Code Style

The project uses SwiftLint and SwiftFormat for code consistency:

```bash
cd scripts
swift run hScript lint --fix
```

## Roadmap

- ✅ **Phase 1**: Local data MVP with basic tracking
- 🚧 **Phase 2**: WHO/CDC growth standards & percentiles
- 📅 **Phase 3**: Enhanced UI with charts
- 📅 **Phase 4**: Cloud sync & family sharing

## License

See [LICENSE](LICENSE) file for details.
