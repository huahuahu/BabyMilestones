//
//  MainTabView.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI

struct MainTabView: View {
  @Environment(NavigationManager.self) private var navigation
  
  var body: some View {
    TabView(selection: Binding(
      get: { navigation.selectedTab },
      set: { navigation.selectedTab = $0 }
    )) {
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
    default:
      Text("Coming Soon")
        .navigationTitle("Under Development")
    }
  }
}

#Preview {
  MainTabView()
    .environment(NavigationManager())
    .environment(DataManager())
}
