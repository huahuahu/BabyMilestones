import SwiftUI

/// Defines the main navigation tabs for the app.
enum AppTab: String, CaseIterable, Identifiable {
    case home
    case growth
    case settings

    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .home: "tab.home"
        case .growth: "tab.growth"
        case .settings: "tab.settings"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "chart.xyaxis.line"
        case .growth: "list.bullet.clipboard"
        case .settings: "gearshape"
        }
    }
}
