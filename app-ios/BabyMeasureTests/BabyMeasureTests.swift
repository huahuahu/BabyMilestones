//
//  BabyMeasureTests.swift
//  BabyMeasureTests
//
//  Created by tigerguom4 on 2025/9/29.
//

import Testing
import Foundation
@testable import BabyMeasure

@MainActor
struct BabyMeasureTests {
  @Test("Draft model initialization")
  func draftInitialization() throws {
    let child = ChildDraft(id: UUID(), name: "Alice", gender: .female, birthday: .now)
    #expect(child.name == "Alice")
    #expect(child.gender == .female)

    let measurement = MeasurementDraft(id: UUID(), childId: child.id, type: .height, value: 72.4, recordedAt: .now)
    #expect(measurement.type == .height)
    #expect(measurement.value == 72.4)
  }

  @Test("InMemoryStore append & query")
  func storeMutation() throws {
    let store = InMemoryStore()
    let child = ChildDraft(id: UUID(), name: "Bob", gender: .unspecified, birthday: .now)
    store.add(child: child)
    #expect(store.children.count == 1)
    let m1 = MeasurementDraft(id: UUID(), childId: child.id, type: .weight, value: 10.2, recordedAt: .now)
    store.add(record: m1)
    #expect(store.measurements(for: child.id).count == 1)
  }
}
