//
//  DataPersisting.swift
//  BabyMeasure
//
//  Created by Copilot on 2025/11/06.
//

import Foundation

/// Protocol for persisting and retrieving data
protocol DataPersisting {
  /// Save data to persistent storage
  /// - Parameters:
  ///   - data: The data to save
  ///   - key: Unique identifier for the data
  /// - Throws: An error if saving fails
  func save<T: Codable>(_ data: T, forKey key: String) throws

  /// Load data from persistent storage
  /// - Parameter key: Unique identifier for the data
  /// - Returns: The loaded data, or nil if not found
  /// - Throws: An error if loading fails
  func load<T: Codable>(forKey key: String) throws -> T?

  /// Delete data from persistent storage
  /// - Parameter key: Unique identifier for the data
  /// - Throws: An error if deletion fails
  func delete(forKey key: String) throws

  /// Check if data exists for a given key
  /// - Parameter key: Unique identifier for the data
  /// - Returns: True if data exists, false otherwise
  func exists(forKey key: String) -> Bool
}
