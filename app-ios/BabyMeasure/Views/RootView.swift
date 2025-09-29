//
//  RootView.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import SwiftUI

struct RootView: View {
  @Environment(NavigationManager.self) private var navigation
  @Environment(DataManager.self) private var dataManager
  
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

#Preview {
  RootView()
    .environment(NavigationManager())
    .environment(DataManager())
}