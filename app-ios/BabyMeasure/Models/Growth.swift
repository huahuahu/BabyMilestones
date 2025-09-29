//
//  Growth.swift
//  BabyMeasure
//
//  Created by AI Assistant on 2025/9/29.
//

import Foundation

enum GrowthType: String, CaseIterable, Hashable, Codable {
  case height = "Height"
  case weight = "Weight"
  case headCircumference = "Head Circumference"
  
  var unit: String {
    switch self {
    case .height, .headCircumference:
      return "cm"
    case .weight:
      return "kg"
    }
  }
  
  var icon: String {
    switch self {
    case .height:
      return "ruler"
    case .weight:
      return "scalemass"
    case .headCircumference:
      return "circle.dashed"
    }
  }
}

struct GrowthMeasurement: Identifiable, Hashable, Codable {
  let id: UUID
  var type: GrowthType
  var value: Double
  var date: Date
  var notes: String?
  
  init(type: GrowthType, value: Double, date: Date, notes: String? = nil) {
    self.id = UUID()
    self.type = type
    self.value = value
    self.date = date
    self.notes = notes
  }
}