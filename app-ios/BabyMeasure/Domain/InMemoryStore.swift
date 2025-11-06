//
//  InMemoryStore.swift
//  BabyMeasure
//
//  Phase 00: Foundation - In-memory storage for draft models
//  Will be replaced with SwiftData Store in Phase 01
//

import Foundation
import Observation

@Observable
class InMemoryStore {
  var children: [ChildDraft] = []
  var records: [MeasurementDraft] = []

  func add(child: ChildDraft) {
    children.append(child)
  }

  func add(record: MeasurementDraft) {
    records.append(record)
  }
}
