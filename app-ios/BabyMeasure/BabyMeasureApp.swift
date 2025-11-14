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
  // Phase 00: inject in-memory draft store for domain prototypes.
  // Replace Phase 00 in-memory store with SwiftData container + stores injection
  static var modelContainer: ModelContainer = {
    // For now, persistent on-disk default configuration; can toggle memory-only for tests.
    let schema = Schema([ChildEntity.self, MeasurementEntity.self])
    return try! ModelContainer(for: schema)
  }()

  @State
  private var childStore = ChildStore(context: ModelContext(BabyMeasureApp.modelContainer))
  @State
  private var measurementStore = MeasurementStore(context: ModelContext(BabyMeasureApp.modelContainer))

  //  init() {
  //    let context = ModelContext(modelContainer)
  //    _childStore = State(initialValue: ChildStore(context: context))
  //    _measurementStore = State(initialValue: MeasurementStore(context: context))
  //  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .modelContainer(Self.modelContainer)
        .environment(childStore)
        .environment(measurementStore)
    }
  }
}
