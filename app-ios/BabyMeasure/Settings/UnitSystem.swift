import Foundation
import SwiftUI

/// Unit system for measurements display.
enum UnitSystem: String, CaseIterable, Identifiable {
    case metric
    case imperial

    var id: String { rawValue }

    var displayName: LocalizedStringKey {
        switch self {
        case .metric:
            "公制"
        case .imperial:
            "英制"
        }
    }

    var description: LocalizedStringKey {
        switch self {
        case .metric:
            "厘米, 千克"
        case .imperial:
            "英寸, 磅"
        }
    }
}
