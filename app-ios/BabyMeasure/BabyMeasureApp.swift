//
//  BabyMeasureApp.swift
//  BabyMeasure
//
//  Created by tigerguom4 on 2025/9/29.
//

import SwiftUI

@main
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
