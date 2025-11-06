//
//  MeasurementDraft.swift
//  BabyMeasure
//
//  Phase 00: Foundation - Draft model for measurement records
//  Will be migrated to SwiftData in Phase 01
//  Internal units: height cm, weight kg, head circumference cm
//

import Foundation

struct MeasurementDraft: Identifiable, Codable {
  let id: UUID
  var childId: UUID
  var type: MeasurementType
  var value: Double // Unified internal units: height cm, weight kg, headCircumference cm
  var recordedAt: Date

  init(
    id: UUID = UUID(),
    childId: UUID,
    type: MeasurementType,
    value: Double,
    recordedAt: Date
  ) {
    self.id = id
    self.childId = childId
    self.type = type
    self.value = value
    self.recordedAt = recordedAt
  }
}
