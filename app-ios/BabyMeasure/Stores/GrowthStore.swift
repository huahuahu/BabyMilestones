//
//  GrowthStore.swift
//  BabyMeasure
//
//  Created by Copilot on 2025/11/06.
//

import Foundation
import SwiftUI

@MainActor
class GrowthStore: ObservableObject {
  @Published var measurements: [GrowthMeasurement] = []
  private let persistence: DataPersisting
  private let storageKey = "measurements"

  init(persistence: DataPersisting = JSONDataStore()) {
    self.persistence = persistence
    loadMeasurements()
  }

  /// Load measurements from persistent storage
  func loadMeasurements() {
    do {
      if let loadedMeasurements: [GrowthMeasurement] = try persistence.load(forKey: storageKey) {
        measurements = loadedMeasurements
      }
    } catch {
      print("Failed to load measurements: \(error.localizedDescription)")
      measurements = []
    }
  }

  /// Save measurements to persistent storage
  private func saveMeasurements() {
    do {
      try persistence.save(measurements, forKey: storageKey)
    } catch {
      print("Failed to save measurements: \(error.localizedDescription)")
    }
  }

  /// Add a new measurement, with same-day override logic
  func addMeasurement(_ measurement: GrowthMeasurement) {
    // Check if a measurement of the same type for the same child on the same day already exists
    if let existingIndex = measurements.firstIndex(where: { $measurement.isSameDay(as: $0) }) {
      // Override the existing measurement
      var updatedMeasurement = measurement
      updatedMeasurement.updatedAt = Date()
      measurements[existingIndex] = updatedMeasurement
    } else {
      // Add new measurement
      measurements.append(measurement)
    }
    saveMeasurements()
  }

  /// Update an existing measurement
  func updateMeasurement(_ measurement: GrowthMeasurement) {
    if let index = measurements.firstIndex(where: { $0.id == measurement.id }) {
      var updatedMeasurement = measurement
      updatedMeasurement.updatedAt = Date()
      measurements[index] = updatedMeasurement
      saveMeasurements()
    }
  }

  /// Delete a measurement
  func deleteMeasurement(_ measurement: GrowthMeasurement) {
    measurements.removeAll { $0.id == measurement.id }
    saveMeasurements()
  }

  /// Get measurements for a specific child
  func measurements(forChildId childId: UUID) -> [GrowthMeasurement] {
    measurements
      .filter { $0.childId == childId }
      .sorted { $0.measuredAt > $1.measuredAt }
  }

  /// Get measurements for a specific child and type
  func measurements(forChildId childId: UUID, type: GrowthMeasurement.MeasurementType) -> [GrowthMeasurement] {
    measurements
      .filter { $0.childId == childId && $0.type == type }
      .sorted { $0.measuredAt > $1.measuredAt }
  }

  /// Get the latest measurement for a specific child and type
  func latestMeasurement(
    forChildId childId: UUID,
    type: GrowthMeasurement.MeasurementType
  ) -> GrowthMeasurement? {
    measurements(forChildId: childId, type: type).first
  }
}
