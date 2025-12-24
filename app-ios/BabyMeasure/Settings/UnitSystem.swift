import Foundation

/// Unit system for measurements display.
enum UnitSystem: String, CaseIterable, Identifiable {
  case metric
  case imperial

  var id: String { rawValue }

  var displayName: String {
    switch self {
    case .metric:
      String(localized: "公制")
    case .imperial:
      String(localized: "英制")
    }
  }

  var description: String {
    switch self {
    case .metric:
      String(localized: "厘米, 千克")
    case .imperial:
      String(localized: "英寸, 磅")
    }
  }
}
