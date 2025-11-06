//
//  GrowthMeasurementTests.swift
//  BabyMeasureTests
//
//  Created by Copilot on 2025/11/06.
//

import Testing
import Foundation
@testable import BabyMeasure

struct GrowthMeasurementTests {
  @Test
  func testMeasurementCreation() {
    let childId = UUID()
    let measurement = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters
    )

    #expect(measurement.childId == childId)
    #expect(measurement.type == .height)
    #expect(measurement.value == 50.0)
    #expect(measurement.unit == .centimeters)
  }

  @Test
  func testHeightValidation() {
    let childId = UUID()

    // Valid height in cm
    let validHeight = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters
    )
    #expect(validHeight.isValid())

    // Invalid height (too low)
    let tooLow = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 20.0,
      unit: .centimeters
    )
    #expect(!tooLow.isValid())

    // Invalid height (too high)
    let tooHigh = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 200.0,
      unit: .centimeters
    )
    #expect(!tooHigh.isValid())
  }

  @Test
  func testWeightValidation() {
    let childId = UUID()

    // Valid weight in kg
    let validWeight = GrowthMeasurement(
      childId: childId,
      type: .weight,
      value: 3.5,
      unit: .kilograms
    )
    #expect(validWeight.isValid())

    // Invalid weight (too low)
    let tooLow = GrowthMeasurement(
      childId: childId,
      type: .weight,
      value: 0.5,
      unit: .kilograms
    )
    #expect(!tooLow.isValid())
  }

  @Test
  func testHeadCircumferenceValidation() {
    let childId = UUID()

    // Valid head circumference
    let validHead = GrowthMeasurement(
      childId: childId,
      type: .headCircumference,
      value: 35.0,
      unit: .centimeters
    )
    #expect(validHead.isValid())

    // Invalid head circumference
    let invalid = GrowthMeasurement(
      childId: childId,
      type: .headCircumference,
      value: 15.0,
      unit: .centimeters
    )
    #expect(!invalid.isValid())
  }

  @Test
  func testSameDayDetection() {
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

    #expect(measurement1.isSameDay(as: measurement2))
  }

  @Test
  func testDifferentDayDetection() {
    let childId = UUID()
    let calendar = Calendar.current
    let today = Date()
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

    let measurement1 = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 50.0,
      unit: .centimeters,
      measuredAt: today
    )

    let measurement2 = GrowthMeasurement(
      childId: childId,
      type: .height,
      value: 51.0,
      unit: .centimeters,
      measuredAt: yesterday
    )

    #expect(!measurement1.isSameDay(as: measurement2))
  }

  @Test
  func testDifferentTypeNotSameDay() {
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

    #expect(!measurement1.isSameDay(as: measurement2))
  }

  @Test
  func testMeasurementCodable() throws {
    let childId = UUID()
    let measurement = GrowthMeasurement(
      childId: childId,
      type: .weight,
      value: 3.5,
      unit: .kilograms,
      notes: "First measurement"
    )

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let data = try encoder.encode(measurement)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedMeasurement = try decoder.decode(GrowthMeasurement.self, from: data)

    #expect(decodedMeasurement == measurement)
  }
}
