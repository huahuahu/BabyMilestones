//
//  BabyMeasureTests.swift
//  BabyMeasureTests
//
//  Created by tigerguom4 on 2025/9/29.
//

import Testing
import Foundation
@testable import BabyMeasure

struct BabyMeasureTests {
  @Test
  func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
  }

  @Test
  func testModelsDraftInitialization() async throws {
    // Test ChildDraft initialization
    let child = ChildDraft(
      name: "Test Child",
      gender: .male,
      birthday: Date()
    )
    #expect(child.name == "Test Child")
    #expect(child.gender == .male)
    // Verify ID is a valid UUID (not nil, has valid UUID format)
    #expect(child.id.uuidString.count == 36)

    // Test MeasurementDraft initialization
    let measurement = MeasurementDraft(
      childId: child.id,
      type: .height,
      value: 75.5,
      recordedAt: Date()
    )
    #expect(measurement.childId == child.id)
    #expect(measurement.type == .height)
    #expect(measurement.value == 75.5)

    // Test Gender enum
    #expect(Gender.allCases.count == 3)
    #expect(Gender.allCases.contains(.male))
    #expect(Gender.allCases.contains(.female))
    #expect(Gender.allCases.contains(.unspecified))

    // Test MeasurementType enum
    #expect(MeasurementType.allCases.count == 3)
    #expect(MeasurementType.allCases.contains(.height))
    #expect(MeasurementType.allCases.contains(.weight))
    #expect(MeasurementType.allCases.contains(.headCircumference))

    // Test InMemoryStore
    let store = InMemoryStore()
    #expect(store.children.isEmpty)
    #expect(store.records.isEmpty)

    store.add(child: child)
    #expect(store.children.count == 1)
    #expect(store.children.first?.name == "Test Child")

    store.add(record: measurement)
    #expect(store.records.count == 1)
    #expect(store.records.first?.type == .height)
  }
}
