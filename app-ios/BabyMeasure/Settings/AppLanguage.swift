import Foundation

/// Supported app languages.
enum AppLanguage: String, CaseIterable, Identifiable {
  case system
  case chinese
  case english

  var id: String { rawValue }

  var displayName: String {
    switch self {
    case .system:
      String(localized: "跟随系统")
    case .chinese:
      "中文"
    case .english:
      "English"
    }
  }

  var languageCode: String? {
    switch self {
    case .system:
      nil
    case .chinese:
      "zh-Hans"
    case .english:
      "en"
    }
  }
}
