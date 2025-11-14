//
//  BabyMeasureApp.swift
//  BabyMeasure
//
//  Created by tigerguom4 on 2025/9/29.
//

import SwiftData
import SwiftUI

@main
struct BabyMeasureApp: App {
  var body: some Scene {
    WindowGroup {
      RootView()
        .modelContainer(HContainer.localContainer)
    }
  }
}
