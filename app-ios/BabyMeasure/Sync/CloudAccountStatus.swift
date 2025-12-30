import CloudKit
import HStorage
import SwiftUI

/// Observable class for monitoring iCloud account status.
@MainActor
@Observable
final class CloudAccountStatus {
  /// The current iCloud account status.
  private(set) var status: CKAccountStatus = .couldNotDetermine

  /// Whether the iCloud account is available for use.
  var isAvailable: Bool {
    status == .available
  }

  /// Whether a warning should be shown (iCloud unavailable and storage mode is iCloud).
  func shouldShowWarning(for storageMode: StorageMode) -> Bool {
    storageMode == .iCloud && !isAvailable
  }

  /// User-facing message for the current account status.
  var statusMessage: LocalizedStringKey {
    switch status {
    case .available:
      "cloud.status.available"
    case .noAccount:
      "cloud.status.noAccount"
    case .restricted:
      "cloud.status.restricted"
    case .couldNotDetermine:
      "cloud.status.unknown"
    case .temporarilyUnavailable:
      "cloud.status.temporarilyUnavailable"
    @unknown default:
      "cloud.status.unknown"
    }
  }

  // MARK: - Initialization

  init() {
    Task {
      await checkAccountStatus()
    }
  }

  // MARK: - Public Methods

  /// Checks the current iCloud account status.
  func checkAccountStatus() async {
    do {
      let accountStatus = try await CKContainer.default().accountStatus()
      status = accountStatus
    } catch {
      status = .couldNotDetermine
    }
  }
}
