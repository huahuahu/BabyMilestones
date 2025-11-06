//
//  GrowthStoreTests.swift
//  BabyMeasureTests
//
//  Created by Copilot on 2025/11/06.
//

import Testing
import Foundation
@testable import BabyMeasure

@MainActor
struct GrowthStoreTests {
  @Test
  func testAddMeasurement() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let childId = UUID()
    let measurement = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters
    )

    growthStore.addMeasurement(measurement)

    #expect(growthStore.measurements.count == 1)
    #expect(growthStore.measurements.first == measurement)
  }

  @Test
  func testSameDayOverride() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let childId = UUID()
    let calendar = Calendar.current
    let today = Date()
    let todayMorning = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!
    let todayEvening = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: today)!

    let measurement1 = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters,
      measuredAt: todayMorning
    )

    let measurement2 = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 51.0,
      unit: .centimeters,
      measuredAt: todayEvening
    )

    growthStore.addMeasurement(measurement1)
    #expect(growthStore.measurements.count == 1)
    #expect(growthStore.measurements.first?.value == 50.0)

    // Adding second measurement on same day should override
    growthStore.addMeasurement(measurement2)
    #expect(growthStore.measurements.count == 1)
    #expect(growthStore.measurements.first?.value == 51.0)
  }

  @Test
  func testDifferentDayNoOverride() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let childId = UUID()
    let calendar = Calendar.current
    let today = Date()
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

    let measurement1 = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters,
      measuredAt: yesterday
    )

    let measurement2 = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 51.0,
      unit: .centimeters,
      measuredAt: today
    )

    growthStore.addMeasurement(measurement1)
    growthStore.addMeasurement(measurement2)

    #expect(growthStore.measurements.count == 2)
  }

  @Test
  func testDifferentTypeNoOverride() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let childId = UUID()
    let date = Date()

    let measurement1 = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters,
      measuredAt: date
    )

    let measurement2 = GrowthMeasurement(
      childId: childId,
      type: .weight,
      value: 3.5,
      unit: .kilograms,
      measuredAt: date
    )

    growthStore.addMeasurement(measurement1)
    growthStore.addMeasurement(measurement2)

    #expect(growthStore.measurements.count == 2)
  }

  @Test
  func testMeasurementsForChild() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let child1Id = UUID()
    let child2Id = UUID()

    let measurement1 = GrowthMeasurement(
      childId: child1Id,
      type: .height,
      value: 50.0,
      unit: .centimeters
    )

    let measurement2 = GrowthMeasurement(
      childId: child2Id,
      type: .height,
      value: 52.0,
      unit: .centimeters
    )

    growthStore.addMeasurement(measurement1)
    growthStore.addMeasurement(measurement2)

    let child1Measurements = growthStore.measurements(forChildId: child1Id)
    #expect(child1Measurements.count == 1)
    #expect(child1Measurements.first?.childId == child1Id)
  }

  @Test
  func testMeasurementsForChildByType() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let childId = UUID()

    let heightMeasurement = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters
    )

    let weightMeasurement = GrowthMeasurement(
      childId: childId,
      type: .weight,
      value: 3.5,
      unit: .kilograms
    )

    growthStore.addMeasurement(heightMeasurement)
    growthStore.addMeasurement(weightMeasurement)

    let heightMeasurements = growthStore.measurements(forChildId: childId, type: .height)
    #expect(heightMeasurements.count == 1)
    #expect(heightMeasurements.first?.type == .height)
  }

  @Test
  func testLatestMeasurement() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let childId = UUID()
    let calendar = Calendar.current
    let today = Date()
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

    let olderMeasurement = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters,
      measuredAt: yesterday
    )

    let newerMeasurement = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 51.0,
      unit: .centimeters,
      measuredAt: today
    )

    growthStore.addMeasurement(olderMeasurement)
    growthStore.addMeasurement(newerMeasurement)

    let latest = growthStore.latestMeasurement(forChildId: childId, type: .height)
    #expect(latest?.value == 51.0)
  }

  @Test
  func testPersistence() async {
    let mockStore = MockDataStore()
    let growthStore1 = GrowthStore(persistence: mockStore)

    let childId = UUID()
    let measurement = GrowthMeasurement(
      childId: childId,
      type: .weight,
      value: 3.5,
      unit: .kilograms
    )

    growthStore1.addMeasurement(measurement)

    // Create a new store instance with the same persistence
    let growthStore2 = GrowthStore(persistence: mockStore)

    #expect(growthStore2.measurements.count == 1)
    #expect(growthStore2.measurements.first == measurement)
  }

  @Test
  func testDeleteMeasurement() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let childId = UUID()
    let measurement = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters
    )

    growthStore.addMeasurement(measurement)
    #expect(growthStore.measurements.count == 1)

    growthStore.deleteMeasurement(measurement)
    #expect(growthStore.measurements.isEmpty)
  }

  @Test
  func testUpdateMeasurement() async {
    let mockStore = MockDataStore()
    let growthStore = GrowthStore(persistence: mockStore)

    let childId = UUID()
    var measurement = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters
    )

    growthStore.addMeasurement(measurement)

    measurement.value = 51.0
    growthStore.updateMeasurement(measurement)

    #expect(growthStore.measurements.first?.value == 51.0)
  }
}
