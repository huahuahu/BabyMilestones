import HStorage
import SwiftData
import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChildEntity.createdAt) private var children: [ChildEntity]
    @State private var selectedChildState = SelectedChildState()
    @State private var appPreferences = AppPreferences()
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.home.title, systemImage: AppTab.home.systemImage, value: .home) {
                HomeTab()
            }

            Tab(AppTab.growth.title, systemImage: AppTab.growth.systemImage, value: .growth) {
                GrowthTab()
            }

            Tab(AppTab.settings.title, systemImage: AppTab.settings.systemImage, value: .settings) {
                SettingsTab()
            }
        }
        .environment(selectedChildState)
        .environment(appPreferences)
        .environment(\.locale, appPreferences.language.locale)
        .preferredColorScheme(appPreferences.theme.colorScheme)
        .onAppear { initializeSelection() }
        .onChange(of: children) { initializeSelection() }
    }

    private func initializeSelection() {
        if selectedChildState.current == nil {
            selectedChildState.current = children.first
        }
    }
}

#Preview("RootView", traits: .modifier(SampleData())) {
    RootView()
        .environment(AppPreferences())
}
