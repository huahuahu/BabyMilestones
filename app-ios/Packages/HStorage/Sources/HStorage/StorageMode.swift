import Foundation

/// Defines the storage mode for the app's data persistence.
/// Used in debug settings to switch between different storage backends.
public enum StorageMode: String, CaseIterable, Identifiable, Sendable {
  /// iCloud sync via CloudKit - data syncs across devices.
  case iCloud

  /// Local persistent storage - data stored on device only.
  case local

  /// In-memory storage - data is lost when app terminates.
  /// Useful for testing and previews.
  case memory

  public var id: String { rawValue }

  public var displayName: String {
    switch self {
    case .iCloud:
      "iCloud"
    case .local:
      "Local"
    case .memory:
      "Memory"
    }
  }

  public var description: String {
    switch self {
    case .iCloud:
      "Syncs data across devices via iCloud"
    case .local:
      "Stores data locally on device only"
    case .memory:
      "In-memory only, data lost on app restart"
    }
  }
}
