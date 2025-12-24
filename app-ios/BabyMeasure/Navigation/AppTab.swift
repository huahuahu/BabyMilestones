import SwiftUI

/// Defines the main navigation tabs for the app.
enum AppTab: String, CaseIterable, Identifiable {
  case home
  case growth
  case settings

  var id: String { rawValue }

  var title: String {
    switch self {
    case .home: "首页"
    case .growth: "记录"
    case .settings: "设置"
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
