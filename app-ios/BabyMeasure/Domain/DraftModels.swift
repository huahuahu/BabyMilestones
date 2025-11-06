// Phase 00 Domain Draft Models
// These lightweight structs/classes intentionally avoid persistence.
// They will migrate to SwiftData-backed models in Phase 01 while preserving API shape.

import Foundation
import SwiftUI

// MARK: - Core Draft Models

struct ChildDraft: Identifiable, Hashable {
  let id: UUID
  var name: String
  var gender: Gender?
  var birthday: Date
}

enum Gender: String, CaseIterable, Codable { case male, female, unspecified }

enum MeasurementType: String, CaseIterable, Codable { case height, weight, headCircumference }

struct MeasurementDraft: Identifiable, Hashable {
  let id: UUID
  var childId: UUID
  var type: MeasurementType
  var value: Double // Internal unit: height cm, weight kg, head circumference cm
  var recordedAt: Date
}

// MARK: - In-Memory Store Prototype

@Observable
class InMemoryStore {
  // Phase 00: mutable arrays for prototyping; no persistence.
  var children: [ChildDraft] = []
  var records: [MeasurementDraft] = []

  // Basic mutation APIs (will align with persistence layer in future phases)
  func add(child: ChildDraft) { children.append(child) }
  func add(record: MeasurementDraft) { records.append(record) }

  func measurements(for childId: UUID) -> [MeasurementDraft] {
    records.filter { $0.childId == childId }.sorted { $0.recordedAt < $1.recordedAt }
  }
}

// MARK: - Sample / Preview Helpers

extension InMemoryStore {
  static func preview(seed count: Int = 1) -> InMemoryStore {
    let store = InMemoryStore()
    for index in 0 ..< count {
      let child = ChildDraft(
      id: UUID(),
      name: "Child #\(index + 1)",
      gender: .unspecified,
      birthday: .now.addingTimeInterval(-Double.random(in: 60 * 60 * 24 * 30 ... 60 * 60 * 24 * 400))
      )
      store.add(child: child)
      let measurements = (0 ..< Int.random(in: 1 ... 4)).map { _ in
      MeasurementDraft(
        id: UUID(),
        childId: child.id,
        type: [.height, .weight, .headCircumference].randomElement()!,
        value: Double.random(in: 30 ... 90),
        recordedAt: Date().addingTimeInterval(-Double.random(in: 0 ... 60 * 60 * 24 * 200))
      )
      }
      measurements.forEach { store.add(record: $0) }
    }
    return store
  }
}
