//
//  GrowthMeasurement.swift
//  BabyMeasure
//
//  Created by Copilot on 2025/11/06.
//

import Foundation

struct GrowthMeasurement: Identifiable, Codable, Equatable {
  let id: UUID
  let childId: UUID
  var type: MeasurementType
  var value: Double
  var unit: MeasurementUnit
  var measuredAt: Date
  var createdAt: Date
  var updatedAt: Date
  var notes: String?

  enum MeasurementType: String, Codable, CaseIterable {
    case height
    case weight
    case headCircumference

    var displayName: String {
      switch self {
      case .height: return "Height"
      case .weight: return "Weight"
      case .headCircumference: return "Head Circumference"
      }
    }
  }

  enum MeasurementUnit: String, Codable {
    case centimeters
    case inches
    case kilograms
    case pounds
    case grams

    var symbol: String {
      switch self {
      case .centimeters: return "cm"
      case .inches: return "in"
      case .kilograms: return "kg"
      case .pounds: return "lb"
      case .grams: return "g"
      }
    }
  }

  init(
    id: UUID = UUID(),
    childId: UUID,
    type: MeasurementType,
    value: Double,
    unit: MeasurementUnit,
    measuredAt: Date = Date(),
    createdAt: Date = Date(),
    updatedAt: Date = Date(),
    notes: String? = nil
  ) {
    self.id = id
    self.childId = childId
    self.type = type
    self.value = value
    self.unit = unit
    self.measuredAt = measuredAt
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.notes = notes
  }

  /// Validate measurement value is within reasonable ranges
  func isValid() -> Bool {
    switch type {
    case .height:
      return validateHeight()
    case .weight:
      return validateWeight()
    case .headCircumference:
      return validateHeadCircumference()
    }
  }

  private func validateHeight() -> Bool {
    switch unit {
    case .centimeters:
      return value >= 30 && value <= 150  // 30cm to 150cm (newborn to ~10 years)
    case .inches:
      return value >= 12 && value <= 60  // 12in to 60in
    case .kilograms, .pounds, .grams:
      return false  // Invalid units for height
    }
  }

  private func validateWeight() -> Bool {
    switch unit {
    case .kilograms:
      return value >= 1 && value <= 100  // 1kg to 100kg
    case .pounds:
      return value >= 2 && value <= 220  // 2lb to 220lb
    case .grams:
      return value >= 1000 && value <= 100000  // 1000g to 100000g
    case .centimeters, .inches:
      return false  // Invalid units for weight
    }
  }

  private func validateHeadCircumference() -> Bool {
    switch unit {
    case .centimeters:
      return value >= 25 && value <= 65  // 25cm to 65cm
    case .inches:
      return value >= 10 && value <= 26  // 10in to 26in
    case .kilograms, .pounds, .grams:
      return false  // Invalid units for head circumference
    }
  }

  /// Check if this measurement is on the same day as another measurement
  func isSameDay(as other: GrowthMeasurement) -> Bool {
    let calendar = Calendar.current
    return calendar.isDate(measuredAt, inSameDayAs: other.measuredAt)
      && type == other.type
      && childId == other.childId
  }
}
