import SwiftUI

/// App appearance theme.
enum AppTheme: String, CaseIterable, Identifiable {
  case system
  case light
  case dark

  var id: String { rawValue }

  var displayName: String {
    switch self {
    case .system:
      String(localized: "跟随系统")
    case .light:
      String(localized: "浅色")
    case .dark:
      String(localized: "深色")
    }
  }

  var colorScheme: ColorScheme? {
    switch self {
    case .system:
      nil
    case .light:
      .light
    case .dark:
      .dark
    }
  }
}
