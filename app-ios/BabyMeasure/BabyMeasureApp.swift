//
//  BabyMeasureApp.swift
//  BabyMeasure
//
//  Created by tigerguom4 on 2025/9/29.
//

import SwiftUI

@main
struct BabyMeasureApp: App {
  // Phase 00: inject in-memory draft store for domain prototypes.
  @State private var store = InMemoryStore()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(store) // SwiftUI native environment injection (@Observable)
    }
  }
}
