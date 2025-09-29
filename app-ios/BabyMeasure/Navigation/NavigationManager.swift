//
//  NavigationManager.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI
import Observation

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
    navigationPaths[.milestones]?.append(NavigationDestination.milestoneDetail(milestone))
  }
  
  func navigateToAddMemory(for milestone: Milestone? = nil) {
    selectedTab = .memories
    navigationPaths[.memories]?.append(NavigationDestination.addMemory(linkedMilestone: milestone))
  }
  
  func navigateToAddMilestone(category: MilestoneCategory? = nil) {
    selectedTab = .milestones
    navigationPaths[.milestones]?.append(NavigationDestination.addMilestone(category: category))
  }
  
  func navigateToAddGrowth(type: GrowthType = .height) {
    selectedTab = .growth
    navigationPaths[.growth]?.append(NavigationDestination.addMeasurement(type))
  }
}
