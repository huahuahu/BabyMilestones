# BabyMilestones - AI Coding Agent Instructions

## Project Overview
BabyMilestones is an iOS app for recording and tracking children's growth and development milestones. This is currently a greenfield project with no existing codebase - focus on establishing strong iOS development foundations.

## Development Context

### Project Status
- **Early Stage**: No source code exists yet - this is a fresh start
- **Platform**: iOS native app (Swift/SwiftUI expected)
- **Domain**: Child development milestone tracking
- **Resources**: Reference material available in `/resource/prc-wst-423-2022.pdf`

### Existing Tooling
The project has sophisticated AI assistance already configured:
- **Chat Modes**: `.github/chatmodes/` contains specialized prompt templates
- **Push Prompts**: `.github/prompts/` for task definition
- Use these existing tools for planning and validation before coding

## iOS Development Guidelines

### Project Structure Conventions
When creating the iOS project structure:
- Use standard Xcode project layout with clear separation of concerns
- Create logical folder groupings: `Models/`, `Views/`, `ViewModels/`, `Services/`, `Utilities/`
- Implement proper data persistence (Core Data or SwiftData for milestone tracking)

### Coding Standards
- Follow Swift API Design Guidelines
- Use SwiftUI for UI implementation (modern iOS development approach)
- Implement proper error handling with `Result` types
- Use `async/await` for asynchronous operations
- Add comprehensive documentation for public APIs

### Baby Milestone Domain Considerations
- **Data Privacy**: Implement strong privacy protections for child data
- **Offline Support**: Ensure app works without internet connectivity
- **Data Export**: Allow parents to export/backup milestone data
- **Age-Appropriate Tracking**: Consider different developmental stages (0-6 months, 6-12 months, etc.)
- **Visual Progress**: Include photo/video milestone documentation capabilities

### Development Workflow
1. **Planning First**: Use `.github/chatmodes/plan.chatmode.md` for feature planning
2. **Incremental Development**: Build core milestone tracking functionality first
3. **Testing Strategy**: Implement unit tests for business logic, UI tests for user flows
4. **Data Migration**: Plan for schema changes as milestone tracking requirements evolve

### Key Integration Points
- **Core Data/SwiftData**: For persistent milestone storage
- **PhotoKit**: For photo/video milestone documentation
- **HealthKit**: Potential integration for growth metrics (height/weight)
- **CloudKit**: For cross-device synchronization (future consideration)

### Architecture Recommendations
- Implement Repository pattern for data access
- Create dedicated services for milestone calculations and age-based recommendations
- Design modular milestone types (physical, cognitive, social, emotional)

## Common Patterns for This Project

### Milestone Data Modeling
```swift
// Example structure - adapt as needed
struct Milestone {
    let id: UUID
    let type: MilestoneType
    let achievedDate: Date?
    let expectedAgeRange: ClosedRange<TimeInterval>
    let description: String
    let photos: [MilestonePhoto]
}
```

### Age Calculation Utilities
- Implement precise age calculations (months, weeks, days)
- Handle milestone timing variations and developmental ranges
- Consider premature birth adjustments

### Progress Tracking Views
- Visual progress indicators for developmental categories
- Timeline views for milestone achievement history
- Age-appropriate milestone suggestions

## Development Priorities
1. **Core Data Model**: Define milestone types and child profiles
2. **Basic CRUD**: Create, read, update milestone records
3. **Age Calculations**: Accurate developmental age tracking
4. **Simple UI**: Basic milestone viewing and recording
5. **Data Persistence**: Reliable local storage
6. **Photo Integration**: Visual milestone documentation

## Testing Approach
- **Unit Tests**: Milestone calculations, age computations, data validation
- **Integration Tests**: Core Data operations, data migration
- **UI Tests**: Critical user flows (adding milestones, viewing progress)
- **Privacy Testing**: Ensure child data protection compliance

Use the existing sophisticated prompt engineering setup to plan features thoroughly before implementation. The `.github/chatmodes/` tools are specifically designed to help with planning and should be leveraged for any significant feature development.