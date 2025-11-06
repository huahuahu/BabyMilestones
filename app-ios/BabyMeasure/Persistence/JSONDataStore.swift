//
//  JSONDataStore.swift
//  BabyMeasure
//
//  Created by Copilot on 2025/11/06.
//

import Foundation

/// JSON-based implementation of DataPersisting protocol
class JSONDataStore: DataPersisting {
  private let fileManager = FileManager.default
  private let documentsDirectory: URL

  enum PersistenceError: Error, LocalizedError {
    case encodingFailed
    case decodingFailed
    case fileNotFound
    case writeFailed
    case deleteFailed

    var errorDescription: String? {
      switch self {
      case .encodingFailed:
        return "Failed to encode data"
      case .decodingFailed:
        return "Failed to decode data"
      case .fileNotFound:
        return "File not found"
      case .writeFailed:
        return "Failed to write data to file"
      case .deleteFailed:
        return "Failed to delete file"
      }
    }
  }

  init() {
    // Get the documents directory
    if let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
      documentsDirectory = documentsPath
    } else {
      // Fallback to temporary directory if documents directory is not available
      documentsDirectory = fileManager.temporaryDirectory
    }
  }

  private func fileURL(forKey key: String) -> URL {
    documentsDirectory.appendingPathComponent("\(key).json")
  }

  func save<T: Codable>(_ data: T, forKey key: String) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    encoder.dateEncodingStrategy = .iso8601

    guard let encoded = try? encoder.encode(data) else {
      throw PersistenceError.encodingFailed
    }

    let fileURL = fileURL(forKey: key)

    do {
      try encoded.write(to: fileURL, options: [.atomic, .completeFileProtection])
    } catch {
      throw PersistenceError.writeFailed
    }
  }

  func load<T: Codable>(forKey key: String) throws -> T? {
    let fileURL = fileURL(forKey: key)

    guard fileManager.fileExists(atPath: fileURL.path) else {
      return nil
    }

    guard let data = try? Data(contentsOf: fileURL) else {
      throw PersistenceError.fileNotFound
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    guard let decoded = try? decoder.decode(T.self, from: data) else {
      throw PersistenceError.decodingFailed
    }

    return decoded
  }

  func delete(forKey key: String) throws {
    let fileURL = fileURL(forKey: key)

    guard fileManager.fileExists(atPath: fileURL.path) else {
      return  // Nothing to delete
    }

    do {
      try fileManager.removeItem(at: fileURL)
    } catch {
      throw PersistenceError.deleteFailed
    }
  }

  func exists(forKey key: String) -> Bool {
    let fileURL = fileURL(forKey: key)
    return fileManager.fileExists(atPath: fileURL.path)
  }
}
