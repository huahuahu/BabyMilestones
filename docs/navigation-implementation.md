# Navigation Implementation Examples

## Core Navigation Models

### App Navigation State

```swift
enum AppTab: String, CaseIterable {
    case home = "house.fill"
    case milestones = "list.clipboard.fill"
    case growth = "chart.line.uptrend.xyaxis"
    case memories = "photo.fill"
    case settings = "gear"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .milestones: return "Milestones"
        case .growth: return "Growth"
        case .memories: return "Memories"
        case .settings: return "Settings"
        }
    }
}

@Observable
class NavigationManager {
    var selectedTab: AppTab = .home
    var navigationPaths: [AppTab: NavigationPath] = [:]
    
    init() {
        // Initialize navigation paths for each tab
        for tab in AppTab.allCases {
            navigationPaths[tab] = NavigationPath()
        }
    }
    
    func path(for tab: AppTab) -> Binding<NavigationPath> {
        Binding(
            get: { self.navigationPaths[tab] ?? NavigationPath() },
            set: { self.navigationPaths[tab] = $0 }
        )
    }
    
    func popToRoot(for tab: AppTab) {
        navigationPaths[tab] = NavigationPath()
    }
    
    func navigateToMilestone(_ milestone: Milestone) {
        selectedTab = .milestones
        navigationPaths[.milestones]?.append(milestone)
    }
}
```

### Navigation Destinations

```swift
enum NavigationDestination: Hashable {
    // Home destinations
    case childProfile(Child)
    case addChild
    case quickMilestone
    
    // Milestone destinations
    case milestoneCategory(MilestoneCategory)
    case milestoneDetail(Milestone)
    case addMilestone(category: MilestoneCategory?)
    case editMilestone(Milestone)
    
    // Growth destinations
    case growthChart(GrowthType)
    case addMeasurement(GrowthType)
    case measurementDetail(GrowthMeasurement)
    
    // Memory destinations
    case memoryDetail(Memory)
    case addMemory(linkedMilestone: Milestone?)
    case album(Album)
    case photoDetail(Photo)
    
    // Settings destinations
    case childSettings(Child)
    case notifications
    case dataPrivacy
    case appPreferences
    case help
}
```

## Root App Structure

```swift
struct BabyMeasureApp: App {
    @State private var navigationManager = NavigationManager()
    @State private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(navigationManager)
                .environment(dataManager)
        }
    }
}

struct RootView: View {
    @Environment(NavigationManager.self) private var navigation
    @Environment(DataManager.self) private var dataManager
    @State private var showingOnboarding = false
    
    var body: some View {
        Group {
            if dataManager.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            dataManager.checkOnboardingStatus()
        }
    }
}
```

## Tab-Based Navigation

```swift
struct MainTabView: View {
    @Environment(NavigationManager.self) private var navigation
    
    var body: some View {
        TabView(selection: $navigation.selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                NavigationStack(path: navigation.path(for: tab)) {
                    destinationView(for: tab)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            destinationView(for: destination)
                        }
                }
                .tabItem {
                    Image(systemName: tab.rawValue)
                    Text(tab.title)
                }
                .tag(tab)
            }
        }
        .tabBarMinimizeBehavior(.automatic) // iOS 26 feature
    }
    
    @ViewBuilder
    private func destinationView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeView()
        case .milestones:
            MilestonesView()
        case .growth:
            GrowthView()
        case .memories:
            MemoriesView()
        case .settings:
            SettingsView()
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        switch destination {
        case .childProfile(let child):
            ChildProfileView(child: child)
        case .addChild:
            AddChildView()
        case .milestoneDetail(let milestone):
            MilestoneDetailView(milestone: milestone)
        case .addMilestone(let category):
            AddMilestoneView(category: category)
        // ... other destinations
        default:
            EmptyView()
        }
    }
}
```

## Individual Tab Navigation

### Home Tab Navigation

```swift
struct HomeView: View {
    @Environment(NavigationManager.self) private var navigation
    @Environment(DataManager.self) private var dataManager
    @State private var recentMilestones: [Milestone] = []
    @State private var upcomingMilestones: [Milestone] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Child Profile Card
                if let currentChild = dataManager.currentChild {
                    ChildProfileCard(child: currentChild)
                        .onTapGesture {
                            navigation.navigationPaths[.home]?.append(
                                NavigationDestination.childProfile(currentChild)
                            )
                        }
                }
                
                // Quick Actions
                QuickActionsSection()
                
                // Recent Milestones
                RecentMilestonesSection(milestones: recentMilestones)
                
                // Upcoming Milestones Preview
                UpcomingMilestonesSection(milestones: upcomingMilestones)
            }
            .padding()
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await loadHomeData()
        }
    }
    
    private func loadHomeData() async {
        // Load recent and upcoming milestones
    }
}

struct QuickActionsSection: View {
    @Environment(NavigationManager.self) private var navigation
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Quick Actions")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "Add Milestone",
                    action: {
                        navigation.navigationPaths[.milestones]?.append(
                            NavigationDestination.addMilestone(category: nil)
                        )
                        navigation.selectedTab = .milestones
                    }
                )
                
                QuickActionButton(
                    icon: "ruler.fill",
                    title: "Record Growth",
                    action: {
                        navigation.navigationPaths[.growth]?.append(
                            NavigationDestination.addMeasurement(.height)
                        )
                        navigation.selectedTab = .growth
                    }
                )
                
                QuickActionButton(
                    icon: "camera.fill",
                    title: "Capture Memory",
                    action: {
                        navigation.navigationPaths[.memories]?.append(
                            NavigationDestination.addMemory(linkedMilestone: nil)
                        )
                        navigation.selectedTab = .memories
                    }
                )
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.glass) // iOS 26 Liquid Glass effect
    }
}
```

### Milestones Tab Navigation

```swift
struct MilestonesView: View {
    @Environment(NavigationManager.self) private var navigation
    @State private var milestoneCategories: [MilestoneCategory] = []
    @State private var searchText = ""
    @State private var selectedFilter: MilestoneFilter = .all
    
    var body: some View {
        List {
            ForEach(filteredCategories) { category in
                NavigationLink(value: NavigationDestination.milestoneCategory(category)) {
                    MilestoneCategoryRow(category: category)
                }
            }
        }
        .navigationTitle("Milestones")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .searchSuggestions {
            ForEach(searchSuggestions, id: \.self) { suggestion in
                Text(suggestion)
                    .searchCompletion(suggestion)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(MilestoneFilter.allCases, id: \.self) { filter in
                            Text(filter.title).tag(filter)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .buttonStyle(.glass)
                }
                
                Button {
                    navigation.navigationPaths[.milestones]?.append(
                        NavigationDestination.addMilestone(category: nil)
                    )
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.glass)
            }
        }
        .task {
            await loadMilestoneCategories()
        }
    }
    
    private var filteredCategories: [MilestoneCategory] {
        // Filter logic based on searchText and selectedFilter
        milestoneCategories.filter { category in
            // Implementation
            true
        }
    }
    
    private var searchSuggestions: [String] {
        // Return search suggestions based on current input
        []
    }
    
    private func loadMilestoneCategories() async {
        // Load milestone categories
    }
}
```

## Deep Navigation Handling

### Milestone Detail with Navigation Context

```swift
struct MilestoneDetailView: View {
    let milestone: Milestone
    @Environment(NavigationManager.self) private var navigation
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingAddMemory = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                MilestoneHeader(milestone: milestone)
                MilestoneDescription(milestone: milestone)
                MilestoneProgress(milestone: milestone)
                RelatedMemories(milestone: milestone)
            }
            .padding()
        }
        .navigationTitle(milestone.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showingAddMemory = true
                } label: {
                    Image(systemName: "camera.fill")
                }
                
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                EditMilestoneView(milestone: milestone)
            }
        }
        .sheet(isPresented: $showingAddMemory) {
            NavigationView {
                AddMemoryView(linkedMilestone: milestone)
            }
        }
    }
}
```

## Modal Navigation Patterns

### Onboarding Flow

```swift
struct OnboardingView: View {
    @Environment(DataManager.self) private var dataManager
    @State private var currentStep = 0
    @State private var navigationPath = NavigationPath()
    
    private let onboardingSteps: [OnboardingStep] = [
        .welcome,
        .addFirstChild,
        .setupNotifications,
        .privacySettings,
        .complete
    ]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            onboardingStepView(onboardingSteps[currentStep])
                .navigationDestination(for: OnboardingStep.self) { step in
                    onboardingStepView(step)
                }
        }
    }
    
    @ViewBuilder
    private func onboardingStepView(_ step: OnboardingStep) -> some View {
        switch step {
        case .welcome:
            WelcomeView {
                navigateToNext()
            }
        case .addFirstChild:
            AddFirstChildView { child in
                dataManager.setCurrentChild(child)
                navigateToNext()
            }
        case .setupNotifications:
            NotificationSetupView {
                navigateToNext()
            }
        case .privacySettings:
            PrivacySettingsView {
                navigateToNext()
            }
        case .complete:
            OnboardingCompleteView {
                dataManager.completeOnboarding()
            }
        }
    }
    
    private func navigateToNext() {
        if currentStep < onboardingSteps.count - 1 {
            currentStep += 1
            navigationPath.append(onboardingSteps[currentStep])
        }
    }
}
```

This implementation provides:

1. **Type-safe navigation** using enums and NavigationPath
2. **State preservation** across tab switches
3. **Programmatic navigation** for cross-tab actions
4. **Modern SwiftUI patterns** following iOS 26 guidelines
5. **Flexible architecture** that can accommodate future features
6. **Accessibility support** through proper navigation structure
7. **Performance optimization** with lazy loading and efficient state management

The navigation system is designed to be scalable and maintainable while providing an excellent user experience for tracking baby milestones.