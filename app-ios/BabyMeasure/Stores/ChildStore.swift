//
//  ChildStore.swift
//  BabyMeasure
//
//  Created by Copilot on 2025/11/06.
//

import Foundation
import SwiftUI

@MainActor
class ChildStore: ObservableObject {
  @Published var children: [Child] = []
  private let persistence: DataPersisting
  private let storageKey = "children"

  init(persistence: DataPersisting = JSONDataStore()) {
    self.persistence = persistence
    loadChildren()
  }

  /// Load children from persistent storage
  func loadChildren() {
    do {
      if let loadedChildren: [Child] = try persistence.load(forKey: storageKey) {
        children = loadedChildren
      }
    } catch {
      print("Failed to load children: \(error.localizedDescription)")
      children = []
    }
  }

  /// Save children to persistent storage
  private func saveChildren() {
    do {
      try persistence.save(children, forKey: storageKey)
    } catch {
      print("Failed to save children: \(error.localizedDescription)")
    }
  }

  /// Add a new child
  func addChild(_ child: Child) {
    children.append(child)
    saveChildren()
  }

  /// Update an existing child
  func updateChild(_ child: Child) {
    if let index = children.firstIndex(where: { $0.id == child.id }) {
      var updatedChild = child
      updatedChild.updatedAt = Date()
      children[index] = updatedChild
      saveChildren()
    }
  }

  /// Delete a child
  func deleteChild(_ child: Child) {
    children.removeAll { $0.id == child.id }
    saveChildren()
  }

  /// Get a child by ID
  func child(withId id: UUID) -> Child? {
    children.first { $0.id == id }
  }

  /// Check if any children exist
  var hasChildren: Bool {
    !children.isEmpty
  }
}
