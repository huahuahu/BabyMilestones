import Foundation

// MeasurementType defined in Domain/DraftModels.swift within same target.

public extension MeasurementType {
  var acceptableRange: ClosedRange<Double>? {
    switch self {
    case .height:
      20 ... 150
    case .weight:
      1 ... 60
    case .headCircumference:
      25 ... 60
    }
  }

  var displayName: String {
    switch self {
    case .height:
      "身高"
    case .weight:
      "体重"
    case .headCircumference:
      "头围"
    }
  }

  var unit: String {
    switch self {
    case .height, .headCircumference:
      "cm"
    case .weight:
      "kg"
    }
  }
}
